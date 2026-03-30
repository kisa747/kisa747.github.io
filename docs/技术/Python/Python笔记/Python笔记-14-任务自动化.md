# 任务自动化

## TOX

[tox 官方文档](https://tox.wiki/en/latest/index.html)

其核心作用是支持创建隔离的 Python 环境，在里面可以安装不同版本的 Python 解释器与各种依赖库，以此方便开发者做自动化测试、打包、持续集成等事情。

简单来说，**tox 是一个管理测试虚拟环境的命令行工具。** 它已存在多年且广被开发者们使用，例如，著名的云计算平台 OpenStack 也采用了它，作为最基础的测试工具之一。

细分的用途包括：

- 创建开发环境
- 运行静态代码分析与测试工具
- 自动化构建包
- 针对 tox 构建的软件包运行测试
- 检查软件包是否能在不同的 Python 版本/解释器中顺利安装
- 统一持续集成（CI）和基于命令行的测试
- 创建和部署项目文档
- 将软件包发布到 PyPI 或任何其它平台

```sh
python -m pip install tox
```

Currently only the old format is supported via `legacy_tox_ini`, a native implementation is planned though.

配置如下：

```toml
# pyproject.toml
[tool.tox]
legacy_tox_ini = """
[tox]
isolated_build = True
envlist = py310

[testenv]
deps =
    pytest
    pytest-cov
commands = pytest

# 使用 tox -e build 命令执行
[testenv:build]
description = 构建 whl 安装包
basepython = python3.10
deps =
    setuptools>=61.0
    build>=0.9
commands =
    python -m build -w

"""
```

执行命令：

```sh
# 运行成功会看到  congratulations :)
tox

# 执行 [testenv:build]
tox -e build

# show list of all defined environments (with description if verbose)
tox -a
```

其他的一些配置：

```ini
# Set to true if you want virtualenv to upgrade pip/wheel/setuptools to the latest version. If (and only if) you want to choose a specific version (not necessarily the latest) then you can add e.g. VIRTUALENV_PIP=20.3.3 to your setenv.
download=false(true|false)

# A list of “extras” to be installed with the sdist or develop install. For example, extras = testing is equivalent to [testing] in a pip install command. These are not installed if skip_install is true.
extras(MULTI-LINE-LIST)
```

## Hatch

根据 [官方文档](https://hatch.pypa.io/latest/)，hatch 是由 pypa 维护的一个现代的、可扩展的 python 项目管理工具。

- Standardized [build system](https://hatch.pypa.io/latest/build/#packaging-ecosystem) with reproducible builds by default
- Robust [environment management](https://hatch.pypa.io/latest/environment/) with support for custom scripts
- Easy [publishing](https://hatch.pypa.io/latest/publish/) to PyPI or other sources
- [Version](https://hatch.pypa.io/latest/version/) management
- Configurable [project generation](https://hatch.pypa.io/latest/config/project-templates/) with sane defaults
- Responsive [CLI](https://hatch.pypa.io/latest/cli/about/), ~2-3x [faster](https://github.com/pypa/hatch/blob/hatch-v1.5.0/.github/workflows/test.yml#L76-L108) than equivalent tools

采用 hatch 的项目：[black](https://github.com/psf/black)

Hatch 作为 pypa 的项目，功能异常强大，像是 `setuptools` 、`tox`、`twine` 的合体，多环境测试比 `tox` 更强大，语法、配置更简单、直观。

### 开始使用

```sh
pip install hatch
```

创建项目

```sh
# 创建新的项目
hatch new "HatchDemo"

# 如果是已经存在的项目
hatch new --init
# 会让回答几个简单的问题：项目名称、描述，然后生成一个 pyproject.toml
```

如果已经有 `pyproject.toml` 配置文件，直接修改就可以了。

```toml
# hatch 自动化任务配置
[tool.hatch.envs.default]
dependencies = [
    "pytest",
    "pytest-cov",
    "mypy",
]

[tool.hatch.envs.default.scripts]
# 创建新的命令，不能与已有的命令相同
no-cov = "pytest -s -ra {args}"
cov = "pytest --cov --cov-report html {args}"
my = "mypy src {args}"

[[tool.hatch.envs.test.matrix]]
python = ["310", "311"]

[tool.hatch.envs.docs]
dependencies = ["sphinx", "myst-parser", "furo", "sphinx-autobuild"]

[tool.hatch.envs.docs.scripts]
build = "sphinx-build -M html docs/source docs/build"
serve = "sphinx-autobuild docs/source docs/build/html"
```

常用命令：

```sh
# 查看项目依赖的包
hatch dep show requirements

# 查看存在的虚拟环境
hatch env show

# 执行单环境命令
hatch run no-cov
hatch run cov
hatch run my

# 执行多环境命令
hatch run test:no-cov
hatch run test:cov

# 创建 wheel 包
hatch build -t wheel

# 发布包
hatch publish [OPTIONS] [ARTIFACTS]...
```

hatch 创建的虚拟环境不是在项目目录下，而是集中管理。

```ini
# 创建的虚拟环境位置
%LOCALAPPDATA%\hatch

# 新建项目配置模板
%LOCALAPPDATA%\hatch\config.toml
```

### 基本配置

系统配置目录位于：`%USERPROFILE%\AppData\Local\hatch`。

目录：`%USERPROFILE%\AppData\Local\hatch\config.toml` ，核心配置文件。

目录：`%USERPROFILE%\AppData\Local\hatch\Cache`，hatch 缓存文件默认集中存放在此。

目录：`%USERPROFILE%\AppData\Local\hatch\env`，hatch 虚拟环境默认集中存放在此。

默认情况下，hatch 集中管理各个项目的虚拟环境，集中存放在`%USERPROFILE%\AppData\Local\hatch\env`，如果要将虚拟环境保存至项目的 `.hatch` 目录内，实现分项目管理虚拟环境，这样更符合使用习惯，需要修改 `config.toml`配置文件。

```toml
# %USERPROFILE%\AppData\Local\hatch\config.toml
[dirs.env]
virtual = ".hatch"  # 添加此配置
```

### 版本管理

参考：<https://hatch.pypa.io/latest/version/#supported-segments>

也可以使用 [hatch-vcs](https://pypi.org/project/hatch-vcs/) ，自动控制版本号，与 setuptools_scm 类似，使用参考 <https://github.com/psf/black>

```sh
# 查看当前版本
hatch version
# 更新版本
$ hatch version "0.1.0"
Old: 0.0.1
New: 0.1.0

# 递增第二位
$ hatch version minor
Old: 0.1.0
New: 0.2.0

# 更新第一位，并标记为 rc
$ hatch version major,rc
Old: 0.2.0
New: 1.0.0rc0
```
