## VBA 对话框操作

用法：

```vb
MsgBox(prompt[, buttons] [, title] [, helpfile, context])
'prompt:必需的。字符串表达式，作为显示在对话框中的消息。
'Buttons 可选的。数值表达式是值的总和，指定显示按钮的数目及形式，使用的图标样式，缺省按钮是什么以及消息框的强制回应等。
'Title 可选的。在对话框标题栏中显示的字符串表达式。
'Helpfile 可选的。字符串表达式，识别用来向对话框提供上下文相关帮助的帮助文件。
'Context 可选的。数值表达式，由帮助文件的作者指定给适当的帮助主题的帮助上下文编号。
```

示例

```vb
Sub test2()
MsgBox "欢迎光临我要自学网!" & Chr(13) & "今天是:" & Format(Now, "yyyy-m-d aaaa") _
, , ThisWorkbook.FullName
End Sub
Sub test3()
i = MsgBox("欢迎光临我要自学网!" & Chr(13) & "今天是:" & Format(Now, "yyyy-m-d aaaa") _
, , ThisWorkbook.FullName)
End Sub
Sub test4()
MsgBox "正则表达式学习", vbMsgBoxHelpButton, "欢迎光临我要自学网", ThisWorkbook.Path & "\帮助\正则表达式系统教程.CHM", 0
End Sub
```

## inputbox 函数与方法

```vb
'1.区别一：外观区别
'InputBox 函数
'在一对话框来中显示提示，等待用户输入正文或按下按钮，并返回包含文本框内容的 String。

'Application.InputBox 方法
'显示一个接收用户输入的对话框。返回此对话框中输入的信息。
'------------------------------------------------------------------------------------------

Sub test1()
sr = InputBox("请输入内容！") '函数
sr = Application.InputBox("请输入内容！") '方法
End Sub

'------------------------------------------------------------------------------------------

'2.参数区别
'inputbox函数与方法的主要区别:

'InputBox(prompt[, title] [, default] [, xpos] [, ypos] [, helpfile, context]) 函数

'表达式.InputBox(Prompt, Title, Default, Left, Top, HelpFile, HelpContextID, Type) 方法
'主要区别：方法比函数多了一个参数(type-指定返回的数据类型。如果省略该参数，对话框将返回文本。).


'3.按扭返回值区别

Sub test2()
hs = InputBox("请输入内容！") '函数
ff = Application.InputBox("请输入内容！") '方法
End Sub
'小结：函数取消/关闭 按钮返回值"",而方法是false
```
