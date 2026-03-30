# Office2021 配置

> 参考：
>
> 巧用官方 ODT 清爽安装 Officehttps://sspai.com/post/55644
>
> Office 2019/365 修改默认安装路径及激活方法<https://zhuanlan.zhihu.com/p/114550106>
>
> [Office2019 VOL 版本 自定义安装组件](https://www.cnblogs.com/chasingdreams2017/p/10050764.html)
>
> 如何创建 Office LTSC 2021 VL（批量许可）版本的安装 ISOhttps://sysin.org/blog/office-2021-iso

2021 年 9 月 16 日，微软正式发布了支持 Office 2021 的部署工具（[Office Deployment Tool](https://www.microsoft.com/en-us/download/details.aspx?id=49117)），这意味着 Office 2021 已经正式发布，当然系统要求仅支持 Windows 10 和 Windows 11，Office 2021 具体带来了哪些新功能，可以查阅 Office 官网 [Office 2021 中的新增功能](https://support.microsoft.com/zh-cn/office/office-2021-中的新增功能-43848c29-665d-4b1b-bc12-acd2bfb3910a#Platform=Windows_桌面版) 一文。Office 2021 与 Office 2019 开始改变了以往的安装方式一样，仅支持 C2R（Click-To-Run）安装方式，不再提供 ISO 安装文件。Click-To-Run 可以确保每次下载安装的程序都是最新发行版，但缺点是用户会面临更长的安装（下载）时间，安装的具体版本也有一定的不确定性。

待安装结束后，方可清理目录内的文件。使用 ODT 安装的 Office 一般分为多个包，逐一卸载不便，如需完整卸载，建议使用官方的 [卸载工具](https://aka.ms/SaRA-officeUninstallFromPC)。

Office 2021 LTSC 官方的部署指南：<https://docs.microsoft.com/zh-cn/deployoffice/ltsc2021/overview>

## 安装配置方法

### 1 下载部署工具

下载地址： [Office Deployment Tool](https://www.microsoft.com/en-us/download/details.aspx?id=49117)

双击运行后会得到 `setup.exe` 文件和一大堆配置文件，只需要 `setup.exe` 文件即可。

### 2 定制 Office 配置文件

参考官方的在线工具：<https://config.office.com>

| **产品**                           | **GVLK**                      |
| :--------------------------------- | :---------------------------- |
| Office LTSC Professional Plus 2021 | FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH |
| Project Professional 2021          | FTNWT-C6WBT-8HMGF-K9PRX-QV9H8 |

安装 Word、Excel、PowerPoint、Project 的配置文件 `configuration.xml` 如下：

下面配置会安装 Word、Excel、PowerPoint、Project 组件。

```xml
<Configuration>
  <Info Description="-" />
  <Add OfficeClientEdition="64" Channel="PerpetualVL2021" AllowCdnFallback="true">
    <Product ID="ProPlus2021Volume">
      <Language ID="zh-cn" />
      <ExcludeApp ID="Access" />
      <ExcludeApp ID="Groove" />
      <ExcludeApp ID="Lync" />
      <ExcludeApp ID="OneDrive" />
      <ExcludeApp ID="OneNote" />
      <ExcludeApp ID="Outlook" />
      <ExcludeApp ID="Publisher" />
      <ExcludeApp ID="Teams" />
    </Product>
    <Product ID="ProjectPro2021Volume">
      <Language ID="zh-cn" />
    </Product>
  </Add>
  <Display AcceptEULA="True" />
  <Property Name="PinIconsToTaskbar" Value="False" />
  <AppSettings>
    <Setup Name="Company" Value="-" />
  </AppSettings>
</Configuration>
```

如果需要安装 viso，只需要在 Project 后面添加：

```xml
    <Product ID="ProjectPro2021Volume">
      <Language ID="zh-cn" />
      <Product ID="VisioPro2021Volume">
      <Language ID="zh-cn" />
    </Product>
```

### 3 下载安装包

将上述 2 个文件放至同一目录下，运行以下命令，下载最新的安装文件。

```sh
setup.exe /download Configuration.xml
```

得到以下目录结构如下：

```ini
卷 Office2021_LTSC 的文件夹 PATH 列表
│  Readme.txt                   说明文档
│  Setup.cmd                    一键安装快捷程序
│  configuration.xml            ODP配置文件
│  do_not_run.exe               Office Deployment Tool主程序
│  一键激活Office2021_VL版.cmd  Office激活工具
│
└─Office                        Office安装包
    └─Data
        │  v64.cab
        │  v64_16.0.14332.20145.cab
        │
        └─16.0.14332.20145
                i640.cab
                i640.cab.cat
                i642052.cab
                s640.cab
                s642052.cab
                stream.x64.x-none.dat
                stream.x64.x-none.dat.cat
                stream.x64.zh-cn.dat
                stream.x64.zh-cn.dat.cat
```

### 4 安装至本机

待上一步执行完后，执行以下命令，安装 Office。

```cmd
setup.exe /configure configuration.xml
```

可以将整个目录打包为 ISO 镜像，以后只要双击 `Setup.cmd` 运行即可一键安装。

>**注意：**
>
>Office 默认安装至 %ProgramFiles% （C:\Program Files）目录下，且无法修改，可以使用 mklink 命令安装至 D 盘
>
>`mklink /j "%ProgramFiles%\Microsoft Office" "D:\Program Files\Microsoft Office"`
