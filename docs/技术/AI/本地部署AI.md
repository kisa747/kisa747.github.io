# 本地部署 AI

## 安装 Ollama

```sh
scoop install ollama
```

  安装模型

```sh
# qwen3.5 - 阿里出品，中文优秀，推荐首选
ollama pull qwen3.5:0.8b

# Qwen3 默认9B - 更强大，需要更多内存（16GB+）
ollama pull qwen3.5


# bge-m3 模型，嵌入模型
ollama pull bge-m3
```

hermes 使用

hermes 顶层命令

| 命令                      | 用途                                                         |
| ------------------------- | ------------------------------------------------------------ |
| `hermes chat`             | 与 Agent术语解释**Agent**具备自主性、能调用工具以完成目标的 AI 程序。Agent 是一种基于大语言模型的智能程序，能够感知环境、做出决策、调用工具执行操作，并自主推进任务——它不仅能读写文件、执行命令，还能操作浏览器、调用 API，与数字世界进行多轮交互。 进行交互式或单次对话。 |
| `hermes model`            | 交互式选择默认提供者和模型。                                 |
| `hermes gateway`          | 运行或管理消息网关服务。                                     |
| `hermes setup`            | 交互式设置向导，用于全部或部分配置。                         |
| `hermes whatsapp`         | 配置并配对 WhatsApp 桥接。                                   |
| `hermes auth`             | 管理凭据 — 添加、列出、删除、重置、设置策略。处理 Codex/Nous/Anthropic 的 OAuth术语解释**OAuth**开放授权框架，允许第三方应用在无需获取用户密码的前提下访问用户资源。OAuth 是一种授权框架（而非认证机制），让用户通过浏览器登录并授权，将访问权限委托给应用，应用由此获得有效期有限的访问令牌。相比直接粘贴长期 API Key，OAuth 更安全、更标准化。 流程。 |
| `hermes login` / `logout` | **已弃用** — 请改用 `hermes auth`。                          |
| `hermes status`           | 显示 Agent、认证和平台状态。                                 |
| `hermes cron`             | 检查并触发定时调度器。                                       |
| `hermes webhook`          | 管理事件驱动激活的动态 Webhook 订阅。                        |
| `hermes doctor`           | 诊断配置和依赖项问题。                                       |
| `hermes dump`             | 可复制粘贴的设置摘要，用于支持/调试。                        |
| `hermes logs`             | 查看、实时跟踪和过滤 Agent/网关/错误日志文件。               |
| `hermes config`           | 显示、编辑、迁移和查询配置文件。                             |
| `hermes pairing`          | 批准或撤销消息配对码。                                       |
| `hermes skills`           | 浏览、安装、发布、审计和配置技能。                           |
| `hermes honcho`           | 管理 Honcho 跨会话记忆集成。                                 |
| `hermes memory`           | 配置外部记忆提供者。                                         |
| `hermes acp`              | 以 ACP术语解释**ACP**Agent Client Protocol，Hermes 与编辑器（VS Code、Zed、JetBrains）通信的标准协议。让编辑器能"请"Hermes 来帮忙写代码的沟通协议。ACP 基于 JSON-RPC，通过标准输入/输出（stdio）在编辑器和 Hermes 之间传递消息。装好 ACP 后，你在编辑器里就能直接跟 Hermes 对话、看它改文件、执行命令，而无需切换到终端。 服务器模式运行 Hermes，用于编辑器集成。 |
| `hermes mcp`              | 管理 MCP 服务器配置，并以 MCP 服务器模式运行 Hermes。        |
| `hermes plugins`          | 管理 Hermes Agent术语解释**Hermes Agent**开源 AI 智能体框架与产品的正式名称。Hermes Agent 是项目和产品的正式名称。文档、GitHub 仓库、安装命令、社区讨论和搜索结果都统一使用这一写法。 插件（安装、启用、禁用、移除）。 |
| `hermes tools`            | 配置各平台启用的工具。                                       |
| `hermes sessions`         | 浏览、导出、清理、重命名和删除会话。                         |
| `hermes insights`         | 显示 token/成本/活动分析。                                   |
| `hermes claw`             | OpenClaw 迁移辅助工具。                                      |
| `hermes profile`          | 管理配置文件 — 多个隔离的 Hermes 实例。                      |
| `hermes completion`       | 输出 shell 补全脚本（bash/zsh）。                            |
| `hermes version`          | 显示版本信息。                                               |
| `hermes update`           | 拉取最新代码并重新安装依赖项。                               |
| `hermes uninstall`        | 从系统中移除 Hermes。                                        |

## 提取pdf

>帮我规划一个操作流程：将 PDF文档 转换为 markdown 格式文档。使用 <https://mineru.net/apiManage/docs> 提供的API 接口，如果没有token，向我询问；检查文件的大小、页数，必要时拆分；最终的markdown文件需要包含图片；移除“由 MinerU API 自动解析生成（含图片）”、“<!-- ===== 第 1-200 页 ===== -->” 等这些不是原文档的内容；删除临时文件。
>
>帮我规划一个操作流程：移除PDF水印。使用python 的 playwright 工具 打开 <https://www.dpdf.com/zh/remove-watermark> 在线工具，上传pdf文件，移除水印后，保存pdf文件
>
>帮我规划一个操作流程：为 PDF 文件添加目录
>
>帮我写一个python脚本程序：将 PDF文档 转换为 markdown 格式文档。使用 <https://mineru.net/apiManage/docs> 提供的API 接口，token从指定的配置文件中读取；检查文件的大小、页数，必要时拆分；最终的markdown文件需要包含图片；移除“由 MinerU API 自动解析生成（含图片）”、“<!-- ===== 第 1-200 页 ===== -->” 等这些不是原文档的内容；检查图片是否被markdown文件引用，如果没有引用，删除图片；如果images目录下为空，则删除images文件夹；删除临时文件。python语言使用 python3.14 推荐的语法及内置库；使用ruff检查无报错。
