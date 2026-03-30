# Node.js 笔记

## Node.js 管理

```sh
# 固定项目版本
node --version > .node-version
```

## nmp 常用命令

```sh
# 持久使用淘宝源
npm config set registry https://registry.npmmirror.com

# 查看 npm 版本
npm -v
# 查看当前目录安装的软件
npm ls
# 查看全局安装软件
npm ls -g

# 检查是否有更新
# 如果输出结果 wanted 小于 latest，想要更新的化，需要手动临时修改 package.json
# 可以临时将 ^ 改为 >，后面 update 会自动更新为 ^
npm outdated
# 更新包，并将包的版本信息更新至 package.json
# 注意 npm install 默认会将包依赖写入 package.json
# npm update 默认并不将新的版本号写入 package.json，所以需要指定 --save 参数
npm update --save

# 如果想更简单一点，可以使用 npm-check-updates
# 安装 ncu 命令
npm install -g npm-check-updates
# 检查项目包更新情况
ncu
# 写入 package.json
ncu -u
#安装更新
npm install

# 常用命令简写

npm up  # npm update
```

## 安装 Node.js

### Windows 下安装 Node.js

1. 使用 scoop 安装 `nodejs-lts` 版

```sh
scoop install nodejs-lts
```

2、使用 fnm 工具安装并管理 `nodejs`

```sh
scoop install fnm
```

下面介绍的是从官方下载安装的方法，不推荐。

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

### Linux 下安装

参考：<https://github.com/Schniz/fnm>

```sh
# 安装 curl
sudo apt install curl
# 安装 fnm，需要从 GitHub 下载，哎...
curl -fsSL https://fnm.vercel.app/install | bash
# 如果不成功，就手动下载脚本：https://github.com/Schniz/fnm/blob/master/.ci/install.sh
# 升级
curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell

# 安装成功后需要重新登录 shell
fnm -V  # 显示版本号，说明安装成功

# 更换国内源
export FNM_NODE_DIST_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/
# List all remote Node.js versions
fnm list-remote --lts --latest
# 安装最新的 lts 版，Install latest LTS
fnm install --lts

# 检查安装版本
node -v
npm -v

fnm use 16.5.0            # 切换到已经安装的某个版本（16.5.0）
fnm alias default 16.6.2  # 设置默认的 Node.js 版本（16.6.2）
fnm ls                    # 列出所有已经安装的 Node.js 版本
fnm uninstall 16.5.0      # 卸载某个已经安装的 Node.js 版本（16.5.0）
```
