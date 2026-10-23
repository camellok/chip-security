# 芯片安全专题开发路线

本文件整理已有 README 和 DCSM_ERRATA 中的待完成事项，不代表已交付或已验证。

| 主题 | 工作范围与验收目标 |
| --- | --- |
| 统一 ex00～ex02 演示场景 | 功能模块与代码/参数分区已实现，构建、产物检查及本轮简要板级回归通过（2026-10-22）；结果见[简要回归表](REGRESSION_EX00_EX02.md)，原验证记录保留 |
| 裸片演示配置整理 | 待例程方案稳定后，面向未使用的裸片，从 Z1 ZSB1 开始规划各阶段配置及必要的槽位推进；同配置例程复用槽位，不按例程编号逐个消耗。本轮开发板因已有 OTP 配置，暂从 Z1 ZSB2 开始测试；交付前同步整理 OTP 汇编、链接地址、LINKPOINTER 与演示步骤，不能直接沿用开发板的 ZSB2 起点 |
| ex03：execute-only 对照 | 普通安全保护与 execute-only 对照；增加同 Zone 数据读取入口；代码可执行、独立参数可读，记录读取限制 |
| ex04：安全 RAM | 代码或工作数据放入安全 RAM；检查 Flash load / RAM run 地址与同 Zone 搬运，验证锁定访问和断电行为 |
| ex05～ex06：Flash 更新与升级 | 先验证 Flash API 运行位置、Zone 权限及信号量，再实现升级流程；镜像认证与完整性校验另行设计与验证 |
| HX280013x 适配 | ex00～ex02 已基于用户空白模板实现，构建及产物检查通过，见[独立回归表](REGRESSION_HX280013X_EX00_EX02.md)；待完成板级验收、密码隐藏对照，再增加 RAMOPEN / JTAGLOCK 例程 |
| FORCESEC 后再解锁待确认项 | 确认推荐流程、初始化前提和最小补充读取序列；补齐芯片修订和 SDK 版本；不预设驱动或芯片缺陷 |
| 客户应用笔记与交付验证 | 完成 user guide、培训材料、工具与接线清单、Flash / OTP 操作边界和版本化验证记录 |

当前基线：28002x 已有 ex00、ex01、ex02 工程；2026-10-22 开发者确认新模块版本 ex00～ex02 简要板级回归通过，Z1 ZSB2 已写入并回读确认。ex02 完成3轮锁定/解锁、新布局代码与参数读取对照及断电恢复验证。原 SPWM 应用层版本的连续10轮记录独立保留，不与本轮次数合并。其余平台和规划例程不沿用该验证结论。

公开资料中的密码为演示值。设备 OTP 备份、回读镜像和客户生产密钥应独立保管，不提交至本仓库。

## GitHub 跟踪

- [Issue #1](https://github.com/camellok/chip-security/issues/1)
- [Issue #2](https://github.com/camellok/chip-security/issues/2)
- [Issue #3](https://github.com/camellok/chip-security/issues/3)
- [Issue #4](https://github.com/camellok/chip-security/issues/4)
- [Issue #5](https://github.com/camellok/chip-security/issues/5)
- [Issue #6](https://github.com/camellok/chip-security/issues/6)
- [Issue #7](https://github.com/camellok/chip-security/issues/7)
