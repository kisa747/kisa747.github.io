# Windows 下升级 python

使用 `scoop` 的 `Version` 库安装的 Python 指定版本，升级步骤如下：

```python
# 查看当前 python 版本
python -V

# 安装新版的 python
scoop install python313
#  设定默认的 python
scoop reset python313

# 查看当前 python 版本
python -V

# 查看 pip 版本
python -m pip -V
pip -V

# 卸载旧版的 python
scoop uninstall python312
```

## 更新配置

1、重新关联`.py` `.pyw` 文件

>1-Python 配置 - 文件关联.cmd

2、升级库文件

```sh
python "D:\Home\Git-Repo\pycode\cron\update_python.py"
```

3、将 pycode 项目注册到自定义库

相当于执行 `pip install -e D:\Home\Git-Repo\pycode` 命令，设置设置 `UTF8` 模式

```sh
python "D:\Home\Git-Repo\pycode\src\set-pth.py"
```
