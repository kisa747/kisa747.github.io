## PaddleOCR

<https://www.paddlepaddle.org.cn/documentation/docs/zh/install/index_cn.html>

基于飞桨的 OCR 工具库，包含总模型仅 8.6M 的超轻量级中文 OCR，单模型支持中英文数字组合识别、竖排文本识别、长文本识别。同时支持多种文本检测、文本识别的训练算法。

```sh
pip install paddlepaddle
pip install paddleocr
```

## 百度智能云 API

参考：<https://cloud.baidu.com/doc/OCR/s/ejwvxzls6/>

首先我们点击链接 (<https://cloud.baidu.com>)，然后用自己百度帐号登录（百度云盘之类的帐号就行，没有的话注册一个），然后点击右上角的管理控制台按钮进去（里面有好多免费的服务，感觉可以嗨一波），拉到下面选择 **文字识别** 点进去。找到创建应用这个按钮，点击后给应用取个名称，建议用字母数字的组合，写个应用描述其他的默认，然后立即创建即可。

得到：返回应用列表，这里可以查看到我们的三个关键信息：`APPP_ID、API_KEY、SECRET_KEY`，这里后面编程需要用的。

安装百度 aip 库：

```sh
pip install baidu-aip
```

使用示例：

```python
import baidu-aip
```
