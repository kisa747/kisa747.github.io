# Bitlocker 笔记

官方文档：<https://docs.microsoft.com/zh-cn/windows/security/information-protection/bitlocker/bitlocker-overview>

> 引用自官方文档：
>
> BitLocker 驱动器加密是一项数据保护功能，它与操作系统集成，用于解决来自丢失、被盗或销毁不当的计算机的数据被盗或泄露的威胁。

Bitlocker 是微软推出的一种数据加密功能，windows 10 系统中自带，无需额外安装软件。

从 Windows 10 Version 1511 开始，微软新增了 `新加密模式`，也就是 `AES-XTS` 加密算法，理论上在性能、安全性更好，推荐使用（旧版系统不支持）。

查看已经使用 Bitlocker 加密磁盘的加密算法，使用 `管理员权限` 打开 命令提示符。

```sh
$ manage-bde -status M:
BitLocker 驱动器加密: 配置工具版本 10.0.18362
版权所有 (C) 2013 Microsoft Corporation。保留所有权利。

卷 M: [WD]
[数据卷]

    大小:              931.48 GB
    BitLocker 版本:    2.0
    转换状态:          仅加密了已用空间
    已加密百分比:      100.0%
    加密方法:          XTS-AES 128
    保护状态:          保护已启用
    锁定状态:          已解锁
    标识字段:          未知
    自动解锁:          已禁用
    密钥保护器:
        密码
        数字密码
```

## 使用 AES-XTS 256 位加密算法

默认加密长度是 AES 128 位，其实可以使用 AES 256 位的。

参考：<https://www.howtogeek.com/193649/how-to-make-bitlocker-use-256-bit-aes-encryption-instead-of-128-bit-aes/>

组策略：计算机配置 - 管理模板 - Bitlocker 驱动器加密 - 选择驱动器加密方法和密码长度（windows 10 [版本 1511]和更高版本），配置为 `已启用`，三种加密方法都修改为 `XTS-AES 256位` 。

对于版本大于  1511 的 windows 10 系统，对应的注册表文件为：

参考：<https://blogs.technet.microsoft.com/dubaisec/2016/03/04/bitlocker-aes-xts-new-encryption-type/>

```ini
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\FVE]
"EncryptionMethodWithXtsOs"=dword:00000007
"EncryptionMethodWithXtsFdv"=dword:00000007
"EncryptionMethodWithXtsRdv"=dword:00000007
```

参考官方博客，使用 128 位和使用 256 加密，耗时几乎一模一样，没有理由不使用 256 位加密。
