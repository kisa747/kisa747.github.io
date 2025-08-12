# Jupyter 笔记

## 笔记

## 快捷键

- **Tab** : 代码补全或缩进
- **Shift-Tab** : 提示
- **Enter** : 转入编辑模式
- **Shift-Enter** : 运行本单元，选中下个单元
- **Ctrl-Enter** : 运行本单元
- **Alt-Enter** : 运行本单元，在其下插入新单元

## Jupyter Notebook 常用魔法命令

```python
# 单元格内显示图像
%matplotlib inline

import numpy as np
import pandas as pd

from sqlalchemy import create_engine
import matplotlib.pyplot as plt
# 显示百分比
import matplotlib.ticker as ticker


# %timeit %%timeit 为代码执行计时
%timeit np.sin(24)

%%timeit
x=np.sin(20)
np.cos(-x)
```

安装

```sh
# 安装并配置扩展
pip install jupyter_contrib_nbextensions
jupyter contrib nbextension install --user
pip install jupyter_nbextensions_configurator
jupyter nbextensions_configurator enable --user

# 卸载扩展
pip uninstall jupyter_contrib_nbextensions
pip uninstall jupyter_nbextensions_configurator
```
