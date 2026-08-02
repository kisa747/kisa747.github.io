# pandas 读写

参考：

<https://pandas.pydata.org/pandas-docs/stable/reference/series.html#datetimelike-properties>

## 读写 csv 文件

```python
# 读取 csv 文件，可以指定索引列、是否解析日期、编码，还可以额外指定 infer_datetime_format=True，提高解析速度。
# 根据官方文档，If True and parse_dates is enabled, pandas will attempt to infer the format of the datetime strings in the columns, and if it can be inferred, switch to a faster method of parsing them. In some cases this can increase the parsing speed by 5-10x.
df = pd.read_csv('1.csv',index_col=2, parse_dates=True, encoding='gbk')
# parse_dates 参数还可以将分别包含年、月、日的列合并解析为一个日期列，parse_dates={'date':[0,1,2]}
# df 的 'date' 列位于第一列，且原来的 2、3、4 列会被丢弃。
df = pd.read_csv('1.csv', parse_dates={'date':[2,3,4]}, encoding='gbk')
# 写入 csv 文件，默认会写入索引列，可以指定编码格式、日期格式。
df.to_csv('3.csv', index=False, encoding='gbk', date_format='%Y/%m/%d')
```

## 读写 excel 文件

读取 excel 文件，参考：<https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_excel.html>

```python
# sheet_name 参数为 0 时，表示仅读取第一个工作表；参数为列表 [0,1, 'sheet1']，表示读取第 1、2 个工作表；
# sheet_name 参数为 'sheet1' 时，表示读取名称为 sheet1 的工作表。
# parse_dates 参数默认为 False
pd.read_excel('test.xlsx', sheet_name=0, index_col=0,  parse_dates=True)
```

写入 excel 文件

```python
with pd.ExcelWriter(xlsx_path, engine='xlsxwriter', date_format='YYYY-MM-DD') as writer:
    df.to_excel(writer, sheet_name='A 股数据', index=False, float_format='%.4f', freeze_panes=(1,0))
    workbook = writer.book  # 获取工作簿
    worksheet = writer.sheets['A 股数据']  # 获取工作表
    # worksheet.freeze_panes(1, 0)  # 冻结首行
    cell_format = workbook.add_format({'align':'center'})  # 定义单元格样式
    worksheet.set_column('A:A', 12, cell_format)  # 设置列的单元格样式
```

## 读写数据库

方法 1：

```python
with sqlite3.connect('weather_from_2345.db') as con:
    # 指定日期的 format，速度提升 10~100 倍
    df = pd.read_sql(f'SELECT * FROM 郑州', con, index_col='date', parse_dates={'date':'%Y-%m-%d'})
```

方法 2：

```python
from sqlalchemy import create_engine
engine = create_engine(f'sqlite:///weather_from_2345.db')
df = pd.read_sql('郑州', engine, index_col='date', parse_dates={'date':'%Y-%m-%d'})
parse_dates : list or dict, default: None
        - List of column names to parse as dates.
        - Dict of ``{column_name: format string}`` where format string is
        strftime compatible in case of parsing string times, or is one of
        (D, s, ns, ms, us) in case of parsing integer timestamps.
        - Dict of ``{column_name: arg dict}``, where the arg dict corresponds
        to the keyword arguments of :func:`pandas.to_datetime`
                Especially useful with databases without native Datetime support,
                such as SQLite.
```

写入数据库

方法 1：

参考：<https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.to_sql.html>

```python
engine = create_engine('sqlite://', echo=False)
# if_exists 默认选项是 fail，如果表名已存在则抛出 ValueError。
# if_exists 选项为'replace'时，Drop the table before inserting new values.
# if_exists 选项为'append'时，Insert new values to the existing table.
df.to_sql('users', con=engine, if_exists='replace')
```

方法 2：

采用标准的 SQL 语句操作。

```python
with sqlite3.connect('weather_from_2345.db') as con:
    con.execute(f"insert or ignore into {stock_exchange} values (?,?,?,?,?)", [1,2,3,4,5])
```
