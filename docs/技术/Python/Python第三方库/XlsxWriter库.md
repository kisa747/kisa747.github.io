# XlsxWriter 库

参考官方文档：<https://xlsxwriter.readthedocs.io/index.html>

XlsxWriter 是用来全新创建 Excel 文件的 Python 库，Pandas 默认使用 XlsxWriter 引擎创建 Excel 文件。

优点：

> * 语法简洁、优美、易读、易用。
> * 官方文档详实、优秀。

## 示例

使用上下文管理，可以自动保存、关闭工作簿。

```python
with xlsxwriter.Workbook('hello_world.xlsx') as workbook:
    worksheet = workbook.add_worksheet()
    worksheet.write('A1', 'Hello world')

    # 冻结首行
    worksheet.freeze_panes(1, 0)

    # Center the printed page horizontally.
    worksheet.center_horizontally()

    # Center the printed page vertically.
    worksheet.center_vertically()

    # 设定列的样式
 cell_format = workbook.add_format({'align':'center'})  # 定义单元格样式
 worksheet.set_column('A:A', 12, cell_format)  # 设置 A 列的单元格样式
    worksheet.set_column(0, 0, 12, cell_format)  # 设置 A 列的单元格样式
```
