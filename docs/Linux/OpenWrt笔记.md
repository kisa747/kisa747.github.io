# OpenWrt 笔记

参考：<https://blog.csdn.net/lwz2008123/article/details/51165664>

官方文档：<https://openwrt.org/docs/guide-user/start>

## Newifi mini 简介

参考：<https://openwrt.org/toh/lenovo/lenovo_y1_v1>

硬件简介：

| Model          | SoC              | CPU MHz | Flash MB | RAM MB | WLAN Hardware    | WLAN2.4 | WLAN5.0 | 100M ports | USB    |
| -------------- | ---------------- | ------- | -------- | ------ | ---------------- | ------- | ------- | ---------- | ------ |
| Newifi mini Y1 | MediaTek MT7620A | 580     | 16       | 128    | MediaTek MT7612E | b/g/n   | a/n/ac  | 2          | 1x 2.0 |

内部存储 16 M，内存 128M，单核 MIPS 构架 CPU 主频 580MHZ，除了内部存储有点小，其它的性能还可以，而且 U-boot 未锁，刷系统很方便。

## 安装 OpenWrt

参考：<https://linuxtoy.org/archives/install-openwrt-on-newifi-mini.html>

Newifi 的设备名称是 `Newifi mini Y1`，这款设备的 U-boot 并没有锁，所以您完全可以直接刷入 OpenWrt 系统的，方法如下：

1. 前往 OpenWrt 官网下载对应固件，设备实际型号名为 [Lenovo Y1](https://openwrt.org/toh/lenovo/lenovo_y1_v1) 。
2. 通过有线连接设备，并将 PC 端设备 IP 设定为 `192.168.1.11`，子网掩码 `255.255.255.0`，网关 `192.168.1.1` 。
3. 拔下路由器后面的电源，拿在手里，然后再次通电，之后 **迅速按下 RESET 按钮**，若是设备上出现两个蓝灯连续闪烁，代表已经进入 U-boot 恢复模式。
4. 在浏览器中输入 192.168.1.1 进入恢复模式页面，选择之前下载的 bin 文件即可开始刷机
5. 将 PC 端设备 IP 重置为自动获取模式，即可开始常规 OpenWrt 配置了

## OpenWrt 配置

### 配置 SSH 登录

1、生成公钥、密钥

打开 puttygen.exe，点击 Generate 生成公钥、密钥。复制密钥框的内容。

点击 Save public key、Save private key 分别保存公钥、密钥。

2、在 openwrt 的 web 界面 - 系统 - 管理权，粘贴 SSH 公钥。

2、打开 putty，填写地址（192.168.2.1），端口号（22），选择“ssh”协议；

在左侧找到“Connection”，在“Data”项，在“Auto-login username”项填写用户名；

在“SSH” -> “Auth”，在“Private key file for authentication”项，点击“Browse...”，选择第 2 步转换的“.ppk”格式的证书；

保存当前的“Session”后；

点击“Open” ，即可自动登录。

### 修改路由内网地址

修改修改 LAN 接口 IP 地址段，openwrt 默认的 192.168.1.1 很容易与其他路由冲突，因此修改为 192.168.2.1

直接在 luci 界面修改，会无法进入后台。因此需要 ssh 登陆后，命令行修改。

```sh
vi /etc/config/network
```

输入命令 i 开始编辑，修改以下内容：

```ini
config interface 'lan'
        option type 'bridge'
        option ifname 'eth0.1'
        option proto 'static'
        option ipaddr '192.168.2.1'  # 修改此处
        option netmask '255.255.255.0'
        option ip6assign '60'
```

按 ESC 键，输入 :wq 命令保存并退出。

使用命令直接修改：

```sh
if [ ! -f /etc/config/network.bak ]; then sudo cp /etc/config/network /etc/config/network.bak; fi
sed -i "s|option ipaddr '192.168.1.1'|option ipaddr '192.168.2.1'|g" /etc/config/network
```

重启路由，即可使用 `192.168.2.1` 访问。

```sh
reboot
```

### 设置二级路由

由于 newifi 性能比较渣，所以做为二级路由，小米路由作为一级路由。

参考：<https://www.right.com.cn/forum/thread-209013-1-1.html>

设置二级路由：

1、OpenWrt - 网络 - 防火墙 - Zones，只需把 wan 区域的 Input 入站数据改成 accept 接受即可。

编辑配置文件：`/etc/config/firewall` ，在 wan 下面添加：`option input 'ACCEPT'`

```ini
config zone
 option name 'wan'
 list network 'wan'
 list network 'wan6'
 option output 'ACCEPT'
 option forward 'REJECT'
 option masq '1'
 option mtu_fix '1'
 option input 'ACCEPT'
```

2、配置 `/etc/samba/smb.conf.template` ，把 `bind interfaces only = yes` 的 yes 改为 no。

```sh
sed -i "s/bind interfaces only = yes/bind interfaces only = no/g" /etc/samba/smb.conf.template
```

设置一级路由：

1、DHCP 静态 IP 分配，将二级路由绑定固定 IP：`192.168.31.31`

重启 samba 服务后生效。

```sh
service samba restart
```

### 设置时区

记得在 `Luci - 系统 - 系统` ，设置时区为 `Asia/Shanghai` 。否则默认时区为 `UTC` ，计划任务会无法正确执行。

修改配置文件：`/etc/config/system`

```sh
sed -i 's|UTC|Asia\/Shanghai|g' /etc/config/system
sed -n '/zonename/p' /etc/config/system
```

## 软件配置

### 修改软件源

参考：<http://mirrors.ustc.edu.cn/help/lede.html>

```sh
if [ ! -f /etc/opkg/distfeeds.conf.bak ]; then cp /etc/opkg/distfeeds.conf /etc/opkg/distfeeds.conf.bak; fi
sed -i 's|downloads\.openwrt\.org|mirrors.ustc.edu.cn/lede|' /etc/opkg/distfeeds.conf
```

### 软件安装

```sh
# 每次登录后，安装软件前都要先执行 update
# 更新软件列表
opkg update
# The 802.11AC, or 5G wireless capability is provided kmod-mt76 package. It may be installed via terminal
opkg install kmod-mt76

# 中文界面
opkg install luci-i18n-base-zh-cn

# 挂载 U 盘所需要的包
opkg install kmod-usb-core  # usb 核心驱动
opkg install kmod-usb-storage         # 安装 usb 存储设备驱动
#opkg install kmod-usb-ohci            # 安装 usb 1.1 控制器驱动
opkg install kmod-usb2                # 安装 usb2.0
opkg install kmod-usb3                # 安装 usb3.0
opkg install kmod-usb-storage-uas     # usb 大容量设备，大移动硬盘支持
#opkg install kmod-usb-storage-extras  # 读卡器等 USB 存储设备
opkg install kmod-fs-ext4             #安装 ext4 分区格式支持组件
opkg install kmod-fs-ntfs
#opkg install ntfs-3g                  #安装读写 NTFS
#opkg install fdisk  # 分区工具，自动挂载脚本需要使用它判别磁盘分区格式。
opkg install block-mount              #开机自动挂载磁盘。包含 block-hotplug，
opkg install e2fsprogs                #EXT 文件系统格式化和检测工具 fsck
opkg install luci-app-hd-idle         #硬盘休眠功能，自动安装 hd-idle

#安装 samba、samba 的 web 配置工具
opkg install samba36-server
opkg install luci-app-samba

# 安装 aria2
opkg install aria2
#opkg install luci-app-aria2
#opkg install luci-i18n-aria2-zh-cn
#opkg install webui-aria2  # 安装 web 管理界面
```

### 磁盘挂载

在 Linux 系统下使用 Gparted 对移动硬盘进行分区：

```ini
/dev/sda1 ext4
/dev/sda2 swap
```

将 U 盘插入路由器，在 路由器 - 系统 - 挂载点，进行配置。挂载如下：

修改配置文件：`vi /etc/config/fstab`

```ini
config global
        option auto_swap '1'
        option auto_mount '1'
        option delay_root '5'
        option anon_swap '1'
        option anon_mount '1'
        option check_fs '1'

config mount
        option enabled '1'
        option device '/dev/sda1'
        option target '/home'
        option fstype 'ext4'
        option enabled_fsck 1

config swap
        option enabled '1'
        option device '/dev/sda2'
```

创建必要的目录、文件：

```sh
mkdir /mnt/sda1  # 创建 U 盘挂载点
mkdir /mnt/home  # 创建 U 盘挂载点

# 重新让 block-mount 自动挂载识别到的驱动器，相当于 /etc/init.d/fstab restart
block umount && block mount

df -h
# 确认磁盘正确挂载后，创建必要的文件、目录
mkdir -p /home/download
mkdir -p /home/data/aria2
touch /home/data/aria2/aria2.session
```

### 配置 samba

 参考：<https://lixingcong.github.io/2017/11/25/lede-samba/>

在 web 配置界面，取消勾选 `Share home-directories`

#### 1、添加 samba 用户

修改配置文件：`vi /etc/passwd`

```sh
echo "newuser:x:0:0:newuser:/home:/bin/ash" >> /etc/passwd
```

设置 samba 用户的密码：

```sh
touch /etc/samba/smbpasswd
# 根据提示，输入两遍密码
smbpasswd -a newuser
# 不推荐添加 root 用户
#smbpasswd -a root

# 配置好后重启 samba
/etc/init.d/samba restart
```

#### 2、修改 samba 配置文件

修改配置文件：`vi /etc/samba/smb.conf.template`

```sh
# 不绑定登录地址
bind interfaces only = no

# 注释这句的话，可以添加 root 用户
# invalid users = root

# 添加 NTLMv2 认证，否则 samba 在 NT6 内核以上 (win7,8,10) 登陆 samba 认证失败
client ntlmv2 auth = yes
```

4、web 界面添加共享文件夹

修改配置文件：`vi /etc/config/samba`

| 名称   |     Path     | Allowed users | Read-only | Browseable | Allow guests | Create mask | Dir mask |
| ------ | :----------: | ------------- | :-------: | :--------: | :----------: | ----------- | -------- |
| Home   |    /home     | newuser       |           |     √      |              | 0777        | 0777     |
| Public | /home/public |               |     √     |     √      |      √       | 0777        | 0777     |

上述设置代表分享两个目录

- Home: 只允许 newuser 登陆，对应/mnt/sda1（上面 smbpasswd 命令中设置的密码）
- Public: 允许匿名登陆，对应/mnt/sda1/public（实际上匿名只有只读权限，因为/mnt/sda1/public 的所有者是 root）

配置文件：`/etc/samba/smb.conf`

```ini
[global]
# 全局设置在 /etc/samba/smb.conf.template 中修改

[Public]
        path = /home/public
        read only = yes
        guest ok = yes
        create mask = 0744
        directory mask = 0755
        browseable = yes

[Home]
        path = /home
        valid users = newuser
        read only = no
        guest ok = no
        create mask = 0744
        directory mask = 0755
        browseable = yes
```

点击 luci 底部的 `save & apply` 或者执行 `/etc/init.d/samba restart`  重启 samba 服务。

```sh
# 重启 samba 服务
/etc/init.d/samba restart
serviec samba restart
```

### 配置 aria2

参考：<https://meta.appinn.com/t/aria2-2018-11-19/7434>

<https://aria2c.com/usage.html>

#### 1、修改配置文件

```sh
vi /home/data/aria2/aria2.conf
```

内容如下：

```ini
# Auto generated file, changes to this file will lost.
dir=/home/download
enable-rpc=true
rpc-allow-origin-all=true
rpc-listen-all=true
quiet=true
continue=true
input-file=/home/data/aria2/aria2.session
save-session=/home/data/aria2/aria2.session
check-certificate=true
enable-dht=true
dht-file-path=/home/data/aria2/dht.dat
bt-tracker=udp://tracker.coppersurfer.tk:6969/announce,udp://tracker.opentrackr.org:1337/announce,http://tracker.internetwarriors.net:1337/announce,udp://9.rarbg.to:2710/announce,udp://exodus.desync.com:6969/announce,udp://tracker1.itzmx.com:8080/announce,http://tracker3.itzmx.com:6961/announce,udp://explodie.org:6969/announce,udp://ipv4.tracker.harry.lu:80/announce,udp://tracker.vanitycore.co:6969/announce,udp://denis.stalker.upeer.me:6969/announce,udp://tracker.torrent.eu.org:451/announce,udp://tracker.tiny-vps.com:6969/announce,udp://tracker.port443.xyz:6969/announce,udp://thetracker.org:80/announce,udp://open.stealth.si:80/announce,udp://open.demonii.si:1337/announce,udp://bt.xxx-tracker.com:2710/announce,udp://zephir.monocul.us:6969/announce,udp://tracker.iamhansen.xyz:2000/announce,udp://9.rarbg.to:2710/announce,udp://9.rarbg.me:2710/announce,http://tr.cili001.com:8070/announce,http://tracker.trackerfix.com:80/announce,udp://open.demonii.com:1337,udp://tracker.opentrackr.org:1337/announce,udp://p4p.arenabg.com:1337,wss://tracker.openwebtorrent.com,wss://tracker.btorrent.xyz,wss://tracker.fastcast.nz
bt-enable-lpd=true
file-allocation=none
follow-torrent=true
max-concurrent-downloads=20
peer-id-prefix=-TR2770-
rpc-listen-port=6800
save-session-interval=30
user-agent=Transmission/2.77
enable-peer-exchange=true
```

#### 2、Tracker

更多 tracker 使用：<https://github.com/ngosang/trackerslist>

<http://www.tkser.tk/>

人人影视的 Tracker

```sh
udp://9.rarbg.to:2710/announce
udp://9.rarbg.me:2710/announce
http://tr.cili001.com:8070/announce
http://tracker.trackerfix.com:80/announce
udp://open.demonii.com:1337
udp://tracker.opentrackr.org:1337/announce
udp://p4p.arenabg.com:1337
wss://tracker.openwebtorrent.com
wss://tracker.btorrent.xyz
wss://tracker.fastcast.nz
```

#### 3、创建服务

创建服务文件：`vi /etc/init.d/aria2`

```sh
#!/bin/sh /etc/rc.common
START=95
RETVAL=0
case "$1" in
    start)
        echo "Starting service Aria2..."
        aria2c --conf-path=/etc/aria2/aria2.conf -D
        echo "Start service done."
    ;;
    stop)
        echo "Stoping service Aria2..."
        killall aria2c
        echo "Stop service done."
    ;;
    restart)
        echo "Stoping service Aria2..."
        killall aria2c
        echo "Stop service done."
        aria2c --conf-path=/etc/aria2/aria2.conf -D
        echo "Restart service done."
    ;;
esac
exit $RETVAL
```

编辑后保存，赋予可执行权限 `chmod +x /etc/init.d/aria2`

#### 4、启动 aria2

```sh
aria2c --conf-path=/home/data/aria2/aria2.conf -D
```

<https://aria2c.com/usage.html>

<https://www.moerats.com/archives/462/>

#### 5、管理界面

<http://yaaw.ghostry.cn/>

<http://webui-aria2.ghostry.cn/>

<http://ariang.ghostry.cn>

### 配置 Syncthing

官方文档：<https://docs.syncthing.net>

参考：

<https://www.mivm.cn/openwrt-syncthing/>

<https://www.jianshu.com/p/92ce0050ebc7>

<https://www.jianshu.com/p/2c6692ce2038>

#### 1、安装 syncthing

syncthing 对硬件要求还是蛮高的，可用空间 16M+、内存 128M+，所以需要安装至 U 盘下。

>注意：MTK 用 MIPSLE，所以应下载 linux-mipsle 版本。

下载 `syncthing-linux-mipsle-v0.14.54.tar.gz` ，解压后复制 syncthing 文件至路由器 U 盘 `data/syncthing` 目录下。

SSH 登录路由器后，执行命令：

```sh
# 赋予可执行权限
chmod +x /home/syncthing/syncthing
# 创建链接
ln -s /home/data/syncthing/syncthing /usr/bin/syncthing

# 启动 syncthing 进行测试
syncthing -gui-address="0.0.0.0:8384" -home="/home/data/syncthing/config" -no-browser
```

然后浏览器中打开  <192.168.2.1:8384>  即可配置

#### 3、配置 windows 系统下的 syncthing

windows 下配置比较简单，直接下载 amd64 版本，压缩包内仅 syncthing.exe 文件是必须，将 syncthing.exe 文件复制至任意文件夹。

双击 syncthing.exe 运行，或是命令行无参数启动的话，默认配置文件在 `%LOCALAPPDATA%\Syncthing` 目录。方便起见，应该适当添加参数启动。

```sh
syncthing.exe -home=".\config"
```

按照上面的方法启动的话，会一直显示命令窗口。现实情况中，我们调试正常后，仅需要它在后台默默运行。

方法：创建 `启动syncthing.cmd` ，内容如下：

```vb
start "Syncthing" syncthing.exe -home=".\config" -no-console -no-browser
```

然后添加开机启动项。参考：<https://docs.syncthing.net/users/autostart.html>

#### 4、syncthing 重要设置

一般来说，我们希望笔记本的数据单向同步至 NAS，而不需要双向同步。我们仅是把 NAS 作为备份用途。

笔记本作为主数据，无条件地备份到 NAS - OpenWrt 硬盘，即使笔记本上意外删除了文件，NAS 也能保留。

NAS - OpenWrt 作为副本数据，即使 NAS - OpenWrt 上删除了文件，也不会同步至笔记本。

下面开始设置：

1、设置 笔记本主数据，浏览器中打开  <<http://127.0.0.1:8384>

> 文件夹 - 选项 - 高级 - 文件夹类型，设置为“仅发送”

2、设置 NAS - OpenWrt 副本数据，浏览器中打开  <192.168.2.1:8384>

> 文件夹 - 选项 - 高级 - 文件夹类型，设置为“仅接受”
>
> 文件夹 - 选项 - 版本控制，设置为“阶段版本控制”
>
> 添加远程设备 - 共享，勾选“自动 接受”
>
> 操作 - 设置 - 常规，设置默认文件夹路径

主数据 设置是最核心的。

#### syncthing 文档

Syncthing 有四种版本控制方式，分别是：回收站式版本控制、简易版本控制、阶段版本控制、外部版本控制。区别如下：

- 1、回收站式版本控制：当文件被 Syncthing 替换或删时，将会被移动到 .stversions 文件夹。
- 2、简易版本控制：当某个文件在其他设备被替换或删除时，本设备将会在 .stversions 文件夹中保留该文件的备份，并在文件名中加入时间戳信息。
- 3、阶段版本控制：当某个文件在其他设备被替换或删除时，本设备将会在 .stversions 文件夹中保留该文件的备份，并在文件名中加入时间戳信息。超过最长保留时间，或者不满足条件的历史版本，将会被删除。
- 4、外部版本控制：使用外部命令接管版本控制。该命令必须自行从同步文件夹中删除该文件。

### 配置 Python3

参考官方文档：<https://openwrt.org/docs/guide-user/services/python>

#### 设置软件安装位置

由于路由器内部空间较小，python 需要 37M 空间，因此需要安装至外置磁盘。

首先配置 opkg。修改 `/etc/opkg.conf`

 `/etc/opkg.conf` 原始 内容：

```ini
dest root /
dest ram /tmp
lists_dir ext /var/opkg-lists
option overlay_root /overlay
option check_signature 1
```

修改为：

```ini
dest root /
dest ram /tmp
# 使用 opkg update 之后，可以把软件仓库的信息保存的 USB 设备里面，以后就不用每次重启都要更新了。
lists_dir ext /home/data/opkg-lists
option overlay_root /overlay
option check_signature 1

# 指定 usb 位置，以后 可以使用 opkg -d usb 参数安装软件
dest usb /home/data/opkg
```

或者直接使用命令操作：

```sh
mkdir -p /home/data/opkg-lists
cp /etc/opkg.conf /etc/opkg.conf.bak
# 修改软件列表信息位置
sed -i 's|\/var\/opkg-lists|\/home\/data\/opkg-lists|g' /etc/opkg.conf

# 指定 usb 位置，以后 可以使用 opkg -d usb 参数安装软件
echo 'dest usb /home/data/opkg' >> /etc/opkg.conf
```

修改环境变量

```sh
# 添加环境变量
echo 'export PATH=$PATH:/home/data/opkg/usr/bin' >> /etc/profile
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/data/opkg/usr/lib' >> /etc/profile
# 应用配置文件
source /etc/profile
```

#### 安装 python3

Python 主要有以下三个包：

> **python3-base** - just the minimal to have a python interpreter running
>
> **python3-light** - is a “dynamic” package; it's python (full) minus all other python-codecs, python-compiler, etc
>
> **python3** - full python install, minus a few stuff that could be stripped [to reduce size], like tests [per module], some python-tk/tcl [GUI] libs

通过 opkg depends 命令检查：

```sh
opkg depends -A python3
[输出结果]：
python3 depends on:
        libc
        python3-light
        python3-unittest
        python3-ncurses
        python3-ctypes
        python3-pydoc
        python3-logging
        python3-decimal
        python3-multiprocessing
        python3-codecs
        python3-xml
        python3-sqlite3
        python3-gdbm
        python3-email
        python3-distutils
        python3-openssl
        python3-cgi
        python3-cgitb
        python3-dbm
        python3-lzma
        python3-asyncio

opkg depends -A python3-light
[输出结果]：
python3-light depends on:
        libc
        python3-base
        libffi
        libbz2

opkg depends -A python3-base
[输出结果]：
python3-base depends on:
        libc
        libpthread
        zlib
```

反正是安装到外部磁盘，最简单的就是完整安装 python3。

```sh
opkg -d usb install python3
# 顺便安装上 pip 工具
opkg -d usb install python3-pip
# 升级 pip
python3 -m pip install -U pip
# 然后就可以直接使用 pip 命令了。
pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip3 install -U setuptools wheel
pip3 install -U requests
pip3 install -U beautifulsoup4
```

## 本地启动脚本

浏览器中配置没什么问题的话，就可以将 sync 添加到启动项了。使用 nice 命令，数字越大，优先级越低。

配置文件：`/etc/rc.local`

OpenWrt - 系统 - 启动项，添加以下内容即可：

```sh
# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.
sleep 10
source /etc/profile
nice -n 19 aria2c --conf-path=/home/data/aria2/aria2.conf -D
sleep 10
nice -n 18 syncthing -gui-address="0.0.0.0:8384" -home="/home/data/syncthing/config" -no-browser >/dev/null &
exit 0
```

## 计划任务

配置位置：`/etc/crontabs/root`

OpenWrt - 系统 - 计划任务，添加以下内容即可：

```sh
# min hour day month dayofweek command
# 每天的 04:31 重启一次
31 4 * * * sleep 70 && touch /etc/banner && reboot
# 每天 13:32 执行脚本，并将屏幕信息写入日志
32 13 * * * . /etc/profile; nice -n 18 python3 /home/sync/openwrt_py/cron/daily.py >/home/sync/openwrt_py/cron/daily_screen.log 2>&1
# 每小时执行一次脚本，并将屏幕信息写入日志
4 */1 * * * . /etc/profile; nice -n 19 python3 /home/sync/openwrt_py/cron/hourly.py >/home/sync/openwrt_py/cron/hourly_screen.log 2>&1
# crontab must (as fstab) end with the last line as space or a comment
```

使用 `python3 *.py` 执行脚本，相当于直接使用解释器调用脚本，所以 *.py 脚本不需要可执行 权限。

同理也可以 `sh *.sh` 执行 shell 脚本。

执行 `crontab -e` 命令可以直接编辑计划任务。crontab 用法：

```sh
Usage: crontab [-c DIR] [-u USER] [-ler]|[FILE]
        -c      Crontab directory
        -u      User
        -l      List crontab
        -e      Edit crontab
        -r      Delete crontab
        FILE    Replace crontab by FILE ('-': stdin)
```

## 重要命令

参考 openwrt 官方文档：<https://openwrt.org/docs/guide-user/start>

```sh
# 查看 swap 分区情况
free

umount -v /dev/sda1
e2fsck /dev/sda1 > /tmp/e2fsck.log
block mount
cat /tmp/e2fsck.log >> /home/sync/openwrt_py/cron/fsck/fsck.log
```

### block 命令

```sh
vi /etc/config/fstab

# 重新让 block-mount 自动挂载识别到的驱动器，相当于 /etc/init.d/fstab restart
block umount && block mount
# 更多参考：https://openwrt.org/docs/techref/block_mount
# block 有以下用法：
block <info|mount|umount|detect>

# 开机挂载 ntfs 分区，修改 /etc/rc.local
sleep 3
ntfs-3g /dev/sda1 /mnt/usb-ntfs -o rw,sync
exit 0
```

### 自动挂载 NTFS 分区

如果要开机自动识别 ntfs 分区并挂载，需要修改 `/etc/hotplug.d/block/10-mount`

```sh
#!/bin/sh
# Copyright (C) 2011 OpenWrt.org
sleep 10 #more apps installed, need more time to load kernel modules!
blkdev=`dirname $DEVPATH`
if [ `basename $blkdev` != "block" ]; then
 device=`basename $DEVPATH`
 case "$ACTION" in
  add)
   mkdir -p /mnt/$device
   # vfat & ntfs-3g check
   if [ `which fdisk` ]; then
    isntfs=`fdisk -l | grep $device | grep NTFS`
    isvfat=`fdisk -l | grep $device | grep FAT`
    isfuse=`lsmod | grep fuse`
    isntfs3g=`which ntfs-3g`
   else
    isntfs=""
    isvfat=""
   fi

   # mount with ntfs-3g if possible, else with default mount
   if [ "$isntfs" -a "$isfuse" -a "$isntfs3g" ]; then
    ntfs-3g /dev/$device /mnt/$device
   elif [ “$isvfat” ]; then
    mount -o iocharset=utf8 /dev/$device /mnt/$device
   else
    mount /dev/$device /mnt/$device
   fi
  ;;
  remove)
   umount -l /dev/$device
  ;;
 esac
fi
```

查找包含指定关键字的 软件

```sh
opkg update
opkg list | grep -i  kmod-usb
```

编写脚本：

```sh
#!/bin/sh
# 升级所有的包，强烈不建议 !
opkg list-upgradable | awk -F ' - ' '{print $1}' | xargs opkg upgrade
```

## 其它配置设置

### 无线配置

注意，接口配置 - 网络，记得选择上 LAN 口。否则无法连接网络。

### 系统文件夹剖析

在这些配置过程中，我们使用的最多的就是 /etc 文件夹，里面涵盖了系统所有的配置。其中`config`里面包含了所有服务的配置文件，例如 PPTP-VPN、NETWORK、FTP、SAMBA 等等。
 `init.d`里面包含了所有服务的控制脚本，因此我们可以使用`/etc/init.d/vsftp start`来启动 FTP 服务，类似的指令还有`start|stop|enable|disable`。
 `rc.d`里面包含了所有开机启动服务的控制脚本的符号链接，在这里可以取消一些程序的开机启动，或者关闭它自己利用`nice`命令和开机启动脚本开启服务。
 `crontabs`里面包含了所有用户的 cron 任务规划配置，当然一般情况下我们可以使用`crontab -e`直接进行编辑。

### openwrt 启动流程

>1. CFE
>2. Linux 内核
>3. init 相关
>
> - /etc/preinit
> - /sbin/init
> - /etc/inittab
> - /etc/rc.d/S*

## Vmware 下运行 openwrt

### 制作 VMware 硬盘文件

下载 combined-ext4.img.gz

 <https://downloads.openwrt.org/releases/18.06.1/targets/x86/generic/>

<https://mirrors.ustc.edu.cn/lede/releases/18.06.4/targets/x86/64/>

下载得到：`openwrt-18.06.4-x86-64-combined-ext4.img.gz`

>rootfs 工作区存储格式为 ext4
>
>squashfs 相当于可 win 的 ghost，使用中配置错误，可直接恢复默认。
>
>rootfs 的镜像，不带引导，可自行定义用 grub 或者 syslinux 来引导，需要存储区是 ext4。
>
>一般来说，用 combined-ext4.img.gz、combined-squashfs.img 就可以了，除非你喜欢自定义折腾。

先在 linuxMint 下安装 必要软件：

参考：<https://openwrt.org/docs/guide-user/virtualization/vmware>

```sh
apt search qemu
sudo apt install qemu-utils
img_name=openwrt-18.06.4-x86-64-combined-ext4
gunzip ${img_name}.img.gz
qemu-img convert -f raw -O vmdk ${img_name}.img ${img_name}.vmdk
```

### 创建虚拟机

网络选择 `桥接`，创建完成后，将虚拟机的硬盘文件用刚才生成的 `openwrt-18.06.4-x86-64-combined-ext4.vmdk` 替换掉。

开机！到网络界面后，回车进入 prompt。

```sh
if [ ! -f /etc/config/network.bak ]; then cp /etc/config/network /etc/config/network.bak; fi
sed -i "s|option ipaddr '192.168.1.1'|option ipaddr '192.168.88.44'|g" /etc/config/network
cat /etc/config/network
/etc/init.d/network restart
# 然后可以 通过 192.168.88.44 访问 LUCI
# 设置 root 的密码，后面就可以使用 ssh 登录了
# 配置免密登录。
```

### 网络设置

测试能正常访问的话，但是无法连接外网，查看接口，仅有一个 LAN，没有 WAN。

关闭 openwrt 虚拟机，添加网络适配器，选择 `桥接模式`。

登录 LUCI，添加网络口。name：wlan；Protocol：DHCP Client，Interface：eth1。

没问题的话，就可以正常上网了。

重新将 /etc/config/network 改为 `192.168.2.1`。

### 安装软件

用 putty 登录，然后就可以愉快地耍了。

```sh
opkg update
opkg install luci-i18n-base-zh-cn
opkg install kmod-fs-ext4             #安装 ext4 分区格式支持组件
opkg install fdisk  # 分区工具，自动挂载脚本需要使用它判别磁盘分区格式。
opkg install block-mount              #开机自动挂载磁盘。包含 block-hotplug，
opkg install e2fsprogs                #EXT 文件系统格式化和检测工具 fsck

# 设置好挂载点，将 /dev/sda2 挂在到 /home，然后重启
reboot

mkdir -p /home/data/opkg-lists
cp /etc/opkg.conf /etc/opkg.conf.bak
# 修改软件列表信息位置
sed -i 's|\/var\/opkg-lists|\/home\/data\/opkg-lists|g' /etc/opkg.conf

opkg update
opkg install samba36-server
opkg install luci-app-samba
mkdir -p /home/download

# 顺便安装上 pip 工具
opkg install python3 python3-pip
# 然后就可以直接使用 pip3 命令了。
# 升级 pip
python3 -m pip install -U pip
# 然后就可以直接使用 pip 命令了。
pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple
# 默认 install 加上 --user 参数，以后使用 pip install 就不用每次加 --user 参数。
pip3 config set global.timeout 120
#默认为升级
pip3 config set install.upgrade true

pip3 install -U setuptools wheel
pip3 install -U requests
pip3 install -U beautifulsoup4
```
