# LocalContext · 本地右键工具

在 Finder 的文件夹空白处点右键，选择 **本地右键工具 → 新建 Word 文档**，即可在当前目录得到一个可编辑的空白文档。连续新建时，文件名会自动加上序号。

## 安装

准备一台 Mac 和 Xcode 命令行工具（可通过 `xcode-select --install` 安装），然后在终端运行：

```sh
git clone https://github.com/dongrikeaii/LocalContext.git
cd LocalContext
./install.sh
```

脚本在本机编译应用，安装到 `~/Applications/LocalContext.app` 并注册 Finder 扩展。若菜单尚未出现，在系统设置中搜索「Finder 扩展」，启用「本地右键工具」。

## 使用

| 操作 | 用法 |
| --- | --- |
| 新建 | 创建 Word、Excel、PowerPoint、文本、Markdown 文件或文件夹。选中文件时在其所在目录创建。 |
| 路径与副本 | 复制所选项目的完整路径，或在原目录创建副本。 |
| 复制与移动 | 选择一个或多个项目，再从对话框指定目标文件夹。 |
| ZIP | 压缩选区第一项，或将选中的 ZIP 解压到各自的文件夹。 |
| 终端 | 在所选目录或文件所在目录打开 Terminal。 |

Finder 扩展向主应用传递操作和路径，主应用以当前用户权限处理文件。Office 文件从内置空白模板创建，可以离线使用。

## 构建与卸载

运行 `./build.sh` 可在仓库目录生成应用包。构建使用 Swift、macOS SDK、Python 3 和系统签名工具。模板已随源码提供，来源与许可见 [第三方说明](NOTICE.md)。

卸载时先在系统设置中关闭扩展，退出 LocalContext，再将用户「应用程序」目录中的 LocalContext 移到废纸篓。
