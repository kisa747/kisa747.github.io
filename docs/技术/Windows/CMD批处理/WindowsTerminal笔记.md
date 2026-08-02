# Windows Terminal 笔记

Windows Terminal 底层使用的还是 命令提示符 和 Powershell，所以他俩没有的功能，Windows Terminal 同样也不会有。

## 安装

```sh
scoop install windows-terminal
# 'windows-terminal' suggests installing 'extras/vcredist2022'.
```

常用参数

```sh
# 查看版本
wt -v
# 查看帮助
wt -h
```

## 使用

Windows Terminal 只是一个终端外壳程序，底层可以选择 命令提示符 或 Powershell，日常需要命令行操作，基本可以替代 命令提示符 或 Powershell，具备历史记录、自定义主题等现代 Terminal 应具备的功能。

优点：

* 操作历史记录
* 方便的复制粘贴操作
* 同时支持命令提示符和 Powershell
* 界面现代、美观，支持主题
* 字体显示效果好

## 添加右键菜单

命令提示符 和 Powershell 的右键菜单可以不用了，只用一个 Windows Terminal 就行了。

```ini
Windows Registry Editor Version 5.00
;注册表
[HKEY_CURRENT_USER\SOFTWARE\Classes\Directory\Background\shell\wt]
@="Windows Terminal"
"Icon"="C:\\Users\\kevin\\scoop\\apps\\windows-terminal\\current\\wt.exe"

[HKEY_CURRENT_USER\SOFTWARE\Classes\Directory\Background\shell\wt\command]
@="\"C:\\Users\\kevin\\scoop\\apps\\windows-terminal\\current\\wt.exe\" -d ."
```
