# PowerShell 笔记

**PowerShell** 是一个微软开发的自动化任务和配置管理系统。它基于 .NET 框架，由命令行语言解释器（shell）和脚本语言组成。

简介：

- 开源，Windows 原生支持。
- PowerShell 提供对`.NET` 、COM (组件对象模型 Component Object Model) 和 WMI (Windows 管理规范 Windows Management Instrumentation) 的完全访问。
- 社区活跃，微软还在不停地开发 PowerShell，不断更新、扩展新功能。
- Windows 10 2021 LTSC 自带的 PowerShell 版本为 `5.1` ，安装新版的 PowerShell 后，自带的 PowerShell 并不会被删除。新版的 PowerShell 命令是 `pwsh`。

## 快速开始

参考：<https://learn.microsoft.com/zh-cn/powershell/scripting/dev-cross-plat/vscode/understanding-file-encoding?view=powershell-7.3#configuring-powershell>

- windows10、Windows11 中的内置了 PowerShell 5.1 版本，此版本：`ps1` 文件需要用 `UTF8 with BOM` 编码、终端输入输出使用 `cp936` 编码，输出文件有 `UTF8 with BOM`、`UTF-16 LE with BOM` 等各种五花八门的编码。运行出错也不提示是编码错误，超级容易踩坑。
- PowerShell 6+ 版本中，默认全部采用不带有 BOM 的 `UTF-8` 编码。
- PowerShell 后缀名，脚本使用 `ps1` ，模块使用 `psm1` 。
- PowerShell7 的命令是 `pwsh`
- PowerShell 既可以作为脚本执行，也可以作为模块导入，支持函数、对象等。

```powershell
# 改变终端输入编码
chcp 65001 | out-null
```

## 编码

参考：官方文档： [Character encoding in Windows PowerShell](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_character_encoding)

Powershell 的编码情况太扯了，必须专门说明一下。

查看 Windows 10 LTSC 2021 系统下 Powershell 的系统级默认编码情况（非当前会话、自定义设置）：

```powershell
[psobject].Assembly.GetTypes() | Where-Object { $_.Name -eq 'ClrFacade'} |
  ForEach-Object {
    $_.GetMethod('GetDefaultEncoding', [System.Reflection.BindingFlags]'nonpublic,static').Invoke($null, @())
  }

# PowerShell 5.1 下的编码情况
BodyName          : gb2312
EncodingName      : 简体中文(GB2312)
HeaderName        : gb2312
WebName           : gb2312
WindowsCodePage   : 936
IsBrowserDisplay  : True
IsBrowserSave     : True
IsMailNewsDisplay : True
IsMailNewsSave    : True
IsSingleByte      : False
EncoderFallback   : System.Text.InternalEncoderBestFitFallback
DecoderFallback   : System.Text.InternalDecoderBestFitFallback
IsReadOnly        : True
CodePage          : 936

# PowerShell 7.3 下的编码情况
Preamble          :
BodyName          : utf-8
EncodingName      : Unicode (UTF-8)
HeaderName        : utf-8
WebName           : utf-8
WindowsCodePage   : 1200
IsBrowserDisplay  : True
IsBrowserSave     : True
IsMailNewsDisplay : True
IsMailNewsSave    : True
IsSingleByte      : False
EncoderFallback   : System.Text.EncoderReplacementFallback
DecoderFallback   : System.Text.DecoderReplacementFallback
IsReadOnly        : True
CodePage          : 65001
```

### 1）脚本文件编码

脚本文件中如果包含有中文字符（包括注释），Powershell 5.1 版只有采用 `UTF8 with BOM` 编码，才能正确运行。如果设置为其它编码，有时不报错，有时报错，即使不报错，也不能准确运行。安全起见必须设为 `UTF8 with BOM` 编码。

Powershell 6 以后，默认采用 `UTF8 NoBOM` 编码。

参考官方建议，为保证最大兼容性，建议 PowerShell 文件采用 `UTF8 with BOM` 编码。

### 2）文件输出编码

a）Windows 系统下大部分都是 CP936 编码，但是使用 `Out-File`、`Export-Csv` 行为不一样

|     命令     |      默认编码      |                             备注                             |
| :----------: | :----------------: | :----------------------------------------------------------: |
|  `Out-File`  | UTF-16 LE with BOM | 设置为 utf8 参数，输出仍是带 BOM 的 UTF8 文件，无不带 BOM 输出的选项。 |
| `Export-Csv` |    UTF-8 NoBOM     |                                                              |

测试：

```powershell
# 测试 Out-File 命令
 Write-Output "测试" | Out-File -FilePath ".\Out-File.txt"

# 测试 Export-Csv 命令，Powershell 5.1执行下面命令不能正确显示。
$person1 = @{
    Name = '张三'
    Number = 1
}

$person2 = @{
    Name = '李四'
    Number = 1
}

$allPeople = $person1, $person2
$allPeople | Export-Csv -Path .\People.csv
```

b）、Powershell 6 以后，默认采用 `UTF8` 编码，所有输出默认采用 `UTF8 NoBOM` 编码。

参考官方说明，为保证输出文件编码一致，建议在左右 PowerShell 文件前面添加以下内容。

Use the following statement to change the default encoding for all cmdlets that have the **Encoding** parameter.

```powershell
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
```

### 3）终端输出编码

参考：<https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_profiles>

修改当前用户、当前主机终端输出为 UTF8 编码。

```powershell
if (!(Test-Path -Path $PROFILE)) {
  New-Item -ItemType File -Path $PROFILE -Force
}
```

添加以下内容：

```powershell
# $HOME\Documents\PowerShell\Microsoft.VSCode_profile.ps1
[System.Console]::InputEncoding = [System.Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
```

备注：

>`[System.Console]::InputEncoding`  影响终端输入，`chcp` 命令会变成 65001
>
>`[System.Console]::OutputEncoding` 影响终端输出，终端输出如果是 GBK，pycharm 会乱码、pytest 会报错。
>
>最主要的是修改终端输出编码。

## 运行脚本文件

两种方式可以运行脚本文件。

### 1）向脚本传递参数

让脚本文件接受外部参数，示例参考：<https://dotnet-helpers.com/powershell/creating-a-balloon-tip-notification-using-powershell/>

```powershell
# balloontip.ps1
# 准备接受的外部参数，必须放在函数前面
param($Text, $Title = 'Information', $Icon = 'Info', $ExpirationMinutes = 0)
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

function ShowBalloonTipInfo
{
    [CmdletBinding()]
    param
    (
    # Mandatory=$true 参数表示必选参数
        [Parameter(Mandatory, Position = 0)] [string] $Text,
        [Parameter(Position = 1)] [string] $Title = 'title',
    # It must be 'None','Info','Warning','Error'
        [Parameter(Position = 2)] [string] $Icon = 'Info',
    # 这个参数没有使用
        [Parameter(Position = 3)] [int] $ExpirationMinutes = 0
    )
    Add-Type -AssemblyName System.Windows.Forms
    $balloonToolTip = New-Object System.Windows.Forms.NotifyIcon
    $balloonToolTip.Icon = [System.Drawing.SystemIcons]::Information
    $balloonToolTip.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::$Icon
    $balloonToolTip.BalloonTipText = $Text
    $balloonToolTip.BalloonTipTitle = $Title
    $balloonToolTip.Visible = $true
    $balloonToolTip.ShowBalloonTip(1000*20)  # 默认单位是毫秒
    #    Start-Sleep -Seconds 1
    #    $balloonToolTip.Dispose()
}
# 调用函数，接收传递进来的参数
ShowBalloonTipInfo $Text $Title  $Icon $ExpirationMinutes
```

外部程序（批处理、python）调用时，运行脚本时后面添加参数即可。

```powershell
# 普通的Windows系统（非服务器、LTSC版）默认无法运行PS脚本文件，所以需要添加 -ExecutionPolicy RemoteSigned 参数。
powershell -ExecutionPolicy RemoteSigned -File balloontip.ps1 "通知内容" "通知标题" "Info"

# 确保可以执行 PS 脚本，可以省掉 -ExecutionPolicy RemoteSigned 参数。
powershell -File balloontip.ps1 "通知内容" "通知标题" "Info"

# 或是在 powershell 中使用 Invoke-Expression 命令（也可以使用 iex 简写）
Invoke-Expression -Command "C:\ps-test\testscript.ps1" "通知内容" "通知标题" "Info"
```

### 2）作为模块加载

```sh
# toast.ps1
#param($Message, $Title = 'Information', $Icon = 'Info')
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
Function New-DotNetToast
{
    [cmdletBinding()]
    Param(
        [Parameter(Mandatory, Position = 0)]
        [String] $Message,
        [Parameter(Position = 1)]
        [String] $Title = 'Information',
        [Parameter(Position = 2)]
        [String] $Icon = 'Info',  # 可选参数：Info,Warning,Error
        [Parameter(Position = 3)]
        [Int] $ExpirationMinutes = 0
    )

    $IconPath = "$PSScriptRoot\images\$Icon.ico"
    $XmlString = @"
  <toast>
    <visual>
      <binding template="ToastGeneric">
        <text>$Title</text>
        <text>$Message</text>
        <image src="$IconPath" placement="appLogoOverride" hint-crop="circle" />
      </binding>
    </visual>
    <audio src="ms-winsoundevent:Notification.Default" />
  </toast>
"@
    #    $AppId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
    $AppId = (Get-StartApps | Where-Object Name -eq "Windows PowerShell").AppID
    $null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
    $null = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]

    $ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::new()
    $ToastXml.LoadXml($XmlString)

    $Toast = [Windows.UI.Notifications.ToastNotification]::new($ToastXml)

    # 默认通知在通知中心保留 3 天
    Write-Debug "ExpirationMinutes --> $ExpirationMinutes"
    if ($ExpirationMinutes -gt 0)
    {
        $ExpirationTime = [System.DateTime]::Now.AddMinutes($ExpirationMinutes)
        Write-Debug "ExpirationTime --> $ExpirationTime"
        $Toast.ExpirationTime = $ExpirationTime
    }
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($Toast)
}

#New-DotNetToast $Message $Title $Icon
```

调用时先加载此模块，再使用 `New-DotNetToast` 函数：

```powershell
# 使用 Dot-Sourcing 方法
. .\toast.ps1 ; New-DotNetToast "通知内容" "通知标题" "Info" 1
# 把后缀名改为 psm1，作为模块导入
Import-Module .\toast.ps1 ; New-DotNetToast "通知内容" "通知标题" "Info" 1
```

在命令提示符下运行：

```cmd
powershell . .\toast.ps1 ; New-DotNetToast "通知内容" "通知标题" "Info" 1
```

> 注意：在批处理、python、计划任务等其他程序中调用，前面需要添加 `powershell` 命令。

## 脚本模块

参考：<https://learn.microsoft.com/zh-cn/powershell/scripting/learn/ps101/10-script-modules>

<https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_psmodulepath>

Powershell 自动在 `$env:PSModulePath` 变量里的目录内查找模块。

```powershell
$env:PSModulePath -split ';'
[out]:
C:\Users\kevin\Documents\WindowsPowerShell\Modules
C:\Program Files\WindowsPowerShell\Modules
C:\windows\system32\WindowsPowerShell\v1.0\Modules
```

一般个人用户将个人的模块放入 `%USERPROFILE%\Documents\WindowsPowerShell\Modules` 目录下即可。

模块需要以目录形式存在，脚本以 `.psm1` 作为后缀名，比如：

```ini
├─Modules
   └─toast
           toast.psm1
```

直接使用 `Import-Module` 命令，就可以查找到 `toast` 模块了。

```powershell
Import-Module toast ; New-DotNetToast "通知内容" "通知标题" "Info" 1
```

## 操作

### 类

Powershell 大部分命令返回的其实是一个类实例。

```powershell
# 查看类的方法与属性
Get-Date | Get-Member
# 查看所有可用命令
Get-Command
# 查看进程
Get-Process
# 查看本机信息
Get-ComputerInfo


$now = Get-Date
# 调用方法
$now.adddays(1)
# 调用属性
$now.year

# 不赋予变量调用
(& "Get-Date").year

# 访问 .NET 对象
[System.DateTime]::Now.year
```

### 调试选项

脚本中包含有 `Write-Debug` 的语句，执行命令时通过 `-Debug` 参数显示出来。

```powershell
powershell . .\toast.ps1 ; New-DotNetToast -Debug "内容" "标题" "Info" 1
```

### 管理脚本文件执行策略

参考：Powershell 文档 [执行策略](https://learn.microsoft.com/zh-cn/powershell/scripting/learn/ps101/01-getting-started?view=powershell-7.3#execution-policy)

```powershell
# 获取当前 powershell 版本
>>> $PSVersionTable
Name                           Value
----                           -----
PSVersion                      5.1.19041.1682
PSEdition                      Desktop
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}
BuildVersion                   10.0.19041.1682
CLRVersion                     4.0.30319.42000
WSManStackVersion              3.0
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1

# Windows Server、LTSC 版系统默认设置为：RemoteSigned 远程签名
# 普通 Windows10、Windows11 默认设置为：Restricted 受限
# 当执行策略设置为“受限”时，PowerShell 脚本根本无法运行。
# 获取当前用户的脚本执行策略
>>> Get-ExecutionPolicy
RemoteSigned
# 查看所有作用域的执行策略
>>> Get-ExecutionPolicy -list

        Scope ExecutionPolicy
        ----- ---------------
MachinePolicy       Undefined
   UserPolicy       Undefined
      Process       Undefined
  CurrentUser    RemoteSigned
 LocalMachine       Undefined

# 修改当前用户执行策略。CurrentUser 范围仅影响设置此作用域的用户。
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
# -Scope 共有4个可选参数：
# MachinePolicy。 为计算机的所有用户设置组策略。
# UserPolicy。 为计算机的当前用户设置组策略。
# Process 。 仅影响当前的 PowerShell 会话。
# CurrentUser。 仅影响当前用户。
# LocalMachine。 影响计算机所有用户的默认范围。

# 修改执行策略，需要以管理员权限运行
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Set-ExecutionPolicy -ExecutionPolicy Restricted
```

Set-ExecutionPolicy，有以下几个选项：

```powershell
Set-ExecutionPolicy [-ExecutionPolicy] {Unrestricted | RemoteSigned | AllSigned | Restricted | Default | Bypass | Undefined} [[-Scope] {Process | CurrentUser | LocalMachine | UserPolicy | MachinePolicy}]  [<CommonParameters>]
```

ExecutionPolicy 可选参数：

>Bypass. Nothing is blocked and there are no warnings or prompts.
>
>Restricted: 不载入配置文件，不执行脚本。"Restricted"是默认值。
>
>AllSigned: 所有的配置文件和脚本必须通过信任的出版商签名 (trusted publisher), 这里所指的脚本页包括你在本地计算机上创建的脚本。
>
>RemoteSigned: 所有从互联网上下载的脚本必须通过信任的出版商签名 (trusted publisher).
>
>Unrestricted: 载入所有的配置文件和脚本。如果你运行了一个从互联网上下载且没有数字签名的脚本，在执行前你都会被提示是否执行。
>
>Default：Restricted

Scope 的可选参数：

>MachinePolicy. Set by a Group Policy for all users of the computer.
>
>UserPolicy. Set by a Group Policy for the current user of the computer.
>
>Process. Affects only the current PowerShell session.仅影响当前 Powershell 会话。
>
>CurrentUser. Affects only the current user.仅影响当前用户。
>
>LocalMachine. Default scope that affects all users of the computer.影响本机所有用户，默认值。执行此参数需要管理员权限。

`-Force` 参数：Suppresses all the confirmation prompts. Use caution with this parameter to avoid unexpected results.

### 脚本中提升为管理员权限

参考：

```powershell
param([switch]$Elevated)
function Test-Admin {
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
if ((Test-Admin) -eq $false)  {
    if ($elevated)
    {
        # tried to elevate, did not work, aborting
    }
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
}
exit
}
# 第一个 if 语句检查执行的脚本是否已经在具有管理权限的 Windows PowerShell 中运行。
# 第二个 if 语句检查 Windows 操作系统内部版本号是否为 6000 或更高。 （Windows Vista 或 Windows Server 2008 或更高版本）
# $Command 变量检索并保存用于运行脚本的命令，包括参数。
# Start-Process 使用提升的权限启动一个新的 Windows PowerShell 实例，并像我们之前的脚本一样重新运行该脚本。
# 下面为需要以管理员权限运行的代码
# ---------------------------------------
Write-Output 'Hello World!'
cmd /c pause
```

### 安装最新版的 PowerShell 7.3

```sh
# 使用 scoop 安装最新版的 PowerShell
scoop install pwsh
```

添加文件关联、在此处打开 PowerShell7 窗口。

```ini
Windows Registry Editor Version 5.00

;------------------------------------------------------------
;右键用 PowerShell7 运行
[-HKEY_LOCAL_MACHINE\SOFTWARE\Classes\SystemFileAssociations\.ps1]

[HKEY_CLASSES_ROOT\Microsoft.PowerShellScript.1\Shell\pwsh]
@="用 Powershell7 运行"
"ICon"="C:\\Users\\kevin\\scoop\\apps\\pwsh\\current\\pwsh.exe"

[HKEY_CLASSES_ROOT\Microsoft.PowerShellScript.1\Shell\pwsh\command]
@="\"C:\\Users\\kevin\\scoop\\apps\\pwsh\\current\\pwsh.exe\" \"%1\""
;------------------------------------------------------------


;------------------------------------------------------------
;在此处打开 PowerShell7 窗口
[HKEY_CLASSES_ROOT\Directory\background\shell\pwsh]
@="在此处打开 PowerShell7 窗口"
"Icon"="C:\\Users\\kevin\\scoop\\apps\\pwsh\\current\\pwsh.exe"
"Extended"=""
"NoWorkingDirectory"=""
"ShowBasedOnVelocityId"=dword:00639bc8

[HKEY_CLASSES_ROOT\Directory\background\shell\pwsh\command]
@="C:\\Users\\kevin\\scoop\\apps\\pwsh\\current\\pwsh.exe -NoExit -RemoveWorkingDirectoryTrailingCharacter -WorkingDirectory \"%V!\" -Command \"$host.UI.RawUI.WindowTitle = 'PowerShell Core (x64)'\""
;------------------------------------------------------------
```

注：

> 无法修改、删除系统自带的 `打开 PowerShell 窗口` 菜单

### 气泡提示

[Creating a Balloon Tip Notification Using PowerShell](https://dotnet-helpers.com/powershell/creating-a-balloon-tip-notification-using-powershell)

[4 Types of Notifications Generated in PowerShell](https://www.kjctech.net/4-types-of-notifications-generated-in-powershell/)

### Toast 消息通知

<https://github.com/Rudesind/PowerShell-Toast/blob/master/toast.psm1>

<https://github.com/steviecoaster/RTPSUG7Nov>
