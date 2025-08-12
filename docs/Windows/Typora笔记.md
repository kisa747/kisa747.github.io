## 解决测试版无法使用的问题

参考：<https://zhuanlan.zhihu.com/p/543941703>

1. 打开注册表 `regedit` 。
2. 输入：`计算机\HKEY_CURRENT_USER\SOFTWARE\Typora` .
3. 找到 `typora` 这一项，然后点击 右键，选择 权限；
4. 在 权限 里面把各个用户的权限，全部选择 拒绝；有人说，仅关闭当前使用的用户即可，但我觉得保险起见，还是把所有用户都拒绝掉吧。【最后别忘了 应用 + 确认】

## Typora 主题

参考：<http://support.typora.io/Add-Custom-CSS/>

Typora will load CSS files in following order:

1. Typora’s basic styles.
2. CSS for current theme.（比如：github.user.css）
3. `base.user.css` under theme folder.
4. `{current-theme}.user.css` under theme folder. If you choose `Github` as your theme, then `github.user.css` will also be loaded.

`base.user.css`应用至所有主题。`{current-theme}.user.css`仅应用至对应的主题。如果要修改 GitHub 主题，只需创建`github.user.css`，内容如下：

```css
body {
    font-family: "Source Han Sans SC","Noto Sans CJK SC","Source Han Serif SC","Microsoft Yahei",sans;
}

blockquote {
    border-left: 4px solid #42b983;
    padding: 10px 15px;
    color: #777;
    background-color: rgba(66, 185, 131, .1);
    font-family: "KaiTi","Source Han Sans SC","Noto Sans CJK SC","Source Han Serif SC","Microsoft Yahei",sans;
}

.md-fences,
code,
tt {
    font-size: 0.94em;
    font-family: consolas,monospace,"Source Han Sans SC","Noto Sans CJK SC","Microsoft Yahei";
}

code {
    background-color: #e2f0ff;
    padding: 2px 4px;
    margin: auto 4px;
    border-radius: 4px;
    font-family: consolas,monospace,"Source Han Sans SC","Noto Sans CJK SC","Microsoft Yahei";
}

h1 {
    font-size: 1.7em;
}

h2 {
    font-size: 1.5em;
    font-family: "Source Han Serif SC","Source Han Sans SC","Noto Sans CJK SC","Microsoft Yahei",sans;
}

h3 {
    font-size: 1.5em;
    font-family: "KaiTi","Source Han Serif SC","Source Han Sans SC","Noto Sans CJK SC","Microsoft Yahei",sans;
}
```
