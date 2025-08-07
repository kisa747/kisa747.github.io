# Nodejs笔记

## nmp常用命令

```sh
# 查看 npm 版本
npm -v
# 查看当前目录安装的软件
npm ls
# 查看全局安装软件
npm ls -g

# 检查全局安装需要更新的包
npm outdated -g
# 更新全局安装的包：npm、hexo-cli
npm update -g
```

## 安装

推荐使用 scoop 安装 `nodejs-lts` 版，下面介绍的是从官方下载安装的版本

地址：<https://nodejs.org>，推荐使用 LTS 版。

> 安装 `Node.js` 。一定要勾选 `Add to PATH`（默认）

Portable 版 `Node.js` 安装方法：

1. 点击 Other Downloads，下载 `node-v**-win-x64.zip`，解压至任意具有写权限的目录，
2. 添加环景变量，修改 `npm` 全局下载位置。

在 `nodejs` 目录下创建如下内容的批处理文件 `全局设置.cmd`  ，然后运行。

```sh
@echo off
::全局设置
set nodejs=%~dp0
set npmrc=%nodejs%node_modules\npm\npmrc
echo "prefix = %nodejs%npm-global" > %npmrc%
echo "cache = %nodejs%npm-cache" >> %npmrc%

set add_path=%nodejs:~0,-1%

(reg query "HKCU\Environment" /v Path | find "%add_path%" > nul)&& goto ext
for /f "skip=2 tokens=3*"  %%i in ('reg query "HKCU\Environment" /v Path') do (set p=%%i%%j)
set user_path=%p%%add_path%;
setx PATH "%user_path%"
echo 成功添加了环境变量
pause & exit

:ext
echo.
echo 设置成功！
echo.
pause & exit
```

