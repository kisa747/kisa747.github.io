# SQLite 笔记

参考：<https://docs.python.org/zh-cn/3/library/sqlite3.html>

使用过 sqlite 时，可以指定 `detect_types=sqlite3.PARSE_DECLTYPES` 参数。

```python
# detect_types=sqlite3.PARSE_DECLTYPES 参数
with sqlite3.connect(db_path, detect_types=sqlite3.PARSE_DECLTYPES) as con:
    con.execute("create table if not exists t1(id integer primary key autoincrement, name varchar(128), info varchar(128))")
```

设置这个参数后，`sqlite3` 模块将解析它返回的每一列申明的类型。它会申明的类型的第一个单词，比如“integer primary key”，它会解析出“integer”，再比如“number(10)”，它会解析出“number”。然后，它会在转换器字典里查找那个类型注册的转换器函数，并调用它。

```sh
# 连接对象可以用来作为上下文管理器，它可以自动提交或者回滚事务。如果出现异常，事务会被回滚；否则，事务会被提交。
with sqlite3.connect(db_path, detect_types=sqlite3.PARSE_DECLTYPES) as con:
sqlite3.PARSE_DECLTYPES
# 本常量使用在函数 connect() 里，设置在关键字参数 detect_types 上面。表示在返回一行值时，是否分析这列值的数据类型定义。
# 如果设置了本参数，就进行分析数据表列的类型，并返回此类型的对象，并不是返回字符串的形式。

sqlite3.PARSE_COLNAMES
# 本常量使用在函数 connect() 里，设置在关键字参数 detect_types 上面。表示在返回一行值时，是否分析这列值的名称。
# 如果设置了本参数，就进行分析数据表列的名称，并返回此类型的名称

# 查询所有的表名
label_names = con.execute("select name from sqlite_master where type='table' order by name")


# fetchone() 的用法
cur.execute('SELECT name, friends FROM Twitter WHERE retrieved = 0')
# 包含选中元素 (name, friends) 的第一行，以 tuple 形式存在：
row = cur.fetchone()
# row[0] 代表 name
# row[1] 代表 friends

# fetchall() 的用法
cur.execute('SELECT name, friends FROM Twitter WHERE retrieved = 0')
# 包含选中元素 (name, friends) 的所有行，以 list(tuple, tuple, ...) 形式存在：
allrows = cur.fetchall()
# allrows[i] 代表“第 i 行的 tuple”
# allrows[i][0] 代表“第 i 行的 tuple 的 name”
# allrows[i][1] 代表“第 i 行的 tuple 的 friends”
```

## SQLite 语法

```sqlite
sqlite3
.open 'sqlite.db'
.header on
.mode column
.tables --查看所有的表
.schema  --整个数据库的概述
CREATE TABLE wallhaven_table(
            id integer primary key autoincrement,
            pic_name text not null unique,
            pic_suffix text default 'jpg'
            );
CREATE UNIQUE INDEX name if not exists name on wallhaven_table (name);
SELECT * FROM wallhaven_table;  --查看整个表

# 查看整个数据库的所有表名
select name from sqlite_master where type='table' order by name
SELECT * FROM 郑州
```

## 游标 cursor

​  游标提供了一种对从表中检索出的数据进行操作的灵活手段，就本质而言，游标实际上是一种能从包括多条数据记录的结果集中每次提取一条记录的机制。游标总是与一条 SQL  选择语句相关联。因为游标由**结果集**（可以是零条、一条或由相关的选择语句检索出的多条记录）和结果集中指向特定记录的**游标位置**组成。当决定对结果集进行处理时，必须声明一个指向该结果集的游标。如果曾经用 C 语言写过对文件进行处理的程序，那么游标就像您打开文件所得到的文件句柄一样，只要文件打开成功，该文件句柄就可代表该文件。对于游标而言，其道理是相同的。可见游标能够实现按与传统程序读取平面文件类似的方式处理来自基础表的结果集，从而把表中数据以平面文件的形式呈现给程序。
​        我们知道**关系数据库管理系统实质是面向集合**的，在 Sqlite 中并没有一种描述表中单一记录的表达形式，除非使用 where  子句来限制只有一条记录被选中。因此我们必须借助于游标来进行面向单条记录的数据处理。由此可见，游标允许应用程序对查询语句 select  返回的行结果集中每一行进行相同或不同的操作，而不是一次对整个结果集进行同一种操作；它还提供对基于游标位置而对表中数据进行删除或更新的能力；正是游标把作为面向集合的数据库管理系统和面向行的程序设计两者联系起来，使两个数据处理方式能够进行沟通。

```python
import sqlite3

conn = sqlite3.connect(":memory:")
conn.isolation_level = None #这个就是事务隔离级别，默认是需要自己 commit 才能修改数据库，置为 None 则自动每次修改都提交，否则为""
# 下面就是创建一个表
conn.execute("create table if not exists t1(id integer primary key autoincrement, name varchar(128), info varchar(128))")
# 插入数据
conn.execute("insert into t1(name,info) values ('zhaowei', 'only a test')")
# 如果隔离级别不是自动提交就需要手动执行 commit
conn.commit()
# 获取到游标对象
cur = conn.cursor()
# 用游标来查询就可以获取到结果
cur.execute("select * from t1")
# 获取所有结果
res = cur.fetchall()
print('row:', cur.rowcount)
# cur.description 是对这个表结构的描述
print 'desc', cur.description
# 用 fetchall 返回的结果是一个二维的列表
for line in res:
    for f in line:
        print f,
    print
print '-'*60

cur.execute("select * from t1")
# 这次查询后只取一个结果，就是一维列表
res = cur.fetchone()
print 'row:', cur.rowcount
for f in res:
    print f,
print
# 再取一行
res = cur.fetchone()
print 'row:', cur.rowcount
for f in res:
    print f,
print
print '-'*60


cur.close()
conn.close()
```

## pandas 操作数据库

pandas 操作数据库，需要安装 sqlalchemy 库。

```python
from sqlalchemy import create_engine
# 参数字段 sqlite:///<database path>
engine = create_engine('sqlite:///weather_from_2345.db')
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

Python 下操作 SQLite 数据库

- [ ] 添加 Python 下操作的方法
- [ ] 添加 pandas 下操作的方法
