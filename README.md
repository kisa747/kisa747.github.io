# 说明

我的知识库

GitHub Actions 配置参考：<https://squidfunk.github.io/mkdocs-material/publishing-your-site/>

## 快速构建本文档

```sh
# 安装依赖
uv sync -U
# 安装 markdownlint 语法检查工具
npm i markdownlint-cli -g

# 检查语法问题
markdownlint docs/**/*.md
# 修复语法问题
markdownlint --fix docs/**/*.md
```
