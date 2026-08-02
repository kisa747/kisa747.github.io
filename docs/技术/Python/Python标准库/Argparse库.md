# Argparse 标准库

argsparse 是 python 的命令行解析的标准模块，内置于 python，不需要额外安装。这个库可以让我们直接在命令行中就可以向程序中传入参数并让程序运行。

官方文档：<https://docs.python.org/zh-cn/3/howto/argparse.html>

参考：<https://zhuanlan.zhihu.com/p/138294710>

参考：<https://docs.python.org/zh-cn/3/library/argparse.html>

如何把 python 脚本变为一个命令行工具。

示例：

```python
import argparse

def main():
    """

    可以直接在命令行使用的工具，底层使用 xlwings 模块。

    Examples
    --------
    将目录内的所有 xls 文件批量转换为 xlsx 文件，导出至 "D:\Excel_xlsx"
    python -m pyexcel --xlsx "D:\Excel"
    将指定的 xls 文件转换为 xlsx 文件，导出至文件同目录
    python -m pyexcel --xlsx "D:\test.xls"

    将目录内的所有 xlsx 文件批量导出为 pdf 文件，导出至 "D:\Excel_pdf"
    python -m pyexcel --pdf "D:\Excel"
    将指定的 xlsx 文件导出为 pdf 文件，导出至文件同目录
    python -m pyexcel --pdf  "D:\test.xls"

    :return: None
    """
    # action='store'，默认为 store，所以可以省略。, type=str，默认为字符串，也可以省略。
    arg_parser = argparse.ArgumentParser(prog='pyexcel', description='使用 xwings 处理 excel 文件')
    arg_parser.add_argument('-x', '--xlsx', metavar='目录或文件', help='将 xls 文件或目录转换为 xlsx')
    arg_parser.add_argument('-p', '--pdf', metavar='目录或文件', help='将 excel 文件转换为 pdf（所有工作表）')
    arg_parser.add_argument('-d', '--dropformula', metavar='目录或文件', help='将 excel 文件的公式清除')
    arg_parser.add_argument('-m', '--merge', metavar='目录', help='合并文件夹下所有 excel 文件至一个 excel 文件')
    arg_parser.add_argument('-s', '--split', metavar='文件', help='将 excel 文件的工作表拆分至不同的工作簿')
    args = arg_parser.parse_args()
    if args.xlsx:
        logging.debug(f'args.convert 参数是：{args.xlsx}')
        convert_excel(args.xlsx, method='to_xlsx')
    if args.pdf:
        convert_excel(args.pdf, method='to_pdf')
    if args.dropformula:
        convert_excel(args.dropformula, method='dropformula')
    if args.merge:
        excel_merge(args.merge)
    if args.split:
        excel_split(args.split)
```
