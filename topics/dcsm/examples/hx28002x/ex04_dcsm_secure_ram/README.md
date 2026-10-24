# ex04：安全 RAM 工作数据

目标为 HXS320F280025C_EDD，使用 Haawking IDE 2.3.17。本例以一个工作变量演示安全 RAM 访问，不将模块代码搬到 RAM。构建与产物检查通过，板级结果待验证。

## 内存与运行

| 内容 | 地址 / 大小 | 属性 |
| --- | --- | --- |
| 模块代码 | sector4，`0x00610000` 起 | Zone1，execute-only |
| 参数3、7 | sector5，`0x00614000` 起 | Zone1，普通安全 |
| 私有变量 `s_module_work` | LS4，`0x00010000`，4字节 | Zone1，普通安全 RAM，NOLOAD |
| APP data、bss、ramfunc | LS5～7，`0x00012000..0x00017FFF` | 非安全 |
| APP 及 RAM 初始化镜像 | 普通 APP Flash | 非安全 |
| 栈 | M0/M1 | 沿用原布局 |

sector4 的 `ProductModule_Init()` 在首次使用前初始化工作变量。`ProductModule_Process()` 将 `input * 3 + 7` 写入 LS4，再读回作为返回值。输入1～9循环，输出10～34、步长3。安全工作段不在启动代码的 BSS 清零和数据复制范围内，初始化不调用非安全 memcpy/memset。

APP 随后通过独立 noinline 函数，实际读取 `0x00010000`。三个非安全 RAM 观察量为 `g_module_input`、`g_module_output`、`g_app_work_read`，串口逐轮输出输入、模块返回值和 APP 直接读值。

SCI 为9600、8N1，LED 每轮翻转。KEY 按住至少300 ms 后松手，按实际状态锁定或解锁；锁定时仍持续调用模块，不沿用 ex02 的暂停逻辑。按住 KEY 期间轮询等待，计算和 LED 暂停属于程序行为。解锁保留 ex02 的应用层准备读取，DriverLib 未改，其必要步骤和根因继续待确认。

APP 受限读取的具体表现需板测，不保证一定返回零。如果产生异常，后续日志、LED、按键可能停止；记录故障位置，并在直接读取前检查模块是否已返回正确结果。

## 与 ex03 共用 OTP

当前开发板准备 Z1 ZSB3（`0x007A0080`），三个 LINKPOINTER 为 `0x1FFFFFFC`。配置顺序为：

```text
EXEONLYRAM   FFFFFFFF
EXEONLYSECT  FFFFFFEF
GRABRAM      FFFFA9FF
GRABSECT     AAAAA5AA
CSMPSWD0     11111111
CSMPSWD1     02222222
CSMPSWD2     33333333
CSMPSWD3     44444444
```

LS4 的 GRABRAM `[9:8]` 为 Z1=`01`、Z2=`10`；LS5～7 非安全。Zone2 汇编及配置保持与 ex01 相同，不推进其指针；完整 HEX 仍包含原有 Z2 ZSB1 数据，写入前同样须核对。可选固定 OTP 字段不输出，旧 Z1 ZSB1/ZSB2 不输出。

本板最近回读的 ZSB3 密码字1为 `0x4BFFFFFF`，与目标 `0x02222222` 兼容，但不能代替其他器件的核对。编程前备份当前 OTP，检查全部预编程位；先写新块并回读，再更新指针。LS4 从 `10` 到 `01` 有0到1冲突，不能覆盖旧 ZSB2。演示密码不是量产配置，本程序不写 OTP。

ex03/ex04 切换只更新 Flash，不再切换 ZSB。操作与观察寄存器见[共用配置与测试说明](../../../validation/hx28002x/REGRESSION_EX03_EX04.md)。裸片从 ZSB1 开始演示的整理任务另行保留。

## 下载与调试

导入 `ex04_dcsm_secure_ram`，选择默认 Flash 配置并由 IDE 重新生成构建文件；本例不支持沿用的 RAM 构建模式。使用默认 `Debug/ex04_dcsm_secure_ram.hex`，不增加 HEX 转换。完整 HEX/ELF 含 OTP，日常程序下载与调试加载必须排除 USER OTP；工具不能控制范围时不要执行该下载。

默认调试配置连接或重启时可能自动解锁，以实时 Z1_CR 为准。OpenOCD 临时工作区改为非安全 GS0（`0x00018000`，8 KiB），不再使用安全 LS4。下载前暂停程序，避免临时工作区覆盖运行中的 GS0 数据；该下载配置仍需板级验证。ELF 的 NOLOAD 段虽没有文件数据，外部加载器是否主动清零仍需核对。

2026-10-23 默认 launch 改为无下载调试，关闭镜像加载但保留符号加载。先用 downloader 只更新 Flash，再连接调试；若 IDE 缓存旧配置，需在 Debug Configurations 中同步关闭 Load image，确认未执行下载，不能仅凭磁盘 launch 已修改就认为当前启动项生效。

启用共用配置后，旧 ex00～ex02 因 APP 使用 LS4，不能原样下载回退，也不能将旧 OTP 镜像写回。修改程序 Flash 不会撤销安全配置。

## 简要测试

1. 完成经核对的共用 OTP 准备后，不连接调试器独立上电。应为 secure；观察模块返回值符合公式，并记录 APP 直接读取的结果或异常。
2. KEY 解锁，检查 `g_app_work_read` 是否与该轮 `g_module_output` 相等；再次锁定，检查读取限制恢复而模块仍运行。重复3轮，记录 LED、日志和调试连接。
3. 再次断电上电，检查恢复 secure、模块初始化及计算正常。观察内存时同步记录 Z1_CR、两区 GRABRAMR 和 RAMSTAT，排除缓存与自动解锁干扰。

构建与反汇编证据见 [构建与产物证据](../../../validation/hx28002x/EX04_BUILD_VALIDATION.md)，板级反馈填写[共用回归表](../../../validation/hx28002x/REGRESSION_EX03_EX04.md)。公开返回值及非安全栈、寄存器上下文仍可能暴露运算状态；本例仅演示指定 RAM 的直接访问保护，不宣称端到端保密。
