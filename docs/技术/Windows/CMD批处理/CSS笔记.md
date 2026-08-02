# CSS 笔记

## 基本知识

**CSS** (Cascading Style Sheets，层叠样式表），是一种用来为结构化文档（如 HTML 文档或 XML 应用）添加样式（字体、间距和颜色等）的计算机语言，文件扩展名为 `.css`。

```css
     h1  { color: blue; font-size: 2rem; }
/* 选择器    属性    值  */
```

注意：

* CSS 声明总是以分号 `;` 结束
* 声明总以大括号 `{}` 括起来
* CSS 注释以 `/*` 开始，以 `*/` 结束
* 不要在属性值与单位之间留有空格（如：`margin-left: 20 px` ），正确的写法是 `margin-left: 20px` 。

## 选择器

### ID 选择器

HTML 元素以 id 属性来设置 id 选择器，CSS 中 id 选择器以 `#` 来定义。

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>菜鸟教程(runoob.com)</title>
<style>
#para1
{
 text-align:center;
 color:red;
}
</style>
</head>

<body>
<p id="para1">Hello World!</p>
<p>这个段落不受该样式的影响。</p>
</body>
</html>
```

### class 选择器

class 选择器在 HTML 中以 class 属性表示，在 CSS 中，类选择器以一个点 `.` 号显示。

多个 class 选择器可以使用空格分开。

```css
p.center .mcon {text-align:center;}
```

## 多重样式

样式表允许以多种方式规定样式信息。样式可以规定在单个的 HTML 元素中、HTML 页的头元素中，或在一个外部的 CSS 文件中。甚至可以在同一个 HTML 文档内部引用多个外部样式表。

一般情况下，优先级如下：

> （内联样式）Inline style > （内部样式）Internal style sheet >（外部样式）External style sheet > 浏览器默认样式

### 内联样式

将样式内容直接写到 html 的 style 属性标签内。当样式仅需要在一个元素上应用一次时可以考虑使用。请慎用这种方法。

```html
<p style="color:sienna;margin-left:20px">这是一个段落。</p>
```

### 内部样式表

当单个文档需要特殊的样式时，就应该使用内部样式表。使用 `<style>` 标签在文档头部 `<head>` 定义内部样式表。

```html
<head>
    <style>
        hr {color:sienna;}
        p {margin-left:20px;}
        body {background-image:url("images/back40.gif");}
    </style>
</head>
```

## 外部样式表

使用外部的 css 文件做为样式表，可以作用域许多页面，最理想的选择。在使用外部样式表的情况下，你可以通过改变一个文件来改变整个站点的外观。浏览器会从文件 mystyle.css 中读到样式声明，并根据它来格式文档。

```html
<head> <link rel="stylesheet" type="text/css" href="mystyle.css"> </head>
```

注意：

> css 文件中不能包含任何的 html 标签。
>
> 样式表应该以 `.css` 扩展名进行保存。

## 常用语法

### 盒子模型

* **Margin(外边距)** - 清除边框外的区域，外边距是透明的。
* **Border(边框)** - 围绕在内边距和内容外的边框。
* **Padding(内边距)** - 清除内容周围的区域，内边距是透明的。
* **Content(内容)** - 盒子的内容，显示文本和图像。

### !important 规则

CSS 中的 `!important` 规则用于增加样式的权重，使用一个 !important 规则时，此声明将覆盖任何其他声明。

```css
p {
  background-color: red !important;
}
```

```css
p, blockquote, ul, ol, dl, table {
    margin: var(--p-spacing) 0;
}
```
