# 280013x OTP 参考模板

默认不输出 OTP 数据。适用范围、空白编码与出厂内容的区别见 [模板说明](../README.md)。

| 文件 | 用途 |
| --- | --- |
| hx280013x_dcsm_z1otp.S | Zone1 固定 OTP 与 ZSB1 字段骨架，含 JLM、JTAG 密码及 CMAC 密钥字段 |
| hx280013x_dcsm_z2otp.S | Zone2 固定 OTP 与 ZSB1 字段骨架，不创建 Zone1 专有字段 |
| DCSM.ld | 按字段组独立定位，检查完整组长度，不填充保留位置 |

Zone1、Zone2 的 ZSB1 参考地址分别为 0x00640040、0x00640440，每块 0x40 字节。密码位于块起点，GRAB 位于 +0x10；三份 LINKPOINTER 连续排列。这些布局与 28002x 不同。

GRABSECT3 +0x18 沿用当前实验接受的布局；EXEONLYSECT2 +0x2C 是待核对偏移，源码中明确标注并保持关闭。主机链接检查只能确认文件按给定地址排列，不能代替器件手册核对或板级验证。

原参考配置的全 Flash Zone1 归属、演示密码和 PSWDLOCK 均未启用。密码、密钥和固定 OTP 字段使用 `<TARGET_VALUE>` 注释占位，保留目标芯片已有内容。
