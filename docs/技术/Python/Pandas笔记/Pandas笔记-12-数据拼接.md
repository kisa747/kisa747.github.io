# 数据拼接

## 笔记

> 如果只是简单的增加行，两个 DataFrame 用 append 或 concat 就可以了。
>
> 如果有两个 DataFrame，分别存储了用户的部分信息，现在需要将用户的这些信息关联起来。使用 merge。
>
> `pandas.merge(*left*, *right*, *how='inner'*, *on=None*, *left_on=None*, *right_on=None*, *left_index=False*, *right_index=False*, *sort=False*, *suffixes=('_x'*, *'_y')*, *copy=True*, *indicator=False*, *validate=None*)`
>
> left：左边的数据
>
> right：右边的数据
>
> how：左右两边数据不一致，且可能左边有，右边没有。inner，丢弃所有有缺失的行，丢弃所有有重复的行；outer，保留所有的数据，如果有重复值，追加到后面，且追加部分的重复值会变成 nan。
>
> 这两个参数都比较怪异。最常见的还是 left，right，使用左边或右边的数据。
>
> on：两边共同的标签。表示依据 `name` 来作为关联键。
>
> left_on，right_on：如果两边关联键的名称不一样，可以通过 `left_on` 和 `right_on` 来分别设置。
>
> suffixes=("_left", "_right"))  如果两边有相同的列，suffixes 指定左右合并两边相同列的后缀。
>
> join 根 merge 大同小异
>
> 也可以 用 A.merge(B) 这样的方法。
>
> 如果想用右边的数据更新左边的数据，保持左边数据的结构，应该使用 A.update(B)

## 拼接

有两个 DataFrame，都存储了用户的一些信息，现在要拼接起来，组成一个 DataFrame，如何实现呢？

```python
data1 = {
    "name": ["Tom", "Bob"],
    "age": [18, 30],
    "city": ["Bei Jing ", "Shang Hai "]
}

df1 = pd.DataFrame(data=data1)
df1
```

输出：

|      | age  | city      | name |
| ---- | ---- | --------- | ---- |
| 0    | 18   | Bei Jing  | Tom  |
| 1    | 30   | Shang Hai | Bob  |

```python
data2 = {
    "name": ["Mary", "James"],
    "age": [35, 18],
    "city": ["Guang Zhou", "Shen Zhen"]
}

df2 = pd.DataFrame(data=data2)
df2
```

输出：

|      | age  | city       | name  |
| ---- | ---- | ---------- | ----- |
| 0    | 35   | Guang Zhou | Mary  |
| 1    | 18   | Shen Zhen  | James |

### append 纵向拼接

`df1.append(df2)` 是最简单的拼接两个 DataFrame 的方法。

```python
df1.append(df2)
```

Python

|      | age  | city       | name  |
| ---- | ---- | ---------- | ----- |
| 0    | 18   | Bei Jing   | Tom   |
| 1    | 30   | Shang Hai  | Bob   |
| 0    | 35   | Guang Zhou | Mary  |
| 1    | 18   | Shen Zhen  | James |

可以看到，拼接后的索引默认还是原有的索引，如果想要重新生成索引的话，设置参数 `ignore_index=True` 即可。

```python
df1.append(df2, ignore_index=True)
```

Python

|      | age  | city       | name  |
| ---- | ---- | ---------- | ----- |
| 0    | 18   | Bei Jing   | Tom   |
| 1    | 30   | Shang Hai  | Bob   |
| 2    | 35   | Guang Zhou | Mary  |
| 3    | 18   | Shen Zhen  | James |

### concat 拼接

除了 `append` 这种方式之外，还有 `pd.concat()` 这种方式可以实现相同的功能。

```python
df_list = [df1, df2]
pd.concat(df_list, ignore_index=True)
```

输出：

|      | age  | city       | name  |
| ---- | ---- | ---------- | ----- |
| 0    | 18   | Bei Jing   | Tom   |
| 1    | 30   | Shang Hai  | Bob   |
| 2    | 35   | Guang Zhou | Mary  |
| 3    | 18   | Shen Zhen  | James |

如果想要区分出不同的 DataFrame 的数据，可以通过设置参数 `keys`，当然得设置参数 `ignore_index=False`。

```python
pd.concat(objs, ignore_index=False, keys=["df1", "df2"])
```

输出：

|      |      | age       | city       | name |
| ---- | ---- | --------- | ---------- | ---- |
| df1  | 0    | 18        | Bei Jing   | Tom  |
| 1    | 30   | Shang Hai | Bob        |      |
| df2  | 0    | 35        | Guang Zhou | Mary |
| 1    | 18   | Shen Zhen | James      |      |

## 关联

有两个 DataFrame，分别存储了用户的部分信息，现在需要将用户的这些信息关联起来，如何实现呢？

```python
data1 = {
    "name": ["Tom", "Bob", "Mary", "James"],
    "age": [18, 30, 35, 18],
    "city": ["Bei Jing ", "Shang Hai ", "Guang Zhou", "Shen Zhen"]
}

df1 = pd.DataFrame(data=data1)
df1
```

输出：

|      | age  |    city    | name  |
| :--: | :--: | :--------: | :---: |
|  0   |  18  |  Bei Jing  |  Tom  |
|  1   |  30  | Shang Hai  |  Bob  |
|  2   |  35  | Guang Zhou | Mary  |
|  3   |  18  | Shen Zhen  | James |

```python
data2 = {"name": ["Bob", "Mary", "James", "Andy"],
        "sex": ["male", "female", "male", np.nan],
         "income": [8000, 8000, 4000, 6000]
}

df2 = pd.DataFrame(data=data2)
df2
```

输出：

|      | income | name  | sex    |
| ---- | ------ | ----- | ------ |
| 0    | 8000   | Bob   | male   |
| 1    | 8000   | Mary  | female |
| 2    | 4000   | James | male   |
| 3    | 6000   | Andy  | NaN    |

### merge 根据列关联

通过 `pd.merge` 可以关联两个 DataFrame，这里我们设置参数 `on="name"`，表示依据 `name` 来作为关联键。

```python
pd.merge(df1, df2, on="name")
```

Python

|      | age  | city       | name  | income | sex    |
| ---- | ---- | ---------- | ----- | ------ | ------ |
| 0    | 30   | Shang Hai  | Bob   | 8000   | male   |
| 1    | 35   | Guang Zhou | Mary  | 8000   | female |
| 2    | 18   | Shen Zhen  | James | 4000   | male   |

关联后发现数据变少了，只有 3 行数据，这是因为默认关联的方式是 `inner`，如果不想丢失任何数据，可以设置参数 `how="outer"`。

```python
pd.merge(df1, df2, on="name", how="outer")
```

Python

|      | age  | city       | name  | income | sex    |
| ---- | ---- | ---------- | ----- | ------ | ------ |
| 0    | 18.0 | Bei Jing   | Tom   | NaN    | NaN    |
| 1    | 30.0 | Shang Hai  | Bob   | 8000.0 | male   |
| 2    | 35.0 | Guang Zhou | Mary  | 8000.0 | female |
| 3    | 18.0 | Shen Zhen  | James | 4000.0 | male   |
| 4    | NaN  | NaN        | Andy  | 6000.0 | NaN    |

可以看到，设置参数 how="outer" 后，确实不会丢失任何数据，他会在不存在的地方填为缺失值。

如果我们想保留左边所有的数据，可以设置参数 `how="left"`；反之，如果想保留右边的所有数据，可以设置参数 `how="right"`

```python
pd.merge(df1, df2, on="name", how="left")
```

Python

|      | age  | city       | name  | income | sex    |
| ---- | ---- | ---------- | ----- | ------ | ------ |
| 0    | 18   | Bei Jing   | Tom   | NaN    | NaN    |
| 1    | 30   | Shang Hai  | Bob   | 8000.0 | male   |
| 2    | 35   | Guang Zhou | Mary  | 8000.0 | female |
| 3    | 18   | Shen Zhen  | James | 4000.0 | male   |

有时候，两个 DataFrame 中需要关联的键的名称不一样，可以通过 `left_on` 和 `right_on` 来分别设置。

```python
df1.rename(columns={"name": "name1"}, inplace=True)
df1
```

Python

|      | age  | city       | name1 |
| ---- | ---- | ---------- | ----- |
| 0    | 18   | Bei Jing   | Tom   |
| 1    | 30   | Shang Hai  | Bob   |
| 2    | 35   | Guang Zhou | Mary  |
| 3    | 18   | Shen Zhen  | James |

```python
df2.rename(columns={"name": "name2"}, inplace=True)
df2
```

Python

|      | income | name2 | sex    |
| ---- | ------ | ----- | ------ |
| 0    | 8000   | Bob   | male   |
| 1    | 8000   | Mary  | female |
| 2    | 4000   | James | male   |
| 3    | 6000   | Andy  | NaN    |

```python
pd.merge(df1, df2, left_on="name1", right_on="name2")
```

Python

|      | age  | city       | name1 | income | name2 | sex    |
| ---- | ---- | ---------- | ----- | ------ | ----- | ------ |
| 0    | 30   | Shang Hai  | Bob   | 8000   | Bob   | male   |
| 1    | 35   | Guang Zhou | Mary  | 8000   | Mary  | female |
| 2    | 18   | Shen Zhen  | James | 4000   | James | male   |

有时候，两个 DataFrame 中都包含相同名称的字段，如何处理呢？

我们可以设置参数 `suffixes`，默认 `suffixes=('_x', '_y')` 表示将相同名称的左边的 DataFrame 的字段名加上后缀 `_x`，右边加上后缀 `_y`。

```python
df1["sex"] = "male"
df1
```

Python

|      | age  | city       | name1 | sex  |
| ---- | ---- | ---------- | ----- | ---- |
| 0    | 18   | Bei Jing   | Tom   | male |
| 1    | 30   | Shang Hai  | Bob   | male |
| 2    | 35   | Guang Zhou | Mary  | male |
| 3    | 18   | Shen Zhen  | James | male |

```python
pd.merge(df1, df2, left_on="name1", right_on="name2")
```

Python

|      | age  | city       | name1 | sex_x | income | name2 | sex_y  |
| ---- | ---- | ---------- | ----- | ----- | ------ | ----- | ------ |
| 0    | 30   | Shang Hai  | Bob   | male  | 8000   | Bob   | male   |
| 1    | 35   | Guang Zhou | Mary  | male  | 8000   | Mary  | female |
| 2    | 18   | Shen Zhen  | James | male  | 4000   | James | male   |

```python
pd.merge(df1, df2, left_on="name1", right_on="name2", suffixes=("_left", "_right"))
```

Python

|      | age  | city       | name1 | sex_left | income | name2 | sex_right |
| ---- | ---- | ---------- | ----- | -------- | ------ | ----- | --------- |
| 0    | 30   | Shang Hai  | Bob   | male     | 8000   | Bob   | male      |
| 1    | 35   | Guang Zhou | Mary  | male     | 8000   | Mary  | female    |
| 2    | 18   | Shen Zhen  | James | male     | 4000   | James | male      |

### join 根据索引关联

除了 `merge` 这种方式外，还可以通过 `join` 这种方式实现关联。相比 `merge`，`join` 这种方式有以下几个不同：

- 默认参数`on=None`，表示关联时使用左边和右边的索引作为键，设置参数`on`可以指定的是关联时左边的所用到的键名
- 左边和右边字段名称重复时，通过设置参数 `lsuffix` 和 `rsuffix` 来解决。

```python
df1.join(df2.set_index("name2"), on="name1", lsuffix="_left")
```

Python

|      | age  | city       | name1 | sex_left | income | sex    |
| ---- | ---- | ---------- | ----- | -------- | ------ | ------ |
| 0    | 18   | Bei Jing   | Tom   | male     | NaN    | NaN    |
| 1    | 30   | Shang Hai  | Bob   | male     | 8000.0 | male   |
| 2    | 35   | Guang Zhou | Mary  | male     | 8000.0 | female |
| 3    | 18   | Shen Zhen  | James | male     | 4000.0 | male   |

## 更新、合并

参考：<http://renpeter.cn/2022/10/09/Pandas%E5%87%BD%E6%95%B0-combine-update.html>

### df.update() 更新数据

```python
DataFrame.update(
    other, # 另一个合并的数据
    join='left', # 默认是保留 left 中的全部信息
    overwrite=True, # 是否覆写
    filter_func=None, # 过滤函数
    errors='ignore')  # 异常报错处理

# 用 df2 的值更新 df1
# df2 的空值会忽略
df1.upate(df2)
```

update 的三个特点：

①返回的框索引只会与被调用框的一致（默认使用左连接）
②第二个框中的 nan 元素不会起作用
③没有返回值，直接在 df 上操作

### df.combine_first() 合并数据

```python
DataFrame.combine(
    other, # 另个 DataFrame
    func,  # 拼接时使用的函数，可以是自定义的函数，也可以是 Python 或者 numpy 内置函数
    fill_value=None, #  缺失值填充处理
    overwrite=True)  # 是否覆写

# 合并两个数据中某个位置第一次出现的元素；如果其中数据不存在，用空值 NaN 代替
df1.combine(df2 )
```

示例：

```python
df3 = pd.DataFrame({'A': [None, 0], 'B': [4, None]})
df4 = pd.DataFrame({'B': [3, 3], 'C': [1, 1]}, index=[1, 2])
df3
>>>
     A   B
0 NaN 4.0
1 0.0 NaN

df4
>>>
 B C
1 3 1
2 3 1

df3.combine_first(df4)
>>>
 A B C
0 NaN 4.0 NaN
1 0.0 3.0 1.0
2 NaN 3.0 1.0
```

### df.combine() 合并数据

```python
DataFrame.combine(
    other, # 另个 DataFrame
    func,  # 拼接时使用的函数，可以是自定义的函数，也可以是 Python 或者 numpy 内置函数
    fill_value=None, #  缺失值填充处理
    overwrite=True)  # 是否覆写

# 在进行比较的时候，是两个 DataFrame 相同的位置同时为空值才会进行指定值的填充；
# 如果只有一个 DataFrame 为空值，那么结果就是非空值
# 每个位置上对应的元素进行比较，取出较小者
df5.combine(df6, np.minimum)
```

测试：

```python
df5 = pd.DataFrame({'A': [1, 0], 'B': [4, 3], 'C': [5, 7]})
df6 = pd.DataFrame({'A': [2, 1], 'B': [2, 3], 'C': [8, 9]})
df5
>>>
 A B C
0 1 4 5
1 0 3 7

df6
>>>
 A B C
0 2 2 8
1 1 3 9

# 每个位置上对应的元素进行比较，取出较小者
df5.combine(df6, np.minimum)
>>>
 A B C
0 1 2 5
1 0 3 7
```
