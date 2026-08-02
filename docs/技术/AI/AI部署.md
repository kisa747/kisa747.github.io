# 本地部署 AI

## 手动安装 Hermes

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
# 克隆仓库并进入目录
git clone --recurse-submodules https://github.com/NousResearch/hermes-agent.git
cd hermes-agent

# 使用 Python 3.11 创建虚拟环境
uv venv --python 3.11

# 安装依赖
uv pip install -e ".[mcp]"

# 可选：浏览器工具和 WhatsApp 桥接需要它
npm install

# 让 hermes 成为全局命令
# 管理员权限运行
del %USERPROFILE%\.local\bin\hermes.exe
mklink %USERPROFILE%\.local\bin\hermes.exe "D:\App\Hermes\hermes-agent\.venv\Scripts\hermes.exe"

# 验证安装
hermes doctor
# 自动修复错误
hermes doctor --fix
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

## MimoCode

```sh
# 安装 MiMo Code
npm install -g @mimo-ai/cli
```
