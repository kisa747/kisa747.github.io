## 安装扩展

谷歌浏览器在安装拓展应用的时候，有时候会出现 `无法添加应用、拓展程序和用户脚本` 的现象，解决方法如下：

1.在 Google Chrome 浏览器的桌面快捷方式上鼠标右键，选择属性 (R)，在目标 (T) 后添加参数  --enable-easy-off-store-extension-install（注意在添加参数之前，要有个空格），添加完之后点击确认。

## 添加 Bing 搜索

```sh
# 添加 Bing 搜索。
https://cn.bing.com/search?q=%s
```

### 启动参数

```sh
# 指定 user-agent
--user-agent="Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1"

# 以 app 形式打开网页
--app="https://3bhr.cscec.com/#/time_punch"

"C:\Program Files\Google\Chrome\Application\chrome.exe" --user-agent="Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1" --app="https://3bhr.cscec.com/#/time_punch"
```
