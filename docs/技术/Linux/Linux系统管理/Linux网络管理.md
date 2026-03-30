# Linux 网络管理

## ip 命令

参考：<https://linux.cn/article-3144-1.html>

```sh
# 查看 ip 地址
ip address
ip neigh
ip route
ip link
# 开启网卡
ip link set eth0 up
# 关闭网卡
ip link set eth0 down
# 查看接入你所在的局域网的设备的 MAC 地址，相当于 arp 命令
ip neigh

# release ip：释放 IP
sudo dhclient -r
# 获取 IP
sudo dhclient
```

## 无线网络

### 主配置文件

```ini
# 此文件可以直接放置在：/boot/wpa_supplicant.conf
# 配置位于：/etc/wpa_supplicant/wpa_supplicant.conf
# priority 优先级，数字越大，优先级越高，不可以为负数。
# ip link 命令查看网卡信息
# sudo ip link set wlan0 down && sudo ip link set wlan0 up
# sudo systemctl restart networking.service

ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
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

### 手动连接无线网络

参考：<https://github.com/raspberrypi/documentation/blob/master/configuration/wireless/wireless-cli.md>

<https://linuxconfig.org/how-to-connect-to-wifi-from-the-cli-on-debian-10-buster>

```sh
# 查看无线网卡的设备名称，树莓派上是 wlan0
ip a
# 扫描可见的无线网络，无法显示中文。
sudo iwlist wlan0 scan | grep -i ssid
# 生成加密的 psk 密码，会提示输入密码。
wpa_passphrase "testing"
# 添加无线网络，会提示输入密码。
wpa_passphrase "ssid" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null
# 添加无线网络，直接写入密码。
wpa_passphrase "ssid" "password" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null
# 可以看到已经写到配置文件了。
cat /etc/wpa_supplicant/wpa_supplicant.conf
# Reconfigure the interface
wpa_cli -i wlan0 reconfigure
# 如果有必要，可以重启 wpa_supplicant 服务。
sudo systemctl restart wpa_supplicant
# 查看是否连接上了无线网络
ifconfig wlan0
```

## Zeroconf

参考：<https://wiki.debian.org/ZeroConf>

<https://www.cnblogs.com/taosim/articles/2639520.html>

Zero configuration networking(zeroconf) 零配置网络服务规范，是一种用于自动生成可用 IP 地址的网络技术，不需要额外的手动配置和专属的配置服务器。

“零配置网络服务”的目标，是让非专业用户也能便捷的连接各种网络设备，例如计算机，打印机等。整个搭建网络的过程都是通过程式自动化实现。如果没有 zeroconf，用户必须手动配置一些服务，例如 DHCP、DNS，计算机网络的其他设置等。这些对非技术用户和新用户们来说是很难的事情。

Zeroconf 规范的提出者是 Apple 公司。

## Avahi

Avahi 是 Zeroconf 规范的开源实现，常见使用在 Linux 上。包含了一整套多播 DNS(multicastDNS)/DNS-SD 网络服务的实现。它使用 的发布授权是 LGPL。Zeroconf 规范的另一个实现是 Apple 公司的 Bonjour 程式。Avahi 和 Bonjour 相互兼容 (废话，都走同一个 规范标准嘛，就象 IE，Firefox，chrome 都能跑 HTTP1.1 一样)。

Avahi 允许程序在不需要进行手动网络配置的情况 下，在一个本地网络中发布和获知各种服务和主机。例如，当某用户把他的计算机接入到某个局域网时，如果他的机器运行有 Avahi 服务，则 Avahi 程式自 动广播，从而发现网络中可用的打印机、共享文件和可相互聊天的其他用户。这有点象他正在接收局域网中的各种网络广告一样。

Linux 下系统实际启动的进程名，是 `avahi-daemon` ，服务名为 `avahi-daemon.service`。

```sh
systemctl status avahi-daemon.service
```
