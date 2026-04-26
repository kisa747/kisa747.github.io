# 说明文档

我的知识库，采用 `Zensical` 构建。

## 本地部署

```sh
# 安装依赖
uv sync -U

# 预览并打开预览地址
uv run zensical serve -o
```
## 语法检查

```sh
# 全局安装 markdownlint 工具
npm install markdownlint -g

# 检查 Markdown 语法错误
markdownlint docs/**/*.md
# 自动修复 Markdown 语法错误
markdownlint --fix docs/**/*.md
```

## 发布

GitHub Actions 配置参考：<https://zensical.org/docs/publish-your-site/>
