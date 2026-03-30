# playwright 笔记

Playwright 专为满足端到端测试的需求而创建。Playwright 支持所有现代渲染引擎，包括 Chromium、WebKit 和 Firefox。在 Windows、Linux 和 macOS 上进行测试，本地或持续集成 (CI)，无头或使用原生移动模拟进行有头测试。

官方文档：<https://playwright.dev/python/docs/intro>

## Quick Start

使用 playwright

```sh
# 安装 playwright
uv add playwright

# 安装测试用的浏览器，一般用 chromium 就够了
# Windows 下安装位置：%LOCALAPPDATA%\ms-playwright
uv run playwright install chromium
```

代码助手运行

```sh
uv run playwright codegen --device="iPhone 13" --timezone="Asia/Shanghai" --geolocation="34.283277,117.381175" -o "test_pw.py" "https://3bhr.cscec.com/#/time_punch"  --save-storage=auth.json

# 登录完成后后保存登录信息，下次重复访问此网站，就不用重复登录了
uv run playwright codegen --device="iPhone 13" --timezone="Asia/Shanghai" --geolocation="34.283277,117.381175" -o "test_pw.py" "https://3bhr.cscec.com/#/time_punch"  --load-storage=auth.json
```

同步模式访问一个网站

```python
from playwright.sync_api import Playwright, sync_playwright


def run(playwright: Playwright):
    webkit = playwright.webkit
    device = playwright.devices['iPhone 15']
    browser = webkit.launch()
    context = browser.new_context(
        **device,
        locale='zh-CN',
        timezone_id='Asia/Shanghai',
        geolocation={
            'latitude': 34,  # 纬度
            'longitude': 117,  # 经度
            'accuracy': 99,  # GPS精度
        },
        permissions=['geolocation'],
        storage_state='auth.json',
    )
    page = context.new_page()
    page.goto('http://example.com')


with sync_playwright() as playwright:
    run(playwright)
```

## 配置

### 模拟设备

参考：<https://playwright.dev/python/docs/emulation>

设备支持的字段参考：[registry of device parameters](https://github.com/microsoft/playwright/blob/main/packages/playwright-core/src/server/deviceDescriptorsSource.json)

常见的设备： `iphone 15`  `Galaxy S24`  `iPad Pro 11` `iPad Mini` `Desktop Chrome` `Desktop Edge`

### 模拟语言、时区

模拟 `Locale & Timezone` ，CI部署中非常重要，操作系统语言可能是英语。

```python
context = browser.new_context(
  locale='zh-CN',
  timezone_id: 'Asia/Shanghai',
)
```

### 模拟位置

```python
context = browser.new_context(
    geolocation={
        'latitude': 34,  # 纬度
        'longitude': 117,  # 经度
        'accuracy': 99,  # GPS精度
    },
    permissions=['geolocation'],
)
```

### 加载回话

```python
# 保存会话
context.storage_state(path='auth.json')

# 加载之前保存的会话
context = browser.new_context(
    storage_state='auth.json',
)
```

### 自动等待

playwright 的操作命令，都会有一个自动等待功能，

```python
from playwright.sync_api import Playwright, expect, sync_playwright

# 断言超时默认 5 秒钟，可以设置全局为 30 秒
expect.set_options(timeout=30_000)

# click()、fill() 等操作命令默认等待时间 10s，可以设置全局为 30 秒
browser = playwright.chromium.launch(headless=True)
context = browser.new_context()
context.set_default_timeout(30_000)  # 设置默认超时时间 30s

```
