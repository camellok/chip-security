# ex04 构建与产物检查记录

2026-10-22，使用 Haawking IDE 2.3.17 随附工具链和本地生成的 make 模板执行 Flash 配置 `-B all`，退出码0。本记录仅为主机证据，未烧录、未写 OTP，板级测试待完成。

```powershell
$ide = 'D:\Haawking-IDE-2.3.17'
$env:Path = "$ide\haawking-tools\compiler\Haawking-RISCV-LLVM\bin;$ide\haawking-tools\compiler\bin;$env:Path"
make -C topics/dcsm/examples/hx28002x/ex04_dcsm_secure_ram/Debug -B all
```

构建存在脚手架沿用的编译阶段链接参数未使用警告；size 为 text=25014、data=48、bss=24 字节，bss 统计含寄存器文件 NOBITS。生成物与构建日志位于忽略提交的 Debug 目录；导入 IDE 后应重新生成构建文件。工程 XML 可解析，未发现旧 ex01 工程路径。

## ELF 与反汇编

| 项目 | 地址 / 检查结果 |
| --- | --- |
| `module_work` / `s_module_work` | `0x00010000`，4字节 SHT_NOBITS |
| DATA 范围 | `0x00012000..0x00012030`，结束地址不包含 |
| RAMFUNC 范围 | `0x00012030..0x00012330` |
| BSS 清零范围 | `0x00012330..0x00012340` |
| GS0 复制范围 | 起止均为 `0x00018000`，当前为空 |
| DATA 加载镜像 | `0x00605E30..0x00605E60` |
| RAMFUNC 加载镜像 | `0x00605E60..0x00606160` |
| 栈顶符号 / 初始 sp | `0xFE8` / `0xFE0`，M0/M1，16字节对齐 |
| 模块初始化 / 处理入口 | `0x00610000` / `0x0061000C` |
| 参数 | `0x00614000`，8字节，3和7 |
| APP 直接读取函数 | `0x006006C6`，非安全 APP Flash |

LS4 工作段的 PT_LOAD 文件大小为0、内存大小为4，没有加载镜像；不能据此保证所有外部加载器都不主动清零。CRT 清零与复制范围均不覆盖 LS4，不需要修改启动代码。

反汇编确认真实访问：

```text
610004: sw zero,0(a0)    # 模块初始化，a0=0x10000
610026: sw a0,0(a1)     # 模块结果写入，a1=0x10000
61002a: lw a0,0(a1)     # 模块工作数据读回
6006ca: lw a0,0(a0)     # APP 独立读取，a0=0x10000
```

模块还实际读取 sector5 的参数，未调用非安全 memcpy/memset 或其他辅助函数。函数栈调整为32/48字节，保持 ABI 对齐；非安全栈及寄存器上下文不作为保密边界。

## HEX 与来源保留

HEX 校验和、结束记录及地址范围通过，无重叠数据记录。数据仅位于程序 Flash 和 USER OTP，没有 RAM 数据载荷。OTP 输出范围为 `0x007A0000..0x007A0017`、`0x007A0080..0x007A009F`、原有 Z2 的 `0x007A0440..0x007A045F`，未输出旧 Z1 ZSB1/ZSB2。

两例 OTP 输出一致，三个指针为 `0x1FFFFFFC`，新块值与 README 一致。对比最近一次本板 OTP 回读，无0到1冲突；此结论不自动适用于其他器件。

与 ex01 来源比较，device、Driver、厂商板级驱动目录（含 C/H/crt/syscalls）、lib 及 Z2 OTP 源文件内容未变。修改仅在新工程的应用、链接布局、OTP 目标及工程配置中。

待板测：独立初始化、安全模块访问、APP 受限读取实际表现、3轮锁定/解锁、断电恢复、自动解锁影响及 GS0 下载工作区。读取异常与返回零需分别记录。
