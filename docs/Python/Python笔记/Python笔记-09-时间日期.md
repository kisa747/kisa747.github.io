# 时间日期

## 笔记

```python
from datetime import datetime, date
import time

# 快速获取当前年月，赋给变量。
t = date.today()  # date 类无法处理时间，无法处理时间戳
year, month, day = t.year, t.month, t.day

t = datetime.now()  # 没有指定时区，等价于 datetime.today()
year, month, day = t.year, t.month, t.day

year, month, day, *_ = time.localtime()
year, month, day = time.localtime()[:3]
```

格式化日期：

```python
t.format(format)
```

常用的格式如下表：更多参见：<https://docs.python.org/3/library/datetime.html?highlight=datetime#strftime-and-strptime-behavior>

| Directive | Meaning                                                      | Example                                  | Notes    |
| :-------: | ------------------------------------------------------------ | ---------------------------------------- | -------- |
|   `%Y`    | 年，4 位。（y%是 2 位的年）                                     | 0001, 0002, …, 2013, 2014, …, 9998, 9999 | (2)      |
|   `%m`    | Month as a zero-padded decimal number.                       | 01, 02, …, 12                            |          |
|   `%d`    | Day of the month as a zero-padded decimal number.            | 01, 02, …, 31                            |          |
|   `%w`    | Weekday as a decimal number, where 0 is Sunday and 6 is Saturday. | 0, 1, …, 6                               |          |
|   `%H`    | 小时（24 小时制）（I%标识 12 小时制小时）                       | 00, 01, …, 23                            |          |
|   `%M`    | 分钟，2 位                                                    | 00, 01, …, 59                            |          |
|   `%S`    | Second as a zero-padded decimal number.                      | 00, 01, …, 59                            | (4)      |
|   `%p`    | 上下午（AM、PM）                                             | AM, PM (en_US);am, pm (de_DE)            | (1), (3) |
|   `%z`    | 相对于标准时间（UTC）的时间偏移，格式 ±HHMM[SS] (如果没有，返回空的字符串) | (empty), +0000, -0400, +1030             | (6)      |
|   `%%`    | 标识 % 符号本身                                              | %                                        |          |

下表不是 ISO 标准。

| Directive | Meaning                                                      | Example       | Notes |
| :-------: | ------------------------------------------------------------ | ------------- | ----- |
|   `%u`    | ISO 8601 weekday as a decimal number where 1 is Monday.      | 1, 2, …, 7    |       |
|   `%V`    | ISO 8601 week as a decimal number with Monday as the first day of the week. Week 01 is the week containing Jan 4. | 01, 02, …, 53 | (8)   |

New in version 3.6: `%G`, `%u` and `%V` were added.

## time

time 只能处理 1970 年~3001 年的日期，基本够用了。而且比较简单，全是函数，更复杂的转换、比较，可以使用 datetime 模块。time 模块全是一堆函数，没有对象这个概念。

```python
import time
import datetime
dt = datetime.datetime.now()  # 获取当前 datetime 对象
ts = time.time()  # 返回当前时间的时间戳，精度为 7 的浮点数

# time 转换为 datetime 对象
datetime.datetime.fromtimestamp(ts)
Out[]: datetime.datetime(2022, 11, 1, 12, 9, 44, 287057)
# time 转换为 date 对象
datetime.date.fromtimestamp(ts)
Out[]: datetime.date(2022, 11, 1)

# datetime 转换为 time
dt.timestamp()
Out[]: 1667275784.287056

time.localtime([secs])  # 将时间戳转换为结构化时间元组
[输出：]time.struct_time(tm_year=2018, tm_mon=9, tm_mday=7, tm_hour=8, tm_min=36, tm_sec=34, tm_wday=4, tm_yday=250, tm_isdst=0)
#5  tm_sec     0 到 61 (60 或 61 是闰秒)
#6 tm_wday    0 到 6 (0 是周一)
#7 tm_yday    1 到 366 一年中的第几天，
#8 tm_isdst   是否为夏令时，值有：1(夏令时)、0(不是夏令时)、-1(未知)，默认 -1

time.strftime(format[, t])  # time 时间元组格式化
print(time.strftime("%Y-%m-%d %H:%M:%S %A %B", time.localtime()))
[输出：]2018-09-07 08:48:21 Friday September
# %m %d 表示的月和日，不够 2 位的前面会填充 0

# 其它用法
time.gmtime([secs])  # 将一个时间戳转换为 UTC 时区的结构化时间

time.strptime(string[,format]) # 将格式化时间字符串转化成结构化时间

stime = "2017-09-26 12:11:30"
st  = time.strptime(stime,"%Y-%m-%d %H:%M:%S")
st
[输出：]time.struct_time(tm_year=2017, tm_mon=9, tm_mday=26, tm_hour=12, tm_min=11, tm_sec=30, tm_wday=1, tm_yday=269, tm_isdst=-1)

# 将一个时间戳格式化输出
t = 1536280520.7295556
time.strftime('%Y-%m-%d %H:%M:%S %A %B', time.localtime(t))
[输出：]'2018-09-07 08:35:20 Friday September'
```

## datetime 对象

参考：<https://www.liaoxuefeng.com/wiki/1016959663602400/1017648783851616>

> strftime  Format to string  格式为字符串
>
> strptime  Parse string to datetime  解析字符串为 datetime 对象

datetime 是 date 的超集，date 类下的所有方法和属性 datetime 都有。

与 `time` 模块不同的是， `datetime` 模块不支持闰秒。

处理日期相关的用 date 最方便，如果涉及到时间戳转换，转换为 timetuple()，就用 datetime。

ISO 格式：`YYYY-MM-DD[*HH[:MM[:SS[.fff[fff]]]][+HH:MM[:SS[.ffffff]]]]`

```python
import time
import datetime
dt = datetime.datetime.now()  # 获取当前 datetime 对象
ts = time.time()  # 返回当前时间的时间戳，精度为 7 的浮点数

dt
Out[]: datetime.datetime(2018, 9, 7, 9, 10, 27, 439027)

# datetime 对象转换为 timestamp
dt.timestamp()
Out[]: 1667275784.287056

# datetime 对象格式化为字符串
dt.isoformat(sep='T', timespec='auto')  # 默认参数。timespec='seconds'：精确至秒，不显示秒小数点后面部分
Out[]: '2022-11-01T12:09:44.287056'
dt.strftime('%Y-%m-%d %H:%M:%S.%f')
Out[]: '2022-11-01 12:09:44.287056'

# 字符串转换为 datetime 对象
datetime_str = '2021-12-26 20:09:14.000'
datetime.datetime.fromisoformat(datetime_str)
datetime.datetime.strptime(datetime_str, '%Y-%m-%d %H:%M:%S.%f')

# timestamp 转换为 datetime 对象
datetime.datetime.fromtimestamp(ts, timezone=None)
Out[]: datetime.datetime(2022, 11, 1, 12, 9, 44, 287057)

# 将一个时间戳格式化输出
t = 1536280520.7295556
datetime.fromtimestamp(t).strftime('%Y-%m-%d %H:%M:%S %A %B')
ut[]: datetime.datetime(2018, 9, 7, 9, 10, 27, 439027)
```

## date 对象

date 对象是 datetime 对象的子类。date 对象的大部分方法与 datetime 对象一致。

如果处理日期，使用 datetime 的 date 模块比较方便。

```python
import time
import datetime
dt = datetime.date.today() # 获取当前 datetime 对象
ts = time.time()  # 返回当前时间的时间戳，精度为 7 的浮点数

dt
[输出：]datetime.date(2018, 9, 25)

# date 对象转换为 timestamp
dt.timestamp()
Out[]: 1667275784.287056

# date 对象转换为字符串
dt.isoformat()  # ISO 格式，'2018-09-25'
[输出：]'2018-09-25'
dt.strftime('%Y-%m-%d')
[输出：]'2018-09-25'

# 字符串转换为 date 对象
datetime.date.fromisoformat('2018-09-25')
[输出：]datetime.date(2018, 9, 25)

datetime.date.strptime('2018-09-25', '%Y-%m-%d %H:%M:%S.000')
[输出：]datetime.date(2018, 9, 25)

# timestamp 转换为 date 对象
datetime.date.fromtimestamp(ts)
[输出：]datetime.date(2018, 9, 25)

# ----------------------------------------------------------
# 快速创建日期
datetime.date(2018, 2, 5)
[输出：]datetime.date(2018, 2, 5)

# 获取年、月、日，星期几
dt.year
dt.month
dt.day
dt.weekday()  # 星期一是 0，星期二是 1。

# 替换一个日期的某个数值，参数是数字
# dt.replace(year, month, day)
dt.replace(month=2)
Out[]: datetime.date(2018, 2, 25)

# 生成时间元组
dt.timetuple()
Out[]: time.struct_time(tm_year=2022, tm_mon=11, tm_mday=1, tm_hour=12, tm_min=9, tm_sec=44, tm_wday=1, tm_yday=305, tm_isdst=-1)
```

## 时区

参考：<https://code-examples.net/zh-CN/q/20d153>

 [`zoneinfo`](https://docs.python.org/zh-cn/3/library/zoneinfo.html) --- IANA 时区支持

 tzinfo 类无法示例话，timezone 时区对象是 tzinfo 的子类，可以通过示例化 timezone 类来设置时区

### datetime 日期对象

```python
import time
import datetime

# 获取当前 datetime 对象（不包含时区信息）
datetime.datetime.now()

# 字符串创建 UTC 时间（包含时区信息）
datetime.datetime.fromisoformat('2021-12-26 20:09:14.000+00:00')

# 当前 UTC 时间（不包含时区信息）
datetime.datetime.utcnow()
Out[8]: datetime.datetime(2022, 11, 1, 8, 26, 24, 981620)

# 当前 UTC 时间（包含时区信息）
datetime.datetime.utcnow().replace(tzinfo=datetime.timezone.utc)
Out[13]: datetime.datetime(2022, 11, 1, 8, 30, 20, 801034, tzinfo=datetime.timezone.utc)
```

### timezone 时区信息对象

```python
# 时区名称元组
time.tzname
Out[5]: ('中国标准时间', '中国夏令时')
# 时区偏移值（秒），需要乘以 -1
-time.timezone
Out[6]: 28800

# 当前时区的 timedelta 偏移对象
datetime.timedelta(seconds=-time.timezone)
# 当前时区的 timezone 对象
datetime.timezone(datetime.timedelta(hours=-time.timezone/3600))
```

### 添加时区信息

```python
# 1：当前时间，带当前时区信息的 datetime 对象
datetime.datetime.now().replace(tzinfo=datetime.timezone(datetime.timedelta(seconds=-time.timezone)))
# 2：当前 UTC 时间，带 UTC 时区信息的 datetime 对象
datetime.datetime.utcnow().replace(tzinfo=None)

# 手动创建东八区时区对象
datetime.timezone(datetime.timedelta(hours=8))
# 当前时间绑定东八时区信息，不调整时间
datetime.datetime.utcnow().replace(tzinfo=datetime.timezone(datetime.timedelta(hours=8)))
```

### 时区转换

不同时区的日期转换，要确保 datetime 对象携带 timezone 时区信息

```python
# 当前时间（包含时区信息）
dt = datetime.datetime.now().replace(tzinfo=datetime.timezone(datetime.timedelta(seconds=-time.timezone)))
# 转换至 UTC 时间
dt_utc = dt.astimezone(tz=datetime.timezone.utc)
# 转换至本地时间时间，携带时区信息
dt_utc.astimezone(tz=None)
# 转换至东京时间，携带时区信息
dt_utc.astimezone(datetime.timezone(datetime.timedelta(hours=9)))

# 删除时区信息
dt_utc.replace(tzinfo=None)

# timezone 对象
dt.tzinfo
# 时区名称
dt.tzname()
# 相对 UTC 时区偏差
dt.utcoffset()
```

### zoneinfo 库

zoneinfo 库是一个时区数据库，包含了不同国家城市的时区数据。需要安装 `tzdata` 库。

### 技巧

```python
# 创建带时区信息的当前时间，最简单的方法是从 UTC 时间转换
datetime.datetime.utcnow().replace(tzinfo=datetime.timezone.utc).astimezone(tz=None)
```

### 总结

1. `datetime` 库默认创建的对象都不包含时区信息。
2. 如果要装换时区时间，需要先使用 `replace()` 方法强制设置时区，然后使用 `astimezone()` 方法转换到任意时区。
3. `replace(tzinfo=None)` 方法强制删除时区信息；`astimezone(None)` 方法则是转换为当地时间（保留时区信息）。
4. datetime 表示的时间需要时区信息才能确定一个特定的时间，否则只能视为本地时间。
5. 如果要存储 `datetime` 对象，最佳方法是将其转换为 timestamp 再存储，因为 timestamp 的值与时区完全无关。

## calendar 日历

```python
import calendar

calendar.monthrange(2018, 8)  # 返回两个整数。第一个是该月第一天的星期几（0 代表星期一），第二个是该月有几天。星期几是从 0（星期一）到 6（星期日）。
[输出：]
(2, 31)

# 快速创建日期序列
prng = (
    pd.date_range('2021-01', datetime.now(), freq='M')
    .map(lambda x: [x.year, x.month])
    .tolist()
)
prng.reverse()
[out]:
[[2022, 11], [2022, 10], [2022, 9], [2022, 8], [2022, 7], [2022, 6], [2022, 5], [2022, 4], [2022, 3], [2022, 2], [2022, 1]]
```

## arrow 库

标准库 time、datetime 都不好用，尤其是用过 pandas 之后。

> 生成上个月日期的二维数组

更高级、简单的话，使用 arrow 库。

```python
pip install setuptools
pip install arrow

import arrow

arrow.now()  # 当前本地时间
[输出：]<Arrow [2018-09-07T14:30:59.849982+08:00]>

arrow.utcnow() # 当前 utc 时间
[输出：]<Arrow [2018-09-07T06:31:32.363805+00:00]>

a = arrow.now()
a.datetime  # 获取 datetime 对象
[输出：]datetime.datetime(2018, 9, 7, 14, 33, 10, 459854, tzinfo=tzlocal())

a.timestamp
[输出：]1536301990

a.year  # 获取 arrow 对象的年、月、日、时、分、秒
a.month
a.day
a.hour
[输出：]
2018
9
7
14

a.date()  # 获取 arrow 对象的时间和日期
[输出：]datetime.date(2018, 9, 7)
a.time()
[输出：]datetime.time(14, 33, 10, 459854)

a.format()  # 默认格式输出
[输出：]'2018-09-07 14:33:10+08:00'
a.format("YYYY-MM-DD HH:mm:ss")  # 转换为指定时间格式
[输出：]'2018-09-07 14:33:10'

```
