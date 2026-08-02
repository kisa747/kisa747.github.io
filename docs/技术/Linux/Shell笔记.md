## Shell 笔记

参考：[编写 Shell 脚本的最佳实践，规范一](https://www.cnblogs.com/chengjian-physique/p/9260997.html)

 [编写 Shell 脚本的最佳实践，规范二](https://www.cnblogs.com/chengjian-physique/p/9260990.html)

[Shell 风格指南](<https://zh-google-styleguide.readthedocs.io/en/latest/google-shell-styleguide/contents/>)

[Bash 脚本教程](https://wangdoc.com/bash/index.html) By 阮一峰

[写出健壮的 Bash 脚本](https://blog.csdn.net/weixin_34292287/article/details/93970179)

### 用户 shell 环境信息

参考：<https://help.ubuntu.com/community/EnvironmentVariables>

<https://www.linuxidc.com/Linux/2016-09/135476.htm>

<https://www.linuxprobe.com/diff-bashrcprofile.html>

<https://blog.csdn.net/hymanjack/article/details/80285400>

通过查看 `~/.profile` 文件可知，`~/.bashrc` 是被 `~/.profile` 加载的。

>用户级文件：
>
>**~/.profile**：在登录时用到的第三个文件 是 .profile 文件，每个用户都可使用该文件输入专用于自己使用的 shell 信息，当用户登录时，该文件仅仅执行一次！默认情况下，他设置一些环境变量，执行用户的 .bashrc 文件。
>
>**~/.bashrc**：该文件包含专用于你的 bash shell 的 bash 信息，当登录时以及每次打开新的 shell 时，该文件被读取。不推荐放到这儿，因为每开一个 shell，这个文件会读取一次，效率上讲不好。

如果`.bashrc`文件被误删，`/etc/skel/.bashrc`有模板，复制一份就行了。

```sh
cp /etc/skel/.bashrc ~/
```

### 解释器

Debian、Ubuntu、LinuxMinit 默认的 shell 是 bash，sh 软连接的是 dash。

>GNU/Linux 操作系统中的 /bin/sh 本是 bash (Bourne-Again Shell) 的符号链接，但鉴于 bash 过于复杂，有人把 bash 从 NetBSD 移植到 Linux 并更名为 dash (Debian Almquist Shell)，并建议将 /bin/sh 指向它，以获得更快的脚本执行速度。Dash Shell 比 Bash Shell 小的多，符合 POSIX 标准。
>
>Debian 和 Ubuntu 中，/bin/sh 默认已经指向 dash，这是一个不同于 bash 的 shell，它主要是为了执行脚本而出现，而不是交互，它速度更快，但功能相比 bash 要少很多，语法严格遵守 POSIX 标准。
>
>Debian 和 Ubuntu 系统中内置的不少脚本就是用 dash 执行的。

Centos、Fedora 默认的 shell 都是 bash。

OpenWrt 由于空间限制，使用了 ash。

查看当前 shell：

```sh
$ echo $SHELL
/bin/bash

$ which bash
/usr/bin/bash

# 查看 sh 链接的内容
$ ls /bin/sh -al
lrwxrwxrwx 1 root root 4  8月 22  2021 /bin/sh -> dash
```

### shebang 写法

推荐使用 env 环境变量的写法，鉴于学习的 shell 知识都是基于 bash 的，所以直接指定 bash 作为解释器更为妥当。

```sh
# 推荐写法，因为 Debian 10，Fedora 的 bash 已经移至 /usr/bin/ 。
#!/usr/bin/env bash

# 其它的写法
#!/usr/bin/env sh
#!/usr/bin/bash
#!/bin/bash
#!/bin/sh
```

### 执行脚本

使用解释器直接调用脚本，不需要可执行权限

```sh
# 使用此方法运行脚本，甚至不需要在脚本的首行指定解释器
bash sample.sh
```

创建 `sample.sh` 后，要想直接运行，需要赋予可执行权限

```sh
chmod +x sample.sh
./sample.sh
```

### cat EOF 变量自动解析问题

参考：[shell cat EOF 变量自动解析问题](https://www.cnblogs.com/fsckzy/p/10837831.html)

方法 1：在 `$` 前加转义字符`\`，适用于变量少的情况

方法 2：第一个 EOF 加反斜杠，或用单引号、双引号包围。适用变量多的情况

第一个 EOF 加反斜杠，或用单引号、双引号包围。

注意：**需要注意的是，第一个 EOF 必须以重定向字符 `<<` 开始，第二个 `EOF` 必须顶格写**

```sh
cat << "EOF" | tee -a ~/.bashrc
alias rm=trash
trash()
{
  mv -f $@ ~/.trash/
}
EOF
```

> 1. EOF 只是一个标识而已，可以替换成任意的合法字符
> 2. 作为结尾的 delimiter 一定要顶格写，前面不能有任何字符
> 3. 作为结尾的 delimiter 后面也不能有任何的字符（包括空格）
> 4. 作为起始的 delimiter 前后的空格会被省略掉

### Linux 系统命令行快捷键

参考：[树莓派 Linux 系统命令行快捷键](<http://shumeipai.nxez.com/2018/09/26/raspberry-pi-linux-system-command-line-shortcuts.html>)

### 当前脚本路径

`$0` 表示了当前文件本身。**必须在脚本中才有效**。

```sh
#!/usr/bin/env bash

# 进入脚本所在目录，必须要有双引号，防止目录名中有空格。
# 此方法有问题。
# cd `dirname "$0"`

# 参考：https://github.com/koalaman/shellcheck/wiki/Sc2046
# 这才是最标准的写法，最外层的双引号，可以防止单词间的空格。
# 使用 $() 替代传统的 ``。
cd "$(dirname "$0")"

# 获取脚本的完整路径。
dir_name=$(cd "$(dirname "$0")"; pwd)
file_name=`basename "$0"`
path=${dir_name}/${file_name}
echo $path
```

### 安装 zsh

使用`cat /etc/shells`查看当前系统已安装的 shell。

安装 zsh：

```sh
sudo apt install zsh
# 安装后会提示修改默认 shell，如果没有设置，可以自己设置
chsh -s $(which zsh)
```

安装`Oh My Zsh`插件，主页：<https://github.com/robbyrussell/oh-my-zsh>

```sh
# 系统必须要有 git
sudo apt install git -y
sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

配置：

参考：<https://ehlxr.me/2016/09/24/using-oh-my-zsh/>

```sh
cp ~/.zshrc ~/.zshrc.bak
# 默认的主题
ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"
```

### Bash 插件

```sh
cat << "EOF" | tee -a ~/.bashrc
source ~/.config/bash/extract.sh
EOF
source ~/.bashrc

mkdir ~/.config/bash
touch ~/.config/bash/extract.sh
```

### 当前系统版本

参考：<https://www.linuxprobe.com/chapter-02.html>

```sh
# 当前系统版本
$ lsb_release -ds
Raspbian GNU/Linux 10 (buster)
```
