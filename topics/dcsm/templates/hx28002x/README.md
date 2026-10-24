# 28002x 独立 OTP 参考模板

本目录保留原 `security_examples/` 根目录中的 `DCSM.ld`、`hx28002x_dcsm_z1otp.s` 和 `hx28002x_dcsm_z2otp.s`，内容随目录迁移保持原样。

这些是独立参考模板，不参与现有例程的默认构建。实际实验应使用对应工程内的 `Security/` 汇编和 `haawking-drivers/ldscripts/DCSM.ld`，并按该工程 README 核对目标器件、槽位、密码和已有 OTP。

模板不代表当前开发板或客户器件的可直接编程配置，不用于自动编程。OTP 编程前保存目标器件备份，并核对完整产物中的实际段范围。
