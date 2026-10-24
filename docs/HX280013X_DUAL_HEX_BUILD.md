# 280013x ex01/ex02：双HEX构建

普通Build会生成两份文件：

| 工程 | 仅程序Flash | 程序Flash和DCSM配置 |
| --- | --- | --- |
| ex01 | `Debug/ex01_dcsm_secure_flash.hex` | `Debug/ex01_dcsm_secure_flash_dcsm.hex` |
| ex02 | `Debug/ex02_dcsm_debug.hex` | `Debug/ex02_dcsm_debug_dcsm.hex` |

正常名称的HEX用于日常程序Flash更新；`_dcsm.hex`包含OTP配置，仅在确认需要配置OTP时人工选择。构建脚本只生成文件，不执行任何下载。APP ELF始终不含OTP，现有launch继续使用APP ELF。

## 执行顺序和原理

1. **Pre-build**：删除两份旧HEX及临时文件，避免本轮编译/链接失败后误用上次的镜像。
2. **编译与链接**：生成本轮APP ELF；两个OTP汇编源仍排除在APP构建之外，APP主脚本不包含 `DCSM.ld`。
3. **Post-build**：`Security/BuildHex.ps1`调用IDE自带 `riscv32-haawking-elf-objcopy -O ihex --remove-section=.dcsm*`，生成不含DCSM的程序HEX临时文件，并检查所有数据记录位于程序Flash范围。
4. 同一脚本调用 `Security/BuildOtp.ps1`，用当前OTP汇编和 `haawking-drivers/ldscripts/DCSM.ld`重新构建独立OTP ELF/HEX。当前默认配置输出48字节。
5. 按绝对字节地址合并APP和OTP数据记录，生成 `_dcsm.hex`。合并检查校验和、地址范围、重复地址及APP/OTP重叠，重新核验合并结果；保持APP启动地址记录，不填充地址空洞。
6. 两份HEX均核验成功后才发布最终文件。任一阶段失败则删除两份最终HEX和临时文件，并使构建报错。

转换必须在本轮链接结束后执行。Pre-build时本轮ELF尚不存在或仍是旧版本，因此Pre-build只清理，转换和合并在Post-build进行。

这是对现有APP/OTP分离方案的扩展：不将OTP链接进调试用APP ELF，仅在HEX层生成完整镜像。`--remove-section=.dcsm*`按ELF输出段名过滤，APP地址范围校验提供额外检查；RAM运行函数和初始化data按Flash加载地址LMA进入程序HEX。

## IDE配置与Clean

`.cproject`配置非空的Pre-build/Post-build阶段并关闭默认单HEX转换，避免它与双HEX脚本重复生成同名文件。工程根目录的版本化 `makefile.targets`通过IDE生成makefile底部的include接入实际脚本：

- `pre-build`及 `clean` 的前置规则删除两份HEX；因此Clean Project、Rebuild Project的清理阶段都会删除两份文件。
- `post-build` 的前置规则生成两份HEX。IDE生成的配置命令带忽略错误前缀，实际脚本放在前置规则中执行，保证脚本失败会传递为make失败。
- 每次执行标准Build/`make all`都会执行这两个阶段，即使APP无需重新链接，OTP源和OTP链接脚本仍会重新构建，因此只改OTP不会留下旧的 `_dcsm.hex`。
- APP主链接脚本和两个映射依赖也显式列为ELF依赖，修改链接布局后会重新链接。

不修改 `Debug/` 内的生成makefile。更新源码后在IDE中Refresh项目并重新生成构建文件。直接调用 `make main-build`、单个 `.elf`目标等内部目标会跳过完整构建阶段；发布HEX应执行Build Project或 `make all`。

## 手动命令

先由IDE生成构建文件，再使用IDE工具链：

```powershell
$ide = 'D:\Haawking-IDE-2.3.17'
$env:Path = "$ide\haawking-tools\compiler\Haawking-RISCV-LLVM\bin;$ide\haawking-tools\compiler\bin;$env:Path"
make -C security_examples/hx280013x/ex01_dcsm_secure_flash/Debug all
make -C security_examples/hx280013x/ex01_dcsm_secure_flash/Debug clean
```

需要手动转换现有APP ELF时，在工程 `Debug` 目录执行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ../Security/BuildHex.ps1 -ProjectName ex01_dcsm_secure_flash -BuildDirectory .
```

脚本默认使用 `D:\Haawking-IDE-2.3.17`；安装路径不同时，可在 `makefile.targets` 的生成命令添加 `-IdeRoot`，或手动调用时指定该参数。使用Windows PowerShell 5.1即可，不依赖额外Python安装。

## 验证范围

本次验证覆盖IDE重新生成构建文件、两例Clean/Rebuild、无改动增量Build、隔离副本中只改OTP后的更新、OTP构建错误和APP构建错误后的双HEX清理。检查完整HEX恰好等于APP数据与当前48字节OTP数据的并集，默认HEX无OTP，且合并保留空洞。故障注入不修改实际工程的OTP配置，不连接硬件。

构建通过不代表OTP已写入，也不新增ex01/ex02板级验证结论。

## 2026-10-24验证结果

两例Clean、Rebuild、无改动增量Build均通过；无改动Build不重链接APP ELF，但会重新发布两份HEX。带空格路径的隔离副本中，仅修改OTP源后APP HEX与ELF保持不变，完整HEX中相应OTP字更新。OTP链接失败、APP构建失败均返回非零，并确认两份HEX及临时文件均不残留；恢复配置后可重新生成。

| 示例 | 普通HEX有效字节 | DCSM有效字节 | `_dcsm.hex`有效字节 |
| --- | --- | --- | --- |
| ex01 | 22322 | 48 | 22370 |
| ex02 | 22570 | 48 | 22618 |

完整HEX的数据地址和值精确等于普通HEX与独立OTP HEX的并集，启动记录相同，没有空洞填充。没有执行硬件下载或OTP编程。
