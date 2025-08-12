# 异步 IO

参考：<https://docs.python.org/3/library/asyncio-queue.html>

[Async IO in Python: A Complete Walkthrough](https://realpython.com/async-io-python/)

<https://blog.csdn.net/Run_Bomb/article/details/117819932>

如果程序中存在 IO 操作，如读写文件、发送网络数据时，就需要等待 IO 操作完成，才能继续进行下一步操作。这种情况称为同步 IO。

多线程和多进程的模型虽然解决了并发问题，但是系统不能无上限地增加线程。由于系统切换线程的开销也很大，所以，一旦线程数量过多，CPU 的时间就花在线程切换上了，真正运行代码的时间就少了，结果导致性能严重下降。

另一种解决 IO 问题的方法是异步 IO。当代码需要执行一个耗时的 IO 操作时，它只发出 IO 指令，并不等待 IO 结果，然后就去执行其他代码了。一段时间后，当 IO 返回结果时，再通知 CPU 进行处理。

## async/await

传统的 `生产者-消费者` 模型是一个线程写消息，一个线程取消息，通过锁机制控制队列和等待，但一不小心就可能死锁。

如果改用协程，生产者生产消息后，直接通过`yield`跳转到消费者开始执行，待消费者执行完毕后，切换回生产者继续生产，效率极高：

```python
import asyncio

async def main():
    print('Hello ...')
    await asyncio.sleep(1)
    print('... World!')

asyncio.run(main())
```
