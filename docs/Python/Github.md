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
