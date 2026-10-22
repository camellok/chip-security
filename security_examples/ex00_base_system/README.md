# ex00：基础系统与功能模块

本例程检查 LED、按键、SCI，以及一个可供 APP 调用的产品功能模块。全程使用轮询，不配置 USER OTP。

模块执行 `output = input * 3 + 7`。输入1～9循环，输出依次为10、13、16、19、22、25、28、31、34。后续例程沿用相同接口和参数，只改变内存保护与安全操作。

## 接线与运行

目标为 HXS320F280025C_EDD，使用 Haawking IDE 2.3.17。GPIO31 为 LED，GPIO9 为低有效按键，GPIO28/29 为 SCIA RX/TX，串口为9600、8N1。

LED 每250 ms 翻转，串口持续输出输入和结果。按住 KEY 至少300 ms 后松开，串口打印 `[KEY] released.`。按住期间轮询等待松手，LED 和计算暂时暂停。

```text
[ex00] Module: output = input * 3 + 7.
[MODULE] input=1 output=10
[MODULE] input=2 output=13
```

## 代码与内存

`Algorithms/product_module.c` 包含模块函数 `ProductModule_Process()` 和只读参数 `g_module_params[2] = {3, 7}`。参数使用 const volatile，保留实际 Flash 数据读取，供后续保护演示使用。

主程序只有两个全局观察量：非安全 RAM 中的 `g_module_input` 和 `g_module_output`。模块及参数的输入段 `module_code`、`module_params` 均由本例程 linker 收入普通 APP Flash 的 `text` 输出段，不使用 sector4/5。

本例程不会清除已有 OTP，也不输出“Zone1 已解锁”之类未经查询的状态。已配置 ex01/ex02 的板可用于检查基础外设，但既有安全状态不会因此取消。

## 构建与简要验收

在 IDE 中重新生成构建文件，确认 `product_module.c` 参与编译。使用默认构建输出 `Debug/ex00_base_system.elf` 和 `Debug/ex00_base_system.hex`；本例程不输出 OTP 数据。

下载后独立上电，确认 LED 闪烁、输入输出符合公式，再按一次 KEY 检查日志即可。自动构建检查与板级结果统一记录在[简要回归表](../../docs/REGRESSION_EX00_EX02.md)。

2026-10-22 开发者确认本次模块版本板级回归通过：独立上电 LED 正常闪烁，串口输入1～9循环且输出符合公式，按键松手打印一次日志后恢复运行。本次记录仅覆盖 ex00，不替代 ex01/ex02 的安全功能验证。
