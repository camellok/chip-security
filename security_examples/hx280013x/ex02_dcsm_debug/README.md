# 280013x ex02：调试读取与反复锁定/解锁

目标为 HXS320F2800137_EDE、PM核心板，Haawking IDE 2.3.17。由用户提供的空白工程配置，DriverLib保持原样。平台说明、接线、内存、OTP准备与寄存器地址见[280013x平台说明](../README.md)。

## 运行逻辑

模块及参数布局与 ex01 相同，共用 ZSB1 配置。解锁时计算并输出；锁定时主动暂停模块调用，保留输入输出，LED 继续翻转。按住 SW2 至少300 ms后松开，按实际状态选择 FORCESEC 或密码匹配解锁。暂停是应用逻辑，不表示普通 RAM 受保护。

按键等待松手期间，轮询程序暂停；这段时间LED也暂停。观察量为非安全 LS0 中的 `g_module_input`、`g_module_output`。SCI 为 GPIO28/29，9600、8N1；LED2 为 GPIO20，SW2 默认 GPIO1。

## 构建与下载

导入 `ex02_dcsm_debug`，让 IDE 重新生成构建文件。默认APP ELF和普通HEX不含OTP。每次Build生成 `Debug/ex02_dcsm_debug.hex`（仅程序Flash）和 `Debug/ex02_dcsm_debug_dcsm.hex`（程序Flash+DCSM配置），Clean/Rebuild同时清除两份HEX。构建原理、失败清理及手动命令见[双HEX构建说明](../../../docs/HX280013X_DUAL_HEX_BUILD.md)。使用应用层 `haawking-drivers/ldscripts/HXS320F2800137_EDE_link_FLASH.ld`，工程内已删除未使用的厂商原版Flash/RAM主脚本；[具体差异](../../../docs/HX280013X_LINKER_DIFF.md)已记录。

launch 保留模板自动解锁流程，Zone1演示密码与 `Security/hx280013x_dcsm_z1otp.S` 的四个显式密码字、`Security/password.h` 的应用解锁密钥保持一致。Post-build自动调用 `Security/BuildOtp.ps1` 重新构建OTP准备数据，并合成 `_dcsm.hex`；也可单独手动构建。所有脚本只生成文件，不编程器件。本例采用开发配置，PSWDLOCK保持出厂值，密码隐藏未实现。

## 简要验收

1. 先完成 ex00/ex01 的基础与 OTP 准备，仅下载本例 APP。
2. 调试连接后读取 Z1_CR，确认此时是否自动解锁。解锁时输入输出更新，`0x00614000`起两个32位字为3、7。
3. 按 SW2 锁定，确认 UNSECURE=0；输入输出停止更新，LED继续闪烁，记录代码和参数读取、调试连接状态。
4. 再按 SW2 解锁，确认实际状态、参数读取和计算恢复。至少连续3轮并逐轮记录；失败时保留现场，不加入未经验证的补充读取步骤。
5. 断电重启，检查 secure 和计算暂停，按键解锁后恢复。

## 当前验证状态

2026-10-23：构建及产物检查通过，板级待验证；详细证据与待填项见[280013x独立回归表](../../../docs/REGRESSION_HX280013X_EX00_EX02.md)。未继承28002x平台的板级验收结果。
