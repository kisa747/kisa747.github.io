# Markdown 写作笔记

参考：[简明语法](https://www.zybuluo.com/mdeditor?url=https://www.zybuluo.com/static/editor/md-help.markdown) 、 [高阶语法](https://www.zybuluo.com/mdeditor?url=https://www.zybuluo.com/static/editor/md-help.markdown#cmd-markdown-%E9%AB%98%E9%98%B6%E8%AF%AD%E6%B3%95%E6%89%8B%E5%86%8C)

* Markdown 书写语法以 GitHub 的 [GitHub Flavored Markdown](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) 为准，尽量使用标准唯一的语法。比如：标题使用 `#` 而不是 `==`。
* GitHub 不支持 ==高亮==、行内公式
* 无序列表使用 `-` `*` `+` 都可以

## 常用命令

```sh
# 修复能修复的语法问题
markdownlint --fix **/*.md

# 需要在 Git Bash 下运行
# 检查文档
autocorrect --lint **/*.md
# 纠正目录下的所有文档
autocorrect --fix **/*.md
```

## markdownlint 工具

参考：[markdownlint 仓库](https://github.com/DavidAnson/markdownlint) | [markdownlint-cli 仓库](https://github.com/igorshubovych/markdownlint-cli) | [markdownlint-cli2 仓库](https://github.com/DavidAnson/markdownlint-cli2)

**缺点**：2 个工具都无法正常使用 `pre-commit`

* `pre-commit` 下 `markdownlint-cli2` 无法运行
* `pre-commit` 下 `markdownlint-cli` 乱码。

语法使用 `markdownlint` 工具检查，也有 VsCode 的 插件，非常方便，可以共用配置文件。插件的话直接在差价市场搜索安装即可。

```sh
# 安装命令行工具
npm i markdownlint-cli -g

# 检查语法问题
markdownlint docs/**/*.md
# 修复能修复的语法问题
markdownlint --fix docs/**/*.md
```

pre-commit 设置

```sh
uv tool install pre-commit
pre-commit autoupdate
pre-commit run --all-files
pre-commit install
```

配置文件：直接放在项目目录下即可，支持很多格式和文件名，官方有详细的 [默认配置示例配置文件](https://github.com/DavidAnson/markdownlint/blob/v0.32.1/schema/.markdownlint.yaml) [.markdownlint-cli2.yaml](https://github.com/DavidAnson/markdownlint-cli2/blob/main/test/markdownlint-cli2-yaml-example/.markdownlint-cli2.yaml)

我这里使用了 `.markdownlint.yml`，VsCode 插件也能读取这个配置。

```yaml
# markdownlint 配置文件
gitignore: true

MD013: false  # line-length - Line length
MD024: false  # no-duplicate-heading - Multiple headings with the same content
MD029: false  # ol-prefix - Ordered list item prefix
MD033:        # no-inline-html - Inline HTML
  allowed_elements: ["br","p"]
MD036: false  # no-emphasis-as-heading - Emphasis used instead of a heading
MD041: false  # first-line-heading/first-line-h1 - First line in a file should be a top-level heading
#MD056: false  # table-column-count - Table column count
```

## 文案校正

参考：<https://github.com/huacnlee/autocorrect>

🎯 AutoCorrect 的愿景是提供一套标准化的文案校正方案。以便于在各类场景（例如：撰写书籍、文档、内容发布、项目源代码...）里面应用，让使用者轻松实现标准化、专业化的文案输出 / 校正。

```sh
scoop install autocorrect

# 需要在 Git Bash 下运行
# Windows 下命令提示符和 PowerShell 下都乱码，使用 Git Bash 正常
# 检查文档
autocorrect --lint docs/**/*.md
# 纠正目录下的所有文档
autocorrect --fix docs/**/*.md
```

## 用 VSCode 优雅写 MarkDown

参考：[用 VsCode 优雅写 MarkDown](https://www.cnblogs.com/fanxiaozao/p/18578845)

## pymarkdownlnt 工具

参考：[官方文档](https://pymarkdown.readthedocs.io/en/latest/)  [配置文件](https://application-properties.readthedocs.io/en/latest/file-types/#configuration-file-types)

1. 扫描速度慢
2. 配置、行为与 `markdownlint` 不一致。
3. 可以使用 `pre-commit`

```sh
# 安装 pymarkdownlnt 命令行工具
uv tool install pymarkdownlnt
# 会有 pymarkdown、pymarkdownlnt 两个命令
# 扫描所有文档
pymarkdown scan docs/**/*.md
# 修复所有文档
pymarkdown fix docs/**/*.md
```

与 `markdownlint` 配置文件不一样，比较好的是可以使用 `pyproject.toml` 配置文件

```toml
[tool.pymarkdown]
extensions.front-matter.enabled = true
plugins.md007.enabled = false
plugins.md013.enabled = false
plugins.md014.enabled = false
plugins.md024.enabled = false
plugins.md029.allow_extended_start_values = true
plugins.md033.allowed_elements = "!--,![CDATA[,!DOCTYPE,br,p"
plugins.md036.enabled = false
plugins.md041.enabled = false
```
