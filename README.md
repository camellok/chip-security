# 芯片安全专题 | Chip Security

本仓库面向昊芯 DSC 用户，按安全主题组织例程、操作说明和验证记录。当前主题为 CSM / DCSM，演示代码与数据保护、密码解锁、调试访问及安全 RAM 的使用。后续主题和待完成内容见[开发路线](docs/ROADMAP.md)。

DCSM 的共同原理统一说明，例程按芯片分组。各工程保留自己的源码、驱动库、链接脚本和 IDE 配置，可单独导入。工程状态区分实现、构建检查和板级验证；规划中的功能不算已交付。

## 资料入口

| 入口 | 内容 |
| --- | --- |
| [资料使用与开发环境](docs/getting_started.md) | 工程导入、构建方法及下载前检查 |
| [DCSM 主题](topics/dcsm/README.md) | 演示场景、学习顺序、芯片差异、例程状态及内存布局 |
| [芯片平台差异](topics/dcsm/docs/chip_differences.md) | 28002x 与 280013x 的内存、安全配置及使用差异 |
| [28002x 例程](topics/dcsm/examples/hx28002x/README.md) | HXS320F280025C_EDD 平台，已有 ex00～ex04 |
| [280013x 例程](topics/dcsm/examples/hx280013x/README.md) | 当前目标为 HXS320F2800137_EDE / PM 核心板，已有 ex00～ex02 |
| [常见问题](topics/dcsm/docs/faq.md) | 构建、启动、调试与硬件排查 |
| [现象与待确认事项](topics/dcsm/docs/errata.md) | 已观察的行为、对照试验及适用范围 |
| [开发路线](docs/ROADMAP.md) | 后续例程、文档和交付准备 |

当前资料以例程及验证记录为主，独立 user guide 和培训 PPT 待补充。各平台的具体进度、操作步骤和验证证据以主题、平台及工程 README 为入口查阅；一个平台的结果不直接适用于另一个平台。

## 目录

```text
Chip_Security/
├── README.md
├── docs/
│   ├── getting_started.md
│   └── ROADMAP.md
└── topics/
    └── dcsm/
        ├── README.md
        ├── docs/                  # 专题说明、FAQ 与现象记录
        ├── examples/
        │   ├── hx28002x/          # ex00～ex04
        │   └── hx280013x/         # ex00～ex02
        ├── templates/             # 独立 OTP 参考模板
        └── validation/            # 按芯片保留验证记录
```

## 开始使用

1. 阅读[资料使用与开发环境](docs/getting_started.md)及 [DCSM 主题说明](topics/dcsm/README.md)，选择目标芯片，确认工程状态及已有 OTP 配置是否兼容。
2. 使用 Haawking IDE 2.3.17，在独立工作空间中通过 Existing Projects 导入对应芯片目录下的工程。两个平台有同名工程，请分别使用工作空间。
3. 按平台和工程 README 核对接线、工具链与调试配置。先运行 ex00，确认启动、LED、SCI 和计算结果，再开展安全实验。ex00 不会清除芯片已有的安全配置。
4. 首次导入后由 IDE 生成构建文件，再执行构建。`Debug/` 及工作空间缓存不纳入版本控制；更换安装目录时，检查编译器、库、链接脚本和调试配置中的路径。
5. 构建后核对 map 中的运行地址、Flash 加载地址及 HEX 输出范围，再按工程说明选择下载产物。构建通过不代表已经完成板级验证。

## Flash 更新与 OTP 配置

普通 Flash 更新和 USER OTP 编程分别操作。完整 ELF 或 HEX 可能包含 OTP，不能仅凭文件名判断下载范围。280013x 的产物规则及当前例外见[双 HEX 构建说明](topics/dcsm/docs/HX280013X_DUAL_HEX_BUILD.md)。

OTP 无法像普通 Flash 一样擦除恢复。任何有意编程前，先保存目标器件的初始 OTP、待写配置和密码，核对工厂位、编程规则及例程间兼容关系。设备专用备份与回读数据在本地单独保管，不提交公开仓库；本仓库不自动编程 OTP。

28002x 的 ex03/ex04 为当前开发板准备共用 Z1 ZSB3 配置。启用该配置后，旧 ex00～ex02 二进制不能原样下载回退，具体限制见[共用配置与回归说明](topics/dcsm/validation/hx28002x/REGRESSION_EX03_EX04.md)。面向新器件、从 ZSB1 开始的交付配置仍需另行整理。

调试器可能在连接时自动解锁。读取对照应同时记录区域归属、安全状态和读数；读回全零不等于存储内容已经清零。演示密码及明文软件密钥只用于培训，不应直接作为量产配置。
