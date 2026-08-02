# win10toast 库

不推荐使用，依赖 `pypiwin32` 库，还不如自己用 `PowerShell` 自己写一个库。

An easy-to-use Python library for displaying Windows 10 Toast Notifications which is useful for Windows GUI development.

地址：<https://github.com/jithurjacob/Windows-10-Toast-Notifications>

## Installation

```sh
pip install win10toast
```

## Example

```python
from win10toast import ToastNotifier
toaster = ToastNotifier()

toaster.show_toast("Hello World!!!",
                   "Python is 10 seconds awsm!",
                   icon_path="custom.ico",
                   duration=10)

toaster.show_toast("Example two",
                   "This notification is in it's own thread!",
                   icon_path=None,
                   duration=5,
                   threaded=True)
# Wait for threaded notification to finish
while toaster.notification_active(): time.sleep(0.1)
```
