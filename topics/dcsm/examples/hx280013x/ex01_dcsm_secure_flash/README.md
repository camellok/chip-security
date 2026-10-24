# 280013x ex01：安全 Flash 与按键解锁

目标为 HXS320F2800137_EDE、PM 核心板，Haawking IDE 2.3.17。工程基于开发者提供的空白 DriverLib 工程，厂商驱动保持原样。平台说明、接线、内存、OTP 准备与寄存器地址见[280013x平台说明](../README.md)。

## 运行逻辑

模块代码在 Zone1 扇区 32～39，参数在 Zone1 扇区 40～47。锁定状态仍持续调用模块并打印计算结果；按住 SW2 至少 300 ms 后松开，调用原始 `DCSM_unlockZone1CSM()` 并输出操作后的真实状态。按键只解锁，不反复切换。

按键等待松手期间，轮询程序暂停；这段时间 LED 也暂停。观察量为非安全 LS0 中的 `g_module_input`、`g_module_output`。SCI 为 GPIO28/29，9600、8N1；LED2 为 GPIO20，SW2 默认 GPIO1。

## 构建与下载

导入 `ex01_dcsm_secure_flash`，让 IDE 重新生成构建文件。默认 ELF 包含 APP 和 OTP 配置；普通 HEX 不含 OTP。现有 launch 下载默认 ELF 时也会包含 OTP 段，已配置 OTP 后的日常更新请使用普通 HEX 或工具支持的仅 Flash 下载设置。每次 Build 生成 `Debug/ex01_dcsm_secure_flash.hex`（仅程序 Flash）和 `Debug/ex01_dcsm_secure_flash_dcsm.hex`（程序 Flash+DCSM 配置），Clean/Rebuild 同时清除两份 HEX。构建原理、失败清理及手动命令见[双HEX构建说明](../../../docs/HX280013X_DUAL_HEX_BUILD.md)。使用应用层 `haawking-drivers/ldscripts/HXS320F2800137_EDE_link_FLASH.ld`，工程内已删除未使用的厂商原版 Flash/RAM 主脚本；[具体差异](../../../docs/HX280013X_LINKER_DIFF.md)已记录。

launch 保留模板自动解锁流程，Zone1 演示密码与 `Security/hx280013x_dcsm_z1otp.S` 的四个显式密码字、`Security/password.h` 的应用解锁密钥保持一致。Post-build 从同一默认 ELF 直接转换普通 HEX 和 `_dcsm.hex`。所有脚本只生成文件，不编程器件。本例采用开发配置，PSWDLOCK 保持出厂值，密码隐藏未实现。

## 简要验收

1. 先完成 ex00；按平台说明备份并人工核对 OTP，仅在确认兼容时准备共用配置。
2. 下载 APP 并断电上电，检查 secure 状态，LED 和模块计算应持续正常。
3. 接入调试器后重新读取 Z1_CR；自动解锁可能改变当前状态。
4. 在可保持 secure 的调试条件下，记录代码/参数直接读取结果。SW2 解锁后确认状态及参数 3、7 可读；若 CPU 停在安全代码导致连接中断，按平台手册使用等待引导方式处理。
5. 断电重启检查保护恢复，填写回归表。

## 当前验证状态

2026-10-24：开发者反馈当前 ex01 板级验证通过。记录为本平台、本示例的整体验证结论；本次未提供逐项日志、寄存器实测值、OTP 写后回读或循环次数，详细记录见[280013x独立回归表](../../../validation/hx280013x/REGRESSION_HX280013X_EX00_EX02.md)。未继承 28002x 平台的板级验收结果。

实现进度：安全 Flash 开发配置、完整 OTP 字段模板、GPREG/EXEONLYSECT 分组和精简链接脚本已完成；完整 ELF 及双 HEX 的构建、Clean 和输出范围检查通过。当前 OTP 为 60 字节，其中三个 Zone1 全 1 LINKPOINTER 占 12 字节，ZSB 密码及 GRAB 占 48 字节。普通 HEX 仅含程序 Flash，默认 ELF 和_dcsm.hex 含 APP+OTP。

后续工作：补录本例分项实测证据，另行实现并验证 PSWDLOCK 密码隐藏对照；该对照不计入当前开发配置的已完成范围。平台后续例程进度见[开发路线](../../../../../docs/ROADMAP.md)。
