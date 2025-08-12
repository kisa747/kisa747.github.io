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

## 笔记

### 模拟设备、时区、语言、位置

参考：<https://playwright.dev/python/docs/emulation>

常见的 `iphone 15` ，支持的字段参考：[registry of device parameters](https://github.com/microsoft/playwright/blob/main/packages/playwright-core/src/server/deviceDescriptorsSource.json)

```python
from playwright.sync_api import sync_playwright, Playwright

def run(playwright: Playwright):
    webkit = playwright.webkit
    iphone = playwright.devices["iPhone 6"]
    browser = webkit.launch()
    context = browser.new_context(**iphone)
    page = context.new_page()
    page.goto("http://example.com")
    # other actions...
    browser.close()

with sync_playwright() as playwright:
    run(playwright)
```

模拟 Locale & Timezone

```python
context = browser.new_context(
  locale='zh-CN',
  timezone_id: 'Asia/Shanghai',
)
```

坐标

```python
_ = {  # 打卡地 1
'latitude': 34.283277,  # 纬度
'longitude': 117.381175,  # 经度
'accuracy': 99,  # GPS 精度
}
_ = {  # 打卡地 2
'latitude': 34.28186,  # 纬度
'longitude': 117.34710,  # 经度
'accuracy': 99,  # GPS 精度
}
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
