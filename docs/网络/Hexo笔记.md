# Hexo+Github Page搭建静态博客

Hexo 官方文档：<https://hexo.io/zh-cn/docs/>

## 环境搭建

### 安装 Node.js、Git

```sh
# scoop 依赖 git，所以只要有scoop，Git肯定已经安装。
# 安装 nodejs长期支持版本
scoop install nodejs-lts
```

### 安装 Hexo

选一块风水宝地作为hexo博客的主目录，比如：`E:\Hexo` ，在此目录下打开 Git Bash 。

>为保证命令都能顺利执行，推荐下面所有的命令都在 Git Bash 下操作。并且所有的操作都是在 Hexo 目录下。

Nodejs 的 npm 默认源实在太慢了，可以使用淘宝源或华为源。

```sh
# 临时使用
#npm --registry https://registry.npm.taobao.org install express
# 持久使用
npm config set registry https://registry.npmmirror.com
#npm config set registry https://mirrors.huaweicloud.com/repository/npm/

# 配置后可通过下面方式来验证是否成功 
npm config get registry
# 或是
npm info express
```

没有问题后就可以使用 npm安装了。

```sh
# 全局安装Hexo，为了能够使用hexo命令。
npm install hexo-cli -g

# 初始化Hexo
hexo init blog

# 创建网站，npm将会自动安装你需要的组件，只需要等待npm操作即可。
cd blog && npm install

# 下面这两个没必要全局安装
# 局部安装 Git 部署工具
npm install hexo-deployer-git --save

# 局部安装服务器模块
npm install hexo-server --save
```

启动 hexo 本地服务器：

```sh
hexo clean && hexo server
```

网站会在 <http://localhost:4000> 下启动。在服务器启动期间，Hexo 会监视文件变动并自动更新，无须重启服务器。

以上都没有问题了，就可以继续下面的工作。

## 配置 Git

1、设置Git的user name和email：

```sh
git config --global user.name "**"
git config --global user.email "**@qq.com"
```

2、如果没有密钥，运行Git Bash，输入命令生成密钥，默认位置在 `C:\User\用户名` 下

```sh
 ssh-keygen -t rsa -C "**@qq.com"
```

3、如果已经有密钥。复制公钥内容，即 `id_rsa.pub`  里的内容，进入 `GitHub— Personal settings—SSH andGPG keys—New SSH key`，粘贴公钥内容。

## 配置 GitHub

参考：https://help.github.com/articles/setting-up-an-apex-domain/

1. 创建一个名为：kisa747.github.io 的仓库
2. 在仓库的 Setting 绑定域名 kisa747.com
3. 勾选 github 绑定域名的 `Enforce HTTPS` 

解析域名到 GitHub

为确保只使用不带 www 的网址格式，就不要使用 `CNAME` 记录。

| 主机记录 | 记录类型 |     记录值      |
| :------: | :------: | :-------------: |
|    @     |    A     | 185.199.108.153 |
|    @     |    A     | 185.199.109.153 |
|    @     |    A     | 185.199.110153  |
|    @     |    A     | 185.199.111.153 |

如果要使用 www 格式的网址形式，只需要 `CNAME` 记录即可。

| 主机记录 | 记录类型 |      记录值       |
| :------: | :------: | :---------------: |
|    @     |  CNAME   | kisa747.github.io |

刷新本机DNS： `ipconfig /flushdns`

4. 点击 `Clone or download - Use SSH`，复制内容，就是博客的仓库地址。
5. 创建 `CNAME` 文件

在 `blog\source`  下创建 `CNAME`文件，添加 `kisa747.com` 字段。

```sh
echo kisa747.com > source/CNAME
```

## 配置 Hexo

修改网站配置 `_config.yml`，记得编码修改为 `utf8` 。

```yaml
# Site
title: 智行天下
subtitle: 人生苦短，我用Python！
description: 智行天下
keywords:
author: kisa747
language: zh-CN
timezone:

# URL
## If your site is put in a subdirectory, set url as 'http://yoursite.com/child' and root as '/child/'
url: https://kisa747.top
root: /
permalink: :title/
permalink_defaults:

# -----------------------
# 中间的代码不用修改
# -----------------------
# Extensions
## Plugins: https://hexo.io/plugins/
## Themes: https://hexo.io/themes/
theme: next

# Deployment
## Docs: https://hexo.io/docs/deployment.html
#username换成自己的用户名和仓库名,去掉括号
deploy:
  type: git
  repo: git@github.com:kisa747/kisa747.github.io.git
  branch: master
```

修改主题后，预览下效果：

```sh
# hexo clean 清除缓存文件、静态文件。修改`_config.yml` 后应该clean一下。 
hexo clean && hexo server
```

完成后，部署到github。就可以在github上看到博客了。

```sh
hexo clean && hexo d -g   # 生成静态文件后发布网站。
```

命令解释：`hexo g`  生成静态文件，`hexo d` 部署网站。

hexo 的一些命令：

```sh
hexo new [layout] <title>    #新建一片文章
```

## 更新 hexo

```sh
# 查看 npm 版本
npm -v
# 更新 npm 至最新版本
npm install -g npm@latest
npm -v

# 检查需要升级的包
npm outdated
# 升级全局安装的包： npm、hexo-cli
npm update -g
# 更新当前目录安装的包
npm update
```

## NexT 主题

NexT 主题官方文档：https://theme-next.js.org/docs/getting-started/

next 主题现在开发活跃，功能众多，配置也较多。

```sh
# 安装主题
npm install hexo-theme-next

# 升级主题，或者 npm update 所有当前目录的包
npm install hexo-theme-next@latest

# 查看当前版本
npm ls
```

## 插件

### 启用背景动态线条效果

参考：https://github.com/theme-next/theme-next-canvas-nest

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

新版Next主题已经删除了这个选项，可以先安装插件，再进行相关配置就可以启用首页预览。

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

编辑 source\categories\index.md，添加 `type: categories ` 字段。

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

创建 source/404.md ，内容如下：

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

当然, 也可能是我搞错了... 
```

## 其他主题

下载主题，所有的命令都必须在 hexo 目录下操作

```sh
# 默认主题
# theme: landscape
# 从Github下载主题
git clone https://github.com/A-limon/pacman.git themes/pacman
# 修改_config.yml中的theme配置
# theme : pacman
git clone https://github.com/theme-next/hexo-theme-next themes/next
# theme: next
git clone https://github.com/litten/hexo-theme-yilia.git themes/yilia
# theme: yilia
# 更新主题
cd themes/yilia
git pull
```

### yilia 主题

使用 yilia 主题，需要安装 `hexo-generator-json-content` 库。

## Hexo博客笔记

参考：https://theme-next.js.org/docs/theme-settings/#NexT-Quick-Start

https://zhiho.github.io/

https://www.jianshu.com/p/6f77c96b7eff

重装系统系统，只需要依次下面操作即可：

```sh
# 安装 nodejs-lts
scoop install nodejs-lts

# 全局安装 hexo-cli
npm install hexo-cli -g

# 升级全局安装的包： npm、hexo-cli
npm install npm -g
npm update -g
# 更新当前目录安装的包：hexo、插件、hexo-theme-next主题等
npm update

# 查看全局安装的包
npm ls -g
# 查看当前目录安装的包
npm ls

# 检查需要升级的包
npm outdated
npm outdated -g

npm install -g npm-check-updates

# 显示当前目录中项目的所有最新依赖项（不包括 peerDependencies）
ncu
# 查看全局的安装包最新版本
ncu -g

通过上述安装后得到的版本可得知


^ 开头的版本会固定首个大版本，后面的两个小版本会更新到最新，如 vue ^2.5.0 => vue 2.6.14


~ 开头的版本会前两个版本，后面的小版本会更新到最新 vuex ~3.1.0 => vuex 3.1.3


不带符号，直接写版本号会安装固定的版本 vue-router 3.5.3 => vue-router 3.5.3


最小的版本设置为 x 或者 *，其最小的版本号会更新到最新 react 15.4.x => react 15.4.2


依次类推任何一位版本设置为 x 或者 *，其当前位置的版本号都会更新到最新


永远保持最新版本可以将版本号设置为 x 或者 *，如 pinia * => pinia 2.0.12



# 更新 package.json 的最新依赖项
ncu -u
npm install
# 更新 package.json 的最新依赖项
ncu -u -g
```

## 更新包

npm工具仅能检查哪些有更新版本，无法批量更新至最新版，如果要 
