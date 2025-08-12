# DebianNAS

## 安装系统

1. 使用网络安装镜像即可，即 `*-netinst.iso` 。
2. 选用 tuna 或 USTC 源。
3. 不要使用 swap 分区
4. 禁用 root 账户，新创建一个普通账户，会自动加入到 sudoer 用户组。
5. 要勾选 SSH Server，否则无法 SSH 登录

配置 APT 更新源，参考：<https://mirrors.tuna.tsinghua.edu.cn/help/debian/>

```sh
# 配置 APT 更新源
if [ ! -f /etc/apt/sources.list.bak ]; then sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak; fi
# 修改更新源
cat << "EOF" | sudo tee /etc/apt/sources.list
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware
EOF
# ---------------------------------------------------------------------
# 更新软件
sudo apt update && sudo apt upgrade
```

配置

```sh
# ---------------------------------------------------------------------
# 设置命令别名
uu
# ---------------------------------------------------------------------
# 设置 ssh 免密自动登录
# ---------------------------------------------------------------------
# 配置 python
# ---------------------------------------------------------------------
```

## 磁盘管理

挂载硬盘最优雅的方式是采用 LABEL 方式。

参考：<https://systemd-book.junmajinlong.com/systemd_fstab.html>

```sh
# lsblk 添加 f 参数可以查看文件系统的格式、UUID
lsblk -f
# 查看卷标信息
sudo blkid
# 查看分区格式，挂载情况、容量等信息
df -hT
# 修改卷标
sudo tune2fs -L hd1 /dev/sdb1
sudo blkid

# nofail,x-systemd.device-timeout=30 在挂载失败时 (比如设备不存在) 直接跳过。
# nofail 通常会结合 x-systemd.device-timeout 一起使用，表示等待该设备多长时间才认为可用于挂载 (即判断该设备可执行挂载操作)，默认等待 90s
#noauto,x-systemd.automount：noauto 表示开机时不要自动挂载，x-systemd.automount 表示在第一次对该文件系统进行访问时自动挂载。
#内核会将从触发自动挂载到挂载成功期间所有对该设备的访问缓冲下来，当挂载成功后再去访问该设备。

sudo mkdir -p /mnt/hd1
if [ ! -f /etc/fstab.bak ]; then sudo cp /etc/fstab /etc/fstab.bak; fi
cat << "EOF" | sudo tee -a /etc/fstab
LABEL=hd1  /mnt/hd1  auto  defaults,noatime,nofail,x-systemd.device-timeout=30,noauto,x-systemd.automount  0  2
EOF
systemctl daemon-reload
sudo mount -a
```

### 自动挂载磁盘

参考：[Linux 下用 udevil 实现 USB 存储设备自动挂载](https://ruohai.wang/202307/linux-auto-mount-usb-storage/)

```sh
sudo apt install udevil

systemctl start devmon@${USER}.service
systemctl enable devmon@${USER}.service
# 注意：无法自动加载 exfat 磁盘
#default_options_exfat     = nosuid, noexec, nodev, noatime, umask=0077, uid=$UID, gid=$GID, iocharset=utf8, namecase=0, nonempty
if [ ! -f /etc/udevil/udevil.conf.bak ]; then sudo cp /etc/udevil/udevil.conf /etc/udevil/udevil.conf.bak; fi
# 检查语法
sed -n 's/\(default_options_exfat.*\),\s*nonempty/\1/p' /etc/udevil/udevil.conf
# 直接修改
sudo sed -i 's/\(default_options_exfat.*\),\s*nonempty/\1/' /etc/udevil/udevil.conf
```

或者配置 udev 脚本

参考：<https://github.com/Ferk/udev-media-automount>

## 配置共享

安装 samba

```sh
sudo apt install samba
```

创建一个共享目录

```sh
sudo mkdir /home/public
sudo chmod 777 /home/public
```

配置 samba

```sh
# 配置 samba
if [ ! -f /etc/samba/smb.conf.bk ]; then sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bk; fi
cat << "EOF" | sudo tee /etc/samba/smb.conf
[global]
    # 局域网工作组
    workgroup = WORKGROUP
    # 网络邻居上显示的名称，默认为主机名 hostname
;    netbios name = debian
    # 出现在 Windows 网上邻居上显示的注释
    server string = %h server
    # 需要账号密码模式，推荐使用此模式
    security = user
    # 匿名访问时映射为 Bad user，要实现匿名访问的必要设置
    map to guest = Bad User
    # 默认匿名设置时映射的用户名，默认值 nobody，可以不用设置。
    guest account = nobody
    # 默认值 SMB2_02，个别无法访问可以设为 NT1，最高值为 SMB3_11（Windows 10 SMB3 version）
    client min protocol = SMB2_02
 # 对独占 oplocked 锁文件使用 sendfile 函数系统会更高效。系统 CPU 使用效率更高，Samba 速度也更快。
 # 如果客户端使用比 NT LM 0.12 还低的协议或者是 Windows 9X 时 Samba 会自动关闭该功能。
 use sendfile = yes
 # 异步 IO
 aio read size = 1
 # 异步 IO
 aio write size = 1
[homes]
    comment = 用户家目录
    browseable = no
    read only = no
    create mask = 0644
    directory mask = 0755
    valid users = %S
    # 启用回收站功能
    vfs objects =  recycle
        # %U 按登录的用户名分开存放
        recycle:repository = .trash/%U
        recycle:keeptree = yes
        # 不覆盖同名文件
        recycle:versions = yes
        # 指定覆盖同名文件的文件类型
        recycle:noversions = *.tmp|*.temp
        # 放入回收站时更新 最后访问时间
        recycle:touch = yes
        # 放入回收站时不更新 最后修改时间
        recycle:touch_mtime = no
        recycle:directory_mode = 0777
        recycle:subdir_mode = 0700
        recycle:exclude = *.tmp|*.temp
        recycle:exclude_dir =
        recycle:maxsize = 0
[public]
    comment = 共享目录
    path = /home/public
    browseable = yes
    # 允许匿名访问，与 public 参数功能一样
    guest ok = yes
    # 默认只读。设置可写 no 后，任何人都有写权限，下面的 write list 参数就会作废
    read only = yes
    # 通过下面 2 个参数精确控制读写权限
    read list =
    write list = @family
    create mask = 0666
    directory mask = 0777
EOF
sudo systemctl restart nmbd
sudo systemctl restart smbd
```

## 配置用户

参考：<https://itboon.github.io/linux-20/managing-user/user-and-group/>

管理用户和组可以使用底层工具 `useradd`、`groupadd`、`usermod`，也可以使用 `adduser` 这种对用户友好的前端工具。前端工具适合交互式操作，上手简单；底层工具适合在脚本中使用，学习成本稍微高一点。

```sh
# 添加用户组
# 普通用户组
#sudo groupadd users
# 家庭用户组
sudo groupadd family
# 将当前用户添加至 family 用户组
sudo adduser $USER family
# 也可以用下面的命令
#sudo usermod $USER -a -G family
# 将当前用户添加至 samba 用户，并设置密码
sudo smbpasswd -a $USER
# 查看当前用户所属哪些用户组
groups $USER

# 创建一个标准用户
# debian 下，adduser 命令创建用户是会在/home 下自动创建与用户名同名的用户目录，系统 shell 版本，会在创建时会提示输入密码，更加友好。会同时创建同名群组。
sudo adduser --ingroup family selina
groups selina
# samba 添加用户，并修改密码
sudo smbpasswd -a selina

# 创建一个访客用户，最小的权限，没有主目录，禁用「登录 shell」
# 创建用户，并附加到 family 组，主组仍是 users 用户组，-N 不创建同名的组
#sudo useradd a -G family -N -s /usr/sbin/nologin
# 不用设置用户密码，只用设置 samba 密码即可访问共享
#sudo smbpasswd -a a

```

## 安装 syncthing

在 官网 直接下载程序包，将 `syncthing` 文件放至 `~/.local/bin/` 目录下：

```sh
chmod 744 ~/.local/bin/syncthing

# 启动一下，让它自动生成配置文件
syncthing -gui-address="0.0.0.0:8384" -no-browser &
sleep 20
pkill syncthing
sleep 2

# 修改配置文件
sed -i 's/127\.0\.0\.1/0\.0\.0\.0/' ~/.local/state/syncthing/config.xml

mkdir -p ~/.config/systemd/user
cat << EOF | tee ~/.config/systemd/user/syncthing.service
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
ExecStart=$HOME/.local/bin/syncthing -no-browser -no-restart -logflags=0
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

systemctl --user enable syncthing.service
systemctl --user start syncthing.service
# 随系统自动启动 systemd 用户实例
sudo loginctl enable-linger $USER

systemctl --user status syncthing.service
```

## OMV

[官方文档](https://docs.openmediavault.org/en/latest/installation/on_debian.html)

Debian 下安装 OMV，不能有桌面环境

```sh
# Install the openmediavault keyring manually
sudo apt-get install --yes gnupg
wget --quiet --output-document=- https://packages.openmediavault.org/public/archive.key | sudo gpg --dearmor --yes --output "/usr/share/keyrings/openmediavault-archive-keyring.gpg"

# Add the package repositories
cat <<EOF | sudo tee /etc/apt/sources.list.d/openmediavault.list
deb [signed-by=/usr/share/keyrings/openmediavault-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/public sandworm main
deb [signed-by=/usr/share/keyrings/openmediavault-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/packages sandworm main
## Uncomment the following line to add software from the proposed repository.
# deb [signed-by=/usr/share/keyrings/openmediavault-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/public sandworm-proposed main
# deb [signed-by=/usr/share/keyrings/openmediavault-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/packages sandworm-proposed main
## This software is not part of OpenMediaVault, but is offered by third-party
## developers as a service to OpenMediaVault users.
# deb [signed-by=/usr/share/keyrings/openmediavault-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/public sandworm partner
# deb [signed-by=/usr/share/keyrings/openmediavault-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/packages sandworm partner
EOF

# Install the openmediavault package，需要安装 188 个软件包
export LANG=C.UTF-8
export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none
sudo apt-get update
sudo apt-get --yes --auto-remove --show-upgraded \
    --allow-downgrades --allow-change-held-packages \
    --no-install-recommends \
    --option DPkg::Options::="--force-confdef" \
    --option DPkg::Options::="--force-confold" \
    install openmediavault

# Populate the openmediavault database with several existing system settings, e.g. the network configuration
sudo omv-confdbadm populate
```

登录 web 后台，账号 admin，密码 openmediavault，修改密码，将用户添加到_ssh 用户组中，修改自动登出时间 1 天。

```sh
# 修改
sudo omv-firstaid

# 删除 apt 缓存
sudo apt-get clean
```

## Debian CasaOS

官方：<https://github.com/IceWhaleTech/CasaOS>

```sh
# 先手动安装 docker

wget -qO- https://get.casaos.io | sudo bash
```
