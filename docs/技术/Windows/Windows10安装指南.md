# Windows 10 安装指南

## 笔记

* Windows 和 Office 推荐安装 VL 版，激活方便。尤其推荐 LTSC 版，更纯净，没有功能更新，只有安全更新。
* PS：安装 Windows10，系统盘推荐 `100G+` ；如果是固态硬盘可以考虑使用`/compact`参数，减小系统的大小（机械硬盘一定不能使用此功能）。
* 硬盘分区推荐使用 GPT。必须要有 ESP 分区（推荐 `1G`），没有必要创建 MSR 分区。
* 建议关闭 BIOS 的 Secure Boot 选项，使用 GRUB 作为 BootLoader。
* 软件选择策略，优先选择开源免费的软件，以实用、精致为主要目的。

Windows 安装 ISO 镜像信息：

>Windows 10 LTSC 2021 信息：
>
>Windows 10 Enterprise LTSC 2021 (x64) - DVD (Chinese-Simplified)
>文件：SW_DVD9_WIN_ENT_LTSC_2021_64BIT_ChnSimp_MLF_X22-84402.ISO
>大小：4.7GB
>MD5:2579B3865C0591EAD3A2B45AF3CABEEE
>SHA1：C19D7DAFBAFEB26C36E31D97C465E87C7A6E8A4C
>SHA256：C117C5DDBC51F315C739F9321D4907FA50090BA7B48E7E9A2D173D49EF2F73A3
>
>`magnet:?xt=urn:btih:366ADAA52FB3639B17D73718DD5F9E3EE9477B40&dn=SW_DVD9_WIN_ENT_LTSC_2021_64BIT_ChnSimp_MLF_X22-84402.ISO&xl=5044211712`
>
>`ed2k://|file|SW_DVD9_WIN_ENT_LTSC_2021_64BIT_ChnSimp_MLF_X22-84402.ISO|5044211712|1555B7DCA052B5958EE68DB58A42408D|/`

Windows 10 LTSC 2019 信息

>Windows 10 LTSC 2019 信息：
>
>文件名：cn_windows_10_enterprise_ltsc_2019_x64_dvd_9c09ff24.iso
>
>SHA1:24b59706d5eded392423936c82ba5a83596b50cc
>
>文件大小：4.17GB
>
>发布时间：2019-03-15
>
>下载地址：`ed2k://|file|cn_windows_10_enterprise_ltsc_2019_x64_dvd_9c09ff24.iso|4478906368|E7C526499308841A4A6D116C857DB669|/`

将 Windows 10 Enterprise LTSC 2021 激活为 Windows 10 IoT Enterprise LTSC 2021

参考：[批量许可证中的 Windows IoT Enterprise LTSC](https://learn.microsoft.com/zh-cn/windows/iot/iot-enterprise/deployment/volume-license)

```sh
rem 导入 Windows 10 IoT Enterprise LTSC 2021 版本的密钥
cscript //Nologo %windir%\system32\slmgr.vbs /ipk KBN8V-HFGQ4-MGXVD-347P6-PDQGT

rem 查看当前版本
Dism /Online /Get-CurrentEdition

echo 正在设置Windows的KMS服务器地址...
cscript //Nologo %windir%\system32\slmgr.vbs /skms kms.03k.org
::其它KMS服务器
rem kms.pub
rem kms.03k.org
rem kms.chinancce.com
rem kms.library.hk
rem kms.lotro.cc

echo 正在激活Windows...
cscript //Nologo %windir%\system32\slmgr.vbs /ato

echo 正在当前许可证的过期日期...
cscript //Nologo %windir%\system32\slmgr.vbs /xpr
```

支持日期

| 版本                            | 开始日期       | 主流结束日期  | 延长结束日期  |
| :------------------------------ | -------------- | ------------- | ------------- |
| Windows 10 IoT 企业版 LTSC 2021 | 2021 年 11 月 16 日 | 2027 年 1 月 12 日 | 2032 年 1 月 13 日 |

## 一、我的程序

### 1、工具类

[PDFCreator](http://www.pdfforge.org/download) | [Chrome](https://www.google.cn/chrome/index.html) | [VMwareWorkstation](https://github.com/201853910/VMwareWorkstation/releases)

[TeraCopy](http://codesector.com/teracopy)  最好安装在系统盘默认位置，因为升级后会自动安装至 `%programfiles%`

### 2、便携版软件

* App

[7-Zip](http://www.7-zip.org/) | [Firefox](http://www.mozilla.org/en-US/firefox/all/) | [Foobar2000 汉化版](http://blog.sina.com.cn/go2spa) | [MPC-BE](https://sourceforge.net/projects/mpcbe/) | [Notepad++](http://notepad-plus-plus.org) | [Notepad2 Mod](https://xhmikosr.github.io/notepad2-mod/) | [PortableGit](https://npm.taobao.org/mirrors/git-for-windows/) | [PotPlayer](http://potplayer.daum.net/?lang=zh_CN) | [Snipaste](https://zh.snipaste.com) | [Sumatra PDF](http://www.sumatrapdfreader.org/) | [VeraCrypt](https://sourceforge.net/projects/veracrypt/) |

* Tool：

 [Icaros](http://shark007.net/forum/Forum-Icaros-Development) |  [VC 运行库](https://learn.microsoft.com/zh-cn/cpp/windows/latest-supported-vc-redist?view=msvc-170)

[HEICThumbnailHandler](https://github.com/brookmiles/windows-heic-thumbnails)

[Avira 杀毒](https://www.avira.com/zh-cn/download?product=avira-free-antivirus) | [avast! 杀毒](https://www.avast.com/zh-cn/download-software) | [金山词霸](http://cp.iciba.com/) | [WPS Office](http://www.wps.cn/) | [Thunderbird](http://www.mozilla.org/zh-CN/thunderbird/) |[FreeFileSync](http://freefilesync.sourceforge.net/) |

[MPlayer WW](http://mplayer-ww.com/?page=rel) | [MeGUI](http://sourceforge.net/projects/megui/) | [Mp3tag](http://www.mp3tag.de) | [K-Lite Codec Pack](https://www.codecguide.com/download_kl.htm) 下载 Basic 版即可

[ScarAnge eMule](http://scarangel.sourceforge.net/) | [CCleaner](http://www.piriform.com/ccleaner) |

[EasyPHP](http://www.easyphp.org/) | [FileZilla](https://filezilla-project.org) | [DCPicker](http://hide-inoki.com/en/index.html) | [IETester](http://www.my-debugbar.com/wiki/IETester/HomePage) | [JR Screen Ruler](http://www.spadixbd.com/freetools/jruler.htm) | [PicPick](https://picpick.app/zh/)   [Resource Hacker](http://www.angusj.com/resourcehacker/)  [AutoHotkey](https://www.autohotkey.com/)

[HaoZip](http://haozip.2345.com/) 有流氓潜质，不建议使用。

### 3、维护工具

[微 PE 工具箱](http://www.wepe.com.cn/) | [GRUB2](http://www.gnu.org/software/grub/) | [GRUB2 实战手册（金步国）](http://www.jinbuguo.com/linux/grub.cfg.html) |

[一键 GHOST](http://doshome.com/yj/index.html) | [Bootice](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=57675) | [fbinstTool](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=189221) | [grub4dos](http://grub4dos.chenall.net/) | [RUN 模块](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=191301) |

[DiskGenius](http://www.diskgenius.cn/download.php) | [傲梅分区助手](http://www.disktool.cn/) | [Defraggler](http://www.piriform.com/defraggler) | [Recuva](http://www.piriform.com/recuva) | [CPU-Z](http://www.cpuid.com/softwares/cpu-z.html) | [HWMonitor](http://www.cpuid.com/softwares/hwmonitor.html) |

### 4、Chrome 扩展

[谷歌访问助手](http://www.ggfwzs.com/)

[AdBlock Plus](https://chrome.google.com/webstore/detail/cfhdojbkjhnklbpkdaibdccddilifddb) | [miniGestures](https://chrome.google.com/webstore/detail/minigestures/apnjnepphihnjahpbfjiebcnpgmjnhfp) | [一键下载到小米路由器](https://chrome.google.com/webstore/detail/一键下载到小米路由器/kfcpablabgofhgdifeokmojafdnlomhp) |

```sh
# 添加 Bing 搜索。
https://cn.bing.com/search?q=%s
```

### 5、工作软件

[天正插件](http://tangent.com.cn/download/gongju/)

## 三、优化设置全攻略

### （1）、运行命令优化

* 运行 `Windows10优化.cmd`
* 导入 `Windows10优化.reg`

### （2）、基本设置

* 关闭系统保护，设置虚拟内存
* 设置开始菜单：添加“命令提示符”、“IE 浏览器”到开始菜单
* 设置资源管理器：
  * 设置删除文件，需要确认。
  * 设置资源管理器的文件排列方式为：默认平铺
  * 禁止 C 盘索引。

### （3）、设置面板

* 设置——系统——电源和睡眠
  设置电源按钮——不采取任何措施。
* 设置——设备
  1）关闭蓝牙
  2）触摸板——滚动方向“向下移动时向下滚动”。
  3）关闭自动播放。
* 个性化
  1）主题——桌面图标设置 - 桌面显示“此电脑”。
  2）开始——在“开始”菜单显示应用列表——【关】
  3）任务栏——通知区域始终显示所有图标，关闭不用的系统图标。
* 应用
  1）删除不用的程序。包括（onedrive）
  2）设置默认应用，尤其是照片
* 账户
  1）更改账户信息：图片、密码
  2）登录选项，将“更新或重启后，使用我的登录信息自动完成设备设置”这个选项关闭。
* 时间和语言——设置默认输入法为英文
* 轻松使用——其他选项——视觉选项——关闭“在 Windows 中播放动画”。
* 隐私：修改隐私设置。

### （4）、清理 C 盘

清理 C 盘。

## 四、可选设置

### 组策略设置

运行 `gpedit.msc`

* 组策略\计算机配置\管理模板\windows 组件\自动播放策略——【关闭自动播放】、【关闭非卷设备的自动播放】、【自动运行的默认行为】，三个全部启用。

* 设置提升管理员权限需要输入密码：组策略\计算机配置\Windows 设置\安全设置\本地策略\安全选项\用户帐户控制：管理批准模式中管理员的提升权限提示的行为，修改成【提示凭据】。

* 禁止篡改 IE 主页：组策略\用户配置\管理模板\Windows 组件\Internet Explorer\禁用更改主页设置，设为“已启用”，主页为：about:blank。

* 刷新组策略（以管理员身份运行）`gpupdate /force`
