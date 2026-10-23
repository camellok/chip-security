# 280013x 平台：ex00～ex02

本目录以开发者提供的 HXS320F2800137_EDE 空白 DriverLib 工程为模板，使用 Haawking IDE 2.3.17。平台统称为 **280013x**；当前具体目标为 **2800137_EDE、PM 核心板**，不代表其他容量、封装或修订均已验证。三个工程已完成构建及产物检查，板级验证待完成。

| 工程目录 | IDE 工程名称 | 演示 |
| --- | --- | --- |
| [ex00_base_system](ex00_base_system/README.md) | `hx280013x_ex00_base_system` | 未保护的 LED、SCI、按键和厂家模块基线 |
| [ex01_dcsm_secure_flash](ex01_dcsm_secure_flash/README.md) | `hx280013x_ex01_dcsm_secure_flash` | Zone1 锁定运行，按键解锁 |
| [ex02_dcsm_debug](ex02_dcsm_debug/README.md) | `hx280013x_ex02_dcsm_debug` | 按键反复锁定/解锁及调试读取对照 |

IDE 工程名带平台前缀，可以与 28002x 工程一起导入。目录编号、`src/`、`Driver/`、`Algorithms/`、函数接口和轮询日志风格沿用 28002x。模板自带的 `haawking-drivers/` 与库文件保持原样。

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

应用链接脚本位于各工程 `src/HXS320F2800137_EDE_link_FLASH.ld`。IDE 源排除项排除厂商同名 Flash 脚本，链接搜索路径将 `../src` 放在前面；生成的链接命令应只选择应用脚本。厂商原脚本保留供对照。不要添加第二个完整 `-T` 脚本，避免重复定义内存区域。仅提供本次 Flash 运行演示，RAM 调试布局不作为本次验证范围。

启动 `_init()` 先清 bss，再复制 ramfunc/data。两份加载镜像均在普通 APP Flash，LS0 全部非安全；不套用 28002x 的 LS4～LS7 / GS0 声明。链接断言约束模块大小、参数大小及 APP 加载镜像上界。

## 导入、构建和程序更新

1. 在 Haawking IDE 2.3.17 中导入本目录三个工程，选择 Debug / FLASH，由 IDE 生成构建文件。
2. 核对编译宏 `DSC2800137_EDE`、DriverLib 路径和应用链接脚本。工具链使用 IDE 自带版本。
3. 构建后查看 `Debug/hx280013x_<例程名>.elf`、`.hex`、`.map`。程序 HEX **只有程序 Flash，不包含 USER OTP**。
4. 日常切换 ex01/ex02 只下载相应 APP；它们共用同一 OTP 配置。用演示密钥解锁后再更新受保护 Flash，记录下载工具实际行为。

IDE 生成 makefile 后，也可在 PowerShell 构建：

```powershell
$ide = 'D:\Haawking-IDE-2.3.17'
$env:Path = "$ide\haawking-tools\compiler\Haawking-RISCV-LLVM\bin;$ide\haawking-tools\compiler\bin;$env:Path"
make -C security_examples/hx280013x/ex02_dcsm_debug/Debug -B all
```

launch 继承模板的 `monitor hx_c_unlock 0` 自动解锁流程。ex01/ex02 的 Zone1 密码项已改为本例程演示值，Zone2 保留模板的出厂 ZSB1 值。launch 的构建配置 ID 与 `.cproject` 已同步。连接后不一定仍处于 secure，以实时寄存器为准。JTAG 密码字段属于模板连接配置，不表示本例启用了芯片的 JTAGLOCK；程序和 OTP 模板均不启用它。

## 一次性 OTP 准备

**工程不会自动编程 OTP。** ex01/ex02 的 `Security/otp/` 被排除在默认 APP 构建之外，只提供独立的手动构建脚本：

```powershell
& ./security_examples/hx280013x/ex01_dcsm_secure_flash/Security/otp/BuildOtp.ps1
```

脚本仅生成 `Debug/otp/hx280013x_dcsm_zsb1.{elf,hex,map}`。ex02 的对应源码及产物内容相同。程序 HEX 与 OTP HEX 必须分别核对，不能合并成默认下载镜像。

该准备文件**只适用于事先确认兼容的 ZSB1 新器件**：三个14位 LINKPOINTER 的有效值均应为 `0x3FFF`，Z1/Z2 活动 ZSB 地址分别为 `0x00640040` / `0x00640440`，块步长为 `0x40` 字节。手册表5-3将首块称为 Block0，图5-1称为 ZSB1，本目录统一用 ZSB1。已使用其他槽位或已写字段的器件，需另行规划，不能覆盖套用。

| 输出范围 | 内容 |
| --- | --- |
| `0x00640040`～`0x0064004F` | Z1 演示密码：`11111111 00222222 33333333 44444444` |
| `0x00640050`～`0x0064005F` | Z1 GRABSECT1/2/3、GRABRAM1：`AAAAAAAA AAAAAAAA AAAAA5FF FFFFFFAA` |
| `0x00640450`～`0x0064045F` | Z2 GRABSECT1/2/3、GRABRAM1：`AAAAAAAA AAAAAAAA AAAAAAFF FFFFFFAA` |

Z1 密码第二字保留手册所列 ZSB1 出厂值 `0x4D7FFFFF` 的零位，C 和汇编共用 `Security/password_values.h`。实际芯片初始 OTP 仍必须单独备份、核对，不以手册默认值代替实物回读。Zone2 的密码不输出，保留其出厂状态。

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
