# 树莓派笔记

官方文档：<https://www.raspberrypi.org/documentation/>

科大源：<http://mirrors.ustc.edu.cn/help/raspbian.html>

<http://mirrors.ustc.edu.cn/help/archive.raspberrypi.org.html>

## 总结

### 极简配置

- 下载 [Raspbian Lite](https://www.raspberrypi.com/software/operating-systems/)、[Raspberry Pi Imager](https://www.raspberrypi.com/software/)
- 准备一个至少 16G 的优盘，使用 Raspberry Pi Imager 工具将 `*-*-*-raspbian-*-lite.zip` 烧录至优盘。
- 拔出 U 盘再插入电脑。
- 在 TF 卡的 boot（FAT32 格式）分区根目录里面创建一个名为 `ssh`  空文件（不要有 txt 后缀！）。
- 树莓派插上电源、U 盘、网线、显示器（非必须），开机！
- 使用 SSH 登录，用户名：`pi`，密码：`raspberry`

```bash
# ssh登录树莓派
ssh pi@raspberrypi.local
# 修改当前用户密码
passwd
# 下载脚本并执行
wget -qO- https://gitee.com/kisa747/kisa747/raw/master/data/set-raspi.sh | bash
# 重启树莓派
sudo reboot
```

### 额外配置

```sh
# 设置开机挂载移动硬盘
sudo mkdir -p /mnt/sdb1 /mnt/sdb2
if [ ! -f /etc/fstab.bak ]; then sudo cp /etc/fstab /etc/fstab.bak; fi
cat << "EOF" | sudo tee -a /etc/fstab
/dev/sdb1  /mnt/sdb1  auto  defaults,noatime,nofail,x-systemd.automount,x-systemd.device-timeout=30  0  2
/dev/sdb2  /mnt/sdb2  auto  defaults,noatime,nofail,x-systemd.automount,x-systemd.device-timeout=30  0  2
EOF
sudo mount -a
# ---------------------------------------------------------------------
# 配置目录的软连接
mkdir -p ~/Sync
rm ~/Sync/科技馆 2>/dev/null
ln -s /mnt/sdb1/bak/Sync/科技馆 ~/Sync/科技馆
rm ~/download 2>/dev/null
ln -s /mnt/sdb1/orico/Download ~/Download
rm ~/Bing 2>/dev/null
ln -s /mnt/sdb1/orico/Pictures/Bing ~/Bing
rm ~/sdb1 2>/dev/null
ln -s /mnt/sdb1 ~/sdb1
rm ~/sdb2 2>/dev/null
ln -s /mnt/sdb2 ~/sdb2
# ---------------------------------------------------------------------
# 以上都可以自动执行，无需人工干预。
# ---------------------------------------------------------------------
# 此时可以配置 syncthing 同步。
# ---------------------------------------------------------------------
# 配置 samba
# samba 添加当前用户，并修改密码
sudo smbpasswd -a $USER
# 禁用 nmbd 服务，可以关闭局域网发现功能，只能通过 ip 地址访问共享。
sudo systemctl restart nmbd
sudo systemctl restart smbd
# ---------------------------------------------------------------------
# 配置 python
# 配置完 syncthing 后，添加 python 环境变量'myapplication.pth'
python3 ~/Sync/py/packages/set-pth.py
# 安装依赖的库
pip3 install -r ~/Sync/py/cron/requirements_linux.txt
# 授权 bypy
# bypy list
# 最后复制 python 包的 cfg 文件。
# ---------------------------------------------------------------------
# 清理登录信息
if [ ! -f /etc/motd.bak ]; then sudo mv /etc/motd /etc/motd.bak; fi
# sudo sed -i 's/^[^#].*$/## &/g' /etc/motd
cat << "EOF" | sudo tee /etc/update-motd.d/11-$USER
#!/bin/sh
echo ""
df -Th -x tmpfs -x devtmpfs
echo ""
EOF
sudo chmod 755 /etc/update-motd.d/11-$USER
# ---------------------------------------------------------------------
# 修改 swap
if [ ! -f /etc/dphys-swapfile.bak ]; then sudo cp /etc/dphys-swapfile /etc/dphys-swapfile.bak; fi
cat << EOF | sudo tee /etc/dphys-swapfile
CONF_SWAPFILE=/home/swap
# CONF_SWAPSIZE=100
EOF
sudo systemctl restart dphys-swapfile.service
# ---------------------------------------------------------------------
# 修改 SSH 端口
if [ ! -f /etc/ssh/sshd_config.bak ]; then sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak; fi
# 测试
# sed -n 's|^#\?Port\s[0-9]\{2,5\}$|Port 9002|p' /etc/ssh/sshd_config
sudo sed -i 's|^#\?Port\s[0-9]\{2,5\}$|Port 20002|g' /etc/ssh/sshd_config
# 重启 ssh 服务，Debian、Ubuntu 只有服务名称为 ssh，CentOS 服务为 sshd。
sudo systemctl restart ssh
# ---------------------------------------------------------------------
# 配置 APT 自动升级
# ---------------------------------------------------------------------
# 配置 S-nail 邮件功能
# ---------------------------------------------------------------------
# 配置硬盘自动休眠
# ---------------------------------------------------------------------
```

### 计划任务

dom: day of month 1~31

month：1~12

dow：day of week 0~7 周日是 0 或 7。

```sh
# 重启任务应该放到 root 用户下的 crontab。
cat << EOF | sudo crontab
# minute hour  dom month dow   command
# 每天 05:10 重启
# 10 5 * * 0 sleep 70 && reboot
# 每周六 05:10 重启
10 5 * * 6 sleep 70 && reboot
EOF
sudo crontab -l
# ---------------------------------------------------------------------
cat << EOF | crontab
# minute hour  dom month dow   command
# 每周六 03:32 执行 weekly.py
32 5 * * 6 /usr/bin/python3 $HOME/Sync/py/cron/weekly.py >$HOME/Sync/py/cron/weekly_screen.log 2>&1 &
# 每天 00:50 执行 daily.py
50 0 * * * /usr/bin/python3 $HOME/Sync/py/cron/daily.py >$HOME/Sync/py/cron/daily_screen.log 2>&1 &
# 6 * * * *  /usr/bin/python3 $HOME/sync/py/cron/hourly.py >$HOME/sync/py/cron/hourly_screen.log 2>&1 &
EOF

# 检查 cron 状态
crontab -l
systemctl status cron -l --no-pager
```

还有一种新型的方法是使用 `systemd` 的 timer 功能。

### 树莓派的常用命令

```sh
# 查看 cpu 信息
lscpu
cat /proc/cpuinfo
# 更多参考 https://elinux.org/RPI_vcgencmd_usage
# 查看 cpu 温度
cat /sys/class/thermal/thermal_zone0/temp
awk -v x=$(cat /sys/class/thermal/thermal_zone0/temp) 'BEGIN{printf "%-4.2f C\n",x/1000}'
vcgencmd measure_temp
# 测量树莓派的核心电压
vcgencmd measure_volts core
# 查看时间的设置
timedatectl status

# 查看除根分区外所有磁盘的检查情况
systemctl status systemd-fsck@*.service
# 查看 sdb1 磁盘的检查情况
systemctl status systemd-fsck@dev-sdb1.service
# 查看 sdb2 磁盘的检查情况
systemctl status systemd-fsck@dev-sdb2.service
# 查看根分区 / 磁盘的检查情况
systemctl status systemd-fsck-root.service
# 查看 hd-idle 服务的运行情况
systemctl status hd-idle.service

# 查看启动耗时
systemd-analyze
# 查看每个服务的启动耗时
systemd-analyze blame

# 查看系统开机时间
date -d "$(awk -F. '{print $1}' /proc/uptime) second ago" +"%Y-%m-%d %H:%M:%S"

# 修改 crontab、visudo 等的默认编辑器，默认 nano，推荐使用 nano
select-editor

# 树莓派有个专门的设置工具，可以设置开启 ssh、键盘、时区，扩展分区等功能。
# set-raspi.sh 脚本里已经全部设置过了。
sudo raspi-config

sudo apt install manpages-zh
man journalctl
```

## 安装系统

参考：<https://blog.csdn.net/kxwinxp/article/details/78370913>

<http://www.ruanyifeng.com/blog/2017/06/raspberry-pi-tutorial.html>

<https://www.raspberrypi.org/documentation/installation/installing-images/README.md>

<https://www.raspberrypi.org/documentation/installation/installing-images/windows.md>

<https://www.raspberrypi.org/documentation/installation/noobs.md>

<https://www.raspberrypi.org/learning/software-guide/>

[树莓派资源整理汇总 (2018 年 10 月 14 日更新)](http://blog.lxx1.com/1879)

参考：[树莓派与 Linux](https://www.cnblogs.com/vamei/archive/2012/10/10/2718229.html)

参考 [官方文档](https://github.com/raspberrypi/documentation/blob/master/hardware/raspberrypi/bootmodes/msd.md) 的说法，3B+ 默认已经支持 USB 启动。

>The Raspberry Pi 3+ is able to boot from USB without any changes

最新版的 4B（2020 年 9 月 3 日之后的版本）原生支持 USB 启动，并且支持切换启动设备（SD、USB），参考 [Raspberry Pi 4 bootloader configuration](https://github.com/raspberrypi/documentation/blob/master/hardware/raspberrypi/bcm2711_bootloader_config.md)

需要准备的软件：

>- [SD Memory Card formatter](https://www.sdcard.org/chs/downloads/formatter_4/eula_windows/index.html)  SD 卡格式化工具
>- USB 启动的话如果要使用 NOOBS，Windows 自带的格式化工具仅能处理 32G 的 FAT32 分区（参考 [官方文档](https://github.com/raspberrypi/documentation/blob/master/installation/sdxc_formatting.md) ），如果大于 32G 需要用到 [FAT32 Format](http://www.ridgecrop.demon.co.uk/guiformat.htm) 小工具
>- [**Etcher**](https://etcher.io/)  系统烧录工具，或者是 [Win32DiskImager](https://sourceforge.net/projects/win32diskimager/files/Archive/)
>- [Raspberry Pi Imager](https://www.raspberrypi.org/software/) 树莓派官方出品的烧录工具。
>- ~~更简单的使用官方出品的 [NOOBS](https://www.raspberrypi.org/downloads/noobs/)~~

查看分区使用情况：

- boot 分区 44M 已使用 23M
- / 分区 4.9G 已使用 92%，可用空间 400M
- 空闲 9.5G

看来设置好后需要第一时间调整系统主分区容量。两个方法：

- 进入树莓派系统后，通过 `sudo raspi-config` 工具，将主分区扩展至整个 U 盘
- 将 U 盘挂载到 Linux 系统下，使用 Gparted 工具任意调整主分区大小，然后调整 boot 分区 cmdline.txt。

```sh
# 使用 blkid 命令查看设备标识
/dev/sda1: LABEL="boot" UUID="9304-D9FD" TYPE="vfat" PARTUUID="de0f354a-01"
/dev/sda2: LABEL="rootfs" UUID="29075e46-f0d4-44e2-a9e7-55ac02d6e6cc" TYPE="ext4" PARTUUID="de0f354a-02"
# 默认主分区使用 PARTUUID 标识
dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=PARTUUID=de0f354a-02 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait
# 修改为使用设备名标识
dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=/dev/sda2 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait
```

调整后，boot 分区不变，主分区调整为 10G，扩展分区 4.7G 格式化 ext4 分区，稍后将它挂载到 `/home`

### 开启 SSH

- 如果没有连接显示器，需要提前开启 SSH 功能。因为自 2016 年 9 月开始，raspberry 默认关闭 ssh 连接。

>在 TF 卡 FAT32 分区里面创建一个名为“ssh”空文件即可（不要有 txt 后缀！）

### 配置无线网络

如果没有有线网络，只有 WIFI，需要提前配置好 WIFI 信息。

在 boot 分区创建 `wpa_supplicant.conf` 文件，内容如下：

参考：<https://github.com/raspberrypi/documentation/blob/master/configuration/wireless/wireless-cli.md>

进入系统可以使用以下命令编辑：

```sh
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf
```

内容如下：

```ini
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
# 3B+ 板子使用 5G 网络，需要设置国家代码，便于识别正确的 frequency bands
country=CN

# priority 是指连接优先级，数字越大优先级越高（不可以是负数）。
# 可见网络，有密码，优先级 1
network={
    ssid="testing"
    psk="testingPassword"
    priority=1
    id_str="home1"
}
# 隐藏的 WIFI，有密码，优先级 2
network={
    ssid="yourHiddenSSID"
    scan_ssid=1
    psk="Your_wifi_password"
    priority=2
    id_str="home2"
}
```

修改成功后，重新配置下无线网卡即可。

```sh
# 重新配置无线网卡
wpa_cli -i wlan0 reconfigure
```

### 开机

连接显示器，网线连接路由器，插上电源，开机！

登录账号：

>用户名：pi
>
>密码：raspberry

进入系统后设置，新版的 rasbian 系统首次启动会自动扩展分区。树莓派默认采用的 MBR 格式，系统安装后会自动扩展到整个 U 盘。

然后运行配置脚本。

```bash
sh /boot/set-raspi.sh
```

### SSH 登录

推荐在路由器上是指 IP 与 MAC 地址绑定。

```bash
# 查看树莓派ip地址
hostname -I
ip address
```

然后在 putty 的 Host Name or IP 栏填写 `pi@192.168.31.33`

更方便的，树莓派提供了对 Bonjour 的支持。Bonjour 用于自动发现网络上的设备，可以实现局域网上的自动域名解析。在同一局域网下，可以用 `主机名.local` 的形式，找到对应的 IP 地址。

```bash
# 查看树莓派的hostname
hostname
```

然后在 putty 的 Host Name or IP 栏填写 `pi@raspberry.local`

SSH 免密登录：

```sh
# 设置 ssh 免密自动登录
mkdir -p ~/.ssh
cat << "EOF" | tee ~/.ssh/authorized_keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIA1iWXQrl0Ul0mcGwkqYTpITl1bGx+Lrdjl60icFMZM LOVE_2025
EOF
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# 使用这个工具更好，自动配置权限
ssh-copy-id pi@raspi.local
sudo systemctl restart ssh
```

putty 中选择对应的密钥就行了。其实 git bash 里面是包含 ssh 命令的。

创建 start.sh，内容如下：

```sh
#!/usr/bin/env bash
# ssh 登录
ssh pi@raspi.local
```

相同目录下创建一个 ssh.vbs，内容如下：

```vb
CreateObject("WScript.Shell").Run "D:\App\PortableGit\git-bash.exe start.sh",0
```

以后双击运行 ssh.vbs，就能使用 git bash 登录树莓派了。

### 基本配置

运行完配置脚本后，建议连接显示器、鼠标、键盘，首次登陆会有个向导，帮忙自动设置语言、区域、时区，会自动安装上 fctix 输入法。

先修改默认源：

参考：<https://mirrors.ustc.edu.cn/help/raspbian.html>

<https://mirrors.ustc.edu.cn/help/archive.raspberrypi.org.html>

```sh
# 修改 raspbian 的系统源
if [ ! -f /etc/apt/sources.list.bak ]; then sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak; fi
cat /etc/apt/sources.list
sudo sed -i 's|raspbian.raspberrypi.org|mirrors.ustc.edu.cn/raspbian|g' /etc/apt/sources.list
cat /etc/apt/sources.list

# 修改 raspbian 的软件源
if [ ! -f /etc/apt/sources.list.d/raspi.list.bak ]; then sudo cp /etc/apt/sources.list /etc/apt/sources.list.d/raspi.list.bak; fi
cat /etc/apt/sources.list.d/raspi.list
sudo sed -i 's|//archive.raspberrypi.org|//mirrors.ustc.edu.cn/archive.raspberrypi.org|g' /etc/apt/sources.list.d/raspi.list
cat /etc/apt/sources.list.d/raspi.list

# 设置命令简写
cat << "EOF" | tee ~/.bash_aliases
# 自定义命令部分
alias uu='sudo apt update && sudo apt upgrade'
alias ll='ls -alF'
alias la='ls -A'
alias temp="awk -v x=\$(cat /sys/class/thermal/thermal_zone0/temp) 'BEGIN{printf \"%-4.2f C\\n\",x/1000}'"
EOF
. ~/.bashrc

# 树莓派上有不少的硬件，如 WiFi 适配器、蓝牙适配器等等。这些硬件都有特定的固件支持。有时候树莓派安装的是比较旧的固件，可能会带来一些问题。可以从命令行更新固件：
sudo rpi-update
# 进入 vi 编辑后，按 backspace 无法删除，且上下键盘失灵，解决方法
sudo cp /etc/vim/vimrc.tiny /etc/vim/vimrc.tiny.bak
sudo sed -i '/^set compatible.*$/a set backspace=2' /etc/vim/vimrc.tiny
sudo sed -i 's/set compatible/set nocompatible/' /etc/vim/vimrc.tiny
```

但是我们要学习一些基础的命令，所以还是学习一下背后是如何工作的。

```bash
# 默认主机名是 raspberrypi，修改为 raspi
# 命令方式修改，然后重新启动主机名服务，重启网络主机名解析服务。
sudo hostnamectl set-hostname raspi
sudo systemctl restart systemd-hostnamed.service
sudo systemctl restart nmbd.service
# 直接修改配置文件也可以
# echo "raspi" | sudo tee /etc/hostname
# 查看主机情况
hostnamectl

# 开启自动登录，图形界面：开始 - 首选项 - Raspberry Pi Configuration3
sudo cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.bak
sudo sed -i 's/.*autologin-user=.*/autologin-user=kisa747/p' /etc/lightdm/lightdm.conf

# 把Raspbian拓展到整张SD卡上，最新版的已经自动扩展至整个磁盘了。
#sudo raspi-config --expand-rootfs
#设置时区为 亚洲（Asia） 上海（Shanghai）
# 修改区域设置
# 也可以使用 sudo dpkg-reconfigure locales
sudo sed -i 's/^.*zh_CN.UTF-8 UTF-8.*$/zh_CN.UTF-8 UTF-8/' /etc/locale.gen
sudo sed -i 's/^.*en_US.UTF-8 UTF-8.*$/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo sed -i 's/^.*en_GB.UTF-8 UTF-8.*$/# en_GB.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen
# 相当于修改 /etc/default/locale
sudo localectl set-locale LANG="zh_CN.UTF-8" LANGUAGE="zh_CN:en_US:en"
sudo update-locale
sudo systemctl restart systemd-localed.service
# 查看设置情况
locale
# 修改键盘布局为美式键盘 /etc/default/keyboard
# sudo sed -i 's/XKBLAYOUT=.*/XKBLAYOUT="us"/' /etc/default/keyboard
# 使用命令方法更好
#localectl list-x11-keymap-layouts
sudo localectl set-x11-keymap "us"
# 修改WiFi密码
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf
```

### 时间设置

常用的时间服务器地址参考：<https://dns.icoa.cn/ntp/>

阿里云：<https://www.alibabacloud.com/help/zh/doc-detail/92704.htm>，设置为 `ntp.aliyun.com`，会自动选择合适的。

腾讯云：<https://cloud.tencent.com/document/product/213/30392>，地址为： `time[1-5].cloud.tencent.com` 。

```bash
# 设置时区为东八区
sudo timedatectl set-timezone "Asia/Shanghai"
timedatectl status
#启动 NTP 使计算机时钟与 Internet 时间服务器同步
sudo timedatectl set-ntp true
# 最新的raspbian系统采用 systemd 提供的 systemd-timesyncd.service 服务来同步时间
# 配置文件位于 /etc/systemd/timesyncd.conf
cat /etc/systemd/timesyncd.conf
# 常用的时间服务器地址参考：https://dns.icoa.cn/ntp/
if [ ! -f /etc/systemd/timesyncd.conf.bak ]; then sudo cp /etc/systemd/timesyncd.conf /etc/systemd/timesyncd.conf.bak; fi
sudo sed -i 's/^#\?NTP=.*$/NTP=cn.pool.ntp.org ntp.aliyun.com time.asia.apple.com time1.cloud.tencent.com/' /etc/systemd/timesyncd.conf
sudo systemctl daemon-reload
sudo systemctl restart systemd-timesyncd.service
journalctl -e -u systemd-timesyncd.service
```

## 系统配置

### 挂载 NTFS/ext4 分区

```bash
# 安装 ntfs、exfat 文件系统格式支持
# exfat-utils用来创建、检查、修改标签，exfat-fuse用来读写exfat文件系统，所以两个都建议安装。
sudo apt install ntfs-3g exfat-fuse exfat-utils

# 创建挂载目录
sudo mkdir -p /mnt/sdb2
# 挂载
sudo mount -t ntfs-3g /dev/sdb2 /mnt/sdb2

# 创建 ext4 文件系统，使用 mkfs 的 -L 选项为分区贴上标签
sudo mkfs -t ext4 -L media /dev/sdb2
sudo mount /dev/sdb2 /mnt/sdb2
# 挂载后 /mnt/sdb2 目录没有写权限，因为用户和用户组都是 root，挂载后需要设置用户和用户组
sudo chown pi:pi /mnt/sdb2

# 卸载分区前得把相关读写操作的应用关闭
sudo systemctl stop smbd
sudo umount /dev/sdb2
sudo systemctl restart smbd
```

### 挂载移动硬盘

参考：<https://wiki.archlinux.org/index.php/Persistent_block_device_naming_(简体中文)>

查看磁盘信息：

```bash
# List information about block devices.
# lsblk 命令用于列出所有可用块设备的信息，而且还能显示他们之间的依赖关系，但是它不会列出RAM盘的信息。
# 块设备有硬盘，闪存盘，cd-ROM等等
# 添加 f 参数可以查看文件系统的格式、UUID
lsblk -f
# 查看设备块的UUID
blkid

# 使用 fdisk工具可以
sudo fdisk -l
sudo parted -l /dev/sda
# 查看已挂载的情况
# chown -R pi:pi folder
# 挂载fstab中所有的文件系统
sudo mount -a
```

### 迁移/home 目录到单独分区

开启 root 账户后可以修改用户名及目录位置，不要把 `/home` 目录迁移到移动硬盘上。

```sh
home_dev="/dev/sdb2"
home_dir="/mnt/sdb2"
sudo mkdir -p /mnt/sdb2
sudo umount ${home_dev}
sudo mount ${home_dev} ${home_dir}
rsync -avP --delete /home/$USER/ $home_dir/$USER

cat << EOF | sudo tee -a /etc/fstab
${home_dev}  /home auto  defaults,noatime,nofail,x-systemd.automount,x-systemd.device-timeout=30  0  2
EOF
cat /etc/fstab
sudo reboot
# --------------------------------------------------
# 设置 root 账户密码
sudo passwd root
# 启用 root 账户
sudo passwd --unlock root
lsblk -f

# 以 root 身份登录
su
# --------------------------------------------------
# 以下内容以 root 身份执行

cd
mkdir -p /root/home
umount ${home_dev}
mount ${home_dev} /root/home
df -h

ls -a /root/home/pi
umount /root/home
rm -r /home/pi
rmdir /root/home
mount ${home_dev} /home
df -h
cat << EOF | sudo tee -a /etc/fstab
${home_dev}  /home  ext4  defaults,noatime  0  2
EOF
cat /etc/fstab
reboot
# --------------------------------------------------
# 删除 root 账号密码
sudo passwd --delete root
# 锁定 root 账号
sudo passwd --lock root
```

### 调整 swapfile 大小

参考：<http://manpages.ubuntu.com/manpages/bionic/man8/dphys-swapfile.8.html>

树莓派默认使用了 swapfile

```sh
# 查看内存、虚拟内存使用情况
free -h
cat /etc/dphys-swapfile
# 默认 CONF_SWAPSIZE=100
sudo cp /etc/dphys-swapfile /etc/dphys-swapfile.bak
# 虚拟内存文件设置为 1G
sudo sed -i 's/CONF_SWAPSIZE=.*/CONF_SWAPSIZE=1024/' /etc/dphys-swapfile
cat /etc/dphys-swapfile
# 查看服务情况
systemctl status dphys-swapfile.service
```

### 删除文件实现回收站功能

参考：<https://blog.csdn.net/u014057054/article/details/52126494>

```sh
# 创建一个文件夹用来保存删除的文件
mkdir -p /mnt/sdb2/.trash
ln -s /mnt/sdb2/.trash ~/.trash

# 修改.bash_aliases 文件
cat << "EOF" | tee -a ~/.bash_aliases
alias rm=trash
alias lt='ls ~/.trash'
alias ur=undelfile
undelfile()
{
  mv -i ~/.trash/$@ ./
}
trash()
{
  mv -f $@ ~/.trash/
}
cleartrash()
{
    read -p "Clear trash? [y/n]" confirm
    [ $confirm == 'y' ] || [ $confirm == 'Y' ]  && /bin/rm -rf ~/.trash/*
}
EOF

# 执行 source 命令生效
source ~/.bashrc
```

使用方法：

```sh
# 现在可以使用 rm（删除）,ur（撤销），rl（列出回收站），cleartrash（清空回收站）命令了。
#删除一个文件夹，helloworld 下面的文件均被移到回收站中
rm helloworld
#删除一个文件
rm abc.txt
#撤销 abc.txt
ur abc.txt
#撤销 helloworld 文件夹
ur helloworld
#列出回收站
rl
#清空回收站
cleartrash
```

### 登录信息

SSH 登录信息的显示顺序。

- `/etc/update-motd.d/*`  目录内存放了各种脚本
- `/etc/motd`  登录成功后显示的信息。
- LastLogin 的信息

```sh
# 清理登录信息
if [ ! -f /etc/motd.bak ]; then sudo mv /etc/motd /etc/motd.bak; fi
# sudo sed -i 's/^[^#].*$/## &/g' /etc/motd
cat << "EOF" | sudo tee /etc/update-motd.d/11-$USER
#!/bin/sh
echo ""
df -Th -x tmpfs -x devtmpfs
echo ""
EOF
sudo chmod 755 /etc/update-motd.d/11-$USER
# 要想不显示 LastLogin 的信息，配置文件添加 PrintLastLog no 选项。
# if [ ! -f /etc/ssh/sshd_config.bak ]; then sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak; fi
# sudo sed -i 's/^.*PrintLastLog.*$/PrintLastLog no/g' /etc/ssh/sshd_config
```

### 修改 SSH 端口

```sh
# 修改 SSH 端口
if [ ! -f /etc/ssh/sshd_config.bak ]; then sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak; fi
# 测试
# sed -n 's|^#\?Port\s[0-9]\{2,5\}$|Port 9002|p' /etc/ssh/sshd_config
sudo sed -i 's|^#\?Port\s[0-9]\{2,5\}$|Port 20002|g' /etc/ssh/sshd_config
# 重启 ssh 服务，Debian、Ubuntu 只有服务名称为 ssh，CentOS 服务为 sshd。
sudo systemctl restart ssh
# 查看端口使用情况
netstat -ntulp
```

## 安装软件

一些常用的软件

### 安装 DLNA 支持

其实就是需要安装 DLNA Server, minidlna（最新版的改名为了 ReadyMedia）是一个简单的 DLNA Server。

DNLA 的优点是免密码、方便、视频播放流畅（速度比 SMB 协议快），缺点是无法支持外挂字幕（仅支持内嵌字幕）。

```sh
# 安装 minidlna 会附带安装 100 多个包，主要是一些协议支持需要的视频、音频解码器。
sudo apt-get install minidlna
```

参考：<https://openwrt.org/docs/guide-user/services/media_server/minidlna>

<https://wiki.archlinux.org/index.php/ReadyMedia>

接着，编辑 `/etc/minidlna.conf` 来设定分享目录：

```sh
if [ ! -f /etc/minidlna.conf.bak ]; then sudo cp /etc/minidlna.conf /etc/minidlna.conf.bak; fi
cat << "EOF" | sudo tee /etc/minidlna.conf
# 第一行会把 /srv/media 底下所有的媒体文件 (照片，影片，音乐) 分享出去。
# media_dir=media_dir=/var/lib/minidlna
# 如果想要限制媒体的种类，可以在目录前加上 V(影片), A(声音) 或 P(照片) 来指定种类：
media_dir=V,/mnt/sdb1/orico/Video

# Use a different container as the root of the directory tree presented to
# clients. The possible values are:
#   * "." - standard container
#   * "B" - "Browse Directory"
#   * "M" - "Music"
#   * "P" - "Pictures"
#   * "V" - "Video"
#   * Or, you can specify the ObjectID of your desired root container
#     (eg. 1$F for Music/Playlists)
# If you specify "B" and the client device is audio-only then "Music/Folders" will be used as root.
# 设置为 V，即显示所有的视频，隐藏了所有的音乐、图片。
root_container=V

# Path to the directory that should hold the database and album art cache.
db_dir=/var/cache/minidlna

# Port number for HTTP traffic (descriptions, SOAP, media transfer).
port=8200

# Name that the DLNA server presents to clients.
# Defaults to "hostname: username"，即“RASPI:minidlna”
friendly_name=RASPI

# List of file names to look for when searching for album art.
# Names should be delimited with a forward slash ("/").
# This option can be specified more than once.
album_art_names=Cover.jpg/cover.jpg/AlbumArtSmall.jpg/albumartsmall.jpg
album_art_names=AlbumArt.jpg/albumart.jpg/Album.jpg/album.jpg
album_art_names=Folder.jpg/folder.jpg/Thumb.jpg/thumb.jpg
EOF
# 重启服务
sudo systemctl restart minidlna.service
#------------------------------------------------------

# 停止服务、禁用服务。
sudo systemctl stop minidlna.service
sudo systemctl disable minidlna.service

```

这么一来，支持 DLNA 的播放程序如 Media Player 就可以直接浏览 server 上的媒体，并且串流播放。

手机、平板上可以使用 `VLC` 等 APP 播放分享出来的媒体。

### 配置 python3

#### 安装测试版 Python3

推荐使用 `pyenv`

默认的 python3.5 版本过低，得升级一下

```sh
# 添加 testing 源
echo "deb http://mirrors.ustc.edu.cn/raspbian/raspbian/ testing main contrib non-free rpi" | sudo tee -a /etc/apt/sources.list
# 指定软件库更新的优先级。默认不更新 testing 软件库
cat <<EOF | sudo tee /etc/apt/preferences.d/my_preferences
Package: *
Pin: release a=testing
Pin-Priority: 450
EOF
# 更新软件库信息
sudo apt update
# 检查优先级设置是否正确
apt-cache policy python3
#  从测试版软件库中安装，并从稳定版软件库中安装其依赖包（稳定版通过 apt 规则确定）。python3 不推荐
# apt install python3/testing
# python 的依赖较多，所以使用第二种方法。从测试版软件库中安装，并从测试版软件库中安装其依赖包
sudo apt -t testing install python3
sudo apt autoremove

# 查看 python3 版本
python3 -V
# 查看 pip3 的版本
pip3 -V
pip3 install --user -U pip
. ~/.profile
# 使用国内源，可选：
# https://mirrors.aliyun.com/pypi/simple
# https://mirrors.ustc.edu.cn/pypi/web/simple
# https://pypi.tuna.tsinghua.edu.cn/simple
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
# 默认 install 加上 --user 参数，以后使用 pip install 就不用每次加 --user 参数了。
# Debian、LinuxMint 系统已经默认安装到用户目录，所以这个参数不需要添加了。
#pip config set install.user true
# 配置为：默认升级。
pip config set install.upgrade true
# 配置：超时时间为 120 秒。
pip config set global.timeout 120
# 安装库
pip install setuptools wheel
# pip install requests beautifulsoup4
```

#### 安装 pandas

树莓派上默认启用了`extra-index-url=https://www.piwheels.org/simple` ，因此速度超慢。

Pandas、Numpy 有 `aarch64` 的 whl 包，但是树莓派是 32 位的 armhf 系统，因此使用 pip 安装如果从官方源安装，就是源码安装，速度超慢，有更简单的方法。不过 apt 源里面的版本一般会比较老，而且 pandas 更新速度实在太快了，很多函数、参数变化都很大。所以还是期待树莓派尽快出品 64 位的系统。

```sh
# Debian 10 上的 pandas 包很老，版本是 0.23.3+dfsg-3
apt show python3-pandas
sudo apt install python3-pandas
```

默认的 timeout 是 15 秒，需要设定大一些，防止网络超时。

估计是 buster 系统刚出来，piwheels 上的 numpy 包安装会失败，需要临时禁用 extra-index。

```ini
# /etc/pip.conf 默认的内容
[global]
extra-index-url=https://www.piwheels.org/simple
```

numpy 和 pandas 源码安装，尤其是 pandas，速度超慢要 2 个多小时。怪不得树莓派要有个 extra-index，就像 piwheels 官方说的，fast！

```sh
# if [ ! -f /etc/pip.conf.bak ]; then sudo cp /etc/pip.conf /etc/pip.conf.bak; fi
# sudo sed -i 's/^[^#].*$/## &/' /etc/pip.conf # 临时禁用 piwheels.org
# cat /etc/pip.conf

临时禁用 piwheels.org
pip config set global.extra-index-url ''
pip config list  # 查看 pip 设置

pip --no-cache-dir --timeout 1000  install numpy
# pandas 竟然依赖 Cython
pip install Cython
pip --no-cache-dir --timeout 1000 install pandas
# 重新启用 piwheels.org
sudo sed -i 's/^##\s//' /etc/pip.conf
cat /etc/pip.conf
```

#### 编译安装 Python3

编译安装 python3.7.2，太慢了，而且升级也不方便，不推荐。

参考：<https://www.scivision.co/compile-install-python-beta-raspberry-pi>

<https://www.ramoonus.nl/2018/06/30/installing-python-3-7-on-raspberry-pi/>

下载好：Python-3.7.2.tar.xz

```sh
# get prereqs on your ARM device
sudo apt install libffi-dev libbz2-dev liblzma-dev libsqlite3-dev libncurses5-dev libgdbm-dev zlib1g-dev libreadline-dev libssl-dev tk-dev build-essential libncursesw5-dev libc6-dev openssl git
cd ~
wget https://www.python.org/ftp/python/3.7.2/Python-3.7.2.tar.xz
tar xvJf Python-3.7.2.tar.xz
cd Python-3.7.2
# Configure (3 minutes on Raspberry Pi 2):
./configure --prefix=$HOME/.local --enable-optimizations
# Build and install–this step takes 10-40 minutes, depending on Raspberry Pi model. Do not use sudo!
# 这一步太慢了，得 4 个小时
make -j -l 4
make install
# add to ~/.bashrc:
export PATH=$HOME/.local/bin/:$PATH
sudo apt autoremove
sudo apt clean
```

### 安装 samba

```sh
sudo apt install samba
# 在安装过程中，会有以下提示：
# Modify smb.conf to use WINS settings from DHCP? 选择 NO，不使用 WINS 设置。
# 查看服务运行情况
systemctl status smbd.service

if [ ! -f /etc/samba/smb.conf.bak ]; then sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak; fi
# 去掉 samba 配置所有注释行
grep -v -E "^#|^;|^$" /etc/samba/smb.conf | sudo tee /etc/samba/smb.conf
cat /etc/samba/smb.conf
sudo nano /etc/samba/smb.conf
```

参考：<https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html>

添加以下内容：

```ini
[orico]
   comment = Orico移动硬盘
   path = /mnt/sdb1
   guest ok = no
   browseable = yes
   writeable = yes
   create mask = 0644
   directory mask = 0755
```

保存后退出

```sh
# 添加用户 pi，并修改密码
sudo smbpasswd -a pi
# 可以禁用 nmbd 服务，关闭局域网发现功能。
sudo systemctl stop nmbd
sudo systemctl disable nmbd
# 重启 samba 服务
sudo systemctl status smbd
sudo systemctl restart smbd
```

#### samba 添加回收站功能

参考：<https://blog.csdn.net/qiminghang/article/details/53787679>

<https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html>

如果在客户端有误删文件的情况，那么成功恢复文件的机率将非常小。原来 samba 共享是可以添加回收站功能的，删除的文件给直接放到设置好的回收站目录里。

```bash
sudo nano /etc/samba/smb.conf
```

在 共享目录下添加代码：

```ini
[orico]
   comment = Orico移动硬盘
   path = /mnt/sdb1/orico
   browseable = yes
   writeable = yes
   create mask = 0644
   directory mask = 0755
   # 载入 Samba 用于回收站功能的模块 recycle.so
   vfs object = recycle
       # 回收站的相对路径，删除的文件会被放入你共享的文件夹下的.trash_samba 文件夹中
       # .trash_samba/%U是按登录的用户名分开存放
       recycle:repository = .trash_samba
       # 指定是否按删除时的目录结构存放
       recycle:keeptree = Yes
       # 指定是否区覆盖同名的文件，yes 是不覆盖
       recycle:versions = Yes
       # 指定回收站目录的大小，0 是不限制
       recycle:maxsixe = 0
       # 不放入回收站的文件类型
       recycle:exclude = *.tmp|*.mp3
       # 指定覆盖同名文件的文件类型
       recycle:noversions = *.tmp
```

重启 samba 服务，查看效果。

```sh
sudo systemctl restart smbd
```

#### 定期清理回收站内文件

```sh
# 每天 8:30 删除回收站内大于 30 天的文件
#-atime -n: 最后一次访问发生在 n 天 之内 Accesss 最近访问
#-mtime -n: 最后一次文件内容修改发生在 n 天 之内 Modify 最近更改
#-ctime -n: 最后一次文件状态修改发生在 n 天 之内 Change 最近改动

30 8 * * * find /mnt/sdb1/orico/.trash_samba -ctime +30 -exec rm -rf "{}" \;
30 8 * * * find /mnt/sdb1/bak/.trash_samba -ctime +30 -exec rm -rf "{}" \;
```

### 开启 NFS 共享

参考：<https://blog.yeefire.com/2020_02/Raspberry_NFS.html>

<https://odinxu.com/post/windows-access-centos-nfs/>

安装必要的软件：

```sh
# 安装 nfs 服务端，会自动安装 nfs-common、rpcbind
sudo apt-get install nfs-kernel-server

if [ ! -f /etc/exports.bak ]; then sudo cp /etc/exports /etc/exports.bak; fi
cat << EOF | sudo tee /etc/exports
# 注意 exports 配置文件有非常严格的格式要求，目录名后必须要有空格（几个空格没关系）。
# 但是 * 号，或者 ip 地址后面，不允许出现空格，必须紧接着出现小括号 ()，小括号里是权限参数。
/home/kevin/public *(rw,sync,root_squash)
EOF

#systemctl status nfs-server
#systemctl status rpcbind
# 启动服务
sudo systemctl restart rpcbind
sudo systemctl restart nfs-server
# 设置开机自启动 nfs-server 服务
sudo systemctl enable nfs-server
```

用于配置 NFS 服务程序配置文件的参数：

| 参数           | 作用                                                         |
| -------------- | ------------------------------------------------------------ |
| ro             | 只读                                                         |
| rw             | 读写                                                         |
| root_squash    | 当 NFS 客户端以 root 管理员访问时，映射为 NFS 服务器的匿名用户     |
| no_root_squash | 当 NFS 客户端以 root 管理员访问时，映射为 NFS 服务器的 root 管理员   |
| all_squash     | 无论 NFS 客户端使用什么账户访问，均映射为 NFS 服务器的匿名用户。**推荐使用**。 |
| sync           | 同时将数据写入到内存与硬盘中，保证不丢失数据                 |
| async          | 优先将数据保存到内存，然后再写入硬盘；这样效率更高，但可能会丢失数据 |
| anonuid=1000   | 匿名用户的 UID 值，可以在此处自行设定                          |
| anongid=1000   | 匿名用户的 GID 值。                                            |

#### Windows 下启用 NFS

参考：<https://it.umn.edu/services-technologies/how-tos/network-file-system-nfs-mount-nfs-share>

<https://odinxu.com/post/windows-access-centos-nfs/>

<https://help.aliyun.com/document_detail/67165.html>

<https://www.rootusers.com/how-to-mount-an-nfs-share-in-windows-server-2016/>

<https://docs.datafabric.hpe.com/61/AdministratorGuide/MountingNFSonWindowsClient.html>

<https://docs.microsoft.com/en-us/powershell/module/dism/get-windowsoptionalfeature?view=win10-ps>

<https://docs.microsoft.com/en-us/powershell/module/dism/enable-windowsoptionalfeature?view=win10-ps>

管理员权限运行 PowerShell：

```powershell
dism /online /get-features
dism /online  /format:table /Get-Features

# Lists optional features in the running operating system
Get-WindowsOptionalFeature -Online
# Gets details about features using a wildcard
Get-WindowsOptionalFeature -Online -FeatureName *NFS*
# 启用 NFS Client
Enable-WindowsOptionalFeature -Online -FeatureName ServicesForNFS-ClientOnly, ClientForNFS-Infrastructure -NoRestart
# 启用 NFS 管理工具
Enable-WindowsOptionalFeature -Online -FeatureName NFS-Administration -NoRestart

# 禁用 NFS Client
Disable-WindowsOptionalFeature -Online -FeatureName ServicesForNFS-ClientOnly, ClientForNFS-Infrastructure -NoRestart
# 禁用 NFS 管理工具
Disable-WindowsOptionalFeature -Online -FeatureName NFS-Administration -NoRestart
```

安装成功后，就可以使用 showmount 和 mount 命令。

```sh
# 查看 远程地址的 NFS 目录情况。
showmount -e 192.168.29.128
/home/kevin/public                 *

# 将 NFS 目录挂载到 X：盘。
mount \\192.168.29.128\home\kevin\public x:

# 取消挂载
umount x:

# 查看挂载情况
mount
```

Windows 挂载 NFS 目录后，没有写权限。

参考：<http://blog.phpdr.net/win7-nfs-uid.html>

<https://blog.csdn.net/youcijibi/article/details/105276580>

<https://blog.51cto.com/14375810/2427482>

```ini
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ClientForNFS\CurrentVersion\Default]
; Uid 和Gid都设置为1000
"AnonymousUid"=dword:000003e8
"AnonymousGid"=dword:000003e8

; Uid 和Gid都设置为0
;"AnonymousUid"=dword:00000000
;"AnonymousGid"=dword:00000000
```

### 安装 syncthing

参考：<https://apt.syncthing.net/>

```sh
# Add the release PGP keys:
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
# Add the "stable" channel to your APT sources:
echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list

# Update and install syncthing:
sudo apt update
sudo apt install syncthing -y

# 测试，并让它自动生成配置文件，便于下一步修改。
syncthing -gui-address="0.0.0.0:8384" -no-browser
# 没问题后 ctrl + C 结束掉
# 修改配置文件
sed -i 's/127\.0\.0\.1/0\.0\.0\.0/' ~/.config/syncthing/config.xml
cat ~/.config/syncthing/config.xml
```

通过命令行输出得知：

|          设备           | Hash 性能（Hashing performance） |
| :---------------------: | :-----------------------------: |
|        树莓派 3B+        |            16.81M/S             |
|        群晖 120J        |             46.8M/s             |
|  笔记本 Intel I5-4210U   |            144.81M/S            |
| 笔记本 AMD Ryzen 5 4600U |          1125.57 MB/s           |
| 路由器 MediaTek MT7620A  |                                 |

也就说 100G 得文件需要 2.7 小时！！！

#### 创建用户服务（推荐）

参考：<https://docs.syncthing.net/users/autostart.html#using-systemd>

<https://wiki.archlinux.org/index.php/Systemd/User_(简体中文)>

推荐创建用户服务。

```sh
mkdir -p ~/.config/systemd/user
cat << "EOF" | tee ~/.config/systemd/user/syncthing.service
[Unit]
Description=Syncthing - Open Source Continuous File Synchronization
Documentation=man:syncthing(1)
StartLimitIntervalSec=60
StartLimitBurst=4
# 自定义配置，在本地文件和网络就绪后才启动
Wants=network.target local-fs.target
After=network.target local-fs.target

[Service]
# 自定义配置，运行等级低一点
Nice=10
ExecStart=/usr/bin/syncthing -no-browser -no-restart -logflags=0
Restart=on-failure
RestartSec=1
SuccessExitStatus=3 4
RestartForceExitStatus=3 4

# Hardening
SystemCallArchitectures=native
MemoryDenyWriteExecute=true
NoNewPrivileges=true

# Elevated permissions to sync ownership (disabled by default),
# see https://docs.syncthing.net/advanced/folder-sync-ownership
#AmbientCapabilities=CAP_CHOWN CAP_FOWNER

[Install]
WantedBy=default.target
EOF
```

保存后退出

```sh
systemctl --user disable syncthing.service
systemctl --user enable syncthing.service
systemctl --user restart syncthing.service
systemctl --user status syncthing.service
systemctl --user stop syncthing.service
# 如果要删除服务，需要先禁用
systemctl --user disable syncthing.service

systemctl --user daemon-reload

# 随系统自动启动 systemd 用户实例
# 默认用户服务是用户登录后才能启用，要么开启自动登录，要么设置无需登录就能启动服务
# Systemd 支持通过 --user 参数管理用户级别的后台程序，不过这存在一个问题，如果用户退出登录后，属于该用户的后台服务会被终止。
# 如果希望用户退出后仍然保持服务的运行，可以使用下面的命令启用用户的逗留状态
sudo loginctl enable-linger $USER
# 查看用户日志
journalctl -e --user-unit=syncthing.service
# 编辑环境变量
systemctl --user edit syncthing.service
```

注意：

默认 sync 会根据文件的后缀名自动赋予写权限。如果要让所有文件都是 644，目录 755。

#### 创建系统服务（不推荐）

```sh
sudo nano /etc/systemd/system/syncthing@${USER}.service
```

内容如下：

```ini
[Unit]
Description=Syncthing - Open Source Continuous File Synchronization for %I
Documentation=man:syncthing(1)
After=network.target
StartLimitIntervalSec=60
StartLimitBurst=4

[Service]
User=%i
ExecStart=/usr/bin/syncthing serve --no-browser --no-restart --logflags=0
Restart=on-failure
RestartSec=1
SuccessExitStatus=3 4
RestartForceExitStatus=3 4

# Hardening
ProtectSystem=full
PrivateTmp=true
SystemCallArchitectures=native
MemoryDenyWriteExecute=true
NoNewPrivileges=true

# Elevated permissions to sync ownership (disabled by default),
# see https://docs.syncthing.net/advanced/folder-sync-ownership
#AmbientCapabilities=CAP_CHOWN CAP_FOWNER

[Install]
WantedBy=multi-user.target
```

测试：

```sh
sudo systemctl enable syncthing@${USER}.service
sudo systemctl start syncthing@${USER}.service
sudo systemctl status syncthing@${USER}.service
sudo systemctl restart syncthing@${USER}.service
sudo systemctl disable syncthing@${USER}.service
sudo systemctl stop syncthing@${USER}.service
sudo systemctl daemon-reload
systemctl list-units --type=service
systemctl list-unit-files --type=service
# 查看系统日志
journalctl -e -u syncthing@${USER}.service
systemctl edit syncthing@${USER}.service
# 再次测试
ps -ef | grep -i syncthing
```

#### 配置

地址列表：

```sh
dynamic, quic://192.168.88.9:22000
```

### 安装 aria2

```sh
sudo apt install aria2 -y
mkdir -p ~/.config/aria2
touch ~/.config/aria2/aria2.session
cat > ~/.config/aria2/aria2.conf <<EOF
# Auto generated file, changes to this file will lost.
dir=/home/pi/download
input-file=/home/pi/.config/aria2/aria2.session
save-session=/home/pi/.config/aria2/aria2.session
enable-dht=true
dht-file-path=/home/pi/.config/aria2/dht.dat
save-session-interval=60
enable-rpc=true
rpc-allow-origin-all=true
rpc-listen-all=true
quiet=true
continue=true
check-certificate=true
bt-enable-lpd=true
file-allocation=none
follow-torrent=true
max-concurrent-downloads=20
peer-id-prefix=-TR2770-
rpc-listen-port=6800
save-session-interval=30
user-agent=Transmission/2.77
enable-peer-exchange=true
bt-tracker=udp://tracker.coppersurfer.tk:6969/announce,udp://tracker.open-internet.nl:6969/announce,udp://tracker.leechers-paradise.org:6969/announce,udp://tracker.opentrackr.org:1337/announce,udp://tracker.internetwarriors.net:1337/announce,udp://9.rarbg.to:2710/announce,udp://9.rarbg.me:2710/announce,udp://exodus.desync.com:6969/announce,udp://tracker.torrent.eu.org:451/announce,udp://tracker.tiny-vps.com:6969/announce,udp://thetracker.org:80/announce,udp://retracker.lanta-net.ru:2710/announce,udp://open.demonii.si:1337/announce,udp://tracker.cyberia.is:6969/announce,udp://denis.stalker.upeer.me:6969/announce,udp://bt.xxx-tracker.com:2710/announce,udp://open.stealth.si:80/announce,udp://explodie.org:6969/announce,http://open.acgnxtracker.com:80/announce,udp://ipv4.tracker.harry.lu:80/announce,http://tr.cili001.com:8070/announce
EOF
```

测试一下：

```sh
ls ~/.config/aria2
aria2c --conf-path=${HOME}/.config/aria2/aria2.conf
```

打开 <http://yaaw.ghostry.cn> ，OK 的话，开始创建开机自启动脚本。

最好的方法是 使用 systemd 创建一个服务。

参考：<https://linux.cn/article-10182-1.html>

<https://wiki.archlinux.org/index.php/Systemd/Timers_(简体中文)>

#### 创建用户服务

```sh
# %h 标识用户目录，即“/home/pi”
mkdir -p ~/.config/systemd/user
cat << EOF | tee ~/.config/systemd/user/aria2.service
[Unit]
Description=A lightweight multi-protocol & multi-source command-line download utility
Documentation=man:aria2c(1)
Wants=network.target local-fs.target
After=network.target local-fs.target

[Service]
Type=idle
ExecStart=/usr/bin/aria2c --conf-path=%h/.config/aria2/aria2.conf
Restart=on-failure
SuccessExitStatus=3 4
RestartForceExitStatus=3 4

[Install]
WantedBy=default.target
EOF

systemctl --user enable aria2.service
systemctl --user start aria2.service
```

保存后退出：

```sh
systemctl --user enable aria2.service
systemctl --user restart aria2.service
systemctl --user status aria2.service
# 随系统自动启动 systemd 用户实例
# 默认用户服务是用户登录后才能启用，要么开启自动登录
# 要么设置无需登录就能启动服务
sudo loginctl enable-linger $USER
#------------------------------------
# 如果要删除服务，需要先禁用
systemctl --user disable aria2.service
systemctl --user daemon-reload
# 查看用户日志
journalctl -e --user-unit=aria2.service
# 编辑环境变量
systemctl --user edit aria2.service
ps -ef | grep -i aria2c
```

还有一种古老的方法，就是是创建 cron 定时脚本：

```sh
# 查看命令的位置
which aria2c
# 开始编辑用户的 cron
crontab -e

# 添加以下内容：
@reboot /usr/bin/aria2c --conf-path=/home/pi/.config/aria2/aria2.conf -D >/home/pi/.config/aria2/aria2.log 2>&1 &
# 重启测试一下
sudo reboot
# 查看进程
systemctl status cron.service
ps -ef | grep -i aria2c
```

不推荐使用 rc.local 方法。原因：/etc/rc.local 是在系统初始化的末尾执行的一个脚本。如果把太多的任务加入到这个脚本中，不但会拖慢开机的速度，还会造成管理上的混乱。因此，/etc/rc.local 往往只用于修改一些在启动过程需要设定的参数，而不涉及具体的任务启动。如果想随开机启动某些服务，应该避免使用/etc/rc.local。

```sh
sudo cp /etc/rc.local /etc/rc.local.bak
sudo sed -i '10,$s/exit 0/aria2c --conf-path=\/home\/pi\/.config\/aria2\/aria2.conf -D &\nexit 0/' /etc/rc.local
cat /etc/rc.local
# rc.local 需要有可执行权限
ls -l /etc/rc.local
reboot
# 查看进程
ps -e | grep -i aria2c
ps -ef | grep -i aria2c
sudo pkill aria2c
sudo kill <PID>
```

#### 自动更新 BT Tracker 脚本

参考：<https://www.hscbook.com/article/raspberrypi-aria2/>

```sh
# 创建脚本
cat << "EOF" > ~/shell/tracker.sh
#!/usr/bin/env bash
# 自动更新 aria2 的 bt tracker 的脚本。

#https://github.com/ngosang/trackerslist
#trackers_best (20 trackers) => https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt
#trackers_all (65 trackers) => https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt
#trackers_all_udp (30 trackers) => https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all_udp.txt
#trackers_all_http (28 trackers) => https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all_http.txt
#trackers_all_https (3 trackers) => https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all_https.txt
#trackers_all_ws (4 trackers) => https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all_ws.txt

url=https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt
aria2_conf=$HOME/.config/aria2/aria2.conf

list=`wget -qO- $url|awk NF|sed ":a;N;s/\n/,/g;ta"`
if [ -z "`grep "bt-tracker" /data/ser/dat/aria2/aria2.conf`" ]; then
    echo "Add Trackers..."
    sed -i '$a bt-tracker='${list} $aria2_conf
else
    echo "Update Trackers..."
    sed -i "s@bt-tracker=.*@bt-tracker=$list@g" $aria2_conf
fi
echo "Restart Aria2c..."
systemctl --user restart aria2
EOF
```

### 安装远程桌面支持

```sh
# 安装 windows 远程桌面支持
sudo apt install xrdp
systemctl status xrdp.service
sudo systemctl restart xrdp.service
```

windows 系统下运行 `mstsc` ，输入 IP 地址：192.168.31.34

程序在 开始 - 附件 - 远程桌面连接

### 安装远程控制 teamviewer

teamviewer 官方网站下载 deb 包 <https://www.teamviewer.com/en/download/linux/>

参考：[十步配置 TeamViewer 远程控制 Pi – 支持内网穿透](http://www.52pi.net/archives/549)

或是使用命令行：

```sh
#wget https://download.teamviewer.com/download/linux/teamviewer-host_armhf.deb
# 现在用的是虚拟机
wget https://download.teamviewer.com/download/linux/teamviewer-host_amd64.deb
sudo dpkg -i teamviewer-host_*.deb
# 会提示错误，然后运行
sudo apt --fix-broken install
reboot
```

启动测试

```sh
#查看帮助信息
teamviewer help

#查看本机 ID：1149264093
teamviewer info

#设置本机密码
sudo teamviewer passwd 1234567890

# 查看服务
systemctl status teamviewerd.service
```

一切 OK 的话，windows 上可以测试了

### 安装 usbmount

~~实现自动挂载 U 盘功能~~。经测试该软件无效。

```sh
sudo apt install usbmount
sudo nano /etc/usbmount/usbmount.conf
```

### 安装 Resilio

```sh
echo "deb http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free" | sudo tee /etc/apt/sources.list.d/resilio-sync.list
wget -qO - https://linux-packages.resilio.com/resilio-sync/key.asc | sudo apt-key add -
apt-key list
sudo apt-get update && sudo apt-get install resilio-sync
```

### 安装 web 管理软件 cockpit

```sh
sudo apt install cockpit
```

## 安装其它系统

### 安装官方测试版 64 位系统

下载地址：<https://downloads.raspberrypi.org/raspios_lite_arm64/images/>

官方论坛给出的地址：<https://www.raspberrypi.org/forums/viewtopic.php?f=117&t=275370>

参考：<http://blog.dngz.net/RaspberryPiKodbox.htm>

### 安装 Debian

由于树莓派没有 BIOS 系统，需要使用 [64-bit Tiano Core UEFI](https://github.com/andreiw/RaspberryPiPkg)，下载最新的 [pre-built UEFI images](https://github.com/andreiw/RaspberryPiPkg/tree/master/Binary/prebuilt)，模拟出一个 UEFI，然后引导安装 Debian 光盘。

> 注意：UEFI boot media must be MBR partitioned and FAT32 formatted.

安装过程中提示需要插入包含固件的磁盘，地址：<https://github.com/RPi-Distro/firmware-nonfree/tree/master/brcm>，下载三个文件：`brcmfmac43455-sdio.bin`、`brcmfmac43455-sdio.clm_blob`、`brcmfmac43455-sdio.txt`。

安装失败了，原因未知。

### 升级系统至 Buster

参考：<https://www.debian.org/releases/testing/amd64/release-notes/>

<https://www.debian.cn/archives/3136>

Debian 10 (buster) 的变化

>- 支持 UEFI 安全启动
>- Bash 5.0
>- `unattended-upgrades` 除了安装安全更新，在 buster 中它也会自动安装最新的 stable 版的小版本号升级
>- Cryptsetup 默认在磁盘上使用 LUKS2 格式。现有的 LUKS1 卷不会自动升级。它们可以被转换，但因为头的大小不兼容，不是所有的 LUKS2 特性都可用。
>- GNOME defaults to Wayland

1、更新系统至最新

```sh
sudo apt update && sudo apt upgrade
sudo apt full-upgrade
```

2、禁用 APT pinning，禁用 testing 源

由于 Buster 暂时还没有进入 stable。

```sh
sudo rm /etc/apt/preferences.d/my_preferences
sudo sed -i 's/.*testing.*/# &/g' /etc/apt/sources.list
```

3、准备 APT source-list 文件

```sh
sudo sed -i 's/stretch/buster/g' /etc/apt/sources.list
cat /etc/apt/sources.list
```

4、开始升级

```sh
sudo apt update && sudo apt upgrade
sudo apt full-upgrade
# 重启后执行
sudo apt autoremove
```

### 安装 openwrt

参考：<https://openwrt.org/toh/raspberry_pi_foundation/raspberry_pi>

### 安装 ubuntu

官方下载地址：<https://ubuntu.com/download/raspberry-pi>

科大下载地址：<https://mirrors.ustc.edu.cn/ubuntu-cdimage/releases/focal/release/>

官方 WIKI：<https://wiki.ubuntu.com/ARM/RaspberryPi>

官方安装教程：<https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi>

烧录，fat32 分区下新建 `ssh` 文件，开启 ssh

现在最新的 bootloader：<http://archive.raspberrypi.org/debian/pool/main/r/raspberrypi-firmware/>

<https://mirrors.ustc.edu.cn/archive.raspberrypi.org/debian/pool/main/r/raspberrypi-firmware/>

比如：<http://archive.raspberrypi.org/debian/pool/main/r/raspberrypi-firmware/raspberrypi-bootloader_1.20190517-1_armhf.deb>

复制 boot 文件夹内的所有文件至 system-boot 分区

修改 config.txt，修改 kenel，添加 initramf，注释掉 device_tree_address

启用 64 位模式，添加：`arm_control=0x200`

```ini
kernel=vmlinuz
initramfs initrd.img followkernel
#device_tree_address=0x02000000
arm_control=0x200
```

编辑 cmdline.txt，修改   root=/dev/mmcblk0p2 为：root=LABEL=writable .

If you are using a lot of drives then you may wish to switch to using the UUID of the partition.

```ini
root=LABEL=writable
```

插上 U 盘，ssh 登录。You will be asked to change the password on first login.

```ini
账号 ubuntu
密码 ubuntu
```

#### 修改默认账户用户名、主目录

```bash
# 设置root账户密码
sudo passwd root
# 启用root账户
sudo passwd --unlock root
# 开启root的ssh登录
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config
sudo systemctl reload sshd
# 重载所有修改过的配置文件
sudo systemctl daemon-reload
sudo systemctl restart sshd
# 重新用 root账户ssh登录
# ------------------------------------------
# 下面的命令是在root账户下进行
usermod -l pi -d /home/pi -m ubuntu
groupmod -n pi ubuntu
# ------------------------------------------
# 检查没有问题后，退出登录，使用 pi 账号登录。
# 锁定root，关闭root的ssh登录权限。
# 删除root账号密码
sudo passwd --delete root
# 锁定root账号
sudo passwd --lock root
sudo sed -i 's|^PermitRootLogin.*$||g' /etc/ssh/sshd_config
sudo systemctl restart sshd

# 创建新用户，-m 自动创建用户目录， -s指定shell。
# sudo useradd -m -s /bin/bash pi
# 修改密码
# sudo passwd pi
# 添加 sudo 权限。
# echo "pi ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/010-pi
# 切换至 pi 用户
# su - pi
# sudo visudo
# users
# sudo userdel pi
# cat /etc/passwd
```

#### 修改软件源

 参考：<https://mirrors.ustc.edu.cn/help/ubuntu-ports.html>

也可以使用 tuna 的源，<https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports>

```bash
# 使用 HTTPS 可以有效避免国内运营商的缓存劫持
sudo apt install apt-transport-https -y

if [ ! -f /etc/apt/sources.list.bak ]; then sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak; fi
sudo sed -i 's|http://ports.ubuntu.com|https://mirrors.ustc.edu.cn|g' /etc/apt/sources.list
cat /etc/apt/sources.list
sudo apt update && sudo apt upgrade

sudo apt install python3-pip

# 设置命令别名
cat << "EOF" | tee ~/.bash_aliases
# 自定义命令部分
alias uu='sudo apt update && sudo apt upgrade'
alias temp="awk -v x=$(cat /sys/class/thermal/thermal_zone0/temp) 'BEGIN{printf \"%-4.2f C\n\",x/1000}'"
EOF
source ~/.bashrc

sudo apt-get autoremove
sudo apt-get clean

# 清理登录信息
sudo sed -i 's/^[^#]/## &/g' /etc/update-motd.d/51-cloudguest

# 启用硬盘休眠
```

#### 添加更新源

操作方法与 debian 类似，参考：<https://help.ubuntu.com/community/PinningHowto>

<https://www.debian.org/doc/manuals/debian-reference/ch02.zh-cn.html#_tracking_literal_testing_literal_with_some_packages_from_literal_unstable_literal>

<https://wiki.debian.org/AptPreferences>

<https://manpages.debian.org/stretch/apt/apt_preferences.5.en.html>

推荐使用方法 1，

```bash
https://mirrors.aliyun.com/ubuntu-ports/
# ubuntu 18.04 代号是 bionic，添加19.10代号 disco 作为更新源

# 方法1，默认不使用新源，除非指定 -t 参数。
# 添加disco源
echo "deb https://mirrors.ustc.edu.cn/ubuntu-ports disco main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
# 指定软件库更新的优先级。默认不更新testing软件库
cat << EOF | sudo tee /etc/apt/preferences.d/my_preferences
Package: *
Pin: release n=disco
Pin-Priority: 450
EOF
# 更新软件库信息
sudo apt update
# 检查优先级设置是否正确
apt-cache policy aria2
# 从新源中寻找依赖。
sudo apt -t disco install aria2

#方法2，直接指定软件从新源更新，不需要指定 -t 参数。
# 指定系统默认发行版本，防止意外升级所有的软件包。
cat << "EOF" | sudo tee /etc/apt/apt.conf
APT::Default-Release "bionic";
EOF
# 添加disco源
echo "deb https://mirrors.ustc.edu.cn/ubuntu-ports disco main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
# 调整候选版本
cat << "EOF" | sudo tee /etc/apt/preferences
Package: aria2
Pin: release n=disco
Pin-Priority: 900
EOF
# 检查优先级设置是否正确
apt-cache policy aria2
# 从新源中寻找依赖。
sudo apt-get update
sudo apt-get build-dep aria2
```

#### 笔记

ubuntu 默认没有安装 dphys-swapfile

### 安装 Fedora

参考官方文档：<https://fedoraproject.org/wiki/Architectures/ARM/Raspberry_Pi/zh-cn>

下载 Fedora 30 最小化安装镜像：

<https://mirrors.aliyun.com/fedora-altarch/releases/30/Spins/aarch64/images/>

<https://mirrors.ustc.edu.cn/fedora-altarch/releases/30/Spins/aarch64/images/>

下载 Fedora 30 的 server 版：

<https://mirrors.ustc.edu.cn/fedora/releases/30/Server/aarch64/images/>

### 构建 ARM64 版的系统

为树莓派 3B/3B+ 构建基于 Debian ARM64 的操作系统，参考：<https://github.com/UMRnInside/RPi-arm64>

```bash
git clone git@github.com:UMRnInside/RPi-arm64.git && cd RPi-arm64
sudo ./install_deps.sh
cp rpi3_defconfig config
nano config
#---下面为修改config内容
FSTYPE=ext4

#MIRROR="http://mirrors.163.com/debian/"
#MIRROR="http://mirrors.ustc.edu.cn/debian/"
MIRROR="http://httpredir.debian.org/debian/"

RESIZEFS_FIRSTBOOT=1
ROOT_PART="/dev/sda2"
BOOT_PART="/dev/sda1"
#------------------
./build.sh
# 然后就是漫长等待
# 成功后在 dist 目录下找到镜像
```

### 安装 debian arm64 系统

Debian 的 arm64 系统只提供了 iso 镜像下载，通过查阅资料，树莓派的启动模式是 U-Boot，一种常见的嵌入式设备启动模式，通过 UEFI on Top of U-Boot 技术可以实现 UEFI 启动。

参考：<https://wiki.ubuntu.com/ARM/RaspberryPi>

<https://elinux.org/RPi_U-Boot>

<https://fedoraproject.org/wiki/Architectures/ARM/Raspberry_Pi/zh-cn>

<https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/README.md>

在 LinuxMint 下操作：

```sh
sudo apt install git make gcc gcc-aarch64-linux-gnu
git clone git://github.com/swarren/u-boot.git
cd u-boot
sudo make rpi_3_defconfig
sudo make CROSS_COMPILE=aarch64-linux-gnu-

mkdir ~/tmp
wget -O ~/tmp/bcm2837-rpi-3-b.dtb http://ports.ubuntu.com/dists/bionic/main/installer-arm64/current/images/device-tree/bcm2837-rpi-3-b.dtb
```

## 其它

### 工作温度、输出电流

参考官方文档：<https://www.raspberrypi.org/documentation/faqs/>

[树莓派的工作温度测试](http://shumeipai.nxez.com/2019/04/02/what-is-the-ideal-raspberry-pi-cpu-temperature-range.html)

根据 [RPi FAQ](https://www.raspberrypi.org/help/faqs)，LAN9512 的工作温度范围在 0°C 到 70°C，BCM2835 的工作温度范围在 -40°C 到 85°C。

|         Product         | Recommended PSU current capacity | Maximum total USB peripheral current draw | Typical bare-board active current consumption |
| :---------------------: | :------------------------------: | :---------------------------------------: | :-------------------------------------------: |
| Raspberry Pi 3 Model B+ |               2.5A               |                   1.2A                    |                     500mA                     |

参考：[配置树莓派 USB 接口的电流限制](http://shumeipai.nxez.com/2017/12/11/configure-the-current-limit-of-the-raspberry-pi-usb-interface.html)

config.txt 的官方文档：<https://www.raspberrypi.org/documentation/configuration/config-txt/README.md>

具体配置需要修改 /boot/config.txt 这个文件，在最后面添加三行。

```ini
max_usb_current=1
current_limit_override=0x5A000020
avoid_warnings=2
```

由于电源芯片限制，最大电流为 1.2A。重新启动树莓派即可生效。

### Lite 版安装桌面环境

参考：<https://www.raspberrypi.org/forums/viewtopic.php?f=66&t=133691>

```bash
sudo apt-get update && sudo apt-get upgrade
sudo apt-get dist-upgrade
```
