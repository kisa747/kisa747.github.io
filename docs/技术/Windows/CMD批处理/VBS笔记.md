# VBS 笔记

* VBS 需使用 `GBK` 编码，支持 `LF` 、 `CR+LF` 两种格式的换行符。

## 基本语法

变量

* 在 VBScript 中对变量、方法、函数和对象的引用是不区分大小写的。
* 在申明变量时，要显式地申明一个变量，需要使用关键字 DIm 来告诉 VBScript 你要创建一个变量，并将变量名称跟在其后。申明多个同类型变量，可以用逗号分隔。注意：VBScript 中不允许在申明变量的时候同时给变量赋值。但是允许在一行代码内同时对两个变量进行赋值，中间用冒号分隔。

操作符

|       操作符       |     含义     |
| :----------------: | :----------: |
| `+`、`-`、`*`、`/` |   加减乘除   |
|         ==         |     等于     |
|         <>         |    不等于    |
|         >          |     大于     |
|         <          |     小于     |
|         ^          |     乘方     |
|        Mod         |     取模     |
|         &          | 字符串连接符 |

### 循环语句

`if then`语句

```vb
If Num = 0 Then
    Set fa = 0
ElseIf Num = 1 Then
    Set fa = 1
Else: Num = 2
    Set fa = 2
End If
```

## 常用命令

### 获取当前文件所在目录

```vb
set ws=WScript.CreateObject("WScript.Shell")
' 获取当前VBS文件所在目录的路径
current_file_folder=createobject("Scripting.FileSystemObject").GetFile(Wscript.ScriptFullName).ParentFolder.Path
cmd_file=current_file_folder & "\" & "switch_dark_mode.cmd"
' 参数 0 表示隐藏窗口
ws.Run cmd_file, 0
```
