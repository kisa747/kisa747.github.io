# Excel VBA 学习总结 - 内置函数

  了解 VBA 与 Excel 内置的函数，能够使我们处理起任务来事半功倍。这些函数不仅使用方便，而且效率一般都比较高 (有些是例外的，特别是某些工作表函数)，比我们自己写的要高效的多。

## VBA 内置的函数

VBA 内置函数是 VBA 种可以直接使用的函数，很多处理函数也相当有用。

调用方式：直接使用函数，或者使用 VBA 调用。例如 Shell() 或者 VBA.Shell()。

VBA 内置的函数主要涉及以下几类：

**测试类函数：**

```vb
IsNumeric(x) - 是否为数字, 返回Boolean结果。
IsDate(x)  - 是否是日期, 返回Boolean结果。
IsEmpty（x） - 是否为Empty, 返回Boolean结果。
IsArray(x) - 指出变量是否为一个数组。
IsError(expression) - 指出表达式是否为一个错误值。
IsNull(expression) - 指出表达式是否不包含任何有效数据 (Null)。
IsObject(identifier) - 指出标识符是否表示对象变量。
```

**数学函数：**

```vb
Sin(X)、Cos(X)、Tan(X)、Atan(x) - 三角函数，单位为弧度。
Log(x)、Exp(x) -  返回x的自然对数，指数。
Abs(x) - 返回x的绝对值。
Int(number)、Fix(number) - 都返回参数的整数部分，区别：Int 将 -8.4 转换成 -9，而 Fix 将-8.4 转换成 -8。
Sgn(number) - 返回一个 Variant (Integer)，指出参数的正负号。
Sqr(number) - 返回一个 Double，指定参数的平方根。
VarType(varname) - 返回一个 Integer，指出变量的子类型。
Rnd(x) - 返回0-1之间的单精度数据，x为随机种子。
Round(x,y) -  把x四舍五入得到保留y位小数的值。
```

字符串函数：

```vb
Trim(string)、Ltrim(string)、Rtrim(string) - 去掉string左右两端空白，左边的空白，右边的空白。
Len(string) - 计算string长度
Replace(expression,find,replace) - 替换字符串。
Left(string, x)、Right(string, x)、Mid(string, start,x) - 取string左/右/指定段x个字符组成的字符串
Ucase(string)、Lcase(string) - 转换字符串为大、小写
Space(x) - 返回x个空白的字符串
Asc(string) - 返回一个 integer，代表字符串中首字母的字符代码
Chr(charcode) - 返回 string，其中包含有与指定的字符代码相关的字符
InStr() - 返回一个字符串在另外一个字符串中的位置，返回值为Variant(Long)型。
```

转换函数：

```vb
CBool(expression) - 转换为Boolean型
CByte(expression) - 转换为Byte型
CCur(expression) - 转换为Currency型
CDate(expression) - 转换为Date型
CDbl(expression) - 转换为Double型
CDec(expression) -  转换为Decemal型
CInt(expression) - 转换为Integer型
CLng(expression) - 转换为Long型
CSng(expression) - 转换为Single型
CStr(expression) - 转换为String型
CVar(expression) -  转换为Variant型
Val(string) - 转换为数据型
Str(number) - 转换为String
```

时间函数：

```vb
Now、Date、Time - 返回一个 Variant (Date)，根据计算机系统设置的日期和时间来指定日期和时间。
Timer - 返回一个 Single，代表从午夜开始到现在经过的秒数。
TimeSerial(hour, minute, second) - 返回一个 Variant (Date)，包含具有具体时、分、秒的时间。
DateDiff(interval, date1, date2[, firstdayofweek[, firstweekofyear]]) - 返回 Variant (Long) 的值，表示两个指定日期间的时间间隔数目。
Second(time) - 返回一个 Variant (Integer)，其值为 0 到 59 之间的整数，表示一分钟之中的某个秒。
Minute(time) - 返回一个 Variant (Integer)，其值为 0 到 59 之间的整数，表示一小时中的某分钟。
Hour(time) - 返回一个 Variant (Integer)，其值为 0 到 23 之间的整数，表示一天之中的某一钟点。
Day(date) - 返回一个 Variant (Integer)，其值为 1 到 31 之间的整数，表示一个月中的某一日
Month(date) - 返回一个 Variant (Integer)，其值为 1 到 12 之间的整数，表示一年中的某月。
Year(date) - 返回 Variant (Integer)，包含表示年份的整数。
Weekday(date, [firstdayofweek]) - 返回一个 Variant (Integer)，包含一个整数，代表某个日期是星期几。
```

其它常用函数：

```vb
Shell - 运行一个可执行的程序。
InputBox - 这个太熟悉了，简单输入对话框。这个需要注意与Application.InputBox(更强大，内置容错处理，选择取消后返回false)区分，而这个函数不含有容错处理，而且选择取消后返回空串(零个字节的字符串)。
MsgBox - 这个更不用说了，简单信息显示对话框，其实也是一种简单的输入手段。
Join - 连接数组成字符串。
Split - 拆分字符串成数组。
RGB - 返回指定R、G、B分量的颜色数值。
Dir - 查找文件或者文件夹。
IIF(expression, truePart, falsePart)  - IF语句的“简化版本”(比喻，当然并不一样)；expression为true的话返回truePart，否则返回falseParth。
Choose(index, choice1,...choiceN) - 选择指定Index的表达式，Index可选范围是1到选项的总数。
Switch(exp1,value1,exp2,value2,...expN,valueN) - 从左至右计算每个exp的值，返回首先为true的表达式对应的value部分。如果所有的exp值都不为true，则返回Null。注意虽然只返回一个部分，但是这里所有的表达式exp1到expN都是要被计算的，实际使用中要注意这个副作用。
```

部分内容来自下面的连接，感谢楼主的无私奉献。大家入门学学还是很不错的，推荐一下：<http://club.excelhome.net/forum.php?mod=viewthread&tid=178278&extra=page%3D3%26filter%3Ddigest%26digest%3D1&page=1>

## WorksheetFunction 工作表函数

WorksheetFunction 工作表函数是 Excel 内置的处理函数，计算功能相当强大。

调用方式：Application.WorksheetFunction 或者直接 WorksheetFunction。例如 Application.WorksheetFunction.Max() 或者 WorksheetFunction.Max()。

VBA 内置的函数是用于处理程序数据的，是为 VB 语言服务的，所有 VBA 宿主环境都可以使用这些内置的功能。但是对于 Worksheet 中的对象，似乎这些通用的函数并不能提供最佳的实践。所以针对 Sheet，又存在另外一套相关的处理函数，虽然它们与 VBA 中的某些函数作用是一样的，但是从“工作表函数”这个名字上就可以看出，对于工作表中的对象的所有操作，比如对单元格求和，求单元格中最大值等，使用工作表函数必将具有先天的优势 (当然了，工作表函数基本上都是可以在 Excel 单元格中直接输入“=”然后就可以使用的)。虽然从实际的操作中，我们可能发现，使用内置的工作表函数并不一定是最快，最高效的，但无疑是最直接，最省事的。

这里简单总结一下常用的几类函数。全部的函数说明参见文末的 MSDN 链接。

数学函数类：

```vb
BesselI(贝塞尔函数)  BesselJ  BesselK  BesselY  Power（指数） Log(对数，还有以不同) In(自然对数) Fact(阶乘)  FactDouble(半数阶乘，意思就是偶数的只计算偶数阶乘，奇数的只奇数奇数阶乘) PI(圆周率)
```

弦值计算类：

```vb
Acos  Acosh  Asin  Asinh  Atan2  Atanh  Cosh  Sinh  Tanh
```

数制转换类：

```vb
Bin2Dec Bin2Hex  Bin2Oct   Dec2Bin  Dec2Hex  Dec2Oct  Hex2Bin  Hex2Dec  Hex2Oct  Oct2Bin Oct2Dec   Oct2Hex  Degrees与Radians(弧度角度互换).
数值处理类：
Ceiling(arg1,arg2) - 数值舍入处理，把arg1舍入处理成arg2的最接近的倍数(大于等于传入的参数)。
Floor(arg1,arg2) - 数值舍入处理，把arg1舍入处理成arg2的最接近的倍数(小于等于传入的参数)。
Round - 按指定的位数四舍五入，返回类型是Double。
MRound - 按指定位数四舍五入，参数是Variant，返回类型是Double.
RoundDown - 舍去指定位数后面的小数，总是小于等于传入的参数，其它的基本同Round。
RoundUp - 舍去指定位数后的小数总是进1，总是大于等于传入的参数，其它的基本同Round。
Fixed - 按指定的位数四舍五入，返回类型是String，可以指定显示不显示逗号(第三个参数决定，False则显示逗号，True则不显示逗号).
Odd - 返回比参数大的最接近的奇数。
Even - 返回比参数大的最接近的偶数。
```

数值运算类：

```vb
Average  AverageIf  AverageIfs  Max Min Large Small Sum  SumIf  SumIfs SumProduct  SumSq  SumX2MY2   SumX2MY2 SumX2PY2   SumXMY2  Count  CountA  CountBlank CountIf CountIfs
Frequency - 计算第二个数组的每个元素在第一个数组中出现的次数，返回一个与第二个数组同长的一个数组。一般参数和返回值都是Range。
Lcm - 计算数值的最小公倍数。
Product  - 返回所有参数的乘积。
Quotient - 返回两个数整除的值，忽略余数。
```

逻辑判断类：

```vb
And - 如果所有参数都为True，则返回True；只要有一个返回False，则返回False。
Or - 如果所有参数都为False，则返回False；只要有一个返回True,则返回True。
IsErr - 检查是不是除了#N/A外的错误值.
IsError - 检查是不是错误值(#N/A, #VALUE!, #REF!, #DIV/0!, #NUM!, #NAME?,或者 #NULL!).
IsEven - 检查是否是偶数.
IsOdd - 检查是否是奇数.
IsLogical - 检查是不是布尔值.
IsNA - 检查值是否是错误值#N/A（值不可用）。
IsNonText - 检查是否是非文本(空的单元格返回true)。
IsNumber - 检查是不是数字。
IsText - 一般用于判断单元格中内容是否是文本。
Delta - 判断两个Variant的值是否相等，相等则返回1，否则返回0。
数据操作类：
Choose - 返回第一个参数Index指定的值. 与VBA内置的函数Choose有类似的功能。
Asc - 把双字节字符变成单字节字符。
Lookup,VLookup,HLookup - 查找单元格数组中与给定值相同的值，文本等等。
Match - 查找并返回单元格数组中与指定值相同的单元格的相对Index值。
Find,FindB,Search,SearchB -  返回第一个字符串在第二个字符串中的位置(位置是从1开始的，不是基于0的)。
Replace,ReplaceB - 字符串替换，可以指定开始的位置以替换的字符数，控制更为精细。
Substitute - 直接进行字符串替换，不需要指定开始位置，可控性差，但是使用简单。
Rept - 按照指定次数的重复构造字符串并返回。
Text - 按照一定的格式把值转换成文本。
Index - 一般用于返回一组单元格中某块区域中某行某列的值。
Median - 计算一个Double的数值，这个数值将参数分为相同数目两组，一组比这个值大，一组比这个值小。这个值可能正好出现在参数中，也可能不出现在这些参数中。
Mode - 返回传入的数组，或一组值中出现次数最多的值.
Prope - 格式化字符串中的每个单词，把首字母转成大写，其它的转成小写。
RandBetween - 返回介于两个数之间的随机数，返回值为Double型。
Rank- 返回指定的数在一个Range对象值中排过序后的位置(可以用第三个参数指定按降序或升序排，默认是降序)，比如单元格d1到d4的值为(1,4,3,4)，那么4的Rank值就是1(忽略第三个参数是按降序找第一个匹配，然后返回位置)。
Transpose - 把一个数组的行列互换，这个方法主要是针对单元格的，所以数组的长度(<65535)，和每个元素的长度(<255)都有限制。如果这个方法由于这些因素失败了，可以尝试一下这个方案：http://club.excelhome.net/thread-583046-1-1.html。
Trim - 移除单词之间多余的空格，只保留一个；字符串开头和结尾的空格也会全部移除。
Weekday - 返回指定日期是星期几，用Double值表示，范围默认是从1 (Sunday)到7(Saturday)。
WeekNum - 返回指定日期是一年中的第几周。
```

基本上以 Variant 为参数的函数都是可以直接传入单元格的。
以 B 结尾的函数代表是推荐使用于双字节的字符语言的，比如汉子，日语等。不以 B 结尾的函数代表的是推荐使用于单字节字符语言的，例如英语，德语等。对于不同的语言，这 2 个函数返回的结果可能是有差异的。
加上前缀“D”的函数是特别针对 Range 对象或数据库数据的相关数学运算，例如 DMax，DMin，DCount，DSum。
除了这些常用的函数，工作表函数还包含了相当多的高级数学计算函数，比如矩阵，方差，分布，统计，利率，虚数计算相关的函数，具体需要使用的时候查阅 MSDN 就可以了。
在 MSDN 上，很多函数的很多参数是必须的，但是使用的时候，编译器的提示是说这些参数不是必须的，这个时候以编译器为准。谨记，实践是检验真理的唯一标准。
基本上，如果参数是需要传入一组数的函数，都可以传入一个数组或单元格。

实际学习过程中，我是先了解这些内置的函数能干什么，但并不太关注细节；等实际使用的时候，才会找到需要的函数，匹配实现细节的。

全部的函数说明参见下面的 MSDN 链接：<http://msdn.microsoft.com/en-us/library/bb259450(v=office.12).aspx> 或者是<http://msdn.microsoft.com/en-us/library/bb225774(v=office.12).aspx>
