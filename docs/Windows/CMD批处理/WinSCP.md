## 同步远程目录

官方示例：<https://winscp.net/eng/docs/guide_automation>

首先创建一个批处理

`local`, changes from remote directory are applied to local directory

`remote`, changes from the local directory are applied to the remote directory.

`both`, both local and remote directories can be modified.

When directories are not specified, current working directories are synchronized.

Note: Overwrite confirmations are always off for the command.

|  Switch   | Description                                                  |
| :-------: | :----------------------------------------------------------- |
| `-delete` | Delete obsolete files. Ignored for `both` mode.              |
| `-mirror` | [Mirror mode](https://winscp.net/eng/docs/task_synchronize_full#mode) (synchronize also older files). Ignored for `both` mode. |

官方的脚本示例：<https://winscp.net/eng/docs/scripts>

```sh
@echo off

set REMOTE_PATH=/home/user/test.txt
winscp.com /command ^
    "open mysession" ^
    "stat %REMOTE_PATH%" ^
    "exit"

if %ERRORLEVEL% neq 0 goto error

echo File %REMOTE_PATH% exists
rem Do something
exit /b 0

:error
echo Error or file %REMOTE_PATH% not exists
exit /b 1
```
