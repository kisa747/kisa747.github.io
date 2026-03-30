# 多线程与多进程

## 多线程

参考：

<https://www.cnblogs.com/huoxc/p/13304396.html>

<https://docs.python.org/zh-cn/3.7/library/queue.html#queue.Queue.join>

<https://docs.python.org/zh-cn/3.10/library/queue.html#queue.Queue.join>

<https://docs.python.org/zh-cn/3/library/threading.html#thread-objects>

对比 [最新的官方文档](https://docs.python.org/zh-cn/3.10/library/queue.html#queue.Queue.join)，会发现他已经不再往消息队列里放入 None，而是将线程设置为守护线程 `daemon=True` ，主进程结束则自动杀死所有子线程（默认情况下，线程是非守护的。主线程结束后，会默认等待子线程结束后，主线程才退出。父进程在创建子进程之后先于子进程退出，会造成这个子进程变为“孤儿进程”。说了这么多就是大家最好养成习惯，一般情况下，加上`daemon=True`参数是个比较好的选择。）

当 `q` 收到所有的 `task_done()` 信号、所有元素都被消费后，q 才停止阻塞，二者缺一不可。因此可以把消费线程设置为 daemon，用 Queue.join() 方法同样实现阻塞功能。

## 多生产者、多消费者模式

所以多生产者、多消费者模式，有 2 种方案实现。

### 守护模式

方案 1（Python [最新的官方文档](https://docs.python.org/zh-cn/3.10/library/queue.html#queue.Queue.join)  实例）：将子线程设置为守护线程（主进程结束则杀死所有子线程）`daemon=True` ，仅靠 Queue.join() 方法阻塞，只要消息队列被全部取出并消费，则主进程继续往下执行直至结束，主进程结束后，自动杀死所有子线程。

> 如果消息队列阻塞结束后，主进程还要继续往下执行很长一段时间，那么消费线程其实还是在一直执行，但是由于消息队列已经空了，所以代码执行到 `data = self.q.get()` ，其实会一直阻塞。
>
> 官方文档里说了“守护线程在程序关闭时会突然关闭。他们的资源（例如已经打开的文档，数据库事务等等）可能没有被正确释放”。如果存在文件读写、数据库读写，使用过此方案时，一定要及时保存、关闭已经打开的对象，尽量使用上下文管理方法。

### 非守护模式

方案 2（[python3.7 官方文档实例](https://docs.python.org/zh-cn/3.7/library/queue.html#queue.Queue.join)）：保持子线程守护模式为默认模式 `daemon=False`，等生产线程全部结束后，向消息队列中放入与消费线程数量相同的 `None` ，在消费线程的函数中增加判断，如果取出的值是 `None` ，则终止循环，子线程结束。设置消费线程阻塞，待所有消费线程接受后停止阻塞，主进程继续往下执行。这样可以完美保证主进程结束后，不会存在孤儿进程。

> 由于消费线程是通过接收的数据是否为 None 来判断是否结束，因此生产的正常数据中不能为 None。
>
> 通过测试发现，如果生产快、消费慢，q.join() 一段时间后才会出现 None 值被取出。说明向消息队列中放入 None，不必使用 task_done() 方法通知消息队列，也就是说消息队列中的 None，不占用未完成任务的计数。
>
> Queue.join() 塞至队列中所有的元素都被接收和处理完毕。当条目添加到队列的时候，未完成任务的计数就会增加。每当消费者线程调用 [`task_done()`](https://docs.python.org/zh-cn/3.7/library/queue.html#queue.Queue.task_done) 表示这个条目已经被回收，该条目所有工作已经完成，未完成计数就会减少。当未完成计数降到零的时候， [`join()`](https://docs.python.org/zh-cn/3.7/library/queue.html#queue.Queue.join) 阻塞被解除。

通过对比，方案 1，也就是 Python 最新版官方文档的实例，更加简单粗暴，线程设置为守护模式，主进程结束则自动杀死所有子线程，只要消息队列全部被取出且被消费。

以下为官方文档：

一个线程可以被标记成一个“守护线程”。这个标识的意义是，当剩下的线程都是守护线程时，整个 Python 程序将会退出。初始值继承于创建线程。这个标识可以通过 [`daemon`](https://docs.python.org/zh-cn/3/library/threading.html#threading.Thread.daemon) 特征属性或者 *daemon* 构造器参数来设置。

> 守护线程在程序关闭时会突然关闭。他们的资源（例如已经打开的文档，数据库事务等等）可能没有被正确释放。如果你想你的线程正常停止，设置他们成为非守护模式并且使用合适的信号机制，例如： [`Event`](https://docs.python.org/zh-cn/3/library/threading.html#threading.Event)。

关于 logging 模块

>logging 模块是线程安全的，不会抢占屏幕输出。

标准的采用类创建多线程模式

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
多生产者、多消费者模式模板

"""
import logging
import time
import threading
import queue
from collections import deque
# ------------------------------Start------------------------------

class MultiProducerConsumer:
    """
    多线程、多生产者、多消费者模式，参考 python 官方示例的实现。

    流程如下：
    1、开启生产线程，生产数据，放入 Queue 队列。
    2、开启消费线程，从队列中数据并消费。
    3、所有生产线程结束。
    4、等待所有 Queue 中数据全部被消费。
    5、所有消费线程结束。
    6、停止阻塞消费线程。
    7、任务结束。
    """
    def __init__(self):
        # LIFO 模式（Last in, First out 后进先出）请使用 queue.LifoQueue(maxsize=0)
        self._queue = queue.Queue()  # 线程安全的消息队列，FIFO 模式（First in, First out 先进先出）。
        self._deque = deque()

    def producer(self, producer_thread_number):
        """
        生产线程
        厨师不停地每 4 秒做一个包子

        :param producer_thread_number: 生产线程编号
        :return: None
        """
        for i in ('张三', '李四', '王五'):
            data = f'生产线程 {producer_thread_number} 厨师 {i} 做的包子'
            time.sleep(4)
            self._queue.put(data)  # 厨师不停地做包子
            logging.info(data)

    def consumer(self, consumer_thread_number):
        """
        消费线程
        顾客不停地每 2 秒吃一个包子

        :param consumer_thread_number: 消费线程编号
        :return:
        """
        while True:
            data = self._queue.get()  # 顾客不停地吃包子
            # --------------------------------------------------------------
            # 如果消费线程设置了 daemon=True，下面的代码可以注释掉。
            # 判断取出的数据是否为 None，必须直接放到 q.get()，否则取出的 None 值也会被消费。
            # if data is None:  # 收到 None 后，终止循环。
            #     logging.info(f'消费线程{consumer_thread_number} 收到了一个 None')
            #     break
            # --------------------------------------------------------------
            self._deque.append(f'写入的--{data}')  # 添加到队列
            time.sleep(2)
            self._queue.task_done()  # 通知 queue 已经成功取出了一个元素，并已执行完任务。
            logging.info(f'消费线程 {consumer_thread_number} 顾客吃了一个 <{data}>')

    def run(self, producer_num=10, consumer_num=10):
        # 开始生产线程
        thread_producers = []
        for producer_thread_number in range(producer_num):
            thread_producer = threading.Thread(target=self.producer,
                                               args=[producer_thread_number],
                                               name=f'生产线程 {producer_thread_number}',
                                               daemon=True)
            thread_producer.start()  # 启动生产子线程
            thread_producers.append(thread_producer)

        # 开始消费线程
        thread_consumers = []
        for consumer_thread_number in range(consumer_num):
            thread_consumer = threading.Thread(target=self.consumer,
                                               args=[consumer_thread_number],
                                               name=f'消费线程 {consumer_thread_number}',
                                               daemon=True)
            thread_consumer.start()  # 启动消费子线程
            thread_consumers.append(thread_consumer)

        # 阻塞生产线程，直到所有生产线程结束。
        for thread_producer in thread_producers:
            thread_producer.join()

        # 等待队列全部被消费。当 Q 收到所有的 task_done() 信号、所有元素都被消费后，Q 才停止阻塞，二者缺一不可。
        logging.info('self._queue.join() 前')
        self._queue.join()  # block until all tasks are done
        logging.info('self._queue.join() 后')

        # ------------------------------------------------------
        # 如果消费线程设置了 daemon=True 参数，下面这一段可以注释掉。
        # 如果消费线程没有设置 daemon=True 参数，必须要有下面的代码。
        # 向消息队列中放入消费线程数量相同的 None，释放终止消费线程的信号。
        # for _ in thread_consumers:
        #     self._queue.put(None)
        # # 阻塞消费线程，直到所有消费线程结束。
        # for thread_consumer in thread_consumers:
        #     thread_consumer.join()
        # ------------------------------------------------------

        print(f'取出：{self._deque}')  # 多线程结束后，可以放心的读取队列内容
        logging.info('所有生产、消费线程全部结束！')


def main():
    MultiProducerConsumer().run(producer_num=10, consumer_num=10)

# -------------------------------End-------------------------------
if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')
    # 定义一个 FileHandler，将日志信息写入到文件，并将其添加到当前的日志处理对象
    # handler = logging.FileHandler(filename=Path(__file__).with_suffix('.log'), mode='a')
    # handler.setLevel(logging.WARNING)
    # formatter = logging.Formatter('%(asctime)s - %(module)s:%(lineno)s - %(levelname)s: %(message)s')
    # handler.setFormatter(formatter)
    # logging.getLogger('').addHandler(handler)

    # _test()
    main()
```

## Reference

### threading 线程类

```python
# 语法
threading.Thread(group=None, target=None, name=None, args=(), kwargs={}, *, daemon=None)
# args 都是向 target 函数传递参数。daemon 是关键字参数。

import threading
d = threading.Thread(name='daemon', target=daemon, daemon=True)
d.start()
```

默认情况下，线程是非守护的。主线程结束后，会默认等待子线程结束后，主线程才退出。父进程在创建子进程之后先于子进程退出，会造成这个子进程变为“孤儿进程”。说了这么多就是大家最好养成习惯，一般情况下，加上`daemon=True`参数是个比较好的选择。

如果要等待标记为守护的线程结束，可以使用 `d.join()` 方法。

也就是 `d.join()` 方法不是必须的语句，只是为了等待所有的线程执行完成后，然后再向下执行。

默认情况下，`join()` 会无限期等待直到线程完成。

如果`join(10)` 如果在 10 秒内线程并未结束，`join()` 就会执行，不再继续等待，然后程序继续向下执行。

如果多个子线程，可以用列表遍历方法添加。

## subprocess 创建子进程

官方文档：<https://docs.python.org/zh-cn/3.13/library/subprocess.html>

subprocess 模块主要用于创建子进程，并连接它们的输入、输出和错误管道，获取它们的返回状态。通俗地说就是通过这个模块，你可以在 Python 的代码里执行操作系统级别的命令，比如 `ipconfig`、`du -sh` 等等。subprocess 模块替代了一些老的模块和函数，比如：`os.system`、`s.spawn`。

官方建议调用 cmd 命令使用`subprocess.run()`  在 Python 中，我们通过标准库中的 subprocess 包来 fork 一个子进程，并运行一个外部的程序。

如果仅仅为了运行一个外部命令而不用交互，直接使用 `run()` 方法，不用任何参数。返回一个 CompletedProcess 类型对象。

如果需要交互式输入，使用 Popen() 方法，但是它的返回值是一个 Popen 对象，而不是`CompletedProcess`对象。

```python
import subprocess
# 除 args 命令，其余全是关键字参数
subprocess.run(args, *, stdin=None, input=None, stdout=None, stderr=None, capture_output=False, shell=False, cwd=None, timeout=None, check=False, encoding=None, errors=None, text=None, env=None)
```

功能：执行 args 参数所表示的命令，等待命令结束，并返回一个 CompletedProcess 类型对象。`run()` 方法默认返回一个 `CompletedProcess` 实例，包含进程  **退出码、输出信息**。

**参数解释：**

**args**：表示要执行的命令。必须是一个字符串，或字符串参数列表。*args* 被所有调用需要，应当为一个字符串，或者一个程序参数序列。提供一个参数序列通常更好，它可以更小心地使用参数中的转义字符以及引用（例如允许文件名中的空格）。如果传递一个简单的字符串，则 *shell* 参数必须为`True`或者该字符串中将被运行的程序名必须用简单的命名而不指定任何参数。

capture_output=True：捕获标准输出和标准错误。

**shell**：默认为 False。如果该参数为 True，将通过操作系统的 shell 执行指定的命令。

如果 *shell* 设为 `True`,则使用 shell 执行指定的指令。如果您主要使用 Python 增强的控制流（它比大多数系统 shell 提供的强大），并且仍然希望方便地使用其他 shell 功能，如 shell 管道、文件通配符、环境变量展开以及 `~` 展开到用户家目录，这将非常有用。但是，注意 Python 自己也实现了许多类似 shell 的特性（例如：glob, fnmatch, os.walk(), os.path.expandvars(), os.path.expanduser() 和 shutil）

不同于某些其他的 popen 函数，这个库将不会隐式地选择调用系统 shell。这意味着所有字符，包括 shell 元字符都可以被安全地传递给子进程。如果 shell 是通过 `shell=True` 被显式地唤起的，则应用程序要负责确保所有空白符和元字符被适当地转义以避免 [shell 注入](https://en.wikipedia.org/wiki/Shell_injection#Shell_injection) 安全漏洞。在 [某些平台](https://docs.python.org/zh-cn/3.13/library/shlex.html#shlex-quote-warning) 上，可以使用 [`shlex.quote()`](https://docs.python.org/zh-cn/3.13/library/shlex.html#shlex.quote) 来执行这种转义。

在 Windows 上，批处理文件 (`*.bat` 或 `*.cmd`) 可以在系统 shell 中通过操作系统调用来启动而忽略传给该库的参数。这可能导致根据 shell 规则来解析参数，而没有任何 Python 添加的转义。如果你想要附带来自不受信任源的参数启动批处理文件，请考虑传入 `shell=True` 以允许 Python 转义特殊字符。请参阅 [gh-114539](https://github.com/python/cpython/issues/114539) 了解相关讨论。

* 在 python3.12 版本之前，使用 `shell=True`，在当前目录中投放一个命名为 `cmd.exe` 的恶意程序会被当做 shell 运行，后续 python3.12 之后这个 BUG 被修复了。

总结：保持 `shell=False` 默认参数，命令参数已列表形式传递。

* 在 Linux 中，当 args 是个列表的时候，shell 保持默认的 False；当 args 是个字符串时，请设置 `shell=True` 。

* 在 Windows 中，`shell=False` 时，相当于 `Win + R` 运行一条命令。命令和参数应该以列表形式传入，否则会提示 `FileNotFoundError`。

```sh
p = subprocess.run(['explorer', r'd:\'])
```

* 在 Windows 中，传入 `shell = True` 参数，则通过 shell 执行指定的命令，args 可以是字符串、列表。

> 使用中间 shell 意味着在运行该命令之前 **处理命令字符串的变量**，glob 模式以及其他特殊的 shell 功能。
>
> 处理比较复杂的命令可以使用 shell 模式，可以处理$&特殊含义字符。

**timeout=30**：设置命令超时时间，单位为秒。如果命令执行时间超时，子进程将被杀死，并弹出`TimeoutExpired`异常。

**check=True**：如果该参数设置为 True，并且进程退出状态码不是 0，则弹出`CalledProcessError`异常。给 `run()` 方法传递 `check=True` ，可以返回 Python 的错误码，方便 `except` 捕获。等同于 `check_call()`

**encoding**: 如果指定了该参数，则 stdin、stdout 和 stderr 可以接收字符串数据，并以该编码方式编码。否则只接收 bytes 类型的数据。简中 Widows 下默认编码是`cp936`，为便于跨平台使用，可以使用 `encoding=locale.getencoding()` 参数。

```python
import subprocess
import locale
r = subprocess.run('dir', shell=True, capture_output=True, encoding=locale.getencoding())
```

### 需要交互式输入的命令

尽管 subprocess.Popen() 方法也能实现，但是比较复杂。

[`delegator` — `requests` 作者最新作品](https://github.com/kennethreitz/delegator.py)

### subprocess.Popen() 交互式输入

用法和参数与 run() 方法基本类同，但是它的返回值是一个 Popen 对象，而不是`CompletedProcess`对象。

```python
>>> ret = subprocess.Popen("dir", shell=True)
>>> type(ret)
<class 'subprocess.Popen'>
>>> ret
<subprocess.Popen object at 0x0000000002B17668>
```

Popen 对象的 stdin、stdout 和 stderr 是三个文件句柄，可以像文件那样进行读写操作。

```python
>>>s = subprocess.Popen("ipconfig", stdout=subprocess.PIPE, shell=True)
>>>print(s.stdout.read().decode("GBK"))
```

要实现前面的 python 命令功能，可以按下面的例子操作：

```python
import subprocess

s = subprocess.Popen("python", stdout=subprocess.PIPE, stdin=subprocess.PIPE, shell=True)
s.stdin.write(b"import os\n")
s.stdin.write(b"print(os.environ)")
s.stdin.close()

out = s.stdout.read().decode("GBK")
s.stdout.close()
print(out)
```

通过`s.stdin.write()`可以输入数据，而`s.stdout.read()`则能输出数据。
