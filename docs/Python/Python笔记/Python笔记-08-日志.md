# 日志

Python 内置的日志模块是 `logging`，暂时不支持终端彩色输出。

1. 级别从低到高为`DEBUG` `INFO` `WARNING` `ERROR` `CRITICAL`
2. 默认级别为`WARNING`，只有`WARNING`和之上的级别的 log 控制台才会被输出
3. 可以仅输出到文件，也可以同时输出值终端、日志文件

```python
import logging
logging.basicConfig(**kwargs) # 语法

# 示例
logging.basicConfig(filename='log.log', level=logging.WARNING,format='%(asctime)s - %(module)s:%(lineno)s - %(levelname)s: %(message)s')
# 记录到文件使用参数：filename='log.log',
# logging.disable(logging.CRITICAL)  # 禁用日志功能
# level 级别从低到高为：DEBUG、INFO、WARNING、ERROR、CRITICAL，默认级别为 WARNING
```

The following keyword arguments are supported.

|   Format   | Description                                                  |
| :--------: | ------------------------------------------------------------ |
| *filename* | Specifies that a FileHandler be created, using the specified filename, rather than a StreamHandler. |
| *filemode* | If *filename* is specified, open the file in this [mode](https://docs.python.org/3/library/functions.html#filemodes). Defaults to `'a'`. |
|  *format*  | Use the specified format string for the handler.             |
| *datefmt*  | Use the specified date/time format, as accepted by [`time.strftime()`](https://docs.python.org/3/library/time.html#time.strftime). |
|  *style*   | If *format* is specified, use this style for the format string. One of `'%'`, `'{'` or `'$'`for [printf-style](https://docs.python.org/3/library/stdtypes.html#old-string-formatting), [`str.format()`](https://docs.python.org/3/library/stdtypes.html#str.format) or [`string.Template`](https://docs.python.org/3/library/string.html#string.Template) respectively. Defaults to `'%'`. |
|  *level*   | Set the root logger level to the specified [level](https://docs.python.org/3/library/logging.html#levels). |
|  *stream*  | Use the specified stream to initialize the StreamHandler. Note that this argument is incompatible with *filename* - if both are present, a `ValueError` is raised. |
| *handlers* | If specified, this should be an iterable of already created handlers to add to the root logger. Any handlers which don’t already have a formatter set will be assigned the default formatter created in this function. Note that this argument is incompatible with *filename* or *stream* - if both are present, a `ValueError` is raised. |

## logging 日志同时输出至屏幕和文件

参考：<https://docs.python.org/zh-cn/3/library/logging.html>

<https://docs.python.org/zh-cn/3/howto/logging.html>

<https://my.oschina.net/yagami1983/blog/1942002>

官方教程推荐通过 `logger = logging.getLogger('simple_example')` 实例化一个 Hander 对象，然后修改这个实例。

但是这样的话，程序里面的代码都得修改，因此可以选择直接修改 root 的根 Logger 对象。

注意：通过 addHandler 添加的 Handler 的 level 只能比 basicConfig 设置的高。一般来说，我们希望文件记录的等级比屏幕记录的等级高，因此通过 basicConfig 设置屏幕输出较低的等级，通过 addHandler 添加较高的等级到文件。

```python
import logging
from pathlib import Path
def _test():
    logging.info('处理完成！')
def main():
    pass
if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO, format='[%(levelname)s] %(message)s')
    # -------以下为将日志同时输出至文件的代码-------
    # 定义一个 FileHandler，将日志信息写入到文件，并将其添加到当前的日志处理对象
    # handler = logging.FileHandler(filename=Path(__file__).with_suffix('.log'), mode='a')
    # 定义一个 RotatingFileHandler，将日志信息写入到文件，并控制文件大小和数量，可实现日志轮转，
    # 即备份旧日志并创建新日志文件日志文件最大为 100k，备份文件 1 个。
    handler = logging.handlers.RotatingFileHandler(Path(__file__).with_suffix('.log'), 'a', 100_000, 1)
    handler.setLevel(logging.WARNING)
    formatter = logging.Formatter('%(asctime)s - %(module)s:%(lineno)s [%(levelname)s] %(message)s')
    handler.setFormatter(formatter)
    logging.getLogger('').addHandler(handler)
    # ----------------------------------------
    _test()
    # main()
```

## logging 日志同时输出至屏幕和文件（控制日志文件大小）

推荐使用这个方法

```python
import logging
import logging.handlers

# 在程序中正常使用 logger 即可。
logging.info('--> 处理完成！')

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO, format='[%(levelname)s] %(message)s')
    # 定义一个 RotatingFileHandler，将日志信息写入到文件，并控制文件大小和数量，可实现日志轮转，即备份旧日志并创建新日志文件
    # 日志文件最大为 100k，备份文件 1 个。
    handler = logging.handlers.RotatingFileHandler(Path(__file__).with_suffix('.log'), 'a', 100_000, 1)
    handler.setLevel(logging.WARNING)
    formatter = logging.Formatter('%(asctime)s - %(module)s:%(lineno)s [%(levelname)s] %(message)s')
    handler.setFormatter(formatter)
    logging.getLogger('').addHandler(handler)

    # _test()
    main()
```
