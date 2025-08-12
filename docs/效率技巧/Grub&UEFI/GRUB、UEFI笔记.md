# UEFI 与 GRUB

现在新出厂的电脑都自带了 UEFI BIOS，新版的自由软件 GRUB 名称其实是 GRUB2，旧版的其实很少用了，所以就直接用 GRUB 代指 最新版的 GRUB。

## UEFI

`UEFI` 程为统一可扩展固件接口（英语：Unified Extensible Firmware Interface，缩写 UEFI），是一种个人电脑系统规格，用来定义操作系统与系统固件之间的软件界面，作为 `BIOS` 的替代方案。可扩展固件接口负责加电自检（POST）、联系操作系统以及提供连接操作系统与硬件的接口。官方网站：<https://uefi.org>

UEFI 的前身是 Intel 在 1998 年开始开发的 Intel Boot Initiative，后来被重命名为**可扩展固件接口**（Extensible Firmware Interface，缩写**EFI**）。Intel 在 2005 年将其交由统一可扩展固件接口论坛（Unified EFI Forum）来推广与发展，为了凸显这一点，EFI 也更名为 UEFI（Unified EFI）。UEFI 论坛的创始者是 11 家知名电脑公司，包括 Intel、IBM 等硬件厂商，软件厂商 Microsoft，及 BIOS 厂商 AMI、Insyde 及 Phoenix。

### UEFI 启动流程

UEFI 下 Debian 的启动流程：

> UEFI BIOS → EFI 系统分区 → \EFI\debian\shimx64.efi → 加载\EFI\debian\grub.cfg 配置 → 查找系统根目录并加载 /boot/grub/grub.cfg 配置 → 加载内核启动系统

UEFI 下 Windows 的启动流程：

> UEFI BIOS→ESP 分区→\efi\Microsoft\boot\bootmgfw.efi→efi\Microsoft\Boot\BCD→\Windows\system32\winload.efi→加载内核启动系统

UEFI 设计是用来取代传统的 BIOS，肯定有许多优于传统 BIOS 的特点。

传统 BIOS 一般是固化在电脑主板的 ROM 里，自检后就交给磁盘的 MBR，由于 MBR（主引导记录）由三个部分组成 (共占用 512 个字节)，所以基本没有啥扩展性。

UEFI 被设计来可扩展，易开发。EFI 启动后交给 EFI 分区（磁盘的第一个 FAT32 分区），按照特定的规则加载 EFI 程序，EFI 分区可以自定义大小，所以有很高的扩展性。

### EFI 系统分区

Windows 下叫做 ESP（EFI System Partition），ESP 分区不是必须的，但一个 FAT 分区是必须的。

ESP 分区的本质：ESP 分区（EFI System Partition）是一个特殊的 FAT 分区，特殊之处在于：

> 分区类型 GUID 为：{C12A7328-F81F-11D2-BA4B-00A0C93EC93B}

但是这些参数并不影响启动，更加类似于一个人的“身份证”，然而我们 UEFI 启动可以不需要“身份证”所以从这里我们可以看出：ESP 分区可以用任意位置的任意大小的任意 FAT 分区代替。

但是电脑上仍然推荐创建一个 ESP 分区，而不是用普通的 FAT 分区做为引导分区。原因如下：

>对于 Windows 系统来说，ESP 默认不可见，即使挂载了，默认也无法通过资源管理器访问，提高了系统的安全性。
>
>对于 Linux 系统来说，系统会自动识别 ESP 分区并挂载至 `/boot/efi`，并且是只读权限，不需要要手动操作，更加方便。

### EFI 启动文件

一个标准的 EFI 系统分区的目录结构如下：

```ini
文件夹 PATH 列表
卷序列号为 ********
P:.
└─EFI
    ├─Microsoft
    │  └─Boot
    │        bootmgfw.efi
    │        BCD
    ├─boot
    │      bootx64.efi
    └─grub
       │  grub.cfg
       │  grub.efi
       ├─fonts
       │      WenQuanYiMicroHeiMono24px.pf2
       ├─locale
       │      zh_CN.mo
       ├─themes
       │       ********
       └─x86_64-efi
               acpi.mod
               ********
               zstd.mod
```

文件说明：

`/EFI/boot/bootx64.efi` 回退（Fallback）路径的启动文件。

`/EFI/Microsoft/bootmgfw.efi` Windows 的启动文件。

`/EFI/grub/grub.efi` 这个是我自己创建的自定义启动文件。

### Secure Boot 安全启动

GRUB 2.04 支持 UEFI 安全启动，最新的主流 Linux 发行版 Ubuntu、Debian、Fedora、CentOS 都已经支持 UEFI 安全启动。

~~因此可以放心地在 BIOS 中开启 Secure Boot，不用关闭 Secure Boot。~~ 如果要想启用 GRUB 的安全启动支持，要么直接复制发行版的 GRUB 核心文件，要么手动签名，两种方法都不太完美，所以暂时还是关闭安全启动比较方便。

## GRUB

下载地址：<https://ftp.gnu.org/gnu/grub/>

<https://mirrors.huaweicloud.com/gnu/grub/>

官方文档：<https://www.gnu.org/software/grub/manual/grub/grub.html>

参考：<https://wiki.archlinux.org/index.php/GRUB_(简体中文)>

<https://www.jianshu.com/p/326e71f67d58>

<https://www.cnblogs.com/f-ck-need-u/archive/2017/06/29/7094693.html>

GRUB (GRand Unified Bootloader) 既支持传统的 MBR 引导，也支持现在的主流 UEFI 引导，因此可以不用考虑使用 grub4dos 了。由于旧版的 grub  legacy 不再维护，现在说的 GRUB 默认就是 GRUB2。现在购买的品牌电脑，大部分出厂就预装了 windows 操作系统，由于微软对 OEM 厂商的要求，电脑会默认开启 Secure Boot，并且有关闭选项（为了避免垄断嫌疑）。

### GRUB 启动流程

UEF I 启动是传统 MBR 启动方式的升级版。推荐使用 UEFI + GPT 组合。

GRUB 在 UEFI 平台上的常规启动步骤是这样的：

>* 启动 UEFI
>* 加载指定的 EFI 文件
>* 设置 `prefix root cmdpath` 环境变量
>* 加载 "normal.mod" 模块 [同时还包括它所依赖的 terminal crypto extcmd boot gettext 模块]
>* 执行 `normal $prefix/grub.cfg` 命令

参考：<https://www.cnblogs.com/mahocon/p/5691348.html>

<https://www.cnblogs.com/sddai/p/6351715.html>

因为传统 BIOS 无法识别 GPT 分区，所以传统 BIOS 下 GPT 磁盘不能用于启动操作系统，在操作系统提供支持的情况下可用于数据存储。但 UEFI 可同时识别 MBR 分区和 GPT 分区，因此 UEFI 下，MBR 磁盘和 GPT 磁盘都可用于启动操作系统和数据存储。不过微软限制，UEFI 下使用 Windows 安装程序安装操作系统是只能将系统安装在 GPT 磁盘中。

UEFI 查找 EFI 文件有 2 种规则：

* 向 UEFI 添加的启动项。
* 回退路径  (Fallback path) UEFI 原生启动项。如果没有任何可用的 EFI 启动项，根据 [UEFI 规范](https://uefi.org/specifications)，UEFI 会查找所有 FAT 分区（fat16、fat32）的 `\EFI\BOOT\BOOTX64.EFI`，并引导顺序靠前的 EFI 文件。

主流的 Linux 发行版安装后，都会向 UEFI 添加自己的启动项，使用 `efibootmgr`命令可以查看、修改 UEFI 启动项。

```bash
# 查看
efibootmgr -v
[输出：]
BootCurrent: 0004
BootOrder: 0004,0000,0001,0002,0003
Boot0000* EFI VMware Virtual IDE Hard Drive (IDE 0:0)   PciRoot(0x0)/Pci(0x7,0x1)/Ata(0,0,0)
Boot0001* EFI VMware Virtual IDE CDROM Drive (IDE 1:0)  PciRoot(0x0)/Pci(0x7,0x1)/Ata(1,0,0)
Boot0002* EFI Network   PciRoot(0x0)/Pci(0x11,0x0)/Pci(0x1,0x0)/MAC(000c29b9214b,0)
Boot0003* EFI Internal Shell (Unsupported option)       MemoryMapped(11,0xef9d018,0xf3f7017)/FvFile(c57ad6b7-0515-40a8-9d21-551652854e37)
Boot0004* debian        HD(1,GPT,8ea969fc-9b50-4f4a-aaa0-fe36c35eb673,0x800,0x1dc800)/File(\EFI\debian\shimx64.efi)
```

可以看出，`Boot0004` 就是 Debian 添加的启动项。其实不用往 UEFI 添加任何启动项，它仍能自动加载 `/EFI/BOOT/BOOTX64.EFI`。因此 UEFI 启动可以完全基于文件，可以不往硬盘引导扇区写入任何数据。

UEFI 下 Debian 的启动流程：

> UEFI BIOS → ESP 分区 → \EFI\debian\shimx64.efi → 加载\EFI\debian\grub.cfg 配置 → 查找系统根目录并加载 /boot/grub/grub.cfg 配置 → 加载内核启动系统

UEFI 下 Windows 的启动流程：

> UEFI BIOS→ESP 分区→\efi\Microsoft\boot\bootmgfw.efi→efi\Microsoft\Boot\BCD→\Windows\system32\winload.efi→加载内核启动系统

注意：

>预装 Windows 的电脑会自动创建一项 `Windows Boot Manager`，指向 `\EFI\Microsoft\Boot\bootmgfw.efi`，只要启动 Windows，它就会自动修复，所以这一启动项是无法正常修改、删除的。
>
>所以安装 windows 的硬盘是无法使用回退路径（\EFI\BOOT\BOOTX64.EFI）的。
>
>如果要引导自定义的 efi 文件，有 2 个方法，1、把 `\EFI\Microsoft\Boot\bootmgfw.efi` 文件删除。2、创建自定义 EFI 启动项。

### 创建 EFI 启动项

参考：<https://askubuntu.com/questions/744697/i-need-to-see-the-bcdedit-for-a-windows10-ubuntu-install-both-by-wubi-and-by-sep>

推荐创建 EFI 启动项，而不是使用回退路径（\EFI\BOOT\BOOTX64.EFI）。原因：

>使用回退路径（\EFI\BOOT\BOOTX64.EFI）可能会有以下问题：
>
>* 安装 windows 或 Linux 操作系统，会把此文件给覆盖掉。
>* 一个硬盘只能有一个启动项。
>
>手动创建启动项就不会有这样的问题，而且便于管理，可以将不同系统的启动文件放置在不同的目录。比如 Ubuntu 会创建 \EFI\Ubuntu 目录。

#### Windows 下创建 EFI 启动项

Windows 下管理员身份运行命令提示符：

```sh
@echo off
%1 mshta vbscript:Createobject("Shell.Application").ShellExecute("%~s0","::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

rem add EFI entry
for /f "tokens=2 delims={}" %%a in ('bcdedit /copy {bootmgr} /d "grub"') do set guid={%%a}
bcdedit /set %guid% path \EFI\grub\grub.efi
bcdedit /set {fwbootmgr} displayorder %guid% /addfirst
cls
bcdedit /enum firmware
pause

rem bcdedit /delete {c9653390-a2e3-11e9-b53d-e8beb78bd2ca} /f
rem bcdedit /set {bootmgr} path \EFI\Microsoft\Boot\bootmgfw.efi
```

#### Linux 下创建 EFI 启动项

Linux 下有强大的 `efibootmgr`工具。

参考：<https://wiki.gentoo.org/wiki/Efibootmgr>

<https://cnzhx.net/blog/restore-grub2-boot-menu-with-uefi/>

```sh
# 检查系统是否为 EFI 模式
mount | grep efivars
# 列出 EFI 启动菜单
efibootmgr -v
# 添加启动项
sudo efibootmgr -c -L "grub" -d /dev/sda -p 1 -l \\EFI\\boot\\bootx64.efi
# -c | --create         create new variable bootnum and add to bootorder
# -L | --label label     Boot manager display label (defaults to "Linux")
# -d | --disk disk       (defaults to /dev/sda) 分区，即 sda。
# -p | --part part        (defaults to 1) 分区位置，即 sda1。
# -l | --loader name     EFI 启动文件，注意位置分隔符是 \\
# 默认创建的启动项会是第一顺序。

# 删除编号为 2 的启动项
sudo efibootmgr -b 5 -B
```

### 创建 GRUB 引导的 EFI 文件

根据 UEFI 启动流程，UEFI 将启动权交给了 FAT 分区的： `/EFI/BOOT/BOOTX64.EFI`。

如果要使用 GRUB 引导，只需要把 GRUB 生成的 efi 文件放到这个位置就行了。要得到 GRUB 的 efi 文件，有两种方法。

方法 1：使用 `grub-install`命令安装至指定磁盘。

```bash
# 查看安装目标磁盘的编号 DeviceID，比如 \\.\PHYSICALDRIVE5
wmic diskdrive list brief
# 使用例如下面这样的命令进行安装：
grub-install.exe --target=x86_64-efi --recheck --no-nvram --removable --locale-directory=.\locale\zh_CN --efi-directory=g: --boot-directory=g:\EFI  \\.\PHYSICALDRIVE2
```

每个参数的作用

>--target=x86_64-efi       #安装用于用于 UEFI 启动的 grub2
>
>--recheck                            #如果存在磁盘映射，将删除磁盘映射
>
>--no-nvram                       # don't update the `boot-device/Boot` NVRAM variables. This option is only available on EFI and IEEE1275 targets.
>
>--efi-directory=g:            #安装位置，根据自己的盘符更改。use DIR as the EFI System Partition root.
>
>--boot-directory=DIR    # Install GRUB images under the directory DIR/grub instead of the boot/grub directory。
>
>--removable                    #安装装置是可移动设备。如果使用了 `--removable` 选项，那 GRUB 将被安装到 `/EFI/BOOT/BOOTX64.EFI` ，此时即使 EFI 变量被重设或者你把这个驱动器接到其他电脑上，你仍可从这个驱动器上启动。通常来说，你只要像操作 BIOS 设备一样在启动时选择这个驱动器就可以了。如果和 Windows 一起多系统启动，注意 Windows 通常会在那里安装一个 EFI 可执行程序，这只是为了重建 Windows 的 UEFI 启动项。

缺点：

> 生成的 `BOOTX64.EFI` 文件查找 grub.cfg 文件是基于分区 UUID 的，不同的 U 盘都需要使用 grub-install 分别安装。

方法 2：使用 grub-mkimage 命令生成一个内嵌 grub.cfg 的 EFI 文件。

先编写一个 `x86_64-efi.cfg`，内容如下：

```ini
set prefix=($root)/EFI/grub
```

`$root` 表示启动分区，比如：`gpt0,1`。不需要显式地调用 `normal $prefix/grub.cfg`，因为根据 grub 的启动流程，grub 会自动地加载 normal.mod 模块，然后执行 `normal $prefix/grub.cfg`命令，如果要修改执行外部配置 `grub.cfg`的位置或文件名，需要将 normal 模块编译进 EFI 文件，并显示地加载它：`insmod normal.mod`。

```bash
normal [file]
# 进入普通模式，并显示GRUB菜单。
# [说明]只要当前没有处于救援模式，其实就已经是在普通模式中了，所以通常并不需要明确使用此命令。
# 在普通模式中，命令模块[command.lst]与加密模块[crypto.lst]会被自动按需载入(无需使用"insmod"命令)，并且可使用完整的GRUB脚本功能。但是其他模块则可能需要明确使用"insmod"命令来载入。
# 如果给出了"file"参数，那么将从这个文件中读入命令(也就是作为"grub.cfg"的替代)，否则将从"$prefix/grub.cfg"中读入命令(如果存在的话)。你也可以理解为"file"的默认值是'$prefix/grub.cfg'。
# 可以在普通模式中嵌套调用此命令，以构建一个嵌套的环境。不过一般不这么做，而是使用"configfile"命令来达到这目的。
# 如果要使用 normal 命令，需要将 normal 模块嵌入到grub。
#normal $prefix/grub.cfg
```

编译生成 EFI 文件：

```bash
set modules=part_gpt part_msdos fat
grub-mkimage.exe -d x86_64-efi -c x86_64-efi.cfg -p /EFI/grub -o bootx64.efi -O x86_64-efi %modules%
```

详解：

>-d x86_64-efi             表示指定查找模块目录
>
>-c x86_64-efi.cfg      表示指定配置文件，这个配置文件会集成到 efi 文件内，就是我们刚刚编写的 x86_64-efi.cfg
>
>-p  设置偏好文件夹，cfg 文件中会调
>
>-o  表示生成的目标 efi 文件
>
>-O  表示集成的模块目录。
>
>%modules%  只需要将必须的模块编译进去，其余的模块通过外部 cfg 文件加载需要的模块。
>
>只有 `part_gpt part_msdos fat` 是必须的模块，如果使用 `normal $prefix/grub.cfg` 命令，需要将 `normal` 模块编译进去。

优点：

>由于可以自由地嵌入 cfg 文件，因此可以让 efi 文件加载指定的外部配置文件。嵌入合理的 cfg 配置，可以使生成 efi 文件放到不同的 U 盘、硬盘 ESP 分区，都能很好地工作。

### GRUB 常用命令

#### 启动项添加密码保护

先使用 `grub-mkpasswd-pbkdf2` 命令创建密码，根据提示输入两遍密码。

```sh
E:\test\grub-2.06-for-windows>grub-mkpasswd-pbkdf2
Enter password: Reenter password: PBKDF2 hash of your password is grub.pbkdf2.sha512.10000.C5D1F26AEA63......B9CA0D14856A5
```

其中 `grub.pbkdf2.sha512.10000.C5D1F26AEA63......B9CA0D14856A5` 就是得到的加密后的密码。

修改 `grub.cfg`，创建密码保护项

```ini
# grub.cfg
# 可以创建多个用户，用户名间用逗号隔开，下面用户密码分行写
set superusers="kevin"
password_pbkdf2 kevin grub.pbkdf2.sha512.10000.C5D1F26AEA63......B9CA0D14856A5

menuentry 'Windows 10'  --users kevin --class windows --class os {
search --file --set /EFI/Microsoft/Boot/boot.efi
chainloader /EFI/Microsoft/Boot/boot.efi
}
```

### Windows 下删除 GRUB 引导

运行 `C:\WEPEuninstall_UEFI_GRUB.cmd`，删除 GRUB 的启动引导。

也可以手动删除，管理员权限运行命令提示符：

```sh
# 查看所有的启动引导项
bcdedit /enum firmware

# 复制 path=\EFI\grub\grub.efi 的标识符
# 删除指定标识符的 EFI 引导项
bcdedit /delete {c9653390-a2e3-11e9-b53d-e8beb78bd2ca}
```

## GRUB 引导 WindowsPE

由于 GRUB 不能在 UEFI 模式下对 ISO 文件进行仿真，那么我们应该如何在 UEFI 模式下引导 WindowsPE 呢？答案是必须使用 WIM 格式的 WindowsPE。

具体说来就是首先用 GRUB2 链式加载微软的"bootmgfw.efi"引导管理器，然后再由"bootmgfw.efi"根据 BCD 文件的指引去启动 WindowsPE。

第一步，从例如 "[微 PE](http://www.wepe.com.cn)" 这样的作品中提取"WEPE64.WIM"与"WEPE.SDI"(BOOT.SDI) 文件。

第二步，从 Win10 的原版安装光盘中提取"bootmgfw.efi"文件 (/efi/boot/bootx64.efi)。

第三步，将提取的三个文件放置到一个 FAT32 或 NTFS 磁盘分区上，这里假定放到'(hd0,gpt3)/winpe/'目录中。

第四步，仿照下面的命令序列编写一个 BCD 文件：

第五步，将生成的 BCD 文件同样放置到 `(hd0,gpt3)/winpe/` 目录中。

最后，在 `grub.cfg` 中加入如下菜单项：

```sh
menuentry 'UEFI Windows PE Boot Manager' --unrestricted {
    chainloader (hd0,gpt3)/winpe/bootmgfw.efi
}
```

## GRUB 引导 linux 安装光盘

参考：<https://github.com/Jimmy-Z/grub-iso-boot>

<https://github.com/mpolitzer/grub-iso-multiboot>

<https://github.com/thias/glim>

<https://github.com/aguslr/multibootusb>

<https://www.howtogeek.com/196933/how-to-boot-linux-iso-images-directly-from-your-hard-drive/>

由于各种发行版的安装光盘启动各不相同，可以参考 ISO 内部的 grub 配置，也可以参考各自的官方文档。

LinuxMint 参考：<https://community.linuxmint.com/tutorial/view/1849>

```sh
iso_path=/grub
linuxmint=linuxmint-19.1-cinnamon-64bit.iso
linuxmint_path=${iso_path}/${linuxmint}
if [ -f ${linuxmint_path} ]; then
    menuentry "Start Linux Mint 19.1 Cinnamon 64-bit" --class linux-mint {
        loopback loop0 ${linuxmint_path}
        linux (loop0)/casper/vmlinuz boot=casper iso-scan/filename=${linuxmint_path} quiet splash --
        initrd (loop0)/casper/initrd.lz
    }
fi
```

## GRUB 外部配置文件

```sh
# 本文件必须以 utf-8 无 BOM 编码
# 只要该文件放到磁盘根目录的 grub-extra 文件夹下，就能自动识别到该外置菜单。
set timeout_check=-1
export timeout_check
iso_path=/grub-extra/linux

set superusers="kevin"
password_pbkdf2 kevin grub.pbkdf2.sha512.10000.8CA9F997735982E6637DF3BA9F951392245B82349A98BBF29768353E3CE53BA00F2CBBC361CA93D3956E52AF313F06AA0B9D2E8E4B42B18103E494B4B56A0EB3.3751DD4927F51ACD7275374F0683CB4B3C2ED4E7910B43F51066CE078FABA1169D66EA1B1B2C085419978EFB76C1FAD166FC101E1185DABBC726633B8B65486F

# WEPE 最新版
if [ -f /grub-extra/WEPE/boot.efi ] ; then
    menuentry 'WINPE_V2.3 原版' --unrestricted --class recovery --class os {
        chainloader /grub-extra/WEPE/boot.efi
    }
fi


# 显示 Windows 10 菜单
if search --file /EFI/Microsoft/Boot/bootmgfw.efi ; then
    menuentry 'Windows 10'  --users kevin --class windows --class os {
        search --file --set /EFI/Microsoft/Boot/bootmgfw.efi
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
    }
elif search --file /EFI/Microsoft/Boot/boot.efi ; then
    menuentry 'Windows 10'  --users kevin --class windows --class os {
        search --file --set /EFI/Microsoft/Boot/boot.efi
        chainloader /EFI/Microsoft/Boot/boot.efi
    }
fi


# Linuxmint
linuxmint=linuxmint-20-cinnamon-64bit.iso
linuxmint_path=${iso_path}/${linuxmint}
if [ -f ${linuxmint_path} ]; then
    menuentry "Start Linux Mint ISO" --class linux-mint {
        loopback loop0 ${linuxmint_path}
        linux (loop0)/casper/vmlinuz boot=casper iso-scan/filename=${linuxmint_path} quiet splash --
        initrd (loop0)/casper/initrd.lz
    }
fi

# Ubuntu
# 参考：https://help.ubuntu.com/community/Grub2/ISOBoot
ubuntu=ubuntu-20.04.1-desktop-amd64.iso
ubuntu_path=${iso_path}/${ubuntu}
if [ -f ${ubuntu_path} ]; then
    menuentry "Start Ubuntu ISO" --class ubuntu {
        rmmod tpm
        loopback loop0 /${ubuntu_path}
        linux  (loop0)/casper/vmlinuz boot=casper iso-scan/filename=/${ubuntu_path} noprompt noeject toram --
        initrd (loop0)/casper/initrd.lz
    }
fi

# Fedora
# Fedora ISO 镜像必须放到 FAT32 分区
fedora=Fedora-Workstation-Live-x86_64-29-1.2.iso
fedora_path=${iso_path}/${fedora}
if search --file ${fedora_path} ; then
    menuentry "Start Fedora-Workstation-Live 29" --class fedora {
        search --file --set ${fedora_path}
        loopback loop0 ${fedora_path}
        probe -s iso_label -l (loop0)
        linux (loop0)/isolinux/vmlinuz rd.live.image iso-scan/filename="${fedora_path}" root=live:CDLABEL="$iso_label" quiet
        initrd (loop0)/isolinux/initrd.img
    }
fi

if [ -f /grub-extra/linux/grubfmx64.efi ] ; then
    menuentry "文件管理器" --unrestricted --class recovery --class os {
        chainloader /grub-extra/linux/grubfmx64.efi
    }
fi

# clonezilla
clonezilla=clonezilla-live-2.5.6-22-amd64.iso
clonezilla_path=${iso_path}/${clonezilla}
if search --file ${clonezilla_path} ; then
    menuentry "clonezilla live" --class clonezilla {
        loopback loop0 ${clonezilla_path}
        linux (loop0)/live/vmlinuz boot=live union=overlay username=user config components quiet noswap nolocales edd=on nomodeset nodmraid ocs_live_run=\"ocs-live-general\" ocs_live_extra_param=\"\" keyboard-layouts=\"\" ocs_live_batch=\"no\" locales=zh_CN.UTF-8 vga=788 ip=frommedia nosplash toram=filesystem.squashfs findiso=${clonezilla_path}
        initrd (loop0)/live/initrd.img
    }
fi

# 自定义主题
if [ -d /grub-extra/themes ]; then
    submenu ">>Themes" --unrestricted {
        # 1
        if [ -f /grub-extra/themes/Elegant/theme.txt ]; then
            menuentry "Theme Elegant" {
                set theme=($root)/grub-extra/themes/Elegant/theme.txt
                export theme
                configfile $prefix/grub.cfg
            }
        fi
        # 2
        if [ -f /grub-extra/themes/Ettery/theme.txt ]; then
            menuentry "Theme Ettery" {
                set theme=($root)/grub-extra/themes/Ettery/theme.txt
                export theme
                configfile $prefix/grub.cfg
            }
        fi
        # 3
        if [ -f /grub-extra/themes/kisa747/theme.txt ]; then
            menuentry "Theme kisa747" {
                set theme=($root)/grub-extra/themes/kisa747/theme.txt
                export theme
                configfile $prefix/grub.cfg
                set timeout=-1
                export timeout
            }
        fi
        # 4
        if [ -f /grub-extra/themes/StylishDark/theme.txt ]; then
            menuentry "Theme StylishDark" {
                set theme=($root)/grub-extra/themes/StylishDark/theme.txt
                export theme
                configfile $prefix/grub.cfg
            }
        fi
        # 5
        if [ -f /grub-extra/themes/starfield/theme.txt ]; then
            menuentry "Theme starfield" {
                set theme=($root)/grub-extra/themes/starfield/theme.txt
                export theme
                configfile $prefix/grub.cfg
            }
        fi
        # 6
        if [ -f /grub-extra/themes/CyberRe/theme.txt ]; then
            menuentry "Theme CyberRe" {
                set theme=($root)/grub-extra/themes/CyberRe/theme.txt
                export theme
                configfile $prefix/grub.cfg
            }
        fi
        # 7
        if [ -f /grub-extra/themes/Stylish/theme.txt ]; then
            menuentry "Theme Stylish" {
                set theme=($root)/grub-extra/themes/Stylish/theme.txt
                export theme
                configfile $prefix/grub.cfg
            }
        fi
        # 8
        if [ -f /grub-extra/themes/Tela/theme.txt ]; then
            menuentry "Theme Tela" {
                set theme=($root)/grub-extra/themes/Tela/theme.txt
                export theme
                configfile $prefix/grub.cfg
            }
        fi
        # 9
        if [ -f /grub-extra/themes/Vimix/theme.txt ]; then
            menuentry "Theme Vimix" {
                set theme=($root)/grub-extra/themes/Vimix/theme.txt
                export theme
                configfile $prefix/grub.cfg
            }
        fi

    }
fi

if [ ${grub_platform} == "efi" ]; then
 menuentry "UEFI Firmware setup" {
  fwsetup
 }
fi

menuentry '关机' --unrestricted {
    halt
}

menuentry '重启' --unrestricted {
    reboot
}

```
