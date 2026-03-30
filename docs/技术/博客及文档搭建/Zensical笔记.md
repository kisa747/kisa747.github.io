# Zensical 笔记

## 创建

官方文档：<https://zensical.org/docs/get-started/>

中文文档：<https://wcowin.work/Zensical-Chinese-Tutorial/>

```sh
# 创建目录
mkdir zen & cd zen

# 在当前目录创建 Zensical
uv init
uv add --dev zensical
uv run zensical new .
```

创建后目录结构如下：

```sh
zen
│  .gitignore          # git忽略文件
│  .python-version
│  main.py             # 无用，可以删除   
│  pyproject.toml
│  README.md
│  uv.lock
│  zensical.toml       # zensical 配置文件，根据需求修改
│
├─.github
│  └─workflows
│          docs.yml    # GitHub Page 配置文件
│
├─.venv
│  └─Scripts
│  │ ......
│  │
└─docs                 # 文档目录
        index.md
        markdown.md
```

根据需求修改 zensical 配置文件 `zensical.toml` 即可。

readthedocs 配置文件参考：<https://docs.readthedocs.com/platform/stable/intro/zensical.html>

## 注意事项

1. 在 `Page - Source` 部分，选择 `GitHub Actions`
2.
