# 7-zip 命令行用法

## 7-zip 简介

7zip 的命令行程序是程序目录下的 `7z.exe`，并且依赖 `7z.dll`。

命令行用法：

```sh
7z <command> [<switches>...] <archive_name> [<file_names>...] [@listfile]
```

简单示例：

```sh
# 将目录打包为 7z 压缩包
# 不需要显式地指明压缩格式（`-t` 参数），7zip 会自动根据压缩文件的后缀名使用对应的格式。
7z a D:\test.7z D:\test
```

## 主命令

第一个 command 参数必须是不带 `-` 的必选参数：a、u、e（解压）、x（Extract with full paths）

可用的 command：

| 命令 | 含义                                                         |
| :--: | ------------------------------------------------------------ |
| `a`  | Add files to archive 创建新的压缩文件。目标压缩包已经存在，则会覆盖然后创建新的压缩包。 |
| `b`  | enchmark                                                     |
| `d`  | Delete files from archive                                    |
| `e`  | Extract files from archive (without using directory names) 解压缩。 |
| `h`  | Calculate hash values for files                              |
| `i`  | Show information about supported formats                     |
| `l` | List contents of archive                                     |
| `rn` | Rename files in archive                                      |
| `t`  | Test integrity of archive                                    |
| `u`  | Update files to archive 更新压缩包中旧的文件，并添加压缩包中不存在的文件。 |
| `x`  | eXtract files with full paths                                |

> `a` 命令是创建新的压缩文件。目标压缩包已经存在，则会覆盖，创建新的压缩包。
>
> `u` 命令是更新压缩包。源文件删除，压缩包中不会删除。如果没有更新，不会修改压缩包，所以没有更新时，速度很快。可以配合 `-u` 选项使用

## 选项

### 主要选项

>-i (包括文件名)
>
>-m (设置压缩算法) 一般不用设置，会根据压缩包后缀名自动选择合适的压缩算法。
>
>-p (设置密码)
>
>-r (递归子目录)
>
>-t (设置压缩档案格式) 一般不用设置，会根据压缩包后缀名自动选择合适的压缩格式。
>
>-u (更新选项，与 u 主命令配合使用)
>
>-w (设置工作目录)
>
>-x (排除文件)
>
>-p 设置密码
>
>-mx=9 设置压缩等级

### 更新选项

`u` 命令是更新压缩包。源文件删除，压缩包中不会删除。

如果要设置同步模式，即源文件删除，压缩包中也删除，同步更新所有内容。需要 `u` 命令添加 `-uq0` 参数。示例：

```bash
# 同步模式更新压缩包
7z u -uq0 D:\test.7z D:\test
```

### 设置密码

```sh
# -p{Password} : set Password
7z a -p123 -mhe D:\test.7z D:\test
# -p123 设置密码为：123
# -mhe 加密 header，也就是加密文件名。-mhe 与-p 参数一起使用才有效。
```

### 压缩等级

```sh
# -m{Parameters} : set compression Method
# -mmt[N] : set number of CPU threads
# -mx[N] : set compression level: -mx1 (fastest) ... -mx9 (ultra)
7z a -mmt4 -mx9 D:\test.7z D:\test
# 默认 5，标准压缩；0 不压缩；9，极限压缩；0、1、3、5、7、9 共 6 个等级。
# 7z 格式下，默认使用 LZMA2 算法。
```

### 排除（包含）指定文件

```sh
# -i[r[-|0]]{@listfile|!wildcard} : Include filenames
# -x[r[-|0]]{@listfile|!wildcard} : eXclude filenames
# 递归排除所有的 db 文件。
7z a D:\test.7z D:\test -xr!*.db
```

`-xr` 递归选项必须开启，因为要匹配子目录中的文件。相当于 `Path.glob()`，`Path.rglob()`

`-x` 排除指定文件选项。

`-i`包括指定文件和通配符。

`-r` 启用递归选项。只要不是想要递归通配特定的通配符，默认情况下都是开启递归的。

`-r-` 禁用递归选项，所有的命令默认都是这个选项。

`-r0` 仅通配符模式下启用。

`!` 使用通配符进行匹配。`@` 使用 listfile 文件进行匹配。可以将要匹配的规则写到一个文件中，用换行符隔开，文件需用 utf-8 编码。

比如：

```ini
# 使用排除文件
7z u -mx=9 D:\test.7z D:\test -xr@exclude.txt

# exclude.txt 如下：
*.db
*.pyc
.*
```

注意：

>通配符中不能包含盘符。因为前面已经指定递归匹配了，而且指定了目录，通配符中再包含盘符的话，肯定什么也匹配不到。
> 7z 通配符与 windows 操作系统的不同。`*.*` 不匹配所有文件，而是匹配有扩展名的文件，要匹配所有文件，使用 `*` 。

### 速度测试

速度最快的压缩方式：

```sh
7z a -mx=0 D:\test.7z D:\test
7z a -mx=0 D:\test.zip D:\test
```

实际测试压缩 2 万个文件，7z：92.55s，zip：96.99s。
