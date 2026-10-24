# 280013x ex00：基础系统与功能模块

目标为 HXS320F2800137_EDE、PM核心板，Haawking IDE 2.3.17。由用户提供的空白工程配置，DriverLib保持原样。平台说明、接线、内存、OTP准备与寄存器地址见[280013x平台说明](../README.md)。

## 运行逻辑

模块及参数均位于普通 APP Flash。LED 每250 ms翻转，输入1～9循环，输出依次为10、13、16、19、22、25、28、31、34。按住 SW2 至少300 ms后松开，打印一次 `[KEY] released.`。不含 Security OTP 准备文件，也不清除芯片现有安全配置。

按键等待松手期间，轮询程序暂停；这段时间LED也暂停。观察量为非安全 LS0 中的 `g_module_input`、`g_module_output`。SCI 为 GPIO28/29，9600、8N1；LED2 为 GPIO20，SW2 默认 GPIO1。

## 构建与下载

导入 `ex00_base_system`，让 IDE 重新生成构建文件。默认产物为 `Debug/ex00_base_system.elf`、`.hex`、`.map`，APP不含OTP。使用应用层 `haawking-drivers/ldscripts/HXS320F2800137_EDE_link_FLASH.ld`，工程内已删除未使用的厂商原版Flash/RAM主脚本；[具体差异](../../../docs/HX280013X_LINKER_DIFF.md)已记录。

## 简要验收

1. 下载 APP 后独立上电，确认 LED2 闪烁，LED3 熄灭。
2. 打开 CH340C 串口，9600、8N1，核对输入输出。
3. 按下并松开 SW2，检查按键日志及运行恢复。

## 当前验证状态

2026-10-23构建及产物检查通过；2026-10-24开发者反馈上板验证通过、符合预期现象。尚未附逐项日志，结果见[280013x独立回归表](../../../docs/REGRESSION_HX280013X_EX00_EX02.md)。未继承28002x平台的板级验收结果。
