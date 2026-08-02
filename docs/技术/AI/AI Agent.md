# AI Agent

## 手动安装 Hermes

Hermes 官方文档：<https://hermes-agent.nousresearch.com/docs>

配置环境

```sh
# Hermes 核心运行环境：uv, Python3.11, Node.js, ripgrep, ffmpeg, Git Bash

# 安装 uv
scoop install uv
# 安装 python3.11
uv python install 3.11

# 安装 nodejs-lt
scoop install nodejs-lts

# 安装 git
scoop isntall git-bash
scoop install git-lfs

# 安装 ripgrep
scoop install ripgrep
# 安装 ffmpeg
scoop install ffmpeg
```

安装

```sh
# 安装 Run in powershell
iex (irm https://hermes-agent.nousresearch.com/install.ps1)

# 验证安装
hermes doctor
# 自动修复错误
hermes doctor --fix
```

常用命令

```sh
# 临时切换模型
hermes - --provider Z.AI -m glm-4.7-flash

# 备份配置
hermes backup
```

创建快捷方式

```sh
# pwsh
C:\Users\kevin\scoop\apps\pwsh\current\pwsh.exe -NoExit -WorkingDirectory "E:\test\hermes" -c "hermes --tui"
```

安装 `Playwright CLI with SKILLS`，<https://github.com/microsoft/playwright-cli>

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
