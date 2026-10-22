# 芯片安全专题开发路线

本文件整理已有 README 和 DCSM_ERRATA 中的待完成事项，不代表已交付或已验证。

| 主题 | 工作范围与验收目标 |
| --- | --- |
| 统一 ex00～ex02 演示场景 | 从 SPWM 过渡到厂家功能模块与产品参数；代码与参数分区；重新检查 map、HEX，并回归板级行为，保留原验证记录 |
| ex03：execute-only 对照 | 普通安全保护与 execute-only 对照；增加同 Zone 数据读取入口；代码可执行、独立参数可读，记录读取限制 |
| ex04：安全 RAM | 代码或工作数据放入安全 RAM；检查 Flash load / RAM run 地址与同 Zone 搬运，验证锁定访问和断电行为 |
| ex05～ex06：Flash 更新与升级 | 先验证 Flash API 运行位置、Zone 权限及信号量，再实现升级流程；镜像认证与完整性校验另行设计与验证 |
| HX2800137 适配 | 建立独立平台工程，核对 RAM、Flash、OTP、LINKPOINTER、PSWDLOCK；增加 RAMOPEN / JTAGLOCK 例程并形成独立板级证据 |
| FORCESEC 后再解锁待确认项 | 确认推荐流程、初始化前提和最小补充读取序列；补齐芯片修订和 SDK 版本；不预设驱动或芯片缺陷 |
| 客户应用笔记与交付验证 | 完成 user guide、培训材料、工具与接线清单、Flash / OTP 操作边界和版本化验证记录 |

当前基线：28002x 已有 ex00、ex01、ex02 工程；ex02 应用层版本已有开发者确认的连续10轮锁定/解锁与断电恢复记录。其余平台和规划例程不沿用该验证结论。

公开资料中的密码为演示值。设备 OTP 备份、回读镜像和客户生产密钥应独立保管，不提交至本仓库。

## GitHub 跟踪

- [Issue #1](https://github.com/camellok/chip-security/issues/1)
- [Issue #2](https://github.com/camellok/chip-security/issues/2)
- [Issue #3](https://github.com/camellok/chip-security/issues/3)
- [Issue #4](https://github.com/camellok/chip-security/issues/4)
- [Issue #5](https://github.com/camellok/chip-security/issues/5)
- [Issue #6](https://github.com/camellok/chip-security/issues/6)
- [Issue #7](https://github.com/camellok/chip-security/issues/7)
