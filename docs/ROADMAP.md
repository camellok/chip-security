# 芯片安全专题开发路线

本文件整理已有 README 和 DCSM_ERRATA 中的待完成事项，不代表已交付或已验证。

| 主题 | 工作范围与验收目标 |
| --- | --- |
| 统一 ex00～ex02 演示场景 | 功能模块与代码/参数分区已实现，构建、产物检查及本轮简要板级回归通过（2026-10-22）；结果见[简要回归表](../topics/dcsm/validation/hx28002x/REGRESSION_EX00_EX02.md)，原验证记录保留 |
| 裸片演示配置整理 | 待例程方案稳定后，面向未使用的裸片，从 Z1 ZSB1 开始规划各阶段配置及必要的槽位推进；同配置例程复用槽位，不按例程编号逐个消耗。开发板 ex01/ex02 已使用 ZSB2，ex03/ex04 准备 ZSB3；交付前同步整理 OTP 汇编、链接地址、LINKPOINTER 与演示步骤，不能直接沿用开发板的槽位起点 |
| ex03：execute-only 对照 | 示例及同 Zone 读取探针已实现，构建和产物检查通过；先取得普通安全基线，再按[共用配置与测试说明](../topics/dcsm/validation/hx28002x/REGRESSION_EX03_EX04.md)验证 execute-only；板级待反馈 |
| ex04：安全 RAM | 最小安全 RAM 工作数据示例已实现，构建和产物检查通过；与 ex03 共用 ZSB3，板级待反馈。安全 RAM 代码搬运另行设计，不计入本版已实现范围 |
| ex05～ex06：Flash 更新与升级 | 先验证 Flash API 运行位置、Zone 权限及信号量，再实现升级流程；镜像认证与完整性校验另行设计与验证 |
| HX280013x 适配 | ex00～ex02应用已实现并有构建记录，开发者反馈ex00、ex01上板通过（2026-10-24）；ex02保留OTP源Exclude，无OTP ELF及双HEX构建通过，开发者反馈板级通过，分项证据待补录。完整OTP模板及分组链接脚本已完成，ex01完整ELF/双HEX已核对；分项证据、密码隐藏对照及ex03～ex08仍待完成，见下表 |
| FORCESEC 后再解锁待确认项 | 确认推荐流程、初始化前提和最小补充读取序列；补齐芯片修订和 SDK 版本；不预设驱动或芯片缺陷 |
| 客户应用笔记与交付验证 | 完成 user guide、培训材料、工具与接线清单、Flash / OTP 操作边界和版本化验证记录 |

当前基线：28002x 已有 ex00、ex01、ex02 工程；2026-10-22 开发者确认新模块版本 ex00～ex02 简要板级回归通过，Z1 ZSB2 已写入并回读确认。ex02 完成3轮锁定/解锁、新布局代码与参数读取对照及断电恢复验证。原 SPWM 应用层版本的连续10轮记录独立保留，不与本轮次数合并。其余平台和规划例程不沿用该验证结论。

公开资料中的密码为演示值。设备 OTP 备份、回读镜像和客户生产密钥应独立保管，不提交至本仓库。

## 280013x例程进度（2026-10-24）

| 项目 | 实现与构建 | 板级状态 / 下一步 |
| --- | --- | --- |
| ex00 基础系统 | 已完成，构建及产物检查通过 | 开发者反馈通过；逐项日志及工具信息待补录 |
| ex01 安全Flash | 开发配置完成；完整ELF及双HEX检查通过 | 开发者反馈当前上板通过；补录分项结果、寄存器和OTP写后回读；PSWDLOCK密码隐藏对照尚未实现 |
| ex02 调试访问 | 应用层PMF准备适配、可选OTP构建及产物检查完成；当前Exclude OTP | 开发者反馈板级通过；逐项日志、CR和轮数待补录 |
| OTP模板与链接脚本 | 新增字段齐全，GPREG/EXEONLYSECT按组，保留位置仅注释，边界及组长度检查完成 | GRABSECT3按已接受推定布局实验；EXEONLYSECT2偏移推定且默认禁用，不算功能验收 |
| 构建与下载产物 | 目标为默认ELF含APP+OTP、普通HEX仅Flash、_dcsm.hex含APP+OTP；ex01已核对，ex02主动Exclude OTP的构建已通过，ELF和两份HEX无OTP | 日常Flash更新按产物范围选择；构建不执行器件编程 |
| ex03～ex04 | 规划中，280013x尚未实现 | 后续验证execute-only与安全LS0 RAM；28002x对应工程不计入本平台进度 |
| ex05～ex06 | 规划中 | Flash API及Bootloader，先确认平台编程流程与权限 |
| ex07～ex08 | 规划中 | RAMOPEN及JTAGLOCK，分别验证数据清除和调试授权 |

证据与待填项见[280013x回归表](../topics/dcsm/validation/hx280013x/REGRESSION_HX280013X_EX00_EX02.md)，构建及下载边界见[双HEX说明](../topics/dcsm/docs/HX280013X_DUAL_HEX_BUILD.md)。当前具体目标仅为2800137_EDE / PM核心板，不扩展到其他型号、封装或修订。

## GitHub 跟踪

- [Issue #1](https://github.com/camellok/chip-security/issues/1)
- [Issue #2](https://github.com/camellok/chip-security/issues/2)
- [Issue #3](https://github.com/camellok/chip-security/issues/3)
- [Issue #4](https://github.com/camellok/chip-security/issues/4)
- [Issue #5](https://github.com/camellok/chip-security/issues/5)
- [Issue #6](https://github.com/camellok/chip-security/issues/6)
- [Issue #7](https://github.com/camellok/chip-security/issues/7)
