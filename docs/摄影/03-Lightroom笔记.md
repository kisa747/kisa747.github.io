# Lightroom 笔记

## 笔记

1. Lightroom 的优势是调光调色，对相机支持优秀，颜色处理严谨，强大的组织管理能力。
2. Lightroom 处理照片是无损的，所以像去除污点这些功能呢，只能说是有，效果并不是最好的。如果要精细的祛痘、磨皮，还是建议到 PS 中操作。

## 后期流程

其实摄影最大的乐趣就是定格回忆。因此很少对照片进行深度的后期操作。

1. 照片筛选。删除对焦虚的、同一场景重复的、明显不好的照片。留下需要的照片，并进行打星分级。
2. 照片二次构图调整、画面曝光调整等基础调整，或是套用一下预设。
3. 需要精修的导入到 PS 中精修。

大部分照片前 2 步就行了，毕竟普通人摄影就是为了记录生活。

## 照片管理

参考：<https://sspai.com/post/66756>

<https://helpx.adobe.com/cn/lightroom-classic/help/flag-label-rate-photos.html>

### 1、照片筛选

- 排除旗标：稍后会删除的照片
- 1 星：导出；风景
- 2 星：导出；其他人物（很少使用）。
- 3 星：导出；人物
- 4 星：导出；精彩照片
- 5 星：导出；超级精彩照片
- 红色标签：需要冲洗的照片

### 2、照片重命名

重命名规则 `2025-05-05_162802.jpg` ，文件后缀名小写。

## 照片调整

### 美白皮肤

1. 减少橙色的饱和度，提高橙色的亮度，让皮肤白一些。
2. 减少橙色的色相，目的是让皮肤增加一些粉嫩的色彩。

## 导出设置

Lightroom 导出品质并不是线性的。经实测，导出品质 77-84 是一档，85-92 是一个档，93-100 是一个档。基本可以理解为 80、90、100 三个档。我把 80 品质和 100 品质仔细对比了，反正我是看不出有啥区别。但是三档间文件体积差别还是不小的。

相机导出：

图像格式：JPEG；品质：80

锐化对象：屏幕，低

手机导出：

图像格式：JPEG；品质：80

关闭锐化（手机的 HEIF 格式已经锐化过了，再次锐化会显著增加 JPEG 文件体积）

## 色彩管理

参考：<https://helpx.adobe.com/cn/lightroom-classic/help/color-management.html>

<http://qiuliang.com/techniques/2014/20141208_color_management_dirty_part.htm>

Lightroom 下，什么都不用设置就会自动转换色域空间，因此可以将 Lightroom 作为显示标准，默认认为 Lightroom 显示的是正确的色彩。

技术细节，Lightroom Classic 主要使用 Adobe RGB 色彩空间来显示颜色。

- 在“图库”、“地图”、“画册”、“幻灯片”、“打印”和“Web”模块中预览时，使用 Adobe RGB。
- 在“修改照片”模块中，Lightroom Classic CC 默认使用 ProPhoto RGB 色彩空间显示预览。
- 导出或打印照片时，可以选择配置文件或色彩空间。

相机中设置的色彩空间仅影响 JPG 直出，不影响 RAW 格式文件。

## 快捷键

Lightroom 快捷键列表： <https://helpx.adobe.com/cn/lightroom-classic/help/keyboard-shortcuts.html>

用于更改视图和屏幕模式的快捷键

|                结果                |     Windows      |
| :--------------------------------: | :--------------: |
|        转到图库 - 放大视图         |        E         |
|        转到图库 - 网格视图         |        G         |
|        转到图库 - 比较视图         |        C         |
|          进入图库筛选视图          |        N         |
|   在修改照片模块中打开选定的照片   |        D         |

使用“修改照片”模块时的快捷键

|               结果               | Windows |
| :------------------------------: | :-----: |
| 左右并排显示修改前与修改后的照片 |    Y    |
|        仅显示修改前的照片        |    \    |
|  选择“裁剪”工具（在任何模块中）  |    R    |

用于设置照片星级和过滤照片的快捷键

|         结果         | Windows  |
| :------------------: | :------: |
|       设置星标       |   1-5    |
|     指定红色色标     |    6     |
|     指定黄色色标     |    7     |
|     指定绿色色标     |    8     |
|     指定蓝色色标     |    9     |
|   将照片标记为排除   |    X     |
| 将照片标记为留用旗标 |    P     |
|     取消照片旗标     |    U     |
|   切换过滤器开/关    | Ctrl + L |

## Imaging Edge Desktop

Imaging Edge Desktop 生成的 xmp 文件，默认还会带上标签为 None。

```xml
<x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="XMP Core 6.0.0">
 <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about=""
    xmlns:xmp="http://ns.adobe.com/xap/1.0/"
   xmp:Rating="3"
   xmp:Label="None"/>
 </rdf:RDF>
</x:xmpmeta>
```

## RAW 文件默认设置

Lightroom 安装后一定要先设置这个，再导入照片。

在 `首选项 - 预设 - 原始图像默认设置 - 全局：` 选择：`预设 - 默认值 - Adobe颜色+镜头+降噪`。

由于我的是半幅相机，默认值降噪值相对有点偏小，可以将此文件复制出来，手动修改，然后使用自定义预设。

 `D:\Program Files\Adobe\Adobe Lightroom Classic\Resources\Settings\Adobe\Presets\Defaults\Adobe Color + Lens + NR.xmp`

 主要修改自适应 ISO

```xml
    <rdf:Seq>
  <rdf:li
   crs:ISO="100"
   crs:LuminanceSmoothing="0"
   crs:ColorNoiseReduction="25"
   />
  <rdf:li
   crs:ISO="800"
   crs:LuminanceSmoothing="15"
   crs:ColorNoiseReduction="25"
   />
  <rdf:li
   crs:ISO="6400"
   crs:LuminanceSmoothing="40"   # 默认为20
   crs:ColorNoiseReduction="40"
   />
  <rdf:li
   crs:ISO="25600"
   crs:LuminanceSmoothing="50"   # 默认为40
   crs:ColorNoiseReduction="80"
   />
    </rdf:Seq>
```

## 设置 Raw 图像的默认设置（方法作废）

参考：<https://qiuliang.com/post_process_tuesday/2020/001_lightroom_raw_default_settings.htm>

[设置 Raw 图像的默认设置](https://helpx.adobe.com/cn/lightroom-classic/help/raw-defaults.html )

`%APPDATA%\Adobe\CameraRaw\Defaults\`

Lightroom  classic 从 9.2 版开始，相机预设方法发生了变化，新的设置方法如下：

全新安装 Lightroom 后，先不要导入所有照片。可以先导入几张包含所有相机、手机拍照的照片，修改好预设后，再全部导入。

1、创建一个预设。

快捷键 `D` 进入 `修改照片` 模式，先选一个 RAW 文件。

​ 1）、配置文件设置为 `Adobe颜色` 。

​ 2）、镜头校正勾选 `移除色差`、`启用配置文件校正`。

​ 3）、创建预设，名称为 `镜头校正`，勾选 `处理方式和配置文件`、`启用配置文件校正`、`移除色差`。

2、应用相机的默认预设。

​ 1）打开：`首选项`  -  `预设` ，将全局修改为 刚才创建的预设 `镜头校正` 。

>注：
>
>仅对 RAW 图像文件有效。
>
>如果不同的相机想应用不同的设置，可以勾选 `覆盖特定相机的主设置`。
>
>预设中一定要勾选 `处理方式和配置文件` ，如果不勾选，Lightroom 会使用相机设置，而不是 Adobe 颜色。

### 设置特定于 ISO 值的 Raw 图像默认值（作废，不再使用此方法）

参考：<https://helpx.adobe.com/cn/lightroom-classic/help/develop-module-tools.html#iso-adaptive-preset>

修改 `"E:\文档\Lightroom\Lightroom 设置\Settings\镜头校正.xmp"` 文件的内容。

在 `</crs:Look>` 后加入以下代码，

```xml
<x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="Adobe XMP Core 7.0-c000 1.000000, 0000/00/00-00:00:00        ">
 <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about=""
    xmlns:crs="http://ns.adobe.com/camera-raw-settings/1.0/"
   crs:PresetType="Normal"
   crs:Cluster=""
   crs:UUID="1530BC77F7A65D479F4FF1B9D2049AF6"
   crs:SupportsAmount="False"
   crs:SupportsColor="True"
   crs:SupportsMonochrome="True"
   crs:SupportsHighDynamicRange="True"
   crs:SupportsNormalDynamicRange="True"
   crs:SupportsSceneReferred="True"
   crs:SupportsOutputReferred="True"
   crs:RequiresRGBTables="False"
   crs:CameraModelRestriction=""
   crs:Copyright=""
   crs:ContactInfo=""
   crs:Version="14.0"
   crs:ProcessVersion="11.0"
   crs:AutoLateralCA="1"
   crs:LensProfileEnable="1"
   crs:DefringePurpleAmount="0"
   crs:DefringePurpleHueLo="30"
   crs:DefringePurpleHueHi="70"
   crs:DefringeGreenAmount="0"
   crs:DefringeGreenHueLo="40"
   crs:DefringeGreenHueHi="60"
   crs:LensProfileSetup="LensDefaults"
   crs:HasSettings="True"
   crs:CropConstrainToWarp="0">
   <crs:Name>
    <rdf:Alt>
     <rdf:li xml:lang="x-default">镜头校正</rdf:li>
    </rdf:Alt>
   </crs:Name>
   <crs:ShortName>
    <rdf:Alt>
     <rdf:li xml:lang="x-default"/>
    </rdf:Alt>
   </crs:ShortName>
   <crs:SortName>
    <rdf:Alt>
     <rdf:li xml:lang="x-default"/>
    </rdf:Alt>
   </crs:SortName>
   <crs:Group>
    <rdf:Alt>
     <rdf:li xml:lang="x-default"/>
    </rdf:Alt>
   </crs:Group>
   <crs:Description>
    <rdf:Alt>
     <rdf:li xml:lang="x-default"/>
    </rdf:Alt>
   </crs:Description>
   <crs:Look>
    <rdf:Description
     crs:Name="Adobe Color"
     crs:Amount="1"
     crs:UUID="B952C231111CD8E0ECCF14B86BAA7077"
     crs:SupportsAmount="false"
     crs:SupportsMonochrome="false"
     crs:SupportsOutputReferred="false"
     crs:Stubbed="true">
    <crs:Group>
     <rdf:Alt>
      <rdf:li xml:lang="x-default">Profiles</rdf:li>
     </rdf:Alt>
    </crs:Group>
    </rdf:Description>
   </crs:Look>
<!-------  以下为添加的代码  ----->

   <crs:ISODependent>
    <rdf:Seq>
     <rdf:li
      crs:ISO="400"
      crs:LuminanceSmoothing="0"/>
     <rdf:li
      crs:ISO="1600"
      crs:LuminanceSmoothing="16"/>
     <rdf:li
      crs:ISO="6400"
      crs:LuminanceSmoothing="64"/>
    </rdf:Seq>
   </crs:ISODependent>

<!-------  以上为添加的代码  ----->
  </rdf:Description>
 </rdf:RDF>
</x:xmpmeta>
```

此预设通过以下方式设置“减少明亮度杂色”：

- 对于 ISO 为 400 及更低的图像，设置为 0
- 对于 ISO 为 1600 的图像，设置为 16
- 对于 ISO 为 6400 及更高的图像，设置为 64

此预设的主要用例是根据图像 ISO 值自定义杂色减少量，且 ISO 值越高，杂色减少量也越高。

>2017-02-25_郑州黄河湿地公园
>2017-04-15_郑州西流湖公园
>2018-02-15_春节 - 漯河河上街 一张
>2019_春节
>2019-02-05_春节梅庄 一张
>2019-02-23_梅卓然
