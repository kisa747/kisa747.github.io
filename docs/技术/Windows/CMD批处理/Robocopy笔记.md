## robocopy 命令

命令详解

```sh
# 基本用法
ROBOCOPY source destination [file [file]...] [options]

robocopy "%source%" "%des%" /MIR /XJ /MT:32 /R:3 /XF %xf% /XD %xd%
# /S :: 复制子目录，但不复制空的子目录。
# /E :: 复制子目录，包括空的子目录。
# /MIR 镜像目录树 (等同于 /E 加 /PURGE)
# /XJ :: 排除接合点和符号链接。(默认情况下通常包括)
# /MT[:n] :: 使用 n 个线程进行多线程复制 (默认值为 8)。n 必须至少为 1，但不得大于 128
# /R:n :: 失败副本的重试次数：默认为 1 百万
# /XF 文件 [文件]... :: 排除与给定名称/路径/通配符匹配的文件。
# /XD 目录 [目录]... :: 排除与给定名称/路径匹配的目录。
# /COPY:复制标记:: 要复制的文件内容 (默认为 /COPY:DAT)。(复制标记：D=数据，A=属性，T=时间戳)。(S=安全=NTFS ACL，O=所有者信息，U=审核信息)。
```

>注意：robocopy 不会在 dest 创建相应的目录，因此需要在 dest 指定与 soure 相同的文件夹。

The return code from Robocopy is a bitmap，参考：<https://ss64.com/nt/robocopy-exit.html>

<https://docs.microsoft.com/zh-cn/windows-server/administration/windows-commands/robocopy>

> 返回值小于等于 7 都是正常的，没有错误发生。大于等于 8 意味着发生了错误。
>
> 任何大于 **8** 的值都表示在复制操作过程中至少出现一次失败。

```sh
if ERRORLEVEL 8  (echo 复制出现错误！) else (echo 复制成功！)
```

You can use this in a batch file to report anomalies, as follows:

```sh
if %ERRORLEVEL% EQU 16 echo ***FATAL ERROR*** & goto end
if %ERRORLEVEL% EQU 15 echo OKCOPY + FAIL + MISMATCHES + XTRA & goto end
if %ERRORLEVEL% EQU 14 echo FAIL + MISMATCHES + XTRA & goto end
if %ERRORLEVEL% EQU 13 echo OKCOPY + FAIL + MISMATCHES & goto end
if %ERRORLEVEL% EQU 12 echo FAIL + MISMATCHES& goto end
if %ERRORLEVEL% EQU 11 echo OKCOPY + FAIL + XTRA & goto end
if %ERRORLEVEL% EQU 10 echo FAIL + XTRA & goto end
if %ERRORLEVEL% EQU 9 echo OKCOPY + FAIL & goto end
if %ERRORLEVEL% EQU 8 echo FAIL & goto end
if %ERRORLEVEL% EQU 7 echo OKCOPY + MISMATCHES + XTRA & goto end
if %ERRORLEVEL% EQU 6 echo MISMATCHES + XTRA & goto end
if %ERRORLEVEL% EQU 5 echo OKCOPY + MISMATCHES & goto end
if %ERRORLEVEL% EQU 4 echo MISMATCHES & goto end
if %ERRORLEVEL% EQU 3 echo OKCOPY + XTRA & goto end
if %ERRORLEVEL% EQU 2 echo XTRA & goto end
if %ERRORLEVEL% EQU 1 echo OKCOPY & goto end
if %ERRORLEVEL% EQU 0 echo No Change & goto end
:end
```

ROBOCOPY Exit Codes .The return code from Robocopy is a bitmap, defined as follows:

```sh
Hex   Decimal  Meaning if set

0×00   0       No errors occurred, and no copying was done.
The source and destination directory trees are completely synchronized.

0×01   1       One or more files were copied successfully (that is, new files have arrived).

0×02   2       Some Extra files or directories were detected. No files were copied
Examine the output log for details.

0×04   4       Some Mismatched files or directories were detected.
Examine the output log. Housekeeping might be required.

0×08   8       Some files or directories could not be copied
(copy errors occurred and the retry limit was exceeded).
Check these errors further.

0×10  16       Serious error. Robocopy did not copy any files.
Either a usage error or an error due to insufficient access privileges
on the source or destination directories.
```

These can be combined, giving a few extra exit codes:

```sh
0×03   3       (2+1) Some files were copied. Additional files were present. No failure was encountered.

0×05   5       (4+1) Some files were copied. Some files were mismatched. No failure was encountered.

0×06   6       (4+2) Additional files and mismatched files exist. No files were copied and no failures were encountered.
This means that the files already exist in the destination directory

0×07   7       (4+1+2) Files were copied, a file mismatch was present, and additional files were present.
```

Any value greater than 7 indicates that there was at least one failure during the copy operation.

## 比较 2 个目录的差异

参考：<https://www.sysgeek.cn/windows-compare-folders/>

Windows 下可以使用 robocopy 工具比较两个目录的差异。

```sh
@echo off

robocopy source des /l /fp /njh /njs

echo.
echo =======================================
echo.
if errorlevel 1 (
 echo 两个目录发生了变化
) else (
 echo 两个目录一样
)
echo.
echo =======================================
echo.
pause
```

命令参数解释：

用于文件夹对比的 Robocopy 可选参数如下：

- `<源文件夹路径>`: 要比较的源文件夹的路径。
- `<目标文件夹路径>`: 要比较的目标文件夹的路径。
- `/L`: 执行一个测试运行，不实际复制任何文件，只输出将执行的操作。
- `/E`: 复制子目录，包括空的子目录。
- `/NS`: 不要在输出中显示文件大小。
- `/NC`: 不要在输出中显示文件类别。
- `/NJH`: 不要在输出中显示 Job Header。
- `/NJS`: 不要在输出中显示 Job Summary。
- `/NP`: 不要在输出中显示进度百分比。
- `/LOG:<日志文件路径>`: 将输出信息记录到指定的日志文件中。
