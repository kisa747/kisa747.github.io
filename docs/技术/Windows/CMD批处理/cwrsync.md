# cwrsync

cwrsync 是 rsync 在 windows 上的实现，官方地址 [cwrsync](https://www.itefix.net/cwrsync/client/downloads) ，一般下载 client 客户端即可。

## 关闭 ACL 功能

这个操作很重要，否则 Windows 之间同步权限会混乱，同步至 Linux 权限也会混乱。

在 `cwrsync` 安装目录的 `etc` 文件夹下创建 `fstab`文件，确保关闭 ACL 功能。内容如下：

```ini
# \cwrsync\etc\fstab
none /cygdrive cygdrive binary,posix=0,user,noacl 0 0
# 注意下面一定要有换行
```

## Windows 同步至 Linux 服务器

需要确保 Linux 服务端也要安装有 `rsync` 软件，如果没有，手动安装

```sh
sudo apt update && sudo apt install rsync
```

设置免密登录 SSH 登录，需要设置私钥的权限，管理员权限运行以下命令，**删除所有继承的 ACE、赋予当前用户完全访问权限**。

```sh
# /inheritance:r 删除所有继承的 ACE
# /grant[:r] Sid:perm 授予指定的用户访问权限。
# 如果使用 :r，这些权限将替换以前授予的所有显式权限。
# 如果不使用 :r，这些权限将添加到以前授予的所有显式权限。
#    perm 是权限掩码，可以指定两种格式之一：
#        简单权限序列：
#                N - 无访问权限
#                F - 完全访问权限
#                M - 修改权限
#                RX - 读取和执行权限
#                R - 只读权限
#                W - 只写权限
#                D - 删除权限

# 删除所有继承的 ACE
# 赋予当前用户完全访问权限

icacls "%USERPROFILE%\.ssh\id_ed25519" /inheritance:r
icacls "%USERPROFILE%\.ssh\id_ed25519" /grant:r "%USERNAME%":F
```

使用以下批处理命令镜像同步指定目录

```cmd
@echo off
title CWRSYNC备份

cd /d %~dp0

set CWRSYNC=D:\App\Shell\cwrsync\bin\rsync.exe

%CWRSYNC% -avPhh --delete -f": .rsync-filter" -f'+ /src/' -f'+ /*.toml' -f'-p .*/' -f'-p /*' /cygdrive/d/Home/Git-Repo/pycode/ kevin@debian.local:/home/kevin/pycode

# 如果未关闭ACL功能，需要指定目标地的权限
# rsync -avPhh --delete --chown=0:0 --chmod=D755,F644 -f'+ /src/' -f'+ /*.toml' -f'-p .*/' -f'-p /*' /cygdrive/d/Home/Git-Repo/pycode/ kevin@debian.local:/home/kevin/pycode


pause
```

Windows 本机同步

```sh
@echo off
title CWRSYNC备份

cd /d %~dp0

set CWRSYNC=D:\App\Shell\cwrsync\bin\rsync.exe

%CWRSYNC% -avPhh --delete -f": .rsync-filter" /cygdrive/e/test/rsync测试/0source/ /cygdrive/e/test/rsync测试/des

pause
```
