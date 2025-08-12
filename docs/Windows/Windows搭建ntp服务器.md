# Windows 搭建 ntp 服务器

参考：[Windows 搭建 ntp 服务器](https://www.cnblogs.com/IamHzc/p/18201458)

[如何在 Windows Server 中配置权威时间服务器](https://learn.microsoft.com/zh-cn/troubleshoot/windows-server/active-directory/configure-authoritative-time-server)

添加一下注册表内容

```reg
Windows Registry Editor Version 5.00

;启用NTP服务
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer]
"Enabled"=dword:00000001

;服务器将广播其时间，并接受来自客户端的请求
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Config]
"AnnounceFlags"=dword:00000005

```

重启 Windows Time 服务，管理员权限运行 powershell（或命令提示符）

```cmd
net stop w32time
net start w32time
```

测试 ntp 服务器是否搭建成功（有时间回显就是搭建成功）

```cmd
w32tm /stripchart /computer:127.0.0.1
```

开启防火墙，允许其他计算机连接本地计算机搭建的 NTP 服务器，管理员权限运行 powershell

```cmd
New-NetFirewallRule -DisplayName "NTP Outbound" -Direction Outbound -Protocol UDP -LocalPort 123 -Action Allow
```
