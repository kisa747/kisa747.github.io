# 批处理 For 语句笔记

## 基本用法

```sh
# 遍历字符串列表
for %%i in (c d e) do (echo %%i)
# 查找当前运行目录下后缀名为 lnk 的文件
for %%i in (*.lnk) do (echo %%i)

# 读取文本文件中的内容
for /f %%i in (1.txt) do ( echo %%i)
# 遍历命令执行结果
for /f %%i in ('命令语句') do (……)
# 遍历字符串列表
for /f %%i in ("字符串") do (……)

# 如果文件名中空格，使用 usebackq 参数
for /f "usebackq" %%i in ("文件名") do (……)

# 常用的命令
# 查找当前目录，不递归
for /f %%i in ('dir /ad /b') do (……)
# 查找当前目录，递归
for /f %%i in ('dir /ad /b /s') do (……)
```
