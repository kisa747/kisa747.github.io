# matplotlib 绘图

官方教程：<https://matplotlib.org/stable/tutorials/introductory/quick_start.html>

## 简单的绘图

直接使用 DataFrame.plot() 是最简单的绘图方法。

参考：<https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.plot.html>

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

df = pd.DataFrame({'A': [1, 2, 3],
                   'B': [4, 5, 6]},
                  index=['a', 'b', 'c'])
df.plot()

# 更复杂的如下：
plt.rcParams['font.sans-serif'] = ['Source Han Sans SC']  # 用来正常显示中文标签 Source Han Sans SC,SimHei
plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号
fig, ax = plt.subplots(figsize=(10, 5))
df.plot(ax=ax, kind='bar', title='趋势图', xlabel='名称', ylabel='数值')

fig.savefig('test.png', transparent=False)  # 保存图片
plt.close()  # 关闭当前 fig 画布，使用 plt.close(fig) 关闭指定画布
```

## Coding styles

在 matplotlib 中，有两种绘图方式：OO-style(object-oriented)、pyplot-style（pyplot interface）。

* OO-style，分别创建 Figures 和 Axes，并使用其对应的方法绘图
* pyplot-style，依靠 pyplot 来自动创建和管理 Figures 和 Axes，应且使用 pyplot 函数来绘图

OO-style，最简单的绘图：

```python
import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(0, 2 * np.pi, 200)
y = np.sin(x)

fig, ax = plt.subplots()
ax.plot(x, y)
plt.show()
```

pyplot-style，绘制 2 条线：

```python
x = np.linspace(0, 2, 100)  # Sample data.

plt.figure(figsize=(5, 2.7), layout='constrained')
plt.plot(x, x, label='linear')  # Plot some data on the (implicit) axes.
plt.plot(x, x**2, label='quadratic')  # etc.
plt.plot(x, x**3, label='cubic')
plt.xlabel('x label')
plt.ylabel('y label')
plt.title("Simple Plot")
plt.legend()
```

OO-style，绘制 2 条线：

```python
x = np.linspace(0, 2, 100)  # Sample data.

# Note that even in the OO-style, we use `.pyplot.figure` to create the Figure.
fig, ax = plt.subplots(figsize=(5, 2.7), layout='constrained')
ax.plot(x, x, label='linear')  # Plot some data on the axes.
ax.plot(x, x**2, label='quadratic')  # Plot more data on the axes...
ax.plot(x, x**3, label='cubic')  # ... and some more.
ax.set_xlabel('x label')  # Add an x-label to the axes.
ax.set_ylabel('y label')  # Add a y-label to the axes.
ax.set_title("Simple Plot")  # Add a title to the axes.
ax.legend();  # Add a legend.
```

官方更推荐使用 OO-style

## 高级绘图

同时绘制 2 个直方图

```python
plt.rcParams['font.sans-serif'] = ['Source Han Sans SC']  # 用来正常显示中文标签 Source Han Sans SC,SimHei
plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号

# 默认 figsize=(6.4, 4.8), dpi=100, layout=None
fig, ax = plt.subplots(figsize=(10,5), dpi=200, layout='constrained')

x = df.index  # 定义 X 轴坐标上的数据
for column in list(df.columns):
    y= df[column]  # 定义 Y 轴坐标上的数据
#     plt.plot(x, y, label=column)  # 折线图
    rects = ax.bar(x, y, label=column)  # 柱状图
    ax.bar_label(rects, padding=3, rotation=45, fmt='%.0f')

ax.set_xticks(x, x)  # 设置 x 轴刻度显示，默认会省略掉部分日期
ax.set_xticklabels(x, rotation=45, ha='center')  # 设置 x 轴刻度显示的样式，必须在 set_xticks 之后使用
ax.set_xlabel('时间（年）')  # 设置 x 轴标签
ax.set_ylabel('人数')  # 设置 y 轴标签
ax.set_title('全国高考人数趋势')  # 设置标题
ax.legend(title='人数', loc='upper left')  # 给图像增加图例，不设置 loc 的话，会自动调整至合适位置
bottom, top = ax.get_ylim()  # 获得 y 轴最大最小值
ax.set_ylim(top=top*1.1)  # Set the y-axis view limits

# ax.grid()  # 显示网格
# ax.spines[:].set_visible(False)  # 隐藏边框

plt.show()  # 显示绘图

fig.savefig('全国高考人数趋势_柱状图.png', transparent=False)  # 保存图片，上面已经设置过了 dpi，这里不用设置了
plt.close()  # 关闭当前 fig 画布，使用 plt.close(fig) 关闭指定画布
```

同时绘制 2 个直方图、1 个折线图

```python
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

df = pd.read_excel('全国高考人数趋势.xlsx', index_col=0)

plt.rcParams['font.sans-serif'] = ['Source Han Sans SC']  # 用来正常显示中文标签 Source Han Sans SC, SimHei
plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号

# 默认 figsize=(6.4, 4.8), dpi=100, layout=None
fig, ax = plt.subplots(figsize=(10,5), dpi=200, layout='constrained')
ax2 = ax.twinx()

x = df.index  # 定义 X 轴坐标上的数据
y1 = df['参加高考人数 (万人)'] # 定义 Y 轴坐标上的数据
y2 = df['普通高等教育本专科招生数 (万人)'] # 定义 Y 轴坐标上的数据
y3 = y2 / y1

rects1 = ax.bar(x, y1, label=y1.name)  # 柱状图
ax.bar_label(rects1, padding=3, rotation=45, fmt='%.0f')

rects2 = ax.bar(x, y2, label=y2.name )  # 柱状图
ax.bar_label(rects2, padding=-20, fmt='%.0f')

rects3 = ax2.plot(x, y3, label='高考录取率（%）')  # 折线图
ax2.set_ylim([0, 0.92])  # 设置 y 轴数值区间
ax2.yaxis.set_major_formatter(ticker.PercentFormatter(xmax=1, decimals=1))  # 将 y 轴显示为百分比
ax2.set_ylabel('录取率')  # 设置 y 轴标签

# 参考：https://blog.csdn.net/wzk4869/article/details/126077398
ax.set_xticks(x, x)  # 设置 x 轴刻度显示，默认会省略掉部分日期
ax.set_xticklabels(x, rotation=45, ha='center')  # 设置 x 轴刻度显示的样式，必须在 set_xticks 之后使用
ax.set_xlabel('时间（年）')  # 设置 x 轴标签
ax.set_ylabel('人数')  # 设置 y 轴标签
ax.set_title('全国高考人数及录取趋势')  # 设置标题

# 给图像增加图例，不设置 loc 的话，会自动调整至合适位置
# https://stackoverflow.com/questions/5484922/secondary-axis-with-twinx-how-to-add-to-legend
# https://www.codenong.com/5484922/
# https://www.cnblogs.com/Atanisi/p/8530693.html
fig.legend(title='图例', loc='upper left', bbox_to_anchor=(0,1), bbox_transform=ax.transAxes)

bottom, top = ax.get_ylim()  # 获得 y 轴最大最小值
ax.set_ylim(top=top*1.7)  # Set the y-axis view limits
# ax2.grid()  # 显示网格
plt.show()  # 显示绘图
fig.savefig('全国高考人数及录取趋势.png', transparent=False)  # 保存图片，上面已经设置过了 dpi，这里不用设置了
plt.close()  # 关闭当前 fig 画布，使用 plt.close(fig) 关闭指定画布
```

绘制并排 2 个直方图，参考：[Grouped bar chart with labels](https://matplotlib.org/stable/gallery/lines_bars_and_markers/barchart.html)

## 参数

loc 参数

| Location String | Location Code |
| :-------------: | :-----------: |
|     'best'      |       0       |
|  'upper right'  |       1       |
|  'upper left'   |       2       |
|  'lower left'   |       3       |
|  'lower right'  |       4       |
|     'right'     |       5       |
|  'center left'  |       6       |
| 'center right'  |       7       |
| 'lower center'  |       8       |
| 'upper center'  |       9       |
|    'center'     |      10       |

## 其它

参考：<https://zhuanlan.zhihu.com/p/109245779>

[利用 pandas 读取 Excel 表格，用 matplotlib.pyplot 绘制直方图、折线图、饼图](https://www.cnblogs.com/xcuyms/p/11550606.html)

如何用 Matplotlib 自制一张好看的指数估值图？ <https://zhuanlan.zhihu.com/p/137457032>

一般来说保存图片，设置为 `dpi=300` 即可。

在 jupyter 中调试 matlibplot，plt 相关的命令需要在一个格子里，否则保存图片会使空白。

一般来说，在绘图前就提前用 pandas 清洗好数据，设置好索引列（作为 x 轴内容），修改好列名称（作为数据名称），这样绘图基本可以使用通用的代码。

```python
# 这是 IPython 中定义的魔法函数（Magic Function）,其意义是将那些用于 matplotlib 绘制的图显示在页面里而不是弹出一个窗口，因此就不需要 plt.show() 这一语句来显示图片，如下图所示：
%matplotlib inline
```

## 绘制折线图

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

df = pd.read_excel('全国高考人数趋势.xlsx', index_col=0)

# 折线图
plt.rcParams['font.sans-serif'] = ['Source Han Sans SC']  # 用来正常显示中文标签 Source Han Sans SC,SimHei
plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号
# 定义 X 轴坐标上的数据
x = df.index
for column in list(df.columns):
    # 定义 Y 轴坐标上的数据
    y= df[column]
    plt.plot(x, y, label=column)

plt.xlabel(df.index.name)
plt.ylabel('')
plt.title('全国高考人数趋势')
plt.legend()
plt.savefig('全国高考人数趋势_折线图.png', dpi=300, transparent=False)  # 保存图片
# plt.show()
plt.close()  # 关闭当前 fig 画布，使用 plt.close(fig) 关闭指定画布
```

## 绘制直方图

```python
# 柱状图
plt.rcParams['font.sans-serif'] = ['Source Han Sans SC']  # 用来正常显示中文标签 Source Han Sans SC,SimHei
plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号
# 定义 X 轴坐标上的数据
x = df.index
for column in list(df.columns):
    # 定义 Y 轴坐标上的数据
    y= df[column]
    plt.bar(x, y, label=column)
plt.xlabel(df.index.name)
plt.ylabel('')
plt.title('全国高考人数趋势')
plt.legend()
plt.savefig('全国高考人数趋势_柱状图.png', dpi=300, transparent=False)  # 保存图片
# plt.show()
plt.close()  # 关闭当前 fig 画布，使用 plt.close(fig) 关闭指定画布
```

## 绘制饼状图

```python
plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文标签
plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号
labels=df.index
x=df.iloc[:, 0]
explode=(0, 0, 0, 0, 0,0,0,0,0,0,0.1)
plt.pie(x,labels=labels,explode=explode, startangle=60, autopct='%1.1f%%')
plt.axis('equal')
plt.title('全国高考人数趋势')
plt.savefig('全国高考人数趋势_饼图.png', dpi=300, transparent=False)  # 保存图片
# plt.show()
plt.close()  # 关闭当前 fig 画布，使用 plt.close(fig) 关闭指定画布
```
