# PE系统维护

## PE的目录结构

```sh
├─EFI
│  │  install_grub.cmd   # 安装UEFI下的grub的批处理
│  │  
│  ├─boot
│  │      bootx64.efi    # Fallback回退的EFI启动文件，使用grub-mkimage.exe命令生成的
│  │      
│  └─grub
│      │  grub.cfg       # GRUB配置文件
│      │  grub.efi       # GRUB启动文件，与bootx64.efi为同一个文件
│      │  
│      ├─fonts
│      │      unicode.pf2  # GRUB自带的字体文件
│      │      WenQuanYiMicroHeiMono24px.pf2  # 使用grub-mkfont命令生成的字体
│      │      
│      ├─locale
│      │      zh_CN.mo    # 中文支持模块
│      │      
│      ├─themes           # GRUB主题
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
│      └─x86_64-efi     # GRUB支持模块
│              acpi.mod
│              ...
│              zstd.mod
│              
└─WEPE
        BCD                         # 启动文件，用批处理命令生成的。用来引导 sdi、WIM 文件
        boot.efi                    # 从WIM镜像中提取([sources/install.wim]/Windows/Boot/EFI/bootmgfw.efi)
                                    # 也可以从ESP分区中提取（\EFI\Microsoft\Boot\bootmgfw.efi）
        boot.sdi                    # 启动文件。从微PE中提取的"WEPE.SDI"改名而来。
                                    # wim启动时这个boot.sdi虚拟成x:盘，供wim文件挂载之用
        install_mgr.cmd             # 将PE安装至bootmgr菜单。管理员运行。
        uninstall_mgr.cmd           # 卸载bootmgr中的PE菜单。管理员运行。
        uninstall_UEFI_GRUB.cmd     # 卸载EFI菜单
        WEPE64.WIM                  # 微PE文件，uefi模式下必须要用wim格式才行。
```

boot.sdi

>    boot.sdi 就是一个空的 IMAGE 虚拟磁盘文件，用于挂载 系统盘，PE 通常为 X: ，可以用  DiskGenius 等加载和编辑
>    
>    对比 Linux ，Linux 采用虚拟文件系统，所以不需要类似的东西，全部都挂载到根目录 / 下面，而 Windows 采用实体文件系统，所以需要一个空的虚拟磁盘文件挂载，分区，格式化，作为系统分区。

## 制作GRUB引导光盘

在 Debian 下操作：

```sh
# 安装mtools工具合集
sudo apt-get install mtools

# 创建目录
mkdir -p efi/boot
# 将 bootx64.efi 文件放至 efi/boot 目录下

# 创建一个空的efi.img软盘镜像，并格式化为FAT16
mformat -C -f 2880 -L 16 -i ./efi.img ::.
# 将 efi 目录复制至 efi.img 镜像内
mcopy -s -i ./efi.img ./efi ::/.
```

将得到的 efi.iimg 复制到windows 环境下，在windows 下操作。

将 efi.img 复制至光盘根目录，使用 oscdimg 命令创建可启动光盘

```sh
oscdimg -u1 -o -m -h -b"iso\efi.img" -l"iso" iso "grub.iso"
```

