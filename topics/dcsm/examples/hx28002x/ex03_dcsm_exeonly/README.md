# ex03：Execute-Only 与普通安全保护对照

从 ex01 最小产品模块派生。Zone1 锁定或解锁时，APP 均持续计算 `output = input * 3 + 7`，并调用同 Zone 探针把模块代码当数据读取。2026-10-22 普通安全基线通过；execute-only 新配置仍待板测，不以 TI 行为推定昊芯结果。

## 内存与路径

| 对象 | 位置 |
| --- | --- |
| APP、驱动、日志和普通 RAM 初始化镜像 | 普通 APP Flash，sector0–3 |
| `ProductModule_Process()` / `module_code` | sector4，`0x00610000..0x00613FFF`，Zone1；shared 配置下 execute-only |
| `g_module_params[2]` / `module_params` | sector5 起始 `0x00614000`，公开参数3、7，普通安全 Zone1 |
| `ProductModule_ReadCode()` / `module_probe` | sector5，参数之后，普通安全 Zone1；精确地址见 map |
| APP data、bss、ramfunc | 非安全 LS5–7，`0x00012000..0x00017FFF` |
| 栈 | M0/M1；LS4 `0x00010000..0x00011FFF` 完全不占用 |

正常路径：APP → sector4 模块取指 → sector5 参数数据读 → 返回计算结果。探针路径：APP → sector5 探针取指 → 对 `0x00610000` 执行一次32位 volatile 数据读 → 返回原始读值。探针显式 noinline，不能放到普通 APP，否则跨 Zone 限制会混入对照。链接器要求模块代码至少4字节，仍须检查实际指令和位置。

仅三个应用观察量：`g_module_input`、`g_module_output`、`g_module_code_read`，均在非安全 RAM。输入1～9，正常输出10～34。SCI 为9600、8N1，逐轮输出输入、结果、代码读值以及实时 `Z1_CR`、`EXEONLYSECTR`，不根据某个固定读值自动判定成功。

KEY 消抖后等待松手，按实际状态请求锁定或解锁。锁定不会主动暂停模块或探针；按住 KEY 期间轮询等待，计算和 LED 暂停，不是保护证据。解锁复用 ex02 应用层 `Prepare_Zone1_Unlock()`，DriverLib 不变；补充读取的必要性和根因仍待确认。

## 先基线，再切换 Shared OTP

1. 备份并回读器件 OTP，确认当前 ex01/ex02 Z1 ZSB2：三个 LINKPOINTER 为 `0x1FFFFFFE`，ZSB2 基址 `0x007A0060`，sector4/5 普通安全 Zone1，RAM 非安全。
2. **仅下载本例程 Flash，排除全部 USER OTP。** 同一固件在当前 ZSB2 下可运行，LS5–7 仍非安全。记录锁定时公式正常、sector5 同 Zone 探针是否读到与 ELF 对应的真实代码首字，再解锁、重新锁定重复观察。该同 Zone 探针基线尚未板测，旧调试器回读记录不能代替。
3. 单独授权并核对新 profile 后，准备 shared ZSB3。LS4 从 `10` 改 `01` 涉及0→1，**不能原位覆盖 ZSB2**。先核对并写入 ZSB3、回读校验，再按器件规定更新三个 LINKPOINTER。本程序不写 OTP。
4. shared profile 生效并重新上电后，用同一固件重复锁定、解锁、重新锁定与断电对照。锁定时预期模块可执行且可读 sector5 参数，同 Zone 代码数据读受限；具体返回值、异常等均以板测为准。

**解锁不是 EXEONLY 属性切换。解锁后 CPU 探针及调试器能否读出 sector4 真实内容均待板测，不保证解锁取消或保留读取限制。** 同时记录安全状态和 EXEONLY 位；调试器可见性不能代替 CPU 同 Zone 测试。若探针异常，分别记录探针前的计算结果及故障位置，不仅凭 SCI/LED 停止推断原因。

## Shared ZSB3 目标值

ex03/ex04 共用 Zone1 profile；ex03 不使用安全 LS4，不启用 RAM execute-only。

| 字段 | 字节地址 | 目标值 |
| --- | --- | --- |
| Z1 LINKPOINTER1/2/3 | `0x007A0000 / 0x007A0008 / 0x007A0010` | 均 `0x1FFFFFFC` |
| EXEONLYRAM | `0x007A0080` | `0xFFFFFFFF` |
| EXEONLYSECT | `0x007A0084` | `0xFFFFFFEF`，sector4 bit4=0 |
| GRABRAM | `0x007A0088` | `0xFFFFA9FF`，LS4=`01`，LS5–7=`10` |
| GRABSECT | `0x007A008C` | `0xAAAAA5AA`，sector4/5=`01` |
| CSMPSWD0/1/2/3 | `0x007A0090 / 0x007A0094 / 0x007A0098 / 0x007A009C` | `11111111 / 02222222 / 33333333 / 44444444` |

编程前必须核对**目标器件 slot3/ZSB3 的工厂预编程密码位**，不能因 slot2 可用就认定 slot3 兼容。密码调整须同步应用密钥和 launch。演示密码不是量产方案。

Zone2 汇编保留 ex01 原文件，不推进其 LINKPOINTER；完整 profile 仍输出原 ZSB1 相同值（包括密码），须与目标回读一致，不视为任意器件的工厂值。Z1 固定头部可选字段保持不输出，旧 Z1 ZSB1/2 不输出。日常切换 ex03/ex04 不需推进 OTP。

## 构建与验收

Haawking IDE 2.3.17 导入 `ex03_dcsm_exeonly` 并重新生成 Debug 构建文件。本例仅支持默认 FLASH 配置，不切换到沿用的 RAM 链接脚本。工程名、ELF、配置 ID 已独立；跨目录使用时重新检查工具链和链接路径。本地已存在生成模板时可执行：

```powershell
$ide = 'D:\Haawking-IDE-2.3.17'
$env:Path = "$ide\haawking-tools\compiler\Haawking-RISCV-LLVM\bin;$ide\haawking-tools\compiler\bin;$env:Path"
& "$ide\haawking-tools\compiler\bin\make.exe" -C Debug -B all
```

默认构建生成 `Debug/ex03_dcsm_exeonly.hex`。完整 HEX/ELF **含新 OTP 目标数据**，普通 Flash 更新必须明确排除全部 USER OTP，基线阶段尤其不能直接下载完整镜像；工具无法排除时不得进行该下载。开发期间已另用 objcopy 生成不含 OTP 的 `.flash.hex` 并校验，它不是默认构建目标，重新构建后须重新生成核对。

2026-10-23 默认 launch 改为无下载调试：关闭镜像加载、保留符号加载；先使用 downloader 仅更新 Flash，再连接调试。IDE 工作空间若缓存了旧配置，需要在 Debug Configurations 中同步确认无下载、Load image 关闭；仍保留连接时的自动解锁，不能把连接后状态当成独立上电锁定状态。

检查 map、HEX、反汇编：模块在 sector4，参数/探针在 sector5；探针有且仅有一次目标数据 load，未内联；APP data/bss/ramfunc 全在 LS5–7，栈仍在 M0/M1，LS4 无节占用；普通 RAM 加载镜像在 APP Flash，sector4 不放需数据读取的常量、查表和 RAM 加载镜像。确认 HEX 只有新 Z1 ZSB3、三份 LINKPOINTER 和原 Z2 profile，无旧 Z1 ZSB 数据。

本地 Flash 初始化目前保持数据 cache 关闭，厂商源码未改。板测仍须记录 Flash/cache 配置并排除工具缓存、自动解锁干扰。至少记录器件、工具版本、OTP 回读、GRAB/EXEONLY 和安全状态、代码首字、探针返回值、计算结果、按键切换及断电恢复。构建通过不代表板级验证通过。

新工程的 OpenOCD 临时工作区改为非安全 GS0（`0x00018000`，8 KiB），不再使用安全 LS4。下载前暂停程序；工作区会覆盖 GS0 的临时内容，该下载配置仍需板级验证。不要在程序运行中重新烧录。

## 本地软件检查记录

2026-10-23 排查 APP 恢复后仅有启动日志的问题，临时在 input=1 的轮次增加 `[CHECK] before module`、模块返回、探针返回三条日志。只重建 APP 及其 RAM 加载镜像，并用 objcopy 生成 `Debug/ex03_dcsm_exeonly.app_recovery.hex`；该诊断文件不包含 sector4/5 或 OTP，不适用于空白器件完整烧录。模块目标文件 SHA-256 与加日志前一致。日志用于区分模块调用失败与探针受限读取异常，不将程序停住直接判为 execute-only 通过。诊断重建会改变 APP 内地址和加载镜像位置，以下首版构建地址记录不作为诊断 APP 的固定地址表。

2026-10-22 开发者提供基线串口日志：Zone1 secure、`Z1_CR=0x40`、`EXE=0x0000FFFF`，输入1～9循环且输出符合公式，同 Zone 探针稳定读到 `0xD62A7179`。这证明当前普通安全配置下探针可读真实代码，不代表 execute-only 已验证。下一阶段保留同一份 Flash 程序，仅在经核对的 OTP 配置切换后重复观察。

2026-10-22，使用 IDE 2.3.17 工具链和本地生成 make 模板执行 `-B all` 成功，未烧录。存在脚手架沿用的编译阶段链接参数未使用警告。Debug 产物被仓库忽略，不纳入提交。

`llvm-readelf -S/-l` 确认 data=`0x12000`、ramfunc=`0x12030`、bss=`0x12330`，其 Flash 加载镜像从 `0x605E50` 开始；LS4 无节占用，栈顶符号仍为 `0xFE8`。三个观察量地址依次为 `0x12330/0x12334/0x12338`。

模块地址 `0x610000`、长度 `0x1C`；参数地址 `0x614000`、长度8；探针地址 `0x614010`、长度 `0x0C`。反汇编确认探针只有一次对 `0x610000` 的数据 load，模块保留对参数3、7的实际数据读取。此构建代码首字的离线参考值为 `0xD62A7179`，只用于该 ELF 的基线比较，不作为其他构建的固定判据。

默认 HEX 全部记录校验和及目标配置检查通过。OTP 输出恰为88字节：三份 LINKPOINTER 连同保留字24字节、Z1 ZSB3 32字节、原 Z2 ZSB1 32字节；无旧 Z1 ZSB 输出。125个 vendor C/H/汇编文件（含 crt/syscalls）及 Zone2 汇编的 SHA256 与 ex01 一致。

共享 OTP 准备、slot3 回读证据及待执行板测步骤见[共用回归表](../../../validation/hx28002x/REGRESSION_EX03_EX04.md)。回读兼容性证据不等于自动烧录许可。本例尚无板级验收结论，解锁后的 execute-only 读取行为仍待测。
