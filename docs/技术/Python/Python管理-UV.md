# python 管理工具 UV 使用指南

官方文档：<https://docs.astral.sh/uv/>

[uv] 一个用 Rust 编写的极速 Python 包和项目管理工具。虚拟环境管理、多 python 版本管理、包管理、项目管理、构建包、发布包，简直是神器，而且速度超快，之前的各种类似工具都可以丢弃了。

## 安装

```sh
# 推荐通过 pip 安装，可以使用国内源，速度更快更稳定
python -m pip install uv

# 也可以使用 scoop 安装
scoop isntall uv

# 或者使用官方脚本安装
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
# 使用官方脚本安装，通过自身的命令更新版本
uv self update
```

## Quick Start

### 创建项目

uv 可以方便地创建、管理项目。

```sh
# 在当前目录下创建新项目
# 类型为 python 库
# --app 默认啥也不指定，就是 -app 参数，创建脚本、命令行应用程序
# --lib 创建 python 库，可以被其他 python 程序 import 引用
# --package 创建可以打包、发布的命令行工具。
# --build-backend "setuptools" 指定构建后端为 setuptools，如果不指定，默认为 uv_build，官方文档里指出，未来会抛弃 uv_buil，改用 hatch
# -p 3.14 指定虚拟环境使用的 python 版本
mkdir myproject && cd myproject
uv init --lib --build-backend "setuptools" -p 3.14


# 安装并添加包至当前项目
uv add requests
uv add setuptools --dev
# 注意：默认除了 dev 的 group，其他的组不会同步。
uv add pytest --group "test"

# 虚拟环境下执行 main.py
uv run main.py
```

### 常用命令

```sh
# 清理无用的缓存
uv cache prune
# 清理所有的缓存
uv cache clean

# sync 命令默认不升级依赖包
# 从 GitHub 上 clone 回来一个项目，一个命令配置好所有 python 相关的环境
uv sync
# 更新当前项目所有的包
uv sync -U
# 同步所有依赖组，以后还得加--all-groups 参数
uv sync --all-groups

# 打包为 wheel
uv build --wheel

# 查看项目已安装包的版本，仅查看直接安装的，不查看依赖
uv tree -d 1
```

### 全局命令行工具

```sh
# 经常全局使用的命令行工具，可以使用 uv tool 安装

uv tool install ruff
uv tool install notebook
# 更新环境变量，注销后重新登录有效
uv tool update-shell
# 查看所有 uv tool 安装的工具
uv tool list
# 更新所有 uv tool 安装的工具
uv tool upgrade --all

# 临时使用的工具，使用 uvx 命令直接运行
uvx pycowsay "Hello!"
```

## 配置

### Windows 下用户配置

参考：[UV 官方文档](https://docs.astral.sh/uv/concepts/configuration-files/)

主要两个文件：`%APPDATA%\uv\uv.toml`、`%APPDATA%\uv\.python-version`

配置优先级：项目`pyproject.toml` > 用户 `%APPDATA%\uv\uv.toml` `~/.config/uv/uv.toml`

```sh
# %APPDATA%\uv\uv.toml [Windows]
# ~/.config/uv/uv.toml [Linux]
python-downloads = "manual"

[[index]]
url = "https://pypi.tuna.tsinghua.edu.cn/simple"
default = true

[[index]]
url = "https://mirrors.ustc.edu.cn/pypi/simple"
```

项目`.python-version` > 用户 `%APPDATA%\uv\.python-version`、`~/.config/uv/.python-version`

```sh
# 默认 python-preference = managed 优先使用 uv 管理的 python 版本
# 如果不全局指定，新建的项目 python 的版本就像开盲盒
# 指定全局默认 python 版本
>>>uv python pin 3.13 --global
Pinned `.config/uv/.python-version` to `3.13`
```

### Debian 下用户配置

```sh
sudo apt update
sudo apt install pipx python3-pip
pipx ensurepath --force

pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip config set global.extra-index-url "https://mirrors.ustc.edu.cn/pypi/simple"
pip config set install.upgrade true

# pipx install --index-url https://pypi.tuna.tsinghua.edu.cn/simple -U uv
pipx install uv
# 更新所有工具
pipx upgrade-all

# 配置 uv
# Linux 下命令，更新 UV 用户配置
mkdir -p ~/.config/uv/
cat << "EOF" | tee ~/.config/uv/uv.toml
# ~/.config/uv/uv.toml
python-downloads = "manual"

[[index]]
url = "https://pypi.tuna.tsinghua.edu.cn/simple"
default = true

[[index]]
url = "https://mirrors.ustc.edu.cn/pypi/simple"
EOF

# 更新 shell
uv tool update-shell
# 安装最新版的 python
uv python install
```

### 项目配置

项目配置文件 `pyproject.toml`

```toml
[project]
name = "hello-world"
version = "0.1.0"
description = "在此处添加项目描述"
readme = "README.md"
dependencies = [
    "pywin32>=305; platform_system=='Windows'",
    "xlwings>=0.28; python_version>='3.12'",
]

[dependency-groups]
# 非项目本身依赖的包写在这里，包括开发、文档、测试、覆盖率等
# uv sync 默认仅同步 dev 组下的依赖，其他组的依赖不自动同步。
dev = ["setuptools"]
doc = ["mkdocs", "mkdocs-material", "mkdocstrings[python]"]
test = ["mypy", "pytest"]
hint = ["ruff"]

[tool.uv]
# 也可以指定哪些依赖组被同步 ["dev", "doc"]
default-groups = "all"
link-mode = "copy"
```

`.python-version` 文件包含项目的默认 Python 版本。此文件告诉 uv 在创建项目的虚拟环境时应使用哪个 Python 版本。

`uv.lock` 是一个跨平台的锁定文件，其中包含有关项目依赖项的确切信息。与用于指定项目大致要求的 `pyproject.toml` 不同，锁定文件包含安装在项目环境中的确切解析版本。此文件应提交到版本控制系统，以便在不同机器上实现一致且可重现的安装。`uv.lock` 是一个人类可读的 TOML 文件，但由 uv 管理，不应手动编辑。

### 更新 python

#### 手动更新 python 版本

大版本更新项目 python，如果配置了 uv 手动下载 python，需要先手动下载 python。

```sh
# 更新 python 至最新版本
uv python upgrade
```

#### 更新项目 python 版本

即使 python 版本已经更新，但项目虚拟环境使用的 python 版本并不会同步更新，需要根据情况进行更新，方法如下：

方法一：更新`.python-version` 文件

更新用户或项目的 `.python-version` 内容，比如将改为 `3.14.2`改为`3.14.4`  ，然后运行 `uv sync` 即可，没有看错，就是这么简单。

方法二：手动更新项目虚拟环境

```sh
# 更新当前项目 python
# --clear, -c Remove any existing files or directories at the target path.
uv venv -c
# 更新当前项目 python，并指定 python 版本
uv venv -p 3.14.4 -c
```

卸载旧版 python

```sh
# 卸载旧版 python
uv python uninstall 3.14.2
```

## 其他

### 命令别称

日常使用中，需要使用某个虚拟环境作为默认的工作环境，比如要运行某个项目下的模块，标准用法是：

```sh
# 运行命令行工具
uv run --project "D:\Home\Git-Repo\pycode" -m xpdf
```

很明显命令太长，太难记了，最简单的方法是使用命令别称，管理员权限下命令提示符下运行一下命令，添加命令别称。

```sh
reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d "doskey uvr=uv run --project \"D:\Home\Git-Repo\pycode\" $*" /f
```

然后就可以在命令提示符下愉快地使用 `uvc` 命令了，Nice！

```sh
uvr -m xpdf
```

### 双击运行 python 文件

Windows 下双击 `.py` 文件，会关联系统的 `python` 执行，但不会激活当前的虚拟环境。

🚀 方案 1：添加右键菜单 `UV RUN ...` ，添加以下注册表：

```ini
Windows Registry Editor Version 5.00

;Python文件右键添加 UV RUN ...
[HKEY_CLASSES_ROOT\.py]
@="Python.File"
[HKEY_CLASSES_ROOT\Python.File]
@="Python File"
[HKEY_CLASSES_ROOT\Python.File\shell\uv_run]
@="UV RUN ..."
"ICon"="D:\\Home\\Icons\\uv.ico"
[HKEY_CLASSES_ROOT\Python.File\shell\uv_run\command]
@="cmd.exe /s /c \"pushd & uv run %1\""
```

🦄 方案 2：备用方案，创建一个同名的 `.cmd` 批处理文件，然后运行这个批处理文件。

比如：`获取历史天气数据.py` 目录下创建 `获取历史天气数据.cmd` 批处理文件，内容如下：

```sh
@echo off
title [uv run %~n0.py]

rem 确保 UTF-8 编码
chcp 65001 >NUL

cd /d "%~dp0"
uv run "%~n0.py"

pause & exit
```

以后只用双击运行`获取历史天气数据.cmd` 批处理文件即可。

### 使用 UV 管理别人的项目

以 [semi-utils](https://github.com/leslievan/semi-utils) 为例，先克隆整个仓库

```sh
git clone git@github.com:leslievan/semi-utils.git
cd semi-utils

# 这是一个脚本程序，不加任何参数就是创建一个 app
uv init

# 他的 requirements.txt 锁定了库的版本，安装有点问题，把所有的版本约束改为 >= 即可。
# 添加依赖包
uv add -r requirements.txt

# 还得将 exiftool 程序放至程序 exiftool 目录下
# 至此才算是可以正常工作了
uv run main.py
```

放一个照片至 input 目录下，测试没有问题后，可以在项目下创建一个 `main.cmd`，编码格式 UTF8，内容如下，以后直接运行 `main.cmd` 即可，就是这么简单！

```sh
rem 使用UV虚拟环境运行
@echo off
chcp 65001 >NUL

cd /d %~dp0
uv run %~n0.py

pause
```

项目保持更新

```sh
# 拉取仓库更新，根据情况看怎么更新
git fetch

# 更新依赖包
uv sync -U

# 未来如果要更新 python 版本，只需要修改 .python-version 文件内容即可
```
