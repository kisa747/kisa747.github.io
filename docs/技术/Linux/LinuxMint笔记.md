# LinuxMint 笔记

LinuxMint 有官方的中文文档：<https://linuxmint-installation-guide.readthedocs.io/zh_CN/latest/>

LinuxMint 默认文件管理器是 `nemo` ，默认的文本编辑器是 `xed`。

## LinuxMint 安装

* 推荐使用 GPT + EFI 模式安装。
* 安装时可以拔掉网线，避免联网。
* 安装中一定要选择英文，安装成功后，再配置为中文环境。否则安装中下载文件速度超级慢。

> 注意：安装 LinuxMint 过程中，只要选择语言为中文，到了磁盘分区这一步骤时，安装向导底部的按钮会被面板挡住，无法继续进行。
>
> 只要使用 Linux 下通用的一个操作技巧：ALT + 鼠标左键。即：按住 ALT 键，再用鼠标左键点住窗口空白处，然后向上拖动，即可看到安装向导底部的按钮了。
>
> 参考：<http://www.mintos.org/skill/mint-install-faq.html>

分区：

* 实测 Linux Mint 系统安装几个常用软件后，系统占用 7.6G，所以根分区推荐 20G。
* /home 建议单独一个分区，个人配置文件、Timeshit 备份文件都在这个目录。
* 不再设置 swap 分区，而是采用 swapfile 文件的方法。

参考：<https://help.ubuntu.com/community/DiskSpace>

| 挂载点             | 分区格式           | 大小  | 备注      |
|:---------------:|:--------------:|:---:|:-------:|
| /boot/efi（无需设置） | ESP 分区 (FAT32 格式) | 1G  | EFI 启动分区 |
| /               | ext4           | 20G | 根系统分区   |
| /home           | ext4           | 10G | 个人目录    |

确保硬盘是 GPT 分区

```sh
# 使用 gdisk
sudo gdisk -l /dev/sda
# 或是使用 gparted
sudo parted /dev/sda
mklabel gpt
```

或者使用 Gparted 图形工具。

> Click now on the menu item **Device** and find an option *Create Partition Table*. Click on it and see a dire warning *Warning. This will erase all data on the entire disk etc.*Heed the warning - this is your chance to go back and re-check your settings. If you decide to proceed, click on the **Advanced** button. The image will change to something similar to the following.

**注意**：安装启动引导器的设备，选择 ESP 分区，比如：`/dev/sda1`。

## 配置

### 安装后的配置

LinuxMint 在 VirtualBox 中安装，会出现花屏。解决方法：

```sh
右边的ctrl + f1
右边的ctrl + f7
右边的ctrl + f1（回到图形界面)
```

VMware 需要安装 VMware Tools，或是 `open-vm-tools`。

参考：<https://kb.vmware.com/s/article/2073803>

```sh
# 安装官方的版本，重启后生效。
# sudo ./vmware-install.pl

# 安装开源版本 VMware Tools。最新的 20 已经自动安装了。
# sudo apt install open-vm-tools open-vm-tools-desktop
# 注销然后重新登录后生效。
```

apt 相当于是 apt-get 的高级应用，安装、更新、移除软件、系统，尽量使用 apt 命令，除非遇到问题，再考虑使用 apt-get 命令。

配置软件源（菜单 - 系统管理 - 软件源），使用清华 tuna 或科大（USTC）的源，然后更新系统。

```sh
# sudo 命令免密
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/10-$USER
# 如果是双系统，设置为本地时间，保持两个系统的时间一致。
#sudo timedatectl set-local-rtc true
# 许多操作系统会默认系统时钟（主板通过电池驱动的）是 UTC，Windows 上并不是这样。多系统并存时这会带来一些困扰。在 Windows 10 系统中，以管理员身份运行：
# reg add “HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation” /v RealTimeIsUniversal /d 1 /t REG_QWORD /f

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
EOF
source ~/.bashrc

# 修改更新源，参考：https://mirrors.tuna.tsinghua.edu.cn/help/linuxmint/

sudo apt update && sudo apt upgrade

# 配置 grub
if [ ! -f /etc/default/grub.bak ]; then sudo cp /etc/default/grub /etc/default/grub.bak; fi
# GRUB 启动时间设置为 3 秒
sudo sed -i 's/^GRUB_TIMEOUT=.*$/GRUB_TIMEOUT=3/' /etc/default/grub
sudo sed -i 's/^GRUB_TIMEOUT_STYLE=/#GRUB_TIMEOUT_STYLE=/' /etc/default/grub
sudo update-grub
```

Menu - Preferences - Language，添加中文语言支持。

```sh
sudo apt install firefox-locale-zh-hans
```

菜单 - 首选项 - 输入法，添加中文输入法。

开机自动打开小键盘：

参考：<https://blog.csdn.net/ibmall/article/details/79027246>

```sh
# 开机自动打开小键盘：
sudo apt install numlockx
# 在系统设置 –> 登录窗口 –> 设置 -> 激活 numlock 开关
# sudo systemctl restart lightdm
# 修改配置文件 /etc/lightdm/lightdm.conf，添加内容
# 谨慎操作
# sudo cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.bak
# echo "greeter-setup-script=/usr/bin/numlockx on" | sudo tee -a /etc/lightdm/lightdm.conf
# 重新登录后生效
```

进入 vi 编辑后，按 backspace 无法删除，且上下键盘失灵，解决：

修改/etc/vim/vimrc.tiny 文件，将 set compatible 改成 `set nocompatible`，然后再添加一行 `set backspace=2` 即可

```sh
# 进入 vi 编辑后，按 backspace 无法删除，且上下键盘失灵，解决方法
sudo cp /etc/vim/vimrc.tiny /etc/vim/vimrc.tiny.bak
sudo sed -i '/^set compatible.*$/a set backspace=2' /etc/vim/vimrc.tiny
sudo sed -i 's/set compatible/set nocompatible/' /etc/vim/vimrc.tiny
```

修改主机名，域名：

```sh
# 修改本地主机名。修改的配置文件为 /etc/hostname
sudo hostnamectl set-hostname mint
sudo systemctl restart systemd-hostnamed.service
# 修改域名。
# 127.0.0.1 一般为 localhost，表示本地域名，可以用 localhost 域名访问本机的 IP。
# 127.0.1.1 表示的就是真正的本机域名了，使用 www 服务时，就是外部访问的域名。路由器上识别的名称也是此名称。
# 参考：https://www.debian.org/doc/manuals/debian-reference/ch05.zh-cn.html#_the_hostname_resolution
sudo sed -i 's/^.*127.0.1.1.*$/127.0.1.1       mint/' /etc/hosts
# 重启后生效
```

### 配置 python

LinuxMint 默认已经安装了 Python3，但是没有 pip

```sh
# 配置 python3
# Defaulting to user installation because normal site-packages is not writeable
sudo apt install python3-pip

# 将 python 命令指向 python3
>>> which python3
/usr/bin/python3

mkdir -p ~/.local/bin
rm ~/.local/bin/python
ln -s /usr/bin/python3 ~/.local/bin/python

. ~/.profile
# 退出重新登录，依次检查版本是否正确
python -V
python3 -V
pip -V
python -m pip -V

# Defaulting to user installation because normal site-packages is not writeable
python3 -m install -U pip
# ---------------------------------------------------------------------
```

系统默认安装了很多库，在 `/usr/lib/python3/dist-packages` ，所以普通用户没有权限更新。

查看安装了那些库：`pip list`

```sh
# 升级所有过期的包，不推荐。
pip list -o | awk 'NR>2{if ($1!="pycurl") print $1}' | xargs pip3 install --user -U
```

### 安装 ssh 服务

输入：`ps -e | grep ssh`，如果没有 sshd，说明没有 ssh server

```sh
sudo apt install openssh-server
systemctl status ssh | head -20
```

### 卸载软件

```sh
# 卸载 libreoffice
dpkg -l | grep "libreoffice"
sudo apt purge libreoffice*
sudo apt autoremove
```

### 安装字体

```sh
# wps 需要许多字体，腾讯云
cd ~ && wget https://**/fonts.tar.xz
# 字体位置，将字体放入字体目录
mkdir -p ~/.local/share
tar xavf fonts.tar.xz -C ~/.local/share
# 生成字体的索引信息，貌似没啥用
# mkfontscale && mkfontdir
# 更新字体缓存
fc-cache -fv

# 安装 FiraCode 字体
mkdir -p ~/.local/share/fonts
```

### 安装软件

LinuxMint 默认禁用了 snap，无法直接使用 apt 安装 snapd 软件包。

参考：<https://fossbytes.com/how-to-enable-snap-and-install-snap-packages-on-linux-mint-20/>

安装 snapd 方法如下：

```sh
sudo rm /etc/apt/preferences.d/nosnap.pref
```

安装其它软件：

```sh
# 安装 git
sudo apt install git git-lfs
# 安装 snap 商店
#sudo snap install snap-store
# 安装 chromium
# sudo apt install chromium-browser

# 更新 snap 软件列表
sudo apt install snapd
sudo snap refresh
snap find pycharm-community
# 经典的文本编辑器，界面比较 low。Wine 出来的，不推荐。
# sudo snap install notepad-plus-plus
# 安装 pycharm，软件包比较大，速度会比较慢。晚上慢，白天快。
# --classic 参数。The --classic option is required because the PyCharm snap requires full access to the system, like a traditionally packaged application.
sudo snap install pycharm-community --classic

# 安装 Vscode 参考：https://code.visualstudio.com/docs/setup/linux
sudo snap install --classic code
```

[pycharm 官方 snap 安装说明](https://www.jetbrains.com/help/pycharm/installation-guide.html#snap-install)

查找 snap 格式的软件：<https://snapcraft.io/store>

WPS:<http://www.wps.cn/product/wpslinux/>

<http://wps-community.org/downloads>

安装 typora，网站：<https://typora.io>

```sh
# 添加密钥
wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
# LinuxMint 19.1 无法使用 add-apt-repository 命令添加 typora 的仓库
#sudo add-apt-repository 'deb https://typora.io/linux ./'
# 手动添加 typora 仓库
echo "deb https://typora.io/linux ./" | sudo tee /etc/apt/sources.list.d/typora.list
sudo apt update && sudo apt install typora
```

Chrome:<https://www.google.cn/chrome/index.html>

搜狗拼音：<https://pinyin.sogou.com/linux/>

### 配置 samba

参考：<https://linuxmint.com/rel_tessa_cinnamon.php>

Samba changed their protocol to work with Windows 10 and that can prevent you from seing your Windows network.

To work around this issue, edit /etc/samba/smb.conf and add the following line in the [global] section:

```ini
client max protocol = NT1
```

Save the file and reboot，或是重启 samba 服务。

```sh
sudo systemctl restart smbd.service
sudo systemctl restart nmbd.service
```
