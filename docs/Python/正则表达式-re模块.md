# 正则表达式-re 模块

参考：

<https://docs.python.org/zh-cn/3/library/re.html>

<https://docs.python.org/zh-cn/3/howto/regex.html>

<https://www.runoob.com/regexp/regexp-syntax.html>

<https://www.cnblogs.com/huoxc/p/12845551.html>

正则表达式 (Regular Expressions) 是匹配文本模式 (patterns) 的有力工具。

在 Python 中正则表达式搜索的典型语法为：

|                      语句                       | 释义                                                         | 返回值               | 备注                                       |
| :---------------------------------------------: | ------------------------------------------------------------ | -------------------- | ------------------------------------------ |
|                  `re.match()`                   | 如果字符串的开头有 0 或多个字符匹配表达式，返回一个 Match 对象，仅匹配文本开头。 | Match 对象            | 从开头搜索，相当于 `re.search(r'^pat', s)` |
|                  `re.search()`                  | search 方法通过搜索整个字符串，找到第一个匹配表达式的对象，返回一个 match 对象。否则返回 None。 | Match 对象            | 从任意位置搜索                             |
|                 `re.findall()`                  | 返回所有匹配表达式的不重复的匹配对象，从左至右搜索。返回一个 list 列表。如果没有匹配结果，返回空的列表。 | 字符串列表           | 如果有圆括号，仅返回圆括号内匹配对象       |
| `re.split(pattern, string[, maxsplit=0,flags])` | 根据模式的匹配项来分割字符串                                 | 分割后的字符串列表   |                                            |
|   `re.sub(pat,repl, string[,count=0,flags])`    | 将字符串中所有的 pat 的匹配项用 repl 替换                        | 完成替换后的新字符串 |                                            |

使用方法：

```python
import re
# match() 方法判断是否匹配，如果匹配成功，返回一个 Match 对象，否则返回 None。
# 如果字符串的开头有 0 或多个字符匹配表达式，返回一个 Match 对象，仅匹配文本开头。
match = re.match(pattern, string, flags=0)

# search 方法通过搜索整个字符串，找到第一个匹配表达式的对象，返回一个 match 对象。否则返回 None。
re.search(pattern, string, flags=0)

# 返回所有匹配表达式的不重复的匹配对象，从左至右搜索。返回一个 list 列表。如果没有匹配结果，返回空的列表。
re.findall(pattern, string, flags=0)

# 返回迭代器，包含所有 match 对象，所有匹配表达式的不重复的匹配对象。
re.finditer(pattern, string, flags=0)
```

1. 由于 Python 的字符串本身也用`\`转义，pattern 一定要使用 raw 字符串： `r'pattern'`。
2. 正则表达式中所谓的“单词”,就是由`\w`所定义的字符所组成的字符串。
3. 若不确定一个字符是否具有特殊含义，如`@`，可以采用`\@`来确保匹配`@`而不是它可能会对应的特殊模式。对于不确定是否为模式关键字的情况，可以在前面加一个`\`，并不会影响结果;-)。
4. 通常情况下`.`匹配除换行符外的所有字符。这可能会让你认为`.*`可以匹配所有文本 (这是错的)，因为不会进行跨行匹配。注意到`\s`包含换行符，所以如果你想匹配一连串可能包含换行符的空白符，可以简单地采用`\s*`。
5. 通常情况下，`^`或`$`只匹配整个字符串的开头和结尾。
6. `^`放在模式集合开头时将会对集合取反，即匹配不对应方括号内模式的任何字符。

## 贪心与否

假设有一个包含 html 标签的文本：`<b>foo</b>`和`<i>so on</i>`，并且尝试采用`'(<.*>)'`匹配每一个标签 – 匹配结果如何？

结果可能会比较让人吃惊，但是`.*`的“贪心性”确实会导致模式将`<b>foo</b>`和`<i>so on</i>`分别作为一次匹配。

因为`.*`会尽可能多地往后匹配，而不是在匹配到`>`时停止匹配 (即其”贪心性”)。

正则表达式的一个扩展，可以在模式结尾加一个`?`，比如`.*?`或`.+?`[13](https://oncemore.wang/blog/python-re/#fn:pcre),可屏蔽匹配规则的贪心性。

这时匹配会在能够完成匹配的情况下尽早结束。

则`'(<.*?>)'`第一次将仅匹配`<b>`，第二次匹配`</b>`，则能按顺序获得每个标签。

一种较古老但是很流行的对

> 除了在字符 X 处停止匹配外，匹配任意字符 (all of these chars except stopping at X)

进行编程的方法是采用方括号。采用`[^>]*`而不是`.*`来作为模式，将会跳过除`>`之外的所有字符[14](https://oncemore.wang/blog/python-re/#fn:hat)。

### 方法列表

完整的方法列表

| 方法                                            | 描述                     | 返回值                |
| --------------------------------------------- | ---------------------- | ------------------ |
| re.compile(pattern[, flags])                  | 根据包含正则表达式的字符串创建模式对象    | re 对象               |
| re.search(pattern, string[, flags])           | 在字符串中查找                | 第一个匹配到的对象或者 None    |
| re.match(pattern, string[, flags])            | 在字符串的开始处匹配模式           | 在字符串开头匹配到的对象或者 None |
| re.split(pattern, string[, maxsplit=0,flags]) | 根据模式的匹配项来分割字符串         | 分割后的字符串列表          |
| re.findall(pattern, string,flags)             | 列出字符串中模式的所有匹配项         | 所有匹配到的字符串列表        |
| re.sub(pat,repl, string[,count=0,flags])      | 将字符串中所有的 pat 的匹配项用 repl 替换 | 完成替换后的新字符串         |
| re.finditer(pattern, string,flags)            | 将所有匹配到的项生成一个迭代器        | 所有匹配到的字符串组合成的迭代器   |
| re.subn(pat,repl, string[,count=0,flags])     | 在替换字符串后，同时报告替换的次数      | 完成替换后的新字符串及替换次数    |
| re.escape（string）                             | 将字符串中所有特殊正则表达式字符串转义    | 转义后的字符串            |
| re.purge(pattern)                             | 清空正则表达式                |                    |
| re.template(pattern[,flags])                  | 编译一个匹配模板               | 模式对象               |
| re.fullmatch(pattern, string[, flags])        | match 方法的全字符串匹配版本       | 类似 match 的返回值        |

### flag 选项

`re`模块中的函数可接收选项来改变模式匹配的规则。

同时还定义了下面几种匹配模式，单个大写字母是缩写，单词是完整模式名称，引用方法为`re.A`或者`re.ASCII`，两者都可以，注意全部是大写：

选项作为附加参数放在`search()`或`findall()`等函数中`re.search(par, str, re.IGNORECASE)`。

Python 的 re 模块提供了一些可选的标志修饰符来控制匹配的模式。可以同时指定多种模式，通过与符号`|`来设置多种模式共存。如`re.I | re.M`被设置成`I`和`M`模式。

| flag 选项 | 匹配模式       | 描述                                                                              |
| ------ | ---------- | ------------------------------------------------------------------------------- |
| re.A   | ASCII      | ASCII 字符模式。                                                                      |
| re.I   | IGNORECASE | 在匹配中忽略大小写。如`'a'`同时匹配`'a'`和`'A'`。使匹配对大小写不敏感，也就是不区分大小写的模式                         |
| re.L   | LOCALE     | 做本地化识别（locale-aware）匹配                                                          |
| re.M   | MULTILINE  | 在由许多行组成的字符串内，允许`^`和`$`匹配每一行的开头和结尾。通常情况下，`^`或`$`只匹配整个字符串的开头和结尾。多行匹配，影响 `^` 和 `$` |
| re.S   | DOTALL     | 允许句点`.`匹配换行符。使 `.` 这个通配符能够匹配包括换行在内的所有字符，针对多行匹配                                  |
| re.X   | VERBOSE    | 该标志通过给予你更灵活的格式以便你将正则表达式写得更易于理解                                                  |

示例：

```python
for video in media_dir.iterdir():
    if re.match('\.mov|\.mp4', video.suffix, re.I):
        rename_media(video)
```

## 分组功能

Python 的 re 模块有一个分组功能。所谓的分组就是去已经匹配到的内容里面再筛选出需要的内容，相当于二次过滤。实现分组靠圆括号 `()`，而获取分组的内容靠的是 group()、groups() 和 groupdict() 方法，其实前面我们已经展示过。re 模块里的几个重要方法在分组上，有不同的表现形式，需要区别对待。

findall() 方法返回的分组内匹配的列表。所以没有圈在分组内的内容会被抛弃。所以 findall() 方法最常用。

如果有多个分组，则返回的是分组元组的列表。如果要用 () 圆括号，又不想分组，可以使用 (?:...)  分组但不捕获。

sub() 方法没有分组概念。整体匹配然后替换。

`re.search()`方法接收一个正则表达式**模式**和一个**字符串**作为参数，并在给定字符串中搜索给定模式。

如果搜索成功，`search()`返回一个匹配对象，否则返回`None`。

因此，通常搜索会紧跟一个 `if` 语句来测试搜索是否成功，如下例所示，搜索`word:`后紧跟三个字母的模式：

```python
str = 'an example word:cat!!'
match = re.search(r'word:\w\w\w', str)
# If-statement after search() tests if it succeeded
if match:
    # 'found word:cat'
    print 'found', match.group()
else:
    print 'did not find'
```

代码`match =re.search(pat,str)`将搜索结果存储在`match`变量中，然后 if 语句对`match`变量进行测试。

- 如果为真，则`match.group()`为匹配文本 (e.g. `'word:cat'`)。
- 否则`match`为假 (更具体地说是`None`)，即匹配不成功，不存在匹配文本。

字符串开头的`r`指定一个`raw`字符串，即对转义字符`\`不进行解析[1](https://oncemore.wang/blog/python-re/#fn:escape)，这对正则表达式是很便利的。

因此建议养成习惯在使用正则表达式时始终采用`r`指定模式。(Java 非常需要这个特性!)。

## findall 和分组

`findall()`可能是`re`模块中最有用的函数。之前我们采用`re.search()`来查找关于给定模式的 Leftmost 匹配。

不同的是，`findall()`将找到所有的匹配并以字符串列表 (list) 的形式返回，每一个字符串表示一次匹配。

```python
# Suppose we have a text with many email addresses
str = 'purple alice@google.com, blah monkey bob@abc.com blah dishwasher'

# Here re.findall() returns a list of all the found email strings
emails = re.findall(r'[\w\.-]+@[\w\.-]+', str) ## ['alice@google.com', 'bob@abc.com']
for email in emails:
    # do something with each found email string
    print email
```

分组括号`()`同样可以用于和`findall()`组合使用。

如果模式包含两个或多个分组括号，则`findall()`将返回**元组 (tuple)**列表而不是字符串 (str) 列表。

每个元组表示一次匹配，在元组内则是`group(1)`,`group(2)`,…数据[9](https://oncemore.wang/blog/python-re/#fn:tuple)。

所以，如果在邮件地址模式中加入两个分组括号，则`findall()`将返回一个元组列表，每一个元组包含用户名和主机名。

```python
str = 'purple alice@google.com, blah monkey bob@abc.com blah dishwasher'
tuples = re.findall(r'([\w\.-]+)@([\w\.-]+)', str)
print tuples  # [('alice', 'google.com'), ('bob', 'abc.com')]
for tuple in tuples:
    print tuple[0]  # username
    print tuple[1]  # host
```

一旦获得了元组列表，则可以在元组间循环以对每一个元组进行一些计算。

- 如果模式不包含分组括号，则`findall()`返回一个字符串列表。
- 如果模式包含单个分组括号，则`findall()`返回对应于单个分组的字符串列表。

一条较晦涩的可选特性：

有时模式中包含分组括号`()`，且并不希望提取它，在括号内以`?:`开始，e.g.`(?:)`，则不会将匹配文本归入分组结果中。

## 示例：提取邮箱地址

假设想找到字符串`'xyz alice-b@google.com purple monkey'`中的邮件地址。

采用模式`r'\w+@\w+'`的尝试：

```python
str = 'purple alice-b@google.com monkey dishwasher'
match = re.search(r'\w+@\w+', str)
if match:
    print match.group()  # 'b@google'

email_re = re.compile(r'([a-zA-Z0-9_\+\-\.]+)@(([[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)')
```

搜索没有获得整个邮件地址，因为`\w`不会匹配邮件地址中的`'-'`和`'.'`。我们将采用下面的特性来修正这个问题。

## 提取 Group

正则表达式的`group`方法允许程序选取匹配文本的一部分。

假设在邮件地址问题中我们需要提取用户名和主机名。

为了这样做，将用户名模式和主机名模式用`()`包围起来，例如`r'([\w.-]+)@([\w.-]+)'`。

在这种情况下，`()`并不影响匹配规则，而是在匹配文本中建立一个分组 (group)。对于成功的匹配：

- `match.group(1)`表示第一个括号内的模式匹配的文本
- `match.group(2)`表示第二个括号内的模式匹配的文本。
- `match.group()`仍然表示整个匹配文本。
- `match.groups()`返回包括所有分组匹配结果的元组。

```python
str = 'purple alice-b@google.com monkey dishwasher'
match = re.search('([\w.-]+)@([\w.-]+)', str)
if match:
    print(match.group())   # 'alice-b@google.com' (the whole match)
    print(match.group(1))  # 'alice-b' (the username, group 1)
    print(match.group(2))  # 'google.com' (the host, group 2)
```

通常使用正则表达式的工作流程是首先为需要查找的东西写出相应的模式，然后再添加括号分组以便提取感兴趣的部分。

## 正则表达式工作流程和调试

正则表达式将许多不同的含义封装进少数字符中，非常稠密，可能需要使用许多时间来调试模式。

将运行时 (runtime) 设置为可简单地匹配模式并输出匹配文本，例如可以在一个小测试文本上运行并输出`findall()`的结果。

- 当什么都不匹配时，因为没有实质性的结果可以查看，很难取得进展。
- 如果模式没有匹配任何文本，尝试简化模式，移除部分模式以获得更多匹配。
- 当得到了过多的匹配结果时，可以递增地整理组合模式以便得到最终需要匹配的模式。

## 替换

`re.sub(pat, replacement, str)`函数在给定字符串中搜索所有匹配模式的结果，并进行替换。

替换字符串可以包含`'\1','\2',...`，分别引用原始匹配文本的`group(1),group(2),...`。

下面是一个示例，搜索所有邮件地址，并将其变为保留用户名 (`\1`) 但是将”yo-yo-dyne.com”作为主机名。

```python
str = 'purple alice@google.com, blah monkey bob@abc.com blah dishwasher'
## re.sub(pat, replacement, str) -- returns new string with all replacements,
## \1 is group(1), \2 group(2) in the replacement
print re.sub(r'([\w\.-]+)@([\w\.-]+)', r'\1@yo-yo-dyne.com', str)
## purple alice@yo-yo-dyne.com, blah monkey bob@yo-yo-dyne.com blah dishwasher
```

## 加强版切分字符串

正常的字符串切分 (`.split()`):

```python
>>> 'a b   c'.split(' ')
['a', 'b', '', '', 'c']
```

可见其无法应对连续出现的空格字符，正则表达式的`re.split()`可以解决这个问题：

```python
>>> re.split(r'\s+', 'a b   c')
['a', 'b', 'c']
```

## 预编译正则表达式

Python 正则表达式 re 模块工作流程：

- 编译正则表达式，如果正则表达式模式不合法，报错；
- 用编译后的正则表达式去匹配字符串。

如果一个正则表达式要重复使用几千次，出于效率的考虑，可以预编译该正则表达式，之后重复使用时就不需要每次都编译

```python
# 匹配区号 + 电话号码
# 编译：
>>> re_telephone = re.compile(r'^(\d{3})-(\d{3,8})$')
# 使用：
>>> re_telephone.match('010-12345').groups()
('010', '12345')
>>> re_telephone.match('010-8086').groups()
('010', '8086')
```
