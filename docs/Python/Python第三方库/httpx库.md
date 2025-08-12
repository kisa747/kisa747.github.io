# httpx 库

官方文档：(<https://www.python-httpx.org>)

新一代的网络请求库 Httpx。

- 和使用 requests 一样方便，requests 有的它都有。
- 加入 HTTP/2 的支持。
- 全类型注释
- 附带命令行工具

缺点：

- 不会自动重定向，需要手动指定 `follow_redirects=True` 参数。
- 默认不自动检测网页编码功能，需要手动指定网页编码，或使用第三方工具（charset_normalizer，requests 就依赖这个库）检测编码，或是不解码让 BeautifulSoup 等第三方库检测。

## 安装

```sh
pip install httpx

# 如果需要对 HTTP/2 支持，我们需要额外安装 httpx[http2]
pip install httpx[http2]

# 如果需要命令行工具，需要安装 httpx[cli]
pip install httpx[cli]
```

## 使用示例

```python
>>> import httpx

>>> headers = {'user-agent': 'my-app/0.0.1'}
>>> r = httpx.get('https://httpbin.org/get', headers=headers)
>>> r
<Response [200 OK]>
>>> r.text
'<!doctype html>\n<html>\n<head>\n<title>Example Domain</title>...'
>>> r.encoding
'UTF-8'
>>> r.json()
[{u'repository': {u'open_issues': 0, u'url': 'https://github.com/...' ...  }}]

>>> r = httpx.post('https://httpbin.org/post', data={'key': 'value'}, headers=headers)
```

cookie

```python
# 直接使用字典创建 cookie
>>> cookies = {"peanut": "butter"}
>>> r = httpx.get('https://httpbin.org/cookies', cookies=cookies)
>>> r.json()
{'cookies': {'peanut': 'butter'}}


# 使用 Cookies 对象创建 cookie
>>> cookies = httpx.Cookies()
>>> cookies.set('cookie_on_domain', 'hello, there!', domain='httpbin.org')
>>> cookies.set('cookie_off_domain', 'nope.', domain='example.org')
>>> r = httpx.get('http://httpbin.org/cookies', cookies=cookies)
>>> r.json()
{'cookies': {'cookie_on_domain': 'hello, there!'}}
```

会话模式

这个和 requests 有稍微不同，可以直接在在 h`ttpx.Client` 对象中提供 `headers` 等参数，更方便。

```python
>>> url = 'http://httpbin.org/headers'
>>> headers = {'user-agent': 'my-app/0.0.1'}
>>> with httpx.Client(headers=headers) as client:
...     r = client.get(url)
...
>>> r.json()['headers']['User-Agent']
'my-app/0.0.1'
```

## 编码

httpx 默认不处理重定向，需手动添加 `follow_redirects=True` 参数。

```python
import httpx

url = r'http://www.hao6v.com/dy/2018-08-21/MTGHMRJ.html'
r = httpx.get(url, follow_redirects=True)

r.encoding
'utf-8'

r.text[:400]
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\r\n<html xmlns="http://www.w3.org/1999/xhtml">\r\n<head>\r\n<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />\r\n<title>2018����ϲ�硶������������˼ơ�1080p.BD��Ӣ˫�֣�������أ�Ѹ�����أ�2022���µ�Ӱ��6v��Ӱ</title>\r\n<meta name="keywords" content="2018����ϲ�硶������������˼ơ�1080'
```

httpx 不自动检测网页编码，使用会话模式，才能设置网页编码模式。

方法 1：手动检测。

```python
import httpx

url = r'http://www.hao6v.com/dy/2018-08-21/MTGHMRJ.html'
headers = {'user-agent': 'my-app/0.0.1'}
with httpx.Client(headers=headers, follow_redirects=True, default_encoding='gb18030') as client:
    r = client.get(url)

r.encoding
Out[]: 'gb18030'

r.text[:400]
Out[]: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\r\n<html xmlns="http://www.w3.org/1999/xhtml">\r\n<head>\r\n<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />\r\n<title>2018 动作喜剧《瞒天过海：美人计》1080p.BD 中英双字，免费下载，迅雷下载，2022 最新电影，6v 电影</title>\r\n<meta name="keywords" content="2018 动作喜剧《瞒天过海：美人计》1080p.BD 中 英双字免费下载，2018 动作喜剧《瞒天过海：美'
```

方法 2：自动检测。

```python
import httpx
import charset_normalizer

url = r'http://www.hao6v.com/dy/2018-08-21/MTGHMRJ.html'
headers = {'user-agent': 'my-app/0.0.1'}
with httpx.Client(
    headers=headers,
    follow_redirects=True,
    default_encoding=lambda x: charset_normalizer.detect(x).get('encoding') or 'utf-8',
) as client:
    r = client.get(url)

r.encoding
Out[]: 'GB2312'

r.text[:400]
Out[]: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\r\n<html xmlns="http://www.w3.org/1999/xhtml">\r\n<head>\r\n<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />\r\n<title>2018 动作喜剧《瞒天过海：美人计》1080p.BD 中英双字，免费下载，迅雷下载，2022 最新电影，6v 电影</title>\r\n<meta name="keywords" content="2018 动作喜剧《瞒天过海：美人计》1080p.BD 中英 双字免费下载，2018 动作喜剧《瞒天过海：美'
```

## 使用 http2 协议

```python
with httpx.Client(http2=True) as client:
    ...
```

## 异步请求

默认就支持异步协程

```python
async with httpx.AsyncClient(http2=True) as client:
    response = await client.get(...)
```
