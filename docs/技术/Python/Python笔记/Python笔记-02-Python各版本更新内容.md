# Python 各版本更新内容

Python 各版本更新内容

## python3.13 新功能

* 实验性无 GIL 线程支持 (Free-threaded CPython)
* 实验性 JIT 编译器
* 交互式解释器革新
* 错误信息优化
* 对 `locals()` 的定义性修改语义
* 移动平台支持。**PEP 730** 将 iOS 提升为官方支持的平台，**支持级别为 3 级**。**PEP 738** 将 Android 提升为官方支持的平台，**支持级别为 3 级**。
* 版本发布计划变更。Python 3.13 及更高版本有两年的完整支持，随后是三年的安全修复。

## python3.12 新功能

* 更灵活的 f 字符串解析，允许许多以前不允许的事情。
* 支持 Python 代码中的缓冲区协议。
* 新的调试/分析 API。
* 支持具有单独全局解释器锁的隔离子解释器。
* 改进了错误消息。现在，可能由拼写错误引起的更多异常会向用户提出建议。
* 支持 Linux `perf` 探查器在跟踪中报告 Python 函数名称。

总体来说整个 Python 的性能提升 5%。

## python3.11 新功能

1、比上一个版本快 60%，更快的程序启动速度。

2、改进的错误提示 `Error Tracebacks`。

3、改进的类型变量，Python 是一种动态类型语言，但它通过可选的类型提示支持静态类型。Python 静态类型系统的基础在 2015 年的 PEP 484 中定义。自 Python 3.5 以来，每个 Python 版本都引入了几个与类型相关的新提案。Python 3.11 发布了 5 个与类型相关的 PEP，创下新高：

这个 5 个 PEP 提案内容参考：<https://zhuanlan.zhihu.com/p/580441695>

* PEP 646: 可变泛型（Variadic Generics）
* PEP 655: 根据需要或可能丢失的情况标记单个 TypedDict 项
* PEP 673: `Self` 类型
* PEP 675: 任意文字字符串类型
* PEP 681: 数据类转换

类型提示可以使用 `Self`

```python
from typing import Self
class MyLock:
    def __enter__(self) -> Self:
        self.lock()
        return self
```

4、支持 TOML 配置解析，即 `tomllib` 标准库。

```python
try:
    import tomllib
except ModuleNotFoundError:
    import tomli as tomllib

toml_str = """
python-version = "3.11.0"
python-implementation = "CPython"
"""

data = tomllib.loads(toml_str)
```

5、异常组。抛出和处理多个异常

```python
try:
    raise ExceptionGroup("eg",
        [ValueError(1), TypeError(2), OSError(3), OSError(4)])
except* TypeError as e:
    print(f'caught {type(e)} with nested {e.exceptions}')
except* OSError as e:
    print(f'caught {type(e)} with nested {e.exceptions}')
```

## python3.10 新功能

1. 优化错误信息

2. 类型注解中引入了 `X | Y` 语法的联合运算符

参考：<https://www.cnblogs.com/dongfangtianyu/p/14713895.html>

这个新增语法也被接受作为 `isinstance()` 和 `issubclass()` 的第二个参数：

```python
def square(number: int | float) -> int | float:
    return number ** 2

isinstance(1, int | str)
```

3. 多行上下文管理器，在多行中使用多个`with`语句

```python
with (
    open("test.txt", "r") as f,  # 打开第一个文件
    open("test_copy.txt", "w") as f_copy,  # 打开第二个文件
):
    content = f.read()  # 从第一个文件获取内容
    f_copy.write(content)  # 向第二个文件写入内容
```

4. 结构模式匹配 (Structural Pattern Matching)

match、case 语法

```python
today = 1
match  today:
    case 0:
        day = "星期天"
    case 1:
        day = "星期一"
    case 2:
        day = "星期二"
    case 3:
        day = "星期三"
    case 4:
        day = "星期四"
    case 5:
        day = "星期五"
    case 6:
        day = "星期六"
    case _:
        day = "别闹...一个星期只有七天"

print(day)
```

5. zip() 函数支持长度检查

上面的例子有一个特点：`name_list` 和 `number_list` 长度是相同的，如果长度不同会怎么样呢？

```python
name_list = ['报警', '急救', '消防', '查号']
number_list = [110, 120, 119]

for i in zip(name_list, number_list):
    print(i)
[out]:
('报警', 110)
('急救', 120)
('消防', 119)
```

注意：因为长度不同，所以最后一组结果`查号`是不会显示的，但是却没有任何提示，从结果来看，无法判断是否有遗漏的数据。

在 Python 3.10，可以给 zip() 传递参数`strict=True`,对长度进行严格检查

```python
>>> for i in zip(name_list, number_list, strict=True):
>>>     print(i)

('报警', 110)
('急救', 120)
('消防', 119)
Traceback (most recent call last):
  File "C:\Users\san\PycharmProjects\py310\a.py", line 4, in <module>
    for i in zip(name_list, number_list, strict=True):
ValueError: zip() argument 2 is shorter than argument 1

# 注意：zip 的第二个参数比第一个参数短，于是抛出异常
```

## python3.9 新功能

参考：<https://docs.python.org/zh-cn/3.9/whatsnew/3.9.html>

1. 字典合并与更新运算符：合并 (`|`) 与更新 (`|=`) ，更新与 `upadate` 方法一致，也是就地更新，返回 `None`。

```python
# 合并 (|) 与更新 (|=) 运算符已被加入内置的 dict 类。
# 它们为现有的 dict.update 和 {**d1, **d2} 字典合并方法提供了补充。
d = {'spam': 1, 'eggs': 2, 'cheese': 3}
e = {'cheese': 'cheddar', 'aardvark': 'Ethel'}
# | 运算符相当于 Merge 合并，等价于 a = {**d, **e}
d | e
{'spam': 1, 'eggs': 2, 'cheese': 'cheddar', 'aardvark': 'Ethel'}
d
{'spam': 1, 'eggs': 2, 'cheese': 3}
a = d | e
a
{'spam': 1, 'eggs': 2, 'cheese': 'cheddar', 'aardvark': 'Ethel'}
a = {**d, **e}
a
{'spam': 1, 'eggs': 2, 'cheese': 'cheddar', 'aardvark': 'Ethel'}

# |= 运算符相当于 update 更新，等价于 d.update(e)
d |= e
d
{'spam': 1, 'eggs': 2, 'cheese': 'cheddar', 'aardvark': 'Ethel'}
```

2. 新增用于移除前缀和后缀的字符串方法 `str.removeprefix(prefix)` 和 `str.removesuffix(suffix)`

```python
string = 'helloworld'
string.removeprefix('hello')
[Out:]'world'
string.removesuffix('world')
[Out:]'hello'
```

3. `__file__` 属性将是一个绝对路径。Python 现在会获取命令行中指定的脚本文件名 (例如：`python3 script.py`) 的绝对路径： `__main__` 模块的 `__file__` 属性将是一个绝对路径，而不是相对路径。

## python3.8 新功能

参考：<https://docs.python.org/zh-cn/3.8/whatsnew/3.8.html>

1. 赋值表达式（海象运算符）。新增的语法 `:=` 可在表达式内部为变量赋值。它被昵称为“海象运算符”因为它很像是 [海象的眼睛和长牙](https://en.wikipedia.org/wiki/Walrus#/media/File:Pacific_Walrus_-_Bull_(8247646168).jpg)。

```python
# 在这个示例中，赋值表达式可以避免调用 len() 两次：
if (n := len(a)) > 10:
    print(f"List is too long ({n} elements, expected <= 10)")
```

2. `f-string` 支持 `=` 用于自动记录表达式和调试文档

```python
# 增加 = 说明符用于 f-string。形式为 f'{expr=}' 的 f-字符串将扩展表示为表达式文本，加一个等于号，再加表达式的求值结果。例如：
user = 'eric_idle'
member_since = date(1975, 7, 31)
f'{user=} {member_since=}'
[Out:]
"user='eric_idle' member_since=datetime.date(1975, 7, 31)"
```

## python3.7 新功能

新的语法特性：

* [PEP 563](https://docs.python.org/zh-cn/3.7/whatsnew/3.7.html#whatsnew37-pep563)，类型标注延迟求值。

向后不兼容的语法更改：

* [`async`](https://docs.python.org/zh-cn/3.7/reference/compound_stmts.html#async) 和 [`await`](https://docs.python.org/zh-cn/3.7/reference/expressions.html#await) 现在是保留的关键字。

新的库模块：

* [`contextvars`](https://docs.python.org/zh-cn/3.7/library/contextvars.html#module-contextvars): [PEP 567 -- 上下文变量](https://docs.python.org/zh-cn/3.7/whatsnew/3.7.html#whatsnew37-pep567)
* [`dataclasses`](https://docs.python.org/zh-cn/3.7/library/dataclasses.html#module-dataclasses): [PEP 557 -- 数据类](https://docs.python.org/zh-cn/3.7/whatsnew/3.7.html#whatsnew37-pep557)
* [importlib.resources](https://docs.python.org/zh-cn/3.7/whatsnew/3.7.html#whatsnew37-importlib-resources)

新的内置特性：

* [PEP 553](https://docs.python.org/zh-cn/3.7/whatsnew/3.7.html#whatsnew37-pep553), 新的 [`breakpoint()`](https://docs.python.org/zh-cn/3.7/library/functions.html#breakpoint) 函数。

## python3.6 新功能

参考：<https://docs.python.org/zh-cn/3.6/whatsnew/3.6.html>

* 从 Python3.6 开始，字典是有序的！它将保持元素插入时的先后顺序！请务必清楚！
* F string 新的字符格式化语法，PEP 498，python3.6 的新功能。

```python
name = "Eric"
age = 74
r = f"Hello, {name}. You are {age}."
```

* 数字中允许有下划线

```python
>>> 1_000_000_000_000_000
1000000000000000
>>> 0x_FF_FF_FF_FF
4294967295
```
