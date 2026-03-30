# 测试框架

## unittest 单元测试

参考：<https://docs.python.org/zh-cn/3/library/unittest.html>

unittest 单元测试是 python 标准库，当测试内容较简单时，可以考虑使用。

```python
import unittest

class TestPyexcel(unittest.TestCase):
    def setUp(self):
        self.ex = Excel(r"E:\test\pyexcel\Excel\test.xls")

    def test_excel_to_xlsx(self):
        self.ex.to_xlsx(r"E:\test\pyexcel\Excel\test_xlsx.xlsx")

    def tearDown(self):
        self.ex.close()

if __name__ == '__main__':
    unittest.main()
```

### unittest 常用断言

```python
self.assertEqual(value_expected, value_test)  # 预期值，实际值
self.assertNotEqual(value_expected, value_test)
self.assertTrue(True)
self.assertFalse(False)
with self.assertRaises(SomeException):
    do_something()
```

## pytest 测试框架

参考：[pytest 官方文档](https://docs.pytest.org/en/latest/)

[从零开始学自动化测试](https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzI5ODU1MzkwMA==&action=getalbum&album_id=1500392973518323716&scene=173&from_msgid=2247491358&from_itemidx=1&count=3&nolastread=1#wechat_redirect)

`pytest` 是一个广泛使用的测试框架，众多的开源社区采用了 pytest，比如：[black](https://github.com/psf/black) 、[tox](https://github.com/tox-dev/tox)、[requests](https://github.com/psf/requests)、[pandas](https://github.com/pandas-dev/pandas) ，可以参考他们的用法及配置。Pycharm 支持 pytest 测试框架。

### 安装 pytest

```sh
python -m pip install -U pytest
```

### 编写用例规则

编写 pytest 测试样例非常简单，只需要按照下面的规则：

- 测试文件以 `test_`开头（以 `_test` 结尾也可以）
- 测试类以 `Test` 开头，并且不能带有 `__init__` 方法
- 测试函数以 `test_` 开头
- 所有的包 Package 必须要有 `__init__.py` 文件
- 断言使用基本的 `assert` 即可

`fixture` 是 pytest 的灵魂。尽量不使用 `setup` 方法，而是使用 `fixture` 方法。

多个测试可以合并到一个类里，即使如此，前置动作、后置动作、共享数据，也建议使用 `fixture` 。

```python
import pytest

class TestAbc:
    @pytest.fixture()
    def before(self):
        print("------->before")
        dic = {'name': 'john', 'age': 18}
        return dic

    # test_a 方法传入了被 fixture 标识的函数，以变量的形式
    def test_a(self, before):
        print(f"------->test_fixture1，名字是：{before['name']}")
        assert 1
```

### 运行测试用例

1. 直接运行测试文件，py 文件下方添加： `pytest.main([str(Path(__file__))])`
2. 用 `pytest` 命令运行测试
    - `pytest` 不带参数，运行所有测试。
    - `pytest test_some.py`，测试指定文件
    - `pytest tests`，测试指定目录
3. pycharm、VSCode 下调用 pytest 调试、运行。

#### pycharm 下使用 pytest

默认情况下，PyCharm 使用 ` assert 实际值 == 预期值 ` 的断言顺序，参考：[PyCharm 文档](https://www.jetbrains.com/zh-cn/help/pycharm/2025.1/pytest.html)。

pycharm 下调用 pytest 调试，行为与直接使用 pytest 有差异。

- pycharm 下最后一个测试标记为跳过的化，显示会紊乱。
- pycharm 下添加 `--color=yes` 参数，控制台才能显示彩色。不要在 `pyproject.toml` 配置文件中添加此参数，否则 VSCode 下输出乱码。

#### VSCode 下使用 pytest

- 右键 `Run Python File in Terminal`，注意不能使用相对引用，所以推荐将测试文件与程序源码分开，放到项目下 `tests` 目录内。测试文件底部包含以下代码：

```python
if __name__ == '__main__':
    pytest.main(Path(__file__))
```

- 点击左边侧边栏 `测试` ，选中要测试的文件或目录，运行测试。可以使用相对引用，需要在 输出 - Python Test Log 中查看输出内容。

### 运行结果

- `passed` 测试通过
- `failed` 测试失败，断言失败
- `error` fixture 中断言失败，或是测试代码中的其他错误。
- `skiped` 标记为 skip 或 skipif 的测试用例。
- `xfailed` 标记 `xfail` 的用例失败。
- `xpassed` 标记 `xfail` 的用例成功。严格来说，既然我们已经标记了预期失败，他就应该失败才符合预期。因此`xfail` 有个 `strict` 参数，设置为 `True` 时，运行成功会显示 `failed` 。

### 配置文件

pytest 支持 python 标准的 `pyproject.toml` 配置文件。

```toml
# pyproject.toml
# pytest 配置
[tool.pytest.ini_options]
# 运行参数
# addopts = "-ra -q --strict-config --strict-markers --cov --cov-report html"
# --cov --cov-report html  测试代码覆盖率，生成 html 报告
# -rs    显示额外的信息 (f)ailed, (E)rror, (s)kipped, (x)failed, (X)passed, (p)assed,
# (P)assed with output, (a)ll except passed (p/P), or (A)ll.
# (w)arnings are enabled by default (see --disable-warnings),
# 'N' can be used to reset the list.
# (default: 'fE').
# --strict-config  严格模式
# --strict-markers 只要出现配置文件 markers 部分未包含的 marker，都抛出错误
# -p no:faulthandler    消除 Windows fatal exception: code 0x800706be 错误提示
# 参考：https://docs.pytest.org/en/stable/how-to/failures.html#fault-handler
# -s --capture=no  显示程序中的 print/logging 输出
# -x, --exitfirst  遇到错误或失败立即退出
# -v, --verbose    报告模式：Increase verbosity
# --color=yes      让 pycharm 控制台也显示彩色
addopts = "-s -x -p no:faulthandler"
# 源码目录，即添加路径至 sys.path，避免 import 找不到包。
pythonpath = "src"
# 测试目录
testpaths = ["src", "scripts"]
# 配置控制台 logging 日志
junit_logging = "all"
log_cli = true
log_cli_level = 'INFO'
log_cli_format = '[%(levelname)s]: %(message)s'
log_cli_date_format = '%Y-%m-%d %H:%M:%S'
```

### 常用的断言

```python
assert True              # 判断 xx 为真
assert not False         # 判断 xx 不为真
assert 'a' in 'abc'      # 判断 b 包含 a
assert 'a' not in 'abc'  # 判断 b 不包含 a
assert 1 == 1      # 判断 a 等于 b       pycharm 下默认是：预期值 == 实际值
assert 1 != 2      # 判断 a 不等于 b
assert 2 >= 1      # 判断 a 大于等于 b
assert 1 <= 2      # 判断 a 小于等于 b
assert 2 > 1       # 判断 a 大于 b
assert 1 < 2       # 判断 a 小于 b
assert True is True
assert False is not True

# 还可以在条件中加上 or、and、all、any 的条件
assert all(fruit.cubed for fruit in fruit_salad.fruit)
```

### 参数化 parametrize

```python
import pytest

@pytest.mark.parametrize(
    'param,expect', [(True, '\n\n天 八 词\n\n是 指\n\n'), (False, '\n天 八 词\n是 指\n')]
)
def test_strim_no_blank_line(param, expect):
    text = '\n\n\n天\u3000\u3000\u3000\u3000 八\xa0\xa0\xa0 词\n\n\n\r\r\r是\t\t\t\t指\n\n\n'
    value_test = alpha.utils.strim(text, keep_one_blank_line=param)
    logging.info(f'{value_test=}')
    assert value_test == expect
```

#### 标记预期失败

使用 `pytest.mark.xfail` 标记，预期测试用例失败，结果显示 `xfailed`，而不是 `failed` ；如果运行成功，结果显示 `xpassed` 。

```python
pytest.mark.xfail(condition=None, *, reason=None, raises=None, run=True, strict=False)
```

如果设置 `strict=True` ，如果运行成功，结果显示 `failed` 。

如果参数 `condition` 为布尔值，那么必须设置 `reason` 参数。

```python
def add(a: int, b: int) -> int:
    return a + b

# 标记预期失败
@pytest.mark.parametrize(
    'a,b,expected',
    [
        (1, 2, 3),
        # 标记为失败，marks=pytest.mark.xfail 后面可以不带括号，也可以带括号。
        pytest.param(2, 3, 6, marks=pytest.mark.xfail),
        # 标记为失败，marks=pytest.mark.xfail 可以标记预计的异常类。
        pytest.param('1', 3, 4, marks=pytest.mark.xfail(raises=TypeError)),
        # 标记为指定条件下失败
        pytest.param(
            1,
            3,
            5,
            marks=pytest.mark.xfail(
                platform.system() == 'Windows', reason='在 Linux 系统下执行此用例'
            ),
        ),
        # 标记为指定条件下跳过
        pytest.param(
            1,
            3,
            5,
            marks=pytest.mark.skipif(
                platform.system() == 'Windows', reason='在 Linux 系统下执行此用例'
            ),
        ),
    ],
)
def test_add1(a, b, expected):
    value_test = add(a, b)
    assert expected == value_test  # 预期值，实际值
```

#### 组合参数

```python
# 组合参数，生成 n*n 种组合，但是很难管理预期值。
@pytest.mark.parametrize('a', [1, 2, 3])
@pytest.mark.parametrize('b', [4, 5, 6])
def test_add2(a, b):
    value_test = add(a, b)
```

### 前后置操作

**不推荐使用，建议使用 fixture 方法。**

unittest 单元测试中有 `setUp`、`tearDown` 来前置操作和后置操作、共享变量，pytest 框架也有类似于 setup 和 teardown 的语法。

- 模块级（setup_module/teardown_module）开始于模块始末，全局的
- 函数级（setup_function/teardown_function）只对函数用例生效（不在类中）
- 类级（setup_class/teardown_class）只在类中前后运行一次 (在类中)
- 方法级（setup_method/teardown_method）开始于方法始末（在类中）
- 类里面的（setup/teardown）运行在调用方法的前后

#### 函数级、模块级

```python
#  函数级模块级.py
import pytest


def setup_module():
    print("setup_module：整个.py 模块只执行一次")
    print("比如：所有用例开始前只打开一次浏览器")

def teardown_module():
    print("teardown_module：整个.py 模块只执行一次")
    print("比如：所有用例结束只最后关闭浏览器")

def setup_function():
    print("setup_function：每个用例开始前都会执行")

def teardown_function():
    print("teardown_function：每个用例结束前都会执行")

def test_one():
    print("正在执行----test_one")
    x = "this"
    assert 'h' in x

def test_two():
    print("正在执行----test_two")
    x = "hello"
    assert 'h' in x


if __name__ == "__main__":
    pytest.main(["-s"])
```

测试结果：

```python
============================= test session starts =============================
collecting ... collected 2 items

模块级.py::test_one setup_module：整个.py模块只执行一次
比如：所有用例开始前只打开一次浏览器
setup_function：每个用例开始前都会执行
正在执行----test_one
PASSEDteardown_function：每个用例结束前都会执行

模块级.py::test_two setup_function：每个用例开始前都会执行
正在执行----test_two
PASSEDteardown_function：每个用例结束前都会执行
teardown_module：整个.py模块只执行一次
比如：所有用例结束只最后关闭浏览器


============================== 2 passed in 0.01s ==============================

进程已结束,退出代码0
```

#### 类和方法

`setup_method/setup_method` 和 unittest 里面的 `setup/teardown` 是一样的功能。

`setup_class` 和 `teardown_class` 等价于 unittest 里面的 setupClass 和 teardownClass。

>参考：<https://docs.pytest.org/en/stable/deprecations.html#setup-teardown>
>
>方法级应使用 pytest 原生的方法： `setup_method/teardown_method`，不应使用 `setup/teardown` 。
>
>同时使用 `setup_method/teardown_method` 和`setup/teardown` ，`setup/teardown` 会被屏蔽。

```python
#  类和方法.py
import pytest


class TestCase:
    def setup(self):
        self.name = 'test'
        print("setup: 每个用例开始前执行")

    def teardown(self):
        self.name = 'test'
        print("teardown: 每个用例结束后执行")

    def setup_class(self):
        self.name = 'test'
        print("setup_class：所有用例执行之前")

    def teardown_class(self):
        self.name = 'test'
        print("teardown_class：所有用例执行之后")

    def setup_method(self):
        self.name = 'test'
        print("setup_method:  每个用例开始前执行")

    def teardown_method(self):
        self.name = 'test'
        print("teardown_method:  每个用例结束后执行")

    def test_one(self):
        print("正在执行----test_one")
        x = "this"
        assert 'h' in x

    def test_two(self):
        print("正在执行----test_two")
        x = "hello"
        assert 'h' in x


if __name__ == "__main__":
    pytest.main(["-s"])
```

测试结果：

```python
============================= test session starts =============================
collecting ... collected 2 items

类和方法.py::TestCase::test_one setup_class：所有用例执行之前
setup_method:  每个用例开始前执行
正在执行----test_one
PASSEDteardown_method:  每个用例结束后执行

类和方法.py::TestCase::test_two setup_method:  每个用例开始前执行
正在执行----test_two
PASSEDteardown_method:  每个用例结束后执行
teardown_class：所有用例执行之后


============================== 2 passed in 0.01s ==============================

进程已结束,退出代码0
```

#### 函数和类混合

如果一个.py 的文件里面既有函数用例又有类和方法用例

```python
#  函数和类混合.py
import pytest


def setup_module():
    print("setup_module：整个.py 模块只执行一次")
    print("比如：所有用例开始前只打开一次浏览器")


def teardown_module():
    print("teardown_module：整个.py 模块只执行一次")
    print("比如：所有用例结束只最后关闭浏览器")


def setup_function():
    print("setup_function：每个用例开始前都会执行")


def teardown_function():
    print("teardown_function：每个用例结束前都会执行")


def test_one():
    print("正在执行----test_one")
    x = "this"
    assert 'h' in x


def test_two():
    print("正在执行----test_two")
    x = "hello"
    assert 'h' in x


class TestCase:
    def setup_class(self):
        self.name = 'test'
        print("setup_class：所有用例执行之前")

    def teardown_class(self):
        self.name = 'test'
        print("teardown_class：所有用例执行之前")

    def test_three(self):
        print("正在执行----test_three")
        x = "this"
        assert 'h' in x

    def test_four(self):
        print("正在执行----test_four")
        x = "hello"
        assert 'h' in x


if __name__ == "__main__":
    pytest.main(["-s"])
```

测试结果：

```python
============================= test session starts =============================
collecting ... collected 4 items

函数和类混合.py::test_one setup_module：整个.py模块只执行一次
比如：所有用例开始前只打开一次浏览器
setup_function：每个用例开始前都会执行
正在执行----test_one
PASSEDteardown_function：每个用例结束前都会执行

函数和类混合.py::test_two setup_function：每个用例开始前都会执行
正在执行----test_two
PASSEDteardown_function：每个用例结束前都会执行

函数和类混合.py::TestCase::test_three setup_class：所有用例执行之前
正在执行----test_three
PASSED
函数和类混合.py::TestCase::test_four 正在执行----test_four
PASSEDteardown_class：所有用例执行之前
teardown_module：整个.py模块只执行一次
比如：所有用例结束只最后关闭浏览器


============================== 4 passed in 0.02s ==============================

进程已结束,退出代码0
```

从运行结果看出，`setup_module/teardown_module` 的优先级是最大的，然后函数里面用到的`setup_function/teardown_function` 与类里面的 `setup_class/teardown_class` 互不干涉。

### 夹具 fixture

pytest 的核心就是 fixture 夹具。

firture 相对于 setup 和 teardown 来说应该有以下几点优势

- 命名方式灵活，不局限于 `setup` 和 `teardown` 这几个命名
- `conftest.py` 配置里可以实现数据共享，不需要 `import` 就能自动找到一些配置
- `scope='module'` 可以实现多个 `.py` 跨文件共享前置
- `scope='session'` 以实现多个 `.py` 跨文件使用一个 session 来完成多个用例
- 一个 `fixture` 可以应用于多个函数、类等
- 一个函数、类可以使用多个 `fixture`
- 函数、方法、类、模块、会话都可以灵活使用清理动作（teardown）

```python
# fixture 的参数
fixture(scope="function", params=None, autouse=False, ids=None, name=None)
```

#### 调用 fixture 的三种方法

平常写自动化用例会写一些前置的 fixture 操作，用例需要用到就直接传该函数的参数名称就行了。当用例很多的时候，每次都传这个参数，会比较麻烦。fixture 里面有个参数 autouse，默认是 Fasle 没开启的，可以设置为 True 开启自动使用 fixture 功能，这样用例就不用每次都去传参了。

- 函数或类里面方法直接传 fixture 的函数参数名称，可以使用返回值。
- 使用装饰器 `@pytest.mark.usefixtures()` 修饰，如果 fixture 有返回值，那么 usefixture 就无法获取到返回值，这个是装饰器 usefixture 与用例直接传 fixture 参数的区别。当 fixture 需要用到 return 出来的参数时，只能讲参数名称直接当参数传入，不需要用到 return 出来的参数时，两种方式都可以。
- `autouse=True` 自动使用

fixture 里面的 teardown 用 `yield` 来唤醒 teardown 的执行。

#### fixture 的作用域

| scope 参数 |                           作用范围                           |  备注  |
| :--------: | :----------------------------------------------------------: | :----: |
| `function` |               每个测试用例来之前、之后运行一次               | 默认值 |
|  `class`   | 如果一个 class 里面有多个用例，都调用了此 fixture，那么此 fixture 只在该 class 里所有用例开始前执行一次 |        |
|  `module`  |         在当前`.py`脚本里面所有用例开始前只执行一次          |        |
| `session`  |                       本次测试运行一次                       |        |

#### 简单的 fixture

实现场景：用例 1 需要先登录，用例 2 不需要登录，用例 3 需要先登录

```python
# test_fixture.py
import pytest

# 不带参数时默认 scope="function"
@pytest.fixture
def login():
    print("输入账号，密码先登录")
    dic = {'name': 'john', 'age': 20}
    return dic


def test_s1(login):
    print(f"用例 1：登录之后，姓名为：{login['name']}")


def test_s2():  # 不传 login
    print("用例 2：不需要登录，操作 2")


# 使用 usefixture 无法获取到返回值
@pytest.mark.usefixtures("login")
def test_s3():
    print(f"用例 3：登录之后，fixture 为：{login}")


if __name__ == "__main__":
    pytest.main(["-s"])
```

运行结果：

```sh
============================= test session starts =============================
collecting ... collected 3 items

夹具.py::test_s1 输入账号，密码先登录
用例1：登录之后，姓名为：john
PASSED
夹具.py::test_s2 用例2：不需要登录，操作2
PASSED
夹具.py::test_s3 输入账号，密码先登录
用例3：登录之后，fixture为：<function login at 0x000002087592F7F0>
PASSED

============================== 3 passed in 0.01s ==============================

进程已结束,退出代码0
```

如果 `@pytest.fixture()` 里面没有参数，那么默认 `scope='function'` ，也就是此时的级别的 function，针对函数有效。

#### 类中使用 fixture

一个 class 里面多个用例都调用了此 fixture，那么只在 class 里所有用例开始前执行一次。

|  前置/后置方法   |           fixture 写法           |
| :--------------: | :------------------------------: |
| `setup_class()`  | `@pytest.fixture(scope='class')` |
| `setup_method()` |        `@pytest.fixture`         |
|   `teardown_*`   |             `yield`              |

作用与类时，不共享变量的话，可以使用 `usefixtures` 方法。

```python
import pytest

# 不共享变量的话，可以使用 usefixtures 方法
# @pytest.mark.usefixtures('set_abc')
class TestAbc:
    @pytest.fixture(scope='class')
    def set_abc(self):
        logging.info("set_abc --> before")
        dic = {'name': 'john'}
        yield dic
        logging.info("set_abc --> 清理")

    @pytest.fixture
    def set_test(self):
        logging.info("set_test --> before")
        dic = {'age': 18, 'gender': 'male'}
        return dic

    # test_a 方法传入了被 fixture 标识的函数，以变量的形式
    def test_fixture1(self, set_test):
        logging.info(f"test_fixture1，姓名是：{set_abc['name']}，年龄是：{set_test['age']}")
        assert 1

    def test_fixture2(self, set_test):
        logging.info(f"test_fixture2，姓名是：{set_abc['name']}，性别是：{set_test['gender']}")
        assert 1

if __name__ == "__main__":
    pytest.main()
```

运行结果：

```python
------------------------------------ live log setup -------------------------------------
[INFO]: set_abc --> before
[INFO]: set_test --> before
------------------------------------- live log call -------------------------------------
[INFO]: test_fixture1，姓名是：john，年龄是：18
PASSED
test.py::TestAbc::test_fixture2
------------------------------------ live log setup -------------------------------------
[INFO]: set_test --> before
------------------------------------- live log call -------------------------------------
[INFO]: test_fixture2，姓名是：john，性别是：male
PASSED
----------------------------------- live log teardown -----------------------------------
[INFO]: set_abc --> 清理


=================================== 2 passed in 0.13s ===================================
```

#### 设置 autouse=True

autouse 设置为 True，自动调用 fixture 功能

- start 设置 scope 为 module 级别，在当前 `.py` 用例模块只执行一次，`autouse=True` 自动使用
- open_home 设置 scope 为 function 级别，每个用例前都调用一次，自动使用

```python
# autouse.py
import pytest


@pytest.fixture(scope="module", autouse=True)
def start(request):
    print('\n-----开始执行 moule----')
    print(f'module      : {request.module.__name__}')
    print('----------启动浏览器---------')
    yield
    print("------------结束测试 end!-----------")


@pytest.fixture(scope="function", autouse=True)
def open_home(request):
    print(f"function：{request.function.__name__} \n--------回到首页--------")


def test_01():
    print('-----------用例 01--------------')


def test_02():
    print('-----------用例 02------------')


if __name__ == "__main__":
    pytest.main(["-s"])
```

运行结果：

```python
============================= test session starts =============================
collecting ... collected 2 items

autouse.py::test_01
-----开始执行moule----
module      : autouse
----------启动浏览器---------
function：test_01
--------回到首页--------
-----------用例01--------------
PASSED
autouse.py::test_02 function：test_02
--------回到首页--------
-----------用例02------------
PASSED------------结束测试 end!-----------


============================== 2 passed in 0.01s ==============================
```

上面是函数去实现用例，写到 class 里也是一样可以的。

fixture 里面的 teardown 用 yield 来唤醒 teardown 的执行。

#### conftest.py 配置

上面一个案例是在同一个 `.py` 文件中，多个用例调用一个登陆功能，如果有多个 `.py` 的文件都需要调用这个登陆功能的话，那就不能把登陆写到用例里面去了。

此时应该要有一个配置文件，单独管理一些预置的操作场景，pytest 里面默认读取 conftest.py 里面的配置

conftest.py 配置需要注意以下点：

- conftest.py 配置脚本名称是固定的，不能改名称
- conftest.py 与运行的用例要在同一个 pakage 下，并且有 `__init__.py` 文件
- 不需要 import 导入 conftest.py，pytest 用例会自动查找
- 一个项目中可以有多个 conftest.py，一个 conftest.py 作用于同级及下级目录。

```python
# conftest.py
import pytest

@pytest.fixture()
def logout_after_login_success(browser):
    HP.login()
    yield
    HP.logout()
```

### 其他功能

```python
import pytest
import platform

# 跳过类、模块、函数等
@pytest.mark.skip
@pytest.mark.skipif(condition, reason="")

# 创建标记
skipmark = pytest.mark.skip(reason="不能在 window 上运行")
skipifmark = pytest.mark.skipif(platform.system() == 'Windows', reason="不能在 window 上运行")

# 使用标记
@skipmark
class TestSkip_Mark(object):
    ...

# 多个 assume，即使前面的错误，后面的也能继续执行，需要 pip install pytest-assume 安装插件
pytest-assume(3==0)
```

### 插件

常用的插件：

- pytest-assume    多重断言，允许单个测试用例中存在多个失败
- pytest-cov         生成覆盖率报告
- pytest-html        生成 HTML 报告

## 代码覆盖率测试

[coverage 官方文档](https://coverage.readthedocs.io/en/latest/)

[pytest-cov 官方文档](https://pytest-cov.readthedocs.io/en/latest/)

[配置文件语法](https://coverage.readthedocs.io/en/latest/config.html)

```sh
python -m pip install pytest-cov
# python3.11 版本以下，需要安装 toml 支持
python -m pip install coverage[toml]
```

### 用法

Many people choose to use the pytest-cov plugin, but for most purposes, it is unnecessary.

```sh
# 执行代码覆盖测试
coverage run -m pytest

# 在控制台展示测试结果
coverage report -m

# 生成 html 报告文件
coverage html
```

如果使用 `pytest-cov` 插件，它会将 pytest 测试的项目全部生成报告，所以只需要设置排除选项 `omit` 即可，不需要设置 `source` 参数。

配置文件：

```toml
# pyproject.toml
# coverage 配置
[tool.coverage.run]
# 分支覆盖
branch = true
# .coverage 文件位置
data_file = ".pytest_cache/.coverage"
# 不使用 pytest-cov 插件，需要设置此参数
source = ["src"]
# 代码覆盖测试要排除的文件
omit = ['tests/__init__\.py']
[tool.coverage.report]
# Regexes for lines to exclude from consideration
exclude_lines = [
    # Have to re-enable the standard pragma
    'pragma: no cover',
    # Don't complain about missing debug-only code:
    'def __repr__',
    'if self\.debug',
    # Don't complain if tests don't hit defensive assertion code:
    'raise AssertionError',
    'raise NotImplementedError',
    # Don't complain if non-runnable code isn't run:
    'if 0:',
    'if __name__ == .__main__.:',
    # Don't complain about abstract methods, they aren't run:
    '@(abc\.)?abstractmethod',
]
#[tool.coverage.html]
#directory = "coverage_report_html"
```

参数：

```python
# 函数及子进程不生成报告
@pytest.mark.no_cover
```
