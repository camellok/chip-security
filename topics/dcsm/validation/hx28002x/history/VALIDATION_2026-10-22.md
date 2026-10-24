# 迁移与构建检查（2026-10-22）

目录：`D:\ApplicationNotes_Release\Chip_Security`。目标工程配置为 HXS320F280025C_EDD，工具为 Haawking IDE 2.3.17 配套 RISC-V 编译器与 make。

迁移前后已对 809 个非 IDE 缓存文件逐项核对 SHA-256。随后更新总入口、路线与版本管理说明，修正 ex00/ex01 的旧 IDE 工程名；应用源码和厂商库保持原样。已有生成 makefile 中的旧绝对路径仅在本地更新，生成文件不进入 Git。

三个工程均执行 `make -C security_examples/<工程>/Debug -B all`，退出码为 0。工具链有未使用链接参数告警（ex00 135条，ex01/ex02各141条），本次不据此修改应用或厂商源码。

## 产物检查

ELF 段表与 map 已检查：三个工程 ramfunc 大小均为 `0x300`，运行地址均为 `0x00010020`；Flash 加载地址依次为 `0x00602F50`、`0x00602D30`、`0x00602DE0`。ex01/ex02 的 Zone1 LINKPOINTER 段为 `0x007A0000`、大小 `0x18`；Zone1/Zone2 ZSB 分别为 `0x007A0040`、`0x007A0440`，大小均为 `0x20`。

Intel HEX 逐记录校验和通过，非空数据仅落在 Flash `[0x00600000, 0x00640000)` 与 USER OTP `[0x007A0000, 0x007A0800)`：

| 工程 | Flash 数据字节 | USER OTP 数据字节 |
| --- | ---: | ---: |
| ex00_base_system | 12868 | 0 |
| ex01_dcsm_secure_flash | 13405 | 88 |
| ex02_dcsm_debug | 13573 | 88 |

ex01/ex02 的完整 HEX 含 OTP 数据，不能当作仅更新普通 Flash 的下载文件。本次未烧录设备、未进行新增板级验证；原有板级记录继续以各工程 README 和 topics/dcsm/docs/errata.md 为准。
