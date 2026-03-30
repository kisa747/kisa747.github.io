# 分组聚合

```python
# 导入相关库
import numpy as np
import pandas as pd

index = pd.Index(data=["Tom", "Bob", "Mary", "James", "Andy", "Alice"], name="name")

data = {
    "age": [18, 30, 35, 18, np.nan, 30],
    "city": ["Bei Jing ", "Shang Hai ", "Guang Zhou", "Shen Zhen", np.nan, " "],
    "sex": ["male", "male", "female", "male", np.nan, "female"],
    "income": [3000, 8000, 8000, 4000, 6000, 7000]
}

user_info = pd.DataFrame(data=data, index=index)
user_info
```

显示如下：

| name  | age  | city       | income | sex    |
| ----- | ---- | ---------- | ------ | ------ |
| Tom   | 18.0 | Bei Jing   | 3000   | male   |
| Bob   | 30.0 | Shang Hai  | 8000   | male   |
| Mary  | 35.0 | Guang Zhou | 8000   | female |
| James | 18.0 | Shen Zhen  | 4000   | male   |
| Andy  | NaN  | NaN        | 6000   | NaN    |
| Alice | 30.0 |            | 7000   | female |

## 将对象分割成组

在进行分组统计前，首先要做的就是进行分组。既然是分组，就需要依赖于某个信息。

比如，依据性别来分组。直接调用 `user_info.groupby(user_info["sex"])`即可完成按照性别分组。

```python
grouped  = user_info.groupby(user_info["sex"])
grouped.groups
>>>
xxxxxxxxxx {'female': Index(['Mary', 'Alice'], dtype='object', name='name'), 'male': Index(['Tom', 'Bob', 'James'], dtype='object', name='name')}
```

可以看到，已经能够正确的按照性别来进行分组了。通常我们为了更简单，会使用这种方式来实现相同的功能：`user_info.groupby("sex")` 。

```python
grouped  = user_info.groupby("sex")
grouped.groups
>>>
{'female': Index(['Mary', 'Alice'], dtype='object', name='name'),
 'male': Index(['Tom', 'Bob', 'James'], dtype='object', name='name')}
```

你可能会想，能不能先按照性别来分组，再按照年龄进一步分组呢？答案是可以的，看这里。

```python
grouped  = user_info.groupby(["sex", "age"])
grouped.groups

>>>
{('female', 30.0): Index(['Alice'], dtype='object', name='name'),
 ('female', 35.0): Index(['Mary'], dtype='object', name='name'),
 ('male', 18.0): Index(['Tom', 'James'], dtype='object', name='name'),
 ('male', 30.0): Index(['Bob'], dtype='object', name='name'),
 (nan, nan): Index(['Andy'], dtype='object', name='name')}
```

### 关闭排序

默认情况下，`groupby` 会在操作过程中对数据进行排序。如果为了更好的性能，可以设置 `sort=False`。

```python
grouped  = user_info.groupby(["sex", "age"], sort=False)
grouped.groups
>>>
{('female', 30.0): Index(['Alice'], dtype='object', name='name'),
 ('female', 35.0): Index(['Mary'], dtype='object', name='name'),
 ('male', 18.0): Index(['Tom', 'James'], dtype='object', name='name'),
 ('male', 30.0): Index(['Bob'], dtype='object', name='name'),
 (nan, nan): Index(['Andy'], dtype='object', name='name')}
```

对时间序列进行分组

```python
grouped = df.groupby(df.index.year)
```

### 选择列

在使用 `groupby` 进行分组后，可以使用切片 `[]` 操作来完成对某一列的选择。

```python
grouped  = user_info.groupby("sex")
grouped
```

Python

```python
grouped["city"]
```

Python

### 遍历分组

在对数据进行分组后，可以进行遍历。

```python
grouped  = user_info.groupby("sex")

for name, group in grouped:
    print("name: {}".format(name))
    print("group: {}".format(group))
    print("--------------")
```

```ini
name: female
group:         age        city  income     sex
name
Mary   35.0  Guang Zhou    8000  female
Alice  30.0                7000  female
--------------
name: male
group:         age        city  income   sex
name
Tom    18.0   Bei Jing     3000  male
Bob    30.0  Shang Hai     8000  male
James  18.0   Shen Zhen    4000  male
--------------
```

如果是根据多个字段来分组的，每个组的名称是一个元组。

```python
grouped  = user_info.groupby(["sex", "age"])

for name, group in grouped:
    print("name: {}".format(name))
    print("group: {}".format(group))
    print("--------------")
```

Python

```ini
name: ('female', 30.0)
group:         age city  income     sex
name
Alice  30.0         7000  female
--------------
name: ('female', 35.0)
group:        age        city  income     sex
name
Mary  35.0  Guang Zhou    8000  female
--------------
name: ('male', 18.0)
group:         age       city  income   sex
name
Tom    18.0  Bei Jing     3000  male
James  18.0  Shen Zhen    4000  male
--------------
name: ('male', 30.0)
group:        age        city  income   sex
name
Bob   30.0  Shang Hai     8000  male
--------------
```

### 选择一个组

分组后，我们可以通过 `get_group` 方法来选择其中的某一个组。

```python
grouped  = user_info.groupby("sex")
grouped.get_group("male")
```

Python

|       | age  | city      | income | sex  |
| ----- | ---- | --------- | ------ | ---- |
| name  |      |           |        |      |
| Tom   | 18.0 | Bei Jing  | 3000   | male |
| Bob   | 30.0 | Shang Hai | 8000   | male |
| James | 18.0 | Shen Zhen | 4000   | male |

```python
user_info.groupby(["sex", "age"]).get_group(("male", 18))
```

Python

|       | age  | city      | income | sex  |
| ----- | ---- | --------- | ------ | ---- |
| name  |      |           |        |      |
| Tom   | 18.0 | Bei Jing  | 3000   | male |
| James | 18.0 | Shen Zhen | 4000   | male |

## 聚合

分组的目的是为了统计，统计的时候需要聚合，所以我们需要在分完组后来看下如何进行聚合。常见的一些聚合操作有：计数、求和、最大值、最小值、平均值等。

想要实现聚合操作，一种方式就是调用 `agg` 方法。

```python
# 获取不同性别下所包含的人数
grouped = user_info.groupby("sex")
grouped["age"].agg(len)
```

Python

```ini
sex
female    2.0
male      3.0
Name: age, dtype: float64
# 获取不同性别下包含的最大的年龄
grouped = user_info.groupby("sex")
grouped["age"].agg(np.max)
```

Python

```ini
sex
female    35.0
male      30.0
Name: age, dtype: float64
```

如果是根据多个键来进行聚合，默认情况下得到的结果是一个多层索引结构。

```python
grouped = user_info.groupby(["sex", "age"])
rs = grouped.agg(len)
rs
```

Python

|        |      | city | income |
| ------ | ---- | ---- | ------ |
| sex    | age  |      |        |
| female | 30.0 | 1    | 1      |
| 35.0   | 1    | 1    |        |
| male   | 18.0 | 2    | 2      |
| 30.0   | 1    | 1    |        |

有两种方式可以避免出现多层索引，先来介绍第一种。对包含多层索引的对象调用 `reset_index` 方法。

```python
rs.reset_index()
```

Python

|      | sex    | age  | city | income |
| ---- | ------ | ---- | ---- | ------ |
| 0    | female | 30.0 | 1    | 1      |
| 1    | female | 35.0 | 1    | 1      |
| 2    | male   | 18.0 | 2    | 2      |
| 3    | male   | 30.0 | 1    | 1      |

另外一种方式是在分组时，设置参数 `as_index=False`。

```python
grouped = user_info.groupby(["sex", "age"], as_index=False)
grouped.agg(len)
```

Python

|      | sex    | age  | city | income |
| ---- | ------ | ---- | ---- | ------ |
| 0    | female | 30.0 | 1    | 1      |
| 1    | female | 35.0 | 1    | 1      |
| 2    | male   | 18.0 | 2    | 2      |
| 3    | male   | 30.0 | 1    | 1      |

Series 和 DataFrame 都包含了 `describe` 方法，我们分组后一样可以使用 `describe` 方法来查看数据的情况。

```python
grouped = user_info.groupby("sex")
grouped.describe()
```

Python

|        | age   | income |          |      |       |      |       |      |       |        |             |        |        |        |        |        |
| ------ | ----- | ------ | -------- | ---- | ----- | ---- | ----- | ---- | ----- | ------ | ----------- | ------ | ------ | ------ | ------ | ------ |
|        | count | mean   | std      | min  | 25%   | 50%  | 75%   | max  | count | mean   | std         | min    | 25%    | 50%    | 75%    | max    |
| sex    |       |        |          |      |       |      |       |      |       |        |             |        |        |        |        |        |
| female | 2.0   | 32.5   | 3.535534 | 30.0 | 31.25 | 32.5 | 33.75 | 35.0 | 2.0   | 7500.0 | 707.106781  | 7000.0 | 7250.0 | 7500.0 | 7750.0 | 8000.0 |
| male   | 3.0   | 22.0   | 6.928203 | 18.0 | 18.00 | 18.0 | 24.00 | 30.0 | 3.0   | 5000.0 | 2645.751311 | 3000.0 | 3500.0 | 4000.0 | 6000.0 | 8000.0 |

### 一次应用多个聚合操作

有时候进行分组后，不单单想得到一个统计结果，有可能是多个。比如想统计出不同性别下的一个收入的总和和平均值。

```python
grouped = user_info.groupby("sex")
grouped["income"].agg([np.sum, np.mean])
```

Python

|        | sum   | mean |
| ------ | ----- | ---- |
| sex    |       |      |
| female | 15000 | 7500 |
| male   | 15000 | 5000 |

如果想将统计结果进行重命名，可以传入字典。

```python
grouped = user_info.groupby("sex")
grouped["income"].agg([np.sum, np.mean]).rename(columns={"sum": "income_sum", "mean": "income_mean"})
```

Python

|        | income_sum | income_mean |
| ------ | ---------- | ----------- |
| sex    |            |             |
| female | 15000      | 7500        |
| male   | 15000      | 5000        |

### 对 DataFrame 列应用不同的聚合操作

有时候可能需要对不同的列使用不同的聚合操作。例如，想要统计不同性别下人群的年龄的均值以及收入的总和。

```python
grouped = user_info.groupby("sex")
grouped.agg({"age": np.mean, "income": np.sum}).rename(columns={"age": "age_mean", "income": "income_sum"})
```

Python

|        | age_mean | income_sum |
| ------ | -------- | ---------- |
| sex    |          |            |
| female | 32.5     | 15000      |
| male   | 22.0     | 15000      |

## transform 操作

前面进行聚合运算的时候，得到的结果是一个以分组名作为索引的结果对象。虽然可以指定 `as_index=False` ,但是得到的索引也并不是元数据的索引。如果我们想使用原数组的索引的话，就需要进行 merge 转换。

`transform`方法简化了这个过程，它会把 func 参数应用到所有分组，然后把结果放置到原数组的索引上（如果结果是一个标量，就进行广播）

```python
# 通过 agg 得到的结果的索引是分组名
grouped = user_info.groupby("sex")
grouped["income"].agg(np.mean)
```

Python

```ini
sex
female    7500
male      5000
Name: income, dtype: int64
# 通过 transform 得到的结果的索引是原始索引，它会将得到的结果自动关联上原始的索引
grouped = user_info.groupby("sex")
grouped["income"].transform(np.mean)
```

```python
name
Tom      5000.0
Bob      5000.0
Mary     7500.0
James    5000.0
Andy        NaN
Alice    7500.0
Name: income, dtype: float64
```

可以看到，通过 `transform` 操作得到的结果的长度与原来保持一致。

## apply 操作

除了 `transform` 操作外，还有更神奇的 `apply` 操作。

`apply` 会将待处理的对象拆分成多个片段，然后对各片段调用传入的函数，最后尝试用 `pd.concat()`把结果组合起来。func 的返回值可以是 Pandas 对象或标量，并且数组对象的大小不限。

```python
# 使用 apply 来完成上面的聚合
grouped = user_info.groupby("sex")
grouped["income"].apply(np.mean)
```

Python

```ini
sex
female    7500.0
male      5000.0
Name: income, dtype: float64
```

来看下 `apply` 不一样的用法吧。

比如想要统计不同性别最高收入的前 n 个值，可以通过下面这种方式实现。

```python
def f1(ser, num=2):
    return ser.nlargest(num).tolist()

grouped["income"].apply(f1)
```

Python

```ini
sex
female    [8000, 7000]
male      [8000, 4000]
Name: income, dtype: object
```

另外，如果想要获取不同性别下的年龄的均值，通过 `apply` 可以如下实现。

```python
def f2(df):
    return df["age"].mean()

grouped.apply(f2)
```

Python

```ini
sex
female    32.5
male      22.0
dtype: float64
```
