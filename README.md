# 说明

我的知识库

## 构建

```sh
# 安装依赖
uv sync -U
# 安装 markdownlint 语法检查工具
npm i markdownlint-cli -g

# 检查语法问题
markdownlint docs/**/*.md
# 修复语法问题
markdownlint --fix docs/**/*.md

# 预览（-o 打开预览地址）
uv run zensical serve -o

# 本地构建
zensical build
```
## 发布

GitHub Actions 配置参考：<https://zensical.org/docs/publish-your-site/>
