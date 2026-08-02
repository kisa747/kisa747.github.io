# python-office 笔记

## 笔记

python-office 官方文档：<https://www.python-office.com/office/excel.html>

```sh
# 整个下载完竟然要 1.19G，共计 332 个包，简直是丧心病狂
uv add python-office
```

使用

```python
# 导入这个库：python-office，简写为 office
import office

office.excel.excel2pdf(excel_path, pdf_path)
```

暂时还没有找到必须要用这个库的理由，等有需求了，再学习。
