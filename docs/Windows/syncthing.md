# Syncthing 笔记

1. syncthing 应该一直作为服务运行，如果停止运行期间新增了文件，而这个目录又一直没有修改增删文件，那么这个变动将一直不会被监视掉，即使重新扫描也不行。
2. 如果要彻底完全地重新扫描一遍，我现在感觉唯一的办法就是：删除 `index-v0.14.0.db` 。

## 忽略文件语法

匹配规则仅仅是如何匹配，若要匹配文件夹/目录/子目录时，忽略模式中最后不能写/，写了/的表示匹配目录下的子目录/文件。请注意，以斜杠结尾的目录模式 some/directory/与目录内容匹配，但与目录本身不匹配。如果希望模式与目录及其内容匹配，请确保模式末尾没有/。

`.stignore` 文件可包含一系列路径匹配模式，对指定文件的处理方式由第一个匹配到它的模式决定

- 一般的文件名匹配它自己，例如，模式 `foo` 匹配：

  - 文件 `foo`
  - 文件`subdir/foo`
  - 任何名字是 `foo` 的文件夹

    空格会被认为是正常字符，除了前缀和后缀的空格会自动被修剪掉。

- 星号（`*`）匹配 0 个或多个字符，但是不匹配路径分割符。例如 `te*me` 匹配：

  - `telephone`
  - `subdir/telephone`

    但是不匹配 `tele/phone`

- 双星号（`**`）匹配 0 或多个字符，包括路径分割符，例如 `te*me` 匹配：

  - `telephone`
  - `subdir/telephone`
  - `tele/sub/dir/phone`

- 问号（`?`）匹配单个字符，不匹配路径分割符，例如 `te??st` 匹配：

  - `tebest`

    不匹配：

  - `teb/st`
  - `test`

- 方括号（`[]`）指定符号范围，如 `[a-z]` 匹配：任何小写字符

- 大括号（`{}`）表示一组替代词，如 `{banana,pineapple}` 匹配：`banana` 或 `pineapple`

- 反斜杠（`\`）转义字符。例如 `\{banana\}` 会严格匹配 `{banana}` ，而不会识别成替代词。**转义字符在 Windows 上不支持！**

- 以 `/` 开头的模式：只在根目录下进行匹配。例如 `/foo` 匹配 `foo` 但不匹配 `subdir/foo`

- 开头带有 `#include` 的模式会从指定名字的文件中载入模式。如果这个文件不存在，或者被包括了多次，就会出错。注意，虽然这样可以从子文件夹中的一个文件载入模式，但模式自身仍然是以根目录为参照点的。例子：`#include more-patterns.txt`

- 以 `!` 前缀的模式会否定这个模式：匹配的文件会被 **包括**（也就是，不要忽略）。这一项可以覆盖后续的忽略模式。

- 以 `(?i)` 前缀的模式会启用大小写不敏感。如 `(?!)test` 匹配：

  - `test`
  - `TEST`
  - `sEsT`

    `(?!)` 可以与其它模式结合，例如：`(?!)!picture*.png` 会指定 `Picture1.PNG` 不被忽略。在 Mac OS 和 Windows 上，模式永远是大小写不敏感的。

- 以 `(?d)` 前缀的模式，如果这些文件在阻止目录的删除，就会删除这些文件。这个前缀应该被任何 OS 生成的你乐意移除的文件使用。

- 以 `//` 起始的行为注释。

> **注意：**
>
> 前缀的顺序可以是任意的，例如 `(?d)(?i)` ，但是不能在同一个括号中，不要使用 `(?di)`
>
> **注意：**
>
> 顶级的包含模式被特殊对待，并且不会强制 Syncthing 不顾其它忽略模式地扫描整个目录树。例如：`!/foo` 是一个顶级包含模式，`!/foo/bar` 不是。

## 将程序注册为服务

winsw 免费开源，推荐使用 winsw。以 syncthing 为例，将 syncthing 注册为系统服务。

参考：<https://docs.syncthing.net/users/autostart.html#run-as-a-service-independent-of-user>

1. 从官方网站 [winsw](https://github.com/kohsuke/winsw)  下载最新版的 2 个文件，并修改为文件名相同，并放入与 syncthing.exe 相同目录下。

>WinSW.NET4.exe               改名为-->           syncthing-winsw.exe        # 服务主文件
>
>sample-allOptions.xml      改名为-->           syncthing-winsw.xml        # 配置文件

2. 修改 `syncthing-winsw.xml` 的内容

下载的模板里面有详细的解释，简直是太详细了，汗...

官方文档写的更简单明了：<https://github.com/kohsuke/winsw/blob/master/doc/xmlConfigFile.md>

```xml
<!-- syncthing-winsw.xml -->
<service>
    <id>syncthing-winsw</id>
    <name>syncthing-winsw Service</name>
    <description>syncthing 文件同步工具</description>
    <executable>%BASE%\syncthing.exe</executable>
    <onfailure action="restart" delay="20 sec"/>
    <arguments>--home="%BASE%\config" --no-console -no-browser</arguments>
    <!---仅保留这次启动的日志-->
    <log mode="reset"></log>
    <startmode>Automatic</startmode>
    <!---延时启动-->
    <delayedAutoStart>true</delayedAutoStart>
    <!---非管理员身份运行，开机后即使没有登录用户，也自动运行该服务-->
    <serviceaccount>
        <domain>NT AUTHORITY</domain>
        <user>LOCAL SERVICE</user>
        <allowservicelogon>true</allowservicelogon>
    </serviceaccount>
</service>
```

注意：如果不配置 `<serviceaccount>` 部分，syncthing 会提示不应该用系统管理员身份运行，建议以普通用户身份运行。

> Syncthing should not run as a privileged or system user. Please consider using a normal user account.

参考了：<https://www.cnblogs.com/ruijian/archive/2011/08/19/2145302.html>

使用 windows 内置的 `NT AUTHORITY\Local Service` 以普通的用户身份启动，就可以消除这个提示，也更安全。

>本地服务帐户 (LOCAL SERVICE)：
>
>本地服务帐户是一个类似于经过认证的用户帐户的特殊的内置帐户。本地服务帐户具有和 Users 用户组成员相同级别的资源和对象访问权。如果个别的服务或者进程有危害的话，这种有限的访问会有助于保护你的系统。用本地服务帐户运行的服务使用带有匿名证书的空会话访问网络资源。帐户的名字是 NT AUTHORITY\\LocalService。这个帐户没有密码。

同时创建一个管理批处理文件 `管理syncthing服务.cmd` ，内容如下：

```cmd
rem 管理syncthing服务.cmd
@echo off
echo 必须以管理员身份运行该程序
%1 mshta vbscript:Createobject("Shell.Application").ShellExecute("%~s0","::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

cls
:menu
echo. ==============================
echo        1 安装并启动服务
echo        2 停止并卸载服务
echo        3 重启服务
echo        4 停止服务
echo        5 退出
echo. ==============================
echo.
choice /C 12345 /M "请选择："
if %errorlevel%==1 goto install
if %errorlevel%==2 goto uninstall
if %errorlevel%==3 goto restart
if %errorlevel%==4 goto stop
if %errorlevel%==5 exit

:install
rem 注册服务并启动服务
syncthing-winsw.exe install && syncthing-winsw.exe start
rem 将服务设置为延时启动
rem sc config syncthing-winsw start=delayed-auto
rem net start syncthing-winsw
goto menu

:uninstall
rem 停止服务
rem net stop syncthing-winsw
syncthing-winsw.exe stop
rem 卸载服务
syncthing-winsw.exe uninstall
goto menu

:restart
rem 重启服务
syncthing-winsw.exe restart
goto menu

:stop
rem 停止服务
rem net stop syncthing-winsw
syncthing-winsw.exe stop
rem 杀死syncthing进程
rem taskkill /im syncthing.exe /t /f
goto menu
```
