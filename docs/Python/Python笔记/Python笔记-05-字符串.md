# 字符串笔记

## 小技巧

* 用两个 `{{}}` 就能输出 {}，f-string 里不能用反斜杠。

## f-string 格式化字符串

```python
>>> i = 1
>>> print(f'{i:0>2d}.pdf')  # 格式化数字，保持 2 位，不足部分用 0 填充。
01.pdf

>>> p = '测试'
>>> print(f'{p=}')  # 调试时使用很方便。
p='测试'

b = 1056.2612
print(f' 成绩 {b:.2f}')  # 保留 2 位小数
[输出：] 成绩 1056.26

# !r 意思是对变量调用 repr() 函数。相当于{repr(func.__name__)}
# !s 是调用 str()，!a 是调用 ascii()
print(f'\n{func.__name__!r} 运行结束，共耗时 {run_time_str!s}')
```

## 字符串的拼接

[python3 拼接字符串的 7 种方法](<https://www.pythontab.com/html/2018/pythonjichu_0730/1331.html>)

字符串文本能够分成多行。

一种方法是使用三引号：`"""..."""` 或者 `'''...'''`。行尾换行符会被自动包含到字符串中，但是可以在行尾加上 `\` 来避免这个行为。

相邻的两个字符串以上的文本（例如在引号环绕的子串）会自动合并在一起：

```python
>>> text = ('Put several strings within parentheses '
             'to have them joined together.')
```

## 清除多余空格、不可见字符

参考：<https://www.jianshu.com/p/56d4babcc555>

`\xa0`表示不间断空白符，爬虫中遇到它的概率不可谓不小，而经常和它一同出现的还有`\u3000`、`\u2800`、`\t`等 Unicode 字符串。单从对`\xa0`、`\t`、`\u3000`等含空白字符的处理来说，有以下几种方法可行：

### 使用`unicodedata`模块清洗

使用`unicodedata`模块（参数 `NFKC`）。

* 保留制表符`\t`和换行符`\n`
* 能转换 `\u3000`、`\xa0`
* 不能转换 `\u2800`

从网站爬回来的内容，建议使用此方法清洗。

```python
>>> import unicodedata
>>> s = 'T-shirt\xa0\xa0 短袖圆领衫，\u3000 体恤衫\xa0 买一件\t吧'
>>> unicodedata.normalize('NFKC', s)
'T-shirt     短袖\n\n圆领衫，体恤衫 买一件\t\t吧'
```

### 使用 re 模块清洗

使用`re.sub` ，移除所制表符`\t`，移除所有换行`\n`。

可以使用贪婪模式 `\s+` 将所有空格变为 1 个空格。与 Excel 中的 `clean` + `trim` 两个组合函数效果差不多，除了单词之间的单个空格之外，移除文本中的所有空格、换行。

```python
>>> import re
>>> s = 'T-shirt\xa0\xa0\xa0\xa0\xa0 短袖\n\n圆领衫，\u3000\xa0 体恤衫\xa0 买一件\t\t吧'
>>> re.sub('\s', ' ', s)
'T-shirt     短袖  圆领衫，体恤衫 买一件  吧'

>>> re.sub('\s+', ' ', s)
'T-shirt 短袖 圆领衫，体恤衫 买一件 吧'
```

## 字符串的格式化

* 方法 1：`str.format()`，比如：`'{0}, 成绩 {1:.1f}%'.format('小明', 17.125)`

```python
str.format(*args, **kwargs) # 基本语法
# 可变参数，意思可以解包序列，格式化各个元素，可选关键字用来通过 key 使用 value
# 使用 format() 方法还有一个好处，可以在表达式中作为整体使用。f-string 就不行
data = ['{}：{}'.format(x['ItemName'], x['SalaryValue']) for x in lis

>>> '{}, {}, {}'.format('a', 'b', 'c')  # 3.1+ only
'a, b, c'
>>> '{2}, {1}, {0}'.format('a', 'b', 'c') # 通过位置传入
'c, b, a'
>>> '{2}, {1}, {0}'.format(*'abc')      # 解包序列
'c, b, a'
>>> '{0}-{1}-{0}'.format('abra', 'cad')   # 参数的索引可以重复
'abra-cad-abra'

>>> 'Coordinates: {latitude}, {longitude}'.format(latitude='37.24N', longitude='-115.81W')        #通过字典的 key 使用 value 值
'Coordinates: 37.24N, -115.81W'
>>> coord = {'latitude': '37.24N', 'longitude': '-115.81W'}
>>> 'Coordinates: {latitude}, {longitude}'.format(**coord)  # 解包字典
'Coordinates: 37.24N, -115.81W'
```

* 方法 2：f-string，比如：`f'{a}, 成绩 {b:.1f}'`。

推荐使用 `f-string` 方法格式化字符串。

```python
# 示例
a = '小明'
b = 1056.2612
print(f'{a}, 成绩 {b:.1f}')  # 保留 1 位小数
[输出：] 小明, 成绩 17.1

a = '小明'
b = 1056.2612
print(f'{a:*^10s}:{b:0=+15,.3f}')
[输出：] ****小明****:+00,001,056.261

print(f'{a:<10}:{b:0<.2e}')
[输出：] 小明        :1.06e+03

# 字符串中数字左边补 0, 0>2 表示数据总显示宽度为 2，以 0 补齐
i = 1
print(f'{i:0>2d}.pdf')
[输出：] 01.pdf
```

详细语法：

```python
format_spec     ::=  [[fill]align][sign][#][0][width][grouping_option][.precision][type]
fill            ::=  空白处填充字符
align           ::=  "<" | ">" | "=" | "^"    #等号是数字类型专用，数字对齐应该使用等号
sign            ::=  "+" | "-" | " "          # 添加正负号
width           ::=  数字（包括正负号、千分位、小数点的宽度）
grouping_option ::=  "_" | ","                #千分位符
.precision      ::=  .数字                    #精确位数，小数点后位数
type            ::=  "b" | "c" | "d" | "e" | "E" | "f" | "F" | "g" | "G" | "n" | "o" | "s" | "x" | "X" | "%"                        #格式化字符的类型
```

* fill【可选】空白处填充的字符
* align【可选】对齐方式（需配合 width 使用）
* * *<，内容左对齐*
  * *>，内容右对齐 (默认)*
  * *＝，内容右对齐，将符号放置在填充字符的左侧，且只对数字类型有效。即：正负符号 + 填充物 + 数字*
  * *^，内容居中*
* sign【可选】有无符号数字

  * **+，正号加正，负号加负；**
  * **-，正号不变，负号加负；**
  * **空格，正号空格，负号加负；**
* \#            【可选】对于二进制、八进制、十六进制，如果加上#，会显示 0b/0o/0x，否则不显示
* ,_【可选】为数字添加分隔符，如：1,000,000
* width【可选】格式化位所占宽度
* .precision【可选】小数位保留精度
* type【可选】格式化类型

  * *传入”字符串类型“的参数*
    * *s，格式化字符串类型数据*
    * *空白，未指定类型，则默认是 None，同 s*
  * *传入“整数类型”的参数*
    * *b，将 10 进制整数自动转换成 2 进制表示然后格式化*
    * *c，将 10 进制整数自动转换为其对应的 unicode 字符*
    * *d，十进制整数*
    * *o，将 10 进制整数自动转换成 8 进制表示然后格式化；*
    * *x，将 10 进制整数自动转换成 16 进制表示然后格式化（小写 x）*
    * *X，将 10 进制整数自动转换成 16 进制表示然后格式化（大写 X）*
  * *传入“浮点型或小数类型”的参数*
    * *e，转换为科学计数法（小写 e）表示，然后格式化；*
    * *E，转换为科学计数法（大写 E）表示，然后格式化;*
    * *f，转换为浮点型（默认小数点后保留 6 位）表示，然后格式化；*
    * *F，转换为浮点型（默认小数点后保留 6 位）表示，然后格式化；*
    * *g，自动在 e 和 f 中切换*
    * *G，自动在 E 和 F 中切换*
    * *%，显示百分比（默认显示小数点后 6 位）*

 更多格式化操作：<https://docs.python.org/3/library/string.html#format-string-syntax>
