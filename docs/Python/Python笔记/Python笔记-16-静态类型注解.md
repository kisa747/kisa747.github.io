# Python 静态类型注解

## 快速开始

参考：[mypy 文档](https://mypy.readthedocs.io/en/stable/) 、[Python 官方文档：typing—类型注解支持](https://docs.python.org/zh-cn/3/library/typing.html)

Python 是一门动态类型的编程语言。动态类型语言写法灵活，代码简洁，不过随着项目规模变大，人员增多，带来的理解成本，重构难度也不容小觑，导致业界一度有“动态类型一时爽，代码重构火葬场“的说法。

Python 运行时不强制执行函数和变量类型注解，但这些注解可用于类型检查器、IDE、静态检查器等第三方工具。

* 让 mypy 等静态类型检查对代码进行分析，提前找出程序中可能的问题。特别是那些 "把字符串当数字用"，"写错方法名" 等低级错误，都能轻松通过静态分析发现，无须上线运行或编写单元测试。

* 提高代码可读性：变量值是字符串还是数字，不再需要人肉模拟计算机执行来推导得到，直接查看类型注解即可。

* 提高 IDE 自动补全效率：加上类型注解后，IDE 能更精准地预测各场景下可以用来补全的方法名或属性名。

> 注解中直接使用小写 list、tuple、type 等需要 python3.10+
>
> 注解中使用`X | Y`语法的联合运算符，需要 python3.10+
>
> 从 python3.9（[**PEP 585**](https://peps.python.org/pep-0585/)）起，Sequence, Iterator, Callable 等容器的抽象基类需要从 `collections.abc` 导入。
>
> int 是 float 的子类

| Type                | Description                                                      |
|:-------------------:| ---------------------------------------------------------------- |
| `list[str]`         | list of `str` objects                                            |
| `tuple[int, int]`   | tuple of two `int` objects (`tuple[()]` is the empty tuple)      |
| `tuple[int, ...]`   | tuple of an arbitrary number of `int` objects                    |
| `dict[str, int]`    | dictionary from `str` keys to `int` values                       |
| `Iterable[int]`     | iterable object containing ints                                  |
| `Sequence[bool]`    | sequence of booleans (read-only)                                 |
| `Mapping[str, int]` | mapping from `str` keys to `int` values (read-only)              |
| `type[C]`           | type object of `C` (`C` is a class/type variable/union of types) |

## CheetSheet

```python
# 常用的内置类型
x: list[int | float | str | bytes]
# 常用的数据容器
x: list[int]
x: tuple[int]
x: set[int]
x: set[int]
x: dict[int]

# 2 个元素，第一个整数、第二个字符串
x: tuple[int, str] = (1, 'a')
# 单个元素，整数或字符串
x: tuple[int | str] = (1, )
# 任意多元素，整数或字符串
x: tuple[int | str, ...] = ('a', 1, 'b', 'c', 3)

# list 这三种写法效果一样。都表示：任意多元素，整数或字符串
# 一般采用第一种写法
x: list[int, str] = [1, 'a', 2, 'c', 'd']
x: list[int | str] = [1, 'a', 2, 'c', 'd']
x: list[int | str, ...] = [1, 'a', 2, 'c', 'd']

from typing import Optional, Any, Final, Literal
from collections.abc import Sequence, Iterator, Callable, Generator

# Optional[X] is the same as X | None or Union[X, None]
# Optional 仅接受一个参数
x: Optional[str] = "something"

# 任意类型
x: Any

# 指定的参数
x: Literal['html', 'plain'] = 'html'

# yield 生成器返回可迭代对象 Iterator
def g(n: int) -> Iterator[int]:
    i = 0
    while i < n:
        yield i
        i += 1
# This is how you annotate a callable (function) value
# 第一个参数为整数或浮点数，第二个参数为浮点数的可调用对象
x: Callable[[int, float], float] = f

# 类
x: type[Wrapper]


# 鸭子类型，Sequence 表示可以序列化对象（可以下标访问、可以切片访问），比如：list、tuple、str
# 做注解时，基本表示 list 或 tuple，与 list 使用方法一致
# Sequence 仅接受一个参数
x: Sequence[int] = [3, 4]

# 不可更改的常量
PI: Final = 3.1415926
```

## 其他的类型注解

### 容器抽象基类

list、dict、set 等用于注解返回类型，注解参数时，最好使用 Sequence 或 Iterable 等抽象容器类型。

```python
# Python 内置的 str 类型，list 类型，tuple 类型，dict 类型，set 类型都是可迭代的对象，但不是迭代器。

list tuple -> Sequence -> Collection -> Iterable
dict  ->  Mapping -> Collection -> Iterable
set  -> Set -> Collection -> Iterable
```

### 重载 @overload

`@overload` 装饰器可以修饰支持多个不同参数类型组合的函数或方法。

重载是允许修改输入和输出，即同一个方法名可以支持多种类型的输入和输出。

```python
# 函数 process 输入不同参数，输出类型不同。
# 输入 None，返回 None
# 输入 int，返回 tuple[int, str]
# 输入 bytes，返回 str

from typing import overload

@overload
def process(response: None) -> None:
    ...
@overload
def process(response: int) -> tuple[int, str]:
    ...
@overload
def process(response: bytes) -> str:
    ...


def process(response):
    <actual implementation>
```

### 泛型 TypeVar

如果是简单的重载，可以优雅地使用 TypeVar：同一时刻，同一类型。

```python
from typing import TypeVar, overload

@overload
def add(a: str, b: str) -> str:
    ...

@overload
def add(a: int, b: int) -> int:
    ...

def add(a, b):
    return a + b

# 可以优雅地替换成 TypeVar
T = TypeVar('T', int, str)


def add(a: T, b: T) -> T:
    return a + b
```

### 最终限定符 @final

告知类型检查器被装饰的方法不能被覆盖，且被装饰的类不能作为子类的装饰器，例如：

```python
from typing import final

class Base:
    @final
    def done(self) -> None:
        ...
class Sub(Base):
    def done(self) -> None:  # Error reported by type checker
        ...

@final
class Leaf:
    ...
class Other(Leaf):  # Error reported by type checker
    ...
```

## mypy 工具

```sh
# 提示 Library stubs not installed for "requests"
# 方法 1：忽略所有第三方库缺失的 types 包，在配置文件 pyproject.toml 中添加以下内容：
[tool.mypy]
no_site_packages = true
# 方法 2：安装所有缺失的 types 包
mypy --install-types

# 不想检查的地方标记
# type: ignore

# 定义一个空的 序列、collections（集合）全局变量，需要类型注解
PROXY_LIST: deque[dict[str, str]] = deque()
a: list[str] = []
a: list = []
```

### mypy 严格模式

参考：<https://blog.wolt.com/engineering/2021/09/30/professional-grade-mypy-configuration/>

```toml
# pyproject.toml
[tool.mypy]

# 强制所有函数/方法的参数、返回值使用类型注解
disallow_untyped_defs = true
# 定义一个空的序列，需要类型注解
check_untyped_defs = true
# Disallows usage of types that come from unfollowed imports
# (anything imported from an unfollowed import is automatically given a type of Any).
disallow_any_unimported = true
# 设置注解 arg: str = None 也报错
no_implicit_optional = true
# 设置函数返回 Any 也报错
warn_return_any = true
# 显示错误代码
show_error_codes = true
# 提示哪里使用了 # type: ignore
warn_unused_ignores = true
```
