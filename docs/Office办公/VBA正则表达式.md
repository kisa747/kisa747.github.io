# VBA 正则表达式

## 1 正则表达式基础

```vb
Sub test()
 Dim regx As New RegExp
 sr = "aabcabcbac"
 regx.Global = True 'Global属性：查找范围：true全部查找，false只查找第1个，默认false
 regx.Pattern = "a" 'Pattern属性：书写正则表达式，默认为""
'----------------------------------
Set k = regx.Execute(sr) 'Execute方法：返回匹配成功的结果，是一个对象
For Each m In k
 MsgBox m.Value '将匹配成功能的结果循环出来
Next
'----------------------------------
n = regx.Replace(sr, "-") 'Replace方法：将匹配成功的结果做替换。
 MsgBox n
'----------------------------------
End Sub
```

## 2 正则表达式 (普通字符)

```vb
'正则表达式之普通字符
Sub test()
Set regx = CreateObject("vbscript.regexp")
With regx
    .Global = True
    .Pattern = "消售"
   Set Rng = Range("a2:a" & Cells(Rows.Count, 1).End(xlUp).Row)
   For Each rn In Rng
   n = n + 1
    Cells(n + 1, 1) = .Replace(rn.Value, "销售")
   Next
End With
End Sub
```

## 3 正则表达式（元字符）

```vb
\d 匹配一个数字字符。
\D 匹配一个非数字字符。
\w 匹配包括下划线的任何单词字符。"A-Za-z0-9_" ，（不匹配汉字，不匹配空格）
\W 匹配任何非单词字符。
\s 匹配任何空白字符，包括空格、制表符、换页符等等。
\S 匹配任何非空白字符。
\b 匹配一个单词边界，也就是指单词和空格间的位置。
\B 匹配非单词边界。
\n 匹配一个换行符。
\r 匹配一个回车符。
\t 匹配一个制表符。
. 匹配除 "\n" 之外的任何单个字符。要匹配包括 '\n' 在内的任何字符
```

\b 实例：张三 张三丰 李四 李四光 张无忌 陈六 张三 张三 丰 张三杰 丰张三 张三

## 4 元字符之量词

```vb
?     匹配前面的子表达式零次或一次。
+    匹配前面的子表达式一次或多次。
*     匹配前面的子表达式零次或多次。
{n}      n 是一个非负整数。匹配确定的 n 次。
{n,}     n 是一个非负整数。至少匹配n 次。
{n,m}   m 和 n 均为非负整数，其中n <= m。
```

## 5 元字符之量词实例

```vb
Sub 提取内容()
Set regx = CreateObject("vbscript.regexp")
With regx
    .Global = True
    .Pattern = "\S+"  '任何非空白字符，重复一次到多次。
    For Each Rng In [b1:b4]
        Set mat = .Execute(Rng)
        For Each m In mat
            y = y + 1
            Cells(Rng.Row, y + 2) = m
        Next
            y = 0
    Next
End With
End Sub
'--------------------------
Sub 规范符号()
Set regx = CreateObject("vbscript.regexp")
With regx
    .Global = True
    .Pattern = "-{2,}" '-至少匹配2次
    For Each Rng In [a1:a6]
        n = n + 1
        Cells(n, "b") = .Replace(Rng, "--")
    Next
End With
End Sub
```

## 6 分组

```vb
'   (pattern)： 匹配 pattern 并获取这一匹配。
'   x|y ：匹配 x 或 y。（可选元素）
*********************
Sub 去除多余的词()
Set regx = CreateObject("vbscript.regexp")
With regx
    .Global = True
    .ignorecase = True '大小写区分设置，true不区分大小写，默认为false区分大小写。
    .Pattern = "(VBA){2,}"
    [b1] = .Replace([a1], "VBA")
End With
End Sub
' *********************
Sub test2()
Set regx = CreateObject("vbscript.regexp")
With regx
    .Global = True
    .ignorecase = True
    .Pattern = "经理|总裁|董事长"
    For Each Rng In [a2:a9]
        n = n + 1
        Cells(n + 1, "b") = .Replace(Rng, "高管")
    Next
End With
End Sub
' *********************
Sub test3()
Set regx = CreateObject("vbscript.regexp")
With regx
    .Global = True
    .Pattern = "(张|李).*(平|明)"
    For Each Rng In [a1:a9]
        Set mat = .Execute(Rng)
        For Each m In mat
                n = n + 1
                Cells(n, "b") = m
        Next
    Next
End With
End Sub
```

## 7 字符组（拆分单词）

```vb
'[]在中括号中选若干字符之一
'[xyz] 字符集合。匹配所包含的任意一个字符。
'[^xyz] 负值字符集合。匹配未包含的任意字符。
'[a-z] 字符范围。匹配指定范围内的任意字符。
'[^a-z] 负值字符范围。匹配任何不在指定范围内的任意字符。
```

举例：  [a-zA-Z]  匹配 a~z，A~Z 的字母。

## 8 首尾锚定

```vb
'^ 匹配输入字符串的开始位置。放在[]里标识不匹配。
'$ 匹配输入字符串的结束位置。
Sub test()
Set regx = CreateObject("vbscript.regexp")
With regx
    .Global = True
    .Pattern = "^[A-Z]+\d+$"
    For Each Rng In [a1:a17]
        Set mat = .Execute(Rng)
        For Each m In mat
        n = n + 1
        Cells(n, 2) = m
        Next
    Next
End With
End Sub
```

## 9 循环多个正则表达式

```vb
Sub 单词注释拆分() '执行多个正则表达式
Set regx = CreateObject("vbscript.regexp")
With regx
    .Global = True
    For Each ar In Array("[^a-z ]+", "[a-z ]+") '将多个正则表达式写在一个数组中
        n = n + 1
        .Pattern = ar '循环正则表达式
        For Each Rng In [a2:a251]
            Cells(Rng.Row, n + 1) = .Replace(Rng, "")
        Next
    Next
End With
End Sub
```

```vb
'\un 匹配 n，其中 n 是以四位十六进制数表示的 Unicode 字符。
'汉字一的编码是\u4e00,最后一个代码是\u9fa5
'一-龢
```

## 10 后向引用与非捕获

```vb
'1.后向引用
'(pattern) \1 匹配 pattern 并获取这一匹配
'所获取的匹配可以从产生的 Matches 集合得到，
'在VBScript 中使用 SubMatches 集合
'-------------------------
Sub test()
Set regx = CreateObject("vbscript.regexp")
With regx
    .Global = True
    .Pattern = "(\d{4}).+\1.+" '\1捕获第一个括号内匹配的字符
    For Each Rng In [b2:b10]
        If .test(Rng) Then  '测试单元格是否匹配
            n = n + 1
            Cells(n + 1, "d") = Cells(Rng.Row, 1)
        End If
    Next
End With
End Sub
*
'2.非捕获分组
'(?:pattern) 匹配 pattern 但不获取匹配结果，
'也就是说这是一个非获取匹配，不进行存储供以后使用。
'这在使用 "或" 字符 (|) 来组合一个模式的各个部分是很有用。
'例如， 'industr(?:y|ies) 就是一个比 'industry|industries' 更简略的表达式。
'作用：避免不必要的捕获操作，提高代码的匹配效率。
'缺点：不美观，增加阅读难度。
```

## 11 零宽断言

零宽断言：就算找到你爱的人，也得不到，只能默默守在他 (她) 的身边。
**只匹配，不反悔字符。**

|类型 | 正则表达式 | 匹配方式|
|:--:|:--:|:--:|
|正向零宽断言 | `(?=...)` |从左至右查看匹配，位置在匹配的左边|
|负向零宽断言 | `(?!...)` |从右至左查看匹配，位置在匹配的右边|

负向零宽断言：如果匹配的字符位于字符串的第一个，则不匹配。

```vb
Sub test()
With CreateObject("vbscript.regexp")
    .Global = True
    .Pattern = "(?!^)(?=[a-z])" '负向零宽断言
    For Each Rng In [a1:a11]
        Cells(Rng.Row, 2) = .Replace(Rng, "-")
    Next
End With
End Sub
```

## 12 懒惰与贪婪模式

```vb
'前面我们已过知道"?"有三种：
'1 是量词{0,1}
'2 是非捕获型的匹配模式(?:)
'3 是环视结构(?=)(?!)
'今天学习第4种作用：
'任何一个其他限制符 (*, +, ?, {n}, {n,}, {n,m}) 后面加"?"时是懒惰模式
'懒惰模式：尽可能少的匹配所搜索的字符串。限制符后添加"?"
'贪婪模式：尽可能多的匹配所搜索的字符串（默认模式）
'----------------------
Sub test()
With CreateObject("vbscript.regexp")
    .Global = True
    .Pattern = "第\d+章.*?[一-龢]+.+?\d+"
    Set mat = .Execute([a1])
    For Each m In mat
        n = n + 1
        Cells(n + 1, "c") = m
    Next
End With
End Sub
```

## 13 分组

方法 2 比较容易理解。

```vb
Sub 捕获分组值1()
Set regx = CreateObject("vbscript.regexp")
With regx
    .Global = True
    .Pattern = "([一-龢]{3,}) (\d+人)"
    Set mat = .Execute([a1])
    For Each m In mat
        n = n + 1
        Cells(n + 1, 3) = .Replace(m.Value, "$1") '$1代表submatches第一个值。
        Cells(n + 1, 4) = .Replace(m.Value, "$2")
    Next
End With
End Sub
'-------
Sub 捕获分组值2()
Set regx = CreateObject("vbscript.regexp")
With regx
    .Global = True
    .Pattern = "([一-龢]{3,}) (\d+人)"
    Set mat = .Execute([a1])
    For i = 0 To mat.Count - 1
        Cells(i + 2, 5) = mat(i).submatches(0) 'submatches(0)代表submatches第一个值。
        Cells(i + 2, 6) = mat(i).submatches(1)
    Next
End With
End Sub
```

## 正则表达式的总结

EXCEL 里常用的几个正则表达式

```vb
"^\d+$"　　//非负整数（正整数 + 0）
"^[0-9]*[1-9][0-9]*$"　　//正整数
"^((-\d+)|(0+))$"　　//非正整数（负整数 + 0）
"^-[0-9]*[1-9][0-9]*$"　　//负整数
"^-?\d+$"　　　　//整数
"^\d+(\.\d+)?$"　　//非负浮点数（正浮点数 + 0）
"^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$"　　//正浮点数
"^((-\d+(\.\d+)?)|(0+(\.0+)?))$"　　//非正浮点数（负浮点数 + 0）
"^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$"　　//负浮点数
"^(-?\d+)(\.\d+)?$"　　//浮点数
"^[A-Za-z]+$"　　//由26个英文字母组成的字符串
"^[A-Z]+$"　　//由26个英文字母的大写组成的字符串
"[^a-z+$]"    '由26个英文字母的小写组成的字符串
" [^A-Za-z0-9]+$"　　‘由数字和26个英文字母组成的字符串
"^\w+$"　　//由数字、26个英文字母或者下划线组成的字符串
"^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$"　　　　//email地址
"^[a-zA-z]+://(\w+(-\w+)*)(\.(\w+(-\w+)*))*(\?\S*)?$"　　//url
/^(d{2}|d{4})-((0([1-9]{1}))|(1[1|2]))-(([0-2]([1-9]{1}))|(3[0|1]))$/   // 年-月-日
/^((0([1-9]{1}))|(1[1|2]))/(([0-2]([1-9]{1}))|(3[0|1]))/(d{2}|d{4})$/   // 月/日/年
"^([w-.]+)@(([[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.)|(([w-]+.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(]?)$"   //Emil
"(d+-)?(d{4}-?d{7}|d{3}-?d{8}|^d{7,8})(-d+)?"   //电话号码
"^(d{1,2}|1dd|2[0-4]d|25[0-5]).(d{1,2}|1dd|2[0-4]d|25[0-5]).(d{1,2}|1dd|2[0-4]d|25[0-5]).(d{1,2}|1dd|2[0-4]d|25[0-5])$"   //IP地址
匹配中文字符的正则表达式： [^\u4e00-\u9fa5]
匹配双字节字符(包括汉字在内)：[^\x00-\xff]
匹配空行的正则表达式：\n[\s| ]*\r
匹配HTML标记的正则表达式：/<(.*)>.*<\/\1>|<(.*) \/>/
匹配首尾空格的正则表达式：(^\s*)|(\s*$)
匹配Email地址的正则表达式：\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*
匹配网址URL的正则表达式：^[a-zA-z]+://(\\w+(-\\w+)*)(\\.(\\w+(-\\w+)*))*(\\?\\S*)?$
匹配帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)：^[a-zA-Z][a-zA-Z0-9_]{4,15}$
匹配国内电话号码：(\d{3}-|\d{4}-)?(\d{8}|\d{7})?
匹配腾讯QQ号：^[1-9]*[1-9][0-9]*$
```
