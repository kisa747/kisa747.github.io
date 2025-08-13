# Windows 包管理

Windows 下比较知名的包管理系统有 scoop、chocolatey。两个包管理系统的特点对比如下：

>chocolatey 权限要求高，scoop 使用 -g 参数安装才需要管理员权限，默认普通用户权限。
>
>scoop 可以建软件包仓库，如果官方仓库里没有想用的软件，可以自己建一个仓库，存放自己的软件。
>
>chocolatey 很多软件安装位置不固定，会污染 Path。
>
>scoop 独立安装，和已有软件不冲突
>
>scoop 没有权限对话框，因为程序安装到用户目录
>
>scoop 不会污染路径
>
>scoop 不使用 NuGet，无需担心依赖
>
>scoop 不是软件包管理器，它仅读取一个关于如何安装程序的 JSON
>
>scoop 不安装特定版本，仅仅支持最新版本
>
>scoop 专注于开发者的工具

## Scoop

Scoop 官方主页：<https://scoop.sh>

Scoop 主要支持开源软件、没有图形界面的 CLI 工具，开发工具 python、Node.js 等。

### 安装 scoop

普通用户权限 `Powershell` 下执行：

```powershell
# Optional: Needed to run a remote script the first time
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
# 下载脚本并执行
irm get.scoop.sh | iex

# 重装系统后恢复所有软件
scoop reset *
```

### 添加源

```sh
scoop bucket add versions
scoop bucket add extras
```

### 安装软件

```sh
# 修复 extract 错误
scoop install lessmsi
scoop config use_lessmsi true

# 基本工具
scoop install git
scoop install 7zip


# 开发工具
scoop install python311
scoop install nodejs-lts

# 启用 aria2 加速
scoop install aria2
scoop config aria2-enabled true
scoop config aria2-enabled false

# 开发工具
scoop install git-lfs
```

### 设置代理源

```sh
# 设置 Scoop 源
scoop config SCOOP_REPO 'https://hub.fastgit.xyz/ScoopInstaller/Scoop'

# scoop bucket rm main
scoop bucket add main 'https://hub.fastgit.xyz/ScoopInstaller/Main'
# scoop bucket rm extras
scoop bucket add extras 'https://hub.fastgit.xyz/ScoopInstaller/Extras'
# scoop bucket rm versions
scoop bucket add versions "https://hub.fastgit.xyz/ScoopInstaller/Versions"
```

### 安装其它软件

```sh
scoop update

# 图形工具
scoop install resource-hacker everything snipaste
scoop install putty

# VScode 的开源编译
scoop install vscodium
```

### 升级所有软件

```bash
@echo off
::测试
cd /d %~dp0

choco outdated || sudo choco upgrade all
call :scoop_update
pause & exit

:scoop_update
scoop status || scoop update *
exit /b
```

### 安装指定的版本

参考：<https://github.com/lukesampson/scoop/wiki/Switching-Ruby-And-Python-Versions>

```sh
 # add the 'versions' bucket if you haven't already
scoop bucket add versions
scoop search python
scoop install python
 # -> Python 3.8.2
python -V
# 安装不同版本的 python 会自动设置默认的版本
scoop install python39

# 重设 python3.10 为当前版本
scoop reset python310
python -V
```

### 常用命令

```bash
scoop help
# 添加软件仓库
scoop bucket add extras
# 移除软件仓库
scoop bucket rm extras
scoop install sudo  # sudo 权限必备
# 查找软件
scoop search python
# 安装软件
scoop install sumatrapdf
# 列出已安装的软件
scoop list
# 查看scoop状态，是否有可升级的软件
scoop status
# 升级 scoop
scoop update
# 升级所有软件
scoop update *
# 升级所有全局安装的软件
sudo scoop update * -g
# 清理
scoop cleanup *
```

默认安装至：C:\Users\kisa747\scoop\apps

全局安装至：C:\ProgramData\scoop\apps（无写权限）

## Chocolatey

Chocolatey 官方主页：<https://chocolatey.org/>

安装 Chocolatey，管理员权限运行 `Powershell`，然后执行：

```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Chocolatey 默认安装在 `C:\ProgramData\chocolatey`。

安装软件，choco 需要管理员权限，或使用 sudo 命令：

```sh
# 搜索软件包
choco search python3
# 安装软件
choco install python3
# 升级 chocolatey
choco upgrade chocolatey
# 升级所有已安装的软件
choco upgrade all
# 列出所有已安装的软件
choco list --local-only
# 列出需要升级的软件
choco outdated
# 卸载软件
choco uninstall sudo
```

choco 的安装位置在 `C:\ProgramData\chocolatey` ，但是通过 choco 安装的软件 位置却是五花八门，哪里都有，全看软件维护者的兴趣。

安装的软件列表：

```bash
sudo choco install PDFCreator
sudo choco install tim
```
