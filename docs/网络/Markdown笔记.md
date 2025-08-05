# Markdown 笔记

参考：[简明语法](https://www.zybuluo.com/mdeditor?url=https://www.zybuluo.com/static/editor/md-help.markdown) 、 [高阶语法](https://www.zybuluo.com/mdeditor?url=https://www.zybuluo.com/static/editor/md-help.markdown#cmd-markdown-%E9%AB%98%E9%98%B6%E8%AF%AD%E6%B3%95%E6%89%8B%E5%86%8C)

* Markdown书写语法以 Github的 [Basic writing and formatting syntax](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) 为准，尽量使用标准唯一的语法。比如：标题使用 `#` 而不是 `==`。
* Github 不支持 ==高亮==、行内公式

无序列表使用 `-` `*` `+` 都可以。

## 公式

参考：https://www.zybuluo.com/codeep/note/163962

Typora默认已经支持数学公式了，只需要输入`$$`后敲击回车键即可开始填写公式，不过这样只能使用`行间模式(display)`，如果我们需要使用`行内模式(inline)`的话，就需要手动开启了。打开Typora的偏好设置，有5个选项，分别是：行内公式、下标、上标、高亮以及图表功能。勾选即可。

使用方式是在两个`$`间填写公式，如: $E=mc^2$。

==**注意**: 在「Markdown」选项卡下的所有更改，都需要重启Typora才会生效。==

来看一下行内公式和行间公式的效果: $E=mc^2$

$$ 表示整行公式：

$$\sum_{i=1}^n a_i=0$$

$$
f(x_1,x_x,\ldots,x_n) = x_1^2 + x_2^2 + \cdots + x_n^2
$$

$$\sum^{j-1}_{k=0}{\widehat{\gamma}_{kj} z_k}$$

访问 [MathJax](http://meta.math.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference) 参考更多使用方法。

