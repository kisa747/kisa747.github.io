# VBA 笔记

## XLSX 文件结构

典型的 xlsx 文件结构如下：

```ini
├─customUI
│      customUI.xml
│
├─docProps
│      app.xml
│      core.xml
│
├─xl
│  │  styles.xml
│  │  vbaProject.bin
│  │  ....
│  └─_rels
│          workbook.xml.rels
│
└─_rels
        .rels
```

## 修改 `_rels/.rels` 文件

`_rels/.rels` 文件添加指向 `customUI/customUI.xml` 的语句：

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
    <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
    <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
    <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
    <Relationship Id="customUIRelID" Type="http://schemas.microsoft.com/office/2006/relationships/ui/extensibility" Target="customUI/customUI.xml"/>
</Relationships>
```

也就是将以下代码放在 `</Relationship>` 之前。

```xml
<Relationship Id="customUIRelID" Type="http://schemas.microsoft.com/office/2006/relationships/ui/extensibility" Target="customUI/customUI.xml"/>
```

## 创建 customUI/customUI.xml 文件

创建 customUI/customUI.xml，编码可以是 UTF8，写入以下 XML 代码（添加自定义功能区）：

```xml
<customUI xmlns="http://schemas.microsoft.com/office/2006/01/customui">
<ribbon startFromScratch="false">
<tabs>
    <tab id="tab1" label="kisa747">
        <group id="tab1_group1" label="自定义功能">
            <button id="tab1_group1_but1" size="large" label="合并单元格" imageMso="CustomActionsMenu" onAction="ts"/>
            <button id="tab1_group1_but2" size="large" label="拆分单元格" imageMso="AppointmentColorDialog" onAction="ts"/>
            <button id="tab1_group1_but3" size="large" label="隔行填色" imageMso="Chart3DBarChart" onAction="ts"/>
            <button id="tab1_group1_but4" size="large" label="显示行列" imageMso="CreateFormInDesignView" onAction="ts"/>
        </group>

        <group id="tab1_group2" label="工作">
            <button id="tab1_group2_but1" size="large" label="生成计划单" imageMso="FileCheckOut" onAction="ts"/>
            <button id="tab1_group2_but2" size="large" label="导出PDF" imageMso="PublishToPdfOrEdoc" onAction="ts"/>
        </group>

        <group id="tab1_group3" label="工程资料">
            <button id="tab1_group3_but1" size="large" label="复制Sheet" imageMso="BodyTextHide" onAction="ts"/>
            <button id="tab1_group3_but2" size="large" label="资料2PDF" imageMso="ContentControlBuildingBlockGallery" onAction="ts"/>
            <button id="tab1_group3_but3" size="large" label="导出无公式版" imageMso="ClearFormats" onAction="ts"/>
        </group>

    </tab>
</tabs>
</ribbon>
</customUI>
```

## 破解 VBA 工程密码

1、首先，如果文件格式是 Excel 2010 版（.xslm），需要先打开 Excel 文件，另存为 2003 版格式（.xls）。如果是 xlam 格式，在 VBA 的立即窗口执行

```vb
workbooks("你要破解的加载宏名.xlam").isaddin=false
```

执行完后会看到 Sheet1 等多张工作表。再另存一份这工作表另存为为 `xls`  格式。

然后用普通的文本编辑器（我用的是 NotePad++）打开这个文件，注意文件类型选“所有文件”。

然后在文件里查找“DPB"，把它改成“DPx”。注意大小写。

保存修改。然后用 Excel 重新打开这个文件。你会遇到一些错误，忽略它们。

然后进入 Excel 的“开发工具”面板，选择“Visual Basic”。又会有一系列错误，忽略它们，直到 VBA 项目打开。

这时候你已经可以查看 VBA 代码了。如果想改变甚至去除原来的密码，继续看。

从 VBA 编辑器的“工具”菜单，选择“VBA 工程属性...“，然后转到”保护“面板。

在密码框中输入新密码。（即便你想去除原有密码，也必须先设置一个新密码，然后再按后面的步骤去掉这个密码。）

保存 VBA 文件和 Excel 文件，关闭 Excel。

重新启动 Excel 并重新打开这个文件，然后进入"开发工具"->"Visual Basic"，会提示输入密码。输入你新设置的密码。

然后回到 VBA 编辑器的“工具”->"VBA 工程属性"->“保护”，去掉密码以及保护选项前面的标记。

## 破解工作表工作簿密码

2007 的工作表密码：这里还有一个另类的方法来破解 2007 的工作表保护密码。将 A.xlsx 先做好备份（防止失败），然后将 xlsx 后缀改成 ZIP 后缀，解压该文件。假设这里加密的是 sheet1 表，找到 `xl\worksheets\sheet1.xml` 这个文件，用记事本打开后删除类似整个代码

```xml
<sheetProtection password="CF7A" sheet="1" objects="1" scenarios="1" />
```

（没想到工作薄密码采用四位加密算法，估计微软也知道这个加密没有什么实际意义，所以不费心思搞这东西），删除后保存退出。将修改好的 sheet1.xml 文件在解压缩窗口里再次丢进 xl\worksheets\目录，覆盖该文件，确定。最后将 ZIP 后缀将回 xlsx 后缀，密码就清空了，该办法我想应该是本人首创的吧，呵呵，尽管实用性不高。（实际为利用 XML 语言破解）
