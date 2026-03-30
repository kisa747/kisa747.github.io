# 在线文档发布

文档创建好后，本地可以预览了，下一步就可以发布了

## 方法一、手动推送

运行命令将 site 目录推送，默认推送至 `gh-pages` 分支

```sh
uv run mkdocs gh-deploy
```

## 方法二、让 GitHub 自动执行任务

参考：<https://squidfunk.github.io/mkdocs-material/publishing-your-site/>

创建 `.github/workflows/ci.yml` ，内容如下，每次 git push 后 GitHub 就会自动 build 并将 site 目录下内容推送至 `gh-pages` 分支。

```yaml
name: ci
on:
  push:
    branches:
      - master
      - main
permissions:
  contents: write
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Configure Git Credentials
        run: |
          git config user.name github-actions[bot]
          git config user.email 41898282+github-actions[bot]@users.noreply.github.com
      - uses: actions/setup-python@v5
        with:
          python-version: 3.x
      - run: echo "cache_id=$(date --utc '+%V')" >> $GITHUB_ENV
      - uses: actions/cache@v4
        with:
          key: mkdocs-material-${{ env.cache_id }}
          path: ~/.cache
          restore-keys: |
            mkdocs-material-
      - run: pip install mkdocs-material mkdocs-document-dates
      - run: mkdocs gh-deploy --force
```
