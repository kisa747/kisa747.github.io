# Debian 笔记

Debian 适合作为服务器，不太适合作为桌面环境，如果桌面环境推荐使用 Linux Mint。

## 安装

镜像下载地址：<https://mirrors.ustc.edu.cn/debian-cd/current/amd64/iso-cd/>

镜像选择 `netinst.iso` 即可，网络安装（大部分软件可以从国内源下载，但 security 源还是用的官方源，所以国内速度会比较慢）。

VMware 使用 UEFI，虚拟磁盘类型选择 `IDE`，创建完虚拟机后，编辑虚拟机设置 - 选项 - 高级 - 固件类型 UEFI。

> 或是手动在 `*.vmx` 文件末尾添加 `firmware = "efi"`。
>
> 参考：<https://communities.vmware.com/docs/DOC-28494>

如果安装桌面，推荐勾选：

>✅ Debian 桌面环境
>
>✅ Cinnamon 桌面
>
>✅ SSH Server
>
>✅ 标准系统工具

说明

>* Debian 在安装过程中设置 root 密码，就不会安装 sudo 工具。
>* 建议不设置 root 密码，创建普通用户，此用户默认在 sudo 用户组中。
>
>* 如果需要远程 SSH 登录，建议勾选 SSH Server。
>* 建议 UEFI + GPT 安装 Debian。使用 Debian 安装系统的分区工具，会在磁盘两端留 1M 的空闲空间。
>
>* 建议不创建 swap 分区。Ubuntu 早就默认取消 swap 分区了，Debian 仍推荐使用 swap 分区，其实使用 swap 分区的意义不大，个人用户建议使用 swap 文件即可。

查看系统信息

```sh
python3 -c "import platform;import pprint;pprint.pp(platform.freedesktop_os_release())"
```

## 配置

### 常用配置

```sh
# 设置命令简写
cat << "EOF" | tee ~/.bash_aliases
# 自定义命令部分
alias uu='sudo apt update && sudo apt upgrade'
alias ll='ls -alF'
alias la='ls -A'
EOF
. ~/.bashrc
```

### 配置 sudo 免密

```sh
# sudo 命令免密
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/010-$USER
```

### 修改 Debian13 更新源

Debian 官方源列表：<https://www.debian.org/mirror/list>

TUNA 的 Debian 源 [TUNA 官方说明](https://mirrors.tuna.tsinghua.edu.cn/help/debian/)

```sh
# DEB822 格式
if [ ! -f /etc/apt/sources.list.d/debian.sources.bk ]; then sudo cp /etc/apt/sources.list.d/debian.sources /etc/apt/sources.list.d/debian.sources.bk; fi

cat << "EOF" | sudo tee /etc/apt/sources.list.d/debian.sources
Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/debian
Suites: trixie trixie-updates trixie-backports
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/debian-security
Suites: trixie-security
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

# 更新系统
sudo apt update && sudo apt upgrade
```

### 修改 Testing 更新源

CD 下载地址：[每周构建版](http://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/)

参考：<https://mirrors.tuna.tsinghua.edu.cn/help/debian/>

```sh
# 配置 APT 更新源
if [ ! -f /etc/apt/sources.list.bak ]; then sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak; fi
# 推荐直接修改，更直接，而且可以添加非自有软件库。
cat << "EOF" | sudo tee /etc/apt/sources.list
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ testing main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ testing-updates main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ testing-backports main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security testing-security main contrib non-free non-free-firmware
EOF
# 更新系统
sudo apt update && sudo apt upgrade
```

### SSH 免密登录

```sh
# 没有安装 ssh，可以手动安装 ssh。使用 CD 版镜像且断开网络安装会出现此情况。
sudo apt install ssh
# 设置免密登录至虚拟机
ssh-copy-id kevin@debian.local
```

### 修改中文目录为英文

参考：<https://wiki.archlinux.org/index.php/XDG_user_directories_(简体中文)>

如果系统安装时选择的是中文，则个人目录下默认创建“桌面“、“文档”等中文目录。如果是在控制台等不具有中文输入法的情况下，想进入中文目录都会有困难，因此有必要改为英文目录。

```sh
# 本地目录强制修改为英文：Desktop  Downloads  Pictures  Templates  Documents  Music  Public  Videos
LC_ALL=C xdg-user-dirs-update --force
# 重新登录后生效
sudo systemctl restart lightdm

# 在 $HOME 下创建一整套默认的经本地化的用户目录。
# xdg-user-dirs-update
```

### Lightdm 登录

参考：<https://github.com/CanonicalLtd/lightdm>

<https://wiki.debian.org/zh_CN/LightDM>

<https://wiki.ubuntu.com/LightDM>

<https://wiki.archlinux.org/index.php/LightDM_(简体中文)>

```sh
# ---------------------------------------------
# 开机自动打开小键盘
sudo apt-get install numlockx -y
# 这个能使登录后自动打开 numlock，但是登录界面还是无法自动打开。
sudo dpkg-reconfigure numlockx
# ---------------------------------------------
# 配置登录界面自动打开小键盘
sudo mkdir -p /etc/lightdm/lightdm.conf.d  # Debian 默认没有这个目录
cat << EOF | sudo tee /etc/lightdm/lightdm.conf.d/${USER}.conf
[Seat:*]
# 显示用户列表。Debian 默认不显示用户列表，因为 Debian 认为不应该暴露系统的用户名。
greeter-hide-users=false
# 虚拟机环境下设置为自动登录。
autologin-user=$USER
# 设置在登录界面就自动打开 nublock。
greeter-setup-script=/usr/bin/numlockx on
EOF
# 重新登录后生效
sudo systemctl restart lightdm

# [不推荐] 直接修改主配置文件登录界面自动打开 numlock，
#if [ ! -f /etc/lightdm/lightdm.conf.bak ]; then sudo cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.bak; fi
#sudo sed -i -e 's|^#greeter-setup-script=|greeter-setup-script=/usr/bin/numlockx on|g' /etc/lightdm/lightdm.conf
```

Cinnamon 和 Xfce 都使用了 LightDM 登录模块，按照以下顺序读取配置文件。普通用户，修改 `/etc/lightdm/lightdm.conf`即可。

```ini
/usr/share/lightdm/lightdm.conf.d/*.conf
/etc/lightdm/lightdm.conf.d/*.conf
/etc/lightdm/lightdm.conf
```

可能需要安装一个 greeter。greeter 是提示用户输入密码的 GUI 界面。如果配置了自动登录，可以不使用 greeter。参考的 greeter 是 lightdm-gtk-greeter，默认的配置会使用它，配置文件是 `/etc/lightdm/lightdm.conf`，或 `/etc/lightdm/lightdm-gtk-greeter.conf.d` 目录内的配置文件。

默认 greeter，配置文件在 `/usr/share/lightdm/lightdm.conf.d/01_debian.conf`。

```ini
[Seat:*]
# 指向 usr/share/xgreeters/lightdm-greeter.desktop
greeter-session=lightdm-greeter
```

Ubuntu 与 Debian 的不太一样，LinuxMint 甚至还使用了 [slick-greeter](https://github.com/linuxmint/slick-greeter)，Ubuntu 系统确实比 Debian 复杂，还是 Debian 简单些。

修改登录背景，修改 `lightdm-gtk-greeter.conf` 配置文件即可。

修改登录界面自动打开 numlock。

### 删除不常用软件

```sh
# 卸载 libreoffice
dpkg -l | grep "libreoffice"
sudo apt remove --purge libreoffice*
sudo apt autoremove
```

### 配置 python

 从 Debian12 开始，无法直接使用 `pip` 命令安装包，[Python 解释器标记为由外部管理](https://www.debian.org/releases/stable/amd64/release-notes/ch-information.zh-cn.html#python3-pep-668) 。

根据提示信息，Debian 推荐：

* 没有命令行工具的库，推荐使用虚拟环境方法安装。
* 有命令行工具的库，推荐使用 pipx 方法安装。

#### 最佳实践

[pipx 官方文档](https://pipx.pypa.io/stable/)

```sh
sudo apt update
sudo apt install pipx python3-pip
pipx ensurepath

pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip config set global.extra-index-url "https://mirrors.ustc.edu.cn/pypi/simple"
pip config set install.upgrade true

pipx install --index-url https://pypi.tuna.tsinghua.edu.cn/simple uv

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
```

使用 uv 管理 python

```sh
# 安装最新版的 python
uv python install

# 有命令行的工具
uv tool install you-get
# 更新 shell
uv tool update-shell
# 直接使用命令
you-get

# 临时使用工具
uvx pycowsay "Hello!"

  ------
< Hello! >
  ------
   \   ^__^
    \  (oo)\_______
       (__)\       )\/\
           ||----w |
           ||     ||
```

创建项目，创建虚拟环境

```sh
mkdir myproject && cd myproject
uv init -p 3.13
# 添加一个第三方库
uv add pypdf
```

运行虚拟环境下的程序

```sh
# 运行脚本
~/.local/bin/uv run --project ~/myproject ~/myproject/main.py

# 注意：项目配置文件里需要配置有 [build-system]
# 运行命令行模块
~/.local/bin/uv run -m --project ~/myproject xpdf
```

安装指定版本的 python，并设置系统默认的版本，也就是 python3、python 命令指向这个版本

```sh
# 既然都用 uv 全面接管了，系统默认版本就没有修改的必要了
uv python install 3.13 --default

# 测试
python3 -V
python -V
```

#### 官方推荐的方法

```sh
# Debian 下默认没有 venv
sudo apt install python3-venv
mkdir -p ~/.local/venv
python3 -m venv ~/.local/venv
~/.local/venv/bin/python -m pip -V

# 设置命令别名
cat << "EOF" | tee ~/.bash_aliases
# 自定义命令部分
XZ_OPT="-T0"
alias ll='ls -alF'
alias la='ls -A'
alias uu='sudo apt update && sudo apt upgrade'
alias temp="awk -v x=\$(cat /sys/class/thermal/thermal_zone0/temp) 'BEGIN{printf \"%-4.2f C\\n\",x/1000}'"
alias sc="systemctl"
alias jc="journalctl"
alias py="~/.local/venv/bin/python3"
alias pi="~/.local/venv/bin/pip"
function readini(){
    FILENAME=$1; SECTION=$2; KEY=$3
    RESULT=`awk -F ' = ' '/\['$SECTION'\]/{a=1}a==1&&$1~/'$KEY'/{print $2;exit}' $FILENAME`
    echo $RESULT
}
EOF
source ~/.bashrc

# 测试
py -V
py -m pip -V
pi -V
# 检查 python 变量
py -c "import sys;print(sys.path)"


pi config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pi config set install.upgrade true

py -m pip install -U pip
pi install -U wheel setuptools
```

如果安装带命令行的包，可以使用 pipx

```python
sudo apt install pipx
```

使用过 pipx 安装 python 库，会自动创建一个单独的虚拟环境，而且会把命令行工具添加到环境变量中

```sh
pipx install you-get

# 可以直接使用 you-get 命令
you-get --help
```

#### 传统方法

```sh
# 安装 pip
sudo apt install python3-pip
# Debian13 使用 pip 安装包，会提醒 error: externally-managed-environment
# 配置可以使用 pip 直接安装包
pip config set global.break-system-packages true

# 修改 pip 配置
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip config set global.extra-index-url "https://mirrors.ustc.edu.cn/pypi/simple"
pip config set install.upgrade true
# 查看配置
pip config list

# 更新 pip
python3 -m pip install -U pip
# 重新登录 shell 后 PATH 变量自动生效。
# 依次检查版本是否正确
python3 -V
pip -V
python -m pip -V
```

### 中文配置

安装 Debian 过程中，如果不使用网络，可能存在中文的问题（未安装中文输入法，中文显示乱码）。

参考：<https://www.jianshu.com/p/6a363d88fd13>

<https://wiki.archlinux.org/index.php/Fcitx_(简体中文)>

<https://help.ubuntu.com/community/MetaPackages>

通过 `im-config` 配置程序，能看到 fcitx 的安装指南

```sh
# 安装后界面为英文
sudo dpkg-reconfigure locales

# 缺少中文输入法。使用 CD 版、DVD 版且断开网络安装会出现此情况。
# 安装中文输入法
# fcitx-sunpinyin fcitx-googlepinyin，fcitx 默认只是一个输入法框架，要输入中文，需要安装输入引擎。
# fcitx-table-all 是个 Metapackage（功能包合集，把一些相近的功能模块、软件包放到一起的功能包合集）。包含了一下内容：
#  推荐：fcitx-table-bingchan fcitx-table-cangjie fcitx-table-dianbaoma fcitx-table-erbi
# fcitx-table-wanfeng fcitx-table-wbpy fcitx-table-wubi fcitx-table-ziranma
# fcitx-frontend-all 也是一个 Metapackage。包含了：fcitx-frontend-gtk2, fcitx-frontend-gtk3, fcitx-frontend-qt4, fcitx-frontend-qt5
sudo apt install fcitx fcitx-sunpinyin fcitx-googlepinyin fcitx-table-all fcitx-frontend-all fcitx-ui-classic fcitx-ui-light
# 重启 lightdm，就可以使用中文输入法了。
sudo systemctl restart lightdm

# 如果中文乱码，需要安装 noto 字体。使用 CD 版镜像且断开网络安装会出现此情况。
# fonts-noto 是一个 Metapackage。包含了 fonts-noto-core，fonts-noto-cjk, fonts-noto-cjk-extra, fonts-noto-color-emoji, fonts-noto-extra, fonts-noto-mono, fonts-noto-ui-core, fonts-noto-ui-extra, fonts-noto-unhinted
sudo apt install fonts-noto
```

### 安装 sudo

如果设置了 root 密码，系统默认没有安装 `sudo`，需要先安装 `sudo`。

```sh
user_name=$USER

su
apt update && apt install sudo
usermod -a -G sudo ￥user_name

# 切换至当前用户
su - $USER
# 测试是否有效
sudo apt update && sudo apt upgrade
```

### Samba 工具

```sh
# 安装网络共享 samba
sudo apt install samba
# 命令行访问 smb 共享
#sudo apt install smbclient
# 挂载共享目录的工具
#sudo apt install cifs-utils
# 文件管理器访问 smb 协议的后端工具
#sudo apt install gvfs-backends
```

### 修改 GRUB 启动时间

```sh
#  GRUB 默认超时时间是 5 秒。GRUB 启动时间设置为 3 秒
if [ ! -f /etc/default/grub.bak ]; then sudo cp /etc/default/grub /etc/default/grub.bak; fi
sudo sed -i 's/^GRUB_TIMEOUT=.*$/GRUB_TIMEOUT=3/' /etc/default/grub
sudo update-grub
```

### VM Tools 工具

在 VMWare 中安装的 Debian，会自动安装开源版本的 VM tools，如果有问题，可以检查一下包的安装情况

```sh
# 安装开源版本的 VM tools，Debian 11 已经自动安装了这两个包。
# 查看 VM tools 版本
vmtoolsd -v
# 查看运行状态
systemctl status vmtoolsd
# 如果没有安装，就手动安装
sudo apt-get install open-vm-tools open-vm-tools-desktop
# 注销然后重新登录后生效。
sudo reboot
```

### 安装 xfce 桌面

如果安装时没有选择桌面环境，手动安装 xfce 桌面

参考：<https://linuxcapable.com/how-to-install-xfce-on-debian-linux/>

```sh
#xfce4-goodies 很多使用工具，lightdm 登录管理器
sudo apt install xfce4-goodies xfce4 lightdm
sudo apt install network-manager-gnome

sudo apt install task-xfce-desktop
# sudo apt autoremove '^xfce' task-xfce-desktop --purge
# 安装中文支持
sudo apt install fonts-wqy-zenhei
# --------------------------------------------------
# 配置 Lightdm 登录
# --------------------------------------------------
# 安装常用软件
sudo apt install chromium chromium-l10n
```

## 其他

### 使用 Swapfile 交换文件

相比于使用一个磁盘分区作为交换空间，使用交换文件可以更方便地随时调整大小或者移除。当磁盘空间有限（例如常规大小的 SSD）时，使用交换文件更加理想。

可以手动方式使用 Swap 文件，也可以安装 dphys-swapfile，自动配置 Swap 文件。

下面是手动方式：

```sh
# 手动方式建立
swap_file="/var/swap"
sudo fallocate -l 1G $swap_file
# 注意：fallocate 命令用在 F2FS 或 XFS 文件系统时可能会引起问题。
# 代替方式是使用 dd 命令，但是要慢一点。
# sudo dd if=/dev/zero of=$swap_file bs=1M count=1024
# 为交换文件设置权限（默认权限是 644）：（交换文件全局可读是一个巨大的本地漏洞）
sudo chmod 600 $swap_file
sudo mkswap $swap_file
if [ ! -f /etc/fstab.bak ]; then sudo cp /etc/fstab /etc/fstab.bak; fi
# sw 意思是当使用 swapon -a 命令时生效。
cat << EOF | sudo tee -a /etc/fstab
$swap_file none swap sw 0 0
EOF
# 启用所有 Swapfile
sudo swapon -a
# 或是
# sudo swapon $swap_file
free -h
# ---------------------------------------------
# 删除 swapfile 文件。
# 如果要删除一个交换文件，必须先停用它。
sudo swapoff -a
sudo rm -f $swap_file
# 最后从 /etc/fstab 中删除相关条目
cat /etc/fstab
sudo sed -i '/^\/.*none\sswap\ssw.*$/'d /etc/fstab
cat /etc/fstab
```

下面是 dphys-swapfile 方式：

参考：<https://manpages.debian.org/buster/dphys-swapfile/dphys-swapfile.8.en.html>

<https://wiki.archlinux.org/index.php/Swap_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>

```sh
# 检查交换空间的状态
sudo swapon -s
# 临时关闭交换分区，重启后系统还会根据 /etc/fstab 配置文件使用交换分区
# GPT 分区情况下，删除 /etc/fstab 中 swap 条目也不行，systemd-gpt-auto-generator 检查根磁盘来生成单位。这个机制仅在 GPT 磁盘上运行，并可通过类型代码 82 识别交换分区。
sudo swapoff -a
sudo swapon -s

# ---------------------------------------------
# 安装 dphys-swapfile 软件包
sudo apt-get install dphys-swapfile
# 自动计算交换文件的大小，也可以自行修改 /etc/dphys-swapfile 文件，手动设置交换文件的大小。
sudo dphys-swapfile setup
sudo systemctl restart dphys-swapfile.service

# 查看内存、虚拟内存使用情况
sudo swapon -s
free -h
```

### APT 包管理

Debian 有一套完整、严谨的包管理系统。

默认的 `sources.list` 的内容，默认安装只有 main，没有 contrib、non-free，

```ini
if [ ! -f /etc/apt/sources.list.bak ]; then sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak; fi
cat << EOF | sudo tee /etc/apt/sources.list
# 主要仓库
deb https://mirrors.ustc.edu.cn/debian/ $(lsb_release -cs) main contrib non-free
# 安全更新
deb https://mirrors.ustc.edu.cn/debian-security $(lsb_release -cs)/updates main contrib non-free
# 稳定更新
deb https://mirrors.ustc.edu.cn/debian/ $(lsb_release -cs)-updates main contrib non-free
# 计划更新
#deb https://mirrors.ustc.edu.cn/debian $(lsb_release -cs)-proposed-updates main contrib non-free
# 向后移植到稳定版 (Stable Backports)
deb https://mirrors.ustc.edu.cn/debian/ $(lsb_release -cs)-backports main contrib non-free
# testing 仓库
#deb https://mirrors.ustc.edu.cn/debian/ testing main contrib non-free
EOF

# 调低 testing 源的优先级
cat << "EOF" | sudo tee /etc/apt/preferences.d/10preferences
Package: *
Pin: release a=proposed-updates
Pin-Priority: 450

Package: *
Pin: release a=buster-backports
Pin-Priority: 400

Package: *
Pin: release a=testing
Pin-Priority: 300
EOF
```

此文件列出了 与 Debian Jessie 版本相关软件包的所有来源（此手册写作当前稳定版本）。我们不希望当下一个稳定版本发布时，所有基于它的分支在我们控制范围外被改变，因此决定用“Jessie”而不是用相对应的“stable““稳定”的别名（`stable`, `stable-updates`, `stable-backports`）来命名。

也就是说一个稳定版有 buster、debian-security、buster-updates、buster-backports、buster-proposed-updates 共 5 个源。

参考：<https://www.debian.org/doc/manuals/debian-handbook/apt.zh-cn.html>

[proposed-updates（拟议更新）机制](https://www.debian.org/releases/proposed-updates.zh-cn.html)

>xxx-proposed-updates：
>
>在稳定版的基础上的更新也会进行 release，比如 10.1、10.2、7.3 等等，这些 release 被称为 point release，而这个 proposed-updates 就是为下一次的 point release 做准备工作的，也就是说，对稳定版本的更新先放在 proposed-updates 里面，然后积累到了一定的量之后发布 point release。
>
>xxx-backports
>
>就是同一个发行版的 unstalble、testing 中的包，在 stable 下重新编译，使之可以在 stable 版本下使用。

## Debian 版本更新

### Debian 13

代号：Trixie

* python3.13
* **APT 3.0** 成为默认包管理器

### Debian 12

发行信息：<https://www.debian.org/releases/stable/amd64/release-notes/ch-whats-new.zh-cn.html>

* Linux 主线内核 6.1
* 在安装程序中的非自由软件包
* GNOME 在默认情况下，使用 Pipewire 和 Wireplumber 管理器 作为声音服务器，取代了 Pulseaudio
* Debian 12 引入 Apt 软件包管理器的最新的版本 APT2.
* Python 3.11
* Debian 12 现在在双启动设置时可以检测到 Windows 11
* [“合并的 `/usr`”现在是必需的](https://www.debian.org/releases/stable/amd64/release-notes/ch-information.zh-cn.html#a-merged-usr-is-now-required)
* [Python 解释器标记为由外部管理](https://www.debian.org/releases/stable/amd64/release-notes/ch-information.zh-cn.html#python3-pep-668)

### Debian 11

发行信息：<https://www.debian.org/releases/bullseye/amd64/release-notes/index.zh-cn.html>

* 本软件源中 `buster` 换成 `bullseye`，注意其中的安全更新的路径废弃了之前 buster/update 的命令方式，使用了 bullseye-security 格式。

* 持久化 systemd 日志。在 bullseye 中的 systemd 默认启用了持久日志的功能，日志文件存放于 `/var/log/journal/`。请参见 [systemd-journald.service(8)](https://manpages.debian.org//bullseye/systemd/systemd-journald.service.8.html) 以了解细节；请注意 Debian 中的日志除了默认的 `systemd-journal` 组外，还可以被 `adm` 用户组内的成员阅读。

* 新的 Fcitx 5 输入法。Fcitx 5 是用于中文、日语、韩语和其它许多语言的一个输入法。它是 buster 提供的 Fcitx 4 的后续版本。新版本增加了对 Wayland 的支持并改进了扩展支持。您可以在 [维基页面上](https://wiki.debian.org/I18n/Fcitx5) 阅读更多信息以及从旧版本迁移的方法。

* 内核 exFAT 支持

    bullseye 是第一个提供支持 exFAT 文件系统的 Linux 内核的发行版本，且它默认使用该实现挂载 exFAT 文件系统。因此，用户不再需要使用 `exfat-fuse` 软件包所提供的用户空间文件系统实现。如果您要继续使用用户空间文件系统的实现，您需要在挂载 exFAT 文件系统时直接调用 **mount.exfat-fuse** 命令。

    创建和检查 exFAT 文件系统的工具位于 `exfatprogs` 软件包，它由 Linux 内核 exFAT 实现的作者编写。由已有的 `exfat-utils` 软件包提供的独立实现仍然可用，但它不能与新的实现共同安装在系统上。我们推荐您迁移到使用 `exfatprogs` 软件包，尽管您需要注意并处理两者可能不互相兼容的命令行选项。

### Debian 10

更新日志参考官方文档：<https://www.debian.org/releases/buster/amd64/release-notes/>

Debian 从版本 10 开始支持 UEFI 安全启动，推荐使用 UEFI + GPT 安装 Debian。

unattended-upgrades 支持 Stable 版的小版本号的无人值守升级。

Cryptsetup 默认在磁盘上使用 LUKS2 格式。

在全新安装系统时，/bin、/sbin 和 /lib 目录下的内容将默认安装至对应的 /usr 目录下的位置。/bin、/sbin 和 /lib 将变成指向 /usr/ 下面真实目录的软链接。

## BUG

### typora

typora 安装后无法启动。

```sh
sudo chown root /usr/share/typora/chrome-sandbox
sudo chmod 4755 /usr/share/typora/chrome-sandbox
```
