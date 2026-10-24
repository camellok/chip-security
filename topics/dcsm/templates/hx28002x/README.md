# 28002x OTP 参考模板

默认不输出 OTP 数据。适用范围、空白编码与出厂内容的区别见 [模板说明](../README.md)。

| 文件 | 用途 |
| --- | --- |
| hx28002x_dcsm_z1otp.s | Zone1 字段骨架，包含 LINKPOINTER、启动配置、锁字段和 ZSB1 |
| hx28002x_dcsm_z2otp.s | Zone2 字段骨架；0x007A0430–0x007A0437 保留位置没有输出段 |
| DCSM.ld | 独立 OTP 链接布局；不放置应用程序代码或数据 |

Zone1、Zone2 的 ZSB1 参考地址分别为 0x007A0040、0x007A0440。每个块为 0x20 字节，前四字为 EXEONLYRAM、EXEONLYSECT、GRABRAM、GRABSECT，后四字为 CSMPSWD0–3。三份 LINKPOINTER 相隔八字节，分别独立定位，不为中间保留字提供数据。

源码中的配置字全部是注释。密码和固定 OTP 字段使用 `<TARGET_VALUE>` 占位，不沿用原模板的演示密码或某颗芯片的读回值。此模板不改变例程或当前开发板的 OTP。
