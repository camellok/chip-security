# 280013x ex01/ex02：默认完整ELF与双HEX构建

状态更新：2026-10-24。ex01含OTP和ex02主动Exclude OTP两种构建均通过。ex02已加入应用层解锁准备，开发者反馈板级验证通过。源排除后的无OTP构建已支持，不再作为配置故障。详见[回归表](../validation/hx280013x/REGRESSION_HX280013X_EX00_EX02.md)。

## 目标输出与当前差异

按开发者要求，ex01/ex02的目标是各保留一份默认应用ELF，包含APP、调试符号和当前启用的OTP配置段。启用OTP源时符合下表；当前ex02保留开发者Exclude设置，ELF及两份HEX均不含OTP。

| 文件 | 内容 | 使用方式 |
| --- | --- | --- |
| `Debug/<工程名>.elf` | APP＋OTP＋调试符号 | 现有launch使用此文件 |
| `Debug/<工程名>.hex` | 仅程序Flash | 日常Flash更新 |
| `Debug/<工程名>_dcsm.hex` | APP＋OTP | 有意编程OTP时使用 |

默认ELF已包含OTP，因此通过现有launch下载该ELF时，下载器也会收到OTP段。已经编程过OTP的器件，后续更新应使用普通HEX，或使用工具明确支持的仅Flash下载设置。包含OTP段不保证密码或OTP始终可回读，实际读取仍取决于保护状态和工具行为。构建脚本不连接硬件，不自动编程OTP。

## 工程配置

包含OTP时的配置（也支持主动Exclude后的无OTP模式）：

1. `.cproject`中两个 `Security/hx280013x_dcsm_z1otp.S`、`hx280013x_dcsm_z2otp.S`参与正常编译，不再设置Exclude from Build。
2. `haawking-drivers/ldscripts/HXS320F2800137_EDE_link_FLASH.ld`在APP布局之后包含 `DCSM.ld`。后者将启用的OTP段固定放到USER OTP地址，并用KEEP保留，避免被 `--gc-sections` 删除。
3. `makefile.targets`把APP主脚本、Peripheral.ld、BootROM.ld和DCSM.ld列为ELF依赖；OTP源由IDE生成的编译规则跟踪，修改源或链接布局会重新链接默认ELF。
4. `.launch`仍指向 `Debug/ex01_dcsm_secure_flash.elf` 或 `Debug/ex02_dcsm_debug.elf`；下载和符号使用该工程默认ELF，不增加第二份应用ELF或调试配置。

IDE中Refresh工程并重新生成构建文件；不要手改Debug目录的生成makefile。

## 构建顺序与实现原理

- Pre-build删除两份旧HEX及各自临时文件。
- 正常编译和链接生成唯一的APP＋OTP ELF。
- Post-build执行 `Security/BuildHex.ps1`，使用IDE自带objcopy从同一ELF转换两份文件：

```text
riscv32-haawking-elf-objcopy -O ihex --remove-section=.dcsm* <工程名>.elf <工程名>.hex.tmp
riscv32-haawking-elf-objcopy -O ihex <工程名>.elf <工程名>_dcsm.hex.tmp
```

普通HEX按输出段名移除OTP，完整HEX直接保留ELF中的全部可转换数据。脚本不会修改ELF，也不再通过独立OTP ELF合并HEX。

脚本检查Intel HEX校验和、记录长度、结束记录、重复地址和地址范围：普通HEX仅允许程序Flash `[0x00600000,0x00640000)`；完整HEX除完全一致的APP数据外，只允许USER OTP `[0x00640000,0x00640800)`，允许OTP数据为0字节。启动地址记录保持一致。不填充地址空洞；RAM运行函数和初始化data按Flash加载地址LMA进入HEX。两份文件均核验成功后才发布，失败则删除两份最终HEX和临时文件，并让make报错。

## Clean与增量构建

版本化 `makefile.targets`通过IDE生成makefile的include接入实际脚本。脚本放在pre-build、post-build的前置规则中，保证错误不会被IDE生成命令的忽略错误前缀掩盖。

Clean Project、Rebuild Project清理两份HEX；每次标准Build/`make all`均重新转换两份HEX，即使ELF无需重链接。直接执行内部 `main-build`或单个ELF目标会跳过完整HEX构建阶段。

```powershell
$ide = 'D:\Haawking-IDE-2.3.17'
$env:Path = "$ide\haawking-tools\compiler\Haawking-RISCV-LLVM\bin;$ide\haawking-tools\compiler\bin;$env:Path"
make -C topics/dcsm/examples/hx280013x/ex01_dcsm_secure_flash/Debug all
make -C topics/dcsm/examples/hx280013x/ex01_dcsm_secure_flash/Debug clean
```

脚本默认IDE路径为 `D:\Haawking-IDE-2.3.17`，可通过 `-IdeRoot`覆盖。独立OTP构建脚本已删除，当前仅通过默认ELF生成两份HEX。历史 `Debug/otp/`产物不代表本轮默认Build结果。

## 当前OTP差异

ex01启用了Zone1三个LINKPOINTER，地址 `0x00640000/04/08`、值均为 `0xFFFFFFFF`，共新增12字节；ex02的OTP源码现已与ex01对齐，也启用这些字段；当前ex02排除了OTP源，实际产物不含OTP。两例原有ZSB密码及GRAB配置保持不变。全1LINKPOINTER的低14位表示ZSB1，不能将已经清零的OTP位恢复为1。GRABSECT3的ZSB偏移+0x18沿用开发者已接受的实验布局。

旧的APP不含OTP、独立OTP合并方案已由本方案替代；旧回归记录仅表示当时的行为。

## 2026-10-24默认完整ELF验证

按开发者确认，ex01/ex02默认ELF改为包含APP和当前启用的OTP段；取消OTP源的构建排除，APP主脚本包含DCSM.ld。两份HEX均从同一ELF转换，普通HEX移除.dcsm*段，完整HEX保留。默认Build不再生成独立OTP ELF。

两例Clean确认普通HEX和_dcsm.hex均被清除，随后完整重建通过。直接解析ELF段表及段数据，确认OTP地址和值与源码一致；独立objcopy转换结果与完整HEX逐字节相同，普通HEX仅含程序Flash，完整HEX精确等于普通HEX与OTP数据的并集，无填充。ex01保留开发者启用的Z1 LINKPOINTER，共60字节OTP；ex02为48字节。APP分别为22322、22570字节。ex01完整HEX内容及SHA256与修改ELF前的已核验文件一致。

此次未连接硬件、未编程OTP，也未新增板级验证结论。此前APP ELF不含OTP的记录仅描述旧方案；当前launch下载默认ELF会包含OTP段。


## 排除OTP汇编源后的构建

在IDE中将两个OTP汇编源设置为Exclude from Build并重新生成构建文件后，默认ELF不含OTP。此时BuildHex.ps1仍生成两份HEX，两者应用数据相同，均不含OTP；控制台明确输出 `OTP not present in ELF: both HEX files contain APP data only.`。`_dcsm`后缀不保证本轮ELF启用了OTP，实际内容以构建日志和地址记录为准。重新启用源文件后，完整HEX自动恢复包含OTP。切换排除设置后建议执行Rebuild，保证ELF反映当前源配置。地址、校验和和数据一致性检查继续保留。
