# Office2024 配置

Office LTS 只能使用官方的部署方式安装，需要提前写好配置文件，再根据配置文件下载、安装指定的配件，安装过程中没有提示、没有选项，甚至无法自定义安装位置，没有夸张，也只有微软能想到。

## 部署

参考：[Office LTSC 2024 部署文档](https://learn.microsoft.com/zh-cn/office/ltsc/2024/)

1. 从 Microsoft 下载中心下载 [Office 部署工具](https://www.microsoft.com/zh-cn/download/details.aspx?id=49117) （ODT），直接使用 7zip 解压，得到以下文件：

```ini
configuration-Office365-x64.xml
EULA
setup.exe
```

1. 创建 `configuration.xml` 文件

参考：[Office 自定义工具](https://config.office.com/deploymentsettings)

下面的配置会安装：Word、Excel、PowerPoint、Project

```xml
<Configuration>
  <Info Description="-" />
  <Add OfficeClientEdition="64" Channel="PerpetualVL2024">
    <Product ID="ProPlus2024Volume" PIDKEY="XJ2XN-FW8RK-P4HMP-DKDBV-GCVGB">
      <Language ID="MatchOS" Fallback="zh-cn" />
      <ExcludeApp ID="Access" />
      <ExcludeApp ID="Lync" />
      <ExcludeApp ID="OneDrive" />
      <ExcludeApp ID="OneNote" />
      <ExcludeApp ID="Outlook" />
    </Product>
    <Product ID="ProjectPro2024Volume" PIDKEY="FQQ23-N4YCY-73HQ3-FM9WC-76HF4">
      <Language ID="MatchOS" Fallback="zh-cn" />
    </Product>
  </Add>
  <Display AcceptEULA="True" />
  <AppSettings>
    <Setup Name="Company" Value="-" />
  </AppSettings>
</Configuration>
```

3. 根据配置文件下载 Office 安装文件

```sh
setup.exe /download Configuration.xml
```

4. 安装 Office

```sh
setup.exe /configure configuration.xml
```

## 激活

参考：<https://learn.microsoft.com/zh-cn/office/volume-license-activation/gvlks>

只要 Windows 是通过 KMS 激活的，Office 就无须单独激活，换句话说，Office 激活方式与 Windows 的 KMS 激活方式一致。

在配置文件中，设置正确 `pidkey`，可以避免安装后显示 preview 字样。

| **产品**                    | **GVLK**                      |
| :-------------------------- | :---------------------------- |
| Office LTSC 专业增强版 2024 | XJ2XN-FW8RK-P4HMP-DKDBV-GCVGB |
| Project Professional 2024   | FQQ23-N4YCY-73HQ3-FM9WC-76HF4 |
