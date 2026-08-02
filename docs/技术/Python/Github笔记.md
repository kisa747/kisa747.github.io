# GitHub 笔记

## GitHub Actions

官方文档：<https://docs.github.com/zh/actions>

GitHub Actions 是一种持续集成和持续交付 (CI/CD) 平台，可用于自动执行生成、测试和部署管道。你可以创建工作流，以便在推送更改到存储库时运行测试，或将合并的拉取请求部署到生产环境。

```yaml
# Prevents a job from failing when a step fails. Set to true to allow a job to pass when this step fails.
# 即使运行错误也继续向下运行
continue-on-error = true

# 对于单条 shell 命令，也可以这样写，缺点是 GitHub Actions 后台日志看不到警告信息
git restore --source=origin/dev scripts/pw_state.json || true

# 状态检查函数，应避免使用 if: ${{ always() }}
if: ${{ !cancelled() }}

# GitHub Actions 的 cron 时间为 UTC 时间
  schedule:
    - cron: '10 23 * * *' # 每天 7:10 运行（Github Actions 仅支持 UTC 时间）

# 为防止任务挂起，可以设置超时时间
timeout-minutes: 20

# 任务脚本中如果需要处理时间，可以设置操作系统的时区
- name: Set Beijing Timezone  # https://github.com/szenius/set-timezone
  uses: szenius/set-timezone@v2
  with:
  timezoneLinux: "Asia/Shanghai"

# 进阶，为避免安装依赖出错，可以设置缓存
    - name: Cache
      uses: actions/cache@v4
      with:
        key: ${{ runner.os }}-cache
        path: ~/.cache
        restore-keys: |
          ${{ runner.os }}-cache

```

## Dependabot

参考：[Dependabot 快速入门指南](https://docs.github.com/zh/code-security/tutorials/secure-your-dependencies/dependabot-quickstart-guide)

Dependabot 就是一个没有感情的依赖更新机器人，在您的项目所依赖的上游软件包或应用程序发布新版本后，它会在您的 GitHub 仓库自动创建一个 PR 来更新依赖文件，并说明依赖更新内容，用户自己选择是否 merge 该 PR。

开启方法有 2 个：

* 🚀方法 1（推荐此方法）：在仓库的 `.github` 目录中创建 `dependabot.yml` 配置文件，推送至仓库中，即可开启`Dependabot version updates` ，Allow Dependabot to open pull requests automatically to keep your dependencies up-to-date when new versions are available。
* 方法 2：在 GitHub 页面上进行操作，在仓库页面通过`Setting` -> `Advanced Security` -> `Dependabot` -> `Dependabot version updates`  路径点击 `Enable` 即可自动打开配置 `.github/dependabot.yml` 文件的页面。

> 可以根据情况开启 Dependabot alerts，以实现有更新时邮件通知，通过 `Setting` -> `Advanced Security` -> `Dependabot` -> `Dependabot alerts` 路径点击 `Enable` 即可开启。

项目的依赖其实还好解决，对于 Node.js 项目，定期执行 `ncu` 命令即可，但是对于 GitHub Actions 中引用的第三方 actions，总不能手动去检查一遍哪些 action 发布了更新吧，因此使用 Dependabot 来监视 actions 最合适不过了。

配置如下：

```yaml
# .github/dependabot.yml

version: 2
updates:
  - package-ecosystem: "github-actions" # See documentation for possible values
    directory: "/" # Location of package manifests
    schedule:
      interval: "weekly"
```

备份

```yaml
# https://docs.github.com/zh/actions
name: test_time_punch
env:
  FORCE_JAVASCRIPT_ACTIONS_TO_NODE24: true
on:
  schedule:
    - cron: '00 10 * * *' # 每天 18:00 运行（Github Actions 仅支持 UTC 时间）
  push:
    branches:
      - 'run'  # 仅推送 run 分支才触发
  workflow_dispatch:  # 手动运行
permissions:
  contents: write
jobs:
  test:
    timeout-minutes: 10  # The maximum number of minutes to let a job run before GitHub automatically cancels it. Default: 360
    runs-on: ubuntu-latest  # 最新版的 Ubuntu LTS 比如：Ubuntu 24.04.2 LTS
    steps:
    - name: Checkout repository
      uses: actions/checkout@v7
      with:
        fetch-depth: 0  # 确保检出所有分支
    
    - name: Git config
      run: |
        git config user.name github-actions[bot]
        git config user.email 41898282+github-actions[bot]@users.noreply.github.com
    
    - name: Git restore file
      continue-on-error: true
      run: |
        git restore --source=origin/dev scripts/pw_state.json

    - name: Set Beijing Timezone  # https://github.com/szenius/set-timezone
      uses: szenius/set-timezone@v2.0
      with:
        timezoneLinux: "Asia/Shanghai"

    - name: Setup Python  # https://github.com/actions/setup-python
      uses: actions/setup-python@v7
      with:
        python-version-file: 'pyproject.toml'
        cache: 'pip' # caching pip dependencies

    - name: Install python dependencies
      run: pip install -e .

    - run: echo "playwright_cache_id=$(playwright -V | tr -d ' ')" >> $GITHUB_ENV

    - name: Cache playwright browsers
      uses: actions/cache@v6
      with:
        key: ${{ runner.os }}-playwright-browsers-cache-${{ env.playwright_cache_id }}
        path: ~/.cache/ms-playwright
        restore-keys: |
          ${{ runner.os }}-playwright-browsers-cache-${{ env.playwright_cache_id }}
          ${{ runner.os }}-playwright-browsers-cache-

    - name: Install browsers with dependencies
      run: python -m playwright install chromium --with-deps --only-shell

    - name: Run Python Scripts
      env:
        TP_USERNAME: ${{secrets.TP_USERNAME}}
        TP_PWD: ${{secrets.TP_PWD}}
      run: |
        python scripts/test_pw.py

    - name: Git Push to Branch "dev"
      if: ${{ !cancelled() }}  # 除非取消，无论前面工作流成功与否，都会被执行
      run: |
        git add .
        git commit -m "Updated by Github Actions"
        git push -f origin main:dev
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

```
