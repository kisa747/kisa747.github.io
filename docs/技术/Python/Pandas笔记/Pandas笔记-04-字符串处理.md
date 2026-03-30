# 字符串处理

参考：

<https://pandas.pydata.org/pandas-docs/stable/reference/series.html#string-handling>

`str` 对象是定义在 `Index` 或 `Series` 上的属性，专门用于处理每个元素的文本内容，其内部定义了大量方法，因此对一个序列进行文本处理，首先需要获取其 `str` 对象。

```python
# str.split 能够把字符串的列进行拆分，其中第一个参数为正则表达式，默认 pat 字符数大于 1 则支持正则表达式。
s.str.split('[市区路]', n=2, expand=True)
# str.join 表示用某个连接符把 Series 中的字符串列表连接起来，如果列表中出现了非字符串元素则返回缺失值
s.str.join('-')
# str.cat 用于合并两个序列，主要参数为连接符 sep、连接形式 join 以及缺失值替代符号 na_rep，其中连接形式默认为以索引为键的左连接。
s1.str.cat(s2, sep='-', na_rep='?', join='outer')
# str.contains 返回了每个字符串是否包含正则模式的布尔序列：
s.str.contains('\s\wat')
# str.replace 和 replace 并不是一个函数，在使用字符串替换时应当使用前者。
s.str.replace('\d|\?', 'new', regex=True)
# 提取既可以认为是一种返回具体元素（而不是布尔值或元素对应的索引位置）的匹配操作，也可以认为是一种特殊的拆分操作。
# 前面提到的 str.split 例子中会把分隔符去除，这并不是用户想要的效果，这时候就可以用 str.extract 进行提取：
s.str.extract('(\w+ 市)(\w+ 区)(\w+ 路)(\d+ 号)')
# 通过子组的命名，可以直接对新生成 DataFrame 的列命名：
s.str.extract('(?P<市名>\w+ 市)(?P<区名>\w+ 区)(?P<路名>\w+ 路)(?P<编号>\d+ 号)')
# str.extractall 不同于 str.extract 只匹配一次，它会把所有符合条件的模式全部匹配出来，如果存在多个结果，则以多级索引的方式存储：
s.str.extractall('[A|B](?P<name1>\d+)[T|S](?P<name2>\d+)')
# str.findall 的功能类似于 str.extractall，区别在于前者把结果存入列表中，而后者处理为多级索引，每个行只对应一组匹配，而不是把所有匹配组合构成列表。
s.str.findall('(?P<市名>\w+ 市)(?P<区名>\w+ 区)(?P<路名>\w+ 路)(?P<编号>\d+ 号)')
# upper, lower, title, capitalize, swapcase 这五个函数主要用于字母的大小写转化
s.str.upper()
s.str.lower()
s.str.title()
s.str.capitalize()
s.str.swapcase()
# count 和 len 的作用分别是返回出现正则模式的次数和字符串的长度：
s.str.count('[r|f]at|ee')
s.str.len()
# 格式型函数主要分为两类，第一种是除空型，第二种是填充型。其中，第一类函数一共有三种，它们分别是 strip, rstrip, lstrip，分别代表去除两侧空格、右侧空格和左侧空格。这些函数在数据清洗时是有用的，特别是列名含有非法空格的时候。
s.str.strip()
# 对于填充型函数而言，pad 是最灵活的，它可以选定字符串长度、填充的方向和填充内容：
s.str.pad(5,'left','*')
# 上述的三种情况可以分别用 rjust, ljust, center 来等效完成，需要注意 ljust 是指右侧填充而不是左侧填充：
s.str.ljust(5, '*')
# 在读取 excel 文件时，经常会出现数字前补 0 的需求，例如证券代码读入的时候会把”000007”作为数值 7 来处理，pandas 中除了可以使用上面的左侧填充函数进行操作之外，还可用 zfill 来实现。
s.str.zfill(6)
```

文本转换为数据

```python
# 这里着重需要介绍的是 pd.to_numeric 方法，它虽然不是 str 对象上的方法，但是能够对字符格式的数值进行快速转换和筛选。其主要参数包括 errors 和 downcast 分别代表了非数值的处理模式和转换类型。其中，对于不能转换为数值的有三种 errors 选项，raise, coerce, ignore 分别表示直接报错、设为缺失以及保持原来的字符串。
s = pd.Series(['1', '2.2', '2e', '??', '-2.1', '0'])
pd.to_numeric(s, errors='ignore')
```
