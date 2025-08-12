# pandas 常用命令

参考：<https://mp.weixin.qq.com/s/rUC5TUPZO_GIGELLjsExDw>

## 1. 导入模块

```python
from sqlalchemy import create_engine
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker  # 显示百分比模块
%matplotlib inline
```

## 2. 读取数据和保存数据

```python
# 2.1 从 CSV 文件读取数据，编码'gbk'
pd.read_csv(filename, encoding='gbk')

# 2.2 读取前 6 行，当数据量比较大时，可以只读取前 n 行
pd.read_csv(filename, encoding='gbk', nrows = 6)

# 2.3 第一列作为行索引，忽略列索引
pd.read_csv(filename, encoding='gbk', header=None, index_col=0)

# 2.4 读取时忽略第 1/3/5 行和最后两行
pd.read_csv(filename, encoding='gbk', skiprows=[1,3,5], skipfooter=2, engine='python')

# 2.5 读取 excel 文件，使用第一列作为索引列
pd.read_excel('tets.xlsx', index_col=0)

# 2.6 保存数据
# 保存为 csv 文件
df.to_csv('test_ison.csv', encoding='gbk')  # 默认 utf8 编码
# 保存为 xlsx 文件
df.to_excel('test_xlsx.xlsx', index=False)
# 保存为 ison 文件
df.to_json('test_json.json')  # 默认 utf8 编码

# 将两个 df 保存到一个 Excel 的 2 个 sheet
with pd.ExcelWriter('test.xlsx', engine='xlsxwriter', datetime_format='YYYY-MM-DD') as writer:
    df1.to_excel(writer, sheet_name='Sheet1', index=False)
    df2.to_excel(writer, sheet_name='Sheet2', index=False)
```

## 3. 查看数据信息

### 3.1 查看概况

```python
df             # 查看前后 5 行
df.info()      # 查看索引、数据类型和内存信息
df.describe()  # 查看数值型列的汇总统计
df.shape       # 查看行数和列数

df.columns     # 查看列索引
df.index       # 查看行索引
```

### 3.2 查看部分行

```python
df.head(3)      # 查看前 n 行
df.tail(3)      # 查看后 n 行
df.sample(n)    # 查看 n 个随机样本
```

### 3.3 查看空行

```python
df.isna()          # 检查是否
df.isna().any()    # 检查哪些列包含缺失值
df.isna().sum()    # 统计各列空值数量

df.loc[df['high'].notna(), :]        # 显示非空行。
df.loc[df.notna().all(axis=1), :]    # 显示每行不包含空值的行
df.loc[df.isna().any(axis=1), :]     # 显示每行包含空值的行
```

### 3.4 查看重复行

```python
df['date'].is_unique            # 检查某列是否有重复项，输出 True 或 False
df['date'].duplicated()         # 输出某列每个元素重复情况（False、True），数据较多时用处不大。
df['date'].duplicated().sum()   # 查看重复行的个数。

df.duplicated(subset='date')    # 显示重复的行情况（False、True）。
df[df['date'].duplicated()]     # 显示重复的行。

df[~df.duplicated(subset='date')]    # 显示不重复的行。

df['date'].nunique()                 # 查看有多少不同的城市
```

## 4. 数据清洗

### 4.1 改名、改索引

```python
# 重命名列名
df.columns = ['姓名','性别','语文','数学','英语','城市','省份']
# 选择性更改列名
df.rename(columns={'姓名': '姓--名','性别': '性--别'},inplace=True)

# 4.3 批量更改索引
df.rename(lambda x: x + 10)

# 4.4 批量更改列名
df.rename(columns=lambda x: x + '_1')

# 4.5 设置姓名列为行索引
df.set_index('姓名')
```

### 4.2 删空

```python
# 4.6 检查哪些列包含缺失值
df.isnull().any()
# 4.7 统计各列空值
df.isnull().sum()

# 4.8 删除本列中空值的行
df[df['数学'].notnull()]
df[~df['数学'].isnull()]

# 4.9 仅保留本列中是空值的行
df[df['数学'].isnull()]
df[~df['数学'].notnull()]

# 4.12 删除所有包含空值的行
df.dropna()
# 4.13 删除行里全都是空值的行
df.dropna(how = 'all')
# 4.14 删除所有包含空值的列
df.dropna(axis=1)
# 4.15 保留至少有 6 个非空值的行
df.dropna(thresh=6)
# 4.16 保留至少有 11 个非空值的列
df.dropna(axis=1,thresh=11)

# 4.10 去掉某行
df.drop(0, axis=0)
# 4.11 去掉某列
df.drop('英语', axis=1)

df1 = df.pop(['class', 'age'])  # 取出某列并并创建新的 df，原 df 的列也被删除了

# 4.20 强制转换数据类型
df_t1 = df.dropna()
df_t1['语文'].astype('int')
```

### 4.3 填充空值

```python
# method 参数：{‘backfill’, ‘bfill’, ‘pad’, ‘ffill’, None}，默认为 None
# pad/ffill：用前一个非缺失值填充该缺失值
# backfill/bfill：用下一个非缺失值填充该缺失值
df.fillna(method='ffill')          # 行数据向下填充
df.fillna(method='ffill', axis=1)  # 列数据向右填充
df.fillna(0)                       # 用 0 替换所有的空值

# 插值填充，仅用于 Series
# method='linear' 线性插值、'nearest'最近邻插值、'index'索引插值。
# limit_direction 参数：If‘method’is‘backfill’or‘bfill’, the default is‘backward’
# else the default is ‘forward’
# limit 参数：控制最大连续缺失值插值个数
df['high'].interpolate()  # 与 fillna 的 method 中的 ffill 是类似的
df['high'].interpolate(method='linear', limit_direction='backward', limit=1)  # 线性插值插值填充、向后填充
```

### 4.4 去除重复项

```python
# 去重。索引只有去重之后，索引列才能重采样，否则会报错。
# 参考：https://zhuanlan.zhihu.com/p/116884554
# DataFrame.drop_duplicates(subset=None, keep='first', inplace=False)
df.drop_duplicates('date', keep='first', inplace=True)
# 去重后会导致索引不连续，重设一下索引就可以了。
# DataFrame.reset_index(level=None, drop=False, inplace=False, col_level=0, col_fill='')
# We can use the drop parameter to avoid the old index being added as a column:
df.reset_index(drop=True, inplace=True)
```

### 4.5 修改

```python
# 4.22 单值替换
df.replace('苏州', '南京')

# 4.23 多值替换
df.replace({'苏州':'南京','广州':'深圳'})
df.replace(['苏州','广州'],['南京','深圳'])

# 4.24 多值替换单值
df.replace(['深圳','广州'],'东莞')

# 4.25 替换某列，显示需要加 inplace=True
df['城市'] = df['城市'].replace('苏州', '南京')

# 拆分某列，生成新的 Dataframe
df1 = df['姓名'].str.split('-',expand=True)
df1.columns = ['学号','姓名']

# Series 的字符串的矢量方法。replace 默认是正则表达式，
df['date'] = df['date'].str.replace('/', '-', regex=True)

# 某一列类型转换，注意该列类型要一致，包括（NaN）
df1['语文'] = df1['语文'].apply(int)
```

## 5. 数据切片、筛选

```python
# 5.1 输出城市为上海
df[df['城市']=='上海']

# 5.2 输出城市为上海或广州
df[df['城市'].isin(['上海','广州'])]

# 5.3 输出城市名称中含有‘海’字的行
df[df['城市'].str.contains("海", na=False)]

# 5.4 输出城市名称以‘海’字开头的行
df[df['城市'].str.startswith("海", na=False)]

# 5.5 输出城市名称以‘海’字结尾的行
df[df['城市'].str.endswith("海", na=False)]

# 5.6 输出所有姓名，缺失值用 Null 填充
df['姓名'].str.cat(sep='、',na_rep='Null')

# 5.8 前两行
df2[:2]

# 5.9 后两行
df2[-2:]

# 5.10 2-8 行
df2[2:8]

# 5.11 每隔 3 行读取
df2[::3]

# 5.12 2-8 行，步长为 2，即第 2/4/6 行
df2[2:8:2]

# 5.13 选取'语文','数学','英语'列
df2[['语文','数学','英语']]

# df.loc[] 只能使用标签索引，不能使用整数索引，通过便签索引切边进行筛选时，前闭后闭
# 5.14 学号为'001'的行，所有列
df2.loc['001', :]

# 5.15 学号为'001'或'003'的行，所有列
df2.loc[['001','003'], :]

# 5.16 学号为'001'至'009'的行，所有列
df2.loc['001':'009', :]

# 5.17 列索引为'姓名'，所有行
df2.loc[:, '姓名']

# 5.18 列索引为'姓名'至‘城市’，所有行
df2.loc[:, '姓名':'城市']

# 5.19 语文成绩大于 80 的行
df2.loc[df2['语文']>80,:]
df2.loc[df2.loc[:,'语文']>80, :]
df2.loc[lambda df2:df2['语文'] > 80, :]

# 5.20 语文成绩大于 80 的人的学号和姓名
df2.loc[df2['语文']>80,['姓名','城市']]

# 5.21 输出'赵四'和'周七'的各科成绩
df2.loc[df2['姓名'].isin(['赵四','周七']),['姓名','语文','数学','英语']]

# # df.iloc[] 只能使用整数索引，不能使用标签索引，通过整数索引切边进行筛选时，前闭后开
# 5.22 选取第 2 行
df2.iloc[1, :]

# 5.23 选取前 3 行
df2.iloc[:3, :]

# 5.24 选取第 2 行、第 4 行、第 6 行
df2.iloc[[1,3,5],:]

# 5.25 选取第 2 列
df2.iloc[:, 1]

# 5.26 选取前 3 列
df2.iloc[:, 0:3]

# 5.27 选取第 3 行的第 3 列
df2.iloc[3, 3]

# 5.28 选取第 1 列、第 3 列和第 4 列
df2.iloc[:, [0,2,3]]

# 5.29 选取第 2 行的第 1 列、第 3 列、第 4 列
df2.iloc[1, [0,2,3]]

# 5.30 选取前 3 行的前 3 列
df2.iloc[:3, :3]
```

## 6. 数据排序

```python
# 6.1 重置索引
df_last = df1.reset_index(drop=True)

# 6.2 按照语文成绩升序排序，默认升序排列
df_last.sort_values('语文')

# 6.3 按照数学成绩降序排序
df_last.sort_values('数学', ascending=False)

# 6.4 先按语文成绩升序排列，再按数学成绩降序排列
df_last.sort_values(['语文','数学'], ascending=[True,False])

# 6.5 语文成绩 80 及以上
df_last[df_last['语文']>=80]
df_last.query('语文 > 80')

# 6.6 语文成绩 80 及以上以及数学成绩 90 分及以上
df_last[(df_last['语文']>=80) & (df_last['数学']>=90)]

# 6.7 语文成绩 80 及以上或数学成绩 90 分及以上
df_last[(df_last['语文']>=80) | (df_last['数学']>=90)]

# 6.8 输出成绩 100 的行和列号
row, col = np.where(df_last.values == 100)

# 6.9 增加一列“省份 - 城市”
df_last['省份 - 城市'] = df_last['省份'] + '-' + df_last['城市']

# 6.10 增加一列总分
df_last['总分'] = df_last[['语文','数学','英语']].sum(axis = 1)

# 6.11 按照总分、语文、数学、英语成绩依次排序
df_last.sort_values(by =['总分','语文','数学','英语'],ascending=False )

# 6.12 新增一列表示学生语文成绩等级的列（优秀、良好、中等、不及格）
def get_letter_grade(score):
    '''
    定义一个函数，根据分数返回相应的等级
    '''
    if score>=90:
        return '优秀'
    elif score>=80:
        return '良好'
    elif score>=60:
        return '中等'
    else:
        return '不及格'

df_last['语文等级'] = df_last['语文'].apply(lambda score: get_letter_grade(score))
```

## 7. 数据分组

```python
# 7.1 一列分组
df2.groupby('省份').groups

# 7.2 多列分组
df2.groupby(['省份','城市']).groups

# 7.3 每组的统计数据（横向显示）
df2.groupby('省份').describe()

# 7.4 每组的统计数据（纵向显示）
df2.groupby('省份').describe().unstack()

# 7.5 查看指定列的统计信息
df2.groupby('省份').describe()['语文']

# 7.6 分组大小
df2.groupby('省份').count()
df2.groupby('省份').agg(np.size)

# 7.7 分组成绩最大值
df2.groupby('省份').max()
df2.groupby('省份').agg(np.max)

# 7.8 分组成绩最小值
df2.groupby('省份').min()
df2.groupby('省份').agg(np.min)

# 7.9 分组成绩总和
df2.groupby('省份').sum()
df2.groupby('省份').agg(np.sum)

# 7.10 分组平均成绩
df2.groupby('省份').mean()
df2.groupby('省份').agg(np.mean)

# 7.11 按省份分组，计算英语成绩总分和平均分
df2.groupby('省份')['英语'].agg([np.sum, np.mean])

# 7.12 按省份、城市分组计算平均成绩
df2.groupby(['省份','城市']).agg(np.mean)

# 7.13 不同列不同的计算方法
df2.groupby('省份').agg({'语文': sum, # 总和
                        '数学': 'count', # 总数
                        '英语':'mean'}) # 平均

# 7.14 性别分别替换为 1/0
df2 = df2.dropna()
df2['性别'] = df2['性别'].map({'男':1, '女':0})

# 7.15 增加一列按省份分组的语文平均分
df2['语文平均分'] = df2.groupby('省份')['语文'].transform('mean')

# 7.16 输出语文成绩最高的男生和女生（groupby 默认会去掉空值）
def get_max(g):
    df = g.sort_values('语文',ascending=True)
    print(df)
    return df.iloc[-1,:]

df2.groupby('性别').apply(get_max)

# 7.17 按列省份、城市进行分组，计算语文、数学、英语成绩最大值的透视表
df.pivot_table(index=['省份','城市'], values=['语文','数学','英语'], aggfunc=max)
```

## 8. 数据统计

默认都是 `axis=0` 参数，计算列

```python
# 8.1 数据汇总统计
df.describe()

df.sum()  # 列求和

# 8.2 列中非空值的个数
df.count()

# 8.3 列最小值
df.min()

# 8.4 列最大值
df.max()

# 8.5 列均值
df.mean()

# 8.6 列中位数
df.median()

# 8.7 列与列之间的相关系数
df.corr()

# 8.8 列的标准差
df.std()

# 8.9 语文成绩指标
# 对语文列求和
sum0 = df_last['语文'].sum()
# 语文成绩方差
var = df_last['语文'].var()
# 语文成绩标准差
std = df_last['语文'].std()
# 语文平均分
mean = df_last['语文'].mean()

print('语文总分：',sum0)
print('语文平均分：',mean)
print('语文成绩标准差：',std)
print('语文成绩方差：',var)

# 8.10 三个科目的指标
mean = df_last[['语文','数学','英语']].mean()
var  = df_last[['语文','数学','英语']].var()
total = df_last[['语文','数学','英语']].sum()
std = df_last[['语文','数学','英语']].std()
rows = [total,mean,var,std]
# 索引列表
index = ['总分','平均分','方差','标准差']
# 根据指定索引和行构造 DataFrame 对象
df_tmp = pd.DataFrame(rows,index=index)
```

## 9. 表格样式

```python
# 9.3 设置空值背景红色
df.style.highlight_null(null_color = 'red')

# 9.4 最大数据高亮
df.style.highlight_max()

# 9.5 最小数据高亮
df.style.highlight_min()

# 9.6 部分列最大数据高亮
df.style.apply(highlight_max, subset=['语文', '数学'])

# 9.7 部分列数据高亮（Dataframe 全为数据）
df3 = df[['语文','数学','英语']]
def highlight_max(s):
    is_max = s == s.max()
    return ['background-color: yellow' if v else '' for v in is_max]

df3.style.apply(highlight_max)

# 9.8 95 分以上显示红色
def color_negative_red(val):
    color = 'red' if val > 95.0 else 'black'
    return 'color: %s' % color

df3.style.applymap(color_negative_red)

# 9.9 混合
df3.style.applymap(color_negative_red).apply(highlight_max)

# 9.10 设置 float 类型列数据大于 80.0 的背景高亮
yellow_css = 'background-color: yellow'
sfun = lambda x: yellow_css if type(x) == float and x > 80.0 else ''
df3.style.applymap(sfun)

# 9.11 设置数学成绩大于 80.0 分的行背景高亮
yellow_css = 'background-color: yellow'
sfun = lambda x: [yellow_css]*len(x) if x.数学 > 80.0 else ['']*len(x)
df3.style.apply(sfun, axis=1)

# 9.12 设置数学成绩大于 95.0 的行数据颜色为红色
def row_color(s):
    if s.数学 > 95:
        return ['color: red']*len(s)
    else:
        return ['']*len(s)

df3.style.apply(row_color, axis=1)

# 9.13 显示热度图
import seaborn as sns
cm = sns.light_palette("green", as_cmap=True)
df3.style.background_gradient(cmap=cm)
```
