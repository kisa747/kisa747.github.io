## 安装配置

```sh
# 依赖 websocket-client, simplejson, lxml, bs4, tushare
 pip install tushare
```

## 配置 tushare

```python
import tushare as ts
# 设置 token
ts.set_token('your token here')
# 以上方法只需要在第一次或者 token 失效后调用，完成调取 tushare 数据凭证的设置，正常情况下不需要重复设置。也可以忽略此步骤，直接用 pro_api('your token') 完成初始化

# 如果上一步骤 ts.set_token('your token') 无效或不想保存 token 到本地，也可以在初始化接口里直接设置 token:
pro = ts.pro_api('your token')
```

## API

数据调取

以获取交易日历信息为例：

```python
df = pro.trade_cal(exchange='', start_date='20180901', end_date='20181001', fields='exchange,cal_date,is_open,pretrade_date', is_open='0')
```

或者

```python
df = pro.query('trade_cal', exchange='', start_date='20180901', end_date='20181001', fields='exchange,cal_date,is_open,pretrade_date', is_open='0')
```

调取结果：

```python
    exchange  cal_date    is_open pretrade_date
0          SSE       20180901        0      20180831
1          SSE       20180902        0      20180831
2          SSE       20180908        0      20180907
3          SSE       20180909        0      20180907
4          SSE       20180915        0      20180914
5          SSE       20180916        0      20180914
6          SSE       20180922        0      20180921
7          SSE       20180923        0      20180921
8          SSE       20180924        0      20180921
9          SSE       20180929        0      20180928
10         SSE       20180930        0      20180928
11         SSE       20181001        0      20180928
```
