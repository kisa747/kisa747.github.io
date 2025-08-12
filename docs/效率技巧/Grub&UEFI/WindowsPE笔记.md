# WindowsPE 笔记

## 创建可启动 ISO 镜像

参考：<https://docs.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/oscdimg-command-line-options>

参考：<https://blog.csdn.net/xcntime/article/details/51472998>

使用 `mkisofs` 始终无法完美解决中文文件名的问题，因此使用微软的 `oscdimg` 命令行工具，Windows 下不会产生乱码，也能生成可引导的 ISO 文件。

```sh
# Oscdimg [ <options> ] <sourceLocation> <destinationFile>

oscdimg -u1 -o -m -h -b"%filename%\GRLDR" -l"%filename%" "%filename%" "%filename%.iso"

rem -u1 生成具有 UDF 文件系统和 ISO 9660 文件系统的映像。 通过使用与 DOS 兼容 8.3 文件名称进行编写 ISO 9660 文件系统。 通过使用 Unicode 文件的名称进行编写的 UDF 文件系统。
rem -u2 仅生成 UDF 文件系统。
rem -o 使用 MD5 哈希算法来比较文件。用于通过一次编码重复的文件来优化存储。
rem -m 忽略生成镜像的最大大小限制。
rem -h 包括隐藏文件和目录。
rem -l -llabelname 指定卷标。不能在 l 和 labelname 之间使用空格。例如，-lMYLABEL
```

## 使用 DISM 安装系统

参考：[使用 Dism++ 安装系统](https://www.chuyu.me/zh-Hans/Document.html?file=Best/使用Dism++安装系统.md)

## 制作隐藏的 UEFI 启动盘

参考：<https://www.iruanmi.com/mbr-and-gpt-partition-type-and-attributes/>

[基于 UEFI/GPT 的硬盘驱动器分区](https://docs.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/configure-uefigpt-based-hard-drive-partitions)

<https://blog.csdn.net/u010059669/article/details/71480115>

<https://blog.csdn.net/ytfy12/article/details/89134534>

```sh
# 管理员权限运行 PowerShell
# 运行 diskpart 工具
diskpart
# 列出所有磁盘卷
lis vol
# 选中 u 盘，视你的磁盘大小判断选择数字，2 是我的 u 盘
sel vol 6
# 查看该分区详细信息
detail par
# 这时候能看到：
# 类型    : ebd0a0a2-b9e5-4433-87c0-68b6b72699c7
# 隐藏：是
# 属性  : 0000000000000000

# 设为隐藏属性
gpt attributes=0x8000000000000000
remove
exit
# ---------------------------------------------
# 设为可见
gpt attributes=0x0000000000000000
ASSIGN LETTER=H
# ---------------------------------------------
# 设置为 EFI 分区
set id=C12A7328-F81F-11D2-BA4B-00A0C93EC93B
# 设置为可见普通分区
set id=ebd0a0a2-b9e5-4433-87c0-68b6b72699c7
# WinRE 恢复环境分区、系统备份分区
set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
```

## PE 的目录结构

```sh
├─EFI
│  │  install_grub.cmd   # 安装 UEFI 下的 grub 的批处理
│  │
│  ├─boot
│  │      bootx64.efi    # Fallback 回退的 EFI 启动文件，使用 grub-mkimage.exe 命令生成的
│  │
│  └─grub
│      │  grub.cfg       # GRUB 配置文件
│      │  grub.efi       # GRUB 启动文件，与 bootx64.efi 为同一个文件
│      │
│      ├─fonts
│      │      unicode.pf2  # GRUB 自带的字体文件
│      │      WenQuanYiMicroHeiMono24px.pf2  # 使用 grub-mkfont 命令生成的字体
│      │
│      ├─locale
│      │      zh_CN.mo    # 中文支持模块
│      │
│      ├─themes           # GRUB 主题
│      │  └─kisa747
│      │      │  background.png
│      │      │  ...
│      │      │  theme.txt
│      │      │
│      │      └─icons
│      │              antergos.png
│      │              ...
│      │              xubuntu.png
│      │
│      └─x86_64-efi     # GRUB 支持模块
│              acpi.mod
│              ...
│              zstd.mod
│
└─WEPE
        BCD                         # 启动文件，用批处理命令生成的。用来引导 sdi、WIM 文件
        boot.efi                    # 从 WIM 镜像中提取 ([sources/install.wim]/Windows/Boot/EFI/bootmgfw.efi)
                                    # 也可以从 ESP 分区中提取（\EFI\Microsoft\Boot\bootmgfw.efi）
        boot.sdi                    # 启动文件。从微 PE 中提取的"WEPE.SDI"改名而来。
                                    # wim 启动时这个 boot.sdi 虚拟成 x:盘，供 wim 文件挂载之用
        install_mgr.cmd             # 将 PE 安装至 bootmgr 菜单。管理员运行。
        uninstall_mgr.cmd           # 卸载 bootmgr 中的 PE 菜单。管理员运行。
        uninstall_UEFI_GRUB.cmd     # 卸载 EFI 菜单
        WEPE64.WIM                  # 微 PE 文件，uefi 模式下必须要用 wim 格式才行。

# boot.sdi
# boot.sdi 就是一个空的 IMAGE 虚拟磁盘文件，用于挂载 系统盘，PE 通常为 X: ，可以用  DiskGenius 等加载和编辑
# 对比 Linux，Linux 采用虚拟文件系统，所以不需要类似的东西，全部都挂载到根目录 / 下面，而 Windows 采用实体文件系统，所以需要一个空的虚拟磁盘文件挂载，分区，格式化，作为系统分区。
```

## 制作 GRUB 引导光盘

在 Debian 下操作：

```sh
# 安装 mtools 工具合集
sudo apt-get install mtools

# 创建目录
mkdir -p efi/boot
# 将 bootx64.efi 文件放至 efi/boot 目录下

# 创建一个空的 efi.img 软盘镜像，并格式化为 FAT16
mformat -C -f 2880 -L 16 -i ./efi.img ::.
# 将 efi 目录复制至 efi.img 镜像内
mcopy -s -i ./efi.img ./efi ::/.
```

将得到的 efi.iimg 复制到 windows 环境下，在 windows 下操作。

将 efi.img 复制至光盘根目录，使用 oscdimg 命令创建可启动光盘

```sh
oscdimg -u1 -o -m -h -b"iso\efi.img" -l"iso" iso "grub.iso"
```

## 创建可启动 Windows PE (没用)

参考：<https://docs.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/oem-deployment-of-windows-10-for-desktop-editions>

<https://blog.csdn.net/caoshiying/article/details/78341463>

1. 下载与你要安装的 Windows 版本匹配的 [Windows ADK](https://developer.microsoft.com/windows/hardware/windows-assessment-deployment-kit#winADK) 版本。

2. 运行 ADK 安装程序以安装 ADK，使用以下选项。如果你使用适用于 Windows 10 ADK。版本 1809 WinPE 不是 ADK 安装程序的一部分，和是一个单独的加载项包，您必须安装后安装 ADK:

   - **部署工具**
   - **用户状态迁移工具 (USMT)**
   - **Windows 预安装环境 (Windows PE)**

准备 WinPE 文件

1. 在技术人员电脑上，以管理员身份启动**部署和映像工具环境**：
   - 单击**开始**，键入**部署和映像工具环境**。右键单击**部署和映像工具环境**，然后选择**以管理员身份运行**。
2. 使用`copype`创建具有基本的 WinPE 文件的工作目录：

```sh
@echo off
cd /d "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools"
call "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\DandISetEnv.bat"
set DISMROOTDIR=C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs
set WORKDIR=D:\winpe_amd64
copype amd64 %WORKDIR%
Dism /mount-image /imagefile:%WORKDIR%\media\sources\boot.wim /index:1 /mountdir:%WORKDIR%\mount
dism /Get-Packages /Image:%WORKDIR%\mount

DISM /image:%WORKDIR%\mount /Cleanup-image /StartComponentCleanup
set WORKDIR=D:\winpe_amd64
Dism /Unmount-Image /MountDir:"%WORKDIR%\mount" /commit

dism /export-image /sourceimagefile:%WORKDIR%\media\sources\boot.wim /sourceindex:1 /DestinationImageFile:%WORKDIR%\winpe64.wim
copy /y %WORKDIR%\winpe64.wim %WORKDIR%\media\sources\boot.wim
```

设置中文支持：

```sh
# 更改为中文：
rem 更改为中文语言
dism /image:%WORKDIR%\mount /Set-AllIntl:zh-CN
rem 更改输入法区域
dism /image:%WORKDIR%\mount /set-inputlocale:0804:00000804
rem 设置时区
dism /image:%WORKDIR%\mount /set-timezone:"China Standard Time"
dism /image:%WORKDIR%\mount /set-SKUIntlDefaults:zh-CN
```

## 自定义 RE（没用）

> 没啥卵用，还不如写个脚本，在 PE 下执行。

参考微软官方文档 [Windows 恢复环境 (Windows RE)](https://docs.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/windows-recovery-environment--windows-re--technical-reference)

windows 系统默认就安装了 windowsRE，位置在`C:\Recovery\WindowsRE\Winre.wim`，windows 的系统光盘内也有这个文件，经过哈希对比，两个文件是一致的，下面以提取 Windows 10 镜像为例。

将 Windows 10 镜像光盘挂载至 `H` 盘，以下均是管理员权限运行命令提示符。

```sh
md D:\mount & cd /d D:\mount
xcopy H:\sources\install.wim D:\mount
md D:\mount\windows
Dism /mount-image /imagefile:D:\mount\install.wim /index:1 /mountdir:D:\mount\windows
xcopy D:\mount\windows\windows\system32\recovery\* D:\mount
Dism /unmount-image /mountdir:D:\mount\windows /discard

md D:\mount\winre
Dism /mount-image /imagefile:D:\mount\winre.wim /index:1 /mountdir:d:\mount\winre
```

定制 RE

```sh
md D:\mount\winre\sources\recovery\tools
xcopy /y D:\mount\tools\* D:\mount\winre\sources\recovery\tools

Dism /unmount-image /mountdir:D:\mount\winre /commit

Reagentc /setreimage /path C:\WinRE /target C:\Windows
验证 Windows RE 信息：
reagentc /info
```
