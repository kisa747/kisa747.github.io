# python 模块与包

参考：<https://python3-cookbook.readthedocs.io/zh_CN/latest/chapters/p10_modules_and_packages.html>

<https://docs.python.org/zh-cn/3/tutorial/modules.html>

<http://kuanghy.github.io/2018/08/05/python-module-import>

参考：<https://zhuanlan.zhihu.com/p/416867942>

## 名词解释

**模块（Module）**：一个 Python 文件就是一个模块（除了 Python 文件，目录或 C 语言编译出来的可执行文件，也可以作为 Python 的模块，这里为了方便讨论，我们假设一个模块对应一个 Python 文件）。

**包（package）**：根目录下包含 `__init__.py` 文件的文件夹。

一个名为 `mypackage` 的包的目录结构：

```python
# 名为 mypackage 包的目录结构
├─mypackage
│      __init__.py
│      a.py  # class A:
│      b.py  # class B:
```

## Python 模块搜索机制

1. 程序当前目录
2. PYTHONPATH(环境变量) 目录
3. 标准库目录

封装成包是很简单的。在文件系统上组织你的代码，并确保每个目录都定义了一个 `__init__.py` 文件。例如：

```ini
graphics/
    __init__.py
    line.py
    __main__.py
    primitive/
        __init__.py
        fill.py
        text.py
    formats/
        __init__.py
        png.py
        jpg.py
```

## 包的绝对引用与相对引用

1、方法 1：绝对引用。用绝对路径引用包，这是最严谨的引用方法。

Python 内置库、pandas、numpy 都是采用的绝对路径引用。比如：

```python
# mypackage/a.py
from mypackage.b import B
```

2、方法 2：相对路径引用，requests 库采用相对引用。比如：

```python
# mypackage/a.py
from .b import B

# 模块内使用相对引用，文件直接运行会报错，但是作为包使用没有问题。
```

3、方法 3：隐式引用。作为脚本时可以使用。

```python
# 1、当作为文件直接运行时，先查找当前目录，会正确运行。
# 2、当作为包引用时，查找名为 core 的包，但实际上系统会认为 core.py 的地址是 mypackage.core, 所以会报错。

# mypackage/a.py
import b.B as B
```

总结：

> * 绝对路径引用。无论是直接运行，还是作为模块被引用（将模块所在目录添加至 myapplication.pth），都能正常运行。
>
> * 相对路径引用。直接运行文件会报错；作为模块引用正常、`python -m` 运行模块也正常。Pychaarm 下使用 unit 单元测试正常。（unit 单元测试下，其实是把整个包作为模块调用 `python -m package` 运行，所以也能正常运行。）
> * 隐式引用。直接运行文件正常；作为模块引用正常、`python -m` 运行模块报错。
>
> 建议：
>
> * 写模块、包时，建议使用绝对路径，方便调试，也不容易出错。如果要改名，使用 IDE 的重构即可解决。
> * 写模块、包时，如果使用相对路径，调试使用 unit 单元测试方法。
> * 仅作为脚本直接运行，可以使用 `方法3` 隐式引用。被引用时报错。

## 文档注释

一个文件的 `shebang` 和编码之后的三引号包括的内容，是模块的文档注释。

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
模块注释文档
"""
__author__ = 'kevin'
__version__ = '2019/5/22'
#-------------------------------
```

## `__init__.py`文件

绝大部分时候让`__init__.py`空着就好。但是有些情况下可能包含代码。举个例子，`__init__.py`能够用来自动加载子模块：

```python
# graphics/formats/__init__.py
from . import jpg
from . import png
__all__ = ['spam', 'grok']
```

### `__all__`属性

当使用 `from module import *` 语句时，希望对从模块或包导出的符号进行精确控制。在你的模块中定义一个变量 **all** 来明确地列出需要导出的内容。

举个例子：

```python
# somemodule.py
def spam():
    pass

def grok():
    pass

blah = 42
# Only export 'spam' and 'grok'
__all__ = ['spam', 'grok']
```

## 将模块作为脚本执行

模块和包可以像脚本一样直接运行，参考<https://docs.python.org/zh-cn/3/using/cmdline.html>

[PEP 338](https://www.python.org/dev/peps/pep-0338/)

在包的目录下添加一个`__main__.py`文件，比如：

```ini
myapplication/
    spam.py
    bar.py
    grok.py
    __main__.py
```

如果`__main__.py`存在，你可以简单地在顶级目录运行 Python 解释器：

```sh
python -m myapplication
```

解释器将执行`__main__.py`文件作为主程序。

如果你将你的代码打包成 zip 文件，这种技术同样也适用，举个例子：

```sh
$ ls
spam.py bar.py grok.py __main__.py
$ zip -r myapp.zip *.py
$ python3 myapp.zip
```

## 自定义包的安装位置

参考：

<https://stackoverflow.com/questions/122327/how-do-i-find-the-location-of-my-python-site-packages-directory>

<https://stackoverflow.com/questions/9387928/whats-the-difference-between-dist-packages-and-site-packages>

<https://www.cnblogs.com/kevin922/p/3161411.html>

Debian root 安装的位置在：`/usr/local/lib/python3.7/dist-packages/`

```python
>>> from distutils.sysconfig import get_python_lib
>>> print(get_python_lib())
/usr/lib/python3/dist-packages

>>> import site
>>> print(site.getsitepackages())
['/usr/local/lib/python3.7/dist-packages', '/usr/lib/python3/dist-packages', '/usr/lib/python3.7/dist-packages']

>>> print(site.USER_SITE)
'/home/pi/.local/lib/python3.7/site-packages'
```
