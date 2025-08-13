# Jupyter Notebook 笔记

[Jupyter Notebook 文档](https://jupyter-notebook.readthedocs.io/en/latest/)

Jupyter Notebook 太混乱了，VSCode 已经集成了 Jupyter 功能，用的更少了。

## Quik Start

参考：<https://docs.astral.sh/uv/guides/integration/jupyter/>

在项目中使用

```sh
uv run --with jupyter jupyter lab
```

不过每次都需要联网，重新构建虚拟环境，相当有每次运行都要下载一遍 `jupyter`，文档翻了个遍，实在找不到更好、更方便的办法。
