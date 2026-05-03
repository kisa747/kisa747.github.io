# 说明文档

![GitHub Pages](https://github.com/kisa747/kisa747.github.io/actions/workflows/docs.yml/badge.svg)  ![Documentation Status](https://readthedocs.org/projects/kisa747/badge/?version=latest)

我的知识库，采用 `Zensical` 构建。

## 本地部署

```sh
# 安装依赖
uv sync -U

# 预览并在浏览器中打开
uv run zensical serve -o
```
本地预览地址：<http://127.0.0.1:8000>

## Markdown 语法检查

```sh
# 全局安装 markdownlint 工具
npm install markdownlint -g

# 检查 Markdown 语法错误
markdownlint docs/**/*.md

# 自动修复 Markdown 语法错误
markdownlint --fix docs/**/*.md
```

## 中英文混排

主要是用于中英文、数字混排，自动添加空格。

```sh
# 安装 autocorrect
scoop install autocorrect

# 排版检查
autocorrect --lint kisa747.github.io/docs/

# 自动根据规则修正
autocorrect --fix kisa747.github.io/docs/
```

## 发布

GitHub Actions 配置参考：<https://zensical.org/docs/publish-your-site/>
