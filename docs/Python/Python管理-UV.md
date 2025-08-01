# python管理工具UV使用指南

可以使用 pip 命令安装

```sh
pip install uv
```

## 常用命令

```sh
uv tool install you-get
uv tool install ruff
uv tool install pyright

# 更新uv安装的工具
uv tool list && uv tool upgrade --all

# 清理无用的缓存
uv cache prune
# 清理所有的缓存
uv cache clean

# sync 命令默认不升级依赖包
# 更新当前项目所有的包
uv sync -U

# 升级 UV 管理的python
# 注意：这还是试验中的功能
uv python --managed-python upgrade --preview
```

## 创建项目

uv 可以方便地创建、管理项目。

```sh
# 在当前目录下创建新项目
# 类型为python库
# --app 默认啥也不指定，就是-app参数，创建脚本、命令行应用程序
# --lib 创建python库，可以被其他python程序import 引用
# --package 创建可以打包、发布的命令行工具。
# --build-backend "setuptools" 指定构建后端为setuptools，如果不指定，默认为 uv_build，官方文档里说了，未来会抛弃uv_buil，改用hatch
# -p 3.13 指定虚拟环境使用的python版本
uv init myproject --lib --build-backend "setuptools" -p 3.13
cd myproject

uv add pypdf
uv add setuptools --dev
# 注意：默认除了 dev 的 group，其他的组不会同步。
uv add pytest --group "test"
```

在开发 python 项目时，一般会使用虚拟环境。

虚拟环境的目的是，项目与项目之间的 python 环境隔离，项目所使用的 python 第三方库隔离。

* 目标设备的 Python 版本与本机不同
* 目标设备已安装包的版本与本机不同

>注意：配置虚拟环境，pip 不能设置为默认启用 `--user` 参数。

## 神器 uv

[uv] 一个用 Rust 编写的极速 Python 包和项目管理工具。虚拟环境管理、多python版本管理、包管理、项目管理，兼职是虚拟环境管理的神器，几乎完美解决了之前的虚拟环境的各种问题。

### 核心亮点

- 🚀 一个工具替代 `pip`、`pip-tools`、`pipx`、`poetry`、`pyenv`、`twine`、`virtualenv` 等
- ⚡️ 比 `pip` [快 10-100 倍](https://github.com/astral-sh/uv/blob/main/BENCHMARKS.md)
- 🗂️ 提供[全面的项目管理功能](https://uv.doczh.com/#projects)，包含[通用锁文件](https://uv.doczh.com/concepts/projects/layout/#the-lockfile)
- ❇️ [运行脚本](https://uv.doczh.com/#scripts)，支持[内联依赖元数据](https://uv.doczh.com/guides/scripts/#declaring-script-dependencies)
- 🐍 [安装和管理](https://uv.doczh.com/#python-versions) Python 版本
- 🛠️ [运行和安装](https://uv.doczh.com/#tools) 以 Python 包形式发布的工具
- 🔩 包含 [pip 兼容接口](https://uv.doczh.com/#the-pip-interface)，在熟悉 CLI 的同时获得性能提升
- 🏢 支持 Cargo 风格的[工作区](https://uv.doczh.com/concepts/projects/workspaces/)用于可扩展项目
- 💾 磁盘空间高效，通过[全局缓存](https://uv.doczh.com/concepts/cache/)实现依赖去重
- ⏬ 无需 Rust 或 Python 即可通过 `curl` 或 `pip` 安装
- 🖥️ 支持 macOS、Linux 和 Windows

### 常用功能

```sh
# 从GitHub 上 clone 回来一个项目，一个命令配置好所有python相关的环境
uv sync
# 同步更新依赖组
uv sync --all-groups

# 虚拟环境下执行 main.py
uv run main.py

# 安装包，并更新依赖
uv add requests

# 使用 uv build 构建wheel包
uv build --wheel

# 更新所有的包
uv sync -U
# 清理无用的缓存
uv cache prune
# 清理所有的缓存
uv cache clean

# 临时使用的工具，使用 uvx 命令直接运行
uvx pycowsay "Hello!"

# 经常使用的命令行工具，可以使用 uv tool 安装
# 独立虚拟环境安装命令行工具
uv tool install you-get
# 使用 uv tool install 安装的命令行工具，需要添加path环境变量
uv tool update-shell

# 查看所有 uv tool 安装的工具
uv tool list
# 更新所有 uv tool 安装的工具
uv tool upgrade --all
```

### 用户配置

参考：[uv官方文档](https://docs.astral.sh/uv/concepts/configuration-files/)

主要两个文件：`%APPDATA%\uv\uv.toml`、`%APPDATA%\uv\.python-version`

配置优先级：项目`pyproject.toml` > 用户 `%APPDATA%\uv\uv.toml` `~/.config/uv/uv.toml`

```sh
# Windows下UV用户配置
# 禁止自动下载 python，可以手动安装指定版本 uv python install python3.13
echo # ^%APPDATA^%\uv\uv.toml> %APPDATA%\uv\uv.toml
echo python-downloads = "manual">> %APPDATA%\uv\uv.toml
echo [[index]]>> %APPDATA%\uv\uv.toml
echo url = "https://pypi.tuna.tsinghua.edu.cn/simple">> %APPDATA%\uv\uv.toml
echo default = true>> %APPDATA%\uv\uv.toml
```

项目`.python-version` > 用户 `%APPDATA%\uv\.python-version`、`~/.config/uv/.python-version`

```sh
# 默认 python-preference = managed 优先使用uv管理的python版本
# 如果不全局指定，新建的项目python的版本就像开盲盒
# 指定全局默认 python 版本
>>>uv python pin 3.13 --global
Pinned `.config/uv/.python-version` to `3.13`
```

### Debian 下用户配置

```sh
sudo apt update
sudo apt install python3-pip
# 后续升级uv一定要使用指定的Python版本
python3.11 -m pip install -U -i https://pypi.tuna.tsinghua.edu.cn/simple --break-system-packages uv

# Linux下命令，更新UV用户配置
mkdir -p ~/.config/uv/
cat << "EOF" | tee ~/.config/uv/uv.toml
# ~/.config/uv/uv.toml
python-downloads = "manual"

[[index]]
url = "https://pypi.tuna.tsinghua.edu.cn/simple"
default = true
EOF
cat ~/.config/uv/uv.toml

# 安装指定版本的python，并设为系统默认的python
# 也就是 python3、python命令都指向这个版本的python
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

使用UV升级python太方便了，比如要将 python3.12 升级至 python3.13 ，只需要将 `.python-version` 内容改为 `3.13` ，然后运行 `uv sync` 即可，没有看错，就是这么简单。

我配置了 uv 手动下载python，需要先手动下载python。

```sh
uv pypthon install 3.13

# 检查python的环境变量
uv run python -c "import sys;print(sys.path)"

# 升级 UV 管理的python
# 注意：这还是试验中的功能
uv python --managed-python upgrade --preview
```

## 使用UV管理别人的项目

以 [semi-utils](https://github.com/leslievan/semi-utils) 为例，先克隆整个仓库

```sh
git clone git@github.com:leslievan/semi-utils.git
cd semi-utils

# 这是一个脚本程序，不加任何参数就是创建一个 app
uv init

# 他的requirements.txt锁定了库的版本，安装有点问题，把所有的版本约束改为 >= 即可。
# 添加依赖包
uv add -r requirements.txt

# 还得将 exiftool 程序放至程序 exiftool 目录下
# 至此才算是可以正常工作了
uv run main.py
```

放一个照片至input 目录下，测试没有问题后，可以在项目下创建一个 `main.cmd`，编码格式UTF8，内容如下，以后直接运行 `main.cmd` 即可，就是这么简单！

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

# 未来如果要更新python版本，只需要修改 .python-version 文件内容即可
```

