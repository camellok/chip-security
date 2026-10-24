# 280013x 平台：ex00～ex02

本目录以开发者提供的 HXS320F2800137_EDE 空白 DriverLib 工程为模板，使用 Haawking IDE 2.3.17。平台统称为 **280013x**；当前具体目标为 **2800137_EDE、PM 核心板**，不代表其他容量、封装或修订均已验证。三个工程已完成构建及产物检查；2026-10-24开发者反馈ex00上板通过，ex01/ex02板级验证待完成。

| 工程目录 | IDE 工程名称 | 演示 |
| --- | --- | --- |
| [ex00_base_system](ex00_base_system/README.md) | `ex00_base_system` | 未保护的 LED、SCI、按键和厂家模块基线 |
| [ex01_dcsm_secure_flash](ex01_dcsm_secure_flash/README.md) | `ex01_dcsm_secure_flash` | Zone1 锁定运行，按键解锁 |
| [ex02_dcsm_debug](ex02_dcsm_debug/README.md) | `ex02_dcsm_debug` | 按键反复锁定/解锁及调试读取对照 |

IDE工程名与目录名一致。280013x与28002x含同名工程，请使用各自独立的IDE工作空间。目录编号、`src/`、`Driver/`、`Algorithms/`、函数接口和轮询日志风格沿用 28002x。模板自带的驱动与库文件保持原样；原版Flash/RAM主链接脚本已按本例需求替换并删除冗余副本。

## 核心板资源

依据《SCH_Haawking_Core_DSC2800137PM_V1.0_Beta1原理图_2024-02-26.pdf》单页原理图，图内版本日期为2024-02-21。

| 资源 | 配置 | 接线说明 |
| --- | --- | --- |
| LED2 | GPIO20，低有效，每250 ms翻转 | `myGPIO0` / `Drv_Led_Toggle()`；先关闭模拟功能 |
| LED3 | GPIO22，低有效 | 初始化为熄灭，本版不另加状态含义 |
| KEY / SW2 | GPIO1，低有效 | R21=22Ω；R20 通往 GPIO7，图中标 NC；实板若改焊须同步改 board 配置 |
| SCIA RX | GPIO28 | 经 R14 接 CH340C TX；先关闭模拟功能 |
| SCIA TX | GPIO29 | 经 R15 接 CH340C RX |
| 串口 | 9600，8N1 | 核心板 MICRO USB / CH340C 虚拟串口，3.3V 逻辑 |
| 晶振 | GPIO19/X1、GPIO18/X2，20 MHz | `USE_PLL_SRC_XTAL`；模板 PLL 配置产生160 MHz SYSCLK、40 MHz LSPCLK |
| 启动绑带 | GPIO24、GPIO32 外部上拉 | 按图默认 Flash 启动；不作为 LED 或按键 |
| JTAG | CN1，TMS/TCK/TDI/TDO | 保留模板 CMSIS-DAP 配置，未进行在线连接验证 |

按住 SW2 至少300 ms后松开。轮询等待松手时，LED和计算会暂停，属于应用行为。

## 代码与内存布局

三个示例均计算 `output = input * 3 + 7`，输入1～9，输出10、13、16、19、22、25、28、31、34。`const volatile` 参数确保真实 Flash 读取。

| 对象 | ex00 | ex01 / ex02 |
| --- | --- | --- |
| 启动入口 | `0x00600000` | `0x00600000` |
| APP、驱动、常量和 RAM 加载镜像 | 普通 Flash | `0x00600010`～`0x0060FFFF`，扇区0～31 |
| 模块代码 | 普通 APP Flash | `0x00610000`～`0x00613FFF`，扇区32～39，Zone1 |
| 模块参数 | 普通 APP Flash | `0x00614000`～`0x00617FFF`，扇区40～47，Zone1；起始32位字为3、7 |
| data / bss | LS0 | LS0，四个安全分段均配置非安全 |
| ramfunc | M0，`0x00000800`起 | M0，`0x00000800`起 |
| 栈 | `0x00000000`～`0x000007FF` | 相同 |

280013x 的 Flash 扇区为2 KB；32以上的扇区按8扇区一组配置安全属性。这里沿用 28002x 的模块起始地址，**对应的扇区编号和寄存器字段已经改变**。Z1/Z2 `GRABSECT3R[9:8]` 对应32～39，`[11:10]` 对应40～47。

应用链接脚本位于各工程 `haawking-drivers/ldscripts/HXS320F2800137_EDE_link_FLASH.ld`，每个工程仅保留这一份Flash主脚本。厂商原版Flash主脚本和未使用的RAM主脚本已删除；`haawking-drivers/ldscripts/Peripheral.ld`、`BootROM.ld`仍是必要映射依赖，保持原样。具体布局变化及完整文本差异见[链接脚本差异说明](../../docs/HX280013X_LINKER_DIFF.md)。IDE的链接搜索路径使用 `../haawking-drivers/ldscripts`，不再使用原版Flash文件排除项。仅提供本次Flash运行演示。

启动 `_init()` 先清 bss，再复制 ramfunc/data。两份加载镜像均在普通 APP Flash，LS0 全部非安全；不套用 28002x 的 LS4～LS7 / GS0 声明。链接断言约束模块大小、参数大小及 APP 加载镜像上界。

## 导入、构建和程序更新

ex01/ex02现在每次Build同时输出普通名称HEX（仅程序Flash）和 `_dcsm.hex`（程序Flash+DCSM配置）。Pre-build清理旧镜像，Post-build生成新镜像，Clean/Rebuild清理两份；APP ELF仍不含OTP。具体机制及验证见[双HEX构建说明](../../docs/HX280013X_DUAL_HEX_BUILD.md)。

1. 在 Haawking IDE 2.3.17 中导入本目录三个工程，选择 Debug / FLASH，由 IDE 生成构建文件。
2. 核对编译宏 `DSC2800137_EDE`、DriverLib 路径和应用链接脚本。工具链使用 IDE 自带版本。
3. 构建后查看 `Debug/<例程名>.elf`、`.hex`、`.map`。程序 HEX **只有程序 Flash，不包含 USER OTP**。
4. 日常切换 ex01/ex02 只下载相应 APP；它们共用同一 OTP 配置。用演示密钥解锁后再更新受保护 Flash，记录下载工具实际行为。

IDE 生成 makefile 后，也可在 PowerShell 构建：

```powershell
$ide = 'D:\Haawking-IDE-2.3.17'
$env:Path = "$ide\haawking-tools\compiler\Haawking-RISCV-LLVM\bin;$ide\haawking-tools\compiler\bin;$env:Path"
make -C security_examples/hx280013x/ex02_dcsm_debug/Debug -B all
```

launch 继承模板的 `monitor hx_c_unlock 0` 自动解锁流程。ex01/ex02 的 Zone1 密码项已改为本例程演示值，Zone2 保留模板的出厂 ZSB1 值。launch 的构建配置 ID 与 `.cproject` 已同步。连接后不一定仍处于 secure，以实时寄存器为准。JTAG 密码字段属于模板连接配置，不表示本例启用了芯片的 JTAGLOCK；程序和 OTP 模板均不启用它。

## 一次性 OTP 准备

**工程不会自动编程 OTP。** ex01/ex02 的两个 OTP `.S` 文件直接放在 `Security/` 下，并单独排除在默认APP构建之外。手动构建独立OTP文件：

```powershell
& ./security_examples/hx280013x/ex01_dcsm_secure_flash/Security/BuildOtp.ps1
```

脚本仅生成 `Debug/otp/hx280013x_dcsm_zsb1.{elf,hex,map}`。ex02 的对应源码及产物内容相同。程序 HEX 与 OTP HEX 必须分别核对，不能合并成默认下载镜像。

该准备文件**只适用于事先确认兼容的 ZSB1 新器件**：三个14位 LINKPOINTER 的有效值均应为 `0x3FFF`，Z1/Z2 活动 ZSB 地址分别为 `0x00640040` / `0x00640440`，块步长为 `0x40` 字节。手册表5-3将首块称为 Block0，图5-1称为 ZSB1，本目录统一用 ZSB1。已使用其他槽位或已写字段的器件，需另行规划，不能覆盖套用。

| 输出范围 | 内容 |
| --- | --- |
| `0x00640040`～`0x0064004F` | Z1 演示密码：`11111111 00222222 33333333 44444444` |
| `0x00640050`～`0x0064005F` | Z1 GRABSECT1/2/3、GRABRAM1：`AAAAAAAA AAAAAAAA AAAAA5FF FFFFFFAA` |
| `0x00640450`～`0x0064045F` | Z2 GRABSECT1/2/3、GRABRAM1：`AAAAAAAA AAAAAAAA AAAAAAFF FFFFFFAA` |

Z1 密码第二字保留手册所列 ZSB1 出厂值 `0x4D7FFFFF` 的零位，密码在 `Security/hx280013x_dcsm_z1otp.S` 中用 `.word` 直接填写，应用解锁密钥在 `Security/password.h` 中直接填写，与28002x风格一致。修改演示密码时，须同时更新这两个文件和launch中的Zone1密码项；不再使用共享宏头文件。实际芯片初始 OTP 仍必须单独备份、核对，不以手册默认值代替实物回读。Zone2 的密码不输出，保留其出厂状态。

未输出 LINKPOINTER、固定头部、PSWDLOCK、JTAGLOCK、CMAC、启动配置、execute-only 及 JTAG 密码字段。这些地址不能被下载工具用填充数据连带写入。保留出厂 PSWDLOCK 时，CSM 密码位置仍可能可读；这是开发演示配置，**本版不演示密码隐藏**。将来隐藏密码须另行规划固定 OTP，不能用按键反复切换。演示明文密钥不得作为量产方案。

原理图不能判断实物的 OTP 状态。任何有意 OTP 编程均应由开发者完成：先保存初始备份，逐字核对计划值及工厂位，再按工具的编程粒度和规则安排一次性写入，回读后断电上电确认。除 LINKPOINTER 的规定例外，不能沿用 28002x 在已写字段继续清位的操作。固定配置和槽位推进不包含在自动脚本中。

TRM V1.3 图5-2遗漏 GRABSECT3，部分 EXEONLY 字段位置与其他说明存在差异，5.2.8 示例还使用了32字节斜率；本版使用 SDK 的64字节 ZSB 选择公式。GRABSECT3 位于已列 GRABSECT2(+0x14)与 GRABRAM1(+0x1C)之间的+0x18，需在 OTP 准备回读及启动后的 GRABSECT3R 中核对。未明确的 EXEONLY 字段不输出，不把图示当作可烧录的完整64字节表。若实物/官方说明不一致，应先修订准备文件。

## 观察点和验收

以下均为**字节地址**，不要使用 28002x 的 `0x000394xx` 地址或 `0x60` 原始 CR 判据。

| 寄存器 | 地址 | 检查 |
| --- | --- | --- |
| Z1_LINKPOINTER | `0x00219400` | 低14位应选择预期 ZSB |
| Z1_OTPSECLOCK | `0x00219404` | PSWDLOCK 状态，不能仅靠 Flash 读回判断密码是否隐藏 |
| Z1_CR | `0x00219430` | bit22 ARMED、bit21 UNSECURE、bit31 FORCESEC；ALLZERO/ALLONE 单独判断 |
| Z1_GRABSECT3R | `0x0021943C` | `[9:8]` / `[11:10]` 均为01 |
| Z2_GRABSECT3R | `0x002194BC` | 对应字段均为10 |
| SECTSTAT3 | `0x0021950C` | 对应字段均为01，即 Zone1 |
| RAMSTAT1 | `0x00219520` | LS0 A～D 保持非安全，记录实际值 |

串口 `CR>>16` 使用 DriverLib 的 `DCSM_getZone1ControlStatus()` 返回值，已右移16位；例如其 `0x60` 对应原始 CR 的 `0x00600000`，不能混写。每次按键后查询实际状态，不凭请求日志认定成功。ex02 不加入 28002x 的 `Prepare_Zone1_Unlock()` 实验步骤；若 FORCESEC 后再解锁失败，记录寄存器、SDK版本、上电状态及操作顺序，再单独调查。

板级步骤与结果见[独立回归表](../../docs/REGRESSION_HX280013X_EX00_EX02.md)。28002x 的成功次数及保护现象不作为本平台证据。

## 2026-10-24：修正调试工程引用

三个IDE工程名、launch文件名及ELF名统一与目录名一致，例如 `ex00_base_system`、`ex00_base_system.launch`、`Debug/ex00_base_system.elf`。此前的 `hx280013x_` 工程前缀已移除，以兼容由原始空白模板创建的现有工作空间。

更新后先关闭 Debug Configurations，在 Project Explorer 中选中工程按 F5 刷新并重新构建，再打开调试配置。如果此前Debug菜单已因旧launch文件缺失报错，请重启IDE。ex01/ex02需要分别导入本平台对应目录；不要把28002x的同名工程导入同一个工作空间。无需删除源码或整个 `.metadata`。

2026-10-24初始OTP核对：开发者提供的2048字节回读与手册出厂模式一致，两Zone均选中ZSB1；现有48字节准备内容无0变1冲突。详细结果和仍需确认的字段/工具边界见[独立回归表](../../docs/REGRESSION_HX280013X_EX00_EX02.md)。此记录不表示OTP已编程。

TRM复核补充（2026-10-24）：6.6.2节印刷第486～487页明确规定DCSM OTP按32位/4字节对齐，每字只能编程一次，LINKPOINTER为规定例外。现有48字节准备符合此对齐。图5-2仍遗漏GRABSECT3，+0x18属于依据字段清单和相邻地址的交叉推定，未取得显式地址定义；具体下载器对稀疏HEX的处理也不能由TRM硬件粒度推出。详见[原文复核记录](../../docs/REGRESSION_HX280013X_EX00_EX02.md)。

## OTP文件组织与排版

按28002x例程的注释分隔线、`.section` / `.word` 和MEMORY / SECTIONS风格整理；每个安全示例保留以下直接可编辑文件：

```text
Security/
    hx280013x_dcsm_z1otp.S
    hx280013x_dcsm_z2otp.S
    password.h
    BuildOtp.ps1
haawking-drivers/ldscripts/
    HXS320F2800137_EDE_link_FLASH.ld
    DCSM.ld
    Peripheral.ld
    BootROM.ld
```

没有 `Security/otp/` 子目录，也没有 `password_values.h`。`.S` 内密码与配置均为显式十六进制字，`DCSM.ld` 列出两个Zone的完整固定头部及0x40字节ZSB区域，并为字段分组提供对应SECTIONS；`BuildOtp.ps1` 仅作为独立OTP构建入口。

APP主脚本不包含 `DCSM.ld`，两个OTP `.S` 在IDE源排除项中逐文件排除。因此目录和排版与28002x对齐，程序Flash与OTP仍分别生成，未增加默认OTP下载。280013x字段顺序、地址和已记录的TRM待确认项保留。

实验决定（2026-10-24）：开发者已同意采用推定的GRABSECT3=ZSB+0x18布局继续ex01/ex02。当前OTP模板按此定义保持不变，独立OTP准备不再等待这一项的显式手册标注；官方定义与实测结果仍分别记录。

## 完整可复用的OTP模板

模板覆盖280013x新增及重新定义的字段，排版参考28002x，字段和地址采用280013x定义。下表偏移均为**字节偏移**；固定头部基址为Zone1 `0x00640000`、Zone2 `0x00640400`，ZSB偏移相对各自选中的块起点。

| 280013x字段或布局变化 | 固定头部/ZSB偏移 | 适用Zone及说明 |
| --- | --- | --- |
| LINKPOINTER1/2/3 | 头部+0x00/+0x04/+0x08 | 两Zone；三个32位字连续排列，不沿用28002x的间隔保留字 |
| JLM_ENABLE | 头部+0x0C | 仅Zone1；低4位为0xF时禁用JTAGLOCK，其他值启用 |
| GPREG1/2/3/4 | 头部+0x10/+0x14/+0x18/+0x1C | 两Zone；四个独立配置字，不套用28002x的BOOTPIN_CONFIG、BOOTDEF_LOW/HIGH名称和偏移 |
| CRCLOCK | 头部+0x24 | 两Zone；与28002x的+0x28不同，厂商头文件未列出该项，按TRM补齐 |
| JTAGPSWDH0/1 | 头部+0x28/+0x2C | 仅Zone1；128位JTAG密码的[95:64]/[127:96]位，固定头部永久部分 |
| CMACKEY0/1/2/3 | 头部+0x30/+0x34/+0x38/+0x3C | 仅Zone1；安全启动128位密钥，从[31:0]到[127:96]顺序填写 |
| CSMPSWD0/1/2/3 | ZSB+0x00/+0x04/+0x08/+0x0C | 两Zone；密码移至块首，不沿用28002x的块尾布局 |
| GRABSECT1/2/3、GRABRAM1 | ZSB+0x10/+0x14/+0x18/+0x1C | 两Zone；扩展为三个Flash归属字及一个RAM归属字；+0x18按已接受的实验推定 |
| EXEONLYSECT1/2、EXEONLYRAM1 | ZSB+0x28/+0x2C/+0x30 | 两Zone；+0x2C仍属布局推定，默认不输出 |
| JTAGPSWDL0/1 | ZSB+0x38/+0x3C | 仅Zone1；JTAG密码低64位，随选中槽位变化 |

Zone2固定头部+0x0C、+0x28～+0x3C以及ZSB尾部+0x38/+0x3C均保留，不添加Zone1专属字段。两例 `.S` 和 `DCSM.ld` 已同步标注上述差异。已逐项核对厂商 `inc/hw_dcsm.h` 中23个OTP定义及TRM所列OTP字段；运行时的CSMKEY、JTAGKEY、CMACKEY影子寄存器不另作为OTP配置字输出。

两份 `.S` 保留完整字段，不再删去当前例程未启用的配置。**模板完整性与默认输出范围分开管理**：当前ex01/ex02默认输出仍为48字节，其他配置以注释 `.word` 保留；取消注释前填写目标值并核对器件初值。

| 分组 | Zone1 | Zone2 |
| --- | --- | --- |
| LINKPOINTER | 三个副本 | 三个副本 |
| 固定头部 | JLM_ENABLE、GPREG1～4、PSWDLOCK、CRCLOCK、JTAGPSWDH0/1、CMACKEY0～3 | GPREG1～4、PSWDLOCK、CRCLOCK及保留位置 |
| ZSB密码 | CSMPSWD0～3，显式值 | CSMPSWD0～3，保留可编辑的出厂值模板，默认不输出 |
| ZSB归属 | GRABSECT1～3、GRABRAM1 | 同左 |
| ZSB仅执行 | EXEONLYSECT1/2、EXEONLYRAM1，默认不输出 | 同左 |
| ZSB尾部 | JTAGPSWDL0/1及保留位置 | 保留位置 |
| 后续槽位 | 通过DCSM.ld中的ZSB区域起始地址选择，块长0x40 | 同左 |

可选字段按分组使用输入段，链接脚本按固定偏移安放。每个Zone的GPREG1～4合并为 `b0_dcsm_otp_z1_gpreg` / `b0_dcsm_otp_z2_gpreg`，四字顺序排列；EXEONLYSECT1/2合并为 `b0_dcsm_zsel_z1_exeonlysect` / `b0_dcsm_zsel_z2_exeonlysect`，两字顺序排列。两组均须整组启用或整组注释，不能注释组内某一字来跳过地址；链接脚本分别检查段长度为0或0x10、0或0x08，防止不完整输出。启用某组不会移动其他组。密码和密钥分组也必须完整填写；保留字始终保留注释，不为填满0x40块而主动输出。切换ZSB时，除改 `DCSM_ZSEL_Z1/Z2` 的ORIGIN，还需按规则同步LINKPOINTER、该槽位的出厂密码位、应用密钥及launch密码；不能只改链接地址。

ZSB偏移0x20/0x24保留，0x28为EXEONLYSECT1，0x2C为EXEONLYSECT2布局推定，0x30为EXEONLYRAM1，0x34保留，Zone1的0x38/0x3C为JTAGPSWDL0/1。参考Haawking TRM图5-2的显式标注与字段清单，并对照本机C2000Ware 6.00.00.00 F280013x BootROM的 `dcsm_otp_offsets.h` / DCSM示例作结构检查（TI按16位字寻址，其偏移不能直接作为昊芯字节偏移，也不代表两平台行为等同）。未显式标注的+0x2C仍注明推定并默认禁用；此前已接受的GRABSECT3 +0x18实验前提不变。
