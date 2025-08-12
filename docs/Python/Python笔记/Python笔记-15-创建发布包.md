# 创建并发布包

参考：官方文档 [Packaging Python Projects](https://packaging.python.org/en/latest/tutorials/packaging-projects)

[Setuptools 文档](https://setuptools.pypa.io/en/latest/userguide/quickstart.html)

[OpenAstronomy Python Packaging Guide](https://packaging-guide.openastronomy.org/en/latest/index.html#)

## 1、升级打包工具

```sh
python -m pip install --upgrade pip
python -m pip install --upgrade setuptools wheel build
```

## 2、创建项目

准备创建一个名为 `pyexcel` 的包，目录结构如下：

```sh
D:\MyProject                 # 项目目录
│  LICENSE                   # 授权协议。可以从 https://choosealicense.com 选择合适的授权协议
│  pyproject.toml            # 包的配置信息
│  README.md                 # 包的简介
│
├─src                        # 源代码根目录
│   └─pyexcel                # 包目录在这里，必须，否则安装后没有文件夹
│           converts.py
│           excel.py         # 软件包的 python 文件
│           utils.py
│           __init__.py      # 包的初始化文件
│           __main__.py      # 包可以作为脚本调用，python -m pyexcel
│
└─tests                      # 测试源代码根目录
            test_pyexcel.py  # 测试文件
```

在 pycharm 下，将 `src` 目录标记为：源代码根目录；将 `tests` 目录标记为：测试源代码根目录。python 程序中的引用就不会报错了。

SetupTools 文档强烈建议软件包放到 `src` 目录下，即 `src` 布局（src-layout），参考： [官方文档](https://setuptools.pypa.io/en/latest/userguide/package_discovery.html)  。

许可证选择参考阮一峰的文章：[如何选择开源许可证？](https://www.ruanyifeng.com/blog/2011/05/how_to_choose_free_software_licenses.html)

配置信息 `pyproject.toml` 内容如下：

```toml
# pyproject.toml
[build-system]
requires = ["setuptools>=61.0"]
build-backend = "setuptools.build_meta"

[project]
name = "pyexcel"
dynamic = ["version"]
authors = [
  { name="kevin", email="kevin@example.com" },
]
description = "一个处理Excel文件的工具"
# 大部分打包工具都会自动识别 LICENSE 文件，所以不需要指定 LICENSE 文件
readme = "README.md"
requires-python = ">=3.8"
dependencies = [
    "xlwings>=0.28",
]
classifiers = [
    "Programming Language :: Python :: 3 :: Only",
    "License :: OSI Approved :: GNU General Public License v3 (GPLv3)",
    "Operating System :: OS Independent",
    "Development Status :: 5 - Production/Stable",
]

[project.urls]
"Homepage" = "https://example.com"
"Bug Tracker" = "https://github.com/example"

[tool.setuptools.dynamic]
version = {attr = "pyexcel.__version__"}
```

### 额外的依赖包

参考：[pip 文档](https://pip.pypa.io/en/stable/cli/pip_install/#examples)、[PEP508](https://peps.python.org/pep-0508/#extras)、[SetupTools 文档](https://setuptools.pypa.io/en/latest/userguide/dependency_management.html#optional-dependencies)

有时候包的部分功能需要特定的依赖，但又不是所有人会需要这个功能，可以把这个依赖包作为额外依赖包 `extra package`。`black[d]` 采用的就是这种写法。

```toml
[project]
name = "pyexcel"

# 额外的包
[project.optional-dependencies]
PDF = ["ReportLab>=1.2", "RXP"]
```

如果要安装额外的包，使用下面的命令：

```sh
python -m pip install pyexcel[PDF]
```

如果另一个包 Package-B 依赖 pyexcel 包且支持 PDF 额外包，需要这样写：

```toml
[project]
name = "Package-B"

# 依赖的包
dependencies = [
    "pyexcel[PDF]"
]
```

classifiers 解释：<https://pypi.org/classifiers/>

> Programming Language :: Python :: 3
>
> Programming Language :: Python :: 3 :: Only
>
> Programming Language :: Python :: 3.10
>
> License :: OSI Approved :: BSD License
>
> License :: OSI Approved :: GNU General Public License v3 (GPLv3)
>
> Operating System :: OS Independent
>
> Operating System :: Microsoft :: Windows
>
> Operating System :: POSIX :: Linux
>
> Development Status :: 4 - Beta
>
> Development Status :: 5 - Production/Stable

## 3、执行 build 命令创建包

```sh
# 注意：pip 设置为默认--user 的话会报错，需要先执行 pip config set install.user false
# 在项目目录下执行命令
python -m build

# 使用 -w 或 --wheel 参数，仅生成 wheel 文件
python -m build -w

# 运行完可以再改回来
pip config set install.user true
```

执行完后，得到一个 dist 目录：

```sh
pyexcel-1.0.0.tar.gz            # 源码包
pyexcel-1.0.0-py3-none-any.whl  # wheel 包
```

## 4、安装创建的包

```sh
# 直接本地安装
pip install pyexcel-1.0.0-py3-none-any.whl
```

## 5、上传包

```sh
git add .
git commit -m '发布版 1.0.0'
# 给上一次 commit 打标签
git tag 1.0.0
# 默认情况下，git push 并不会把 tag 标签传送到远端服务器上，只有通过显式命令才能分享标签到远端仓库。
git push origin 1.0.0
git push
# 查看本地 tag 列表
git tag
```

然后在仓库查看是否推送成功，如果成功了，就可以通过下面命令安装。

```sh
# 自动从仓库检出（checkout），然后打包，再安装至系统。
python -m pip install --user git+https://gitee.com/kisa747/pyexcel@1.0.0
# 或是下面的方法
python -m pip install --user MyProject@git+https://gitee.com/kisa747/pyexcel@1.0.0
```

上传至 pypi 网站

```sh
python -m pip install --upgrade twine
```

## 自动设置版本号

参考：<https://github.com/pypa/setuptools_scm/#default-versioning-scheme>

上面的方法直接将版本号写到配置里了，即设置了 `version = "1.0.0"` ，

如果软件升级，需要手动修改，而且还要同步修改软件包内的版本号，如果版本号要带上 git 的 commit 信息、日期等内容，会更麻烦。因此需要自动生成版本号。

采用 `setuptools_scm` 自动管理版本，使用 git 打上 tag 标签，就能自动生成新的正式版本，其它的小版本号他会自动生成，非常的方便。

安装 `setuptools_scm` 软件：

```sh
uv install setuptools_scm --dev
```

### 1) 配置 pyproject.toml

参考：<https://github.com/pypa/setuptools_scm/#pyprojecttoml-usage>

```toml
# pyproject.toml
[build-system]
requires = ["setuptools", "setuptools_scm"]
build-backend = "setuptools.build_meta"

[project]
# 自动生成版本号，这里不用手动设置版本号
#version = "1.0.0"
# 将 version 标记为动态生成
dynamic = ["version"]

[tool.setuptools_scm]
# 如果不设置 version_file，会自动把包的版本信息写到 METADATA
version_file = "src/pyexcel/_version.py"
```

查看当前项目的版本：

```sh
>>> uv run -m setuptools_scm
1.0.3.dev1+g12ab31e
```

打包：

```sh
uv build --wheel
```

查看 `src/pyexcel/_version.py` 内容。

```python
# coding: utf-8
# file generated by setuptools_scm
# don't change, don't track in version control
__version__ = version = '1.0.3.dev1+g12ab31e'
__version_tuple__ = version_tuple = (1, 0, 3, 'dev1', 'g12ab31e')
```

在包内获取版本信息采用下面的方法（需要 python3.8+，参考 [Retrieving package version at runtime](https://github.com/pypa/setuptools_scm/#retrieving-package-version-at-runtime)），修改 `src/pyexcel/_version.py`：

```python
# src/pyexcel/_version.py
from importlib.metadata import version, PackageNotFoundError

try:
    __version__ = version("pyexcel")
except PackageNotFoundError:
    # package is not installed
    __version__ = "unknown version"
```

### 2) 停止追踪 `_version.py` 文件

项目的 git 忽略文件`.gitignore`，添加一下内容，git 不再管理 `__version__.py` 文件。

```ini
# .gitignore
_version.py
```

### 版本命名规则

setuptools_scm 的命名规则遵循了 [PEP 440](https://peps.python.org/pep-0440/)，

| 状态                                              | 命名规则                                                                 | 示例                                                     |                                                                                        |
|:-----------------------------------------------:|:--------------------------------------------------------------------:|:------------------------------------------------------:| -------------------------------------------------------------------------------------- |
| no distance and clean（当前 commit 就在 tag 上，代码没有修改）    | `{tag}`                                                              | pyexcel-1.0.2-py3-none-any.whl                         |                                                                                        |
| distance and clean（当前 commit 不在 tag 上，代码没有修改）       | `{next_version}.dev{distance}+{scm letter}{revision hash}`           |                                                        |                                                                                        |
| no distance and not clean（当前 commit 就在 tag 上，代码有修改） | `{tag}+dYYYYMMDD`                                                    |                                                        |                                                                                        |
| distance and not clean（当前 commit 不在 tag 上，代码有修改）    | `{next_version}.dev{distance}+{scm letter}{revision hash}.dYYYYMMDD` | pyexcel-1.0.2.dev1+g7b09aab.d20221113-py3-none-any.whl | The next version is calculated by adding `1` to the last numeric component of the tag. |

For Git projects, the version relies on [git describe](https://git-scm.com/docs/git-describe), so you will see an additional `g` prepended to the `{revision hash}`.

## 手动设置版本号便捷版

参考：<https://setuptools.pypa.io/en/latest/userguide/pyproject_config.html#dynamic-metadata>

即使是手动设置版本号，也有便捷的方案，每次只需要修改一处即可。**推荐使用此方法**。

在 `src/pyexcel/_version.py` ，里面记录版本号。

```python
# src/pyexcel/_version.py

__version__ = '1.0.1'
```

在  `src/pyexcel/_version.py` 里引用它：

```python
from .__version_ import __version__
```

配置 pyproject.toml 文件：

```toml
[project]
dynamic = ["version"]

[tool.setuptools.dynamic]
version = {attr = "pyexcel.__version__"}
```

以后每次更新，只用更新包里的 `__version__.py` 文件即可。
