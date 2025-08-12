# Hexo+Github Page 搭建静态博客

Hexo 官方文档：<https://hexo.io/zh-cn/docs/>

## 环境搭建

### 安装 Node.js、Git

```sh
# scoop 依赖 git，所以只要有 scoop，Git 肯定已经安装。
# 安装最新的 Node.js 长期支持版本
scoop install nodejs-lts
```

### 安装 Hexo

```sh
# Node.js 的 npm 默认源实在太慢了，需要更换国内源。
# 临时使用淘宝源
#npm --registry https://registry.npmmirror.com install express
# 持久使用淘宝源
npm config set registry https://registry.npmmirror.com
#npm config set registry https://mirrors.huaweicloud.com/repository/npm/

# 配置后验证是否成功
npm config get registry
# 或是查看详细配置信息
npm info express
```

选一块风水宝地作为 hexo 博客的主目录，比如：`E:\blog` ，在此目录下打开 Git Bash。

>为保证命令都能顺利执行，推荐下面所有的命令都在 Git Bash 下操作，并且所有的操作都是在 `E:\blog` 目录下进行。

```sh
# 全局安装 Hexo，为了能够使用 hexo 命令。
npm install hexo-cli -g

# 在 blog 目录下初始化 Hexo
hexo init

# 安装依赖包
npm install

# 安装 Git 部署工具
npm install hexo-deployer-git

# 安装服务器模块
npm install hexo-server

# 安装主题
npm install hexo-theme-fluid
```

本地预览

```sh
start http://localhost:4000
hexo clean && hexo server
```

网站会在 <http://localhost:4000> 下启动。在服务器启动期间，Hexo 会监视文件变动并自动更新，无须重启服务器。

以上都没有问题了，就可以继续下面的工作。

### 配置 Git

1、设置 Git 的 user name 和 email：

```sh
git config --global user.name "**"
git config --global user.email "**@qq.com"
```

2、如果没有密钥，运行 Git Bash，输入命令生成密钥，默认位置在 `C:\User\用户名` 下

```sh
 ssh-keygen -t rsa -C "**@qq.com"
```

3、如果已经有密钥。复制公钥内容，即 `id_rsa.pub`  里的内容，进入 `GitHub— Personal settings—SSH andGPG keys—New SSH key`，粘贴公钥内容。

### 配置 GitHub

参考：<https://help.github.com/articles/setting-up-an-apex-domain/>

1. 创建一个名为：`kisa747.github.io` 的仓库
2. 在仓库的 Setting 绑定域名 `kisa747.com`
3. 勾选 GitHub 绑定域名的 `Enforce HTTPS`

解析域名到 GitHub

| 主机记录 | 记录类型 |      记录值       |
| :------: | :------: | :---------------: |
|    @     |  CNAME   | kisa747.github.io |
|   www    |  CNAME   | kisa747.github.io |

刷新本机 DNS： `ipconfig /flushdns`

4. 点击 `Clone or download - Use SSH`，复制内容，就是博客的仓库地址。
5. 创建 `CNAME` 文件

在 `blog\source`  下创建 `CNAME`文件，添加 `kisa747.com` 字段。

```sh
echo kisa747.com > source/CNAME
```

### 配置 Hexo

修改网站配置 `_config.yml`，编码一定为 `utf8` 。

```yaml
# _config.yml
# Hexo Configuration
## Docs: https://hexo.io/docs/configuration.html
## Source: https://github.com/hexojs/hexo/

# Site
title: 智行天下
subtitle: 不会编程的裁缝不是一个好管理者！
description: 人生苦短，我用 Python！
keywords: linux, python, wordpress, 技术
author: kisa747
language: zh-CN
timezone:

# URL
## If your site is put in a subdirectory, set url as 'http://yoursite.com/child' and root as '/child/'
url: http://blog.kisa747.top
root: /
permalink: :title.html
permalink_defaults:

# Directory
source_dir: source
public_dir: public
tag_dir: tags
archive_dir: archives
category_dir: categories
code_dir: downloads/code
i18n_dir: lang
skip_render: README.md

# Writing
new_post_name: :title.md # File name of new posts
default_layout: post
titlecase: false # Transform title into titlecase
external_link:
    enable: true # Open external links in new tab
    field: site # Apply to the whole site
    exclude: ''
filename_case: 0
render_drafts: false
post_asset_folder: false
relative_link: false
future: true
highlight:
    enable: true
    line_number: true
    auto_detect: false
    tab_replace:

# Home page setting
# path: Root path for your blogs index page. (default = '')
# per_page: Posts displayed per page. (0 = disable pagination)
# order_by: Posts order. (Order by date descending by default)
index_generator:
    path: ''
    per_page: 10
    order_by: -date

# Category & Tag
default_category: uncategorized
category_map:
tag_map:

# Date / Time format
## Hexo uses Moment.js to parse and display date
## You can customize the date format as defined in
## http://momentjs.com/docs/#/displaying/format/
date_format: YYYY-MM-DD
time_format: HH:mm:ss

# Pagination
## Set per_page to 0 to disable pagination
per_page: 10
pagination_dir: page

# 自动截断
#excerpt:
#    depth: 5
#    excerpt_excludes: []
#    more_excludes: []
#    hideWholePostExcerpts: true

# Extensions
## Plugins: https://hexo.io/plugins/
## Themes: https://hexo.io/themes/
theme: fluid  # [next | fluid]

# Deployment
## Docs: https://hexo.io/docs/deployment.html
# username 换成自己的用户名和仓库名，去掉括号
deploy:
    type: git
    repo: git@github.com:kisa747/blog-backup.git
    branch: gh-pages
```

### 主题 hexo-theme-fluid

地址：<https://github.com/fluid-dev/hexo-theme-fluid>

文档：<https://hexo.fluid-dev.com/docs/>

预览：<https://hexo.fluid-dev.com/>

配置：

```sh
# 获取最新版本
npm install hexo-theme-fluid

# 更新主题
npm update --save hexo-theme-fluid
```

### 主题 NexT

NexT 主题官方文档：<https://theme-next.js.org/docs/getting-started/>

next 主题现在开发活跃，功能众多，配置也较多。

```sh
# 安装主题
npm install hexo-theme-next

# 升级主题
npm install hexo-theme-next@latest
```

旧版 NexT 主题升级方法

```sh
pwd_dir="`pwd`"
# 升级 next 主题
cd themes/next && git checkout master &&  git pull origin master:master; git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
cd source/lib/canvas-nest && git pull && cd $pwd_dir
pwd
```

### 更新包

npm 遵循 `package.json` 中声明的依赖声明要求，如果某个包出现大版本更新，或是更新版本不满足依赖声明规则，就无法更新，要么修改`package.json` ，要么单个更新指定包。

ncu 会检查哪些包有新的版本，并将新的版本号写入 `package.json` 文件中，无视依赖声明规则，比较方便，**推荐使用**。

```sh
# 安装 ncu 命令
npm install -g npm-check-updates

# 检查工作区 package.json 依赖项是否有更新
ncu
# 更新 package.json
ncu -u
# 根据 package.json 更新依赖项
npm install

# 查看全局的安装包是否有更新
ncu -g
#
ncu -u -g
```

版本控制规则：

```json
"dependencies": {
    "hexo": "^7.3.0",                     /* ^ 开头的版本会固定首个大版本，后面的两个小版本会更新到最新 */
    "hexo-deployer-git": "~4.0.0",        /* ~ 开头的版本会前两个版本，后面的小版本会更新到最新 */
    "hexo-generator-archive": "2.0.0",    /* 不带符号，直接写版本号会安装固定的版本，不更新 */
    "hexo-generator-tag": "latest",       /* 最新稳定版，不推荐这种写法*/
    "hexo-renderer-ejs": ">=2.0.0",       /* >= 大于等于指定版本，npm、ncu 更新后会自动将他改为 ^ */
    "hexo-renderer-marked": "^7.0.1"
}
```

## 插件

### 启用背景动态线条效果

参考：<https://github.com/theme-next/theme-next-canvas-nest>

 在 `hexo/source/_data` 目录下创建 `footer.njk`，内容如下：

```sh
<script color="0,0,255" opacity="0.5" zIndex="-1" count="99" src="https://cdn.jsdelivr.net/npm/canvas-nest.js@1/dist/canvas-nest.js"></script>
```

然后在配置文件 `_config.yml` 中修改：

```yaml
# _config.yml
custom_file_path:
  footer: source/_data/footer.njk
```

### 启用相关文章功能

要启用相关文章，需要安装 `hexo-related-popular-posts` 库。

```sh
npm install hexo-related-popular-posts --save
# 配置文件
  # Related popular posts
  # Dependencies: https://github.com/tea3/hexo-related-popular-posts
  related_posts:
    enable: true
    title: # custom header, leave empty to use the default one
    display_in_home: false
    params:
      maxCount: 5
      #PPMixingRate: 0.0
      #isDate: false
      #isImage: false
      #isExcerpt: false
```

### 自动截断

新版 Next 主题已经删除了这个选项，可以先安装插件，再进行相关配置就可以启用首页预览。

在网站根目录下运行：

```sh
npm install hexo-excerpt --save
```

在站点配置文件里添加（注意不要添加到主题的配置部分）：

```yaml
excerpt:
  depth: 5
  excerpt_excludes: []
  more_excludes: []
  hideWholePostExcerpts: true
```

### 开启站内搜索

在博客根目录执行：

```sh
npm install hexo-generator-json-content --save
```

## 创建页面

文章上面 `---` 包裹的部分叫做 Front matter，Typora 也是支持的。

### 创建归档 页面

```sh
hexo new page categories
```

编辑 source\categories\index.md，添加 `type: categories` 字段。

```markdown
---
layout: page
title: 分类
date: 2019-07-05 20:08:23
type: categories
comments: false
---
```

### 创建标签云页面

```sh
hexo new page tags
```

编辑 source\tags\index.md，添加 `type: tags` ，字段。

```markdown
---
layout: page
title: 标签云
date: 2019-07-05 20:05:06
type: tags
comments: false
---
```

### 创建关于页面

```sh
hexo new page about
```

编辑 source\about\index.md，添加 `type: about` ，字段。

```markdown
---
layout: page
title: 关于
date: 2009-07-05 20:11:32
comments: false
---
```

然后在主题配置中启用对应的功能。

### 创建 404 页面

参考：<https://help.github.com/en/articles/creating-a-custom-404-page-for-your-github-pages-site>

创建 source/404.md，内容如下：

```markdown
---
layout: page
title: 出错啦！
date: 2019-07-07 21:12:17
comments: false
permalink: 404.html
---

# 这是 404 页面

您会到达这个页面证明您刚刚点击了失效的链接。

当然，也可能是我搞错了...
```
