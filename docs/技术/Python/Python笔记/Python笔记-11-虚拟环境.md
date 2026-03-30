# 项目管理及虚拟环境管理

## UV 项目管理及虚拟环境管理

uv 创建管理项目。

```sh
# 在当期目录下创建新项目，类型为 python 库，构建后端为 setuptools，如果不指定，默认为 uv_build
# --app 默认啥也不指定，就是-app 参数，创建脚本、命令行应用程序
# --lib 创建 python 库，可以被其他 python 程序 import 引用
# --package 创建可以打包、发布的命令行工具。
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

## 传统的方法

### pyenv 安装多版本 python

参考：<https://bgasparotto.com/install-pyenv-ubuntu-debian>

<https://github.com/pyenv/pyenv/wiki/Common-build-problems>

Linux 下安装不同版本 python，最方便的方法是使用 `pyenv` 工具。

* pyenv 采用源码安装，编译时间可能稍长。
* 安装至用户目录，不污染系统环境。
* 可以方便切换系统默认 python 版本。
* 默认不安装 pip。
* 由于安装的 `~/.pyenv` 目录可写，所以 `pip` 和其他软件包也会安装至此目录下，解决方案：每次运行 pip 命令手动添加 `--user` 参数。

#### 手动安装 pyenv

```sh
# Debian/Ubuntu 需要安装依赖包
sudo apt install zlib1g zlib1g-dev libssl-dev libbz2-dev libsqlite3-dev libncurses5-dev libedit-dev xz-utils tk-dev libffi-dev liblzma-dev libreadline-dev git


git clone https://github.com/pyenv/pyenv.git ~/.pyenv
# git clone git@gitee.com:mirrors/pyenv.git ~/.pyenv

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
# Restart your shell
exec "$SHELL"
```

#### 使用 pyenv

```sh
pyenv --version
# 查看可安装的版本
pyenv install -l | grep "^\s*3.11"

# 安装最新的 3.11 版
pyenv install 3.11
# 安装后的 python 没有包含 pip 包，需要手动安装
python3.11 -m ensurepip --upgrade

# 当前 shell 会话，切换至 python3.10
pyenv shell 3.11 && python -V
# 查看所有已安装的版本
pyenv versions

# 设置全局 python 版本
pyenv global 3.11
python -V

# 恢复系统 python 为全局
pyenv global system
```

#### 升级 pyenv

手动升级 pyenv 方法：

```sh
# 查看当前 pyenv 版本
pyenv --version
cd ~/.pyenv && git fetch && git checkout $(git describe --tags $(git rev-list --tags --max-count=1)) && cd
# 检查是否升级成功
pyenv --version
```

#### 升级 python

升级 python，升级前需要先升级 pyenv

```sh
# 查看当前 python 版本
pyenv versions
# 查看可安装的版本
pyenv install -l | grep "^\s*3.11"
# 自动安装最新的 python3.11
pyenv install 3.11
pyenv global 3.11
python -m ensurepip --upgrade
python -m pip install -U --user --force-reinstall pip
# 检查是否为最新的版本
pyenv versions
python -V

# 删除旧的版本
pyenv uninstall 3.11.0
pyenv versions

python -V
pip -V
```

#### 保持 pip 版本一致

每次切换默认 python 版本后，pip 并不会跟随更改，需要手动强制重新安装一下 pip 到 user 就行了。

```sh
pyenv global 3.11
# 只要 pip 和 python 版本不一致，强制重新安装一下 pip 到 user 就行了
python -m pip install -U --user --force-reinstall pip
python -V
pip -V
```

#### 包安装位置

```sh
pip install  --user black
```

### 使用 ppa 源安装 python

参考：<https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa>

Ubuntu 方法下可以使用第三方源（不推荐此方法）。

```sh
sudo apt update
# The add-apt-repository utility is included in the software-properties-common package
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update

# 查看当前 python 版本
python3 -V
# 安装 python 3.11，需要安装 full 包，才会带 pip 包
sudo apt install python3.11-full
# 查看刚才安装的 python 版本
python3.11 -V
# 查看 pip 版本
python3.11 -m pip -V
# 更新
python3.11 -m pip install -U pip wheel setuptools
python3.11 -m pip -V
```

### Windows 下安装多版本 python

Windows 下可以使用 [pyenv-win](https://github.com/pyenv-win/pyenv-win) ，但是更方便的是使用 `scoop` 命令。

```sh
# 安装 python311，自动设为默认 python。
scoop install python311

# 手动设置默认 python
scoop reset python310
```

## 项目虚拟环境部署

### Pycharm 下创建虚拟环境

使用 Pycharm 可以很方便地创建、管理虚拟环境。

打开 PyCharm，新建项目：

1. 位置选择：`D:\my_project`
2. Python 解释器选择 `Virtualenv 环境`
3. 位置设为：`D:\my_project\.venv`
4. 如果本机安装有多个版本的 python，基础解释器选择合适的版本。

创建完成后，可以方便地在 pycharm 中升级、安装虚拟环境下的依赖包，以后重新打开此项目，会自动进入虚拟环境。在开发全过程中，推荐使用 pycharm 管理虚拟环境。

### 使用 venv 创建虚拟环境

参考：[Python venv 文档](https://docs.python.org/zh-cn/3/library/venv.html) 、[Python 打包用户指南：创建和使用虚拟环境](https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/#creating-a-virtual-environment)

在用户主目录下创建项目目录，然后创建虚拟环境：

```sh
$ mkdir my_venv_project
$ cd my_venv_project

# 在 .venv 目录创建虚拟环境，并将 pip、setuptools 升级到最新版本（python3.9 新功能）
$ python3 -m venv --upgrade-deps .venv

# 启用虚拟环境
$ source .venv/bin/activate
# Windows 下启用虚拟环境
C:\> .venv\Scripts\activate

# 此时终端已经能看到进入虚拟环境了
# 查看当前的 python 位置
$ which python
C:\> where python

# 查看虚拟环境的包环境。
(.venv)$ pip list
Package       Version
------------- -------
pip           22.3.1
pkg-resources 0.0.0
setuptools    65.6.0

# 安装依赖包
(.venv)$ pip install -r requirements.txt
```

当我们项目开发完后，并不是在本机上运行，需要部署到远程的机器上（一般是 Linux 系统）。为了保证项目与系统环境隔离，使用虚拟环境部署是很好的方案。

### Linux 下创建虚拟环境

使用 python 内置的 `env` 标准库创建虚拟环境。Debian 默认没有内置 `venv` 标准库，需要手动安装。

```sh
sudo apt install python3-venv
```

先使用 `venv` 工具创建虚拟环境，然后创建一个脚本作为程序入口。

### Linux 下创建程序入口

在项目目录下创建脚本 `run.sh`：

```sh
#!/usr/bin/env bash
# run.sh

# 切换至当前目录
current_dir=$(dirname "$0")
cd "$current_dir"

# 运行主程序 main.py
source .venv/bin/activate && (echo "已进入虚拟环境..." ; python3 "$current_dir/main.py")

exit
```

调用脚本

```sh
bash $HOME/my_venv_project/run.sh
```

### Windows 下创建程序入口

在项目目录下创建脚本 `run.cmd`：

```sh
echo off
rem run.cmd
current_dir=%~dp0
cd /d %current_dir%

rem 运行主程序 main.py
call "%current_dir%.venv\Scripts\activate" && (echo "已进入虚拟环境..." & python "%current_dir%main.py")

exit
```

或是命令直接调用 `main.py`。

```sh
cmd /k "pushd "%USERPROFILE%\my_venv_project" & "%USERPROFILE%\my_venv_project\.venv\Scripts\activate" && (echo 已进入虚拟环境... & python "%USERPROFILE%\my_venv_project\main.py")"
```

### 移动项目位置

整个项目目录移动的话，需要手动修改 `activate` 或 `activate.bat` 文件。
