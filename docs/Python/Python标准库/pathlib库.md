# Pathlib 标准库

参考：<https://docs.python.org/zh-cn/3/library/pathlib.html>

## 常用的导入方式

``` python
from pathlib import Path

# PurePath 纯路径操作，不会访问文件系统。可以对并不存在的路径字符串进行操作，不用担心出错。
from pathlib import PurePath
```

## 技巧

pathlib 下并没有一个像 `os.walk()` 能遍历整个目录的方法，但可以变通的使用 `Path.rglob('*')` 方法。

```python
p = Path('.')

# 遍历整个目录，包括子目录、文件
lst = [x for x in p.rglob('*')]
```

## 内置方法属性

```python
from pathlib import Path
dir(p)
[输出：]
['__bytes__', '__class__', '__delattr__', '__dir__', '__doc__', '__enter__', '__eq__', '__exit__', '__format__', '__fspath__', '__ge__', '__getattribute__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__le__', '__lt__', '__module__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__rtruediv__', '__setattr__', '__sizeof__', '__slots__', '__str__', '__subclasshook__', '__truediv__', '_accessor', '_cached_cparts', '_closed', '_cparts', '_drv', '_flavour', '_format_parsed_parts', '_from_parsed_parts', '_from_parts', '_hash', '_init', '_make_child', '_make_child_relpath', '_opener', '_parse_args', '_parts', '_pparts', '_raise_closed', '_raw_open', '_root', '_str', 'absolute', 'anchor', 'as_posix', 'as_uri', 'chmod', 'cwd', 'drive', 'exists', 'expanduser', 'glob', 'group', 'home', 'is_absolute', 'is_block_device', 'is_char_device', 'is_dir', 'is_fifo', 'is_file', 'is_mount', 'is_reserved', 'is_socket', 'is_symlink', 'iterdir', 'joinpath', 'lchmod', 'lstat', 'match', 'mkdir', 'name', 'open', 'owner', 'parent', 'parents', 'parts', 'read_bytes', 'read_text', 'relative_to', 'rename', 'replace', 'resolve', 'rglob', 'rmdir', 'root', 'samefile', 'stat', 'stem', 'suffix', 'suffixes', 'symlink_to', 'touch', 'unlink', 'with_name', 'with_suffix', 'write_bytes', 'write_text']
```

## 常用方法

```python
p = Path()  # 当前目录，返回相对路径
p = Path.cwd()  # 当前目录，返回绝对路径
p = Path.home()  # 用户目录

p.exists()  # 判断路径是否存在
p.is_dir()  # 判断是否是目录
p.is_file()  # 判断是否是文件

a = p / 'Python/p.txt' # 路径拼接，跨操作系统使用，windows 下也可以使用 /
a = p.joinpath('dir', 'ff.txt')  # 路径拼接
q = p.iterdir()  # 返回一个迭代器：列出所有子目录和文件（非递归）。与 os.listdir()、os.scandir() 类似

# 下面的属性返回的都是对象，但可以 print() 输出，也可以拼接
a = p.name  # 获取文件名，文件基名 basename（含扩展名的文件名）
a = p.stem  # 文件名（不含扩展名）
a = p.suffix  # 文件后缀名（含.）
a = p.parent  # 所在的目录 (父目录)
a = p.parent / p.name  # p 的整路径
[输出：]C:\Users\kisa747\Python\p.txt
a = p.parents

p.resolve(strict=False) # 返绝对路径。如果文件或目录不存在，是无法转换为绝对路径的。
p.write_text('测试')  # 以字符串写入，上下文管理，写入后关闭文件。文件不存在会自动创建。可以用来创建文件。
a = p.read_text()  # 以文本形式读取文件。
a = p.read_bytes()  # 以二进制形式读取文件。
p.open(mode='r', buffering=-1, encoding=None, errors=None, newline=None).write('测试')
# 直接用 P.write_text() 或 p.write_bytes() 更方便。
# 'w' 模式写入，如果文件不存在，则自动创建。
# newline 换行符形式，可以是：None, '', '\n', '\r', '\r\n'
a = p.open('r').read()  # 返回文件内容，如果文件不存在，FileNotFoundError

# glob 是否区分大小写由操作系统决定，windows 下不区分大小写。
p.glob(''**/*.txt')  # 列出所有的 txt 文件
p.rglob('*.py')  # 相当于 p.glob('**/*.txt')
p.match('*.txt')  # 是否匹配，返回布尔值

Path.mkdir() # 创建目录，如果子目录不存在，抛出错误。如果目录已存在，抛出 FileExistsError。
Path.mkdir(mode=0o777, parents=False, exist_ok=False)
# parents 设置为 True 时，递归创建子目录。exist_ok 设置为 True 时，如果目录已存在，就不创建，不抛出错误。

# rename 和 replace 都是移动文件、目录的方法，区别是覆盖提醒有区别。rename 不覆盖，replace 无条件覆盖。
# 两个方法都无法跨驱动器移动文件！！！
# 如果需要跨驱动器移动文件、目录，需要自己构造一个 move 方法，或是使用 shutil.move() 方法。
p.rename(target)  # target 可以是字符串，也可以是一个实例对象。windows 下如果目标已经存在，则抛出 FileExistsError 错误。Linux 下静默替换已存在的文件或目录。
p.replace(target) # target 可以是字符串，也可以是一个实例对象。无条件替换已存在的文件或目录。Windows 下无法跨磁盘、分区移动。
p.unlink()  # 删除文件
p.rmdir()  # 删除空目录
```

## pathlib 无法实现的功能

```bash
# 如果要删除非空目录，使用 shutil.rmtree() 方法。
shutil.rmtree(path, ignore_errors=False, onerror=None)

# 简单非跨驱动器移动、重命名文件、目录，使用Path.rename()、Path.replace()
# 涉及到可能跨驱动器情况时：
# 移动文件、目录使用 shutil.move()
# 复制文件（覆盖已存在目标）使用 shutil.copy2() 或 shutil.copy()

# 复制目录使用 shutil.copytree(src, dst, symlinks=False, ignore=None, copy_function=copy2, ignore_dangling_symlinks=False)

# Return an iterator of os.DirEntry objects corresponding to the entries in the directory given by path. The entries are yielded in arbitrary order, and the special entries '.' and '..' are not included.
os.scandir()

# 尽量不要使用 os.listdir()、os.walk()
```

## 相对路径、绝对路径

`__file__` 表示当前文件的路径字符串。**python3.9+ 表示绝对路径**。在旧版本的 python 中，如果要确保使用绝对路径，最好使用 `Path(__file__).resolve` 。

* 在 windows 中表示的是绝对路径

* openwrt 中表示的相对路径。

* linuxmint 中，在文件所在目录执行时是相对路径，从其它位置执行时是绝对路径。

```python
from pathlib import Path

p = Path()  # 当前目录，相对路径
p = Path('.')  # 当前目录，相对路径
p = Path('data')  # 当前目录下的 data 文件夹，相对路径
p = Path('data/zz.txt')  # 当前目录下的 data 文件夹下的 zz.txt，相对路径
p = Path('./data/zz.txt')  # 当前目录下的 data 文件夹下的 zz.txt，相对路径
# 不能用 p = Path('/data/zz.txt')  # 这样表示的是绝对路径

# 如果文件存在，返回 True，否则返回 False
Path('./data/zz.txt').resolve() == Path.cwd() / 'data' / 'zz.txt'
[输出：]True
```

## Path.glob() 方法支持的语法

| Pattern | Meaning                            |
| :-----: | ---------------------------------- |
|    *    | matches everything                 |
|    ?    | matches any single character       |
|  [seq]  | matches any character in *seq*     |
| [!seq]  | matches any character not in *seq* |
|   [?]   | 匹配 ? 字符本身                    |

## 自己动手构造一个提供、移动的方法

```python
# pathlib 没有提供复制文件、目录的方法，可以自己构造一个。
def _copy(self, target):
    import shutil
    # assert self.is_file()
    shutil.copy(self, target)
Path.copy = _copy
# 然后就可以使用下面的方法
source_path.copy(target)

# pathlib 没有提供可靠地移动文件、目录的方法，可以自己构造一个。
def _move(self, target):
    import shutil
    shutil.move(self, target)
Path.move = _move
# 然后就可以使用下面的方法
source_path.move(target)
```
