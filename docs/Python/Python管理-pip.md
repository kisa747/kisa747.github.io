# Python 包管理系统之 PIP

## 配置 pip

pip 官方文档：<https://pip.readthedocs.io>

TUNA 源说明文档：<https://mirrors.tuna.tsinghua.edu.cn/help/pypi/>

```sh
# 如果 pip 版本过低，可以先升级 pip 到最新的版本 (>=10.0.0)
python3 -m pip install -U -i https://pypi.tuna.tsinghua.edu.cn/simple pip
# 主源使用清华 TUNA 源，备用源使用 USTC 中科大源
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip config set global.extra-index-url "https://mirrors.ustc.edu.cn/pypi/simple"
pip config set install.upgrade true

# Windows 下设置后会导致虚拟环境下各种问题，还有其他各种问题，不推荐设置
# Linux：新版的 Debian、LinuxMint 侦测到系统 site-package 不可写，会自动安装至 user 目录下
# pip config set install.user true

# 查看 pip 的配置
pip config list
[输出：]
global.extra-index-url='https://mirrors.ustc.edu.cn/pypi/simple'
global.index-url='https://pypi.tuna.tsinghua.edu.cn/simple'
install.upgrade='true'
```

修改后的 `pip.ini`

```ini
# %APPDATA%\pip\pip.ini [Windows]
# ~/.config/pip/pip.conf [Linux]
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
extra-index-url = https://mirrors.ustc.edu.cn/pypi/simple

[install]
upgrade = true
```

## python 包安装位置

参考：[Debian Python Wiki](http://wiki.debian.org/Python)

从 Debian12 开始，无法直接使用 `pip` 命令安装包，[Python 解释器标记为由外部管理](https://www.debian.org/releases/stable/amd64/release-notes/ch-information.zh-cn.html#python3-pep-668) 。

Linux 系统下：

1. 系统自带的、sudo apt install 安装的包存放在 `/usr/lib/python3/dist-packages` 目录中。
2. 非 root 用户，通过 pip 安装的包存放在 `~/.local/lib/pythonX.Y/site-packages` 目录中。

Windows 系统下默认就是安装到 python 安装目录下的 `site-packages` 目录下。

## 常用命令

```sh
# 卸载软件包
python -m pip uninstall SomePackage
# 列出已经安装的软件包
python -m pip list
# 列出有可升级的包。可以简化为 pip list -o
python -m pip list --outdated
# 安装至用户目录
python -m pip install --user SomePackage
```

## 最大化升级包

参考官方文档：

<https://pip.pypa.io/en/stable/user_guide/#only-if-needed-recursive-upgrade>

```sh
# 最大化升级软件包
pip install -U --upgrade-strategy eager -r requirements_win.txt
```

> “Only if needed” Recursive Upgrade
>
> `pip install --upgrade` now has a `--upgrade-strategy` option which controls how pip handles upgrading of dependencies. There are 2 upgrade strategies supported:
>
> - `eager`: upgrades all dependencies regardless of whether they still satisfy the new parent requirements
> - `only-if-needed`: upgrades a dependency only if it does not satisfy the new parent requirements
>
> The default strategy is `only-if-needed`. This was changed in pip 10.0 due to the breaking nature of `eager` when upgrading conflicting dependencies.
>
> As an historic note, an earlier “fix” for getting the `only-if-needed` behaviour was:
>
> ```sh
> python -m pip install --upgrade --no-deps SomePackage
> python -m pip install SomePackage
> ```
>
> A proposal for an `upgrade-all` command is being considered as a safer alternative to the behaviour of eager upgrading.

## requiremenst.txt 文件语法

requiremenst.txt 文件除了支持常规的 `==`、`>`、`>=`、`<`、`<=`，还有一个 `~=`表示兼容版本，使用任何大于或等于指定版本，但不大于当前发行系列的版本，例如：`~=1.4.3` 可以匹配 `1..4.3`到`1.4.9`，但是不能匹配`1.5.0`。

可以使用 `,` 分割两个条件，比如：

```python
package_name >= 1.0, <=2.0
```

## python 程序中使用 pip

参考 [官方文档](https://pip.pypa.io/en/stable/user_guide/#using-pip-from-your-program)，官方不推荐通过 `import pip` 来调用 pip，而应该使用 `subprocess` 模块调用。

```python
import subprocess
import sys
import locale
import json
from pathlib import Path

subprocess.run([sys.executable, '-m', 'pip', 'install', 'my_package'], check=True)
```

## 获取系统上已安装包的详情

```python
# 获取已安装包的详情
import sys
import subprocess
import json

reqs = subprocess.run([sys.executable, '-m', 'pip', 'list', '--format=json'], capture_output=True)
reqs_json = json.loads(reqs.stdout)

# 获取仅包含包名称的列表
reqs_list = [x['name'] for x in reqs_json]
reqs_list
[out]:
Out[8]:
['anyio',
 'argon2-cffi',
 'argon2-cffi-bindings',
 'arrow',
 'asttokens'
  ...]

# 将仅包含包名称的列表写入文件
reqs_text = '\n'.join(reqs_list)
Path('requirements.txt').write_text(reqs_text)

# 原始 reqs_json 的内容
reqs_json
[out]:
[{'name': 'black', 'version': '22.10.0'},
 {'name': 'bleach', 'version': '5.0.1'},
 ...]

# 觉得不方便，转换成 key 为 name，value 为 version 的字典
reqs_dict = {x['name']: x['version'] for x in reqs_json}
reqs_dict
[out]:
{'black': '22.10.0',
 'bleach': '5.0.1',
 ...}
```
