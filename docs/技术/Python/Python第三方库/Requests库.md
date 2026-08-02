# Requests 笔记

requests 不支持 http2 协议，如果要使用 http2 协议，可以使用 [httpx](https://www.python-httpx.org/) 库，用法与 requests 很相似。

## 安装

```sh
pip install requests
# 导入模块
import requests
```

## 技巧

### 防止连接错误

如果要循环爬取很多页面，难免会存在连接错误发生，因此需要设置一个重试方法。

```python
for i in range(1, 6):  # 从 1 循环到 5（range 函数右边的数字不包括）
    try:
        r = requests.post(url=url, headers=headers, data=post_form, timeout=30, verify=False)
        print(f'--> 获取数据成功！')
        break
    except requests.exceptions.RequestException:
        print(f'--> 连接错误，等待 {i * 10} 秒重试......')
        time.sleep(i * 10)
r_text = r.text if r.status_code == 200 else None
```

写一个装饰器，自动处理 requests 的重试问题。

```python
def retry(
    func=None,
    *,
    exceptions: Sequence[type[BaseException]] = (
        ConnectionError,
        requests.exceptions.RequestException,
    ),
    try_number: int = 10,
    freq: int = 20,
):
    """
    如果出现指定的异常，就会重试，默认重试 10 次。
    依次等待 20、40、60... 秒后重试。

    :param func: 传入的函数
    :param exceptions: 包含异常的元组。关键字参数。
    :param try_number: 最多尝试的次数。关键字参数。
    :param freq: 重试间隔时间（秒）。关键字参数。
    :return: 包装后的函数 func
    """
    if func is None:  # 保证使用 @decorator() 这种方法时不报错
        return functools.partial(
            retry, exceptions=exceptions, try_number=try_number, freq=freq
        )

    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        value = None
        for i in range(1, try_number + 1):
            try:
                value = func(*args, **kwargs)
            except exceptions as err:
                if i == try_number:  # 最后一次仍出错的话，抛出错误，终止程序。
                    raise
                retry_time = freq * i
                logging.warning(
                    f'--> {func.__name__!r}函数出现错误：『{err!r}』，{retry_time} 秒后重试...'
                )
                time.sleep(retry_time)
                continue
            else:
                break
        return value

    return wrapper
```

使用的地方使用 `retry` 装饰器即可。

```python
import requests
from bs4 import BeautifulSoup

@retry
def get_book_url():
    r = requests.get('https://httpbin.org')
    soup = BeautifulSoup(r.content, 'html.parser', from_encoding='utf-8')
    version = soup.find('pre', 'version').string
    return version
```

Requests 官方也支持最大连接次数，但是不好用，因为抓取网页总会出现各种的连接错误，一旦发生，requests 还是会直接报错。

```python
# https://cn.python-requests.org/zh_CN/latest/api.html#requests.adapters.HTTPAdapter
session.mount('http://', requests.adapters.HTTPAdapter(max_retries=4))
session.mount('https://', requests.adapters.HTTPAdapter(max_retries=4))
```

### HTTP 返回代码

| 数值 | 详细信息                                                     |
| :--: | :----------------------------------------------------------- |
| 200  | OK 请求成功。一般用于 GET 与 POST 请求                           |
| 400  | Bad Request 客户端请求的语法错误，服务器无法理解             |
| 404  | Not Found 服务器无法根据客户端的请求找到资源（网页）。通过此代码，网站设计人员可设置"您所请求的资源无法找到"的个性页面 |
| 500  | Internal Server Error 服务器内部错误，无法完成请求           |

### CA 证书

参考：<https://requests.readthedocs.io/zh_CN/latest/user/advanced.html#ca>

从 Requests 2.4.0 版之后，如果系统中装了 [certifi](http://certifi.io/) 包，Requests 会试图使用它里边的 证书。这样用户就可以在不修改代码的情况下更新他们的可信任证书。为了安全起见，建议经常更新 `certifi` ！

```sh
pip install -U certifi
```

### 禁用警告

参考：<https://www.jb51.net/article/165359.htm>

使用 Python3 requests 发送 HTTPS 请求，已经关闭认证（verify=False）情况下，控制台会输出以下错误：

> InsecureRequestWarning: Unverified HTTPS request is being made. Adding certificate verification is strongly advise

requests 库其实是基于 urllib 编写的，对 urllib 进行了封装，使得使用时候的体验好了很多，现在 urllib 已经出到了 3 版本，功能和性能自然是提升了不少。所以，requests 最新版本也是基于最新的 urllib3 进行封装。加上 `verify=False` 这个参数的意思是忽略 https 安全证书的验证，也就是不验证证书的可靠性，直接请求，这其实是不安全的，因为证书可以伪造，不验证的话就不能保证数据的真实性。

在 urllib3 时代，官方强制验证 https 的安全证书，如果没有通过是不能通过请求的，虽然添加忽略验证的参数，但是依然会给出醒目的 Warning，参考 [urllib3 官方文档](https://urllib3.readthedocs.io/en/stable/advanced-usage.html#tls-warnings) 。

```python
# urllib3 官方的方法
import urllib3
urllib3.disable_warnings()

# 必须添加 verify=False 参数，否则会报 requests.exceptions.SSLError 错误
r = requests.post(url=url, headers=headers, data=post_form, timeout=30, verify=False)

# 或是以下方法
requests.packages.urllib3.disable_warnings(requests.packages.urllib3.exceptions.InsecureRequestWarning)
```

## 使用方法

### 标准的请求

```python
import requests
r = requests.post(url=url, headers=headers, data=post_form, timeout=30, verify=False)
```

### 标准的会话方式

```python
import requests
headers = {
        'Host': 'x.cscec3b.com',
        'Referer': r'http://wx.cscec3b.com/hr/Account/Login?Path=/hr/',
        'User-Agent': r'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36'
         }
data_post = {
            'account': account,
            'gxtUserId':'',
            'pwd': pwd
            }
login_url = r'http://wx.cscec3b.com/hr/Account/Login'
with requests.Session() as session:  # 会话方式登录网站，保持连接、带 cookie 信息
    session.post(login_url, data=data_post, headers=headers, timeout=20)
    time.sleep(5)
    response = session.get(r'http://wx.cscec3b.com/hr/', timeout=20)
# response.text 自动自动解码来自服务器的内容，如果乱码，可以查看 response.content 检查编码。
# 确定编码后，再使用 response.encoding='gbk' 指定编码，后面访问就自动使用指定的编码。
print(f'response.text==== {response.text}')
print(f'response.status_code==== {response.status_code}')
```

使用 requests.Session() 方法，会话对象让你能够跨请求保持某些参数。它也会在同一个 Session 实例发出的所有请求之间保持 cookie，期间使用 urllib3 的 connection pooling 功能。所以如果你向同一主机发送多个请求，底层的 TCP 连接将会被重用，从而带来显著的性能提升。

会话常用的属性、方法：

```python
cookies = None
A CookieJar containing all currently outstanding cookies set on this session. By default it is a RequestsCookieJar, but may be any other cookielib.CookieJar compatible object.

headers = None
# 默认是个类似字典的序列，所以使用 update() 更新比较好。
A case-insensitive dictionary of headers to be sent on each Request sent from this Session.

proxies = None
Dictionary mapping protocol or protocol and host to the URL of the proxy (e.g. {'http': 'foo.bar:3128', 'http://host.name': 'foo.bar:4012'}) to be used on each Request.

get(url, **kwargs)  # Sends a GET request. Returns Response object.
参数:
url -- URL for the new Request object.
**kwargs -- Optional arguments that request takes.
返回类型: requests.Response

post(url, data=None, json=None, **kwargs)  #Sends a POST request. Returns Response object.
参数:
url -- URL for the new Request object.
data -- (optional) Dictionary, bytes, or file-like object to send in the body of the Request.
json -- (optional) json to send in the body of the Request.
**kwargs -- Optional arguments that request takes.
返回类型:requests.Response
```

会话也可用来为请求方法提供缺省数据。这是通过为会话对象的属性提供数据来实现的：

```python
s = requests.Session()
s.auth = ('user', 'pass')
s.headers.update({'x-test': 'true'})

# both 'x-test' and 'x-test2' are sent
s.get('http://httpbin.org/headers', headers={'x-test2': 'true'})
```

任何你传递给请求方法的字典都会与已设置会话层数据合并。方法层的参数覆盖会话的参数。

不过需要注意，就算使用了会话，方法级别的参数也不会被跨请求保持。下面的例子只会和第一个请求发送 cookie，而非第二个：

```python
s = requests.Session()

r = s.get('http://httpbin.org/cookies', cookies={'from-my': 'browser'})
print(r.text)
# '{"cookies": {"from-my": "browser"}}'

r = s.get('http://httpbin.org/cookies')
print(r.text)
# '{"cookies": {}}'

# requests 默认的 headers
{'User-Agent': 'python-requests/2.19.1',
'Accept-Encoding': 'gzip, deflate',
'Accept': '*/*',
'Connection': 'keep-alive'}
```

要想发送你的 cookies 到服务器，可以使用 `cookies` 参数：

```python
url = 'http://httpbin.org/cookies'
cookies = dict(cookies_are='working')
r = requests.get(url, cookies=cookies)
r.text

输出结果：
'{"cookies": {"cookies_are": "working"}}'
```

## 高阶用法

### 会话 cookie

推荐使用会话 cookie，会话也可以使用 cookie，默认 cookie 是一个 RequestsCookieJar 对象。如果你要手动为会话添加 cookie，就使用 [Cookie utility 函数](http://docs.python-requests.org/zh_CN/latest/api.html#api-cookies) 来操纵 [`Session.cookies`](http://docs.python-requests.org/zh_CN/latest/api.html#requests.Session.cookies)。

```python
headers = {
        'Host': 'x.cscec3b.com',
        'Referer': r'http://wx.cscec3b.com/hr/Account/Login?Path=/hr/',
        'User-Agent': r'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36'
         }
cookie_dict = {
    'ASP.NET_SessionId' : '1ese2k0iwfvalju4sd412jrb'
    }
# requests.utils.cookiejar_from_dict(cookie_dict, cookiejar=None, *overwrite=True)
cookiejar = requests.utils.cookiejar_from_dict(cookie_dict)  # 实例化一个 RequestsCookieJar 对象

with requests.Session() as session:  # 会话方式登录网站，保持连接、带 cookie 信息
    session.cookies = cookiejar
    session.headers.update(headers)
    response = session.get(r'http://wx.cscec3b.com/hr/')
print(f'cookies== {session.cookies}')  # 通过 session.cookies 访问 cookie 对象
```

查看 requests 的官方文档，使用 Session 会话对象，更加方便、高效。

会话也可用来为请求方法提供缺省数据。这是通过为会话对象的属性提供数据来实现的，比如：`session.headers.update(headers)`。

任何你传递给请求方法的字典都会与已设置会话层数据合并。方法层的参数覆盖会话的参数。不过需要注意，就算使用了会话，方法级别的参数也不会被跨请求保持。下面的例子只会和第一个请求发送 cookie，而非第二个：

```python
s = requests.Session()

r = s.get('http://httpbin.org/cookies', cookies={'from-my': 'browser'})
print(r.text)
# '{"cookies": {"from-my": "browser"}}'

r = s.get('http://httpbin.org/cookies')
print(r.text)
# '{"cookies": {}}'
```

如果你要手动为会话添加 cookie，就使用 [Cookie utility 函数](http://docs.python-requests.org/zh_CN/latest/api.html#api-cookies) 来操纵 [`Session.cookies`](http://docs.python-requests.org/zh_CN/latest/api.html#requests.Session.cookies)。

### response 对象

任何时候进行了类似 requests.get() 的调用，你都在做两件主要的事情。其一，你在构建一个 Request 对象，该对象将被发送到某个服务器请求或查询一些资源。其二，一旦 `requests` 得到一个从服务器返回的响应就会产生一个 `Response` 对象。该响应对象包含服务器返回的所有信息，也包含你原来创建的 `Request` 对象。如下是一个简单的请求，从 Wikipedia 的服务器得到一些非常重要的信息：

```python
>>> response
<Response [200]>
>>> type(response)
<class 'requests.models.Response'>
>>> dir(response)
['__attrs__', '__bool__', '__class__', '__delattr__', '__dict__', '__dir__', '__doc__', '__enter__', '__eq__', '__exit__', '__format__', '__ge__', '__getattribute__', '__getstate__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__iter__', '__le__', '__lt__', '__module__', '__ne__', '__new__', '__nonzero__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__setstate__', '__sizeof__', '__str__', '__subclasshook__', '__weakref__', '_content', '_content_consumed', '_next', 'apparent_encoding', 'close', 'connection', 'content', 'cookies', 'elapsed', 'encoding', 'headers', 'history', 'is_permanent_redirect', 'is_redirect', 'iter_content', 'iter_lines', 'json', 'links', 'next', 'ok', 'raise_for_status', 'raw', 'reason', 'request', 'status_code', 'text', 'url']
```

常用的属性：

```python
response.text # 字符串，响应的内容。Requests 会使用其推测的文本编码。也可以指定一个编码
response.encoding = GBK'  # 指定编码为 GBK，后面访问它就会以 GBK 编码
response.content  # 字节码，二进制响应内容。Requests 会自动为你解码 gzip 和 deflate 传输编码的响应数据。
>>>输出：b'[{"repository":{"open_issues":0,"url":"https://github.com/...
response.raw  #原始响应内容
>>>输出：'\x1f\x8b\x08\x00\x00\x00\x00\x00\x00\x03'
response.status_code  #响应状态码，访问成功，返回 200，不存在返回 404
response.headers  #响应头。以字典形式展示，大小写不敏感
response.cookies  #响应的 cookie。Cookie 的返回对象为 RequestsCookieJar，它的行为和字典类似，但接口更为完整，适合跨域名跨路径使用。你还可以把 Cookie Jar 传到 Requests 中。
response.history  #是一个 Response 对象的列表，为了完成请求而创建了这些对象。这个对象列表按照从最老到最近的请求进行排序。
>>>输出：[<Response [302]>]
```

响应内容如果是 json，可已转换为 json 格式，方便访问：

```python
r_json = response.json()  # 处理 JSON 数据，将响应内容转换为 json 格式
print(r_json[])  #如果 json 内容是字典，就可以通过 key 访问。
输出：'list'
```

### 超时

```python
>>> requests.get('http://github.com', timeout=0.001)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
requests.exceptions.Timeout: HTTPConnectionPool(host='github.com', port=80): Request timed out. (timeout=0.001)
```

timeout 参数告诉 requests 在经过以 `timeout` 参数设定的秒数时间之后停止等待响应。基本上所有的生产代码都应该使用这一参数。如果不使用，你的程序可能会永远失去响应

注意

`timeout` 仅对连接过程有效，与响应体的下载无关。 `timeout` 并不是整个下载响应的时间限制，而是如果服务器在 `timeout` 秒内没有应答，将会引发一个异常（更精确地说，是在`timeout` 秒内没有从基础套接字上接收到任何字节的数据时）If no timeout is specified explicitly, requests do not time out.

### 编码为 JSON 的 post 类型

如果网站接受编码为 JSON 的 POST/PATCH 数据，可以使用 `json` 参数直接传递，然后它就会被自动编码。

```python
with requests.Session() as session:  # 会话方式登录网站，保持连接、带 cookie 信息
    session.post(login_url, json=data_post, headers=headers)
    response = session.get(r'http://wx.cscec3b.com/hr/')
```

### 传递 URL 参数

你也许经常想为 URL 的查询字符串 (query string) 传递某种数据。如果你是手工构建 URL，那么数据会以键/值对的形式置于 URL 中，跟在一个问号的后面。例如， `httpbin.org/get?key=val`。Requests 允许你使用 `params` 关键字参数，以一个字符串字典来提供这些参数。举例来说，如果你想传递 `key1=value1` 和 `key2=value2` 到 `httpbin.org/get` ，那么你可以使用如下代码：

```python
>>> payload = {'key1': 'value1', 'key2': 'value2'}
>>> r = requests.get("http://httpbin.org/get", params=payload)
```

通过打印输出该 URL，你能看到 URL 已被正确编码：

```python
>>> print(r.url)
http://httpbin.org/get?key2=value2&key1=value1
```

注意字典里值为 `None` 的键都不会被添加到 URL 的查询字符串里。

你还可以将一个列表作为值传入：

```python
payload = {'key1': 'value1', 'key2': ['value2', 'value3']}
r = requests.get('http://httpbin.org/get', params=payload)
>>> print(r.url)
http://httpbin.org/get?key1=value1&key2=value2&key2=value3
```

### headers

headers 有哪些重要信息，当不指定任何 deaders 信息时：

```python
import requests
r = requests.get("http://www.hao6v.com/")
head = r.headers
print(head)
[输出：]
{
    'Content-Type': 'text/html',
    'Content-Location': 'http://www.hao6v.com/index.html',
    'Last-Modified': 'Fri, 31 Aug 2018 11:00:40 GMT',
    'ETag': '"9160ffda1941d41:5a1"',
    'Server': 'Microsoft-IIS/6.0',
    'Date': 'Fri, 31 Aug 2018 11:01:01 GMT',
    'X-Via': '1.1 CTG045 (random:76248 Fikker/Webcache/3.7.6)',
    'Content-Length': '9512',
    'Content-Encoding': 'gzip',
    'Vary': 'Accept-Encoding',
    'Connection': 'keep-alive'
}
```

查看 chrome 浏览器的请求 headers

```python
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.9
Cache-Control: max-age=0
Connection: keep-alive
Cookie: UM_distinctid=163287f3d1013b-036d17406f23ae-f373567-144600-163287f3d116e6; CNZZDATA1260800068=968312283-1525388288-%7C1525388288; ecmsecookieinforecord=%2C32-31713%2C
DNT: 1
Host: www.hao6v.com
If-Modified-Since: Fri, 31 Aug 2018 11:00:40 GMT
If-None-Match: "9160ffda1941d41:5a1"
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36
```

### 装饰器修改默认 headers

1、最简单粗暴的方法就是修改源代码，给默认 headers 方法加个装饰器。以后无论怎么调用 request，默认的 headers 都是修改后的了。而且还可以做成模块，供其它程序调用。

```python
def modify_headers(func):
    def inner():
        headers = {
            'User-Agent': r'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
            'Accept-Encoding': 'gzip, deflate, br',
            'Accept-Language': 'zh-CN,zh;q=0.9',
            'Cache-Control': 'max-age=0',
            'Connection': 'keep-alive',
            'Upgrade-Insecure-Requests': '1',
            'DNT': '1',
            }
        new = CaseInsensitiveDict(headers)
        return new
    return inner

@modify_headers
def default_headers():
    """
    :rtype: requests.structures.CaseInsensitiveDict
    """
    return CaseInsensitiveDict({
        'User-Agent': default_user_agent(),
        'Accept-Encoding': ', '.join(('gzip', 'deflate')),
        'Accept': '*/*',
        'Connection': 'keep-alive',
    })

```

第二个方法，不修改源码。在自己的程序里实现。优点：不用动源代码，即使 requests 升级，也不用担心。

```python
def decorator(cls):
    class Wrapper(cls):
        def __init__(self):
            # super() 函数用来调用父类的方法，与下面用法相同
            #super(Wrapper, self).__init__()
            super().__init__()
            head = {
                'User-Agent': r'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36',
                'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
                'Accept-Encoding': 'gzip, deflate, br',
                'Accept-Language': 'zh-CN,zh;q=0.9',
                'Cache-Control': 'max-age=0',
                'Upgrade-Insecure-Requests': '1',
                'DNT': '1',
                'Connection': 'keep-alive'
            }
            self.headers.update(head)
    return Wrapper

requests.Session = decorator(requests.Session)

s = requests.Session()
r = s.get(r"https://www.cnblogs.com", timeout=20)  #先打开首页，准备登录

print(s)
[输出：]
<__main__.decorator.<locals>.Wrapper object at 0x000001CD40F4E278>
print(r)
<Response [200]>
```

### 代理

如果需要使用代理，你可以通过为任意请求方法提供 `proxies` 参数来配置单个请求：

proxies 默认就是一个字典。

```python
import requests
proxies = {
      "http": "http://10.10.1.10:3128",
  "https": "http://10.10.1.10:1080",
}
requests.get("http://example.org", proxies=proxies)

#如果代理需要密码
proxies = {'http':'http://{username}:{password}@proxy.test.com:8080','https':'http://{username}:{password}@proxy.test.com:8080'}

# 会话也可是设置代理
proxies = None
# Dictionary mapping protocol or protocol and host to the URL of the proxy (e.g. {'http': 'foo.bar:3128', 'http://host.name': 'foo.bar:4012'}) to be used on each Request.

proxy = {'http': 'http://118.190.95.35:9001'}
with requests.Session() as session:
    session.proxies.update(proxy)
    session.proxies = proxy
# 由于默认是字典，直接赋值和用 update 方法效果一样，会话设置代理后，整个会话都可以使用。
```

### 重定向

默认情况下，除了 HEAD, Requests 会自动处理所有重定向。

可以使用响应对象的 `history` 方法来追踪重定向。

[`Response.history`](http://docs.python-requests.org/zh_CN/latest/api.html#requests.Response.history) 是一个 [`Response`](http://docs.python-requests.org/zh_CN/latest/api.html#requests.Response) 对象的列表，为了完成请求而创建了这些对象。这个对象列表按照从最老到最近的请求进行排序。

Response.url  # 返回重定向最终的链接。

### 网址解析

```python
from urllib.parse import urlparse, urlsplit, parse_qs

a = r'https://account.xiaomi.com/pass/serviceLogin?mini=false&callback=https%3A%2F%2Fd.miwifi.com%2Fsts%3Ffollowup%3Dhttps%253A%252F%252Fd.miwifi.com%252Fd2r%26sign%3DGWowV6b9dEeS30xoIY2%252F16UNLkI%253D&sid=xiaoqiang_d2r'
b= urlparse(a)
c = b.query
d = parse_qs(c)  # 将参数解析为字典。
print(f'b : {b}')
print(f'c : {c}')
print(f'd : {d}')
[输出：]
b : ParseResult(scheme='https', netloc='account.xiaomi.com', path='/pass/serviceLogin', params='', query='mini=false&callback=https%3A%2F%2Fd.miwifi.com%2Fsts%3Ffollowup%3Dhttps%253A%252F%252Fd.miwifi.com%252Fd2r%26sign%3DGWowV6b9dEeS30xoIY2%252F16UNLkI%253D&sid=xiaoqiang_d2r', fragment='')
c : mini=false&callback=https%3A%2F%2Fd.miwifi.com%2Fsts%3Ffollowup%3Dhttps%253A%252F%252Fd.miwifi.com%252Fd2r%26sign%3DGWowV6b9dEeS30xoIY2%252F16UNLkI%253D&sid=xiaoqiang_d2r
d : {'mini': ['false'], 'callback': ['https://d.miwifi.com/sts?followup=https%3A%2F%2Fd.miwifi.com%2Fd2r&sign=GWowV6b9dEeS30xoIY2%2F16UNLkI%3D'], 'sid': ['xiaoqiang_d2r']}

```

第三方库 furl 更简单

<https://github.com/gruns/furl>

```python
from furl import furl

f = furl(r'https://account.xiaomi.com/pass/serviceLogin?mini=false&callback=https%3A%2F%2Fd.miwifi.com%2Fsts%3Ffollowup%3Dhttps%253A%252F%252Fd.miwifi.com%252Fd2r%26sign%3DGWowV6b9dEeS30xoIY2%252F16UNLkI%253D&sid=xiaoqiang_d2r')
f.args
[输出：]
{'mini': ['false'], 'callback': ['https://d.miwifi.com/sts?followup=https%3A%2F%2Fd.miwifi.com%2Fd2r&sign=GWowV6b9dEeS30xoIY2%2F16UNLkI%3D'], 'sid': ['xiaoqiang_d2r']}
```
