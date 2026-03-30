# Pandas 速查手册

Pandas 是一个强大的分析结构化数据的工具集，它的使用基础是 Numpy（提供高性能的矩阵运算），用于数据清洗、数据挖掘、数据分析。

**教程相关：**

Pandas 官方教程：<https://pandas.pydata.org/pandas-docs/stable/user_guide/index.html>

Pandas 官方 Cookbook：<https://pandas.pydata.org/pandas-docs/stable/user_guide/cookbook.html>

Pandas 官方 API 参考手册：<https://pandas.pydata.org/pandas-docs/stable/reference/index.html>

利用 Python 进行数据分析·第 2 版  <https://seancheney.gitbook.io/python-for-data-analysis-2nd/>

Joyful Pandas:<http://joyfulpandas.datawhale.club/Content/index.html>

## 关键缩写和包导入

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
%matplotlib inline
```

## 导入数据

```python
# 从 CSV 文件导入数据
pd.read_csv('file.csv', name=['列名','列名 2'])
# 从限定分隔符的文本文件导入数据
pd.read_table(filename, header=0)
# Excel 导入，指定 sheet 和表头
pd.read_excel('file.xlsx', sheet_name=' 表 1', header=0)
# 从 SQL 表/库导入数据
pd.read_sql(query, connection_object)
# 从 JSON 格式的字符串导入数据
pd.read_json(json_string)
# 解析 URL、字符串或者 HTML 文件，抽取其中的 tables 表格
pd.read_html(url)
# 从你的粘贴板获取内容，并传给 read_table()
pd.read_clipboard()
# 从字典对象导入数据，Key 是列名，Value 是数据
pd.DataFrame(dict)
# 导入字符串
from io import StringIO
pd.read_csv(StringIO(web_data.text))
```

## 导出输出数据

```python
# 导出数据到 CSV 文件
df.to_csv('filename.csv')
# 导出数据到 Excel 文件
df.to_excel('filename.xlsx', index=True)
# 导出数据到 SQL 表
df.to_sql(table_name, connection_object)
# 以 Json 格式导出数据到文本文件
df.to_json(filename)
# 其他
df.to_html()  # 显示 HTML 代码
df.to_markdown() # 显示 markdown 代码
df.to_string() # 显示格式化字符
df.to_latex(index=False) # LaTeX tabular, longtable
df.to_dict('split') # 字典，格式 list/series/records/index
df.to_clipboard(sep=',', index=False) # 存入系统剪贴板

# 将两个表格输出到一个 excel 文件里面，导出到多个 sheet
writer=pd.ExcelWriter('new.xlsx')
df_1.to_excel(writer,sheet_name='第一个', index=False)
df_2.to_excel(writer,sheet_name='第二个', index=False)
writer.save() # 必须运行 writer.save()，不然不能输出到本地

# 写法 2
with pd.ExcelWriter('new.xlsx') as writer:
    df1.to_excel(writer, sheet_name='第一个')
    df2.to_excel(writer, sheet_name='第二个')
# 用 xlsxwriter 导出支持合并单元格、颜色、图表等定制功能
# https://xlsxwriter.readthedocs.io/working_with_pandas.html
```

## 创建测试对象

```python
# 创建 20 行 5 列的随机数组成的 DataFrame 对象
pd.DataFrame(np.random.rand(20,5))
# 从可迭代对象 my_list 创建一个 Series 对象
pd.Series(my_list)
# 增加一个日期索引
df.index = pd.date_range('1900/1/30', periods=df.shape[0])
# 创建随机数据集
df = pd.util.testing.makeDataFrame()
# 创建随机日期索引数据集
df = pd.util.testing.makePeriodFrame()
df = pd.util.testing.makeTimeDataFrame()
# 创建随机混合类型数据集
df = pd.util.testing.makeMixedDataFrame()
```

## 查看、检查、统计、属性

```python
df.head(n) # 查看 DataFrame 对象的前 n 行
df.tail(n) # 查看 DataFrame 对象的最后 n 行
df.sample(n) # 查看 n 个样本，随机
df.shape # 查看行数和列数
df.info() # 查看索引、数据类型和内存信息
df.describe() # 查看数值型列的汇总统计
df.dtypes # 查看各字段类型
df.axes # 显示数据行和列名
df.mean() # 返回所有列的均值
df.mean(1) # 返回所有行的均值，下同
df.corr() # 返回列与列之间的相关系数
df.count() # 返回每一列中的非空值的个数
df.max() # 返回每一列的最大值
df.min() # 返回每一列的最小值
df.median() # 返回每一列的中位数
df.std() # 返回每一列的标准差
df.var() # 方差
s.mode() # 众数
s.prod() # 连乘
s.cumprod() # 累积连乘，累乘
df.cumsum(axis=0) # 累积连加，累加
s.nunique() # 去重数量，不同值的量
df.idxmax() # 每列最大的值的索引名
df.idxmin() # 最小
df.columns # 显示所有列名
df.team.unique() # 显示列中的不重复值
# 查看 Series 对象的唯一值和计数，计数占比：normalize=True
s.value_counts(dropna=False)
# 查看 DataFrame 对象中每一列的唯一值和计数
df.apply(pd.Series.value_counts)
df.duplicated() # 重复行
df.drop_duplicates() # 删除重复行
# set_option、reset_option、describe_option 设置显示要求
pd.get_option()
# 设置行列最大显示数量，None 为不限制
pd.options.display.max_rows = None
pd.options.display.max_columns = None
df.col.argmin() # 最大值 [最小值 .argmax()] 所在位置的自动索引
df.col.idxmin() # 最大值 [最小值 .idxmax()] 所在位置的定义索引
# 累计统计
ds.cumsum() # 前边所有值之和
ds.cumprod() # 前边所有值之积
ds.cummax() # 前边所有值的最大值
ds.cummin() # 前边所有值的最小值
# 窗口计算 (滚动计算)
ds.rolling(x).sum() #依次计算相邻 x 个元素的和
ds.rolling(x).mean() #依次计算相邻 x 个元素的算术平均
ds.rolling(x).var() #依次计算相邻 x 个元素的方差
ds.rolling(x).std() #依次计算相邻 x 个元素的标准差
ds.rolling(x).min() #依次计算相邻 x 个元素的最小值
ds.rolling(x).max() #依次计算相邻 x 个元素的最大值
```

## 数据清理

```python
df.columns = ['a','b','c'] # 重命名列名
df.rename(columns={'姓名': '姓--名','性别': '性--别'})  # 4.2 选择性更改列名
df.columns = df.columns.str.replace(' ', '_') # 列名空格换下划线
df.loc[df.AAA >= 5, ['BBB', 'CCC']] = 555 # 替换数据
df['pf'] = df.site_id.map({2: '小程序', 7:'M 站'}) # 将枚举换成名称
pd.isnull() # 检查 DataFrame 对象中的空值，并返回一个 Boolean 数组
pd.notnull() # 检查 DataFrame 对象中的非空值，并返回一个 Boolean 数组
df.drop(['name'], axis=1) # 删除列
df.drop([0, 10], axis=0) # 删除行
del df['name'] # 删除列
df.dropna() # 删除所有包含空值的行
df.dropna(axis=1) # 删除所有包含空值的列
df.dropna(axis=1,thresh=n) # 删除所有小于 n 个非空值的行
df.fillna(x) # 用 x 替换 DataFrame 对象中所有的空值
df.fillna(value={'prov':'未知'}) # 指定列的空值替换为指定内容
s.astype(float) # 将 Series 中的数据类型更改为 float 类型
df.index.astype('datetime64[ns]') # 转化为时间格式
s.replace(1, 'one') # 用‘one’代替所有等于 1 的值
s.replace([1, 3],['one','three']) # 用'one'代替 1，用 'three' 代替 3
df.rename(columns=lambda x: x + 1) # 批量更改列名
df.rename(columns={'old_name': 'new_name'}) # 选择性更改列名
df.set_index('column_one') # 更改索引列
df.rename(index=lambda x: x + 1) # 批量重命名索引
# 重新命名表头名称
df.columns = ['UID', '当前待打款金额', '认证姓名']
df['是否设置提现账号'] = df['状态'] # 复制一列
df.loc[:, ::-1] # 列顺序反转
df.loc[::-1] # 行顺序反转，下方为重新定义索引
df.loc[::-1].reset_index(drop=True)
```

## 数据处理：Filter、Sort

```python
# 保留小数位，四舍六入五成双
df.round(2) # 全部
df.round({'A': 1, 'C': 2}) # 指定列
df['Name'] = df.Name # 取列名的两个方法
df[df.index == 'Jude'] # 索引列的查询要用 .index
df[df[col] > 0.5] # 选择 col 列的值大于 0.5 的行
# 多条件查询
df[(df['team'] == 'A') &
   ( df['Q1'] > 80) &
   df.utype.isin(['老客', '老访客'])]
# 筛选为空的内容
df[df.order.isnull()]
# 类似 SQL where in
df[df.team.isin('A','B')]
df[(df.team=='B') & (df.Q1 == 17)]
df[~(df['team'] == 'A') | ( df['Q1'] > 80)] # 非，或
df[df.Name.str.contains('张')] # 包含字符
df.sort_values(col1) # 按照列 col1 排序数据，默认升序排列
df.col1.sort_values() # 同上，-> s
df.sort_values(col2, ascending=False) # 按照列 col1 降序排列数据
# 先按列 col1 升序排列，后按 col2 降序排列数据
df.sort_values([col1,col2], ascending=[True,False])
df2 = pd.get_dummies(df, prefix='t_') # 将枚举的那些列带枚举转到列上
s.set_index().plot()
# 多索引处理
dd.set_index(['utype', 'site_id', 'p_day'], inplace=True)
dd.sort_index(inplace=True) # 按索引排序
dd.loc['新访客', 2, '2019-06-22'].plot.barh() # loc 中按顺序指定索引内容
# 前 100 行，不能指定行，如：df[100]
df[:100]
# 只取指定行
df1 = df.loc[0:, ['设计师 ID', '姓名']]
# 将 ages 平分成 5 个区间并指定 labels
ages = np.array([1,5,10,40,36,12,58,62,77,89,100,18,20,25,30,32])
pd.cut(ages, [0,5,20,30,50,100],
       labels=[u"婴儿",u"青年",u"中年",u"壮年",u"老年"])

daily_index.difference(df_work_day.index) # 取出差别
# 格式化
df.index.name # 索引的名称 str
df.columns.tolist()
df.values.tolist()
df.总人口.values.tolist()
data.apply(np.mean) # 对 DataFrame 中的每一列应用函数 np.mean
data.apply(np.max,axis=1) # 对 DataFrame 中的每一行应用函数 np.max
df.insert(1, 'three', 12, allow_duplicates=False) # 插入列 (位置、列名、[值])
df.pop('class') # 删除列
# 增加一行
df.append(pd.DataFrame({'one':2,
                        'two':3,
                        'three': 4.4},
                       index=['f']),
          sort=True)
# 指定新列
iris.assign(sepal_ratio=iris['SepalWidth'] / iris['SepalLength']).head()
df.assign(rate=lambda df: df.orders/df.uv)
# shift 函数是对数据进行平移动的操作
df['增幅'] = df['国内生产总值'] - df['国内生产总值'].shift(-1)
df.tshift(1) # 时间移动，按周期
# 和上相同，diff 函数是用来将数据进行移动之后与原数据差
# 异数据，等于 df.shift()-df
df['增幅'] = df['国内生产总值'].diff(-1)
# 留存数据，因为最大一般为数据池
df.apply(lambda x: x/x.max(), axis=1)

# 取 best 列中值为列名的值写到 name 行上
df['value'] = df.lookup(df['name'], df['best'])

s.where(s > 1, 10) # 满足条件下数据替换（10，空为 NaN）
s.mask(s > 0) # 留下满足条件的，其他的默认为 NaN
# 所有值加 1 (加减乘除等)
df + 1 / df.add(1)
# 管道方法，链式调用函数，f(df)=df.pipe(f)
def gb(df, by):
    result = df.copy()
    result = result.groupby(by).sum()
    return result
# 调用
df.pipe(gb, by='team')
# 窗口计算 '2s' 为两秒
df.rolling(2).sum()
# 在窗口结果基础上的窗口计算
df.expanding(2).sum()
# 超出（大于、小于）的值替换成对应值
df.clip(-4, 6)
# AB 两列想加增加 C 列
df['C'] = df.eval('A+B')
# 和上相同效果
df.eval('C = A + B', inplace=True)
# 数列的变化百分比
s.pct_change(periods=2)
# 分位数，可实现时间的中间点
df.quantile(.5)
# 排名 average, min,max,first，dense, 默认 average
s.rank()
# 数据爆炸，将本列的类列表数据和其他列的数据展开铺开
df.explode('A')
# 枚举更新
status = {0:'未执行', 1:'执行中', 2:'执行完毕', 3:'执行异常'}
df['taskStatus'] = df['taskStatus'].apply(status.get)
df.assign(金额=0) # 新增字段
df.loc[('bar', 'two'), 'A'] # 多索引查询
df.query('i0 == "b" & i1 == "b"') # 多索引查询方法 2
# 取多索引中指定级别的所有不重复值
df.index.get_level_values(2).unique()
# 去掉为零小数，12.00 -> 12
df.astype('str').applymap(lambda x: x.replace('.00', ''))
# 插入数据，在第三列加入「两倍」列
df.insert(3, '两倍', df['值']*2)
# 枚举转换
df['gender'] = df.gender.map({'male':'男', 'female':'女'})
# 增加本行之和列
df['Col_sum'] = df.apply(lambda x: x.sum(), axis=1)
# 对指定行进行加和
col_list= list(df)[2:] # 取请假范围日期
df['总天数'] = df[col_list].sum(axis=1) # 计算总请假天数
# 对列求和，汇总
df.loc['col_sum'] = df.apply(lambda x: x.sum())
# 按指定的列表顺序显示
df.reindex(order_list)
# 按指定的多列排序
df.reindex(['col_1', 'col_5'], axis="columns")
```

## 数据选取

```python
df[col] # 根据列名，并以 Series 的形式返回列
df[[col1, col2]] # 以 DataFrame 形式返回多列
df.loc[df['team'] == 'B',['name']] # 按条件查询，只显示 name 列
s.iloc[0] # 按位置选取数据
s.loc['index_one'] # 按索引选取数据
df.loc[0,'A':'B'] #  A 到 B 字段的第一行
df.loc[2018:1990, '第一产业增加值':'第三产业增加值']
df.loc[0,['A','B']] # d.loc[位置切片，字段]
df.iloc[0,:] # 返回第一行，iloc 只能是数字
df.iloc[0,0] # 返回第一列的第一个元素
dc.query('site_id > 8 and utype=="老客"').head() # 可以 and or / & |
 # 迭代器及使用
for idx,row in df.iterrows(): row['id']
# 迭代器对每个元素进行处理
df.loc[i,'链接'] = f'http://www.gairuo.com/p/{slug}.html'
for i in df.Name:print(i) # 迭代一个列
# 按列迭代，[列名，列中的数据序列 S（索引名 值)]
for label, content in df.items():print(label, content)
# 按行迭代，迭代出整行包括索引的类似列表的内容，可 row[2] 取
for row in df.itertuples():print(row)
df.at[2018, '总人口'] # 按行列索引名取一个指定的单个元素
df.iat[1, 2] # 索引和列的编号取单个元素
s.nlargest(5).nsmallest(2) # 最大和最小的前几个值
df.nlargest(3, ['population', 'GDP'])
df.take([0, 3]) # 指定多个行列位置的内容
# 按行列截取掉部分内容，支持日期索引标签
ds.truncate(before=2, after=4)
# 将 dataframe 转成 series
df.iloc[:,0]
float(str(val).rstrip('%')) # 百分数转数字
df.reset_index(inplace=True) # 取消索引
```

## 数据处理 GroupBy 透视

```python
df.groupby(col) # 返回一个按列 col 进行分组的 Groupby 对象
df.groupby([col1,col2]) # 返回一个按多列进行分组的 Groupby 对象
df.groupby(col1)[col2] # 返回按列 col1 进行分组后，列 col2 的均值
# 创建一个按列 col1 进行分组，并计算 col2 和 col3 的最大值的数据透视表
df.pivot_table(index=col1,
               values=[col2,col3],
               aggfunc=max,
               as_index=False)
# 同上
df.pivot_table(index=['site_id', 'utype'],
               values=['uv_all', 'regist_num'],
               aggfunc=['max', 'mean'])
df.groupby(col1).agg(np.mean) # 返回按列 col1 分组的所有列的均值
# 按列将其他列转行
pd.melt(df, id_vars=["day"], var_name='city', value_name='temperature')
# 交叉表是用于统计分组频率的特殊透视表
pd.crosstab(df.Nationality,df.Handedness)
# groupby 后排序，分组 agg 内的元素取固定个数
(
    df[(df.p_day >= '20190101')]
    .groupby(['p_day', 'name'])
    .agg({'uv':sum})
    .sort_values(['p_day','uv'], ascending=[False, False])
    .groupby(level=0).head(5) # 每天取 5 个页面
    .unstack()
    .plot()
)
# 合并查询经第一个看（max, min, last, size:数量）
df.groupby('结算类型').first()
# 合并明细并分组统计加总（'max', `mean`, `median`,
# `prod`, `sum`, `std`,`var`, 'nunique'）,'nunique'为去重的列表
df1 = df.groupby(by='设计师 ID').agg({'结算金额':sum})
df.groupby(by=df.pf).ip.nunique() # groupby distinct, 分组 + 去重数
df.groupby(by=df.pf).ip.value_counts() # groupby 分组 + 去重的值及数量
df.groupby('name').agg(['sum', 'median', 'count'])
```

## 数据合并

```python
# 合并拼接行
# 将 df2 中的行添加到 df1 的尾部
df1.append(df2)
# 指定列合并成一个新表新列
ndf = (df['提名 1']
       .append(df['提名 2'], ignore_index=True)
       .append(df['提名 3'], ignore_index=True))
ndf = pd.DataFrame(ndf, columns=(['姓名']))
# 将 df2 中的列添加到 df1 的尾部
df.concat([df1, df2], axis=1)

# 合并文件的各行
df1 = pd.read_csv('111.csv', sep='\t')
df2 = pd.read_csv('222.csv', sep='\t')
excel_list = [df1, df2]
# result = pd.concat(excel_list).fillna('')[:].astype('str')
result = pd.concat(excel_list)[]
result.to_excel('333.xlsx', index=False)

# 合并指定目录下所有的 excel (csv) 文件
import glob
files = glob.glob("data/cs/*.xls")
dflist = []
for i in files:
    dflist.append(pd.read_excel(i, usecols=['ID', '时间', '名称']))

df = pd.concat(dflist)

# 合并增加列
# 对 df1 的列和 df2 的列执行 SQL 形式的 join
df1.join(df2,on=col1,how='inner')
# 用 key 合并两个表
df_all = pd.merge(df_sku, df_spu,
                  how='left',
                  left_on=df_sku['product_id'],
                  right_on=df_spu['p.product_id'])
```

## 时间处理 时间序列

```python
# 时间索引
df.index = pd.DatetimeIndex(df.index)
# 时间只保留日期
df['date'] = df['time'].dt.date
# 将指定字段格式化为时间类型
df["date"] = pd.to_datetime(df['时间'])
# 转化为北京时间
df['time'] = df['time'].dt.tz_convert('Asia/Shanghai')
# 转为指定格式，可能会失去秒以后的精度
df['time'] = df['time'].dt.strftime("%Y-%m-%d %H:%M:%S")
dc.index = pd.to_datetime(dc.index, format='%Y%m%d', errors='ignore')
# 时间，参与运算
pd.DateOffset(days=2)
# 当前时间
pd.Timestamp.now()
pd.to_datetime('today')
# 判断时间是否当天
pd.datetime.today().year == df.start_work.dt.year
df.time.astype('datetime64[ns]').dt.date == pd.to_datetime('today')
# 定义个天数
import datetime
days = lambda x: datetime.timedelta(days=x)
days(2)
# 同上，直接用 pd 包装的
pd.Timedelta(days=2)
# unix 时间戳
pd.to_datetime(ted.film_date, unit='ms')
# 按月（YMDHminS）采集合计数据
df.set_index('date').resample('M')['quantity'].sum()
df.set_index('date').groupby('name')['ext price'].resample("M").sum()
# 按天汇总，index 是 datetime 时间类型
df.groupby(by=df.index.date).agg({'uu':'count'})
# 按周汇总
df.groupby(by=df.index.weekday).uu.count()
# 按月进行汇总
df.groupby(['name', pd.Grouper(key='date', freq='M')])['ext price'].sum()
# 按月进行汇总
df.groupby(pd.Grouper(key='day', freq='1M')).sum()
# 按照年度，且截止到 12 月最后一天统计 ext price 的 sum 值
df.groupby(['name', pd.Grouper(key='date', freq='A-DEC')])['ext price'].sum()
# 按月的平均重新采样
df['Close'].resample('M').mean()
# https://pandas.pydata.org/pandas-docs/stable/user_guide/timeseries.html#offset-aliases
# 取时间范围，并取工作日
rng = pd.date_range(start="6/1/2016",end="6/30/2016",freq='B')
# 重新定时数据频度，按一定补充方法
df.asfreq('D', method='pad')
# 时区，df.tz_convert('Europe/Berlin')
df.time.tz_localize(tz='Asia/Shanghai')
# 转北京时间
df['Time'] = df['Time'].dt.tz_localize('UTC').dt.tz_convert('Asia/Shanghai')
# 查看所有时区
from pytz import all_timezones
print (all_timezones)
# 时长，多久，两个时间间隔时间，时差
df['duration'] = pd.to_datetime(df['end']) - pd.to_datetime(df['begin'])
# 指定时间进行对比
df.Time.astype('datetime64[ns]') < pd.to_datetime('2019-12-11 20:00:00', format='%Y-%m-%d %H:%M:%S')
```

## 常用备忘

```python
# 解决科学计数法问题
df = pd.read_csv('111.csv', sep='\t').fillna('')[:].astype('str')
# 和订单量相关性最大到小显示
dd.corr().total_order_num.sort_values(ascending=False)

# 解析列表、json 字符串
import ast
ast.literal_eval("[{'id': 7, 'name': 'Funny'}]")

# Series apply method applies a function to
# every element in a Series and returns a Series
ted.ratings.apply(str_to_list).head()
# lambda is a shorter alternative
ted.ratings.apply(lambda x: ast.literal_eval(x))
# an even shorter alternative is to apply the
# function directly (without lambda)
ted.ratings.apply(ast.literal_eval)
# 索引 index 使用 apply()
df.index.to_series().apply()
```

## 样式显示

```python
# https://pbpython.com/styling-pandas.html
df['per_cost'] = df['per_cost'].map('{:,.2f}%'.format)  # 显示%比形式
# 指定列表（值大于 0）加背景色
df.style.applymap(lambda x: ' color: rgb(0, 128, 0); font-weight: bold;">if x>0 else '',
                  subset=pd.IndexSlice[:, ['B', 'C']])

# 最大值最小值加背景色
df.style.highlight_max(color='lightgreen').highlight_min(color='#cd4f39')
df.style.format('{:.2%}', subset=pd.IndexSlice[:, ['B']]) # 显示百分号

# 指定各列的样式
format_dict = {'sum':'${0:,.0f}',
                       'date': '{:%Y-%m}',
                       'pct_of_total': '{:.2%}'
                       'c': str.upper}

# 一次性样式设置
(df.style.format(format_dict) # 多种样式形式
    .hide_index()
    # 指定列按颜色深度表示值大小，cmap 为 matplotlib colormap
    .background_gradient(subset=['sum_num'], cmap='BuGn')
    # 表格内作横向 bar 代表值大小
    .bar(color='#FFA07A', vmin=100_000, subset=['sum'], align='zero')
    # 表格内作横向 bar 代表值大小
    .bar(color='lightgreen', vmin=0, subset=['pct_of_total'], align='zero')
    # 下降（小于 0）为红色，上升为绿色
    .bar(color=['#ffe4e4','#bbf9ce'], vmin=0, vmax=1, subset=['增长率'], align='zero')
    # 给样式表格起个名字
    .set_caption('2018 Sales Performance')
    .hide_index())

# 按条件给整行加背景色（样式）
def background_color(row):
    if row.pv_num >= 10000:
        return [' color: rgb(108, 108, 108);">] * len(row)
    elif row.pv_num >= 100:
        return [' color: rgb(108, 108, 108);">] * len(row)
    return [''] * len(row)
# 使用
df.style.apply(background_color, axis=1)
```

## 表格中的直方图，sparkline 图形

```python
import sparklines
import numpy as np
def sparkline_str(x):
    bins=np.histogram(x)[0]
    sl = ''.join(sparklines.sparklines(bins))
    return sl
sparkline_str.__name__ = "sparkline"
# 画出趋势图，保留两位小数
df.groupby('name')['quantity', 'ext price'].agg(['mean', sparkline_str]).round(2)

# sparkline 图形
# https://hugoworld.wordpress.com/2019/01/26/sparklines-in-jupyter-notebooks-ipython-and-pandas/
def sparkline(data, figsize=(4, 0.25), **kwargs):
    """
    creates a sparkline
    """

    # Turn off the max column width so the images won't be truncated
    pd.set_option('display.max_colwidth', -1)

    # Turning off the max column will display all the data
    # if gathering into sets / array we might want to restrict to a few items
    pd.set_option('display.max_seq_items', 3)

    #Monkey patch the dataframe so the sparklines are displayed
    pd.DataFrame._repr_html_ = lambda self: self.to_html(escape=False)

    from matplotlib import pyplot as plt
    import base64
    from io import BytesIO

    data = list(data)

    *_, ax = plt.subplots(1, 1, figsize=figsize, **kwargs)
    ax.plot(data)
    ax.fill_between(range(len(data)), data, len(data)*[min(data)], alpha=0.1)
    ax.set_axis_off()

    img = BytesIO()
    plt.savefig(img)
    plt.close()
    return '<img src="data:image/png;base64, {}" />'.format(base64.b64encode(img.getvalue()).decode())

# 使用
df.groupby('name')['quantity', 'ext price'].agg(['mean', sparkline])
df.apply(sparkline, axis=1) # 仅支持横向数据画线，可做 T 转置
```

## 可视化

- <https://www.jianshu.com/p/3937798d645b>
- <https://www.cnblogs.com/vamei/archive/2013/01/30/2879700.html>

```python
kind : str
- 'line' : line plot (default)
- 'bar' : vertical bar plot
- 'barh' : horizontal bar plot
- 'hist' : histogram
- 'box' : boxplot
- 'kde' : Kernel Density Estimation plot
- 'density' : same as 'kde'
- 'area' : area plot
- 'pie' : pie plot
```

常用方法：

```python
df88.plot.bar(y='rate', figsize=(20, 10)) # 图形大小，单位英寸
df_1[df_1.p_day > '2019-06-01'].plot.bar(x='p_day',\y=['total_order_num','order_user'], figsize=(16, 6)) # 柱状图
# 每条线一个站点，各站点的 home_remain, stack 的意思是堆叠，堆积
# unstack 即“不要堆叠”
(df[(df.p_day >= '2019-05-1') & (df.utype == '老客')]\.groupby(['p_day', 'site_id'])['home_remain'].sum().unstack().plot.line())
#  折线图，多条，x 轴默认为 index
dd.plot.line(x='p_day', y=['uv_all', 'home_remain'])
dd.loc['新访客', 2].plot.scatter(x='order_user', y='paid_order_user') # 散点图
dd.plot.bar(color='blue') # 柱状图，barh 为横向柱状图
sns.heatmap(dd.corr()) # 相关性可视化
#  刻度从 0 开始，指定范围 ylim=(0,100), x 轴相同
s.plot.line(ylim=0)

# 折线颜色 https://matplotlib.org/examples/color/named_colors.html
# 样式 ( '-','--','-.',':' )
# 折线标记 https://matplotlib.org/api/markers_api.html
# grid=True 显示刻度 etc: https://matplotlib.org/api/_as_gen/matplotlib.pyplot.plot.html
s.plot.line(color='green', linestyle='-', marker='o')

# 两个图绘在一起
[df['数量'].plot.kde(), df['数量'].plot.hist()]

# 对表中的数据按颜色可视化
import seaborn as sns
cm = sns.light_palette("green", as_cmap=True)
df.style.background_gradient(cmap=cm, axis=1)

# 将数据转化为二维数组
[i for i in zip([i.strftime('%Y-%m-%d') for i in s.index.to_list()], s.to_list())]

# 和 plot 用法一样 https://hvplot.pyviz.org/user_guide/Plotting.html
import hvplot.pandas

# 打印 Sqlite 建表语句
print(pd.io.sql.get_schema(fdf, 'table_name'))
```

## Jupyter notebooks 问题

```python
# jupyter notebooks plt 图表配置
import matplotlib.pyplot as plt
plt.rcParams['figure.figsize'] = (15.0, 8.0) # 固定显示大小
plt.rcParams['font.family'] = ['sans-serif'] # 显示中文问题
plt.rcParams['font.sans-serif'] = ['SimHei'] # 显示中文问题

# jupyter notebooks 页面自适应宽度
from IPython.core.display import display, HTML
display(HTML("<style>.container { width:100% !important; }</style>"))
# 背景白色 <style>#notebook_panel {background: #ffffff;}</style>

# jupyter notebooks 嵌入页面内容
from IPython.display import IFrame
IFrame('https://arxiv.org/pdf/1406.2661.pdf', width=800, height=450)

# Markdown 一个 cell 不支持多张粘贴图片
# 一个文件打印打开只显示一张图片问题解决
# /site-packages/notebook/static/notebook/js/main.min.js var key 处
# 33502、33504 行
key = utils.uuid().slice(2,6)+encodeURIandParens(blob.name);
key = utils.uuid().slice(2,6)+Object.keys(that.attachments).length;
# https://github.com/ihnorton/notebook/commit/55687c2dc08817da587977cb6f19f8cc0103bab1

# 多行输出
from IPython.core.interactiveshell import InteractiveShell
InteractiveShell.ast_node_interactivity = 'all' #默认为'last'

# 执行 shell 命令：! <命令语句>

# 在线可视化工具
https://plot.ly/create
```

## Pandas 库实例

Pandas 库实例：
Pandas 是 Python 第三方库，提供高性能易用数据类型和分析工具。
         import pandans as pd
Pandas 基于 NumPy 实现，常与 NumPy 和 Matplotlib 一同使用。
理解 pandas 库，首先要理解 Series 和 DataFrame 两个数据类型。
Series = 索引 + 一维数据，相当于一个一维数据类型。
DataFrame = 行列索引 + 二维数据，相当于一个二维到多维的数据类型。
这两个数据类型构成了 Pandas 的基础，围绕这两个数据类型，
Pandas 提供了针对数据分析和操作的很多功能
基于上述数据类型的各类操作
基本操作、运算操作、特征类操作、关联类操作
对比一下 NumPy 和 Pandas
NumPy                                   Pandas
提供了数据类型 (ndarray)              扩展数据类型 (Series、DataFrame)
关注数据的结构表达                    关注数据的应用表达
维度：数据间的关系                    数据与索引间关系
数据的结构表达就是数据之间构成的维度，也就是说。给定一组数据，这组数据通过一种什么样的维度，
将数据存储并表示出来，所以在 NumPy 中，我们看到的是 n 维数据类型，数据通过 n 维的方式存储到一个变量中。

数据的应用表达，也就是在使用数据的时候，怎么更有效地提取数据以及对这些数据进行运算。
我们知道，把数据维度之间关系建立好，应该能把数据的结构表达清楚，但是在使用数据的时候，
过于紧密的维度关系并不利于数据的实际应用，因此 Pandas 并没有过分的关注数据结构表达，而是
关注数据的应用表达，体现在数据与索引之间的关系，无论是 Series 还是 DataFrame 哪种数据类型，
它都支持非常明确和有效的索引，通过索引，可以对数据做相关的分析和提取。而 Pandas 最关键的
就是把我们要关心的数据与索引形成了关系，而通过这种数据和索引的关系，使得数据的应用变得
非常方便，所以理解 NumPy 和 Pandas，不只是要理解到 Pandas 是基于 NumPy 实现的扩展库，更主要的
要理解到 Pandas 要关注的重点是什么。因为我们要的数据都是要为了应用的，所以重点在于对数据
的应用，建立起数据跟索引之间的关系。
理解数据类型与索引的关系，操作索引即操作数据。
理解重新索引、数据删除、算术运算、比较运算。
Pandas 让我们象对待单一数据一样对待 Series 和 DataFrame 对象。

Series 类型
Series 类型由一组数据及与之相关的数据索引组成。

```python
    index_0————>data_a
    index_1————>data_b
    index_2————>data_c
    index_3————>data_d
     索引         数据
```

Series 类型可以由如下类型创建
    1、Python 列表，index 与列表元素个数一致。
    2、标量值，index 表达 Series 类型的尺寸。
    3、Python 字典，键值对中的“键”是索引，index 从字典中进行选择操作。
    4、ndarray，索引和数据都可以通过 ndarray 类型创建。
    5、其它函数，range() 函数等。

```python
import pandas as pd
1、从列表创建
a = pd.Series([9, 8, 7, 6])
a
0    9
1    8
2    7
3    6
dtype: int64  #NumPy 中数据类型

# 其中，0,1,2,3 是自动索引

# 如果 index 作为第二个参数，可以省略 index=
b = pd.Series([9, 8, 7, 6], index = ['a', 'b', 'c', 'd'])
b
a    9
b    8
c    7
d    6
dtype: int64

# 其中，a,b,c,d 是自定义索引

2、从标量值创建，此时不能省略index=，要告诉Series
尽管给了一个值25，但是要生成的数组类型是什么结构，
必须由第二个参数index来指定。
s = pd.Series(25, index = ['a', 'b', 'c'])
s
a    25
b    25
c    25
dtype: int64

3、从字典类型创建
d = pd.Series({'a':9, 'b':8, 'c':7})
d
a    9
b    8
c    7
dtype: int64

#index 从字典中进行选择操作
e = pd.Series({'a':9, 'b':8, 'c':7}, index=['c', 'a', 'b', 'd'])
e
c    7.0
a    9.0
b    8.0
d    NaN
dtype: float64

4、从ndarray创建
n = pd.Series(np.arange(5))
n
0    0
1    1
2    2
3    3
4    4
dtype: int32

m = pd.Series(np.arange(5), index = np.arange(9,4,-1))
m
9    0
8    1
7    2
6    3
5    4
dtype: int32

5、从其他函数创建
d = pd.Series(range(20))
d
0      0
1      1
2      2
3      3
4      4
5      5
6      6
7      7
8      8
9      9
10    10
11    11
12    12
13    13
14    14
15    15
16    16
17    17
18    18
19    19
dtype: int64

d.cumsum()
0       0
1       1
2       3
3       6
4      10
5      15
6      21
7      28
8      36
9      45
10     55
11     66
12     78
13     91
14    105
15    120
16    136
17    153
18    171
19    190
dtype: int64

Series类型的基本操作
    Series类型包括index和values两部分。
    Series类型的操作类似ndarray类型。
    Series类型的操作类似Python字典类型。

b = pd.Series([9, 8, 7, 6], ['a', 'b', 'c', 'd'])
b
a    9
b    8
c    7
d    6
dtype: int64

#.index 获得索引
b.index
Index(['a', 'b', 'c', 'd'], dtype='object')

#.values 获得数据
b.values
array([9, 8, 7, 6], dtype=int64)

#自动索引 (1) 和自定义索引 ('b') 并存
b['b']
8

b[1]
8

b[['c', 'd', 'a']]
c    7
d    6
a    9
dtype: int64

#两套索引并存，但不能混用。
#当两种索引混合使用时，会被当做自定义索引
#由于没有 0 号索引存在，所以数组会产生一个 0 号索引
#并关联一个 NaN 值
b[['c', 'd', 0]]
c    7.0
d    6.0
0    NaN
dtype: float64

Series类型的操作类似ndarray类型
    1、索引方法相同，采用[]。
    2、NumPy中运算和操作可用于Series类型。
    3、可以通过自定义索引的列表进行切片。
    4、可以通过自动索引进行切片，如果存在自定义索引，则一同被切片。

b = pd.Series([9, 8, 7, 6], ['a', 'b', 'c', 'd'])
b
a    9
b    8
c    7
d    6
dtype: int64

b[3]
6

b[:3]
a    9
b    8
c    7
dtype: int64

b[b > b.median()]
a    9
b    8
dtype: int64

np.exp(b)
a    8103.083928
b    2980.957987
c    1096.633158
d     403.428793
dtype: float64

Series类型的操作类似Python字典类型
    1、通过自定义索引访问
    2、保留字in操作
    3、使用.get()方法

b = pd.Series([9, 8, 7, 6], ['a', 'b', 'c', 'd'])
b['b']
8

'c' in b
True

#保留字 in 不会判断自动索引，只会判断自定义索引
0 in b
False

#字典函数，指的是从 b 中提取索引 f 对应的值，如果存在，返回索引 f 对应的值，否则返回 100。
b.get('f', 100)
100

Series类型对齐操作

    Series + Series

b = pd.Series([9, 8, 7, 6], ['a', 'b', 'c', 'd'])
a = pd.Series([1, 2, 3], ['c', 'd', 'e'])

#Series 类型在运算中会自动对齐不同索引的数据
a + b
a    NaN
b    NaN
c    8.0
d    8.0
e    NaN
dtype: float64

Series类型的name属性
    Series对象和索引都可以有一个名字，存储在属性.name中。

b = pd.Series([9, 8, 7, 6], ['a', 'b', 'c', 'd'])

b.name
b.name = 'Series 对象'
b.index.name = '索引列'
b
索引列
a    9
b    8
c    7
d    6
Name: Series对象, dtype: int64

Series类型的修改
    Series对象可以随时修改并即刻生效

b = pd.Series([9, 8, 7, 6], ['a', 'b', 'c', 'd'])
b['a'] = 15
b.name = 'Series'
b
索引列
a    15
b     8
c     7
d     6
Name: Series, dtype: int64

b['b', 'c'] = 20
b.name = 'New Series'
b
索引列
a    15
b    20
c    20
d     6
Name: New Series, dtype: int64

总结：
    1、Series是一维带“标签”的数组。
            index_0————>data_a
    2、Series基本操作类似ndarray和字典，但是它的操作不是基于维度的，
       而是基于索引，所以不同索引之间，在运算时存在索引对齐问题。

DataFrame类型
    DataFrame是Pandas库的二维数据类型，DataFrame类型由共用相同索引的一组列组成。
    DataFrame是一个表格型的数据类型，每列值类型可以不同。
    DataFrame既有行索引、也有列索引。
    DataFrame常用于表达二维数据，但可以表达多维数据。
           column               axis=1
            ——————————————>
       index|    index_0————>data_a  data_1             data_w
            |    index_1————>data_b  data_2             data_x
            |    index_2————>data_c  data_3     .....   data_y
     axis=0 |    index_3————>data_d  data_4             data_z
                  索引                    多列数据

    DataFrame类型可以由如下类型创建：
        1、二维ndarray对象
        2、由一维ndarray、列表、字典、元组或Series构成的字典
        3、Series类型
        4、其他的DataFrame类型创建

    1、从二维ndarray对象创建
    import pandas as pd
    import numpy as np
    d = pd.DataFrame(np.arange(10).reshape(2, 5))
    d
                     0  1  2  3  4  <————自动列索引
    自动行索引———> 0   0  1  2  3  4
                 1   5  6  7  8  9

    2、字典创建
    dt = {'one': pd.Series([1, 2, 3], index = ['a', 'b', 'c']),
        'two': pd.Series([9, 8, 7, 6], index = ['a', 'b', 'c', 'd'])}
    d = pd.DataFrame(dt)
    d

                     one    two <————自动列索引
                  a  1.0     9
    自动行索引————> b  2.0     8
                  c  3.0     7
                  d  NaN     6

    pd.DataFrame(dt, index = ['b', 'c', 'd'], columns = ['two', 'three'])
        two    three
      b  8     NaN
      c  7     NaN      dt字典中不存在键等于three的元素，所以three列没有值，数据根据行列索引自动补齐
      d  6     NaN

    3、列表类型的字典创建
    dl = {'one': [1, 2, 3, 4], 'two': [9, 8, 7, 6]}
    d = pd.DataFrame(dl, index = ['a', 'b', 'c', 'd'])
    d

        one    two
      a  1      9
      b  2      8
      c  3      7
      d  4      6

    dl = {'城市': ['北京', '上海', '广州', '深圳', '沈阳'],
         '环比': [101.5, 101.2, 101.3, 102.0, 100.1],
         '同比': [120.7, 127.3, 119.4, 140.9, 101.4],
         '定基': [121.4, 127.8, 120.0, 145.5, 101.6]}
    d = pd.DataFrame(dl, index = ['c1', 'c2', 'c3', 'c4', 'c5'])
    d

         同比    城市  定基     环比
    c1 120.7    北京   121.4  101.5
    c2 127.3    上海   127.8  101.2
    c3 119.4    广州   120.0  101.3
    c4 140.9    深圳   145.5  102.0
    c5 101.4    沈阳   101.6  100.1

    d.index
    Index(['c1', 'c2', 'c3', 'c4', 'c5'], dtype='object')

    d.columns
    Index(['同比', '城市', '定基', '环比'], dtype='object')

    d.values
    array([[120.7, '北京', 121.4, 101.5],
         [127.3, '上海', 127.8, 101.2],
         [119.4, '广州', 120.0, 101.3],
         [140.9, '深圳', 145.5, 102.0],
        [101.4, '沈阳', 101.6, 100.1]], dtype=object)

    #获取其中的一列，方括号中给出的是列中索引标记
    d['同比']
    c1    120.7
    c2    127.3
    c3    119.4
    c4    140.9
    c5    101.4
    Name: 同比, dtype: float64

    #获取一行数据，'c2'是行索引
    d.ix['c2']
    同比    127.3
    城市    上海
    定基    127.8
    环比    101.2
    Name: c2, dtype: object

    #获取某一个位置的数据，'[列索引][行索引]'组成的联合索引
    d['同比']['c2']
    127.3

    DataFrame是二维带“标签”数组。

                         column_0   column_1   column_i
            index_0 ————> data_a    data_1      data_w

    DataFrame基本操作类似Series，依据行列索引。


Pandas库的数据类型操作
    如何改变Series和DataFrame对象？
        这里说的改变结构，指的是增加或者重排Series和DataFrame的索引，
        或者删掉其中的部分值。

                增加或重排：重新索引
                删除：drop
        重新索引
        .reindex()能够改变或重排Series和DataFrame索引

            dl = {'城市': ['北京', '上海', '广州', '深圳', '沈阳'],
                 '环比': [101.5, 101.2, 101.3, 102.0, 100.1],
                 '同比': [120.7, 127.3, 119.4, 140.9, 101.4],
                 '定基': [121.4, 127.8, 120.0, 145.5, 101.6]}
            d = pd.DataFrame(dl, index = ['c1', 'c2', 'c3', 'c4', 'c5'])
            d

                 同比    城市  定基     环比
              c1 120.7  北京  121.4   101.5
              c2 127.3  上海  127.8   101.2
              c3 119.4  广州  120.0   101.3
              c4 140.9  深圳  145.5   102.0
              c5 101.4  沈阳  101.6   100.1
            d = d.reindex(['c5', 'c4', 'c3', 'c2', 'c1'])

                 同比    城市  定基     环比
              c5 101.4  沈阳  101.6   100.1
              c4 140.9  深圳  145.5   102.0
              c3 119.4  广州  120.0   101.3
              c2 127.3  上海  127.8   101.2
              c1 120.7  北京  121.4   101.5

            d = d.reindex(columns=['城市', '同比', '环比', '定基'])
            d

                城市 同比 环比 定基
            c5 沈阳 101.4  100.1  101.6
            c4 深圳 140.9  102.0  145.5
            c3 广州 119.4  101.3  120.0
            c2 上海 127.3  101.2  127.8
            c1 北京 120.7  101.5  121.4

                            重新索引
                .reindex(index=None, columns=None, ...)的参数
                参数                  说明
                index,columns       新的行列自定义索引
                fill_value          重新索引中，用于填充缺失位置的值
                method              填充方法，ffill当前值向前填充，bfill向后填充
                limit               最大填充量
                copy                默认True，生成新的对象，False时，新旧相等不复制

            dl = {'城市': ['北京', '上海', '广州', '深圳', '沈阳'],
                 '环比': [101.5, 101.2, 101.3, 102.0, 100.1],
                 '同比': [120.7, 127.3, 119.4, 140.9, 101.4],
                 '定基': [121.4, 127.8, 120.0, 145.5, 101.6]}
            d = pd.DataFrame(dl, index = ['c1', 'c2', 'c3', 'c4', 'c5'])
            d

                 同比    城市  定基     环比
              c1 120.7  北京  121.4   101.5
              c2 127.3  上海  127.8   101.2
              c3 119.4  广州  120.0   101.3
              c4 140.9  深圳  145.5   102.0
              c5 101.4  沈阳  101.6   100.1

            newc = d.columns.insert(4, '新增')
            newd = d.reindex(columns = newc, fill_value=200)
            newd

                  同比   城市  定基    环比   新增
              c1 120.7  北京  121.4  101.5   200
              c2 127.3  上海  127.8  101.2   200
              c3 119.4  广州  120.0  101.3   200
              c4 140.9  深圳  145.5  102.0   200
              c5 101.4  沈阳  101.6  100.1   200

            d.index
            Index(['c1', 'c2', 'c3', 'c4', 'c5'], dtype='object')

            d.columns
            Index(['同比', '城市', '定基', '环比'], dtype='object')

            Series和DataFrame的索引是Index类型
            Index对象是不可修改类型

                            索引类型的常用方法
            方法                      说明
            .append(idx)            连接另一个Index对象，产生新的Index对象
            .diff(idx)              计算差集，产生新的Index对象
            .intersection(idx)      计算交集
            .union(idx)             计算并集
            .delete(loc)            删除loc位置处的元素
            .insert(loc, e)         在loc位置增加一个元素e


            #索引类型的使用
            dl = {'城市': ['北京', '上海', '广州', '深圳', '沈阳'],
                 '环比': [101.5, 101.2, 101.3, 102.0, 100.1],
                 '同比': [120.7, 127.3, 119.4, 140.9, 101.4],
                 '定基': [121.4, 127.8, 120.0, 145.5, 101.6]}
            d = pd.DataFrame(dl, index = ['c1', 'c2', 'c3', 'c4', 'c5'])
            d

                 同比    城市   定基     环比
             c1 120.7   北京  121.4   101.5
             c2 127.3   上海  127.8   101.2
             c3 119.4   广州  120.0   101.3
             c4 140.9   深圳  145.5   102.0
             c5 101.4   沈阳  101.6   100.1
            d = d.reindex(['c5', 'c4', 'c3', 'c2', 'c1'])

                 同比    城市   定基     环比
             c5 101.4   沈阳  101.6   100.1
             c4 140.9   深圳  145.5   102.0
             c3 119.4   广州  120.0   101.3
             c2 127.3   上海  127.8   101.2
             c1 120.7   北京  121.4   101.5

            d = d.reindex(columns=['城市', '同比', '环比', '定基'])
            d

                城市  同比    环比    定基
             c5 沈阳 101.4  100.1  101.6
             c4 深圳 140.9  102.0  145.5
             c3 广州 119.4  101.3  120.0
             c2 上海 127.3  101.2  127.8
             c1 北京 120.7  101.5  121.4

            nc = d.columns.delete(2)
            ni = d.index.insert(5, 'c0')
            nd = d.reindex(index = ni, columns = nc, method='ffill')
            nd

                城市 同比   定基
            c5 沈阳 101.4  101.6
            c4 深圳 140.9  145.5
            c3 广州 119.4  120.0
            c2 上海 127.3  127.8
            c1 北京 120.7  121.4
            c0 北京 120.7  121.4

        删除指定索引对象
        .drop()能够删除Series和DataFrame指定行或列索引

            a = pd.Series([9, 8, 7 ,6], index = ['a', 'b', 'c', 'd'])
            a
            a    9
            b    8
            c    7
            d    6
            dtype: int64

            a.drop(['b', 'c'])
            a    9
            d    6
            dtype: int64

            l = {'城市': ['北京', '上海', '广州', '深圳', '沈阳'],
                 '环比': [101.5, 101.2, 101.3, 102.0, 100.1],
                 '同比': [120.7, 127.3, 119.4, 140.9, 101.4],
                 '定基': [121.4, 127.8, 120.0, 145.5, 101.6]}
            d = pd.DataFrame(dl, index = ['c1', 'c2', 'c3', 'c4', 'c5'])
            d

                 同比  城市  定基   环比
            c1 120.7  北京 121.4  101.5
            c2 127.3  上海 127.8  101.2
            c3 119.4  广州 120.0  101.3
            c4 140.9  深圳 145.5  102.0
            c5 101.4  沈阳 101.6  100.1
            d = d.reindex(['c5', 'c4', 'c3', 'c2', 'c1'])

               同比    城市  定基   环比
            c5 101.4  沈阳 101.6  100.1
            c4 140.9  深圳 145.5  102.0
            c3 119.4  广州 120.0  101.3
            c2 127.3  上海 127.8  101.2
            c1 120.7  北京 121.4  101.5

            d = d.reindex(columns=['城市', '同比', '环比', '定基'])
            d

                城市 同比   环比    定基
            c5 沈阳 101.4  100.1  101.6
            c4 深圳 140.9  102.0  145.5
            c3 广州 119.4  101.3  120.0
            c2 上海 127.3  101.2  127.8
            c1 北京 120.7  101.5  121.4

            d.drop('c5')

                城市 同比    环比   定基
            c5 沈阳 101.4  100.1  101.6
            c4 深圳 140.9  102.0  145.5
            c3 广州 119.4  101.3  120.0
            c2 上海 127.3  101.2  127.8
            c1 北京 120.7  101.5  121.4

            d.drop('同比', axis=1)
                城市 环比   定基
            c5 沈阳 100.1  101.6
            c4 深圳 102.0  145.5
            c3 广州 101.3  120.0
            c2 上海 101.2  127.8
            c1 北京 101.5  121.4

        .drop()默认操作轴0上的元素，如果需要操作轴1上的元素，需要指定axis=1

Pandas库的数据类型运算
    算术运算法则
        算术运算根据行列索引，补齐后运算，运算默认产生浮点数。
        补齐时缺项填充NaN(空值)
        二维和一维、一维和零维间为广播运算
        采用+ - * /符号进行的二元运算产生新的对象
            a = pd.DataFrame(np.arange(12).reshape(3,4))
            a
                0  1  2  3
            0  0  1  2  3
            1  4  5  6  7
            2  8  9  10 11
            b = pd.DataFrame(np.arange(20).reshape(4,5))
            b
               0  1  2  3  4
            0  0  1  2  3  4
            1  5  6  7  8  9
            2  10 11 12 13 14
            3  15 16 17 18 19

            #对于维度相同，但是行列元素个数不同的情况，自动补齐，缺项补 NaN，然后进行运算。
            a + b
                0      1      2      3      4
            0  0.0    2.0    4.0    6.0    NaN
            1  9.0    11.0   13.0   15.0   NaN
            2  18.0   20.0   22.0   24.0   NaN
            3  NaN    NaN    NaN    NaN    NaN

            a * b
                0      1      2      3      4
            0  0.0    1.0    4.0    9.0    NaN
            1  20.0   30.0   42.0   56.0   NaN
            2  80.0   99.0   120.0  143.0  NaN
            3  NaN    NaN    NaN    NaN    NaN

                          数据类型的算术运算
                            方法形式的运算
                方法                      说明
                .add(d, **argws)        类型间加法运算，可选参数
                .sub(d, **argws)        类型间减法运算，可选参数
                .mul(d, **argws)        类型间乘法运算，可选参数
                .div(d, **argws)        类型间除法运算，可选参数

            a = pd.DataFrame(np.arange(12).reshape(3,4))
            a
               0  1  2  3
            0  0  1  2  3
            1  4  5  6  7
            2  8  9  10 11
            b = pd.DataFrame(np.arange(20).reshape(4,5))
            b
               0  1  2  3  4
            0  0  1  2  3  4
            1  5  6  7  8  9
            2  10 11 12 13 14
            3  15 16 17 18 19

            #fill_value 参数替代 NaN，替代后参与运算。
            b.add(a, fill_value=100)
                0      1      2      3      4
            0  0.0    2.0    4.0    6.0    104.0
            1  9.0    11.0   13.0   15.0   109.0
            2  18.0   20.0   22.0   24.0   114.0
            3  115.0  116.0  117.0  118.0  119.0

            a.mul(b, fill_value=0)
                0      1      2      3      4
            0  0.0    1.0    4.0    9.0    0.0
            1  20.0   30.0   42.0   56.0   0.0
            2  80.0   99.0   120.0  143.0  0.0
            3  0.0    0.0    0.0    0.0    0.0

            b = pd.DataFrame(np.arange(20).reshape(4,5))
            b
               0  1  2  3  4
            0  0  1  2  3  4
            1  5  6  7  8  9
            2  10 11 12 13 14
            3  15 16 17 18 19
            c = pd.Series(np.arange(4))
            c
            0    0
            1    1
            2    2
            3    3
            dtype: int32

            #不同维度间为广播运算，一维 Series 默认在轴 1 参与运算
            c - 10
            0   -10
            1    -9
            2    -8
            3    -7
            dtype: int32

            b - c
                0      1      2      3      4
            0  0.0    0.0    0.0    0.0    NaN
            1  5.0    5.0    5.0    5.0    NaN
            2  10.0   10.0   10.0   10.0   NaN
            3  15.0   15.0   15.0   15.0   NaN

            #使用运算方法可以令一维 Series 参与轴 0 运算。
            b.sub(c, axis=0)
               0  1  2  3  4
            0  0  1  2  3  4
            1  4  5  6  7  8
            2  8  9  10 11 12
            3  12 13 14 15 16

    比较运算法则
        比较运算只能比较相同索引的元素，不进行补齐。
        二维和一维、一维和零维间为广播运算。
        采用> < >= <= == !=等符号进行的二元运算产生布尔对象。

            a = pd.DataFrame(np.arange(12).reshape(3, 4))
            a
               0  1  2  3
            0  0  1  2  3
            1  4  5  6  7
            2  8  9  10 11
            d = pd.DataFrame(np.arange(12, 0, -1).reshape(3,4))
            d
               0  1  2  3
            0  12 11 10 9
            1  8  7  6  5
            2  4  3  2  1

            #同维度运算，要求 a 和 d 尺寸一致。
            a > d
                  0     1      2      3
            0  False  False  False  False
            1  False  False  False  True
            2  True   True   True   True

            a == d
                 0     1       2      3
            0  False  False  False  False
            1  False  False  True   False
            2  False  False  False  False

            a = pd.DataFrame(np.arange(12).reshape(3, 4))
            a
               0  1  2  3
            0  0  1  2  3
            1  4  5  6  7
            2  8  9  10 11
            c = pd.Series(np.arange(4))
            0    0
            1    1
            2    2
            3    3
            dtype: int32

            #不同维度，广播运算，默认在轴 1。
            a > c
                  0     1      2      3
            0  False  False  False  False
            1  True   True   True   True
            2  True   True   True   True

            c > 0
            0    False
            1     True
            2     True
            3     True
            dtype: bool
```

## Pandas 库的数据排序

```python
Pandas库的数据排序
1、操作索引的排序方法：
    .sort_index()方法在指定轴上根据索引进行排序，默认升序。
        .sort_index(axis=0, ascending=True)

            b = pd.DataFrame(np.arange(20).reshape(4,5), index=['c', 'a', 'd', 'b'])
            b
               0  1  2  3  4
            c  0  1  2  3  4
            a  5  6  7  8  9
            d  10 11 12 13 14
            b  15 16 17 18 19

            b.sort_index()
               0  1  2  3  4
            a  5  6  7  8  9
            b  15 16 17 18 19
            c  0  1  2  3  4
            d  10 11 12 13 14

            b.sort_index(ascending=False)
               0  1  2  3  4
            d  10 11 12 13 14
            c  0  1  2  3  4
            b  15 16 17 18 19
            a  5  6  7  8  9

            c = b.sort_index(axis=1, ascending=False)
            c
               4  3  2  1  0
            c  4  3  2  1  0
            a  9  8  7  6  5
            d  14 13 12 11 10
            b  19 18 17 16 15

            c.sort_index()
               4  3  2  1  0
            a  9  8  7  6  5
            b  19 18 17 16 15
            c  4  3  2  1  0
            d  14 13 12 11 10

2、操作数据的排序方法：
    .sort_values()方法在指定轴上根据数值进行排序，默认升序。
        Series.sort_values(axis=0, ascending=True)
        DataFrame.sort_values(by, axis=0, ascending=True)
                    by：axis轴上的某个索引或索引列表

            b = pd.DataFrame(np.arange(20).reshape(4,5), index=['c', 'a', 'd', 'b'])
            b
               0  1  2  3  4
            c  0  1  2  3  4
            a  5  6  7  8  9
            d  10 11 12 13 14
            b  15 16 17 18 19

            c = b.sort_values(2, ascending=False)
            c
               0  1  2  3  4
            b  15 16 17 18 19
            d  10 11 12 13 14
            a  5  6  7  8  9
            c  0  1  2  3  4

            c = c.sort_values('a', axis=1, ascending=False)
            c
               4  3  2  1  0
            b  19 18 17 16 15
            d  14 13 12 11 10
            a  9  8  7  6  5
            c  4  3  2  1  0

            #NaN 统一放到排序末尾
            a = pd.DataFrame(np.arange(12).reshape(3,4), index=['a', 'b', 'c'])
            a
               0  1  2  3
            a  0  1  2  3
            b  4  5  6  7
            c  8  9  10 11
            b = pd.DataFrame(np.arange(20).reshape(4,5), index=['c', 'a', 'd', 'b'])
            b
               0  1  2  3  4
            c  0  1  2  3  4
            a  5  6  7  8  9
            d  10 11 12 13 14
            b  15 16 17 18 19
            c = a + b
            c
                0      1      2      3      4
            a  5.0    7.0    9.0    11.0   NaN
            b  19.0   21.0   23.0   25.0   NaN
            c  8.0    10.0   12.0   14.0   NaN
            d  NaN    NaN    NaN    NaN    NaN

            c.sort_values(2, ascending=False)
                0      1      2      3      4
            b  19.0   21.0   23.0   25.0   NaN
            c  8.0    10.0   12.0   14.0   NaN
            a  5.0    7.0    9.0    11.0   NaN
            d  NaN    NaN    NaN    NaN    NaN

            c.sort_values(2, ascending=True)
                0      1      2      3      4
            a  5.0    7.0    9.0    11.0   NaN
            c  8.0    10.0   12.0   14.0   NaN
            b  19.0   21.0   23.0   25.0   NaN
            d  NaN    NaN    NaN    NaN    NaN


数据的基本统计分析

                            基本的统计分析函数
                        适用于Series和DataFrame类型

               方法                       说明
               .sum()                   计算数据的总和，按轴0计算，下同
               .count()                 非NaN值的数量
               .mean() .median()        计算数据的算术平均值、算术中位数
               .var() .std()            计算数据的方差、标准差
               .min() .Max()            计算数据的最小值、最大值

                        适用于Series类型

                方法                      说明
                .argmin() .argmax()     计算数据最大值，最小值所在位置的索引位置(自动索引)
                .idxmin() .idxmax()     计算数据最大值、最小值所在位置的索引(自定义索引)

                        适用于Series和DataFrame类型
                方法                  说明
                .describe()         针对轴0(各列)的统计汇总
                a = pd.Series([9, 8, 7, 6], index = ['a', 'b', 'c', 'd'])
                a
                a    9
                b    8
                c    7
                d    6
                dtype: int64

                a.describe()
                count    4.000000
                mean     7.500000
                std      1.290994
                min      6.000000
                25%      6.750000
                50%      7.500000
                75%      8.250000
                max      9.000000
                dtype: float64

                type(a.describe())
                pandas.core.series.Series

                a.describe()['count']
                4.0

                a.describe()['max']
                9.0
                b = pd.DataFrame(np.arange(20).reshape(4,5), index=['c', 'a', 'd', 'b'])
                b.describe()
                                0          1          2          3          4
                count  　　 4.000000   4.000000   4.000000   4.000000   4.000000
                mean   　　 7.500000   8.500000   9.500000   10.500000  11.500000
                std        6.454972   6.454972   6.454972   6.454972   6.454972
                min        0.000000   1.000000   2.000000   3.000000   4.000000
                25%        3.750000   4.750000   5.750000   6.750000   7.750000
                50%        7.500000   8.500000   9.500000   10.500000  11.500000
                75%        11.250000  12.250000  13.250000  14.250000  15.250000
                max        15.000000  16.000000  17.000000  18.000000  19.000000

                type(b.describe())
                pandas.core.frame.DataFrame

                b.describe().ix['max']
                0    15.0
                1    16.0
                2    17.0
                3    18.0
                4    19.0
                Name: max, dtype: float64

                b.describe()[2]
                count     4.000000
                mean      9.500000
                std       6.454972
                min       2.000000
                25%       5.750000
                50%       9.500000
                75%      13.250000
                max      17.000000
                Name: 2, dtype: float64

                b.describe()[2]['max']
                17.0


数据的累计统计分析

                            累计统计分析函数
                        适用于Series和DataFrame类型

                  方法                       说明
               .cumsum()               依次给出前1、2、...、n个数的和
               .cumprod()              依次给出前1、2、...、n个数的积
               .cummax()               依次给出前1、2、...、n个数的最大值
               .cummin()               依次给出前1、2、...、n个数的最小值

                b = pd.DataFrame(np.arange(20).reshape(4,5), index=['c', 'a', 'd', 'b'])
                b
                    0  1  2  3  4
                 c  0  1  2  3  4
                 a  5  6  7  8  9
                 d  10 11 12 13 14
                 b  15 16 17 18 19

                b.cumsum()
                    0  1  2  3  4
                 c  0  1  2  3  4
                 a  5  7  9  11 13
                 d  15 18 21 24 27
                 b  30 34 38 42 46

                b.cumprod()
                    0      1     2       3     4
                 c  0      1     2       3     4
                 a  0     6     14     24     36
                 d  0    66    168    312    504
                 b  0  1056   2856   5616   9576

                b.cummin()
                    0  1  2  3  4
                 c  0  1  2  3  4
                 a  0  1  2  3  4
                 d  0  1  2  3  4
                 b  0  1  2  3  4

                b.cummax()
                    0  1  2  3  4
                 c  0  1  2  3  4
                 a  5  6  7  8  9
                 d  10 11 12 13 14
                 b  15 16 17 18 19

                            累计统计分析函数
                适用于Series和DataFrame类型，滚动计算（窗口计算）。

               方法                                   说明
               .rolling(w).sum()               依次计算相邻w个元素的和
               .rolling(w).mean()              依次计算相邻w个元素的算术平均值
               .rolling(w).var()               依次计算相邻w个元素的方差
               .rolling(w).std                 依次计算相邻w个元素的标准差
               .rolling(w).min() .max()        依次计算相邻w个元素的最小值和最大值

                b = pd.DataFrame(np.arange(20).reshape(4,5), index=['c', 'a', 'd', 'b'])
                b
                    0  1  2  3  4
                 c  0  1  2  3  4
                 a  5  6  7  8  9
                 d  10 11 12 13 14
                 b  15 16 17 18 19

                b.rolling(2).sum()
                    0      1      2      3      4
                c  NaN    NaN    NaN    NaN    NaN
                a  5.0    7.0    9.0    11.0   13.0
                d  15.0   17.0   19.0   21.0   23.0
                b  25.0   27.0   29.0   31.0   33.0

                b.rolling(3).sum()
                    0      1      2      3      4
                c  NaN    NaN    NaN    NaN    NaN
                a  NaN    NaN    NaN    NaN    NaN
                d  15.0   18.0   21.0   24.0   27.0
                b  30.0   33.0   36.0   39.0   42.0

```
