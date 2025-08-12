# BeautifulSoup 库

## 概述

官方文档：<https://www.crummy.com/software/BeautifulSoup/bs4/doc.zh/>

BeautifulSoup 的优点：

- 自动识别编码，准确率高。
- 可以使用不同的解析器。
- 语法简单。

类似的库还有：requests-html、xpath、

## 安装

```sh
pip install beautifulsoup4
```

 使用示例：

```python
from bs4 import BeautifulSoup

soup = BeautifulSoup(markup, 'html.parser', from_encoding='gbk')
```

如果不指定解析器，`BeautifulSoup` 会自动选择最合适的解析器来解析文档，但会有错误提示。

使用标准库中的 `html.parser` 已经很好用了，也可以使用更强大的 `lxml` 解析器。Beautiful Soup  会使用内置的 `UnicodeDammit` 库，自动检测当前文档编码并转换成 Unicode 编码。 `BeautifulSoup` 对象的 `.original_encoding` 属性记录了自动识别编码的结果：

```python
import requests
from bs4 import BeautifulSoup

r = requests.get(r'http://www.hao6v.com/dy/2018-08-21/MTGHMRJ.html')
print(r.encoding)
[输出：]ISO-8859-1

soup = BeautifulSoup(r.content, 'html.parser')
soup.original_encoding
[输出：]'windows-1252'
soup.

print(r.content[:400])
[输出：]
b'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\r\n<html xmlns="http://www.w3.org/1999/xhtml">\r\n<head>\r\n<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />\r\n<title>2018\xb6\xaf\xd7\xf7\xcf\xb2\xbe\xe7\xa1\xb6\xc2\xf7\xcc\xec\xb9\xfd\xba\xa3\xa3\xba\xc3\xc0\xc8\xcb\xbc\xc6\xa1\xb71080p.BD\xd6\xd0\xd3\xa2\xcb\xab\xd7\xd6\xa3\xac\xc3\xe2\xb7\xd1\xcf\xc2\xd4\xd8\xa3\xac\xd1\xb8\xc0\xd7\xcf\xc2\xd4\xd8\xa3\xac2018\xd7\xee\xd0\xc2\xb5\xe7\xd3\xb0\xa3\xac6v\xb5\xe7\xd3\xb0\xcf\xc2\xd4\xd8\xcd\xf8</title>\r\n<meta name="keywords" content="2018\xb6\xaf\xd7\xf7'

r.encoding='gb18030'
print(r.text[:400])
[输出：]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>2018动作喜剧《瞒天过海：美人计》1080p.BD中英双字，免费下载，迅雷下载，2018最新电影，6v电影下载网</title>
<meta name="keywords" content="2018动作喜剧《瞒天过海：美人计》1080p.BD中英双字下载，2018动作喜剧《瞒天过海：
```

很明显`BeautifulSoup` 、和 `requests`  都识别错了，毕竟两个都是靠 chardet 库自动检测的。如果知道页面的编码方式，还是提前指定比较好。

```python
soup = BeautifulSoup(markup, 'html.parser', from_encoding='gbk')
```

如果使用 requests 的 response 对象，那么尽量使用 response.content（字节码），让 Beautiful Soup 自动检测编码而不是使用 response.text。

## 使用

### 对象种类

Beautiful Soup 将复杂 HTML 文档转换成一个复杂的树形结构，每个节点都是 Python 对象，所有对象可以归纳为 4 种：`Tag` , `NavigableString` , `BeautifulSoup` , `Comment` 。

### 查找包含有特定子 Tag 的标签

默认没有这样的方法。可以先使用`find_all`找到需要找的 tag 列表，再使用列表生成式。

```python
soup = BeautifulSoup(response.content, 'html.parser')  #实例化 BeatifulSoup 对象
col2 = soup.find("div", "col2")  #查找 col2
box = col2.find("div", "box")  #查找 box
ul = box.find("ul", 'lt') #查找下面所有的列表
lis = ul.find_all('a')
li = [x for x in lis if x.find('font')]
```

### 遍历文档树

`find`  和 `find_all` 查找功能确实强大，但操作文档树最简单的方法就是告诉它你想获取的 tag 的 name.如果想获取 `<head>` 标签，只要用 `soup.head` ，如果找首页 body 标签 下的 div 标签

```python
a = soup.body.div
```

通过点取属性的方式只能获得当前名字的第一个 tag。

### 属性

tag 的 `.contents` 属性可以将 tag 的子节点以列表的方式输出：

通过 tag 的 `.children` 生成器，可以对 tag 的子节点进行循环：

`.contents` 和 `.children` 属性仅包含 tag 的直接子节点。例如，`<head>` 标签只有一个直接子节点 `<title>`

`.string`  如果 tag 只有一个 `NavigableString` 类型子节点，那么这个 tag 可以使用 `.string` 得到子节点

```python
li = col2.find("div", "box")
li.string
[输出：]None
>>> li.get_text("|", strip=True)
[输出：]
'今日推荐|2018 动作剧情《狄仁杰之四大天王》|2018 动作喜剧《瞒天过海：美人计》|2018 高分剧情《美国动物》1080p.B|2018 动作科幻《升级》1080p.BD 中英|2018 动作喜剧《死侍 2 未分级加长版|2018 动作惊悚《摩天营救》720p.HD|2018 高分科幻《复仇者联盟 3：无限|2018 动作科幻《侏罗纪世界 2》720p'
```

`get_text()` 方法，这个方法获取到 tag 中包含的所有文版内容包括子孙 tag 中的内容，并将结果作为 Unicode 字符串返回。第一个参数指定分隔符，第二个参数指定去除文本前后的空白。
