# 280013x 平台：ex00～ex02

本目录提供 HXS320F2800137_EDE / PM 核心板的 ex00～ex02，基于开发者提供的空白 DriverLib 工程，使用 Haawking IDE 2.3.17。文档将该平台统称为 280013x，验证范围仅限上述器件和板卡。

三个工程均已有构建及产物检查记录。2026-10-24，开发者反馈 ex00～ex02 板级验证通过；逐项证据见[回归记录](../../validation/hx280013x/REGRESSION_HX280013X_EX00_EX02.md)。ex02 已加入应用层解锁准备读取，当前排除 OTP 源，默认 ELF 及两份 HEX 均不含 OTP。

| 工程目录 | IDE 工程名称 | 演示 | 当前进度（2026-10-24） |
| --- | --- | --- | --- |
| [ex00_base_system](ex00_base_system/README.md) | `ex00_base_system` | 未保护的 LED、SCI、按键和厂家模块基线 | 实现与构建完成；开发者反馈上板通过 |
| [ex01_dcsm_secure_flash](ex01_dcsm_secure_flash/README.md) | `ex01_dcsm_secure_flash` | Zone1 锁定运行，按键解锁 | 开发配置、构建和双 HEX 完成；开发者反馈上板通过，分项证据待补录；密码隐藏未实现 |
| [ex02_dcsm_debug](ex02_dcsm_debug/README.md) | `ex02_dcsm_debug` | 按键反复锁定/解锁及调试读取对照 | 加入解锁准备读取；构建通过，开发者反馈板级通过；当前排除 OTP 源 |

ex03～ex08 仍为规划，当前目录未实现 execute-only、安全 RAM、Flash API、Bootloader、RAMOPEN 或 JTAGLOCK 例程。下一步补录 ex01/ex02 分项证据，再开展密码隐藏对照及后续例程；详见[开发路线](../../../../docs/ROADMAP.md)。

独立的 [280013x OTP 参考模板](../../templates/hx280013x/README.md)提供字段骨架，默认不输出 OTP 数据；各例程仍使用自己 `Security/` 中的配置。

IDE 工程名与目录名一致。280013x 与 28002x 含同名工程，请使用各自独立的 IDE 工作空间。目录编号、`src/`、`Driver/`、`Algorithms/`、函数接口和轮询日志风格沿用 28002x。厂商驱动与库文件保持原样；主链接脚本使用本例的 Flash 布局，工程内仅保留所需脚本。

## 核心板资源

依据《SCH_Haawking_Core_DSC2800137PM_V1.0_Beta1原理图_2024-02-26.pdf》单页原理图，图内版本日期为 2024-02-21。

| 资源 | 配置 | 接线说明 |
| --- | --- | --- |
| LED2 | GPIO20，低有效，每 250 ms 翻转 | `myGPIO0` / `Drv_Led_Toggle()`；先关闭模拟功能 |
| LED3 | GPIO22，低有效 | 初始化为熄灭，本版不另加状态含义 |
| KEY / SW2 | GPIO1，低有效 | R21=22Ω；R20 通往 GPIO7，图中标 NC；实板若改焊须同步改 board 配置 |
| SCIA RX | GPIO28 | 经 R14 接 CH340C TX；先关闭模拟功能 |
| SCIA TX | GPIO29 | 经 R15 接 CH340C RX |
| 串口 | 9600，8N1 | 核心板 MICRO USB / CH340C 虚拟串口，3.3V 逻辑 |
| 晶振 | GPIO19/X1、GPIO18/X2，20 MHz | `USE_PLL_SRC_XTAL`；模板 PLL 配置产生 160 MHz SYSCLK、40 MHz LSPCLK |
| 启动绑带 | GPIO24、GPIO32 外部上拉 | 按图默认 Flash 启动；不作为 LED 或按键 |
| JTAG | CN1，TMS/TCK/TDI/TDO | 保留模板 CMSIS-DAP 配置，未进行在线连接验证 |

按住 SW2 至少 300 ms 后松开。轮询等待松手时，LED 和计算会暂停，属于应用行为。

## 代码与内存布局

三个示例均计算 `output = input * 3 + 7`，输入 1～9，输出 10、13、16、19、22、25、28、31、34。`const volatile` 参数确保真实 Flash 读取。

| 对象 | ex00 | ex01 / ex02 |
| --- | --- | --- |
| 启动入口 | `0x00600000` | `0x00600000` |
| APP、驱动、常量和 RAM 加载镜像 | 普通 Flash | `0x00600010`～`0x0060FFFF`，扇区 0～31 |
| 模块代码 | 普通 APP Flash | `0x00610000`～`0x00613FFF`，扇区 32～39，Zone1 |
| 模块参数 | 普通 APP Flash | `0x00614000`～`0x00617FFF`，扇区 40～47，Zone1；起始 32 位字为 3、7 |
| data / bss | LS0 | LS0，四个安全分段均配置非安全 |
| ramfunc | M0，`0x00000800`起 | M0，`0x00000800`起 |
| 栈 | `0x00000000`～`0x000007FF` | 相同 |

280013x 的 Flash 扇区为 2 KB；32 以上的扇区按 8 扇区一组配置安全属性。这里沿用 28002x 的模块起始地址，**对应的扇区编号和寄存器字段已经改变**。Z1/Z2 `GRABSECT3R[9:8]` 对应 32～39，`[11:10]` 对应 40～47。

各工程的应用主链接脚本为 `haawking-drivers/ldscripts/HXS320F2800137_EDE_link_FLASH.ld`，用于本次 Flash 运行演示。`haawking-drivers/ldscripts/Peripheral.ld`、`BootROM.ld` 是必要的映射依赖，内容保持原样；工程不含另一份厂商原版 Flash 主脚本或未使用的 RAM 主脚本。

IDE 通过 `../haawking-drivers/ldscripts` 搜索链接脚本，无需设置原版 Flash 文件排除项。布局变化及完整文本差异见[链接脚本差异说明](../../docs/HX280013X_LINKER_DIFF.md)。

启动 `_init()` 先清 bss，再复制 ramfunc/data。两份加载镜像均在普通 APP Flash，LS0 全部非安全；不套用 28002x 的 LS4～LS7 / GS0 声明。链接断言约束模块大小、参数大小及 APP 加载镜像上界。

## 导入、构建和程序更新

ex01/ex02 每次 Build 生成普通名称 HEX 和 `_dcsm.hex`，Clean/Rebuild 同步清理。当前 ex01 的 ELF 和 `_dcsm.hex` 含 OTP，普通 HEX 仅含 Flash；ex02 保留 OTP 源 Exclude 设置，ELF 和两份 HEX 均无 OTP。Pre-build 清理旧镜像，Post-build 按实际 ELF 段生成新镜像。launch 下载默认 ELF，必须核对实际段范围。具体机制见[双HEX说明](../../docs/HX280013X_DUAL_HEX_BUILD.md)。

1. 在 Haawking IDE 2.3.17 中导入本目录三个工程，选择 Debug / FLASH，由 IDE 生成构建文件。
2. 核对编译宏 `DSC2800137_EDE`、DriverLib 路径和应用链接脚本。工具链使用 IDE 自带版本。
3. 构建后查看 `Debug/<例程名>.elf`、`.hex`、`.map`。程序 HEX **只有程序 Flash，不包含 USER OTP**。
4. 日常切换 ex01/ex02 只下载相应 APP；它们共用同一 OTP 配置。用演示密钥解锁后再更新受保护 Flash，记录下载工具实际行为。

IDE 生成 makefile 后，也可在 PowerShell 构建：

```powershell
$ide = 'D:\Haawking-IDE-2.3.17'
$env:Path = "$ide\haawking-tools\compiler\Haawking-RISCV-LLVM\bin;$ide\haawking-tools\compiler\bin;$env:Path"
make -C topics/dcsm/examples/hx280013x/ex02_dcsm_debug/Debug -B all
```

launch 继承模板的 `monitor hx_c_unlock 0` 自动解锁流程。ex01/ex02 的 Zone1 密码项已改为本例程演示值，Zone2 保留模板的出厂 ZSB1 值。launch 的构建配置 ID 与 `.cproject` 已同步。连接后不一定仍处于 secure，以实时寄存器为准。JTAG 密码字段属于模板连接配置，不表示本例启用了芯片的 JTAGLOCK；程序和 OTP 模板均不启用它。

## 一次性 OTP 准备

**构建不连接硬件或编程 OTP。** 两个 OTP `.S` 位于 `Security/`。当前 ex01 参与构建，ELF 及 `_dcsm.hex` 含 OTP；ex02 主动排除 OTP 源，其 ELF 和两份 HEX 均无 OTP，已构建复验。启用 OTP 源时，普通 HEX 通过移除 OTP 段保持仅程序 Flash。日常更新请使用普通 HEX 或工具支持的仅 Flash 下载设置，见[双HEX说明](../../docs/HX280013X_DUAL_HEX_BUILD.md)。

当前 ZSB1 配置**只适用于事先确认兼容的 ZSB1 新器件**：三个 14 位 LINKPOINTER 的有效值均应为 `0x3FFF`，Z1/Z2 活动 ZSB 地址分别为 `0x00640040` / `0x00640440`，块步长为 `0x40` 字节。手册表 5-3 将首块称为 Block0，图 5-1 称为 ZSB1，本目录统一用 ZSB1。已使用其他槽位或已写字段的器件，需另行规划，不能覆盖套用。

| 输出范围 | 内容 |
| --- | --- |
| `0x00640000`～`0x0064000B` | Z1 LINKPOINTER1/2/3 均为 `FFFFFFFF`，低 14 位选择 ZSB1；ex01 当前输出，ex02 仅在启用 OTP 源时输出 |
| `0x00640040`～`0x0064004F` | Z1 演示密码：`11111111 00222222 33333333 44444444` |
| `0x00640050`～`0x0064005F` | Z1 GRABSECT1/2/3、GRABRAM1：`AAAAAAAA AAAAAAAA AAAAA5FF FFFFFFAA` |
| `0x00640450`～`0x0064045F` | Z2 GRABSECT1/2/3、GRABRAM1：`AAAAAAAA AAAAAAAA AAAAAAFF FFFFFFAA` |

Z1 密码第二字保留手册所列 ZSB1 出厂值 `0x4D7FFFFF` 的零位，密码在 `Security/hx280013x_dcsm_z1otp.S` 中用 `.word` 直接填写，应用解锁密钥在 `Security/password.h` 中直接填写，与 28002x 风格一致。修改演示密码时，须同时更新这两个文件和 launch 中的 Zone1 密码项。实际芯片初始 OTP 仍必须单独备份、核对，不以手册默认值代替实物回读。Zone2 的密码不输出，保留其出厂状态。

当前 ex01 输出 60 字节 OTP（12 字节 Z1 LINKPOINTER＋48 字节 ZSB 配置），ex02 当前 Exclude OTP 而不输出 OTP，启用两个 OTP 源时输出 60 字节（含 12 字节 Z1 LINKPOINTER）；两例 ZSB 密码及归属配置相同。全 1 指针不能恢复已清零的位，当前两例实际产物的 OTP 范围不同，应分别核对。除此之外未输出其他固定头部、PSWDLOCK、JTAGLOCK、CMAC、启动配置、execute-only 及 JTAG 密码字段。这些地址不能被下载工具用填充数据连带写入。保留出厂 PSWDLOCK 时，CSM 密码位置仍可能可读；这是开发演示配置，**本版不演示密码隐藏**。将来隐藏密码须另行规划固定 OTP，不能用按键反复切换。演示明文密钥不得作为量产方案。

原理图不能判断实物的 OTP 状态。任何有意 OTP 编程均应由开发者完成：先保存初始备份，逐字核对计划值及工厂位，再按工具的编程粒度和规则安排一次性写入，回读后断电上电确认。除 LINKPOINTER 的规定例外，不能沿用 28002x 在已写字段继续清位的操作。固定配置和槽位推进不包含在自动脚本中。

TRM V1.3 图 5-2 遗漏 GRABSECT3，部分 EXEONLY 字段位置与其他说明存在差异，5.2.8 示例还使用了 32 字节斜率；本版使用 SDK 的 64 字节 ZSB 选择公式。GRABSECT3 位于已列 GRABSECT2(+0x14)与 GRABRAM1(+0x1C)之间的+0x18，需在 OTP 准备回读及启动后的 GRABSECT3R 中核对。未明确的 EXEONLY 字段不输出，不把图示当作可烧录的完整 64 字节表。若实物/官方说明不一致，应先修订准备文件。

## 观察点和验收

以下均为**字节地址**，不要使用 28002x 的 `0x000394xx` 地址或 `0x60` 原始 CR 判据。

| 寄存器 | 地址 | 检查 |
| --- | --- | --- |
| Z1_LINKPOINTER | `0x00219400` | 低 14 位应选择预期 ZSB |
| Z1_OTPSECLOCK | `0x00219404` | PSWDLOCK 状态，不能仅靠 Flash 读回判断密码是否隐藏 |
| Z1_CR | `0x00219430` | bit22 ARMED、bit21 UNSECURE、bit31 FORCESEC；ALLZERO/ALLONE 单独判断 |
| Z1_GRABSECT3R | `0x0021943C` | `[9:8]` / `[11:10]` 均为 01 |
| Z2_GRABSECT3R | `0x002194BC` | 对应字段均为 10 |
| SECTSTAT3 | `0x0021950C` | 对应字段均为 01，即 Zone1 |
| RAMSTAT1 | `0x00219520` | LS0 A～D 保持非安全，记录实际值 |

串口 `CR>>16` 使用 DriverLib 的 `DCSM_getZone1ControlStatus()` 返回值，已右移 16 位；例如其 `0x60` 对应原始 CR 的 `0x00600000`，不能混写。每次按键后查询实际状态，不凭请求日志认定成功。开发者反馈 FORCESEC 后再次解锁失败后，已按要求在 ex02 加入适配 280013x 布局的 `Prepare_Zone1_Unlock()` 应用层试验；厂商驱动不变，开发者已反馈板级复测通过，详见[DCSM-002](../../docs/errata.md)。

板级步骤与结果见[独立回归表](../../validation/hx280013x/REGRESSION_HX280013X_EX00_EX02.md)。28002x 的成功次数及保护现象不作为本平台证据。

## 工作空间更新与配置核对

三个 IDE 工程名、launch 文件名及 ELF 名与目录名一致，例如 `ex00_base_system`、`ex00_base_system.launch`、`Debug/ex00_base_system.elf`。从曾使用 `hx280013x_` 工程前缀的版本更新时，需要刷新现有工作空间。

更新后先关闭 Debug Configurations，在 Project Explorer 中选中工程按 F5 刷新并重新构建，再打开调试配置。如果此前 Debug 菜单已因旧 launch 文件缺失报错，请重启 IDE。ex01/ex02 需要分别导入本平台对应目录；不要把 28002x 的同名工程导入同一个工作空间。无需删除源码或整个 `.metadata`。

2026-10-24 初始 OTP 核对：开发者提供的 2048 字节回读与手册出厂模式一致，两 Zone 均选中 ZSB1；当时 48 字节 ZSB 准备内容无 0 变 1 冲突。当前 ex01 额外输出的三个值全为 1 的 LINKPOINTER 应继续按实物当前值核对。初始核对不等于 OTP 写后回读，ex01 整体板级通过也未附写后镜像；详细证据见[独立回归表](../../validation/hx280013x/REGRESSION_HX280013X_EX00_EX02.md)。

TRM 复核补充（2026-10-24）：6.6.2 节印刷第 486～487 页明确规定 DCSM OTP 按 32 位/4 字节对齐，每字只能编程一次，LINKPOINTER 为规定例外。当前源码启用后输出的 60 字节配置，以及历史 48 字节配置，均由完整且对齐的 32 位字组成。图 5-2 仍遗漏 GRABSECT3，+0x18 属于开发者已接受的实验推定，未取得显式地址定义；具体下载器对稀疏 HEX 的处理也不能由 TRM 硬件粒度推出。详见[原文复核记录](../../validation/hx280013x/REGRESSION_HX280013X_EX00_EX02.md)。

## 例程配置文件

每个安全示例通过以下文件管理 OTP 配置、应用密钥、段地址和 HEX 输出：

```text
Security/
    hx280013x_dcsm_z1otp.S
    hx280013x_dcsm_z2otp.S
    password.h
    BuildHex.ps1
haawking-drivers/ldscripts/
    HXS320F2800137_EDE_link_FLASH.ld
    DCSM.ld
    Peripheral.ld
    BootROM.ld
```

`.S` 内密码与配置均为显式十六进制字，`DCSM.ld` 按两个 Zone 的固定头部和 ZSB 有效字段分组提供 MEMORY / SECTIONS，保留位置只作注释说明；`BuildHex.ps1` 从默认 ELF 转换并检查两份 HEX。

APP 主脚本已包含 `DCSM.ld`；ex01 的两个 OTP `.S`参与构建，ELF 包含 APP 与 OTP；ex02 保留主动 Exclude 设置，ELF 无 OTP；普通 HEX 通过移除.dcsm*段保持仅程序 Flash。现有 launch 下载默认 ELF，OTP 是否包含以实际构建段为准。280013x 字段顺序、地址和已记录的 TRM 待确认项保留。

实验决定（2026-10-24）：开发者已同意采用推定的 GRABSECT3=ZSB+0x18 布局继续 ex01/ex02。当前 OTP 模板按此定义保持不变，OTP 配置不再等待这一项的显式手册标注；官方定义与实测结果仍分别记录。

## 例程内 OTP 字段与链接布局

模板覆盖 280013x 新增及重新定义的字段，排版参考 28002x，字段和地址采用 280013x 定义。下表偏移均为**字节偏移**；固定头部基址为 Zone1 `0x00640000`、Zone2 `0x00640400`，ZSB 偏移相对各自选中的块起点。

| 280013x 字段或布局变化 | 固定头部/ZSB 偏移 | 适用 Zone 及说明 |
| --- | --- | --- |
| LINKPOINTER1/2/3 | 头部+0x00/+0x04/+0x08 | 两 Zone；三个 32 位字连续排列，不沿用 28002x 的间隔保留字 |
| JLM_ENABLE | 头部+0x0C | 仅 Zone1；低 4 位为 0xF 时禁用 JTAGLOCK，其他值启用 |
| GPREG1/2/3/4 | 头部+0x10/+0x14/+0x18/+0x1C | 两 Zone；四个独立配置字，不套用 28002x 的 BOOTPIN_CONFIG、BOOTDEF_LOW/HIGH 名称和偏移 |
| CRCLOCK | 头部+0x24 | 两 Zone；与 28002x 的+0x28 不同，厂商头文件未列出该项，按 TRM 补齐 |
| JTAGPSWDH0/1 | 头部+0x28/+0x2C | 仅 Zone1；128 位 JTAG 密码的[95:64]/[127:96]位，固定头部永久部分 |
| CMACKEY0/1/2/3 | 头部+0x30/+0x34/+0x38/+0x3C | 仅 Zone1；安全启动 128 位密钥，从[31:0]到[127:96]顺序填写 |
| CSMPSWD0/1/2/3 | ZSB+0x00/+0x04/+0x08/+0x0C | 两 Zone；密码移至块首，不沿用 28002x 的块尾布局 |
| GRABSECT1/2/3、GRABRAM1 | ZSB+0x10/+0x14/+0x18/+0x1C | 两 Zone；扩展为三个 Flash 归属字及一个 RAM 归属字；+0x18 按已接受的实验推定 |
| EXEONLYSECT1/2、EXEONLYRAM1 | ZSB+0x28/+0x2C/+0x30 | 两 Zone；+0x2C 仍属布局推定，默认不输出 |
| JTAGPSWDL0/1 | ZSB+0x38/+0x3C | 仅 Zone1；JTAG 密码低 64 位，随选中槽位变化 |

Zone2 固定头部+0x0C、+0x28～+0x3C 以及 ZSB 尾部+0x38/+0x3C 均保留，不添加 Zone1 专属字段。两例 `.S` 和 `DCSM.ld` 已同步标注上述差异。已逐项核对厂商 `inc/hw_dcsm.h` 中 23 个 OTP 定义及 TRM 所列 OTP 字段；运行时的 CSMKEY、JTAGKEY、CMACKEY 影子寄存器不另作为 OTP 配置字输出。

两份 `.S` 列出完整有效字段，当前实验只输出其中已启用的配置：当前 ex01 输出 60 字节 OTP，ex02 当前 Exclude OTP 而不输出 OTP，启用两个 OTP 源时输出 60 字节（含 12 字节 Z1 LINKPOINTER）；其他有效配置以注释 `.word` 保留，取消注释前填写目标值并核对器件初值。保留地址仅用注释记录，不提供可启用的 `.word` 或输出 section。

| 分组 | Zone1 | Zone2 |
| --- | --- | --- |
| LINKPOINTER | 三个副本 | 三个副本 |
| 固定头部 | JLM_ENABLE、GPREG1～4、PSWDLOCK、CRCLOCK、JTAGPSWDH0/1、CMACKEY0～3 | GPREG1～4、PSWDLOCK、CRCLOCK 及保留位置 |
| ZSB 密码 | CSMPSWD0～3，显式值 | CSMPSWD0～3，保留可编辑的出厂值模板，默认不输出 |
| ZSB 归属 | GRABSECT1～3、GRABRAM1 | 同左 |
| ZSB 仅执行 | EXEONLYSECT1/2、EXEONLYRAM1，默认不输出 | 同左 |
| ZSB 尾部 | JTAGPSWDL0/1 及保留位置 | 保留位置 |
| 后续槽位 | 通过 DCSM.ld 中的 ZSB 区域起始地址选择，块长 0x40 | 同左 |

可选字段按分组使用输入段，链接脚本按固定偏移安放。每个 Zone 的 GPREG1～4 合并为 `b0_dcsm_otp_z1_gpreg` / `b0_dcsm_otp_z2_gpreg`，四字顺序排列；EXEONLYSECT1/2 合并为 `b0_dcsm_zsel_z1_exeonlysect` / `b0_dcsm_zsel_z2_exeonlysect`，两字顺序排列。两组均须整组启用或整组注释，不能注释组内某一字来跳过地址；链接脚本分别检查段长度为 0 或 0x10、0 或 0x08，防止不完整输出。密码和密钥分组也必须完整填写。所有输出段统一采用 `. = ORIGIN(区域名);` 后接段声明的形式，地址只在 MEMORY 中定义；每个有效配置组有自己的区域，避免可选组被省略时其他组前移或生成填充字节。保留位置没有输出映射。切换 ZSB 时，修改脚本顶部 `DCSM_Z1_ZSB_BASE` / `DCSM_Z2_ZSB_BASE`，还需按规则同步 LINKPOINTER、该槽位的出厂密码位、应用密钥及 launch 密码；不能只改链接地址。

ZSB 偏移 0x20/0x24 保留，0x28 为 EXEONLYSECT1，0x2C 为 EXEONLYSECT2 布局推定，0x30 为 EXEONLYRAM1，0x34 保留，Zone1 的 0x38/0x3C 为 JTAGPSWDL0/1。参考 Haawking TRM 图 5-2 的显式标注与字段清单，并对照本机 C2000Ware 6.00.00.00 F280013x BootROM 的 `dcsm_otp_offsets.h` / DCSM 示例作结构检查（TI 按 16 位字寻址，其偏移不能直接作为昊芯字节偏移，也不代表两平台行为等同）。未显式标注的+0x2C 仍注明推定并默认禁用；此前已接受的 GRABSECT3 +0x18 实验前提不变。
