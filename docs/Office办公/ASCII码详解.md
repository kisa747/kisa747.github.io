# ASCII 码详解

参考：[ASCII 码详解](http://www.cnblogs.com/Fightingbirds/articles/ascii.html)

ASCII 码大致可以分作三部分组成。

## 第一部分 ASCII 非打印控制字符

ASCII 表上的数字 0–31 分配给了控制字符。用于控制像打印机等一些外围设备。例如，12 代表换页/新页功能。此命令指示打印机跳到下一页的开头。

## 第二部分 ASCII 打印字符

ASCII 表上的数字 32–126 分配给了能在键盘上找到的字符。当您查看或打印文档时就会出现。数字 127 代表 DELETE 命令。

## 第三部分 扩展 ASCII 打印字符

扩展的 ASCII 字符满足了对更多字符的需求。扩展的 ASCII 包含 ASCII 中已有的 128 个字符（数字 0–32 显示在下图中），又增加了 128 个字符，总共是 256 个。即使有了这些更多的字符，许多语言还是包含无法压缩到 256 个字符中的符号。因此，出现了一些 ASCII 的变体来囊括地区性字符和符号。例如，许多软件程序把 ASCII 表（又称作 ISO8859-1）用于北美、西欧、澳大利亚和非洲的语言。

## ASCII 码表 0-127

| Dec  |          缩写/字符          |     解释     |
| :--: | :-------------------------: | :----------: |
|  0   |          NUL(null)          |    空字符    |
|  1   |   SOH(start of headling)    |   标题开始   |
|  2   |     STX (start of text)     |   正文开始   |
|  3   |      ETX (end of text)      |   正文结束   |
|  4   |  EOT (end of transmission)  |   传输结束   |
|  5   |        ENQ (enquiry)        |     请求     |
|  6   |      ACK (acknowledge)      |   收到通知   |
|  7   |         BEL (bell)          |     响铃     |
|  8   |       BS (backspace)        |     退格     |
|  9   |     HT (horizontal tab)     |  水平制表符  |
|  10  | LF (NL line feed, new line) |    换行键    |
|  11  |      VT (vertical tab)      |  垂直制表符  |
|  12  | FF (NP form feed, new page) |    换页键    |
|  13  |    CR (carriage return)     |    回车键    |
|  14  |       SO (shift out)        |   不用切换   |
|  15  |        SI (shift in)        |   启用切换   |
|  16  |   DLE (data link escape)    | 数据链路转义 |
|  17  |   DC1 (device control 1)    |  设备控制 1   |
|  18  |   DC2 (device control 2)    |  设备控制 2   |
|  19  |   DC3 (device control 3)    |  设备控制 3   |
|  20  |   DC4 (device control 4)    |  设备控制 4   |
|  21  | NAK (negative acknowledge)  |   拒绝接收   |
|  22  |   SYN (synchronous idle)    |   同步空闲   |
|  23  |  ETB (end of trans. block)  |  传输块结束  |
|  24  |        CAN (cancel)         |     取消     |
|  25  |     EM (end of medium)      |   介质中断   |
|  26  |      SUB (substitute)       |     替补     |
|  27  |        ESC (escape)         |     溢出     |
|  28  |     FS (file separator)     |  文件分割符  |
|  29  |    GS (group separator)     |    分组符    |
|  30  |    RS (record separator)    |  记录分离符  |
|  31  |     US (unit separator)     |  单元分隔符  |
|  32  |           (space)           |     空格     |
|  33  |              !              |              |
|  34  |              "              |              |
|  35  |              #              |              |
|  36  |              $              |              |
|  37  |              %              |              |
|  38  |              &              |              |
|  39  |              '              |              |
|  40  |              (              |              |
|  41  |              )              |              |
|  42  |              *              |              |
|  43  |              +              |              |
|  44  |              ,              |              |
|  45  |              -              |              |
|  46  |              .              |              |
|  47  |              /              |              |
|  48  |              0              |              |
|  49  |              1              |              |
|  50  |              2              |              |
|  51  |              3              |              |
|  52  |              4              |              |
|  53  |              5              |              |
|  54  |              6              |              |
|  55  |              7              |              |
|  56  |              8              |              |
|  57  |              9              |              |
|  58  |              :              |              |
|  59  |              ;              |              |
|  60  |              <              |              |
|  61  |              =              |              |
|  62  |              >              |              |
|  63  |              ?              |              |
|  64  |              @              |              |
|  65  |              A              |              |
|  66  |              B              |              |
|  67  |              C              |              |
|  68  |              D              |              |
|  69  |              E              |              |
|  70  |              F              |              |
|  71  |              G              |              |
|  72  |              H              |              |
|  73  |              I              |              |
|  74  |              J              |              |
|  75  |              K              |              |
|  76  |              L              |              |
|  77  |              M              |              |
|  78  |              N              |              |
|  79  |              O              |              |
|  80  |              P              |              |
|  81  |              Q              |              |
|  82  |              R              |              |
|  83  |              S              |              |
|  84  |              T              |              |
|  85  |              U              |              |
|  86  |              V              |              |
|  87  |              W              |              |
|  88  |              X              |              |
|  89  |              Y              |              |
|  90  |              Z              |              |
|  91  |              [              |              |
|  92  |              \              |              |
|  93  |              ]              |              |
|  94  |              ^              |              |
|  95  |              _              |              |
|  96  |              `              |              |
|  97  |              a              |              |
|  98  |              b              |              |
|  99  |              c              |              |
| 100  |              d              |              |
| 101  |              e              |              |
| 102  |              f              |              |
| 103  |              g              |              |
| 104  |              h              |              |
| 105  |              i              |              |
| 106  |              j              |              |
| 107  |              k              |              |
| 108  |              l              |              |
| 109  |              m              |              |
| 110  |              n              |              |
| 111  |              o              |              |
| 112  |              p              |              |
| 113  |              q              |              |
| 114  |              r              |              |
| 115  |              s              |              |
| 116  |              t              |              |
| 117  |              u              |              |
| 118  |              v              |              |
| 119  |              w              |              |
| 120  |              x              |              |
| 121  |              y              |              |
| 122  |              z              |              |
| 123  |              {              |              |
| 124  |             \|              |              |
| 125  |              }              |              |
| 126  |              ~              |              |
| 127  |        DEL (delete)         |     删除      |
