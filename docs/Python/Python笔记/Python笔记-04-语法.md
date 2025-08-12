## Python 风格规范

参考：[Google 的 Python 风格规范](https://zh-google-styleguide.readthedocs.io/en/latest/google-python-styleguide/python_style_rules/)

* 用 4 个空格来缩进代码，任何时候都不要使用 TAB 进行缩进。
* 顶级定义之间空两行，方法定义之间空一行
* 按照标准的排版规范来使用标点两边的空格
* 确保对模块，函数，方法和行内注释使用正确的风格
* 标准的 shebang：`#!/usr/bin/env python3`
* 每个导入应该独占一行
* 通常每个语句应该独占一行

## 基础知识

参考：[Python Cookbook 中文版](<https://github.com/yidao620c/python3-cookbook>)

Python 区分大小写，对大小写敏感。

单前导下划线 `_var`，以单个下划线开头命名的方法或者变量，就是说明它是仅提供内部使用的。

### and 和 or 运算规律

[python3 中 and 和 or 运算规律](https://www.pythontab.com/html/2018/pythonjichu_0626/1310.html)

常用语函数内，对传入参数进行判断。

```python
a = None
b = 4
c = a or b

# 等价于
if a:
    c = a
else:
    c = b
```

### break 与 continue

break 提前退出循环。

continue 跳过当前的这次循环，直接开始下一次循环。

### 遍历技巧

遍历字典时，键和对应的值可以用 `items()` 方法一次性全部得到。

```python
for k, v in knights.items():
```

遍历一个序列时，位置索引和对应的值可以用 [`enumerate()`](https://docs.python.org/3/library/functions.html#enumerate) 方法一次性全部得到。

```python
for i, v in enumerate(['tic', 'tac', 'toe']):
```

当需要同时遍历两个或多个序列时，可以使用 [`zip()`](https://docs.python.org/3/library/functions.html#zip) 方法将他们合并在一起。

```python
for q, a in zip(list1, list2):
```

当需要反过来遍历一个序列的时候，使用 [`reversed()`](https://docs.python.org/3/library/functions.html#reversed) 方法来将一个正的序列倒序。

```python
for i in reversed(range(1, 10, 2)):
```

需要按顺序遍历一个序列，可以把未排序的序列传到 [`sorted()`](https://docs.python.org/3/library/functions.html#sorted) 方法中来获得一个新的排好序的列表。

```python
for f in sorted(set(basket)):
```

比较运算符 `in` 和 `not in` 能够检查某个值是否在一个序列里出现（或不出现）。

比较运算符可以采用连写的方式。例如， `a < b == c` 用来检查是否 `a` 小于 `b` 并且 `b` 等于 `c` 。

比较运算符可以用布尔运算符 `and` 和 `or` 进行组合，然后他们的结果（或者任何其他的布尔表达式）可以被 `not` 否定。这些布尔运算符的优先级又比比较运算符更低；而在他们之间， `not` 的优先级最高，而 `or` 的优先级最低，因此 `A and not B or C` 就等价于 `(A and (not B)) or C`。当然，括号可以用来提升优先级。

布尔运算符 `and` 和 `or` 往往被称为 *短路* 运算符：它们的参数从左往右一个个被计算，而当最终结果已经能够确定时，就不再计算剩余的参数了。举个例子，如果 `A` 和 `C` 是真的，而 `B` 是假的，那么 `A and B and C` 不会计算表达式 `C` 的值。当不作为布尔值使用，而是作为普通的值来使用时，短路运算符的返回值将会是最后一个被计算的参数。

也可以把比较运算的结果或其他布尔表达式赋值给一个变量。例如：

```python
if a and b:
    pass
```

### 逻辑运算

```python
True and True
True or True
not True
```

and、or、not 是运算符。

## 序列

### 序列索引、切片

索引：

```ini
 +---+---+---+---+---+---+
 | P | y | t | h | o | n |
 +---+---+---+---+---+---+
   0   1   2   3   4   5
  -6  -5  -4  -3  -2  -1   0
```

切片：

```ini
 +---+---+---+---+---+---+
 | P | y | t | h | o | n |
 +---+---+---+---+---+---+
 0   1   2   3   4   5   6
-6  -5  -4  -3  -2  -1   0
```

start_index：表示起始索引（包含该索引本身）；该参数省略时，表示从对象“端点”开始取值，至于是从“起点”还是从“终点”开始，则由 step 参数的正负决定，step 为正从“起点”开始，为负从“终点”开始。

end_index：表示终止索引（不包含该索引本身）；该参数省略时，表示一直取到数据“端点”，至于是到“起点”还是到“终点”，同样由 step 参数的正负决定，step 为正时直到“终点”，为负时直到“起点”。

### 列表 list

```python
a = [[1,2], [3,4]]
b = [[5,6], [7,8]]
c = a + b  # 列表可以相加，进行连接操作。
print(c)
[输出：][[1, 2], [3, 4], [5, 6], [7, 8]]

# 还有更方便的
a.extend(b)  # 直接在列表 a 上修改，不用重新赋值。
print(a)
[输出：][[1, 2], [3, 4], [5, 6], [7, 8]]

squares[:]      # 表示列表所有元素。
len(squares)    # 所有序列都内置有 len() 方法
```

`list.pop([*i*])`移除并返回列表中给定位置的元素。如果没有指定索引，`a.pop()` 移除并返回列表的最后一个元素。

`list.append(*str*)`将一个元素添加到列表的末端

`list.extend(*iterable*)`将一个 `iterable` 的对象中的所有元素添加到列表末端来拓展这个列表。如果`iterable`也是一个列表 list，相当于：list1 + list2。

`list.sort(*key=None*, *reverse=False*)`对列表中的元素进行原地排序。相当与 sorted() 函数。

`list.reverse()`原地翻转列表。

像 `insert`、`remove` 或者 `sort` 这样的方法只是改动了列表但是没有打印出返回值，因为它们返回了默认的 `None` 。这是一个 Python 中所有可变数据结构的设计理念。

#### 使用列表作为堆栈

**后进先出**。列表当成元素后进先出的堆栈来用。使用 `append()` 来把一个元素加到堆栈的顶部。使用不显示携带索引参数的 `pop()` 方法来把一个元素从堆栈顶部移除。

#### 使用列表作为队列

也可以使用列表作为队列，其中添加的第一个元素是检索的第一个元素（**“先入，先出”**）；然而，列表对于这一目的并不高效。虽然从列表末尾追加和弹出是高效的，但是从列表的开头开始插入或弹出就低效了（因为所有其他元素都必须移动一个位置）。

实现一个队列，使用 [`collections.deque`](https://docs.python.org/3/library/collections.html#collections.deque) 它被设计为从两端都具有快速追加和弹出的能力。

```python
>>> from collections import deque
>>> queue = deque(["Eric", "John", "Michael"])
>>> queue.append("Terry")           # Terry 进入
>>> queue.append("Graham")          # Graham 进入
>>> queue.popleft()                 # 现在弹出第一个进入的元素
'Eric'
>>> queue.popleft()                 # 现在弹出第二个进入的元素
'John'
>>> queue                           # 按进入顺序维护队列
deque(['Michael', 'Terry', 'Graham'])
```

### 元组 tuple

元组固定元素，仅可以拼接元组。

```python
a = ()  # 空的元组
a = (1,)  # 仅有一个元素的元组，后面必须要有逗号。

# 元组可以拼接
a = ([1,2], [3,4])
b = ([5,6], [7,8])
c = a + b
print(c)
[输出：]([1, 2], [3, 4], [5, 6], [7, 8])

# 列表转换成元组
a = [1,2]
b = tuple(a)
print(b)
[输出：]
(1, 2)
```

### 字典 dict

字典，默认在 key 中遍历，如果要在 value 中遍历，使用 `dict.values()` 方法，如果在 key 和 value 中同时遍历，使用 `dict.items()` 方法

```python
dic = {'key1': 'value1', 'key2': 'value2'}
for k, v in dict.items():
for k in dict.keys():  # 与 for k in dict: 一样
for v in dict.values():

a = {'A':1, 'B':12, 'C':23}
b = {'B':35, 'D':46, 'E':58}

# 更新字典
# 就地更新 a，返回 None。有重复的会被字典 b 的 value 覆盖更新。
a.update(b)
print(a)
[输出：]{'A': 1, 'B': 35, 'C': 23, 'D': 46, 'E': 58}
# python3.9+ 支持更新 (|=) 运算符，与 a.update(b) 效果一样。
a |= b

# 合并字典
# 如果不想就地更新字典，要么深拷贝一个字典，要么使用合并字典操作。
# 合并操作就是 a.update(b) 的非就地更新版。
c = a | b
c
[输出：]{'A': 1, 'B': 35, 'C': 23, 'D': 46, 'E': 58}
# 或者使用 ** 解包合并，效果一样
c = {**a, **b}
c
[输出：]{'A': 1, 'B': 35, 'C': 23, 'D': 46, 'E': 58}

a.values() # 以列表形式返回所有的值，特殊的列表，不可索引。
[输出：]dict_values([1, 35, 23, 46, 58])
a.keys()  # 以列表形式返回所有的键值，特殊的列表，不可索引。
[输出：]dict_keys(['A', 'B', 'C', 'D', 'E'])
a.items()  # 以列表形式返回 key value
[输出：]dict_items([('A', 1), ('B', 35), ('C', 23), ('D', 46), ('E', 58)])

dict.fromkeys(seq[, value]) # 用序列作为 key 创建一个字典，默认 value 为 None。需要提前定义一个字典，非空字典将被清空。
a.fromkeys(['A','c'],5)

# 这三种方法都能判断是否在字典中，get() 方法最为强大，还能指定默认返回值。
dict.has_key(key) # 在字典中查找指定 key，返回布尔值
dict.get(key, default=None) # 返回指定键的值，如果值不在字典中，返回参数 default 的值。没有参数时返回 None
key in dict # 判断 key 是否在字典的 key 中

dict.setdefault(key, default=None) # 该函数和 get() 方法类似，如果键不存在于字典中，将会添加键并将值设为默认值。

pop(key[,default])  # pop() 方法删除字典给定键 key 及对应的值，key 值必须给出。如果有 key 值，返回值为被删除的值。如果没有 对应的 key，返回 default 值

iter(dict)  # 相当于 iter(dict.keys())，返回所有键值的迭代器
```

### 推导式

```python
code = {'河南': ['郑州', '开封', '洛阳', '安阳', '焦作', '鹤壁', '新乡', '濮阳', '许昌', '漯河', '南阳', '商丘', '信阳', '周口', '驻马店', '济源', '平顶山', '三门峡'], '黑龙江': ['哈尔滨', '牡丹江', '佳木斯', '大庆', '鸡西', '双鸭山', '齐齐哈尔', '伊春', '七台河', '鹤岗', '黑河', '绥化', '大兴安岭'], '湖北': ['武汉', '黄石', '襄阳', '荆州', '宜昌', '黄冈', '鄂州', '孝感', '荆门', '咸宁', '仙桃', '十堰', '随州', '神农架', '恩施', '天门', '潜江']}
# 组合这种类型的数据，2 次推导式更方便。字典不添加 .items() 方法，默认返回的是.keys() ,如果要返回 values，使用 .values() 方法
lis = [[k, x] for k, v in code.items() for x in v]
lis
[输出：]
[['河南', '郑州'], ['河南', '开封'], ['河南', '洛阳'], ['河南', '安阳'], ['河南', '焦作'], ['河南', '鹤壁'], ['河南', '新乡'], ['河南', '濮阳'], ['河南', '许昌'], ['河南', '漯河'], ['河南', '南阳'], ['河南', '商丘'], ['河南', '信阳'], ['河南', '周口'], ['河南', '驻马店'], ['河南', '济源'], ['河南', '平顶山'], ['河南', '三门峡'], ['黑龙江', '哈尔滨'], ['黑龙 江', '牡丹江'], ['黑龙江', '佳木斯'], ['黑龙江', '大庆'], ['黑龙江', '鸡西'], ['黑龙江', '双鸭山'], ['黑龙江', '齐齐哈尔'], ['黑龙江', '伊春'], ['黑龙江', '七台河'], ['黑龙江', '鹤岗'], ['黑龙江', '黑河'], ['黑龙江', '绥化'], ['黑龙江', '大兴安岭'], ['湖北', '武汉'], ['湖北', '黄石'], ['湖北', '襄阳'], ['湖北', '荆州'], ['湖北', '宜昌'], ['湖北', '黄冈'], ['湖北', '鄂州'], ['湖北', '孝感'], ['湖北', '荆门'], ['湖北', '咸宁'], ['湖北', '仙桃'], ['湖北', '十堰'], ['湖北', '随州'], ['湖北', '神农架'], ['湖北', '恩施'], ['湖北', '天门'], ['湖北', '潜江']]
```

### 三元表达式

```python
# if else 是三元表达式，在列表生成式中后面的 if 只是个判断
text = '男' if gender == 'male' else '女'

# 生成式中使用
lis = [1,2,3,4]
[x**2 for x in lis if x<3]
[输出：][1, 4]

# 列表生成式中不支持 if else 语句的。
[x**2 for x in lis if x<3 else x**3]
[输出：]
  File "<input>", line 1
    [x**2 for x in lis if x<3 else x**3]
                                 ^
SyntaxError: invalid syntax

# lambda 匿名函数中使用
lis = [1,2,3,4]
list(map(lambda x:x**2 if x<3 else x**3, lis))
[输出：][1, 4, 27, 64]

list(map(lambda x:x**2 if x<3 else None, lis))
[输出：][1, 4, None, None]

#One-Line if Statements
if <expr>: <statement>

if <expr>: <statement>

if <expr>: <statement_1>; <statement_2>; ...; <statement_n>

# Conditional Expressions
<expr1> if <conditional_expr> else <expr2>
>>> age = 12
>>> s = 'minor' if age < 21 else 'adult'
>>> s
'minor'
>>> 'yes' if ('qux' in ['foo', 'bar', 'baz']) else 'no'
'no'
```

## 函数

### 函数的参数

定义函数时，需要确定函数名和参数个数；

如果有必要，可以先对参数的数据类型做检查；

函数体内部可以用 `return` 随时返回函数结果；

函数执行完毕也没有 `return` 语句时，自动 `return None`

函数可以同时返回多个值，但其实就是一个 tuple。

```python
def power(x, n=2):  可以设置默认参数（Default Argument Values）
```

**定义默认参数要牢记一点：默认参数必须指向不变对象！**

```python
def add_end(L=None): 否则多次调用，参数会记住之前的值,不能L=[]
默认参数一定要用不可变对象，如果是可变对象，程序运行时会有逻辑错误！
```

可变参数

```python
def calc(*args): # argsargs 为可变参数，可以输入一个参数，也可以输入多个参数。
 pass

nums = [1, 2, 3]
a = calc(*nums)  # nums 表示把 nums 这个 list 的所有元素作为可变参数传进去。这种写法相当有用，而且很常见。

num = 3
a = calc(num) # 当只传入一个参数时，不加*，即使只有一个元素，函数内部也会组成一个 tuple 来使用。
```

**参数定义的顺序必须是：必选参数（a positional argument）、默认参数、可变参数、命名关键字参数和关键字参数。**

> *args 是可变参数，args 接收的是一个 tuple，传入函数内也是一个元组
>
> **kwargs 是可变关键字参数，kw 接收的是一个 dict。
>
> 可变参数既可以直接传入：func(1, 2, 3)，又可以先组装 list 或 tuple，再通过*args 传入：func(*(1, 2, 3))；
>
> 关键字参数既可以直接传入：func(a=1, b=2)，又可以先组装 dict，再通过  \**kw 传入：func(**{'a': 1, 'b': 2})。
>
> 使用*args 和**kw 是 Python 的习惯写法，当然也可以用其他参数名，但最好使用习惯用法。

4.**关键字参数**

对于`*args`和`**kwargs`参数，函数的调用者可以传入任意不受限制的参数。比如：

```python
def func(*args):
    pass

func("haha", 1, [], {})
func(1,2,3,4,5,6)
```

对于这样的参数传递方式，虽然灵活性很大，但是风险也很大，可控性差，必须自己对参数进行过滤和判定。例如下面我只想要姓名、年龄和性别，就要自己写代码检查：

```python
def student(name, age, **kwargs):
    if 'sex' in kwargs:
        student_sex = kwargs['sex']
```

但是实际上，用户任然可以随意调用函数，比如`student("jack", 18, xxx='male')`，并且不会有任何错误发生。而我们实际期望的是类似`student("jack", 18, sex='male')`的调用。那么如何实现这种想法呢？

可以用关键字参数！关键字参数前面需要一个特殊分隔符`*`和位置参数及默认参数分隔开来，`*`后面的参数被视为关键字参数。在函数调用时，关键字参数必须传入参数名，这和位置参数不同。如果没有传入参数名，调用将报错。不同于默认参数，关键字参数必须传递，但是关键字参数也可以有缺省值，这时就可以不传递了，从而简化调用。

我们把前面的函数改写一下：

```python
def student(name, age, *, sex):
    pass

student(name="jack", age=18, sex='male')
```

注意函数的定义体首行。

如果函数定义中已经有了一个`*args`参数，后面跟着的命名关键字参数就不再需要一个特殊分隔符`*`了。

```python
def student(name, age=10, *args, sex, classroom, **kwargs):
    pass

student(name="jack", age=18, sex='male', classroom="202", k1="v1")
```

Python 的函数参数种类多样、形态多变，既可以实现简单的调用，又可以传入非常复杂的参数。需要我们多下功夫，多写实际代码，多做测试，逐步理清并熟练地使用参数。

### 匿名函数 lambda

简单实现二维数组的查询，类似 Excel 中 `index`  ，`match` 函数类似的效果：

一个很常见的 Excel 表格：

|  班级  | 姓名 | 性别 | 分数 |
| :----: | :--: | :--: | :--: |
| 三年级 |  甲  |  女  |  86  |
| 二年级 |  乙  |  女  |  75  |
| 三年级 |  丙  |  男  |  93  |

找出三年级的所有人的姓名：

```python
lb = [['班级','姓名','性别','分数'],['三年级','甲','女','86'],['二年级','乙','女','75'],['三年级','丙','男','93']]

r = list(filter(lambda x:x, map(lambda x:x[1] if x[0]=='三年级' else False, lb)))
print(f'r 值:{r}')

r1 = [x[1] for x in lb if x[0]=='三年级']
print(f'r1 值:{r1}')

输出：r值:['甲', '丙']
输出：r1值:['甲', '丙']
```

找出第一个符合三年级条件的姓名：

```python
s = list(filter(lambda x:x[0]=='三年级',lb))[0][1]
print(f's 值:{s}')

s1 = [x[1] for x in lb if x[0]=='三年级'][0]
print(f's1 值:{s1}')

输出：s值:甲
输出：s1值:甲
```

判断 `乙` 是否在姓名一列，方法 1：

```python
t = list(filter(lambda x:x[1]=='乙',lb))
t1 = list(filter(lambda x:x[1]=='小名',lb))
t2 = [x for x in lb if x[1]=='乙']  #最简洁的写法

print(f't 值:{t}')
print(f't1 值:{t1}')
print(f't2 值:{t2}')

输出：t值:[['二年级', '乙', '女', '75']]
输出：t1值:[]
输出：t2值:[True]
由于 Python 中，0，None，空的序列[]，{}都是False，所有输出结果可以用来判断。
```

判断 `乙` 是否在姓名一列，方法 2：

```python
q = '乙' in list(map(lambda x:x[1], lb))
q1 = '乙' in [x[1] for x in lb]  #最容易理解的方法

print(f'q 值:{q}')
print(f'q1 值:{q1}')

输出：q值:True
输出：q1值:True
```

总体来看，使用列表生成式比较简单。

还有更简单的 `zip()` 函数。

```python
lb = [['班级','姓名','性别','分数'],['三年级','甲','女','86'],['二年级','乙','女','75'],['三年级','丙','男','93']]

# 找出第一个符合三年级条件的姓名：
l = list(zip(*lb))
[输出：][('班级', '三年级', '二年级', '三年级'), ('姓名', '甲', '乙', '丙'), ('性别', '女', '女', '男'), ('分数', '86', '75', '93')]

l[1][l[0].index('三年级')]
[输出：]'甲'

# 有一共有几个女生
l[2].count('女')
[输出：]2
```

### 内置函数列表

The Python interpreter has a number of functions and types built into it that are always available. They are listed here in alphabetical order.

|                                                              |                                                              | Built-in Functions                                           |                                                              |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| [`abs()`](https://docs.python.org/3/library/functions.html#abs) | [`delattr()`](https://docs.python.org/3/library/functions.html#delattr) | [`hash()`](https://docs.python.org/3/library/functions.html#hash) | [`memoryview()`](https://docs.python.org/3/library/functions.html#func-memoryview) | [`set()`](https://docs.python.org/3/library/functions.html#func-set) |
| [`all()`](https://docs.python.org/3/library/functions.html#all) | [`dict()`](https://docs.python.org/3/library/functions.html#func-dict) | [`help()`](https://docs.python.org/3/library/functions.html#help) | [`min()`](https://docs.python.org/3/library/functions.html#min) | [`setattr()`](https://docs.python.org/3/library/functions.html#setattr) |
| [`any()`](https://docs.python.org/3/library/functions.html#any) | [`dir()`](https://docs.python.org/3/library/functions.html#dir) | [`hex()`](https://docs.python.org/3/library/functions.html#hex) | [`next()`](https://docs.python.org/3/library/functions.html#next) | [`slice()`](https://docs.python.org/3/library/functions.html#slice) |
| [`ascii()`](https://docs.python.org/3/library/functions.html#ascii) | [`divmod()`](https://docs.python.org/3/library/functions.html#divmod) | [`id()`](https://docs.python.org/3/library/functions.html#id) | [`object()`](https://docs.python.org/3/library/functions.html#object) | [`sorted()`](https://docs.python.org/3/library/functions.html#sorted) |
| [`bin()`](https://docs.python.org/3/library/functions.html#bin) | [`enumerate()`](https://docs.python.org/3/library/functions.html#enumerate) | [`input()`](https://docs.python.org/3/library/functions.html#input) | [`oct()`](https://docs.python.org/3/library/functions.html#oct) | [`staticmethod()`](https://docs.python.org/3/library/functions.html#staticmethod) |
| [`bool()`](https://docs.python.org/3/library/functions.html#bool) | [`eval()`](https://docs.python.org/3/library/functions.html#eval) | [`int()`](https://docs.python.org/3/library/functions.html#int) | [`open()`](https://docs.python.org/3/library/functions.html#open) | [`str()`](https://docs.python.org/3/library/functions.html#func-str) |
| [`breakpoint()`](https://docs.python.org/3/library/functions.html#breakpoint) | [`exec()`](https://docs.python.org/3/library/functions.html#exec) | [`isinstance()`](https://docs.python.org/3/library/functions.html#isinstance) | [`ord()`](https://docs.python.org/3/library/functions.html#ord) | [`sum()`](https://docs.python.org/3/library/functions.html#sum) |
| [`bytearray()`](https://docs.python.org/3/library/functions.html#func-bytearray) | [`filter()`](https://docs.python.org/3/library/functions.html#filter) | [`issubclass()`](https://docs.python.org/3/library/functions.html#issubclass) | [`pow()`](https://docs.python.org/3/library/functions.html#pow) | [`super()`](https://docs.python.org/3/library/functions.html#super) |
| [`bytes()`](https://docs.python.org/3/library/functions.html#func-bytes) | [`float()`](https://docs.python.org/3/library/functions.html#float) | [`iter()`](https://docs.python.org/3/library/functions.html#iter) | [`print()`](https://docs.python.org/3/library/functions.html#print) | [`tuple()`](https://docs.python.org/3/library/functions.html#func-tuple) |
| [`callable()`](https://docs.python.org/3/library/functions.html#callable) | [`format()`](https://docs.python.org/3/library/functions.html#format) | [`len()`](https://docs.python.org/3/library/functions.html#len) | [`property()`](https://docs.python.org/3/library/functions.html#property) | [`type()`](https://docs.python.org/3/library/functions.html#type) |
| [`chr()`](https://docs.python.org/3/library/functions.html#chr) | [`frozenset()`](https://docs.python.org/3/library/functions.html#func-frozenset) | [`list()`](https://docs.python.org/3/library/functions.html#func-list) | [`range()`](https://docs.python.org/3/library/functions.html#func-range) | [`vars()`](https://docs.python.org/3/library/functions.html#vars) |
| [`classmethod()`](https://docs.python.org/3/library/functions.html#classmethod) | [`getattr()`](https://docs.python.org/3/library/functions.html#getattr) | [`locals()`](https://docs.python.org/3/library/functions.html#locals) | [`repr()`](https://docs.python.org/3/library/functions.html#repr) | [`zip()`](https://docs.python.org/3/library/functions.html#zip) |
| [`compile()`](https://docs.python.org/3/library/functions.html#compile) | [`globals()`](https://docs.python.org/3/library/functions.html#globals) | [`map()`](https://docs.python.org/3/library/functions.html#map) | [`reversed()`](https://docs.python.org/3/library/functions.html#reversed) | [`__import__()`](https://docs.python.org/3/library/functions.html#__import__) |
| [`complex()`](https://docs.python.org/3/library/functions.html#complex) | [`hasattr()`](https://docs.python.org/3/library/functions.html#hasattr) | [`max()`](https://docs.python.org/3/library/functions.html#max) | [`round()`](https://docs.python.org/3/library/functions.html#round) |                                                              |

更多查看官方文档<https://docs.python.org/3/library/functions.html>

### 递归函数

```python
def fact(n):
    if n==1:
        return 1
    return n * fact(n - 1)

# 递归函数实现斐波那契数列
# 递归函数效率非常低，非必要不使用。计算 40 项耗时 19.2483 秒。
def py_fib_recursive(num: int) -> int:
    if num in (1, 2):
        result = 1
    else:
        result = py_fib_recursive(num - 1) + py_fib_recursive(num - 2)
    return result

# 普通方法，计算 40 项耗时 0.0001 秒。性能差别巨大。
def py_fib_range(num):
    a, b = 1, 1
    for i in range(num - 1):
        a, b = b, a + b
    return a
```

### 高阶函数

map、reduce、filter 高阶函数其实可以用列表生成器替代，更加直观。Guido 在《[The fate of reduce() in Python 3000](http://lambda-the-ultimate.org/node/587)》这篇短文中，提出要一次性移除 reduce()、map()、filter() 以及 lambda。

```python
# map 函数将参数 2 逐次应用于参数 1，返回一个 Iterator
map(str, [1, 2, 3, 4, 5, 6, 7, 8, 9])
# 推导式方法
(str(x) for x in [1, 2, 3, 4, 5, 6, 7, 8, 9])

# filter 依次将参数 2 的元素作用于函数，保留是 True 的元素。用于筛选列表，返回一个 Iterator
filter(lambda x: x % 2 == 0, [1, 2, 4, 5, 6, 9, 10, 15])
# 推导式方法
(x for x in [1, 2, 4, 5, 6, 9, 10, 15] if  x % 2 == 0)

# 给 sorted 传入 key 函数，即可实现忽略大小写的排序
sorted(['bob', 'about', 'Zoo', 'Credit'], key=str.lower)
```

### partial() 偏函数

注意：偏函数会丢失原函数的元信息，所以内部调用可以使用，如果要外部访问的函数，尽量不要使用。

```python
import functools

int2 = functools.partial(int, base=2)  #偏函数
int2('1000000') #int2 函数将 100000 转换为 2 进制。

# 装饰器内部使用，不需要外部使用，可以使用。
def tryer(func=None, *, pause: bool = False, quiet: bool = True):
    if func is None:  # 保证使用 @decorator() 这种方法时不报错
        return functools.partial(tryer, pause=pause, quiet=quiet)

# 需要外部访问的函数，不要使用偏函数，否则丢失元信息。
def info(text: str, title: str = '', expiration_minutes: int = 0) -> int:
    return _toast(text, title, 'Info', expiration_minutes)
```

### zip() 函数

注意：python 3.11 修改了 zip 函数

组合对象。将对象逐一配对。

``` python
list_1 = [1,2,3]
list_2 = ['a','b','c']
s = zip(list_1,list_2)
print(list(s))

运行结果：

[(1, 'a'), (2, 'b'), (3, 'c')]
```

组合 3 个对象：

```python
list_1 = [1, 2, 3, 4]
list_2 = ['a', 'b', 'c', "d"]
list_3 = ['aa', 'bb', 'cc', "dd"]
s = zip(list_1, list_2, list_3)
print(list(s))

运行结果：
[(1, 'a', 'aa'), (2, 'b', 'bb'), (3, 'c', 'cc'), (4, 'd', 'dd')]
```

那么如果对象的长度不一致呢？多余的会被抛弃！以最短的为基础！

```python
list_1 = [1,2,3]
list_2 = ['a','b','c',"d"]
s = zip(list_1,list_2)
print(list(s))
--------------------------------
运行结果：
[(1, 'a'), (2, 'b'), (3, 'c')]
```

### enumerate() 函数

枚举函数，在迭代对象的时候，额外提供一个序列号的输出。注意：`enumerate(li,1)`中的 1 表示从 1 开始序号，默认从 0 开始。注意，第二个参数才是你想要的序号开始，不是第一个参数。

```python
enumerate(iterable, start=0)


dic = {
    "k1":"v1",
    "k2":"v2",
    "k3":"v3",
}

for i, key in enumerate(dic, 1):
    print(i,"\t",key)
```

通常用于对那些无法提供序号的迭代对象使用。但对于字典，依然是无序的。

### all()、any() 函数

all() 函数接收一个可迭代对象，如果对象里的所有元素的 bool 运算值都是 True，那么返回 True，否则 False。不要小瞧了这个函数，用好了，有化腐朽为神奇的特效。

```python
all(iterable)

>>> all([1,1,1])
True
>>> all([1,1,0])
False
```

any() 函数接收一个可迭代对象，如果迭代对象里有一个元素的 bool 运算值是 True，那么返回 True，否则 False。与 all() 是一对兄弟。

```python
any(iterable)

>>> any([0,0,1])
True
>>> any([0,0,0])
False
```

### eval()

将字符串直接解读并执行。例如：`s = "6*8"`，s 是一个字符串，`d = eval(s)`，d 的结果是 48。

```python
eval(expression, globals=None, locals=None)
```

### exec()

执行字符串或 compile 方法编译过的字符串，没有返回值。

```python
exec(object[, globals[, locals]])

>>> exec("print('this is a test')")
this is a test
>>> eval("print('this is a test')")
this is a test
```

### iter()

制造一个迭代器，使其具备 next() 能力。

```python
>>> lis = [1, 2, 3]
>>> next(lis)
Traceback (most recent call last):
  File "<pyshell#8>", line 1, in <module>
    next(lis)
TypeError: 'list' object is not an iterator
>>> i = iter(lis)
>>> i
<list_iterator object at 0x0000000002B4A128>
>>> next(i)
1
```

### pow() 幂函数

幂函数。

```python
>>> pow(3, 2)
9
```

## 迭代（Iteration）

> 默认情况下，dict 迭代的是 key。如果要迭代 value，可以用 for value in d.values()，如果要同时迭代 key 和 value，可以用 for k, v in d.items()。

```python
[d for d in os.listdir('.')] # os.listdir 可以列出文件和目录
[k + '=' + v for k, v in d.items()] #列表生成式也可以使用两个变量来生成 list：
```

在 Python 中，这种一边循环一边计算的机制，称为生成器：`generator`。

要创建一个 generator，有很多种方法。第一种方法很简单，只要把一个列表生成式的 `[]` 改成 `()` ，就创建了一个 `generator`：

```python
g = (x * x for x in range(10)) #g 返回一个生成器

def fib(max):  #函数实现生成器
    n, a, b = 0, 0, 1
    while n < max:
        yield b  #想象成 print(b)，每次计算返回一次 b 的值。
        a, b = b, a + b
        n = n + 1
    return 'done'  #有 yield，return 就没必要了。
```

参考：<https://www.birdpython.com/posts/1/32/>

迭代器总结：

* Python 内置的 int 类型，float 类型，bool 类型，NoneType 类型都不是可迭代的对象，更不是迭代器。
* Python 内置的 str 类型，list 类型，tuple 类型，dict 类型，set 类型都是可迭代的对象，但不是迭代器。
* 可迭代对象（str，list，tuple，dict，set）都可以通过 iter 函数转换为迭代器。
* 一个对象同时有 **iter** 函数和 **next** 函数是迭代器的充分必要条件。也就是说迭代器必须有 **iter** 函数和 **next** 函数，有 **iter** 函数和 **next** 函数的对象都是迭代器（我们在面向对象学习对象）。
* 生成器一定是迭代器，也就说生成器含有 **iter** 函数和 **next** 函数。
* 凡是可作用于 for 循环的对象都是 Iterable 类型；
* 凡是可作用于 next() 函数的对象都是 Iterator 类型，它们表示一个惰性计算的序列；
* Python 的 for 循环本质上就是通过不断调用 next() 函数实现的。
* **迭代器只能 计算一次**，然后前面计算的值就会被清空。也就是说，生成器、生成器表达式、迭代函数创建的迭代器 都只能 被调用计算一次。

## 异常处理：try...except

```python
try:
    print('try...')
    r = 10 / int('2')
    print('result:', r)
except ValueError as e:
    print('ValueError:', e)
except ZeroDivisionError as e:
    print('ZeroDivisionError:', e)
else:
    print('no error!')
finally:
    print('finally...')
print('END')
```

当我们认为某些代码可能会出错时，就可以用`try`来运行这段代码，如果执行出错，则后续代码不会继续执行，而是直接跳转至错误处理代码，即`except`语句块，执行完`except`后，如果有`finally`语句块，则执行`finally`语句块，至此，执行完毕。

此外，如果没有错误发生，可以在`except`语句块后面加一个`else`，当没有错误发生时，会自动执行`else`语句：
