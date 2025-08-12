# AutoHotkey

## 创建脚本

创建一个脚本 `Hotkey.ahk`

```sh
;Hotkey.ahk
#NoTrayIcon  ;不显示托盘图标。

#z::  ;设置 Windows 键和 z 键
IfWinNotExist, D:\home\Link
    Run, explore D:\home\Link
    WinActivate
return
```

测试脚本

```cmd
rem 测试ahk.cmd
@echo off
start D:\App\Tool\AutoHotkey\AutoHotkeyU64.exe Hotkey.ahk
echo.
echo 已经启动了脚本
echo.
echo ----按任意键终止程序----  & @pause>nul

taskkill /f /im AutoHotkeyU64.exe /t
```

编译为一个 exe 执行文件

```cmd
rem 编译.cmd
@echo off
set app_path=D:\App\Tool\AutoHotkey\Compiler
%app_path%\Ahk2Exe.exe /in Hotkey.ahk /bin "%app_path%\Unicode 64-bit.bin"
```
