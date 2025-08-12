# 使用 mkdocs 创建在线文档

参考：[ReadtheDocs 文档](https://docs.readthedocs.io/en/stable/index.html)

`Sphinx` 作为老牌工具，网上很多的文档也都是采用的 Sphinx 创作，但新兴的`mkdocs`现在貌似更受欢迎，[ReadtheDocs](https://docs.readthedocs.io/en/stable/intro/getting-started-with-mkdocs.html) 官方也更推荐使用 `mkdocs` 创作，`mkdocs` 优点更多：

- 简单
- 实时预览，主题和插件定制方便
- 采用 Markdown 语法写作，语法简单

功能上，Sphinx 能实现的，mkdocs 通过插件基本也都能实现，两个都有漂亮的主题。

参考：[MkDocs 文档](https://www.mkdocs.org/user-guide/) 、 [Material for MkDocs 主题文档](https://squidfunk.github.io/mkdocs-material/getting-started/)

mkdocs 本身是为创建项目文档而生，而现在要让他专一的作为博客使用，需要一些特殊的设置。

## 创建项目

创建项目，并安装需求的库：

```sh
mkdir blog && cd blog
uv init -p 3.13
# 安装 mkdocs 库
uv add mkdocs
# 安装 material 主题，非常漂亮，而且支持暗黑模式。
uv add mkdocs-material
```

## 创建 mkdocs 项目

创建项目，在项目目录 `D:\blog` 下执行以下操作：

```sh
uv run mkdocs new .
```

目录结构：

```sh
D:\blog
│  .readthedocs.yaml      # ReadtheDocs 主配置文件。需要自己手动创建。
│  mkdocs.yml             # mkdocs 主配置文件。由 mkdocs 生成。
│
└─docs                    # 文档主目录
        index.md          # 文档主页显示内容
        requirements.txt  # ReadtheDocs 需要的依赖文件，必须。
```

运行以下命令，在浏览器中打开 <http://127.0.0.1:8000> 实时预览。

```sh
uv run mkdocs serve --watch-theme
```

Build the documentation site，生成静态文件至目录 `site` 。

```sh
uv run mkdocs build
```

## Material 主题

采用 Material for MkDocs 主题的网站：

<https://101.ustclug.org>

<https://hatch.pypa.io>

```yaml
# mkdocs.yml
# mkdocs 主配置文件
# https://squidfunk.github.io/mkdocs-material/getting-started/

site_name: "Kevin's Wiki"

# 手动设置导航栏内容
#nav:
#  - index.md
#  - Blog:
#    - blog/index.md

theme:
  name: material
  language: zh
  logo: assets/logo.png
  favicon: assets/favicon.png
  # 不使用 google font
  font: false

  features:
    # instant loading
    - navigation.instant
    # 导航栏
    - navigation.tabs
    # 固定导航栏
    - navigation.tabs.sticky
    # 搜索关键字高亮
    - search.highlight
    # 底部导航箭头
    - navigation.footer
    - navigation.top

  # 根据系统设置切换 light、dark 模式
  palette:

    # Palette toggle for automatic mode
    - media: "(prefers-color-scheme)"
      toggle:
        icon: material/brightness-auto
        name: Switch to light mode

    # Palette toggle for light mode
    - media: "(prefers-color-scheme: light)"
      scheme: default
      toggle:
        icon: material/brightness-7
        name: Switch to dark mode

    # Palette toggle for dark mode
    - media: "(prefers-color-scheme: dark)"
      scheme: slate
      toggle:
        icon: material/brightness-4
        name: Switch to system preference


plugins:
  - search
  - blog
  # 用于显示文档精确元信息的 MkDocs 插件，如创建时间、最后更新时间、作者、电子邮件等
  - document-dates:
      position: top            # 显示位置：top（标题后）bottom（文档末尾）
      type: date               # 时间类型：date datetime timeago，默认：date
      exclude:                 # 排除文件列表
        - temp.md              # 排除指定文件
        - drafts/*             # 排除 drafts 目录下所有文件，包括子目录
      locale: zh               # 本地化语言：en zh zh_TW es fr de ar ja ko ru，默认：en
      date_format: '%Y-%m-%d'  # 日期格式化字符串，例如：%Y年%m月%d日、%b %d, %Y
      time_format: '%H:%M:%S'  # 时间格式化字符串（仅在 type=datetime 时有效）
      show_author: false        # 是否显示作者信息，默认：true


extra:
  social:
    - icon: fontawesome/brands/github
      link: https://github.com/kisa747


# 加载额外的 css 样式
extra_css:
  - assets/extra.css


# 是否显示 Made with Material for MkDocs
#generator: false
# 版权声明
copyright: Copyright &copy; 2025 - 2025 kisa747
# 显示仓库地址
repo_url: https://github.com/kisa747/note
edit_uri: ""

markdown_extensions:
  # 注释标题支持
  - admonition
  - pymdownx.details
  - pymdownx.superfences
  #  - mkautodoc

  # 代码标题支持
  - pymdownx.highlight:
      anchor_linenums: true
  - pymdownx.inlinehilite
  - pymdownx.snippets

  # 表格支持
  - tables

  # 公式支持，参考：https://squidfunk.github.io/mkdocs-material/reference/math/
  - pymdownx.arithmatex:
      generic: true

  # 扩展语法支持
  - pymdownx.critic
  - pymdownx.caret
  - pymdownx.keys
  - pymdownx.mark
  - pymdownx.tilde

extra_javascript:
  # 公式支持，参考：https://squidfunk.github.io/mkdocs-material/reference/math/
  - assets/js/mathjax.js
  - https://unpkg.com/mathjax@3/es5/tex-mml-chtml.js
```

`docs/requirements.txt` 内容：

```ini
# docs/requirements.txt
mkdocs
mkdocs-material
mkdocstrings[python]
mkdocs-document-dates
```

好用的插件：[mkdocs-document-dates](https://github.com/jaywhj/mkdocs-document-dates)
