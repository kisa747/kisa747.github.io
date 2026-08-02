## 查看电池报告

管理员权限执行：

```sh
powercfg /batteryreport /output E:\battery-report.html
```

## 查看信息

```sh
# 查看系统信息
systeminfo

# 系统信息
msinfo32

# DirectX 诊断工具
dxdiag


wmic freedisk     # 查看每一个盘的剩余空间。
wmic diskdrive    # 可以看出牌子和大小。
wmic logicaldisk  # 可以看到有几个盘，每一个盘的文件系统和剩余空间。
wmic volume       # 每个盘的剩余空间量，其实上一个命令也可以查看的。
fsutil volume diskfree c:  # 查看每一个卷的容量信息是很方便的。
```

## 用户管理

```sh
netplwiz
```

## 查看硬盘类型

如何判断硬盘是 HDD 还是 SSD

方法一：PowerShell 执行以下命令：

```powershell
PS C:> Get-PhysicalDisk

Number FriendlyName               SerialNumber                             MediaType CanPool OperationalStatus HealthSt
                                                                                                               atus
------ ------------               ------------                             --------- ------- ----------------- --------
0      SAMSUNG MZALQ512HALU-000L2 0025_38A4                                SSD       False   OK                Healthy
1      KIOXIA-EXCERIA SSD         0000_0000_0000                           SSD       False   OK                Healthy
```

## 播放语音

创建 `播放.vbs` ，内容如下：

```vb
CreateObject("SAPI.SpVoice").Speak "你真帅！"
```
