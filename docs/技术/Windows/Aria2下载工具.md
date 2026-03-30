# Aria2 下载工具

## 配置文件

配置文件为 aria2.conf，内容如下：

```ini
# aria2.conf
# Auto generated file, changes to this file will lost.
## '#'开头为注释内容，选项都有相应的注释说明，根据需要修改 ##
## 被注释的选项填写的是默认值，建议在需要修改时再取消注释  ##

## 文件保存相关 ##
# 文件的保存路径 (可使用绝对路径或相对路径), 默认：当前启动位置
dir=E:\Download
# 断点续传
continue=true
# 启用磁盘缓存，0 为禁用缓存，需 1.16 以上版本，默认:16M
#disk-cache=32M
# 文件预分配方式，能有效降低磁盘碎片，默认:prealloc
# NTFS(MinGW build only)、ext4 建议使用 falloc
file-allocation=falloc
# 最大同时下载任务数，运行时可修改，默认:5
max-concurrent-downloads=20
# Make aria2 quiet (no console output). Default: false
#quiet=true


## 进度保存相关 ##
# 从会话文件中读取下载任务
input-file=aria2.session
# 在 Aria2 退出时保存 错误/未完成 的下载任务到会话文件
save-session=aria2.session
# 定时保存会话，0 为退出时才保存，需 1.16.1 以上版本，默认:0
save-session-interval=60

## RPC 相关设置 ##
# 启用 RPC, 默认:false
enable-rpc=true
# RPC 监听端口，端口被占用时可以修改，默认:6800
rpc-listen-port=6800
# 允许所有来源，默认:false
rpc-allow-origin-all=true
# 允许从外部访问，默认:false
rpc-listen-all=true
# 是否启用 RPC 服务的 SSL/TLS 加密，
# 启用加密后 RPC 服务需要使用 https 或者 wss 协议连接
#rpc-secure=true
# 在 RPC 服务中启用 SSL/TLS 加密时的证书文件，
# 使用 PEM 格式时，您必须通过 --rpc-private-key 指定私钥
#rpc-certificate=$HOME/.config/aria2/server.crt
# 在 RPC 服务中启用 SSL/TLS 加密时的私钥文件
#rpc-private-key=/$HOME/.config/aria2/server.key

## BT/PT下载相关 ##
# 打开 DHT 功能，PT 需要禁用，默认:true
enable-dht=true
dht-file-path=dht.dat
# 打开 IPv6 DHT 功能，PT 需要禁用
enable-dht6=true
dht-file-path6=dht6.dat
# 分享率 1.0，默认值。
seed-ratio=1
# 做种 30 分钟。
seed-time=30
# 本地节点查找，PT 需要禁用，默认:false
bt-enable-lpd=true
# 种子交换，PT 需要禁用，默认:true
enable-peer-exchange=true
# 当下载的是一个种子 (以.torrent 结尾) 时，自动开始 BT 任务，默认:true
follow-torrent=true
# 客户端伪装，PT 需要
peer-id-prefix=-TR2940-
user-agent=Transmission/2.94

bt-tracker=http://1337.abcvg.info:80/announce
```

Windows 下可以配置为服务，使用以下命令管理

```cmd
rem 管理aria2.cmd
@echo off
echo 必须以管理员身份运行该程序
%1 mshta vbscript:Createobject("Shell.Application").ShellExecute("%~s0","::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

cls
echo.
echo 1、安装服务、启动服务
echo 2、停止服务、卸载服务
echo 3、start aria2c-winsw
echo 4、kill aria2c-winsw
echo.
choice /C 1234 /M "请选择："
if %errorlevel%==1 goto install
if %errorlevel%==2 goto uninstall
if %errorlevel%==3 goto start_it
if %errorlevel%==4 goto kill_it

:install
:: 注册服务
aria2c-winsw.exe install
:: 启动服务
aria2c-winsw.exe start
rem net start syncthing-winsw
pause && exit

:uninstall
::停止服务
rem syncthing-winsw.exe stop
net stop aria2c-winsw
:: 卸载服务
aria2c-winsw.exe uninstall
pause && exit

:start_it
start "aria2" aria2c.exe --enable-rpc --rpc-listen-all --rpc-allow-origin-all --conf-path=aria2.conf
exit

:kill_it
::杀死syncthing进程
taskkill /im aria2c.exe /t /f
exit
```
