# 本地部署 AI

## 安装 Ollama

```sh
scoop install ollama
```

  安装模型

```sh
# qwen3.5 - 阿里出品，中文优秀，推荐首选
ollama pull qwen3.5:0.8b

# Qwen3 默认 9B - 更强大，需要更多内存（16GB+）
ollama pull qwen3.5


# bge-m3 模型，嵌入模型
ollama pull bge-m3
```

## 手动安装 Hermes

```sh
# 配置环境
# 安装 nodejs-lt
scoop install nodejs-lts
# 安装 ripgrep
scoop install ripgrep
# 安装 git
scoop isntall git-bash
scoop install git-lfs
# 安装 uv
scoop install uv
# 安装 python3.11
uv python install 3.11
```

安装

```sh
uv init -p 3.11

uv add hermes-agent[mcp]
```

进入 `.venv\Scripts` ，运行命令提示符

```sh
# Hermes 核心运行环境：uv, Python 3.11, Node.js, ripgrep, ffmpeg, Git Bash
# 安装辅助能力：Node.js、浏览器、ripgrep、ffmpeg 等
hermes postinstall
```

常用命令

```sh
# 临时切换模型
hermes --provider Z.AI -m glm-4.7-flash
```

创建快捷方式

```sh
# pwsh
C:\Users\kevin\scoop\apps\pwsh\current\pwsh.exe -NoExit -WorkingDirectory "E:\test\hermes" -c "D:\Home\Git-Repo\Hermes\.venv\Scripts\hermes.exe"

# git bash
C:\Users\kevin\scoop\apps\git\current\git-bash.exe -c "/D/Home/Git-Repo/Hermes/.venv/Scripts/hermes;bash"
```

安装 Playwright CLI with SKILLS

<https://github.com/microsoft/playwright-cli>

```sh
npm install -g @playwright/cli@latest
playwright-cli --help

playwright-cli install --skills

playwright-cli install-browser chromium
```

## 安装 opencode

```sh
# scoop 安装
scoop install opencode-ai

# npm 安装
npm i -g opencode-ai
# 卸载
npm uninstall -g opencode-ai
```

## MimoCode

```sh
# 安装 MiMo Code
npm install -g @mimo-ai/cli
```

## 提示词

>帮我规划一个操作流程：将 PDF 文档 转换为 markdown 格式文档。使用 <https://mineru.net/apiManage/docs> 提供的 API 接口，如果没有 token，向我询问；检查文件的大小、页数，必要时拆分；最终的 markdown 文件需要包含图片；移除“由 MinerU API 自动解析生成（含图片）”、“<!-- ===== 第 1-200 页 ===== -->”等这些不是原文档的内容；删除临时文件。
>
>
>
>帮我规划一个操作流程：移除 PDF 水印。使用 python 的 playwright 工具 打开 <https://www.dpdf.com/zh/remove-watermark> 在线工具，上传 pdf 文件，移除水印后，保存 pdf 文件
>
>
>
>帮我规划一个操作流程：为 PDF 文件添加目录
>
>
>
>帮我写一个 python 脚本程序：将 PDF 文档 转换为 markdown 格式文档。使用 <https://mineru.net/apiManage/docs> 提供的 API 接口，token 从指定的配置文件中读取；检查文件的大小、页数，必要时拆分；最终的 markdown 文件需要包含图片；移除“由 MinerU API 自动解析生成（含图片）”、“<!-- ===== 第 1-200 页 ===== -->”等这些不是原文档的内容；检查图片是否被 markdown 文件引用，如果没有引用，删除图片；如果 images 目录下为空，则删除 images 文件夹；删除临时文件。python 语言使用 python3.14 推荐的语法及内置库；使用 ruff 检查无报错。
