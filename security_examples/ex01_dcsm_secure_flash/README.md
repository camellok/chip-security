# ex01：Flash 算法保护

本例程在 ex00 的基础上，把正弦查表函数和常量表放入 Flash sector4，并将该扇区分配给 Zone1。APP、SCI 和算法运行状态保留在非安全区域。

实验验证以下行为：Zone1 处于安全状态时程序可以独立运行；按键触发密码解锁；断电后重新进入安全状态；下载工具使用错误密码时无法读回真实算法内容，使用正确密码后可以读回。

当前配置保留开发阶段的调试与恢复空间。演示密码以明文存放在 APP 中，PSWDLOCK 等最终锁定字段也未在本例程中启用，不能将其直接用于量产固件。

## 实验准备

先完成 [ex00](../ex00_base_system/README.md)，确认 LED、按键和串口通路正常。硬件连接相同：GPIO31 为 LED，GPIO9 为低有效按键，GPIO28/29 分别为 SCIA RX/TX，串口格式为 9600、8N1。

使用 Haawking IDE 和配套工具链构建，使用昊芯 downloader 完成烧录与回读。现有构建配置使用 Haawking IDE 2.3.17。

编程 OTP 前，先保存目标芯片的初始 OTP，并核对其当前安全状态。OTP 无法擦除，已有的 0 位不能通过写入 1 恢复。特别要检查密码和保留字段中的出厂值，不能假设整个 USER OTP 都是 `0xFFFFFFFF`。

## 内存划分

| 区域 | 地址范围 | 内容与用途 |
| --- | --- | --- |
| 启动入口 | `0x00600000..0x0060000F` | Flash 启动跳转 |
| APP Flash | `0x00600010..0x0060FFFF` | 主程序、驱动、日志字符串及 RAM 初始化镜像 |
| Zone1 算法区 | `0x00610000..0x00613FFF` | sector4，大小 16 KB，保存算法函数和常量表 |
| RAM LS4 至 LS7 | `0x00010000..0x00017FFF` | 可写变量和 RAM 运行函数，配置为非安全 |

`g_sine_table_256` 使用输入段 `algorithm_sine_table`，`spwm_duty_calc()` 使用 `algorithm_funcs`。主链接脚本把这些输入段收集到 `flash_zone1_algo`，放入 `FLASH_ZONE1_ALGO`。

索引 `g_sine_table_idx` 和计算结果 `g_epwm_cmp_value` 位于 RAM。程序会持续修改它们，因此它们不能以 Flash 地址作为可写运行地址。当前程序只更新计算结果变量，未输出实际 PWM 波形。

`ramfuncs` 保留 RAM 运行方式。`.data` 和 `ramfunc` 的 Flash 加载镜像放在普通 APP Flash，使启动代码能够在 Zone1 尚未解锁时完成初始化。检查 map 时，需要同时检查运行地址和 load address。

## OTP 配置与链接关系

`Security/hx28002x_dcsm_z1otp.S`、`hx28002x_dcsm_z2otp.S` 输出配置数据；`haawking-drivers/ldscripts/DCSM.ld` 将各输入段放到指定 USER OTP 地址。主 Flash 链接脚本通过 `INCLUDE "DCSM.ld"` 引入这些布局。

| 输入段 | 当前 OTP 地址 |
| --- | --- |
| `b0_dcsm_otp_z1_linkpointer` | `0x007A0000`，大小 24 字节 |
| `b0_dcsm_zsel_z1` | `0x007A0040`，大小 32 字节 |
| `b0_dcsm_zsel_z2` | `0x007A0440`，大小 32 字节 |

Zone1 的三个 LINKPOINTER 都为 `0x1FFFFFFF`，选择本例程放在 `0x007A0040` 的首个 ZSB。每个 LINKPOINTER 后的保留字占 4 字节，使三个值分别位于 `0x007A0000`、`0x007A0008`、`0x007A0010`。

ZSB 内部按以下偏移连续排列：

| 偏移 | 字段 | Zone1 | Zone2 |
| --- | --- | --- | --- |
| `+0x00` | EXEONLYRAM | `0xFFFFFFFF` | `0xFFFFFFFF` |
| `+0x04` | EXEONLYSECT | `0xFFFFFFFF` | `0xFFFFFFFF` |
| `+0x08` | GRABRAM | `0xFFFFAAFF` | `0xFFFFAAFF` |
| `+0x0C` | GRABSECT | `0xAAAAA9AA` | `0xAAAAAAAA` |
| `+0x10..+0x1C` | CSMPSWD0 至 CSMPSWD3 | 演示密码 | 保留来源芯片的初始密码值 |

sector4 对应 GRABSECT 的 `[9:8]`：Zone1 为 `01`、Zone2 为 `10`，组合表示归 Zone1。其他 Flash sector 配为 `10/10`，LS4 至 LS7 也配为 `10/10`。本例程未开启 execute-only。

Zone2 文件同样参与构建，其 GRAB 字段用于确定资源归属。Zone2 的密码字段保留了初始回读中的值，使用其他芯片时应重新核对。

GPREG、PSWDLOCK、CRCLOCK、JTAGLOCK、BOOTCTRL 及量产填零段当前没有输出配置数据，对应位置保持芯片已有内容。不要为了使模板看起来完整而取消这些字段的注释。

`Security/f28002x_*.asm` 是 TI 参考文件，不参与昊芯目标的构建。

## 演示密码

`Security/password.h` 中的软件密钥与 Zone1 ZSB 的四个密码字按同一顺序对应：

| 字段 | 值 |
| --- | --- |
| CSMPSWD0 / csmKey0 | `0x11111111` |
| CSMPSWD1 / csmKey1 | `0x02222222` |
| CSMPSWD2 / csmKey2 | `0x33333333` |
| CSMPSWD3 / csmKey3 | `0x44444444` |

在 downloader 中按密码字段顺序填写，注意第二个字是 `0x02222222`。修改密码时，需同时核对 OTP 数据、软件密钥和工具设置，并确认新值符合芯片现有 OTP 的可编程方向。

## 构建与首次烧录

1. 导入工程，选择 Debug 配置，核对目标型号、工具链和链接脚本路径。
2. 构建后检查 `Debug/ex01_dcsm_secure_flash.map`：算法函数与正弦表在 sector4，可写变量在 RAM，启动用 RAM 初始化镜像在 APP Flash。
3. 确认两个昊芯 OTP 汇编文件已生成目标文件；map 中 Zone1 LINKPOINTER 大小为 `0x18`，两个 ZSB 各为 `0x20`。不能只根据段名判断配置已进入产物。
4. 核对 `Debug/ex01_dcsm_secure_flash.hex` 中的 Flash 和 USER OTP 地址、数据及密码。首次编程前，将这份产物和初始 OTP 一起保存。
5. 在 downloader 中确认 OTP 编程选项和待写入范围，再执行本次配置。后续仅更新 APP 时，应单独检查烧录范围，避免把普通 Flash 更新与 OTP 编程混在一起。

## 独立运行

打开串口终端后，断开调试会话并重新上电。未执行解锁时应输出：

```text
[DCSM] Zone1 secure.
```

LED 初始按约 500 ms 的间隔翻转，主循环持续调用算法。按下并松开按键后，程序调用 `DCSM_unlockZone1CSM()`；成功时输出：

```text
[DCSM] Zone1 unlock succeed.
```

随后 LED 翻转间隔改为约 250 ms。若失败，输出 `[DCSM] Zone1 unlock failed.`，当前源码不会因此加快闪烁。按键采用轮询，短按可能被主循环延时漏检，松开后才执行解锁。

解锁后断电重启，应重新得到 `Zone1 secure`。调试器连接时可能自动解锁，仿真中的状态应以当时读取的寄存器为准。

## 验证与验收

| 检查项 | 通过条件 |
| --- | --- |
| 区域归属 | sector4 的 Z1/Z2 GRAB 字段为 `01/10`，其余预期资源非安全 |
| 独立启动 | 无调试器参与时，启动日志为 secure，LED 和 SCI 正常 |
| 算法运行 | 索引循环、计算结果更新，正弦表保持固定内容 |
| 软件解锁 | 按键后输出解锁成功，Zone1 进入解锁状态 |
| 重新上锁 | 解锁后断电重启，Zone1 再次为 secure |
| 回读保护 | 错误密码无法取得 sector4 真实内容，正确密码回读内容与构建产物一致 |

使用 downloader 验证回读时，每轮测试前先断电重启，避免沿用上一次的解锁状态。两次选择相同的 Flash 地址范围，分别使用错误密码和正确密码，并保存工具日志和 HEX。非安全 Flash 应保持可读，算法区应出现受限与可读的区别。若工具因解锁失败直接中止回读，也应记录该行为。

本项目的板级验证中，错误密码导致 Zone1 解锁报错，sector4 回读为全零；正确密码时能回读真实算法内容，所有有效 Flash 构建字节与工程 HEX 一致。受保护区域的全零结果不能当作实际 Flash 已被清零的证据。

## 调试时观察什么

`g_sine_table_idx`、`g_epwm_cmp_value` 位于非安全 RAM，在 LiveView 中可见符合配置。`g_sine_table_256` 位于 Zone1 Flash，固定表项不会变化。查看它的内容时，应同时确认当前 Zone1 状态及调试器是否执行过解锁。

常用寄存器包括 `Z1_CR`（`0x00039430`）、Z1/Z2 的 GRABSECTR（`0x00039434` / `0x00039484`）和 `B0_SECTSTAT`（`0x000394A4`）。当前驱动在 `(Z1_CR & 0x60) == 0x60` 时判定已解锁。

调试器已解锁的会话不能证明未授权读取会被阻止。更多排查方法见[项目 FAQ](../../FAQ.md)。
