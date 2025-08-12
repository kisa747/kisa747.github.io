# ReadtheDocs 笔记

参考：[ReadtheDocs 文档](https://docs.readthedocs.io/en/stable/index.html)

Sphinx 作为老牌工具，网上大部分的文档也都是采用的 Sphinx 创作。

但 [ReadtheDocs](https://docs.readthedocs.io/en/stable/intro/getting-started-with-mkdocs.html) 官方更推荐使用 `mkdocs` 创作，mkdocs 优点更多：

- 简单
- 实时预览，主题和插件定制方便
- 采用 Markdown 语法写作，语法简单

功能上，Sphinx 能实现的，mkdocs 通过插件基本也都能实现，两个都有漂亮的主题。

## 使用 mkdocs

参考：[MkDocs 文档](https://www.mkdocs.org/user-guide/)

[Material for MkDocs 主题文档](https://squidfunk.github.io/mkdocs-material/getting-started/)

安装需求的库：

```sh
# 安装 mkdocs 库
pip install mkdocs
# 安装 material 主题，非常漂亮，而且支持暗黑模式。
pip install mkdocs-material
```

创建项目，在项目目录 `D:\Project` 下执行以下操作：

```sh
mkdocs new .
```

目录结构：

```sh
D:\Project
│  .readthedocs.yaml      # ReadtheDocs 主配置文件。需要自己手动创建。
│  mkdocs.yml             # mkdocs 主配置文件。由 mkdocs 生成。
│
└─docs                    # 文档主目录
        index.md          # 文档主页显示内容
        requirements.txt  # ReadtheDocs 需要的依赖文件，必须。
```

运行以下命令，在浏览器中打开 <http://127.0.0.1:8000> 实时预览。

```sh
mkdocs serve
mkdocs serve --watch-theme
```

Build the documentation site，生成静态文件至目录 `site` 。

```sh
mkdocs build
```

### Material for MkDocs 主题

采用 Material for MkDocs 主题的网站：

<https://101.ustclug.org>

<https://hatch.pypa.io>

### 自动生成 API 文档

#### autodocstring 插件

文档：<https://mkdocstrings.github.io>

```sh
pip install mkdocstrings[python]
```

修改 `mkdocs.yml` 文件：

```yaml
# mkdocs.yml
plugins:
  - mkdocstrings:
      handlers:
        python:
          paths: [ src ]  # search packages in the src folder
          options:
            show_root_heading: true
            docstring_style: "sphinx"
```

extra.css 添加一下内容：

```css
/* docs/assets/extra.css */

/* mkdocstrings 的 css 配置*/
/* Indentation. */
div.doc-contents:not(.first) {
  padding-left: 25px;
  border-left: .05rem solid var(--md-typeset-table-color);
}

/* Mark external links as such. */
a.autorefs-external::after {
  /* https://primer.style/octicons/arrow-up-right-24 */
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="rgb(0, 0, 0)" d="M18.25 15.5a.75.75 0 00.75-.75v-9a.75.75 0 00-.75-.75h-9a.75.75 0 000 1.5h7.19L6.22 16.72a.75.75 0 101.06 1.06L17.5 7.56v7.19c0 .414.336.75.75.75z"></path></svg>');
  content: ' ';

  display: inline-block;
  position: relative;
  top: 0.1em;
  margin-left: 0.2em;
  margin-right: 0.1em;

  height: 1em;
  width: 1em;
  border-radius: 100%;
  background-color: var(--md-typeset-a-color);
}
a.autorefs-external:hover::after {
  background-color: var(--md-accent-fg-color);
}
```

#### mkautodoc 插件

参考：<https://github.com/tomchristie/mkautodoc>

使用 mkautodoc 插件的文档：[httpx](https://www.python-httpx.org/) 。mkautodoc 官方的示例用的就是 httpx 文档页面。

```sh
pip install mkautodoc
```

启用插件：

```yaml
# mkdocs.yml

markdown_extensions:
  - mkautodoc
```

`extra.css` 内容：

```css
/* docs/assets/extra.css */

/* mkautodoc 的 css 配置*/
div.autodoc {
  font-family: consolas, monospace, "Roboto Mono";
}
div.autodoc-signature {
  font-size: 1.1em;
}
div.autodoc-docstring {
  padding-left: 20px;
  margin-bottom: 30px;
  margin-left: 30px;
  border-left: 5px solid rgba(230, 230, 230);
  font-family: consolas, monospace, "Roboto Mono";
}
div.autodoc-members {
  padding-left: 20px;
  margin-bottom: 15px;
  font-family: consolas, monospace, "Roboto Mono";
}
```

### MkDocs 语法

```yaml
# 二级导航
nav:
    - Home: 'index.md'
    - 'User Guide':
        - 'Writing your docs': 'writing-your-docs.md'
        - 'Styling your docs': 'styling-your-docs.md'
    - About:
        - 'License': 'license.md'
        - 'Release Notes': 'release-notes.md'
```

`docs/requirements.txt` 内容：

```ini
# docs/requirements.txt
mkdocs
mkdocs-material
```

## 使用 Sphinx

  参考：[Sphinx 文档](https://www.sphinx-doc.org/zh_CN/master/usage/quickstart.html) 、[myst-parser 文档](https://myst-parser.readthedocs.io/en/latest/) 、<https://pradyunsg.me/furo>

安装需求的库：

```sh
pip install sphinx
# furo 主题，非常漂亮
pip install furo
# markdown 支持
pip install myst-parser

# 自动预览工具
pip install sphinx-autobuild
```

创建项目

```sh
mkdir docs
cd docs
sphinx-quickstart

# 根据提示回答指定的问题
> Separate source and build directories (y/n) [n]: y
> Project name: sphinxdocs
> Author name(s): kevin
> Project release []: latest
> Project language [en]: zh_CN
```

项目结构：

```sh
E:\sphinxdocs
│  .readthedocs.yaml       # ReadtheDocs 主配置文件。需要自己手动创建。
│
└─docs
    │  make.cmd            # 生成静态网站
    │  Makefile
    │  requirements.txt    # 创建文档需要的依赖，发布至 ReadtheDocs 必须
    │  serve.cmd           # 预览文档
    │
    ├─build                # 使用 make.bat 生成静态网站的目录
    └─source               # 文档 md 源码目录
        │  api.md
        │  conf.py         # sphinx 主配置文件，必须放在 md 源码目录下
        │  index.md
        │  usage.md
        │  写作指南.md
        │
        ├─_static           # 文档图标等静态文件
        │      favicon.png
        │      logo.png
        │
        └─_templates        # 文档模板目录，一般空着就行
```

实时预览

```sh
# 实时预览，地址，可以把此命令写到 serve.cmd 文件里，方便使用。
sphinx-autobuild source build/html
```

构建

```sh
# 构建静态网站文件
make html
```

### furo 主题

采用 furo 主题的网站：

<https://pip.pypa.io>

<https://setuptools.pypa.io>

### 自动生成 API 文档

Sphinx 使用 `autodoc` 插件生成 API 文档，参考：

> 踩坑记，使用 `autodoc` 插件生成 API 文档，需要注意两点：
>
> <https://sphinx-rtd-tutorial.readthedocs.io/en/latest/sphinx-config.html#autodoc-configuration>
>
> 如果设置了 Separate source and build directories，需要修改 `.readthedocs.yaml`
>
> ```yaml
> # .readthedocs.yaml
> sphinx:
>    configuration: docs/source/conf.py
> ```
>
> 必须在 `conf.py` 中指定 Python 源码目录，`conf.py` 必须在`source` 目录下。
>
> ```python
> # docs/source/conf.py
> import sys
> from pathlib import Path
>
> sys.path.insert(0, str(Path(__file__).parents[2] / 'src'))
> ```

Python 的 `docstring` 书写可以参考：<https://sphinx-rtd-tutorial.readthedocs.io/en/latest/docstrings.html>

### 其它插件

复制按钮：[sphinx-copybutton](https://sphinx-copybutton.readthedocs.io/)

折叠代码：[sphinx-togglebutton](https://sphinx-togglebutton.readthedocs.io/)

代码标签：[sphinx-panels](https://sphinx-panels.readthedocs.io/en/latest/)
