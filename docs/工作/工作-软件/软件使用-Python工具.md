# Python 工具

## 广联达报表处理

```sh
# 合并 表 8
python -m glodon -m 目录
python -m glodon -merge_report8 目录
```

## PDF 处理

```sh
# PDF 文件添加页码
uvr -m xpdf -a test.pdf

# 非递归合并目录下的所有 pdf
uvr -m xpdf -m 目录

# 递归合并目录下的所有 pdf
uvr -m pdf -mr 目录
```
