# PDF 文件添加目录书签

1. 安装 pdftk 工具

```sh
scoop install pdftk
```

2. 使用 AI 生成目录文件

使用 Deepseek（豆包怎么试都不行），上传 PDF 文件，对话框中输入：

>生成 PDF 文件的 pdftk 格式目录，包含“前言、目录”

输出：

```ini
BookmarkBegin
BookmarkTitle: 目录
BookmarkLevel: 1
BookmarkPageNumber: 4
BookmarkBegin
BookmarkTitle: 1 总则
BookmarkLevel: 1
BookmarkPageNumber: 5
BookmarkBegin
BookmarkTitle: 1.1 目的
BookmarkLevel: 2
BookmarkPageNumber: 5
BookmarkBegin
BookmarkTitle: 1.2 适用范围
BookmarkLevel: 2
BookmarkPageNumber: 5
......
BookmarkBegin
BookmarkTitle: 附件G 特种设备检验意见通知书(2)
BookmarkLevel: 1
BookmarkPageNumber: 90
```

将输出内容以`UTF8` 编码保存为 `toc.txt`。

3、使用 pdftk 工具生成目录

```sh
pdftk test.pdf update_info_utf8 toc.txt output test_带目录.pdf
```
