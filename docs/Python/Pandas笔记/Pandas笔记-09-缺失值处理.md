# Pandas 缺失值处理

参考：官方文档 [Working with missing data](https://pandas.pydata.org/pandas-docs/stable/user_guide/missing_data.html)

[joyfulpandas 缺失数据](http://joyfulpandas.datawhale.club/Content/ch7.html)

pandas 的缺失值处理很复杂。

在 pandas 中 None、NaN(np.nan)、NaT(np.nan)、\<NA>(pd.NA)，都能表示缺失值。

* pd.NA 仍是试验特性，特性会不断更改，主要用在 整型数据、布尔数据。
* 读取文件得到的 DataFrame 不会产生 None，但是从 python 内部 的列表、字典等得到的 DataFrame 可能会产生 None。
* NaT(np.nan) 用于时间序列，特性与 NaN(np.nan) 一致

np.nan 来自 Numpy，当然特性也与 Numpy 中的一致，np.nan 为浮点型数据。

在数据类型（整型、浮点型）的 df 中，np.nan 行为与 0 高度一致。

在文本类型（object）的 df 中，与在 Excel 中的空置有很大不同：

* `s1.str.cat(s2)` 或 df1 + df2，只要存在空值，得到的就为空值（NaN）。
* 处理文本数据的空值，建议使用 `df.fillna('')` 替换为空白文本。

如果要使用 \<NA>(pd.NA)，最简单的方法是使用 `df.convert_dtypes()` 转换（NaT 不会被转换）。This is especially useful after reading in data using readers such as [`read_csv()`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_csv.html#pandas.read_csv) and [`read_excel()`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_excel.html#pandas.read_excel). See [文档](https://pandas.pydata.org/pandas-docs/stable/user_guide/missing_data.html#missing-data-na-conversion) for a description.

pandas 从 1.0 开始支持 string（StringDtype）专用数据格式，使用 `df.convert_dtypes()` 转换后，数据格式会变为 string（StringDtype）。
