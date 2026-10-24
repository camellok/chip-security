# 280013x ex01/ex02：默认完整 ELF 与双 HEX 构建

状态更新：2026-10-24。ex01 含 OTP 和 ex02 主动 Exclude OTP 两种构建均通过。ex02 已加入应用层解锁准备，开发者反馈板级验证通过。构建脚本支持排除 OTP 源后的应用更新。详见[回归表](../validation/hx280013x/REGRESSION_HX280013X_EX00_EX02.md)。

## 目标输出与当前差异

按开发者要求，ex01/ex02 的目标是各保留一份默认应用 ELF，包含 APP、调试符号和当前启用的 OTP 配置段。启用 OTP 源时符合下表；当前 ex02 保留开发者 Exclude 设置，ELF 及两份 HEX 均不含 OTP。

| 文件 | 内容 | 使用方式 |
| --- | --- | --- |
| `Debug/<工程名>.elf` | APP＋OTP＋调试符号 | 现有 launch 使用此文件 |
| `Debug/<工程名>.hex` | 仅程序 Flash | 日常 Flash 更新 |
| `Debug/<工程名>_dcsm.hex` | APP＋OTP | 有意编程 OTP 时使用 |

启用 OTP 源后，默认 ELF 包含 OTP，通过现有 launch 下载时，下载器也会收到这些段。当前 ex02 排除 OTP 源，其 ELF 不含 OTP。已经编程过 OTP 的器件，后续更新应使用普通 HEX，或使用工具明确支持的仅 Flash 下载设置。包含 OTP 段不保证密码或 OTP 始终可回读，实际读取仍取决于保护状态和工具行为。构建脚本不连接硬件，不自动编程 OTP。

## 工程配置

包含 OTP 时的配置（也支持主动 Exclude 后的无 OTP 模式）：

1. `.cproject` 中两个 `Security/hx280013x_dcsm_z1otp.S`、`hx280013x_dcsm_z2otp.S`参与正常编译；若只更新应用，可将两源设为 Exclude from Build。
2. `haawking-drivers/ldscripts/HXS320F2800137_EDE_link_FLASH.ld`在 APP 布局之后包含 `DCSM.ld`。后者将启用的 OTP 段固定放到 USER OTP 地址，并用 KEEP 保留，避免被 `--gc-sections` 删除。
3. `makefile.targets`把 APP 主脚本、Peripheral.ld、BootROM.ld 和 DCSM.ld 列为 ELF 依赖；OTP 源由 IDE 生成的编译规则跟踪，修改源或链接布局会重新链接默认 ELF。
4. `.launch`仍指向 `Debug/ex01_dcsm_secure_flash.elf` 或 `Debug/ex02_dcsm_debug.elf`；下载和符号使用该工程默认 ELF，不增加第二份应用 ELF 或调试配置。

IDE 中 Refresh 工程并重新生成构建文件；不要手改 Debug 目录的生成 makefile。

## 构建顺序与实现原理

- Pre-build 删除两份旧 HEX 及各自临时文件。
- 正常编译和链接生成默认 ELF，包含 APP 及本轮启用的 OTP 段。
- Post-build 执行 `Security/BuildHex.ps1`，使用 IDE 自带 objcopy 从同一 ELF 转换两份文件：

```text
riscv32-haawking-elf-objcopy -O ihex --remove-section=.dcsm* <工程名>.elf <工程名>.hex.tmp
riscv32-haawking-elf-objcopy -O ihex <工程名>.elf <工程名>_dcsm.hex.tmp
```

普通 HEX 按输出段名移除 OTP，完整 HEX 直接保留 ELF 中的全部可转换数据。脚本不会修改 ELF，也不再通过独立 OTP ELF 合并 HEX。

脚本检查 Intel HEX 校验和、记录长度、结束记录、重复地址和地址范围：普通 HEX 仅允许程序 Flash `[0x00600000,0x00640000)`；完整 HEX 除完全一致的 APP 数据外，只允许 USER OTP `[0x00640000,0x00640800)`，允许 OTP 数据为 0 字节。启动地址记录保持一致。不填充地址空洞；RAM 运行函数和初始化 data 按 Flash 加载地址 LMA 进入 HEX。两份文件均核验成功后才发布，失败则删除两份最终 HEX 和临时文件，并让 make 报错。

## Clean 与增量构建

版本化 `makefile.targets`通过 IDE 生成 makefile 的 include 接入实际脚本。脚本放在 pre-build、post-build 的前置规则中，保证错误不会被 IDE 生成命令的忽略错误前缀掩盖。

Clean Project、Rebuild Project 清理两份 HEX；每次标准 Build/`make all`均重新转换两份 HEX，即使 ELF 无需重链接。直接执行内部 `main-build`或单个 ELF 目标会跳过完整 HEX 构建阶段。

```powershell
$ide = 'D:\Haawking-IDE-2.3.17'
$env:Path = "$ide\haawking-tools\compiler\Haawking-RISCV-LLVM\bin;$ide\haawking-tools\compiler\bin;$env:Path"
make -C topics/dcsm/examples/hx280013x/ex01_dcsm_secure_flash/Debug all
make -C topics/dcsm/examples/hx280013x/ex01_dcsm_secure_flash/Debug clean
```

脚本默认 IDE 路径为 `D:\Haawking-IDE-2.3.17`，可通过 `-IdeRoot`覆盖。独立 OTP 构建脚本已删除，当前仅通过默认 ELF 生成两份 HEX。历史 `Debug/otp/`产物不代表本轮默认 Build 结果。

## 当前 OTP 差异

ex01 启用了 Zone1 三个 LINKPOINTER，地址 `0x00640000/04/08`、值均为 `0xFFFFFFFF`，共新增 12 字节；ex02 的 OTP 源码现已与 ex01 对齐，也启用这些字段；当前 ex02 排除了 OTP 源，实际产物不含 OTP。两例原有 ZSB 密码及 GRAB 配置保持不变。值全为 1 的 LINKPOINTER，其低 14 位表示 ZSB1，不能将已经清零的 OTP 位恢复为 1。GRABSECT3 的 ZSB 偏移+0x18 沿用开发者已接受的实验布局。

旧的 APP 不含 OTP、独立 OTP 合并方案已由本方案替代；旧回归记录仅表示当时的行为。

## 2026-10-24 默认完整 ELF 验证（历史记录）

按开发者确认，ex01/ex02 默认 ELF 改为包含 APP 和当前启用的 OTP 段；取消 OTP 源的构建排除，APP 主脚本包含 DCSM.ld。两份 HEX 均从同一 ELF 转换，普通 HEX 移除.dcsm*段，完整 HEX 保留。默认 Build 不再生成独立 OTP ELF。

两例 Clean 确认普通 HEX 和_dcsm.hex 均被清除，随后完整重建通过。直接解析 ELF 段表及段数据，确认 OTP 地址和值与源码一致；独立 objcopy 转换结果与完整 HEX 逐字节相同，普通 HEX 仅含程序 Flash，完整 HEX 精确等于普通 HEX 与 OTP 数据的并集，无填充。ex01 保留开发者启用的 Z1 LINKPOINTER，共 60 字节 OTP；ex02 为 48 字节。APP 分别为 22322、22570 字节。ex01 完整 HEX 内容及 SHA256 与修改 ELF 前的已核验文件一致。

此次未连接硬件、未编程 OTP，也未新增板级验证结论。上述 48 字节 ex02 结果来自当时的源码和构建配置；当前源码已同步 Z1 LINKPOINTER，启用后为 60 字节，但默认排除 OTP 源。launch 始终下载实际 ELF。


## 排除 OTP 汇编源后的构建

在 IDE 中将两个 OTP 汇编源设置为 Exclude from Build 并重新生成构建文件后，默认 ELF 不含 OTP。此时 BuildHex.ps1 仍生成两份 HEX，两者应用数据相同，均不含 OTP；控制台明确输出 `OTP not present in ELF: both HEX files contain APP data only.`。`_dcsm`后缀不保证本轮 ELF 启用了 OTP，实际内容以构建日志和地址记录为准。重新启用源文件后，完整 HEX 自动恢复包含 OTP。切换排除设置后建议执行 Rebuild，保证 ELF 反映当前源配置。地址、校验和和数据一致性检查继续保留。
