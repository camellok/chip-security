# 资料使用与开发环境

仓库按安全主题组织，当前实现内容位于 [DCSM 专题](../topics/dcsm/README.md)。同一 IP 的原理统一说明，例程按芯片平台分组；未来主题在实际开始建设时加入。

## 获取与导入

1. 下载完整仓库，先阅读主题入口和目标平台 README。
2. 使用 Haawking IDE 2.3.17 创建独立工作空间，通过 Existing Projects 导入所需工程。工程位于 `topics/dcsm/examples/<芯片平台>/<工程名>/`。
3. 28002x 和 280013x 使用相同的例程工程名；请分工作空间导入，避免名称冲突。目录层级变化后，原工作空间不会自动更新工程位置，应从新位置重新导入。
4. 让 IDE 重新生成构建规则，再构建所选工程。仓库不发布 `.metadata`、`Debug/` 和 `Release/` 缓存与产物；旧本地生成文件可能仍含迁移前路径。

各工程携带自己的应用源码、驱动、启动配置、库和链接脚本。更换工具链目录时，检查工程设置中的编译器、库路径和调试配置。

## 命令行构建

先通过 IDE 生成构建文件，然后在仓库根目录用 PowerShell 执行：

```powershell
$ide = 'D:\Haawking-IDE-2.3.17'
$env:Path = "$ide\haawking-tools\compiler\Haawking-RISCV-LLVM\bin;$ide\haawking-tools\compiler\bin;$env:Path"
make -C topics/dcsm/examples/hx28002x/ex02_dcsm_debug/Debug all
```

替换平台与工程名即可构建其他例程。链接配置修改后用 `-B all` 强制重建。编译通过不代表板级验证完成，实际状态以平台、工程 README 和验证记录为准。

## 下载与安全配置

构建不连接硬件或编程 OTP。下载前检查 ELF、map 和 HEX 的实际范围，区分程序 Flash 更新与 OTP 编程；文件名不能代替段范围检查。OTP 编程前备份目标器件，按对应平台及例程说明核对已有配置与密码。演示密码不用于量产。

28002x ex03/ex04 的 Z1 ZSB3 配置与旧 ex00～ex02 二进制存在兼容边界，详见[平台入口](../topics/dcsm/examples/hx28002x/README.md)。
