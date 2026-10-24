# 28002x DCSM 例程

当前目标为 HXS320F280025C_EDD，使用 Haawking IDE 2.3.17。各目录都是独立工程，保留自己的驱动、库、启动配置和链接脚本。导入及工具设置见[通用环境说明](../../../../docs/getting_started.md)。

| 工程 | 内容 | 当前状态 |
| --- | --- | --- |
| [ex00](ex00_base_system/README.md) | 未保护的基础系统与功能模块 | 2026-10-22 简要板级回归通过 |
| [ex01](ex01_dcsm_secure_flash/README.md) | 模块代码与参数的普通安全 Flash 保护 | ZSB2、锁定运行、解锁及断电恢复通过 |
| [ex02](ex02_dcsm_debug/README.md) | 调试访问、锁定与解锁的读取对照 | 新模块版本 3 轮、读取对照及断电恢复通过；历史 SPWM 版本 10 轮记录独立保留 |
| [ex03](ex03_dcsm_exeonly/README.md) | execute-only 与普通安全保护对照 | 实现、构建及产物检查通过，板级待验证 |
| [ex04](ex04_dcsm_secure_ram/README.md) | Zone1 RAM 工作数据保护 | 实现、构建及产物检查通过，板级待验证 |

ex05～ex06 尚为规划，详见[开发路线](../../../../docs/ROADMAP.md)。芯片差异见[平台对照](../../docs/chip_differences.md)，主题原理与学习路线见[DCSM 入口](../../README.md)。

独立的 [28002x OTP 参考模板](../../templates/hx28002x/README.md)提供字段骨架，默认不输出 OTP 数据；各例程仍使用自己 `Security/` 中的配置。

## 当前开发板配置兼容性

ex01/ex02 当前使用 Z1 ZSB2，模块代码位于 sector4、参数位于 sector5。ex03/ex04 为同一开发板准备共享 Z1 ZSB3：sector4 execute-only、sector5 普通 Zone1、LS4 普通 Zone1 RAM；APP data/bss/ramfunc 转移到 LS5～LS7。ex04 从 Zone1 代码初始化独立 NOLOAD LS4 工作区。

启用 ZSB3 后，旧 ex00～ex02 二进制不能原样下载回退。ex03/ex04 互相切换只更新程序 Flash，但须先完成共享配置核对与板级验证。未使用裸片从 ZSB1 开始的交付方案仍待整理，不能把开发板槽位起点直接用于客户器件。

操作步骤和结果见[ex00～ex02 回归表](../../validation/hx28002x/REGRESSION_EX00_EX02.md)、[ex03/ex04 共用回归表](../../validation/hx28002x/REGRESSION_EX03_EX04.md)。构建不自动编程 OTP；完整 HEX 可能包含 OTP，下载前必须检查范围。

历史 SPWM / ZSB1 迁移构建记录见[2026-10-22 历史检查](../../validation/hx28002x/history/VALIDATION_2026-10-22.md)，不作为当前模块 / ZSB2 或 ZSB3 的新验收结果。ex04 独有的启动范围、ELF 与汇编证据见[构建检查](../../validation/hx28002x/EX04_BUILD_VALIDATION.md)。
