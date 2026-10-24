# ex01：Flash 功能模块与参数保护

APP 调用厂家模块的公开接口，由模块读取产品参数并返回结果。本例程在 Zone1 锁定时持续运行，演示正常调用与直接读出受保护内容的区别。

计算与 ex00 相同：输入 1～9 循环，`output = input * 3 + 7`，输出 10～34、步长 3。LED 和 SCI 用于确认程序仍在运行。

## 内存与 OTP

| 内容 | 位置 |
| --- | --- |
| APP、驱动、日志、RAM 初始化镜像 | 普通 APP Flash |
| `ProductModule_Process()` / `module_code` | sector4，`0x00610000..0x00613FFF`，Zone1 |
| `g_module_params[2]` / `module_params` | sector5，`0x00614000..0x00617FFF`，Zone1，内容为 3、7 |
| `g_module_input`、`g_module_output` | 非安全 RAM，具体地址看新 map |
| 原有 `ramfuncs` | 在 RAM 运行，加载镜像位于普通 APP Flash |

模块和参数都使用普通安全保护，未启用 execute-only。参数是公开演示值，结果通过正常接口输出。

本版本和 ex02 共用一套 OTP 目标配置：Zone1 的三个 LINKPOINTER 为 `0x1FFFFFFE`，选中 ZSB2（首个块之后的块），位于 `0x007A0060`；`GRABSECT=0xAAAAA5AA`，sector4/5 均归 Zone1。Z2 保持原配置，仍使用其首个 ZSB；Z1/Z2 的 RAM 设置保持非安全。

旧版本首个 ZSB 的 `0xAAAAA9AA` 无法原位覆盖为新值，因为 bit10 需要从 0 变 1。完整 HEX 不输出旧 Z1 ZSB1，保留其内容。具体配置和一次性准备见[简要回归表](../../../validation/hx28002x/REGRESSION_EX00_EX02.md)，不要为了后续每次下载再切换 ZSB。

`password.h` 与 OTP 使用相同演示密码。三个 LINKPOINTER、ZSB、密码及其工厂已编程位应在写入前一并核对。

## 运行与按键

接线与 ex00 相同，串口 9600、8N1。独立上电应打印安全状态，并持续显示：

```text
[DCSM] Zone1 secure.
[MODULE] input=1 output=10
[MODULE] input=2 output=13
```

按住 KEY 至少 300 ms 后松开，程序打印解锁请求，执行应用层准备读取，再调用原始 `DCSM_unlockZone1CSM()`，最后打印实际状态。KEY 仅请求解锁；重新保护通过断电重启验证。LED 翻转周期固定，不用快慢表示解锁是否成功。

模块位于 Zone1，能够在该 Zone 锁定时读取同 Zone 的参数；普通 APP 不直接读取参数。

应用层 `Prepare_Zone1_Unlock()` 沿用既有补充读取试验，DriverLib 保持原样。该流程的根因、最小必要步骤和 TI 平台对应行为仍待确认，见 [topics/dcsm/docs/errata.md](../../../docs/errata.md)。

## 下载与简要验收

使用默认构建输出 `Debug/ex01_dcsm_secure_flash.hex`，不额外转换 HEX。该文件包含 OTP 目标数据；首次配置前核对全部 OTP 字段及当前芯片内容，日常仅更新程序时必须在下载工具中明确排除 USER OTP。调试器加载 ELF 时也要核对实际下载范围；工具若不支持排除 OTP，不应直接执行仅更新程序的下载。

新版板级回归只检查：独立上电为 secure 且结果符合公式；KEY 解锁成功；断电重启恢复 secure。sector4/5 的读保护对照可随 ex02 一次完成，记录在[简要回归表](../../../validation/hx28002x/REGRESSION_EX00_EX02.md)。

2026-10-22 开发者确认本次模块版本简要板级回归通过：ZSB2 先写入并回读校验，随后三个 LINKPOINTER 切换为 `0x1FFFFFFE`，其他 OTP 保持不变；独立上电为 secure，LED 和计算正常，KEY 解锁成功，断电重启恢复 secure。同日使用相同布局与 OTP 的 ex02 完成 sector4/5 读取对照：锁定时代码和参数读回零，解锁时代码可读、参数为 3 和 7，详见[回归记录](../../../validation/hx28002x/REGRESSION_EX00_EX02.md)。

原 SPWM 版本已验证：锁定运行、密码解锁、断电恢复及 downloader 正确/错误密码回读对照。这些旧布局记录继续保留，不替代新布局的读取保护验证。
