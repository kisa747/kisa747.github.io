# Python 技巧

## 笔记

* Widows 下日常使用的 python 版本比正式版落后一个版本比较合适，很多库的适配速度跟不上 python 的更新速度。
* Windows 下使用 scoop 的 version 库来安装和更新 python 程序，可以使用 versions 库安装多个版本，而且可以自由切换不同的版本。
* 官方文档推荐使用 `python -m pip` 来执行 `pip` 命令，考虑到复杂的虚拟环境，用 `python -m` 作为入口启动 pip，才是正确的 python 环境。

### Python UTF-8 模式

参考：<https://docs.python.org/zh-cn/3/library/os.html#utf8-mode>

Python UTF-8 模式会忽略 [locale encoding](https://docs.python.org/zh-cn/3/glossary.html#term-locale-encoding) 并强制使用 UTF-8 编码。

根据 [PEP687 提案](https://peps.python.org/pep-0686/)，从 python3.15 版开始，UTF8 模式会成为默认设置，因此 Windows 下建议永久设置 UTF8 模式。

方法 1：永久设置。设置环境变量 [`PYTHONUTF8`](https://docs.python.org/zh-cn/3/using/cmdline.html#envvar-PYTHONUTF8) 为 `1` ，建议采用此方法，毕竟按照 `PEP686` 提案，2025 年 UTF8 模式会成为默认设置。

```sh
setx PYTHONUTF8 1
```

方法 2：临时使用 UTF8 模式。通过命令行选项 [`-X utf8`](https://docs.python.org/zh-cn/3/using/cmdline.html#cmdoption-X)

```sh
python -X utf8 test.py
```

设置后，编码变为 UTF-8

```python
>>> locale.getpreferredencoding()  # 根据用户的偏好，返回用于文本数据的 locale encoding。
'utf-8'
```

设置后，获取系统原始默认的编码设置

```python
>>> locale.getencoding()
'cp936'
```

### 获取系统及 python 信息

参考官方文档：<https://docs.python.org/zh-cn/3/library/platform.html>

python 是跨平台语言，有时候我们的程序需要运行在不同系统上，例如：linux、MacOS、Windows，有时也要检测 python 版本，为了使程序有更好通用性，需要根据不同系统、python 版本使用不同操作方式。

>获取系统及 python 信息，推荐使用跨平台的 `platform` 标准库，不要使用 `os`、`sys` 模块。

python 的 `os`、`sys` 模块也能获取信息，但都不通用，比如： `os.uname()` 仅在 Linux 下有效，所以更推荐使用跨平台的 `platform` 标准库。

#### Windows 下系统信息

```python
>>> import platform
# 具有高可移植性的 uname 接口
>>> platform.uname()
uname_result(system='Windows', node='DESKTOP-10DJI7T', release='10', version='10.0.19041', machine='AMD64')
# MacOS 为 'Darwin'
>>> platform.system()
'Windows'
>>> platform.platform()
'Windows-10-10.0.19041-SP0'
>>> platform.version()
'10.0.19041'
>>> platform.machine()
'AMD64'
>>> platform.release()
'10'

# 还可以获取 python 版本信息
>>> platform.python_version()
'3.10.8'
>>> platform.python_version_tuple()
('3', '10', '8')

>>> sys.version
'3.10.8 (tags/v3.10.8:aaaf517, Oct 11 2022, 16:50:30) [MSC v.1933 64 bit (AMD64)]'

# 获取 windows 下的系统版本号
>>> sys.getwindowsversion()
sys.getwindowsversion(major=10, minor=0, build=19044, platform=2, service_pack='')
```

#### Linux 下系统信息

```python
>>> import platform
>>> platform.uname()
uname_result(system='Linux', node='synology', release='4.4.180+', version='#42962 SMP Tue Oct 18 15:05:40 CST 2022', machine='aarch64')
>>> platform.system()
'Linux'
>>> platform.platform()
'Linux-4.4.180+-aarch64-with-glibc2.26'
>>> platform.version()
'#42962 SMP Tue Oct 18 15:05:40 CST 2022'
>>> platform.machine()
'aarch64'
>>> platform.release()
'4.4.180+'

# Linux 下获取发行版信息，返回一个字典，python3.10 新增加功能。
>>> platform.freedesktop_os_release()
{'NAME': 'Debian GNU/Linux', 'ID': 'debian', 'PRETTY_NAME': 'Debian GNU/Linux 11 (bullseye)', 'VERSION_ID': '11', 'VERSION': '11 (bullseye)', 'VERSION_CODENAME': 'bullseye', 'HOME_URL': 'https://www.debian.org/', 'SUPPORT_URL': 'https://www.debian.org/support', 'BUG_REPORT_URL': 'https://bugs.debian.org/'}
```

### toml 配置文件

python3.11 内置了 `tomllib` 标准库，但是要想在低版本 python 上使用，可以使用下面的方法：

```python
try:
    import tomllib
except ModuleNotFoundError:
    import tomli as tomllib

tomllib.loads("['This parses fine with Python 3.6+']")

# 也可以使用下面方法
import platform

if platform.python_version_tuple()[1] >= 11
    import tomllib
else:
    import tomli as tomllib

tomllib.loads("['This parses fine with Python 3.6+']")
```

### sys.argv[] 及当前文件的用法

`sys.argv[]` 其实就是一个列表，里边的项为用户输入的参数，关键就是要明白这参数是从程序外部输入的，而非代码本身的什么地方，要想看到它的效果就应该将程序保存了，从外部来运行程序并给出参数。

sys.argv[0] 代表代码文件本身，返回当前文件的完整路径。与 `__file__` 返回的结果一致。

sys.argv[1:] 代表命令后面输入的所有参数列表。

```python
>>> print(__file__)
D:/Home/Pycharm/测试/ceshi.py

>>> print(sys.argv[0])
D:/Home/Pycharm/测试/ceshi.py
```

### Windows 计划任务启动 Python 脚本

程序选择： `pythonw.exe`   无界面启动脚本。

添加参数： `D:\App\Tool\Shell\hao6v.py`   无需更改脚本的后缀名。

起始于： `D:\App\Tool\Shell`  参数的目录保持一致，保证脚本运行的目录是当前目录。

### 尽可能使用隐式 false

Python 在布尔上下文中会将某些值求值为 false. 按简单的直觉来讲，就是所有的”空”值都被认为是 false. 因此`0`， `None`, `[]`, `{}`, `''`都被认为是`false`.

尽可能使用隐式的 `false`, 例如：使用 `if foo:` 而不是`if foo != []:` 不过还是有一些注意事项需要你铭记在心：

* 永远不要用`==`或者`!=`来比较单件，比如`None`. 使用`is`或者`is not`.
* 对于序列 (字符串，列表，元组), 要注意空序列是 `false`.

### sorted() 与 sort()

 `sorted()`  函数与`list.sort()`方法不同，sorted 函数也是一个高阶函数，后面也可添加各种参数。

For sorting examples and a brief sorting tutorial, see [Sorting HOW TO](https://docs.python.org/3/howto/sorting.html#sortinghowto).

> 注意：`sorted()` 不改变原列表，`list.sort()`直接修改原列表。

```python
sorted(iterable, *, key=None, reverse=False)

>>> sorted("This is a test string from Andrew".split(), key=str.lower)
['a', 'Andrew', 'from', 'is', 'string', 'test', 'This']

>>> student_tuples = [
...     ('john', 'A', 15),
...     ('jane', 'B', 12),
...     ('dave', 'B', 10),
... ]
>>> sorted(student_tuples, key=lambda student: student[2])   # sort by age
[('dave', 'B', 10), ('jane', 'B', 12), ('john', 'A', 15)]

>>> sorted(student_tuples, key=itemgetter(2))
[('dave', 'B', 10), ('jane', 'B', 12), ('john', 'A', 15)]
```

参考：<https://realpython.com/python-sort/>

sorted() 是 python 内建函数。

```python
>>> numbers = [6, 9, 3, 1]
>>> numbers_sorted = sorted(numbers)
>>> numbers_sorted
[1, 3, 6, 9]
>>> numbers
[6, 9, 3, 1]
```

`.sort()`  是列表的方法，就地排序，返回 `None` 。

```python
>>> values_to_sort = [5, 2, 6, 1]
>>> # Try to call .sort() like sorted()
>>> sort(values_to_sort)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: name 'sort' is not defined

>>> # Try to use .sort() on a tuple
>>> tuple_val = (5, 1, 3, 5)
>>> tuple_val.sort()
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'tuple' object has no attribute 'sort'

>>> # Sort the list and assign to new variable
>>> sorted_values = values_to_sort.sort()
>>> print(sorted_values)
None

>>> # Print original variable
>>> print(values_to_sort)
[1, 2, 5, 6]
```

### 浅拷贝与深拷贝

参考：<https://blog.csdn.net/qq_24502469/article/details/104185122>

正常我们想复制一个序列，有三种方法。

>* 直接赋值：两个列表是等价的，修改其中任何一个列表都会影响到另一个列表。
>* 浅拷贝：仅一层实现了深拷贝，但对于其内嵌套的 List，仍然是浅拷贝，修改内嵌的 list，仍会影响新的列表。因为嵌套的 List 保存的是地址，复制过去的时候是把地址复制过去了，嵌套的 List 在内存中指向的还是同一个。
>* 深拷贝：无论多少层，无论怎样的形式，得到的新列表都是和原来无关的，这是最安全最清爽最有效的方法。

1. 直接赋值

```python
old = [1, [1, 2, 3], 3]
new = old
```

2. 浅拷贝

```python
# 切片与浅拷贝效果一致
new = old.copy()
new = old[:]
```

3. 深拷贝

```python
import copy
new = copy.deepcopy(old)
```

4. for 循环、列表生成式

for 循环、列表生成式都是浅拷贝方式。

```python
# for 循环方式
new = []
for i in old:
    new.append(i)

# 列表生成式方式
new = [x for x in old]
```

## 不推荐使用的方法

### 通配符 glob

我们都知道在 Python 2 时不能直接通配递归的目录，需要这样：

```python
found_images = \
    glob.glob('/path/*.jpg') \
  + glob.glob('/path/*/*.jpg') \
  + glob.glob('/path/*/*/*.jpg') \
  + glob.glob('/path/*/*/*/*.jpg') \
  + glob.glob('/path/*/*/*/*/*.jpg')
```

Python3 的写法要清爽的多：

```python
import glob
found_images = glob.glob('/path/**/*.jpg', recursive=True)
```

事实上更好的用法是使用 pathlib:

```python
import pathlib
found_images = pathlib.Path('/path/').glob('**/*.jpg')

# 或是使用 rglob
found_images = pathlib.Path('/path/').rglob('*.jpg')
```

### 自动安装缺失模块

使用 try except 自动安装没有的模块。

```python
import subprocess
import sys

try:  # 尝试导入库
    from rawkit.raw import Raw
except ModuleNotFoundError:
    subprocess.run(
        [sys.executable, '-m', 'pip', 'install', '-U', 'rawkit'],
        shell=True,
        check=True
    )
    from rawkit.raw import Raw
```

### 将当前文件夹添加到系统变量（不推荐使用）

```python
# 将当前文件夹添加到系统变量，便于查找 raw.dll 文件。
os.environ['PATH'] = f'{os.environ["PATH"]};{os.getcwd()};{os.path.join(os.getcwd(),"data")}'
```
