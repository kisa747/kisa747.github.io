# pandas 基础

## 技巧

参考：[Pandas 官方文档](https://pandas.pydata.org/pandas-docs/stable/user_guide/)

### 链式赋值警告

参考：<https://www.jianshu.com/p/72274ccb647a>

注意：当对一个 df 复制操作后得到 df1，如果再就地修改 df1，pandas 会提示 `链式赋值` 警告。应该尽量避免这样操作。

```python
df1 = df[['close']]
df1.rename(columns={'close': '收盘价（元）'}, inplace=True)

# SettingWithCopyWarning:
# A value is trying to be set on a copy of a slice from a DataFrame
# See the caveats in the documentation: https://pandas.pydata.org/pandas-docs/stable/user_guide/indexing.html#returning-a-view-versus-a-copy

# 应该修改为
df.rename(columns={'close': '收盘价（元）'})
df1 = df1[['收盘价（元）']]
```

### 抽出一行仍保持 DataFrame 形状

```python
# 额外增加一个方括号即可
df.loc[[3], :]
```

## 数据处理

* 数据处理前检查 **空值**。
* 数据处理前检查 **重复项**。

* 使用唯一值做索引，避免麻烦。否则使用标签（loc）索引时，会返回多个值。

* 字符串处理前最好 `strip()` 一下，防止两端出现空白字符串。

```python
lis = [['2018/01/02', 1, -2, 'dda', '东北风', '3-4 级'],
 ['2018/01/01', 11, -2, '晴~多云', '东北风', '1-2 级'],
 ['2018/01/01', 1, -6, '小雪~大雪', '东北风', '1-2 级'],
 ['2018/01/04', -2, -10, '大雪~阴', '东北风', '1-2 级'],
 ['2018/01/05', 0, -8, '多云~小雪', '南风', '1-2 级'],
 ['2018/01/06', -2, -6, '中雪~小雪', '无持续风向', '微风'],
 ['2018/01/07', None, -5, '阴~多云', '西风', '1-2 级'],
 ['2018/01/08', 1, -5, '多云~晴', '西风', '4-5 级'],
 ['2018/01/09', 2, -5, '晴', '西风', '3-4 级'],
 ['2018/01/10', 4, None, '晴', '西风', '3-4 级'],
 ['2018/01/11', 2, -8, '晴', '东北风', '1-2 级']]
# pandas.DataFrame(data=None, index=None, columns=None, dtype=None, copy=False)
df = pd.DataFrame(lis, columns=['date','high','low','weather','wind','power'])
```

## 查看数据信息

```python
df  # 查看前后各 30 行
df.info()  # 看看整体情况
df.describe() # 统计指标，默认仅统计数值类型的列。
df.shape  # 查看行列数量返回一个元祖 (行数，列数)
df.head(30)  # 查看前 30 行
df.tail(30)  # 查看后 30 行
# 如果表格过长，仅看头和尾有可能还是发现不了其中数据存在的问题，这时可以随机抽样。
# DataFrame.sample(n=None, frac=None, replace=False, weights=None, random_state=None, axis=None)
# n=30 要抽取的 30 行。frac=0.8，就是抽取其中 80%。random_state=1，可以取得重复数据。
df.sample(n=30, random_state=1)
```

## 数据处理

```python
# 检查空值。
# 检查缺失值 isna() 与 isnull() 一模一样
df.isnull()  # 判断是否有缺失值
df.isnull().any()  # 判断每列是否有缺失值，any 默认参数时 axis=0
df.isnull().any(axis=1)  # 判断每行是否有缺失值
df.isnull().sum()  # 统计缺失值数量
df.isnull().sum(axis=1)  # 统计行缺失值数量
df.isnull().any(axis=1).sum()  # 统计行缺失值数量
df.notna()

# 仅显示非空行。
df.loc[df['high'].notna(), :]
# 显示所有空行
df.isna().any()

# 检查重复值。
df.date.is_unique
[输出：]False
# 输出某列每个元素重复情况（False、True），数据较多时用处不大。
df['date'].duplicated()
# 查看重复行的个数。
df['date'].duplicated().sum()
# 显示重复的行。
df[df['date'].duplicated()>0]

# Series 的字符串的矢量方法。replace 默认是正则表达式，
df['date'] = df['date'].str.replace('/','-', regex=True)
# 去重。只有去重之后，索引列才能重采样，否则会报错。
# 参考：https://zhuanlan.zhihu.com/p/116884554
# DataFrame.drop_duplicates(subset=None, keep='first', inplace=False)
df.drop_duplicates('date', keep='first', inplace=True)
# 去重后会导致索引不连续，重设一下索引就可以了。
# DataFrame.reset_index(level=None, drop=False, inplace=False, col_level=0, col_fill='')
# We can use the drop parameter to avoid the old index being added as a column:
df.reset_index(drop=True, inplace=True)

# 转换为时间序列
df.date = pd.to_datetime(df.date)
# 转换为日期序列
df.date = pd.to_datetime(df.date).dt.date
# 设置为 Index
df.set_index('date',inplace=True)
# 按照索引重新排序
df.sort_index(inplace=True)  # sort_index、sort_values 排序，没有重复项，才可以使用 inplace=True 参数，否则会报错。
# 索引去重。DataFrame.drop_duplicates 函数的 subset 参数无法设置索引列（index），只能使用这个方法去重后复制一个新的 DataFrame。
df1 = df[~df.index.duplicated()]

# 频率转换。改变频率的函数主要是 asfreq()。对于 DatetimeIndex，这就是一个调用 reindex()，并生成 date_range 的便捷打包器。
# DataFrame.asfreq() 方法可以转换时间频率。缺失的行，按指定的方法进行填充。
# DataFrame.asfreq(freq, method=None, how=None, normalize=False, fill_value=None)
df.asfreq('1d')

# 快速生成一个月的 df1
df1 = pd.DataFrame(None, index=pd.date_range('2018-01-01', '2018-01-31'), columns=df.columns)
# 不是从列转换成 index 的话，默认的索引是没有索引标签名称的，设置有多种方法。
df.index.name='y'    # 方法一
df.index.names=['y']   # 方法二
df.index.set_names='y'  # 方法三
df.index.set_names=['y']  # 方法三

# 4.1 重命名列名
df.columns = ['姓名','性别','语文','数学','英语','城市','省份']
# 4.2 选择性更改列名
df.rename(columns={'姓名': '姓--名','性别': '性--别'},inplace=True)
# 4.3 批量更改索引
df.rename(lambda x: x + 10)
# 4.4 批量更改列名
df.rename(columns=lambda x: x + '_1')
# df2 必须提前去重，否则会报错：cannot reindex from a duplicate axis
df1.update(df2)

# 重采样。相当于转换频率后，再进行一个统计运算。
df.resample('3d').sum()

# 丢弃指定列
df.drop(['label', 'code'], axis=1, inplace=True)
# 保留指定列
df1 = df[['年份', '指标', '数值']]

# 合列
df['date'] = df['year'].str.cat(df['month'], sep='-', na_rep='')
```

## 快速生成日期序列

```python
# 生成指定日期序列，包含年月的二维数组
from datetime import date
prng = pd.date_range('2011-01', date.today(),
                    freq='MS').map(lambda x:[x.year, x.month]).tolist()
[输出：]
[[2011, 1],
 [2011, 2],
 [2011, 3],
 [2011, 4],
 [2011, 5],
 [2011, 6],...

# 快速生成上个月的日期序列，二维数组
from datetime import date
now = date.today()
year = now.year
month = now.month
pd.date_range(f'{year}-{month-1}', f'{year}-{month}',freq='D').map(lambda x:[x.year, x.month, x.day]).tolist()[:-1]
[输出：][[2018, 8, 1],
 [2018, 8, 2],
 [2018, 8, 3],
 [2018, 8, 4],
 [2018, 8, 5],
 [2018, 8, 6],...
# 或者是：
pd.date_range(f'{year}-{month-1}', periods=calendar.monthrange(year,month-1)[1]).map(lambda x:[x.year, x.month, x.day]).tolist()
```

## 索引和切片

常用的方法：

```python
# 索引列
df.high
df['high']  # 按列名称索引
df.iloc[:,1]  # 第 2 列

# 索引行
df[1:4]  # 第 2~4 行。
```

所有的方法：

```python
# [] 索引，列按标签索引，行按索引号索引。
# 索引号从 0 开始，左开右闭。
df['high'][:1]
#行维度：
#    整数切片、标签切片、<布尔数组>
#列维度：
#    标签索引、标签列表、Callable

# loc 标签索引，先行后列
df.loc[:,'high']
df.loc['2018-01-05','high']
# 二维，先行后列
# 行维度：
#    标签索引、标签切片、标签列表、<布尔数组>、Callable
# 列维度：
#    标签索引、标签切片、标签列表、<布尔数组>、Callable

# iloc 索引号索引，先行后列
df.iloc[1,1]
# 二维，先行后列
# 行维度：
#    整数索引、整数切片、整数列表、<布尔数组>
# 列维度：
#    整数索引、整数切片、整数列表、<布尔数组>、Callable
df.iloc[df['A']>0, :]
```

## 预处理

```python
df = pd.DataFrame()

# 查看前后各 30 行
df

# 查看前、后各 5 行
df.head()
df.tail()

# 看看整体情况
df.info()

# 查看形状
df.shape

# 转置
df.T

# 访问它的原始数据，也就是转换为 ndarray，会丢弃 Index。
# 建议使用 df.to_numpy()
df.values

# ndarray 转换为列表
# 建议使用 df.to_numpy().tolist()
df.values.tolist()

# 统计指标，默认仅统计数值类型的列。
df.describe()

# 查看非数字类型的列的统计指标
df.describe(include=["object"])

# 统计数量
df.count()

# 统计下某列中每个值出现的次数，注意这个方法作用于 Series
df['high'].value_counts()

# 如果想要获取某列最大值或最小值对应的索引，可以使用 idxmax 或 idxmin 方法完成。
df.high.idxmax()

# 排序
user_info.sort_index(axis=1, ascending=False)
user_info.sort_values(by="age")

# list 中每个元素的顺序会影响排序优先级的。
user_info.sort_values(by=["age", "city"])

# 需要获取最大的 n 个值或最小值的 n 个值
user_info.age.nlargest(2)

# 函数应用。常用到的函数有：map、apply、applymap。
# apply 方法既支持 Series，也支持 DataFrame，在对 Series 操作时会作用到每个值上，在对 DataFrame 操作时会作用到所有行或所有列（通过 axis 参数控制）。
# 接收一个 lambda 函数
user_info.age.map(lambda x: "yes" if x >= 30 else "no")

# 可以传入一个函数，也可以传入一个字典，也可以是个 Series
# 又比如，我想要通过城市来判断是南方还是北方，我可以这样操作。
city_map = {
    "BeiJing": "north",
    "ShangHai": "south",
    "GuangZhou": "south",
    "ShenZhen": "south"
}
# 传入一个 map
user_info.city.map(city_map)

# apply 方法既支持 Series，也支持 DataFrame，在对 Series 操作时会作用到每个值上，在对 DataFrame 操作时会作用到所有行或所有列（通过 axis 参数控制）。

# 对 Series 来说，apply 方法 与 map 方法区别不大。
user_info.age.apply(lambda x: "yes" if x >= 30 else "no")

# 对 DataFrame 来说，apply 方法的作用对象是一行或一列数据（一个 Series）
user_info.apply(lambda x: x.max(), axis=0)

# applymap 方法针对于 DataFrame，它作用于 DataFrame 中的每个元素，它对 DataFrame 的效果类似于 apply 对 Series 的效果。
user_info.applymap(lambda x: str(x).lower())

# 修改列/索引名称
# 在使用 DataFrame 的过程中，经常会遇到修改列名，索引名等情况。使用 rename 轻松可以实现。

# 修改列名只需要设置参数 columns 即可。
user_info.rename(columns={"age": "Age", "city": "City", "sex": "Sex"})

# 类似的，修改索引名只需要设置参数 index 即可。
user_info.rename(index={"Tom": "tom", "Bob": "bob"})

# 类型操作
# 如果想要获取每种类型的列数的话，可以使用 get_dtype_counts() 方法。
user_info.get_dtype_counts()

# 如果想要转换数据类型的话，可以通过 astype 来完成。
user_info["age"].astype(float)

# 有时候会涉及到将 object 类型转为其他类型，常见的有转为数字、日期、时间差，Pandas 中分别对应 to_numeric、to_datetime、to_timedelta 方法。

# 这里给这些用户都添加一些关于身高的信息。

user_info["height"] = ["178", "168", "178", "180cm"]
user_info
Python
age city sex height
name
Tom 18 BeiJing male 178
Bob 30 ShangHai male 168
Mary 25 GuangZhou female 178
James 40 ShenZhen male 180cm
现在将身高这一列转为数字，很明显，180cm 并非数字，为了强制转换，我们可以传入 errors 参数，这个参数的作用是当强转失败时的处理方式。

默认情况下，errors='raise'，这意味着强转失败后直接抛出异常，设置 errors='coerce' 可以在强转失败时将有问题的元素赋值为 pd.NaT（对于datetime和timedelta）或 np.nan（数字）。设置 errors='ignore' 可以在强转失败时返回原有的数据。

pd.to_numeric(user_info.height, errors="coerce")
Python
name
Tom      178.0
Bob      168.0
Mary     178.0
James      NaN
Name: height, dtype: float64
pd.to_numeric(user_info.height, errors="ignore")
Python
name
Tom        178
Bob        168
Mary       178
James    180cm
Name: height, dtype: object
```

## 数据处理

示例：

```python
import numpy as np
import pandas as pd
index = pd.Index(data=["Tom", "Bob", "Mary", "James", "Andy", "Alice"], name="name")

data = {
    "age": [18, 30, np.nan, 40, np.nan, 30],
    "city": ["BeiJing", "ShangHai", "GuangZhou", "ShenZhen", np.nan, " "],
    "sex": [None, "male", "female", "male", np.nan, "unknown"],
    "birth": ["2000-02-10", "1988-10-17", None, "1978-08-08", np.nan, "1988-10-17"]
}

user_info = pd.DataFrame(data=data, index=index)

# 将出生日期转为时间戳
user_info["birth"] = pd.to_datetime(user_info.birth)
user_info

 age birth city sex
name
Tom 18.0 2000-02-10 BeiJing None
Bob 30.0 1988-10-17 ShangHai male
Mary NaN NaT GuangZhou female
James 40.0 1978-08-08 ShenZhen male
Andy NaN NaT NaN NaN
Alice 30.0 1988-10-17  unknown
```

可以看到，用户 Tom 的性别为 `None`，用户 Mary 的年龄为 `NAN`，生日为 `NaT`。在 Pandas 的眼中，这些都属于缺失值，可以使用 `isnull()` 或 `notnull()` 方法来操作。

```python
# 查看有缺失值得行
user_info.isnull()

# 过滤掉用户年龄为空的用户
user_info[user_info.age.notnull()]

使用 dropna 方法可以丢弃缺失值。
user_info.age.dropna()

# Seriese 使用 dropna 比较简单，对于 DataFrame 来说，可以设置更多的参数。
df.dropna(axis=0, how='any', thresh=None, subset=None, inplace=False)
# axis 参数用于控制行或列，跟其他不一样的是，axis=0（默认）表示操作行，axis=1 表示操作列。
# how 参数可选的值为 any（默认）或者 all。any 表示一行/列有任意元素为空时即丢弃，all 一行/列所有值都为空时才丢弃。
# subset 参数表示删除时只考虑的索引或列名。
# thresh 参数的类型为整数，它的作用是，比如 thresh=3，会在一行/列中至少有 3 个非空值时将其保留。

# 一行数据只要有一个字段存在空值即删除
user_info.dropna(axis=0, how="any")
# 一行数据所有字段都为空值才删除
user_info.dropna(axis=0, how="all")
# 一行数据中只要 city 或 sex 存在空值即删除
user_info.(axis=0, how="any", subset=["city", "sex"])

填充缺失值
除了可以丢弃缺失值外，也可以填充缺失值，最常见的是使用 fillna 完成填充。

fillna 这名字一看就是用来填充缺失值的。

填充缺失值时，常见的一种方式是使用一个标量来填充。例如，这里我样有缺失的年龄都填充为 0。

user_info.age.fillna(0)

# 除了可以使用标量来填充之外，还可以使用前一个或后一个有效值来填充。
# 设置参数 method='pad' 或 method='ffill' 可以使用前一个有效值来填充。
user_info.age.fillna(method="ffill")

# 设置参数 method='bfill' 或 method='backfill' 可以使用后一个有效值来填充。
user_info.age.fillna(method="backfill")

#除了通过 fillna 方法来填充缺失值外，还可以通过 interpolate 方法来填充。默认情况下使用线性差值，可以是设置 method 参数来改变方式。
df.interpolate(method='linear', axis=0, limit=None, inplace=False, limit_direction='forward', limit_area=None, downcast=None, **kwargs)

#替换缺失值
#大家有没有想过一个问题：到底什么才是缺失值呢？你可能会奇怪说，前面不是已经说过了么，None、np.nan、NaT 这些都是缺失值。但是我也说过了，这些在 Pandas 的眼中是缺失值，有时候在我们人类的眼中，某些异常值我们也会当做缺失值来处理。

#例如，在我们的存储的用户信息中，假定我们限定用户都是青年，出现了年龄为 40 的，我们就可以认为这是一个异常值。再比如，我们都知道性别分为男性（male）和女性（female），在记录用户性别的时候，对于未知的用户性别都记为了“unknown”,很明显，我们也可以认为“unknown”是缺失值。此外，有的时候会出现空白字符串，这些也可以认为是缺失值。

#对于上面的这种情况，我们可以使用 replace 方法来替换缺失值。

user_info.age.replace(40, np.nan)

也可以指定一个映射字典。
user_info.age.replace({40: np.nan})

对于 DataFrame，可以指定每列要替换的值。

user_info.replace({"age": 40, "birth": pd.Timestamp("1978-08-08")}, np.nan)


似地，我们可以将特定字符串进行替换，如：将 "unknown" 进行替换。

user_info.sex.replace("unknown", np.nan)

除了可以替换特定的值之外，还可以使用正则表达式来替换，如：将空白字符串替换成空值。

user_info.city.replace(r'\s+', np.nan, regex=True)

使用其他对象填充
除了我们自己手动丢弃、填充已经替换缺失值之外，我们还可以使用其他对象来填充。

例如有两个关于用户年龄的 Series，其中一个有缺失值，另一个没有，我们可以将没有的缺失值的 Series 中的元素传给有缺失值的。

age_new = user_info.age.copy()
age_new.fillna(20, inplace=True)
age_new
user_info.age.combine_first(age_new)

将大于30的替换为nan。
df[df.high>30]['high'] = np.nan

```

## 文本数据处理

```python
# 使用 map 方法，如果文本中有缺失值，会报错。
# 因为 np.nan 属于 float 类型。
user_info.city.map(lambda x: x.lower())

# 这时候，应该使用 str 属性进行操作。
# 将文本转为小写
user_info.city.str.lower()
可以看到，通过 str 属性来访问之后用到的方法名与 Python 内置的字符串的方法名一样。并且能够自动排除缺失值。

我们再来试试其他一些方法。例如，统计每个字符串的长度。
user_info.city.str.len()

替换和分割
使用 .srt 属性也支持替换与分割操作。

先来看下替换操作，例如：将空字符串替换成下划线。

user_info.city.str.replace(" ", "_")

replace 方法还支持正则表达式，例如将所有开头为 S 的城市替换为空字符串。

user_info.city.str.replace("^S.*", " ")

再来看下分割操作，例如根据空字符串来分割某一列。

user_info.city.str.split(" ")
name
Tom       [Bei, Jing, ]
Bob      [Shang, Hai, ]
Mary      [Guang, Zhou]
James      [Shen, Zhen]
Andy                NaN
Alice              [, ]
Name: city, dtype: object

分割列表中的元素可以使用 get 或 [] 符号进行访问：

user_info.city.str.split(" ").str.get(1)
user_info.city.str.split(" ").str[1]
name
Tom      Jing
Bob       Hai
Mary     Zhou
James    Zhen
Andy      NaN
Alice
Name: city, dtype: object

设置参数 expand=True 可以轻松扩展此项以返回 DataFrame。

user_info.city.str.split(" ", expand=True)
 0 1 2
name
Tom Bei Jing
Bob Shang Hai
Mary Guang Zhou None
James Shen Zhen None
Andy NaN None None
Alice   None

提取子串
既然是在操作字符串，很自然，你可能会想到是否可以从一个长的字符串中提取出子串。答案是可以的。

提取第一个匹配的子串
extract 方法接受一个正则表达式并至少包含一个捕获组，指定参数 expand=True 可以保证每次都返回 DataFrame。

例如，现在想要匹配空字符串前面的所有的字母，可以使用如下操作：

user_info.city.str.extract("(\w+)\s+", expand=True)
```

|       | 0     |
| ----- | ----- |
| name  |       |
| Tom   | Bei   |
| Bob   | Shang |
| Mary  | Guang |
| James | Shen  |
| Andy  | NaN   |
| Alice | NaN   |

如果使用多个组提取正则表达式会返回一个 DataFrame，每个组只有一列。

例如，想要匹配出空字符串前面和后面的所有字母，操作如下：

```python
user_info.city.str.extract("(\w+)\s+(\w+)", expand=True)
```

|       | 0     | 1    |
| ----- | ----- | ---- |
| name  |       |      |
| Tom   | Bei   | Jing |
| Bob   | Shang | Hai  |
| Mary  | Guang | Zhou |
| James | Shen  | Zhen |
| Andy  | NaN   | NaN  |
| Alice | NaN   | NaN  |

### 匹配所有子串

`extract` 只能够匹配出第一个子串，使用 `extractall` 可以匹配出所有的子串。

例如，将所有组的空白字符串前面的字母都匹配出来，可以如下操作。

```python
ser_info.city.str.extractall("(\w+)\s+")
```

Python

|       |       | 0     |
| ----- | ----- | ----- |
| name  | match |       |
| Tom   | 0     | Bei   |
| 1     | Jing  |       |
| Bob   | 0     | Shang |
| 1     | Hai   |       |
| Mary  | 0     | Guang |
| James | 0     | Shen  |

### 测试是否包含子串

除了可以匹配出子串外，我们还可以使用 `contains` 来测试是否包含子串。例如，想要测试城市是否包含子串“Zh”。

```python
name
Tom      False
Bob      False
Mary      True
James     True
Andy       NaN
Alice    False
Name: city, dtype: object
```

当然了，正则表达式也是支持的。例如，想要测试是否是以字母“S”开头。

```python
user_info.city.str.contains("^S")
name
Tom      False
Bob       True
Mary     False
James     True
Andy       NaN
Alice    False
Name: city, dtype: object
```

## 生成哑变量

这是一个神奇的功能，通过 `get_dummies` 方法可以将字符串转为哑变量，`sep` 参数是指定哑变量之间的分隔符。来看看效果吧。

```python
user_info.city.str.get_dummies(sep=" ")
```

Python

|       | Bei  | Guang | Hai  | Jing | Shang | Shen | Zhen | Zhou |
| ----- | ---- | ----- | ---- | ---- | ----- | ---- | ---- | ---- |
| name  |      |       |      |      |       |      |      |      |
| Tom   | 1    | 0     | 0    | 1    | 0     | 0    | 0    | 0    |
| Bob   | 0    | 0     | 1    | 0    | 1     | 0    | 0    | 0    |
| Mary  | 0    | 1     | 0    | 0    | 0     | 0    | 0    | 1    |
| James | 0    | 0     | 0    | 0    | 0     | 1    | 1    | 0    |
| Andy  | 0    | 0     | 0    | 0    | 0     | 0    | 0    | 0    |
| Alice | 0    | 0     | 0    | 0    | 0     | 0    | 0    | 0    |

这样，它提取出了 `Bei, Guang, Hai, Jing, Shang, Shen, Zhen, Zhou` 这些哑变量，并对每个变量下使用 0 或 1 来表达。实际上与 One-Hot（狂热编码）是一回事。听不懂没关系，之后将机器学习相关知识时会详细介绍这里。

## 方法摘要

这里列出了一些常用的方法摘要。

|      方法       | 描述                                                         |
| :-------------: | ------------------------------------------------------------ |
|      cat()      | 连接字符串                                                   |
|     split()     | 在分隔符上分割字符串                                         |
|    rsplit()     | 从字符串末尾开始分隔字符串                                   |
|      get()      | 索引到每个元素（检索第 i 个元素）                              |
|     join()      | 使用分隔符在系列的每个元素中加入字符串                       |
|  get_dummies()  | 在分隔符上分割字符串，返回虚拟变量的 DataFrame                |
|   contains()    | 如果每个字符串都包含 pattern / regex，则返回布尔数组          |
|    replace()    | 用其他字符串替换 pattern / regex 的出现                        |
|    repeat()     | 重复值（s.str.repeat(3) 等同于 x * 3 t2 >）                    |
|      pad()      | 将空格添加到字符串的左侧，右侧或两侧                         |
|    center()     | 相当于 str.center                                             |
|     ljust()     | 相当于 str.ljust                                              |
|     rjust()     | 相当于 str.rjust                                              |
|     zfill()     | 等同于 str.zfill                                              |
|     wrap()      | 将长长的字符串拆分为长度小于给定宽度的行                     |
|     slice()     | 切分 Series 中的每个字符串                                     |
| slice_replace() | 用传递的值替换每个字符串中的切片                             |
|     count()     | 计数模式的发生                                               |
|  startswith()   | 相当于每个元素的 str.startswith(pat)                          |
|   endswith()    | 相当于每个元素的 str.endswith(pat)                            |
|    findall()    | 计算每个字符串的所有模式/正则表达式的列表                    |
|     match()     | 在每个元素上调用 re.match，返回匹配的组作为列表               |
|    extract()    | 在每个元素上调用 re.search，为每个元素返回一行 DataFrame，为每个正则表达式捕获组返回一列 |
|  extractall()   | 在每个元素上调用 re.findall，为每个匹配返回一行 DataFrame，为每个正则表达式捕获组返回一列 |
|      len()      | 计算字符串长度                                               |
|     strip()     | 相当于 str.strip                                              |
|    rstrip()     | 相当于 str.rstrip                                             |
|    lstrip()     | 相当于 str.lstrip                                             |
|   partition()   | 等同于 str.partition                                          |
|  rpartition()   | 等同于 str.rpartition                                         |
|     lower()     | 相当于 str.lower                                              |
|     upper()     | 相当于 str.upper                                              |
|     find()      | 相当于 str.find                                               |
|     rfind()     | 相当于 str.rfind                                              |
|     index()     | 相当于 str.index                                              |
|    rindex()     | 相当于 str.rindex                                             |
|  capitalize()   | 相当于 str.capitalize                                         |
|   swapcase()    | 相当于 str.swapcase                                           |
|   normalize()   | 返回 Unicode 标准格式。相当于 unicodedata.normalize             |
|   translate()   | 等同于 str.translate                                          |
|    isalnum()    | 等同于 str.isalnum                                            |
|    isalpha()    | 等同于 str.isalpha                                            |
|    isdigit()    | 相当于 str.isdigit                                            |
|    isspace()    | 等同于 str.isspace                                            |
|    islower()    | 相当于 str.islower                                            |
|    isupper()    | 相当于 str.isupper                                            |
|    istitle()    | 相当于 str.istitle                                            |
|   isnumeric()   | 相当于 str.isnumeric                                          |
|   isdecimal()   | 相当于 str.isdecimal                                          |

## 时间序列

面列出了 Pandas 中 和时间日期相关常用的类以及创建方法。

| 类            | 备注            | 创建方法                               |
| ------------- | --------------- | -------------------------------------- |
| Timestamp     | 时刻数据        | to_datetime，Timestamp                 |
| DatetimeIndex | Timestamp 的索引 | to_datetime，date_range，DatetimeIndex |
| Period        | 时期数据        | Period                                 |
| PeriodIndex   | Period          | period_range，PeriodIndex              |

Pandas 中关于时间序列最常见的类型就是时间戳（`Timestamp`）了，创建时间戳的方法有很多种，我们分别来看一看。

```python
pd.Timestamp(2018, 5, 21)
```

```python
Timestamp('2018-05-21 00:00:00')
pd.Timestamp("2018-5-21")
```

```python
Timestamp('2018-05-21 00:00:00')
```

除了时间戳之外，另一个常见的结构是时间跨度（`Period`）。

```python
pd.Period("2018-01")
```

```python
Period('2018-01', 'M')
pd.Period("2018-05", freq="D")
```

Python

```python
Period('2018-05-01', 'D')
```

`Timestamp` 和 `Period` 可以是索引。将`Timestamp` 和 `Period` 作为 `Series` 或 `DataFrame` 的索引后会自动强制转为为 `DatetimeIndex` 和 `PeriodIndex`。

`Timestamp` 和 `Period` 可以是索引。将`Timestamp` 和 `Period` 作为 `Series` 或 `DataFrame` 的索引后会自动强制转为为 `DatetimeIndex` 和 `PeriodIndex`。

```python
dates = [pd.Timestamp("2018-05-01"), pd.Timestamp("2018-05-02"), pd.Timestamp("2018-05-03"), pd.Timestamp("2018-05-04")]

ts = pd.Series(data=["Tom", "Bob", "Mary", "James"], index=dates)
ts.index
```

```python
DatetimeIndex(['2018-05-01', '2018-05-02', '2018-05-03', '2018-05-04'], dtype='datetime64[ns]', freq=None)
```

```python
periods = [pd.Period("2018-01"), pd.Period("2018-02"), pd.Period("2018-03"), pd.Period("2018-4")]

ts = pd.Series(data=["Tom", "Bob", "Mary", "James"], index=periods)
ts.index
```

Python

```python
PeriodIndex(['2018-01', '2018-02', '2018-03', '2018-04'], dtype='period[M]', freq='M')
```

## 转换时间戳

你可能会想到，我们经常要和文本数据（字符串）打交道，能否快速将文本数据转为时间戳呢？

答案是可以的，通过 `to_datetime` 能快速将字符串转换为时间戳。当传递一个 Series 时，它会返回一个 Series（具有相同的索引），而类似列表的则转换为`DatetimeIndex`。

```python
pd.to_datetime(pd.Series(["Jul 31, 2018", "2018-05-10", None]))
```

Python

```python
0   2018-07-31
1   2018-05-10
2          NaT
dtype: datetime64[ns]
pd.to_datetime(["2005/11/23", "2010.12.31"])
```

Python

```python
DatetimeIndex(['2005-11-23', '2010-12-31'], dtype='datetime64[ns]', freq=None)
```

除了可以将文本数据转为时间戳外，还可以将 unix 时间转为时间戳。

```python
pd.to_datetime([1349720105, 1349806505, 1349892905], unit="s")
```

Python

```python
DatetimeIndex(['2012-10-08 18:15:05', '2012-10-09 18:15:05',
               '2012-10-10 18:15:05'],
              dtype='datetime64[ns]', freq=None)
pd.to_datetime([1349720105100, 1349720105200, 1349720105300], unit="ms")
```

Python

```Python
DatetimeIndex(['2012-10-08 18:15:05.100000', '2012-10-08 18:15:05.200000',
               '2012-10-08 18:15:05.300000'],
              dtype='datetime64[ns]', freq=None)
```

## 生成时间戳范围

有时候，我们可能想要生成某个范围内的时间戳。例如，我想要生成 "2018-6-26" 这一天之后的 8 天时间戳，如何完成呢？我们可以使用 `date_range` 和 `bdate_range` 来完成时间戳范围的生成。

```python
pd.date_range("2018-6-26", periods=8)
```

Python

```python
DatetimeIndex(['2018-06-26', '2018-06-27', '2018-06-28', '2018-06-29',
               '2018-06-30', '2018-07-01', '2018-07-02', '2018-07-03'],
              dtype='datetime64[ns]', freq='D')
pd.bdate_range("2018-6-26", periods=8)
```

Python

```python
DatetimeIndex(['2018-06-26', '2018-06-27', '2018-06-28', '2018-06-29',
               '2018-07-02', '2018-07-03', '2018-07-04', '2018-07-05'],
              dtype='datetime64[ns]', freq='B')
```

可以看出，`date_range` 默认使用的频率是 **日历日**，而 `bdate_range` 默认使用的频率是 **营业日**。当然了，我们可以自己指定频率，比如，我们可以按周来生成时间戳范围。

```python
pd.date_range("2018-6-26", periods=8, freq="W")
```

```python
DatetimeIndex(['2018-07-01', '2018-07-08', '2018-07-15', '2018-07-22',
               '2018-07-29', '2018-08-05', '2018-08-12', '2018-08-19'],
              dtype='datetime64[ns]', freq='W-SUN')
```

## DatetimeIndex

`DatetimeIndex` 的主要作用是之一是用作 Pandas 对象的索引，使用它作为索引除了拥有普通索引对象的所有基本功能外，还拥有简化频率处理的高级时间序列方法。

```python
rng = pd.date_range("2018-6-24", periods=4, freq="W")
ts = pd.Series(range(len(rng)), index=rng)
ts
```

Python

```python
2018-06-24    0
2018-07-01    1
2018-07-08    2
2018-07-15    3
Freq: W-SUN, dtype: int32
# 通过日期访问数据
ts["2018-07-08"]
```

Python

```python
2
# 通过日期区间访问数据切片
ts["2018-07-08": "2018-07-22"]
```

Python

```python
2018-07-08    2
2018-07-15    3
Freq: W-SUN, dtype: int32
```

除了可以将日期作为参数，还可以将年份或者年份、月份作为参数来获取更多的数据。

```python
# 传入年份
ts["2018"]
```

Python

```python
2018-06-24    0
2018-07-01    1
2018-07-08    2
2018-07-15    3
Freq: W-SUN, dtype: int32
# 传入年份和月份
ts["2018-07"]
```

Python

```python
2018-07-01    1
2018-07-08    2
2018-07-15    3
Freq: W-SUN, dtype: int32
```

除了可以使用字符串对 `DateTimeIndex` 进行索引外，还可以使用 `datetime`（日期时间）对象来进行索引。

```python
from datetime import datetime

ts[datetime(2018, 7, 8) : datetime(2018, 7, 22)]
```

Python

```python
2018-07-08    2
2018-07-15    3
Freq: W-SUN, dtype: int32
```

我们可以通过 `Timestamp` 或 `DateTimeIndex` 访问一些时间/日期的属性。这里列举一些常见的，想要查看所有的属性见官方链接：[Time/Date Components](http://www.naodongopen.com/wp-content/themes/begin5.2/inc/go.php?url=http://pandas.pydata.org/pandas-docs/stable/timeseries.html#time-date-components)

```python
# 获取年份
ts.index.year
```

Python

```python
Int64Index([2018, 2018, 2018, 2018], dtype='int64')
# 获取星期几
ts.index.dayofweek
```

Python

```python
Int64Index([6, 6, 6, 6], dtype='int64')
# 获取一年中的几个第几个星期
ts.index.weekofyear
```

Python

```python
Int64Index([25, 26, 27, 28], dtype='int64')
```

## 计算工具

```python
df.high.rank()
```

## 统计函数

最常见的计算工具莫过于一些统计函数了。这里我们首先构建一个包含了用户年龄与收入的 DataFrame。

```python
index = pd.Index(data=["Tom", "Bob", "Mary", "James", "Andy", "Alice"], name="name")

data = {
    "age": [18, 40, 28, 20, 30, 35],
    "income": [1000, 4500 , 1800, 1800, 3000, np.nan],
}

df = pd.DataFrame(data=data, index=index)
df
```

Python

|       | age  | income |
| ----- | ---- | ------ |
| name  |      |        |
| Tom   | 18   | 1000.0 |
| Bob   | 40   | 4500.0 |
| Mary  | 28   | 1800.0 |
| James | 20   | 1800.0 |
| Andy  | 30   | 3000.0 |
| Alice | 35   | NaN    |

我们可以通过 `cov` 函数来求出年龄与收入之间的协方差，计算的时候会丢弃缺失值。

```python
df.age.cov(df.income)
```

Python

```python
11320.0
```

除了协方差之外，我们还可以通过 `corr` 函数来计算下它们之间的相关性，计算的时候会丢弃缺失值。

默认情况下 `corr` 计算相关性时用到的方法是 `pearson`，当然了你也可以指定 `kendall` 或 `spearman`。

```python
df.age.corr(df.income)
```

Python

```python
0.94416508951340194
df.age.corr(df.income, method="kendall")
```

Python

```python
0.94868329805051366
df.age.corr(df.income, method="spearman")
```

Python

```python
0.97467943448089644
```

除了相关性的计算外，还可以通过 `rank` 函数求出数据的排名顺序。

```python
df.income.rank()
```

Python

```python
name
Tom      1.0
Bob      5.0
Mary     2.5
James    2.5
Andy     4.0
Alice    NaN
Name: income, dtype: float64
```

如果有相同的数，默认取其排名的平均值作为值。我们可以设置参数来得到不同的结果。可以设置的参数有：`min`、`max`、`first`、`dense`。

```python
df.income.rank(method="first")
```

Python

```python
name
Tom      1.0
Bob      5.0
Mary     2.0
James    3.0
Andy     4.0
Alice    NaN
Name: income, dtype: float64
```

## 筛选

1、切片

切片，行按照索引序号，列按照标签

2、loc

loc 行和列都按照标签。行是索引标签

3、iloc

iloc 行和列都按照索引序号

## 布尔索引

通过布尔操作我们一样可以进行筛选操作，布尔操作时，`&amp;` 对应 `and`，`|` 对应 `or`，`~` 对应 `not`。

当有多个布尔表达式时，需要通过小括号来进行分组。

```python
user_info[user_info.age > 20]
```

Python

| name  | age  | birth      | city      | sex     |
| ----- | ---- | ---------- | --------- | ------- |
| Bob   | 30.0 | 1988-10-17 | Shang Hai | male    |
| James | 40.0 | 1978-08-08 | Shen Zhen | male    |
| Alice | 30.0 | 1988-10-17 |           | unknown |

```python
# 筛选出年龄在 20 岁以上，并且性别为男性的数据
user_info[(user_info.age > 20) & (user_info.sex == "male")]
```

Python

| name  | age  | birth      | city      | sex  |
| ----- | ---- | ---------- | --------- | ---- |
| Bob   | 30.0 | 1988-10-17 | Shang Hai | male |
| James | 40.0 | 1978-08-08 | Shen Zhen | male |

```python
# 筛选出性别不为 unknown 的数据
user_info[~(user_info.sex == "unknown")]
```

Python

|       | age  | birth      | city       | sex    |
| ----- | ---- | ---------- | ---------- | ------ |
| name  |      |            |            |        |
| Tom   | 18.0 | 2000-02-10 | Bei Jing   | None   |
| Bob   | 30.0 | 1988-10-17 | Shang Hai  | male   |
| Mary  | NaN  | NaT        | Guang Zhou | female |
| James | 40.0 | 1978-08-08 | Shen Zhen  | male   |
| Andy  | NaN  | NaT        | NaN        | NaN    |

除了切片操作可以实现之外， `loc` 一样可以实现。

```python
user_info.loc[user_info.age > 20, ["age"]]
```

Python

|       | age  |
| ----- | ---- |
| name  |      |
| Bob   | 30.0 |
| James | 40.0 |
| Alice | 30.0 |

## isin 筛选

Series 包含了 `isin` 方法，它能够返回一个布尔向量，用于筛选数据。

```python
# 筛选出性别属于 male 和 female 的数据
user_info[user_info.sex.isin(["male", "female"])]
```

Python

|       | age  | birth      | city       | sex    |
| ----- | ---- | ---------- | ---------- | ------ |
| name  |      |            |            |        |
| Bob   | 30.0 | 1988-10-17 | Shang Hai  | male   |
| Mary  | NaN  | NaT        | Guang Zhou | female |
| James | 40.0 | 1978-08-08 | Shen Zhen  | male   |

对于索引来说，一样可以使用 `isin` 方法来筛选。

```python
user_info[user_info.index.isin(["Bob"])]
```

Python

|      | age  | birth      | city      | sex  |
| ---- | ---- | ---------- | --------- | ---- |
| name |      |            |           |      |
| Bob  | 30.0 | 1988-10-17 | Shang Hai | male |

## 通过 Callable 筛选

`loc`、`iloc`、切片操作都支持接收一个 callable 函数，callable 必须是带有一个参数（调用 Series，DataFrame）的函数，并且返回用于索引的有效输出。

```python
user_info[lambda df: df["age"] > 20]
```

Python

|       | age  | birth      | city      | sex     |
| ----- | ---- | ---------- | --------- | ------- |
| name  |      |            |           |         |
| Bob   | 30.0 | 1988-10-17 | Shang Hai | male    |
| James | 40.0 | 1978-08-08 | Shen Zhen | male    |
| Alice | 30.0 | 1988-10-17 |           | unknown |

```python
user_info.loc[lambda df: df.age > 20, lambda df: ["age"]]
```

Python

|       | age  |
| :---: | :--: |
| name  |      |
|  Bob  | 30.0 |
| James | 40.0 |
| Alice | 30.0 |

```python
user_info.iloc[lambda df: [0, 5], lambda df: [0]]
```

Python

|       | age  |
| :---: | :--: |
| name  |      |
|  Tom  | 18.0 |
| Alice | 30.0 |
