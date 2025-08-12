## 单元测试

内置的 unit 单元测试，参考：[unittest--- 单元测试框架](https://docs.python.org/zh-cn/3/library/unittest.html#module-unittest)

命令行执行测试：

```sh
python -m unittest mail.test_unit.MyTestCase
```

由于是作为模块执行测试，可以完美解决 import 相对引用的问题。

```python
class MyTestCase(unittest.TestCase):
    def setUp(self):
        pass

    # @unittest.skip('跳过')
    def test_message(self):
        emailbody = Path('emailbody').read_bytes()
        msg = email.message_from_bytes(emailbody, policy=email.policy.default)
        value_test = msg.get_body(preferencelist=('plain', 'html'))
        value = None
        self.assertEqual(value_test, value)

    def tearDown(self):
        pass
```

## 文档测试 doctest

官方文档：<https://docs.python.org/zh-cn/3/library/doctest.html>

直接写到函数、方法里的文档，可以可以通过工具（sphinx-autodoc）自动生成文档、测试。

```python
class Media:

    @property
    def creat_date(self) -> datetime.datetime:
        """
        获取媒体创建时间

        :return: 媒体创建时间

        Usage:

        >>> from mediainfo import Media
        >>> m = Media(r'E:\\test\\mediainfo\\1.mov')
        >>> m.creat_date
        datetime.datetime(2021, 12, 26, 20, 9, 14)
        """
        # '2021-12-26 20:09:14.000'
        c_date_str = self.media_info_json['File_Modified_Date_Local']
        # c_date = datetime.datetime.strptime(c_date_str, '%Y-%m-%d %H:%M:%S.%f')
        c_date = datetime.datetime.fromisoformat(c_date_str)
        return c_date
```

## 捕获异常

### 捕获堆栈跟踪信息

 Capturing Stack Traces

```python
import logging
a, b = 5, 0
try:
  c = a / b
except Exception as err:
  logging.warning(f"Exception occurred:{err}", exc_info=True)

[输出：]
ERROR:root:Exception occurred
Traceback (most recent call last):
  File "exceptions.py", line 6, in <module>
    c = a / b
ZeroDivisionError: division by zero
[Finished in 0.2s]

# 还有一种写法，没啥卵用。
logging.exception("Exception occurred")
# 相当于：
logging.error("Exception occurred", exc_info=True)
```

### 捕获异常的基类

```python
print("Unexpected error:", sys.exc_info()[0])
```

### 同时捕获多个异常

```python
try:
    pass
except (ValueError, ZeroDivisionError) as err:
    pass
```

### 输出信息格式化

Refer to the [`str.format()`](https://docs.python.org/3/library/stdtypes.html#str.format) documentation for full details on the options available to you.

| Attribute name  | Format                                      | Description                                                  |
| --------------- | ------------------------------------------- | ------------------------------------------------------------ |
| args            | You shouldn’t need to format this yourself. | The tuple of arguments merged into `msg` to produce `message`, or a dict whose values are used for the merge (when there is only one argument, and it is a dictionary). |
| asctime         | `%(asctime)s`                               | Human-readable time when the [`LogRecord`](https://docs.python.org/3/library/logging.html?highlight=logging#logging.LogRecord) was created. By default this is of the form ‘2003-07-08 16:49:45,896’ (the numbers after the comma are millisecond portion of the time). |
| created         | `%(created)f`                               | Time when the [`LogRecord`](https://docs.python.org/3/library/logging.html?highlight=logging#logging.LogRecord) was created (as returned by [`time.time()`](https://docs.python.org/3/library/time.html#time.time)). |
| exc_info        | You shouldn’t need to format this yourself. | Exception tuple (à la `sys.exc_info`) or, if no exception has occurred, `None`. |
| filename        | `%(filename)s`                              | Filename portion of `pathname`.                              |
| funcName        | `%(funcName)s`                              | Name of function containing the logging call.                |
| levelname       | `%(levelname)s`                             | Text logging level for the message (`'DEBUG'`, `'INFO'`, `'WARNING'`, `'ERROR'`, `'CRITICAL'`). |
| levelno         | `%(levelno)s`                               | Numeric logging level for the message (`DEBUG`, `INFO`,`WARNING`, `ERROR`, `CRITICAL`). |
| lineno          | `%(lineno)d`                                | Source line number where the logging call was issued (if available). |
| message         | `%(message)s`                               | The logged message, computed as `msg % args`. This is set when [`Formatter.format()`](https://docs.python.org/3/library/logging.html?highlight=logging#logging.Formatter.format) is invoked. |
| module          | `%(module)s`                                | Module (name portion of `filename`).                         |
| msecs           | `%(msecs)d`                                 | Millisecond portion of the time when the [`LogRecord`](https://docs.python.org/3/library/logging.html?highlight=logging#logging.LogRecord) was created. |
| msg             | You shouldn’t need to format this yourself. | The format string passed in the original logging call. Merged with `args` to produce `message`, or an arbitrary object (see [Using arbitrary objects as messages](https://docs.python.org/3/howto/logging.html#arbitrary-object-messages)). |
| name            | `%(name)s`                                  | Name of the logger used to log the call.                     |
| pathname        | `%(pathname)s`                              | Full pathname of the source file where the logging call was issued (if available). |
| process         | `%(process)d`                               | Process ID (if available).                                   |
| processName     | `%(processName)s`                           | Process name (if available).                                 |
| relativeCreated | `%(relativeCreated)d`                       | Time in milliseconds when the LogRecord was created, relative to the time the logging module was loaded. |
| stack_info      | You shouldn’t need to format this yourself. | Stack frame information (where available) from the bottom of the stack in the current thread, up to and including the stack frame of the logging call which resulted in the creation of this record. |
| thread          | `%(thread)d`                                | Thread ID (if available).                                    |
| threadName      | `%(threadName)s`                            | Thread name (if available).                                  |
