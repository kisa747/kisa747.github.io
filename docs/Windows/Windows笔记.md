## 笔记

<https://docs.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/>

## 选择超过 15 个文件时，上下文菜单会缩短

[选择超过 15 个文件时，上下文菜单会缩短](https://learn.microsoft.com/zh-cn/troubleshoot/windows-client/shell-experience/context-menus-shortened-select-over-15-files)

解决方案

可以修改以下注册表值，以选择在维护上下文菜单选项时可能选择的文件数。

- 路径：HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer
- 名称：MultipleInvokePromptMinimum
- 类型：DWORD
- 默认值：15 (十进制)

## 雷神键盘绑定 DELETE 键

雷神键盘没有 DELETE 键，可以手动将不常用的 F12 键绑定为 DELETE 键。

```ini
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout]
; 参考 https://flyzto.com/windows-scancode-map.html
; 按照二进制数的读写规则，低位在左，高位在右。
; 将 F12 改为 DEL
; DEL  E0 53
; F12  00 58
"Scancode Map"=hex:00,00,00,00,00,00,00,00,02,00,00,00,53,E0,58,00,00,00,00,00
```

## Windows10 删除、重命名、新建文件后不自动刷新的问题

这个问题真是非常恶心人，百度了很多解决办法，大致是修改注册表、修改音频设置里的耳机侦测、还有修复系统文件的

统统对我的系统没作用，最后发现，开机后，如果不打开 此电脑（资源管理器），就一切正常，一旦打开后，文件的改动就不再刷新了，终于怀疑到了快速访问里固定的几个网络地址，有两个是 NAS 的内网地址，可以正常取消固定（删除），但有一个地址，不知道什么鬼，右键取消固定都操作不了，程序直接卡死，是任务管理器都无法终结、注销都卡死的那种。没法办，重启后，从网上找到办法，直接删除下列位置的所有文件

> %APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations

 重启电脑后，终于，困扰很多天的问题，彻底解决了

## 开机启动目录

>%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup

## 安装 Edge 浏览器

`Windows 10 LTSC 2021` 默认集成了 Edge 浏览器。

`Windows 10 LTSC 2019` 默认是没有 Edge 浏览器的，可以通过离线的方式进行安装，使用：

```powershell
dism /online /add-package /packagepath:"Microsoft-Windows-Internet-Browser-Package-amd64-10.0.17763.1.cab" /packagepath:"Microsoft-Windows-Internet-Browser-Package-amd64-10.0.17763.1-zh-CN.cab"
PowerShell dir $env:windir\SystemApps\*edge*\AppxManifest.xml ^|Add-AppxPackage -DisableDevelopmentMode -Register
```

## 解除 Windows 文件名长度限制

参考：<https://docs.microsoft.com/en-us/windows/win32/fileio/naming-a-file#maximum-path-length-limitation>

添加注册表：

```ini
Windows Registry Editor Version 5.00
;解除文件路径字符个数260个的限制。
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem]
"LongPathsEnabled"=dword:00000001
```

## 使用 sudo

doskey 命令相当于 Linux 下的 alias，参考：<https://superuser.com/questions/42537/is-there-any-sudo-command-for-windows>。

```bash
doskey sudo= runas /noprofile /user:Administrator "cmd /k cd \"%cd%\" & $*"
```

## 显示灰阶图出现条纹

Windows 10 1903 现恶性颜色 bug 显示灰阶图出现条纹，参考：<https://www.expreview.com/69343.html>

打开 <http://www.lagom.nl/lcd-test/gradient.php> ，能够查看效果。

## 启用 MacType

参考：<https://github.com/snowie2000/mactype>

Windows 默认的字体显示效果太渣了，锯齿严重，

## 系统设置为 utf8 编码

windows 10 是可以设置为 utf8 环境的。Windows10 下默认为 gbk（cp936），locale 可以设置为 UTF-8。

设置——时间和语言——区域和语言设置——管理语言设置——更改系统区域设置——勾选“Beta 版：使用 Unicode UTF-8 提供全球语言支持”。重启后生效。

设置成功后：

```bat
chcp
>>>Active code page: 65001
```

从 windows 10 1903 版开始，基本可以设置为 utf8 环境了，不会影响正常使用。但是还是要求一些设置，保证最大的兼容。

已知的问题，国外开发的软件一般都没有问题，反而是国内开发的软件不行。囧，还得切换回 `cp936` 。

- 批处理文件。批处理文件需设置为 utf8 编码，为保证在 cp936 环境下正常运行，在开头添加：`chcp 65001 >NUL` ，这样在各种环境下都能正常运行。
- Notepad2 设置。windows 下经常使用 Notepad2 编辑文本内容。如果文件是 gb18030 编码的文件，打开就会出现乱码，过渡期间，设置默认编码为 `gb18030` ，可以正常读取编码为 `gb18030` 的文件。
- 部分绿化程序界面会有乱码，影响不大。
- 算王无法使用，筑业资料软件无法使用。
- 部分 Word 文档、Excel 文档无法编辑。
- PE 环境编码仍旧是 cp936，因此无法执行 utf8 编码的批处理脚本。

## 延迟更新半年频道

运行 `gpedit.msc`

> 依次打开：组策略 - 计算机配置 - 管理模板 - Windows 组件 - Windows 更新 - 适用于企业的 Windows 更新 - 选择何时接受预览版和功能更新
>
> 设置为：已启用。选择要接收更新的 Windows 就绪级别：半年频道；延迟天数：365。

最多只能延迟一年。所以更推荐 LTSC 长期支持版本，只有安全更新，没有任何功能更新，捆绑的软件也更少。

对应的注册表为：

```ini
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate]
"DeferFeatureUpdates"=dword:00000001
"BranchReadinessLevel"=dword:00000010
"DeferFeatureUpdatesPeriodInDays"=dword:0000016d
"PauseFeatureUpdatesStartTime"=""
```

## 禁用 1903 版的毛玻璃效果

参考：[Turn Off The Blur Effect On Sign In Screen Background Picture In Windows 10](https://www.intowindows.com/turn-off-the-blur-effect-on-sign-in-screen-background-picture-in-windows-10/)

```ini
Windows Registry Editor Version 5.00
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System]
"DisableAcrylicBackgroundOnLogon"=dword:00000001
```

## 将程序注册为服务

可以使用 [winsw](https://github.com/kohsuke/winsw) 、[nssm](http://nssm.cc/download)

nssm 的使用可以参考：<https://docs.syncthing.net/users/autostart.html#run-as-a-service-independent-of-user>

winsw 免费开源，所以使用 winsw。以 syncthing 为例，将 syncthing 注册为系统服务。

1. 从官方网站 [winsw](https://github.com/kohsuke/winsw)  下载最新版的 2 个文件，并修改为文件名相同，并放入与 syncthing.exe 相同目录下。

    >WinSW.NET4.exe --> syncthing-winsw.exe  服务主文件
    >
    >sample-allOptions.xml --> syncthing-winsw.xml 配置文件

2. 修改 syncthing-winsw.xml 的内容

下载的模板里面有详细的解释，简直是太详细了，汗...

官方文档写的更简单明了：<https://github.com/kohsuke/winsw/blob/master/doc/xmlConfigFile.md>

```xml
<configuration>
    <id>syncthing-winsw</id>
    <name>syncthing-winsw Service</name>
    <description>syncthing 文件同步工具</description>
    <executable>%BASE%\syncthing.exe</executable>
    <onfailure action="restart" delay="20 sec"/>
    <arguments>-gui-address="0.0.0.0:8384" -home="%BASE%\config" -no-console -no-browser</arguments>
    <startmode>Automatic</startmode>
    <delayedAutoStart/>
    <serviceaccount>
        <domain>NT AUTHORITY</domain>
        <user>LOCAL SERVICE</user>
        <allowservicelogon>true</allowservicelogon>
    </serviceaccount>
</configuration>
```

注意：如果不配置 `<serviceaccount>` 部分，syncthing 会提示不应该用系统管理员身份运行，建议以普通用户身份运行。

> Syncthing should not run as a privileged or system user. Please consider using a normal user account.

参考了：<https://www.cnblogs.com/ruijian/archive/2011/08/19/2145302.html>

使用 windows 内置的 `NT AUTHORITY\LocalService` 以普通的用户身份启动，就可以消除这个提示，也更安全。

注册服务，启动服务

```bash
# 管理员权限运行以下命令
:: 注册服务
aria2-winsw.exe install
:: 启动服务
aria2-winsw.exe start

::停止服务
aria2-winsw.exe stop
:: 卸载服务
aria2-winsw.exe uninstall
```

## 创建自解压程序

Aria2 – 超・懒人包参考：<https://meta.appinn.com/t/aria2-2018-11-19/7434>

下载最新的 7zip 的 SDK：<https://www.7-zip.org/sdk.html>

复制 7zSD.sfx 至 7zip 目录

参考：<https://www.bbsmax.com/A/RnJW28eyzq/>

<https://www.cnblogs.com/Tty725/p/6076297.html>

## Windows 开启 SSH 服务

Windows 10 终于支持 SSH Sever 了。开启方法：设置 - 应用 - 应用和功能 - 管理可选功能 - 添加功能，找到“OpenSSH 服务器”，添加即可。

> 经测试，没啥实用价值，还是老老实实用 Putty 或是 GitBash 吧。

添加后的服务，默认是手动开启，需要设置为自动开启。**管理员权限** PowerShell 下运行以下命令：

```bash
# To make sure that the OpenSSH features are available for install:
Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

管理员权限运行 命令提示符：

```bash
rem sc config sshd start=disabled
sc config sshd start=delayed-auto
net start sshd

# ------------------------------------------------------------------

sc config ssh-agent start=delayed-auto
net start ssh-agent

net stop sshd
net stop ssh-agent
net start sshd
net start ssh-agent

# 启动成功后，配置免密登录
# generate security keys for the sshd server
ssh-keygen -A

cd C:\Windows\System32\OpenSSH

cd C:\ProgramData\ssh
ssh-add ssh_host_rsa_key
cd %USERPROFILE%\.SSH
ssh-add id_rsa.pub

ssh user@192.168.8.8

sshpass -p 123456 rsync -avz --delete -e ssh user@192.168.8.8:C:\%USERPROFILE%\.SSH ~/rsync
```

## Mp3tag 便携化方法

Just download the normal installer below and choose **Portable** during installation. You can install to an USB stick or somewhere else – it won't leave any traces on your system.

## windows10 Trim

检查是否开启了 TRIM

```bash
fsutil behavior QUERY DisableDeleteNotify
```

输出以下信息：

> NTFS DisableDeleteNotify = 0  (已禁用)
>
> ReFS DisableDeleteNotify = 0  (已禁用)

如果查询结果是“DisableDeleteNotify = 0”，代表 SSD 已经支持并启用 Trim 指令

如果提示为“DisableDeleteNotify = 1”，代表 SSD 还没启用 Trim 指令。

## Git Bash 中添加 rsync

参考：<https://blog.tiger-workshop.com/add-rsync-to-git-bash-for-windows/>

下载 rsync 的执行文件：<https://mirrors.ustc.edu.cn/msys2/msys/x86_64/>

## 管理控制台

参考：<https://forsenergy.com/zh-cn/mmc/>
