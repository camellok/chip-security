# DCSM 芯片平台使用差异

DCSM 的区域归属、密码解锁和访问限制统一在[主题入口](../README.md)介绍。本页集中列出当前两个平台的使用差异；某个平台已有的验证结论不适用于另一个平台。

| 项目 | 28002x | 280013x |
| --- | --- | --- |
| 当前目标 | HXS320F280025C_EDD 演示板 | HXS320F2800137_EDE / PM 核心板 |
| 已建立工程 | ex00～ex04 | ex00～ex02 |
| 板级状态 | ex00～ex02 通过；ex03/ex04 待验证 | 开发者反馈 ex00～ex02 通过，分项证据待补录 |
| USER OTP Zone 基址 | `0x007A0000`、`0x007A0400` | `0x00640000`、`0x00640400` |
| LINKPOINTER / ZSB | 按本平台 OTP 模板和当前活动槽位配置 | 14 位 LINKPOINTER、`0x40` 字节 ZSB 步长，字段及分组重新核对 |
| 模块 Flash | sector4 代码、sector5 参数 | 当前代码地址 `0x00610000`～`0x00613FFF` 对应扇区 32～39，参数位于后续独立区域 |
| 安全 RAM | ex03/ex04 共享配置预留 LS4，ex04 实际使用其工作区；APP 移至 LS5～LS7 | 使用 LS0 分段；安全 RAM 例程尚未实现 |
| 当前 OTP 配置 | ex01/ex02 为开发板 ZSB2；ex03/ex04 准备 ZSB3 | ex01/ex02 模板采用 ZSB1；ex02 当前主动 Exclude OTP 源 |
| 构建产物 | 完整 HEX 可能含 OTP，普通更新须检查下载范围 | ex01 ELF / `_dcsm.hex` 含 OTP、普通 HEX 仅 Flash；ex02 ELF 与两份 HEX 均无 OTP |
| 后续特有例程 | ex05 Flash API、ex06 Bootloader 规划中 | 另规划 ex07 RAMOPEN、ex08 JTAGLOCK，尚未实现 |

280013x OTP 除 LINKPOINTER 的规定例外外，每个 32 位字只能编程一次，不能照搬另一个平台的字段修改流程。当前 GRABSECT3 等布局推定和 TRM 待确认项仍须按[平台说明](../examples/hx280013x/README.md)核对；模板存在不等于功能已验证。

FORCESEC 后再次解锁的应用层准备读取分别记录在[勘误与验证记录](errata.md)。两个平台的读取序列、寄存器布局及板级证据独立维护，不推定与 TI 器件行为相同。

具体接线、时钟、工程和配置以 [28002x 平台说明](../examples/hx28002x/README.md)、[280013x 平台说明](../examples/hx280013x/README.md)及各工程 README 为准。
