# python 管理工具 UV 使用指南

官方文档：<https://docs.astral.sh/uv/>

[uv] 一个用 Rust 编写的极速 Python 包和项目管理工具。虚拟环境管理、多 python 版本管理、包管理、项目管理、构建包、发布包，简直是神器，而且速度超快，之前的各种类似工具都可以丢弃了。

可以使用 pip 命令安装

```sh
# uv 安装脚本需要从 GitHub 下载，所以推荐通过 pip 安装，可以使用国内源
python -m pip install uv
```

## Quick Start

### 创建项目

uv 可以方便地创建、管理项目。

```sh
# 在当前目录下创建新项目
# 类型为 python 库
# --app 默认啥也不指定，就是-app 参数，创建脚本、命令行应用程序
# --lib 创建 python 库，可以被其他 python 程序 import 引用
# --package 创建可以打包、发布的命令行工具。
# --build-backend "setuptools" 指定构建后端为 setuptools，如果不指定，默认为 uv_build，官方文档里说了，未来会抛弃 uv_buil，改用 hatch
# -p 3.13 指定虚拟环境使用的 python 版本
uv init --lib --build-backend "setuptools" -p 3.13 myproject
cd myproject

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

参考：[uv 官方文档](https://docs.astral.sh/uv/concepts/configuration-files/)

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
sudo apt install python3-pip
# 后续升级 uv 一定要使用指定的 Python 版本
python3.11 -m pip install -U -i https://pypi.tuna.tsinghua.edu.cn/simple --break-system-packages uv

# Linux 下命令，更新 UV 用户配置
mkdir -p ~/.config/uv/
cat << "EOF" | tee ~/.config/uv/uv.toml
# ~/.config/uv/uv.toml
python-downloads = "manual"

[[index]]
url = "https://pypi.tuna.tsinghua.edu.cn/simple"
default = true
EOF
cat ~/.config/uv/uv.toml

# 安装指定版本的 python，并设为系统默认的 python
# 也就是 python3、python 命令都指向这个版本的 python
uv python install --default 3.13
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

大版本更新项目 python，如果配置了 uv 手动下载 python，需要先手动下载 python。

```sh
uv python install 3.13
# 更新当前项目 python
uv venv -p 3.13 -c
```

或是将 `.python-version` 内容改为 `3.13` ，然后运行 `uv sync` 即可，没有看错，就是这么简单。

```sh
# 升级 UV 管理的 python。注意：试验中的功能
uv python upgrade
# 比如 3.13.5 --> 3.13.6
# 将最新版的更新为默认版本
# uv python install 3.13 --force
# 卸载旧版
uv python uninstall 3.13.6
# 更新当前项目 python
uv venv -p 3.13.7 -c
```

## 其他

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
