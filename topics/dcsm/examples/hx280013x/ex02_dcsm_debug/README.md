# 280013x ex02：调试读取与反复锁定/解锁

目标为 HXS320F2800137_EDE、PM 核心板，Haawking IDE 2.3.17。工程基于开发者提供的空白 DriverLib 工程，厂商驱动保持原样。平台说明、接线、内存、OTP 准备与寄存器地址见[280013x平台说明](../README.md)。

## 运行逻辑

模块及参数布局与 ex01 相同，共用 ZSB1 配置。解锁时计算并输出；锁定时主动暂停模块调用，保留输入输出，LED 继续翻转。按住 SW2 至少 300 ms 后松开，按实际状态选择 FORCESEC 或密码匹配解锁。暂停是应用逻辑，不表示普通 RAM 受保护。

按键等待松手期间，轮询程序暂停；这段时间 LED 也暂停。观察量为非安全 LS0 中的 `g_module_input`、`g_module_output`。SCI 为 GPIO28/29，9600、8N1；LED2 为 GPIO20，SW2 默认 GPIO1。

## 构建与下载

导入 `ex02_dcsm_debug`，让 IDE 重新生成构建文件。当前保留开发者的 OTP 源 Exclude 设置；ELF、`Debug/ex02_dcsm_debug.hex` 和 `Debug/ex02_dcsm_debug_dcsm.hex` 均无 OTP，构建及产物检查通过。此设置用于已有 OTP 器件的 APP 更新。若有意启用两个 OTP 源，须重新构建并核对 60 字节 OTP（含 Z1 三个 LINKPOINTER），届时 ELF 和 `_dcsm.hex` 将含 OTP，普通 HEX 仍仅含程序 Flash。launch 下载实际 ELF，不能只凭文件名判断范围。构建机制见[双HEX说明](../../../docs/HX280013X_DUAL_HEX_BUILD.md)，布局见[链接脚本差异](../../../docs/HX280013X_LINKER_DIFF.md)。

launch 保留模板自动解锁流程，Zone1 演示密码与 `Security/hx280013x_dcsm_z1otp.S` 的四个显式密码字、`Security/password.h` 的应用解锁密钥保持一致。Post-build 从同一默认 ELF 直接转换普通 HEX 和 `_dcsm.hex`。所有脚本只生成文件，不编程器件。本例采用开发配置，PSWDLOCK 保持出厂值，密码隐藏未实现。

## 简要验收

1. 先完成 ex00/ex01 的基础与 OTP 准备，仅下载本例 APP。
2. 调试连接后读取 Z1_CR，确认此时是否自动解锁。解锁时输入输出更新，`0x00614000`起两个 32 位字为 3、7。
3. 按 SW2 锁定，确认 UNSECURE=0；输入输出停止更新，LED 继续闪烁，记录代码和参数读取、调试连接状态。
4. 再按 SW2 解锁，确认实际状态、参数读取和计算恢复。至少连续 3 轮并逐轮记录；失败时保存当前 CR、读取结果与日志，再对照下文的准备读取试验排查。
5. 断电重启，检查 secure 和计算暂停，按键解锁后恢复。

## 当前验证状态

2026-10-24：开发者确认加入应用层准备读取后“这样子可行，我认为ex02通过”。记录为当前 280013x ex02 板级验证通过，不推定具体循环次数、CR 读数或所有分项均有日志。ex01 通过结论独立保留；详细证据见[回归表](../../../validation/hx280013x/REGRESSION_HX280013X_EX00_EX02.md)。

当前两个 OTP 汇编源由开发者 Exclude，默认 ELF 及两份 HEX 均不含 OTP；脚本已支持该模式并输出提示。OTP 源码及链接脚本与 ex01 完全一致，启用两源时计划输出 60 字节（含 Z1 三个值全为 1 的 LINKPOINTER）。当前应用 HEX 为 22706 字节。

## FORCESEC 后解锁准备试验

参考 28002x，应用在原始解锁 API 前调用 `Prepare_Zone1_Unlock()`，只读 Zone1 OTP 头部及活动 ZSB 配置。采用 280013x 的 14 位 LINKPOINTER、0x40 字节 ZSB 步长和字段偏移，厂商 DriverLib 不变。该函数只做 Zone1 解锁前的准备读取，未实现两 Zone 的完整 BootROM 安全初始化，最小必要序列尚未确认；布局推定、访问顺序、构建证据和复测要求见[DCSM-002](../../../docs/errata.md)。本次保留 OTP 源 Exclude 设置，产物不含 OTP，无需重新编程 OTP。开发者已反馈此方案板级验证通过；根因和最小必要读取序列仍待确认。
