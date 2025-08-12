# Pelican 笔记

Pelican：一个 Python 静态网站生成器

官方文档：<http://docs.getpelican.com/en/stable/>

官方主题：<https://github.com/getpelican/pelican-themes>

官方插件：<https://github.com/getpelican/pelican-plugins>

参考：

<https://www.linuxzen.com/>

<http://wklken.me/posts.html>

## 安装 Pelican

安装好 Python3，然后安装 Pelican。

```sh
pip install pelican markdown
```

创建博客主目录：

```sh
mkdir Blog
cd Blog

# 此命令会提问很多问题，逐个回答即可。
pelican-quickstart
```

回答完问题后，生成以下目录结构

```sh
kisa747.com/
├── content/
│   └── (pages)
├── output/
├── tasks.py
├── Makefile
├── pelicanconf.py       # Main settings file
└── publishconf.py       # Settings to use when ready to publish
```

之后的操作默认都是在 `kisa747.com` 目录下操作。

在 output 目录下创建 CNAME 文件

```bash
echo kisa747.com > output\CNAME
```

然后在 `content` 目录创建文章 *.md 格式如下：

```markdown
Title: Hello World (标题)
Date: 2010-12-03 10:20 (创建日期)
Modified: 2010-12-05 19:30 (修改日期)
Category: Python (分类，只能使用单一分类)
Tags: pelican, publishing (标签，多个以 , 分隔)
Slug: my-super-post (slug，将用于 url，请与文件名保持一致)
Authors: (作者，多个以 , 分隔)
Summary: Short version for index and feeds（摘要）

这是正文。
```

写好文章后，生成站点：

```sh
# 每次新添加文章，修改文章后，都需先运行此命令
pelican content
```

预览博客：

```sh
pelican --listen
```

然后在浏览器中打开 <http://localhost:8000/> ，预览博客。

## 发布博客

至此，output 目录下已经是完整的静态博客了。将 output 目录 push 到 GitHub 就行了

```sh
cd output
git init
git add .
git commit -m "first commit"
git remote add origin git@github.com:kisa747/kisa747.github.io.git
:: 由于之前此repo已经有内容了，所以加了 -f 参数，强制推送。
git push -f -u origin master
cd ..
```

## 主题

<https://github.com/getpelican/pelican-themes>

```sh
# clone 下所有的主题，大概 70 多 M
git clone --recursive git@github.com:getpelican/pelican-themes.git ./pelican-themes
# 安装主题，-v（--verbose）参数显示详细信息
pelican-themes -i pelican-themes\tuxlite_tbs -v
# 修改主题后，我们要更新主题才会生效
pelican-themes -U pelican-themes\tuxlite_tbs -v

# 卸载主题
pelican-themes -r tuxlite_tbs -v
```

pelicanconf.py 配置文件中添加：

```python
THEME = 'tuxlite_tbs'
```

不安装主题也行。直接在 pelicanconf.py 中指定主题位置即可。

```python
THEME = r'pelican-themes\tuxlite_tbs'
```

## 静态文件

参考：<https://www.cnblogs.com/imhurley/p/6137272.html>

<https://docs.getpelican.com/en/stable/settings.html#using-pagination-patterns>

FILES_TO_COPY 参数已经废弃。

```python
# 如果我们定义静态的文件，该如何将它在每次生成的时候拷贝到 output 目录呢？
# 我们以 robots.txt 为例，在我们的 content/extra 下面我们放了一个定义好的 robots.txt 文件。
# 在 pelicanconf.py 更改或添加 STATIC_PATHS 项
STATIC_PATHS = [
    'static/robots.txt',
    'static/favicon.ico',
    'static/CNAME',
    ]

EXTRA_PATH_METADATA = {
    'static/robots.txt': {'path': 'robots.txt'},
    'static/favicon.ico': {'path': 'favicon.ico'},
    'static/CNAME': {'path': 'CNAME'},
    }
# 说是直接使用下面的方法，不过不放到文件夹里。
# STATIC_PATHS = [
    # 'robots.txt',
    # 'favicon.ico',
    # 'CNAME',
    # ]
```

## 博客迁移

参考：<https://github.com/dreikanter/wp2md>

<https://github.com/ytechie/wordpress-to-markdown>

配置好 Node.js

### Usage

Clone the repo and go into its directory to install dependencies:

```sh
git clone https://github.com/ytechie/wordpress-to-markdown.git
cd wordpress-to-markdown/
npm install xml2js to-markdown
```

Copy your Wordpress content export into the folder as `export.xml`. Then run the script

```sh
node convert.js
```
