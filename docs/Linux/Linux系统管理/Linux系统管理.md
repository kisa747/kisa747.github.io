# Linux 系统管理

参考：[Linux 二零](https://itboon.github.io/linux-20/)

## 安装 cockpit 管理面板

Debian 下安装

```sh
sudo apt install cockpit

# 安装磁盘管理插件

```

## sudo 权限

参考：<https://man.linuxde.net/sudo>

**sudo 命令** 用来以其他身份来执行命令，预设的身份为 root。在`/etc/sudoers`中设置了可执行 sudo 指令的用户。若其未经授权的用户企图使用 sudo，则会发出警告的邮件给管理员。用户使用 sudo 时，必须先输入密码，之后有 5 分钟的有效期限，超过期限则必须重新输入密码。

配置 sudo 必须通过编辑`/etc/sudoers`文件，而且只有超级用户才可以修改它，还必须使用 visudo 编辑。之所以使用 visudo 有两个原因，一是它能够防止两个用户同时修改它；二是它也能进行有限的语法检查。所以，即使只有你一个超级用户，你也最好用 visudo 来检查一下语法。

其实一般来说，根本不用修改 `/etc/sudoers`文件，只用在 `/etc/sudoers.d/` 目录中新创建文件即可。

```sh
sudo sed '/^#/d;/^$/d' /etc/sudoers
# 显示如下：
# Defaults env_reset 表示默认会将环境变量重置为 secure_path，这样你定义的变量在 sudo 环境就会失效，获取不到。
Defaults        env_reset
Defaults        mail_badpass
# secure_path 的路径
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
root    ALL=(ALL:ALL) ALL
%sudo   ALL=(ALL:ALL) ALL
```

 注意：直接使用 sudo 命令与 sudo 执行脚本效果不一样。

```sh
sudo echo $PATH
# 显示如下：
/home/kevin/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games

sudo echo $HOME
# 显示如下：
/home/kevin

sudo echo $(whoami)
# 显示如下：
kevin

sudo echo $SUDO_USER
# 显示为空

# 创建一个脚本 ~/test.sh。
cat << "EOF" | tee ~/test.sh
#!/usr/bin/env bash

echo "我的家目录在： $HOME"
echo "我是谁：$(whoami)"
echo "\$SUDO_USER 变量是：$SUDO_USER"
exit 0
EOF

# 以 sudo 执行
sudo bash ~/test.sh
# 显示如下：
我的家目录在： /root
我是谁：root
$SUDO_USER变量是：kevin
```

### 脚本中使用 sudo

参考：<https://cloud.tencent.com/developer/article/1721853>

最好是使用 sudo 命令运行脚本。

```sh
sudo bash ./test.sh
```

然后在脚本中判断是否使用了 sudo 执行的脚本，如果不是就停止执行并报出错误。

```sh
if [ $(whoami) != "root" ]; then echo "请使用 sudo 执行此脚本！" && exit 1; fi
```

## linux 目录与文件的权限

参考：[Linux 中权限 (r、w、x) 对于目录与文件的意义](https://www.cnblogs.com/chengjian-physique/p/8878410.html)

Linux 中权限 (r、w、x) 对于目录与文件的意义

| 权限 |                          r（4）                          |                            w（2）                            |                w（1）                |
| :--: | :------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------: |
| 目录 | 可以查看目录下的文件名和子目录名，注意：仅仅指的是名字。 |                  更改该目录结构列表的权限。                  |     可以进入该目录成为工作目录。     |
| 文件 |                可以读取此文件的实际内容。                | 表示可以编辑、添加或者是修改该文件的内容。但是不包含删除该文件。 | 表示该文件具有可以被系统执行的权限。 |

  一、权限对于目录的意义

  1、首先要明白的是目录主要的内容是记录文件名列表和子目录列表，而不是实际存放数据的地方。

  2、r 权限：拥有此权限表示可以读取目录结构列表，也就是说可以查看目录下的文件名和子目录名，注意：仅仅指的是名字。

  3、w 权限：拥有此权限表示具有更改该目录结构列表的权限，总之，目录的 w 权限与该目录下的文件名或子目录名的变动有关，注意：指的是名字。具体如下：

  1）在该目录下新建新的文件或子目录。

  2）删除该目录下已经存在的文件或子目录（不论该文件或子目录的权限如何），注意：这点很重要，用户能否删除一个文件或目录，看的是该用户是否具有该文件或目录所在的目录的 w 权限。

  3）将该目录下已经存在的文件或子目录进行重命名。

  4）转移该目录内的文件或子目录的位置。

  4、x 权限：拥有目录的 x 权限表示用户可以进入该目录成为工作目录，能不能进入一个目录，只与该目录的 x 权限有关，如果用户对于某个目录不具有 x 权限，则无法切换到该目录下，也就无法执行该目录下的任何命令，即使具有该目录的 r 权限。且如果用户对于某目录不具有 x 权限，则该用户不能查询该目录下的文件的内容，注意：指的是内容，如果有 r 权限是可以查看该目录下的文件名列表或子目录列表的。所以要开放目录给任何人浏览时，应该至少要给与 r 及 x 权限。

  二、权限对于文件的意义

  1、也应该明白的是文件是实际含有数据的地方，所以 r、w、x 权限对文件来说是与其内容有关的。

  2、r 权限：用于此权限表示可以读取此文件的实际内容。

  3、w 权限：拥有此权限表示可以编辑、添加或者是修改该文件的内容。但是不包含删除该文件，因为由上面权限对于目录的意义得知删除文件或目录的条件是什么。

  4、x 权限：表示该文件具有可以被系统执行的权限。文件是否能被执行就是由该权限来决定的，跟文件名没有绝对的关系。

修改命令：

```sh
sudo chmod 777 ~/dir
```

## 发送邮件

### 使用 S-nail(S-mailx)

参考：<https://wiki.archlinux.org/index.php/S-nail>

软件主页：<https://www.sdaoden.eu/code.html>

<https://manpages.debian.org/buster/s-nail/s-nail.1.en.html>

推荐使用 `s-nail` ，可以提供完整的 `mail` 命令，自身就可以配置连接外部的 smtp 服务器、imap 服务器，不依赖其它 MTA 程序，非常的强大。如果是 `bsd-mailx` ，还得配置额外 MTA。

s-nail 全局配置文件`/etc/s-nail.rc`，用户配置文件`~/.mailrc`。配置用户文件记得`chmod 600`配置权限。

s-nail 会在 2020 年版本升级为 15.0，名字更改为 s-mailx，所以需要`set v15-compat`，这真是个奇葩的设定。

从 ini 文件中读取参数，参考：<https://blog.csdn.net/mightbxg/article/details/79121775>

最重要的参数就是要使用`smtps://`协议，就可以全程使用`TLS`，即使设置`smtp-use-starttls`参数也会被忽略。

```sh
sudo apt-get install s-nail
man s-nail | grep tls
#-------------------------------------------
sudo ln -s /usr/bin/s-nail /usr/bin/mail
if [ ! -f /etc/s-nail.rc.bak ]; then sudo cp /etc/s-nail.rc /etc/s-nail.rc.bak; fi
from_address=$(readini ~/.ssh/host.cfg mail from_address)
from_address_url_encode=$(echo $from_address | sed 's/@/%40/g')
echo $from_address_url_encode
to_address=$(readini ~/.ssh/host.cfg mail to_address)
pwd_encoded=$(readini ~/.ssh/host.cfg mail pwd)
pwd=$(echo $pwd_encoded | base64 -d -)
echo $pwd
if ! grep "兼容" /etc/s-nail.rc ; then

#-------------------------------------------
# 这一段代码有问题，暂时还解决不了
cat << EOF | sudo tee -a /etc/s-nail.rc
# 兼容 15.0 版
set v15-compat
# 仅支持 url encoded 字符，所以 @ 要转义为 %40
set mta=smtps://${from_address_url_encode}:${pwd}@smtp.qq.com:465 smtp-auth=login
set from="kisa757 <${from_address}>"
set mime-encoding="base64"
EOF
else
  echo "已经设置过/etc/s-nail.rc，无需重复设置！"
fi
#-------------------------------------------
# 测试发送邮件 -vv 显示详情
echo "正文" | mail -s "测试邮件" -vv $to_address
```

也可以不对 s-nail 进行任何配置，而是调用 sendmail 命令。

### 使用 msmtp（不推荐）

也可以使用 msmtp，但 msmtp 只能提供兼容 `sendmail` 的命令，无法提供 `mail` 命令。

参考：<https://wiki.archlinux.org/index.php/Msmtp>

<https://marlam.de/msmtp/msmtp.html>

```sh
# ssmtp 没有人维护了。
# mailutils 试了不行。
# bsd-mailx 还得 sudo dpkg-reconfigure exim4-config 配置后才能使用。
# msmtp-mta 包含 systemd 后台常驻提供 smtp 服务，软连接至 sendmail，所以没必要安装
sudo apt-get install msmtp -y

# 查看服务器的信息，查看端口号
msmtp --serverinfo --tls --tls-certcheck=off --host=smtp.qq.com

# 配置如下
from_address=$(readini ~/.ssh/host.cfg mail from_address)
to_address=$(readini ~/.ssh/host.cfg mail to_address)
pwd_encoded=$(readini ~/.ssh/host.cfg mail pwd)
pwd=$(echo $pwd_encoded | base64 -d -)
cat << EOF | sudo tee /etc/msmtprc
# Set default values for all following accounts.
defaults
tls on
# The SMTP server of the provider.
account qqmail
host smtp.qq.com
port 465
auth on
# 强制使用 tls，不使用 tls_starttls
tls_starttls off
from $from_address
user $from_address
password $pwd
# Set a default account
account default : qqmail
EOF

# 创建 sendmail 的软连接。
sudo ln -s /usr/bin/msmtp /usr/sbin/sendmail

# debug 参数发送邮件测试。
echo -e "subject: 测试邮件 \n\n 这是正文" | msmtp -d $to_address
```

## Systemd 服务管理

LinuxMint 默认采用 systemd 管理服务，Systemd 是 Linux 系统工具，用来启动[守护进程](http://www.ruanyifeng.com/blog/2016/02/linux-daemon.html)，已成为大多数发行版的标准配置。

参考：

* <http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html>
* <http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-part-two.html>
* <http://www.ruanyifeng.com/blog/2018/03/systemd-timer.html>
* <http://linux.vbird.org/linux_basic/0560daemons.php>
* <https://linux.cn/article-9700-1.html>
* <https://linux.cn/article-10182-1.html>
* <https://www.hi-linux.com/posts/3761.html>

历史上，Linux 的启动一直采用 `init` 进程。下面的命令用来启动服务。

```sh
sudo /etc/init.d/apache2 start
# 或者
service apache2 start
```

使用了 Systemd，就不需要再用`init`了。Systemd 取代了`initd`，成为系统的第一个进程（PID 等于 1），其他进程都是它的子进程。

Systemd 的优点是功能强大，使用方便，缺点是体系庞大，非常复杂。事实上，现在还有很多人反对使用 Systemd，理由就是它过于复杂，与操作系统的其他部分强耦合，违反"keep simple, keep stupid"的 Unix 哲学。

### 常用命令

```bash
# 查看 Systemd 的版本。
systemctl --version
# 不加任何参数，显示所有的服务
systemctl
# 查找指定的服务（在名称、描述中）
systemctl | grep -i "samba"
```

### 启动耗时分析

`systemd-analyze` 命令用于查看启动耗时。

```sh
# 查看启动耗时
systemd-analyze
# 查看每个服务的启动耗时
systemd-analyze blame
# 显示瀑布状的启动过程流
systemd-analyze critical-chain
# 显示指定服务的启动流
systemd-analyze critical-chain atd.service

# 列出正在运行的 Unit
systemctl list-units

# 列出所有 Unit，包括没有找到配置文件的或者启动失败的
$ systemctl list-units --all

# 列出所有没有运行的 Unit
$ systemctl list-units --all --state=inactive

# 列出所有加载失败的 Unit
$ systemctl list-units --failed

# 列出所有正在运行的、类型为 service 的 Unit
$ systemctl list-units --type=service
```

### 服务编写

参考：<http://www.jinbuguo.com/systemd/systemd.unit.html>

[systemd service 之：服务配置文件编写 (1)](https://www.junmajinlong.com/linux/systemd/service_1/)

在许多选项中都可以使用一些替换符 (不只是 [Install] 小节中的选项)，以引用一些运行时才能确定的值，从而可以写出更通用的单元文件。替换符必须是已知的、并且是可以解析的，这样设置才能生效。当前可识别的所有替换符及其解释如下：

表 4. 可以用在单元文件中的替换符

| 替换符 | 含义                                                         |
| :----: | ------------------------------------------------------------ |
|   %h   | 用户的家目录。运行 systemd 实例的用户的家目录，对于系统实例则是 "`/root`" |

### Unit 管理

systemd 有许多命令，常用的命令如下：

```sh
# 查看服务状态
systemctl status smbd.service
# 立即启动一个服务
sudo systemctl start smbd.service
# 立即停止一个服务
sudo systemctl stop smbd.service
# 重启一个服务
sudo systemctl restart smbd.service
# 杀死一个服务的所有子进程
sudo systemctl kill smbd.service
# 重新加载一个服务的配置文件
sudo systemctl reload smbd.service
# 一旦修改配置文件（*.service、*.timer 等文件），就要让 SystemD 重新加载配置文件，然后重新启动，否则修改不会生效。
# 重载所有修改过的配置文件
sudo systemctl daemon-reload
# 启用/禁用开机启动一个服务
sudo systemctl enable smbd.service
sudo systemctl disable smbd.service
```

### 日志管理

Systemd 统一管理所有 Unit 的启动日志。带来的好处就是，可以只用`journalctl`一个命令，查看所有日志（内核日志和应用日志）。日志的配置文件是`/etc/systemd/journald.conf`。

参考：

* <http://www.jinbuguo.com/systemd/journalctl.html>
* <http://www.jinbuguo.com/systemd/journald.conf.html>

大部分的配置都能通过 `journalctl` 命令实现，不需要直接修改配置文件。 `journalctl` 功能强大，用法非常多。

Debian 下，默认普通用户没有在 `systemd-journal`组，需要使用 sudo。或添加当前用户至 `systemd-journal` 组，重新登录后生效，不使用 sudo 就可以使用 journalctl 命令。

>每个用户都可以访问其专属的用户日志。但是默认情况下，只有 root 用户以及 "systemd-journal", "adm", "wheel" 组中的用户才可以访问全部的日志 (系统与其他用户)。注意，一般发行版还会给 "adm" 与 "wheel" 组一些其他额外的特权。例如 "wheel" 组的用户一般都可以执行一些系统管理任务。

参考：

* <https://www.cnblogs.com/jackyyou/p/5498083.html>
* <https://www.linuxprobe.com/chapter-05.html>

```sh
sudo adduser $USER adm
sudo usermod -G systemd-journal -a $USER
# 或是
sudo gpasswd -a $USER systemd-journal
# 从组中删除用户
sudo gpasswd -d $USER systemd-journal
```

常用命令：

```sh
# 查看所有日志（默认情况下，只保存本次启动的日志）
sudo journalctl
# 查看内核日志（不显示应用日志）
sudo journalctl -k
# 查看系统本次启动的日志
sudo journalctl -b
sudo journalctl -b -0
# 查看上一次启动的日志（需更改设置）
sudo journalctl -b -1

# 查看指定时间的日志
sudo journalctl --since="2012-10-30 18:17:16"
sudo journalctl --since "20 min ago"
sudo journalctl --since yesterday
sudo journalctl --since "2015-01-10" --until "2015-01-11 03:00"
sudo journalctl --since 09:00 --until "1 hour ago"

# 显示尾部的最新 10 行日志
sudo journalctl -n

# 显示尾部指定行数的日志
sudo journalctl -n 20

# 实时滚动显示最新日志
sudo journalctl -f

# 查看指定服务的日志
$ sudo journalctl /usr/lib/systemd/systemd

# 查看指定进程的日志
$ sudo journalctl _PID=1

# 查看某个路径的脚本的日志
$ sudo journalctl /usr/bin/bash

# 查看指定用户的日志
$ sudo journalctl _UID=33 --since today

# 查看某个 Unit 的日志
sudo journalctl -u nginx.service
sudo journalctl -u nginx.service --since today

# 实时滚动显示某个 Unit 的最新日志
$ sudo journalctl -u nginx.service -f

# 合并显示多个 Unit 的日志
$ journalctl -u nginx.service -u php-fpm.service --since today

# 查看指定优先级（及其以上级别）的日志，共有 8 级
# 0: emerg
# 1: alert
# 2: crit
# 3: err
# 4: warning
# 5: notice
# 6: info
# 7: debug
$ sudo journalctl -p err -b

# 日志默认分页输出，--no-pager 改为正常的标准输出
$ sudo journalctl --no-pager

# 以 JSON 格式（单行）输出
$ sudo journalctl -b -u nginx.service -o json

# 以 JSON 格式（多行）输出，可读性更好
$ sudo journalctl -b -u nginx.serviceqq -o json-pretty

# 显示日志占据的硬盘空间
$ sudo journalctl --disk-usage

# 指定日志文件占据的最大空间
$ sudo journalctl --vacuum-size=1G

# 指定日志文件保存多久
$ sudo journalctl --vacuum-time=1years
# 重启日志服务
sudo systemctl restart systemd-journald.service
```

### 持久化存储日志

参考：<https://www.digitalocean.com/community/tutorials/how-to-use-journalctl-to-view-and-manipulate-systemd-logs>

<http://www.jinbuguo.com/systemd/journald.conf.html>

Debian、Rasbian 默认只保存本次启动的日志，也就是仅临时保存在 `/run/log/journal` 目录中 (将会被自动按需创建)，重启后日志都会被丢弃。

Ubuntu 默认持久存储日志。保存在 `/var/log/journal` 目录中，因为系统已经自动创建了该目录。

主配置文件：`/etc/systemd/journald.conf`，所有选项都位于 "`[Journal]`" 小节：

```ini
Storage=auto
# 在哪里存储日志文件，默认值是 "auto"
# "persistent" 表示优先保存在磁盘上，也就优先保存在 /var/log/journal 目录中 (将会被自动按需创建)，但若失败 (例如在系统启动早期"/var"尚未挂载)，则转而保存在 /run/log/journal 目录中 (将会被自动按需创建)。
# "auto"(默认值) 与 "persistent" 类似，但不自动创建 /var/log/journal 目录，因此可以根据该目录的存在与否决定日志的保存位置。
# "volatile" 表示仅保存在内存中，也就是仅保存在 /run/log/journal 目录中 (将会被自动按需创建)，重启后消失。
# "none" 表示不保存任何日志 (直接丢弃所有收集到的日志)，但日志转发 (见下文) 不受影响。
```

因此，要想持久化存储日志，只需手动创建  `/var/log/journal` 目录。或是修改 `Storage=persistent` 。

```sh
# 持久化存储日志
sudo mkdir -p /var/log/journal
# 限制日志容量
if [ ! -f /etc/systemd/journald.conf.bak ]; then sudo cp /etc/systemd/journald.conf /etc/systemd/journald.conf.bak; fi
cat << "EOF" | sudo tee /etc/systemd/journald.conf
[Journal]
Storage=persistent
# 默认值"yes"表示 压缩存储大于特定阈值 (默认为 512 字节) 的对象。也可以直接设置一个 字节值 (可以带有 K, M, G 后缀) 表示的阈值，表示压缩存储 大于指定阈值的对象。
Compress=yes
# 限制日志文件的大小上限为 500M。以 "System" 开头的选项用于限制磁盘使用量，也就是 /var/log/journal 的使用量。
SystemMaxUse=500M
EOF
sudo systemctl restart systemd-journald.service
# 查看日志磁盘占用情况。
journalctl --disk-usage
# 查看日志服务的情况。
journalctl -u systemd-journald.service
```

### 创建服务

参考：<http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-part-two.html>

`systemctl cat`命令可以用来查看配置文件，下面以`sshd.service`文件为例，它的作用是启动一个 SSH 服务器，供其他用户以 SSH 方式登录。

```ini
$ systemctl cat sshd.service

[Unit]
Description=OpenSSH server daemon
Documentation=man:sshd(8) man:sshd_config(5)
After=network.target sshd-keygen.service
Wants=sshd-keygen.service

[Service]
EnvironmentFile=/etc/sysconfig/sshd
ExecStart=/usr/sbin/sshd -D $OPTIONS
ExecReload=/bin/kill -HUP $MAINPID
Type=simple
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target
```

`Unit`区块的`Description`字段给出当前服务的简单描述，`Documentation`字段给出文档位置。

接下来的设置是启动顺序和依赖关系，这个比较重要。

> `After`字段：表示如果`network.target`或`sshd-keygen.service`需要启动，那么`sshd.service`应该在它们之后启动。相应地，还有一个`Before`字段，定义`sshd.service`应该在哪些服务之前启动。

注意，`After`和`Before`字段只涉及启动顺序，不涉及依赖关系。举例来说，某 Web 应用需要 postgresql 数据库储存数据。在配置文件中，它只定义要在 postgresql 之后启动，而没有定义依赖 postgresql。上线后，由于某种原因，postgresql 需要重新启动，在停止服务期间，该 Web 应用就会无法建立数据库连接。

设置依赖关系，需要使用`Wants`字段和`Requires`字段。

> `Wants` 字段：表示`sshd.service`与`sshd-keygen.service`之间存在"弱依赖"关系，即如果"sshd-keygen.service"启动失败或停止运行，不影响`sshd.service`继续执行。
>
> Requires 字段则表示"强依赖"关系，即如果该服务启动失败或异常退出，那么`sshd.service`也必须退出。

注意，`Wants`字段与`Requires`字段只涉及依赖关系，与启动顺序无关，默认情况下是同时启动的。

### 启动 target

```bash
# 查看当前系统的所有 Target
systemctl list-unit-files --type=target

# 查看一个 Target 包含的所有 Unit
systemctl list-dependencies multi-user.target

# 查看启动时的默认 Target
systemctl get-default

# 设置启动时的默认 Target，如果没有安装桌面环境，2个效果基本一样。
# 多用户，纯文本启动模式
sudo systemctl set-default multi-user.target
# 图形界面启动模式
sudo systemctl set-default graphical.target

# 切换 Target 时，默认不关闭前一个 Target 启动的进程，
# systemctl isolate 命令改变这种行为，
# 关闭前一个 Target 里面所有不属于后一个 Target 的进程
sudo systemctl isolate multi-user.target
```

Target 与 传统 RunLevel 的对应关系如下。

```bash
Traditional runlevel      New target name     Symbolically linked to...
Runlevel 0           |    runlevel0.target -> poweroff.target
Runlevel 1           |    runlevel1.target -> rescue.target
Runlevel 2           |    runlevel2.target -> multi-user.target
Runlevel 3           |    runlevel3.target -> multi-user.target
Runlevel 4           |    runlevel4.target -> multi-user.target 纯文字界面
Runlevel 5           |    runlevel5.target -> graphical.target 图形界面
Runlevel 6           |    runlevel6.target -> reboot.target
```

## 软件包管理

### APT 常用命令

参考：[Debian 参考手册](https://www.debian.org/doc/manuals/debian-reference/ch02.zh-cn.html#_literal_apt_literal_vs_literal_apt_get_literal_literal_apt_cache_literal_vs_literal_aptitude_literal)

建议用户使用新的 apt(8) 命令用于 **交互式**的使用场景，而在 shell 脚本中使用 apt-get(8) 和 apt-cache(8) 命令。

参考：<https://askubuntu.com/questions/194651/why-use-apt-get-upgrade-instead-of-apt-get-dist-upgrade>

#### APT 命令

```sh
# 从软件源服务器获取最新的软件信息并缓存到本地。
# 因为很多 apt 的其他命令都是要通过比对版本信息来进行操作的，如果每次都去对比线上的版本信息效率肯定不理想，也没必要，所以做了一个缓存的机制。
apt update
# 从本地仓库中对比系统中所有已安装的软件，如果有新版本的话则进行升级
apt upgrade
# apt full-upgrade performs the same function as `apt-get dist-upgrade`.will install or remove packages as necessary to complete the upgrade
apt full-upgrade
# 列出本地仓库中所有的软件包名
apt list
# 从本地仓库中查找指定的包名，支持通配符，比如"apt list zlib*"就能列出以 zlib 开头的所有包名
# 可以看到，如果包名后面带有"[installed]"表示该软件已经安装
apt list [package]
# 列出系统中所有已安装的包名
apt list --installed
# 与 list 类似，通过给出的关键字进行搜索，列出所有的包和其描述
apt search [key]
# 列出指定包的详细情况，包名要填写完整。
# 可以看到非常完整的信息，比如版本、大小、依赖的其他包等。
apt show [package]
# 安装指定的包，并同时安装其依赖的其他包。
apt install [package]
# 卸载包，但不删除相关配置文件。包名支持通配符
apt remove [package]
# 卸载包，同时删除相关配置文件。包名支持通配符
apt purge [package]
# 卸载因安装软件自动安装的依赖，而现在又不需要的依赖包 
apt autoremove
# 删除所有已下载的软件包
apt clean
# 类似 clean，但删除的是过期的包（即已不能下载或者是无用的包）
apt autoclean

# 查询依赖
apt-cache depends libraw-bin
# 检查优先级设置
apt-cache policy python3
apt-cache policy python-rpi.gpio
# 安装 testing 的软件包，也从 testing 源里找依赖，这是比较保险的从 testing 源中安装软件的方法。
sudo apt -t testing install python3
```

#### apt-cache 命令

```sh
apt-cache search package_name     #查找一个软件包
apt-cache show package_name       #查看软件包信息
apt-cache policy package_name     #查看软件包信息
apt-cache depends package_name    #查看软件包的依赖关系
apt-cache dump                    #查看每个软件包的简要信息
apt-cache pkgnames                #列出当前所有可用的软件包
apt-cache search vsftpd           #查找软件包并列出该软件包的相关信息
apt-cache pkgnames vsftp          #找出所有以 vsftpd 开头的软件包
apt-cache stats                   #查看软件包总体信息
```

#### apt-get 命令

```sh
sudo apt-get install package_name       #安装一个软件包
sudo apt-get install vsftpd=2.3.5       #安装指定版本的包文件
sudo apt-get upgrade                    #更新已安装的软件包，upgrade 子命令会更新当前系统中所有已安装的软件包，并同时所更新的软件包相关的软件包
sudo apt-get install packageName --no-upgrade    #--no-upgrade 会阻止已经安装过的文件进行更新操作
sudo apt-get install packageName --only-upgrade    #--only-upgrade 只会更新已经安装过的文件，并不会安装新文件
sudo apt-get update                           #更新软件包索引文件
sudo apt-get remove package_name              #卸载一个软件包但是保留相关的配置文件
sudo apt-get --purge remove package_name      #卸载一个软件包同时删除配置文件
sudo apt-get purge package_name               #卸载一个软件包同时删除配置文件
sudo apt-get clean                            #删除软件包的备份
sudo apt-get --download-only source vsftpd    #只下载软件源码包
sudo apt-get source vsftpd                    #下载并解压包
sudo apt-get --compile source goaccess        #下载、解压并编译
sudo apt-get download nethogs                 #仅将软件包下载到当前工作目录中
sudo apt-get changelog vsftpd/apt-get check   #查看软件包的日志信息
sudo apt-get build-dep netcat                 #在当前系统中的本地包库中查看指定包的依赖包并对以来包进行安装
```

### APT Pinning

参考：<https://wiki.debian.org/zh_CN/AptPreferences>

<https://manpages.debian.org/buster/apt/apt_preferences.5.en.html>

<https://linux.cn/article-3288-1.html>

```bash
# 当Buster还没有进入stable时，设置的testing软件源其实就是Buster。
if grep "testing main" /etc/apt/sources.list ; then
 echo "已经设置过testing源，无需重复设置！"
else
 echo "deb https://mirrors.ustc.edu.cn/raspbian/raspbian/ testing main contrib non-free rpi" | sudo tee -a /etc/apt/sources.list
 echo "设置testing源成功！"
fi
# 调低testing源的优先级
cat << "EOF" | sudo tee /etc/apt/preferences.d/10preferences
Package: *
Pin: release a=testing
Pin-Priority: 400
EOF

apt policy python3
# 如果要安装testing版的python3
sudo apt install -t testing python3
# 如果要切换为stable版
sudo apt install python3/stable
```

### APT 自动更新

参考：<https://wiki.debian.org/UnattendedUpgrades>

<https://manpages.debian.org/buster/apt-listchanges/apt-listchanges.1.en.html>

<https://www.debian.org/doc/manuals/debian-handbook/sect.automatic-upgrades.zh-cn.html>

<https://www.debian.org/doc/manuals/debian-handbook/sect.package-meta-information.zh-cn.html#sidebar.questions-conffiles>

<https://www.debian.org/doc/manuals/debian-reference/ch02.zh-cn.html#_automatic_download_and_upgrade_of_packages>

Debian Buster 10 默认安装 了`apt-listchanges`，但是没有安装`unattended-upgrades`，如果安装桌面环境会提示安装。参考官方 WIKI，系统默认有 apt-daily.timer、apt-daily-upgrade.timer 两个定时器，能自动运行 apt update，如果要自动  upgrade，需要使用`unattended-upgrades`配合。

> 原理：
>
> apt-daily.service、apt-daily-upgrade.service 两个服务，均是通过执行 `/usr/lib/apt/apt.systemd.daily`脚本，分别调用 update、install 参数。
>
> 默认情况下，每天 6 点、18 点执行 apt-get update，默认不更新、默认不下载更新包，等于默认情况下啥也没做。
>
> 默认情况下，每天 6 点执行 apt-daily-upgrade，默认不 clean、autoclean，配合 unattended-upgrades，可以更新指定类型的包。等于默认情况下啥也没做。
>
> 如果要自动下载更新包、自动 apt-get clean、apt-get autoclean，需要配置：/etc/apt/apt.conf.d/10periodic（默认无此文件，需手动创建，模板文件在 `/usr/lib/apt/apt.systemd.daily` 中）
>
> 如果要自动安装更新，需要安装 unattended-upgrades，并配置好 unattended-upgrades，默认安装后 unattended-upgrades 不启用。可以手动启动`dpkg-reconfigure -plow unattended-upgrades`（他创建的是 20auto-upgrades），也可手动创建`/etc/apt/apt.conf.d/10periodic`（推荐使用此方法，模板参考`/usr/lib/apt/apt.systemd.daily`）。

从`/usr/lib/apt/apt.systemd.daily` 中的模板文件可知，默认情况下，两个定时器其实啥也没干。因此需要手动配置`/etc/apt/apt.conf.d/10periodic` 的内容，或是`20auto-upgrades`。

```sh
#------------------------------------------------
# 如果要自动安装更新，需要安装 unattended-upgrades
sudo apt-get install unattended-upgrades -y
#------------------------------------------------
# 配置自动更新
cat << "EOF" | sudo tee /etc/apt/apt.conf.d/10periodic
# 模板参考自：/usr/lib/apt/apt.systemd.daily
APT::Periodic::Update-Package-Lists "30";
#  - Do "apt-get update" automatically every n-days (0=disable)
APT::Periodic::Download-Upgradeable-Packages "30";
#  - Do "apt-get upgrade --download-only" every n-days (0=disable)
APT::Periodic::AutocleanInterval "30";
#  - Do "apt-get autoclean" every n-days (0=disable)
APT::Periodic::CleanInterval "30";
#  - Do "apt-get clean" every n-days (0=disable)
APT::Periodic::Unattended-Upgrade "30";
#  - Run the "unattended-upgrade" security upgrade script
#    every n-days (0=disabled)
#    Requires the package "unattended-upgrades" and will write
#    a log in /var/log/unattended-upgrades
APT::Periodic::Verbose "0";
#  - Send report mail to root
#      0:  no report，默认值      (or null string)
#      1:  progress report       (actually any string)
#      2:  + command outputs     (remove -qq, remove 2>/dev/null, add -d)
#      3:  + trace on
EOF
#------------------------------------------------
sudo systemctl restart apt-daily.timer
sudo systemctl restart apt-daily-upgrade.timer
cat /etc/apt/apt.conf.d/10periodic

# 默认的配置有很多不合理的，比如默认立即自动重启。
# 默认的配置竟然不全，还得参考它的 readme 文件
# 参考 `/usr/share/doc/unattended-upgrades/README.md.gz`，可以配置 Sender 选项。
# 这个地方不能备份。
mkdir -p ~/.local/etc/apt/apt.conf.d
if [ ! -f ~/.local/etc/apt/apt.conf.d/50unattended-upgrades.bak ]; then cp /etc/apt/apt.conf.d/50unattended-upgrades ~/.local/etc/apt/apt.conf.d/50unattended-upgrades.bak; fi
cat << "EOF" | sudo tee /etc/apt/apt.conf.d/50unattended-upgrades
Unattended-Upgrade::Origins-Pattern {
// Debian使用下面的：
        "origin=Debian,codename=${distro_codename}-updates";
        "origin=Debian,codename=${distro_codename},label=Debian-Security";
// 使用 sudo apt-cache policy 查看信息
// 树莓派使用下面的：
//        "origin=Raspbian";
        "origin=Raspberry Pi Foundation";
        "origin=Syncthing,a=syncthing,n=debian,c=stable";
};
Unattended-Upgrade::Package-Blacklist {
//      "vim";
};
Unattended-Upgrade::Automatic-Reboot-WithUsers "false";
Unattended-Upgrade::Mail "kisa747@qq.com";
Unattended-Upgrade::Sender "kisa757@qq.com";
Unattended-Upgrade::MailOnlyOnError "false";

// Do automatic removal of unused packages after the upgrade
// (equivalent to apt-get autoremove)
//Unattended-Upgrade::Remove-Unused-Dependencies "false";
EOF
#------------------------------------------------
# 使用调试模式手动运行 unattended-upgrade，看看它是否正常工作 :
sudo apt update
# debug 参数、不真正运行。能看出各种参数，方便调试。
sudo unattended-upgrade -d --dry-run
# 模拟定时器真正运行
sudo /usr/lib/apt/apt.systemd.daily update
sudo /usr/lib/apt/apt.systemd.daily install
# 常看定时器情况
systemctl status apt-daily.timer
systemctl status apt-daily-upgrade.timer
```

查看下它的默认配置文件`/etc/apt/apt.conf.d/50unattended-upgrades`：

```sh
# 下面是 /etc/apt/apt.conf.d/50unattended-upgrades 非注释内容
# ----------------------------------------------------------------------------
grep -v -E "^\s*?/|^$" /etc/apt/apt.conf.d/50unattended-upgrades
# 其实全是注释，有用的就是下面的：
Unattended-Upgrade::Origins-Pattern {
        "origin=Debian,codename=${distro_codename},label=Debian";
        "origin=Debian,codename=${distro_codename},label=Debian-Security";
};
Unattended-Upgrade::Package-Blacklist {
};
# ----------------------------------------------------------------------------
#        "origin=Debian,codename=${distro_codename}-proposed-updates";
#        "origin=Debian,codename=${distro_codename},label=Debian";

# 下面是/etc/apt/apt.conf.d/50unattended-upgrades 的原始内容
# ----------------------------------------------------------------------------
// Unattended-Upgrade::Origins-Pattern controls which packages are
// upgraded.
//
// Lines below have the format format is "keyword=value,...".  A
// package will be upgraded only if the values in its metadata match
// all the supplied keywords in a line.  (In other words, omitted
// keywords are wild cards.) The keywords originate from the Release
// file, but several aliases are accepted.  The accepted keywords are:
//   a,archive,suite (eg, "stable")
//   c,component     (eg, "main", "contrib", "non-free")
//   l,label         (eg, "Debian", "Debian-Security")
//   o,origin        (eg, "Debian", "Unofficial Multimedia Packages")
//   n,codename      (eg, "jessie", "jessie-updates")
//     site          (eg, "http.debian.net")
// The available values on the system are printed by the command
// "apt-cache policy", and can be debugged by running
// "unattended-upgrades -d" and looking at the log file.
//
// Within lines unattended-upgrades allows 2 macros whose values are
// derived from /etc/debian_version:
//   ${distro_id}            Installed origin.
//   ${distro_codename}      Installed codename (eg, "buster")
Unattended-Upgrade::Origins-Pattern {
        // Codename based matching:
        // This will follow the migration of a release through different
        // archives (e.g. from testing to stable and later oldstable).
        // Software will be the latest available for the named release,
        // but the Debian release itself will not be automatically upgraded.
//      "origin=Debian,codename=${distro_codename}-updates";
//      "origin=Debian,codename=${distro_codename}-proposed-updates";
        "origin=Debian,codename=${distro_codename},label=Debian";
        "origin=Debian,codename=${distro_codename},label=Debian-Security";

        // Archive or Suite based matching:
        // Note that this will silently match a different release after
        // migration to the specified archive (e.g. testing becomes the
        // new stable).
//      "o=Debian,a=stable";
//      "o=Debian,a=stable-updates";
//      "o=Debian,a=proposed-updates";
//      "o=Debian Backports,a=${distro_codename}-backports,l=Debian Backports";
};

// Python regular expressions, matching packages to exclude from upgrading
Unattended-Upgrade::Package-Blacklist {
    // The following matches all packages starting with linux-
//  "linux-";

    // Use $ to explicitely define the end of a package name. Without
    // the $, "libc6" would match all of them.
//  "libc6$";
//  "libc6-dev$";
//  "libc6-i686$";

    // Special characters need escaping
//  "libstdc\+\+6$";

    // The following matches packages like xen-system-amd64, xen-utils-4.1,
    // xenstore-utils and libxenstore3.0
//  "(lib)?xen(store)?";

    // For more information about Python regular expressions, see
    // https://docs.python.org/3/howto/regex.html
};

// This option allows you to control if on a unclean dpkg exit
// unattended-upgrades will automatically run
//   dpkg --force-confold --configure -a
// The default is true, to ensure updates keep getting installed
//Unattended-Upgrade::AutoFixInterruptedDpkg "true";

// Split the upgrade into the smallest possible chunks so that
// they can be interrupted with SIGTERM. This makes the upgrade
// a bit slower but it has the benefit that shutdown while a upgrade
// is running is possible (with a small delay)
//Unattended-Upgrade::MinimalSteps "true";

// Install all updates when the machine is shutting down
// instead of doing it in the background while the machine is running.
// This will (obviously) make shutdown slower.
// Unattended-upgrades increases logind's InhibitDelayMaxSec to 30s.
// This allows more time for unattended-upgrades to shut down gracefully
// or even install a few packages in InstallOnShutdown mode, but is still a
// big step back from the 30 minutes allowed for InstallOnShutdown previously.
// Users enabling InstallOnShutdown mode are advised to increase
// InhibitDelayMaxSec even further, possibly to 30 minutes.
//Unattended-Upgrade::InstallOnShutdown "false";

// Send email to this address for problems or packages upgrades
// If empty or unset then no email is sent, make sure that you
// have a working mail setup on your system. A package that provides
// 'mailx' must be installed. E.g. "user@example.com"
//Unattended-Upgrade::Mail "";

// Set this value to "true" to get emails only on errors. Default
// is to always send a mail if Unattended-Upgrade::Mail is set
//Unattended-Upgrade::MailOnlyOnError "false";

// Remove unused automatically installed kernel-related packages
// (kernel images, kernel headers and kernel version locked tools).
//Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";

// Do automatic removal of newly unused dependencies after the upgrade
//Unattended-Upgrade::Remove-New-Unused-Dependencies "true";

// Do automatic removal of unused packages after the upgrade
// (equivalent to apt-get autoremove)
//Unattended-Upgrade::Remove-Unused-Dependencies "false";

// Automatically reboot *WITHOUT CONFIRMATION* if
//  the file /var/run/reboot-required is found after the upgrade
//Unattended-Upgrade::Automatic-Reboot "false";

// Automatically reboot even if there are users currently logged in
// when Unattended-Upgrade::Automatic-Reboot is set to true
//Unattended-Upgrade::Automatic-Reboot-WithUsers "true";

// If automatic reboot is enabled and needed, reboot at the specific
// time instead of immediately
//  Default: "now"
//Unattended-Upgrade::Automatic-Reboot-Time "02:00";

// Use apt bandwidth limit feature, this example limits the download
// speed to 70kb/sec
//Acquire::http::Dl-Limit "70";

// Enable logging to syslog. Default is False
// Unattended-Upgrade::SyslogEnable "false";

// Specify syslog facility. Default is daemon
// Unattended-Upgrade::SyslogFacility "daemon";

// Download and install upgrades only on AC power
// (i.e. skip or gracefully stop updates on battery)
// Unattended-Upgrade::OnlyOnACPower "true";

// Download and install upgrades only on non-metered connection
// (i.e. skip or gracefully stop updates on a metered connection)
// Unattended-Upgrade::Skip-Updates-On-Metered-Connections "true";

// Verbose logging
// Unattended-Upgrade::Verbose "false";

// Print debugging information both in unattended-upgrades and
// in unattended-upgrade-shutdown
// Unattended-Upgrade::Debug "false";

```

查看日志：

```sh
cat /var/log/unattended-upgrades/unattended-upgrades.log
```

### 安装软件组合

Debian 下有：

```sh
# 进入命令行交互界面，可以选择安装哪个桌面
sudo tasksel
# 列出可以安装的桌面环境
tasksel --list-tasks
tasksel --task-packages cinnamon-desktop
sudo tasksel install cinnamon-desktop
sudo tasksel install gnome-desktop
```

Fedora 下有：

```sh
# 检查有哪些可用的桌面环境
dnf grouplist -v
# 安装 Cinnamon
sudo dnf install @cinnamon-desktop-environment
# sudo dnf install switchdesk switchdesk-gui
# 重启
```

### apt upgrade 与 dist-upgrade 对比

Below is an excerpt from `man apt-get`. **Using upgrade keeps to the rule: under no circumstances are currently installed packages removed, or packages not already installed retrieved and installed.** If that's important to you, use `apt-get upgrade`. If you want things to "just work", you probably want `apt-get dist-upgrade` to ensure dependencies are resolved.

To expand on why you'd want *upgrade* instead of *dist-upgrade*, if you are a systems administrator, you need predictability. You might be using advanced features like [apt pinning](http://wiki.debian.org/AptPreferences) or pulling from a collection of [PPAs](https://launchpad.net/ubuntu/+ppas) (perhaps you have an in-house PPA), with various automations in place to inspect your system and available upgrades instead of always eagerly upgrading all available packages. You would get very frustrated when apt performs unscripted behavior, particularly if this leads to downtime of a production service.

> upgrade
> upgrade is used to install the newest versions of all packages
> currently installed on the system from the sources enumerated in
> /etc/apt/sources.list. Packages currently installed with new
> versions available are retrieved and upgraded; under no
> circumstances are currently installed packages removed, or packages
> not already installed retrieved and installed. New versions of
> currently installed packages that cannot be upgraded without
> changing the install status of another package will be left at
> their current version. An update must be performed first so that
> apt-get knows that new versions of packages are available.
>
> dist-upgrade
> dist-upgrade in addition to performing the function of upgrade,
> also intelligently handles changing dependencies with new versions
> of packages; apt-get has a "smart" conflict resolution system, and
> it will attempt to upgrade the most important packages at the
> expense of less important ones if necessary. So, dist-upgrade
> command may remove some packages. The /etc/apt/sources.list file
> contains a list of locations from which to retrieve desired package
> files. See also apt_preferences(5) for a mechanism for overriding
> the general settings for individual packages.

### snap 命令

参考：<https://www.addictivetips.com/ubuntu-linux-tips/enable-snap-package-support-linux-mint/>

```sh
snap find "program name"
sudo snap install programname
# 更新 snap 软件
sudo snap refresh
# 升级指定的 Snap 软件包
sudo snap refresh "包名"
# 检查那些包能更新
snap refresh --list
# 卸载软件
sudo snap remove programname
# 列出已经安装的包
sudo snap list
```

## GRUB 管理

参考：<https://www.debian.org/doc/manuals/debian-handbook/sect.config-bootloader.zh-cn.html#sect.config-grub>

<https://help.ubuntu.com/community/Grub2>

<https://help.ubuntu.com/community/Grub2/Setup>

<https://www.gnu.org/software/grub/manual/grub/html_node/Simple-configuration.html>

### 修改默认启动项

```sh
# 修改默认启动项
sudo grub-set-default 0
```

### 修改 GRUB 启动等待时间

树莓派没有 grub

```sh
if [ ! -f /etc/default/grub.bak ]; then sudo cp /etc/default/grub /etc/default/grub.bak; fi
# GRUB 启动时间设置为 3 秒
sudo sed -i 's/^GRUB_TIMEOUT=.*$/GRUB_TIMEOUT=3/' /etc/default/grub
sudo update-grub
# If you change this file, run 'update-grub' afterwards to update /boot/grub/grub.cfg.
# For full documentation of the options in this file, see: info -f grub -n 'Simple configuration'
```

GRUB 2 configuration is stored in `/boot/grub/grub.cfg`, but this file (in Debian) is generated from others. Be careful not to modify it by hand, since such local modifications will be lost the next time `update-grub` is run (which may occur upon update of various packages). The most common modifications of the `/boot/grub/grub.cfg` file (to add command line parameters to the kernel or change the duration that the menu is displayed, for example) are made through the variables in `/etc/default/grub`. To add entries to the menu, you can either create a `/boot/grub/custom.cfg` file or modify the `/etc/grub.d/40_custom` file. For more complex configurations, you can modify other files in `/etc/grub.d`, or add to them; these scripts should return configuration snippets, possibly by making use of external programs. These scripts are the ones that will update the list of kernels to boot: `10_linux` takes into consideration the installed Linux kernels; `20_linux_xen` takes into account Xen virtual systems, and `30_os-prober` lists other operating systems (Windows, OS X, Hurd).

## 磁盘管理

参考：<https://www.debian.org/doc/manuals/debian-reference/ch09.zh-cn.html#_disk_space_usage>

mount 中文手册 <http://www.jinbuguo.com/man/mount.html>

fstab WIKI <https://wiki.archlinux.org/index.php/Fstab_(简体中文)>

浅析 fstab 与移动硬盘挂载方法 <http://shumeipai.nxez.com/2019/01/17/fstab-and-mobile-hard-disk-mounting-method.html>

<http://www.jinbuguo.com/systemd/systemd-gpt-auto-generator.html>

### 常用命令

```bash
# lsblk添加 f 参数可以查看文件系统的格式、UUID
lsblk -f
# 查看设备块的UUID、PARTUUID
blkid
# df 也能看出分区格式
df -hT

# 使用分区工具也可以
# gdisk可以查看分区类型代码
sudo gdisk -l /dev/sda
sudo fdisk -l
# parted可以区别 FAT32、FAT16
sudo parted -l

# 修改卷标
sudo tune2fs -L orico /dev/sdb1
# 修改 UUID
sudo tune2fs -U **** /dev/sdb1

# 检查挂载日志
sudo journalctl -u
```

### 自动挂载

参考：<http://www.jinbuguo.com/storage/gpt.html>

<http://www.jinbuguo.com/systemd/systemd-gpt-auto-generator.html>

借助 `systemd-gpt-auto-generator` 工具，Linux 可以将文件系统的配置集中到 GPT 分区表中，不用手动配置 `/etc/fstab` 就能实现自动挂载，Linux 下甚至可以不使用`/etc/fstab`文件。

分区类型 GUID（Partition Type ID）既不是 UUID，也不是 PARTUUID。

| 分区类型 GUID（小写）                | 名称                        | 解释                                                         |
| ------------------------------------ | --------------------------- | ------------------------------------------------------------ |
| EBD0A0A2-B9E5-4433-87C0-68B6B72699C7 | Microsoft basic data        | 微软基本数据分区                                             |
| 0FC63DAF-8483-4772-8E79-3D69D8477DE4 | Linux filesystem            | 数据分区。Linux 曾经使用和 Windows 基本数据分区相同的 GUID。这个新的 GUID 是由 GPT fdisk 和 GNU Parted 开发者根据 Linux 传统的"8300"分区代码发明的。 |
| 4f68bce3-e8cd-4db1-96e7-fbcaf984b709 | Root Partition (x86-64)     | x86-64 根分区。对于 64 位 x86-64 平台，ESP 所在物理磁盘的第一个根分区将被挂载为 `/`。这是 systemd 的发明，可用于无 fstab 时的自动挂载。 |
| 69dad710-2ce4-4e3c-b16c-21a1d49abed3 | Root Partition (32-bit ARM) | ARM32 根分区。对于 32 位 ARM 平台，ESP 所在物理磁盘的第一个根分区将被挂载为 `/`。这是 systemd 的发明，可用于无 fstab 时的自动挂载。 |
| b921b045-1df0-41c3-af44-4c6f280d3fae | Root Partition (64-bit ARM) | ARM64 根分区。对于 64 位 ARM 平台，ESP 所在物理磁盘的第一个根分区将被挂载为 `/`。这是 systemd 的发明，可用于无 fstab 时的自动挂载。 |
| 933ac7e1-2eb4-4f13-b844-0e14e2aef915 | Home Partition              | 家分区。根分区所在物理磁盘的第一个家分区将被挂载为 `/home`。这是 systemd 的发明，可用于无 fstab 时的自动挂载。 |
| 0657fd6d-a4ab-43c4-84e5-0933c84b4f4f | Swap                        | 交换分区。根分区所在物理磁盘的所有交换分区都将被挂载。不是 systemd 的发明，但同样可用于无 fstab 时的自动挂载。 |
| c12a7328-f81f-11d2-ba4b-00a0c93ec93b | EFI System Partition (ESP)  | 根分区所在物理磁盘的第一个 ESP 分区将被挂载为 `/boot` 或 `/efi` (详见后文)。 |

### 挂载参数

```ini
<fs>      <dir>   <type>  <options>              <dump> <pass>
SSD固态硬盘：
/dev/sda1  /       ext4   defaults,noatime,discard   0  1
/dev/sda2  /home   ext4   defaults,noatime,discard   0  2
机械硬盘：
/dev/sda1  /       ext4   defaults,noatime   0  1
/dev/sda2  /home   ext4   defaults,noatime   0  2

# nofail,x-systemd.device-timeout=30 在挂载失败时 (比如设备不存在) 直接跳过。
# nofail 通常会结合 x-systemd.device-timeout 一起使用，表示等待该设备多长时间才认为可用于挂载 (即判断该设备可执行挂载操作)，默认等待 90s
#noauto,x-systemd.automount：noauto 表示开机时不要自动挂载，x-systemd.automount 表示在第一次对该文件系统进行访问时自动挂载。
#内核会将从触发自动挂载到挂载成功期间所有对该设备的访问缓冲下来，当挂载成功后再去访问该设备。
```

参数解释：

* defaults - 使用文件系统的默认挂载参数，例如 ext4 的默认参数为:rw, suid, dev, exec, auto, nouser, async.
* noatime - Linux 在默认情况下使用 `atime` 选项，每次在磁盘上读取（或写入）数据时都会产生一个记录。这是为服务器设计的，在桌面使用中意义不大。使用 `noatime` 选项阻止了读文件、目录时的写操作；使用 `relatime` 选项后，只有文件被修改时才会产生文件访问时间写操作。`relatime` 是比较好的折衷，[Mutt](https://wiki.archlinux.org/index.php/Mutt) 等程序还能工作，但是仍然能够通过减少访问时间更新提升系统性能。

> 注意：  `noatime` 已经包含了 `nodiratime`。不需要同时指定。

* discard - 启用固态硬盘的 trim。
* **dump** dump 工具通过它决定何时作备份。dump 会检查其内容，并用数字来决定是否对这个文件系统进行备份。允许的数字是 0 和 1。0 表示忽略，1 则进行备份。大部分的用户是没有安装 dump 的，对他们而言 `dump` 应设为 0。

* **pass** fsck 读取 `pass` 的数值来决定需要检查的文件系统的检查顺序。允许的数字是 0, 1, 和 2。根目录应当获得最高的优先权 1, 其它所有需要被检查的设备设置为 2. 0 表示设备不会被 fsck 所检查。

手动运行 fsck 工具磁盘参考：<http://www.jinbuguo.com/man/e2fsck.html>

```bash
# 如果有程序在使用磁盘，会导致卸载磁盘失败。
sudo umount /dev/sdb2 && sudo e2fsck -p /dev/sdb2
# 或者使用 fsck.ext4
sudo umount /dev/sdb2 && sudo fsck.ext4 -p /dev/sdb2
# 重新挂载
sudo mount /dev/sdb1 /mnt/sdb1
```

### 检验 TRIM 支持

参考：<https://zhuanlan.zhihu.com/p/34683444>

可以直接使用 lsblk 来检测，DISC-GRAN (discard granularity) 和 DISC-MAX (discard max bytes) 列非 0 表示该 SSD 支持 TRIM 功能。这个方法是最简单的，推荐使用。

```bash
$ lsblk --discard
NAME    DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
sda            0        0B       0B         0
├─sda1         0        0B       0B         0
├─sda2         0        0B       0B         0
└─sda3         0        0B       0B         0
sr0            0        0B       0B         0
nvme0n1      512      512B       2T         1
nvme1n1      512      512B       2T         1
```

可以通过 /sys/block 下的信息来判断 SSD 支持 TRIM, discard_granularity 非 0 表示支持。

```bash
$ cat /sys/block/sda/queue/discard_granularity
0
$ cat /sys/block/sdb/queue/discard_granularity
0
$ cat /sys/block/nvme0n1/queue/discard_granularity
512
```

网上大部分文章介绍通过 hdparm 来检测（包括 arch linux 的 wiki），不过我在 Intel P4500 SSD 测试没有返回该信息。

```bash
$ hdparm -I /dev/sda | grep TRIM
        *    Data Set Management TRIM supported (limit 1 block)
```

### 通过挂载参数启用 TRIM

参考：<https://wiki.archlinux.org/index.php/Solid_state_drive_(简体中文)>

<http://www.jinbuguo.com/storage/ssd_intro.html>

在`/etc/fstab`里使用 `discard` 这个参数以启用 TRIM。

```ini
/dev/sda1  /       ext4   defaults,noatime,discard   0  1
/dev/sda2  /home   ext4   defaults,noatime,discard   0  2
```

注意：

> * 自 Linux 内核版本 3.7 起，以下文件系统支持 TRIM: [Ext4](https://wiki.archlinux.org/index.php/Ext4), [Btrfs](https://wiki.archlinux.org/index.php/Btrfs), [JFS](https://wiki.archlinux.org/index.php/JFS), VFAT, [XFS](https://wiki.archlinux.org/index.php/XFS).
> * VFAT 只有挂载参数为 `discard` (而不是 fstrim ) 时才支持 TRIM。
> * TRIM 当在 SSD 上使用块设备加密时并非默认启用；更多内容见 [Dm-crypt/TRIM support for SSD](https://wiki.archlinux.org/index.php/Dm-crypt/Specialties#Discard.2FTRIM_support_for_solid_state_drives_.28SSD.29)。
> * 如果你周期性运行 `fstrim` 的话没必要使用 `discard` 参数。
> * 在 ext3 的根分区上使用 `discard` 参数的话会导致它被挂载为只读模式。所以应该使用 ext4 分区格式。

fstrim 使用法参考：<http://www.jinbuguo.com/man/fstrim.html>

**警告：**

> 用户试图以 `discard` 参数挂载分区前需确认你们的 SSD 支持 TRIM，否则会造成数据丢失！

使用 tune2fs 命令也可以实现启用 TRIM 支持。

```sh
sudo tune2fs -o discard /dev/sdb1
```

### 按需挂载

参考：<https://zhangguanzhang.github.io/2019/01/30/fstab/>

<https://blog.csdn.net/richerg85/article/details/17917129>

<http://www.jinbuguo.com/systemd/systemd.mount.html>

`defaults`下有`auto`会被开机挂载，但有时候并不想开机立即挂载，比如：分区较大、加密磁盘的挂载时间较长，网络磁盘受网络影响可能也会很慢。这时候就要按需挂载。

如果 `/home` 分区较大，可以让不依赖 `/home` 分区的服务先启动。把下面的参数添加到 `/etc/fstab` 文件中 `/home` 项目的参数部分即可：

```ini
noauto,x-systemd.automount
```

这样 `/home` 分区只有需要访问时才会被挂载。内核会缓存所有的文件操作，直到 `/home` 分区准备完成。

**注意：** 这样做会使 `/home` 的文件系统类型被识别为 `autofs`，造成 [mlocate](https://wiki.archlinux.org/index.php/Mlocate) 查询时忽略该目录。实际加速效果因配置而异，所以请自己权衡是否需要。

挂载远程文件系统也是同理。如果你仅想在需要的时候才挂载，也可以添加 `noauto,x-systemd.automount` 参数。另外，可以设置 `x-systemd.device-timeout=#` 参数设置超时时间，以防止网络资源不能访问的时候浪费时间。

```sh
//192.168.1.*/orico /mnt/orico auto username=*,password=*,uid=1000,gid=1000,x-systemd.automount,noauto,nofail,x-systemd.device-timeout=2 0 0
```

桌面登录一般都会自动挂载。

如果你的加密文件系统需要密钥，则需要添加 `noauto` 参数到 `/etc/crypttab` 文件中的对应位置。systemd 开机的时候就不会打开这个加密设备，会一直等待到设备被访问时再使用密钥文件挂载，可以节省一定的时间。例如：

```ini
# /etc/crypttab
# <target name> <source device>         <key file>      <options>
sdb3 /dev/disk/by-uuid/f69bfc4c-26da-4afa-a982-1166e5550839 /root/key.sdb3 luks2,noauto
data /dev/md0 /root/key noauto
```

> 注意：首次访问非自动挂载的分区，可能会出错，得等一会儿挂载成功后才能正常访问。

### udev 热插拔

* 通过 fstab 不仅能实现开机自动挂载，还能实现插入可移动磁盘后自动挂载。
* 还有一种更高级的方法通过设置 udev 来实现自动挂载，还可以定义插入磁盘后，运行指定的程序，可以实现更多的功能。

参考：<https://www.ibm.com/developerworks/cn/linux/l-cn-udev/index.html?ca=drs-cn-0304>

<https://www.jianshu.com/p/188828d9777a>

<http://shumeipai.nxez.com/2015/06/23/raspberry-pi-usb-storage-device-automatically-mounts.html>

<https://wiki.archlinux.org/index.php/Udev_(简体中文)>

<http://www.jinbuguo.com/systemd/systemd-mount.html>

<https://manpages.debian.org/stretch/systemd/systemd.mount.5.en.html>

<https://www.cnblogs.com/cslunatic/p/3171837.html>

配置文件：

```sh
cat << "EOF" | sudo tee /etc/udev/rules.d/10-usbstorage.rules
ACTION=="add", KERNEL=="sd*", SUBSYSTEM=="block", ENV{ID_BUS}="usb", ENV{ID_FS_USAGE}="filesystem", RUN+="/bin/mount -a"
EOF
sudo udevadm control --reload
sudo systemctl daemon-reload
sudo systemctl restart systemd-udevd.service

sudo journalctl -u systemd-udevd.service -b --no-pager
```

详解：

```bash
cat << "EOF" | sudo tee /etc/udev/rules.d/10-usbstorage.rules
ACTION=="add", KERNEL=="sd[c-z][0-9]", SUBSYSTEM=="block", ENV{ID_BUS}="usb", ENV{ID_FS_USAGE}="filesystem", RUN+="/usr/bin/systemd-mount --no-block -o uid=1000,gid=1000 -A $devnode"

# ACTION=="add", KERNEL=="sd[c-z][0-9]", SUBSYSTEM=="block", ENV{ID_BUS}="usb", ENV{ID_FS_USAGE}="filesystem", RUN+="/bin/sleep 10", RUN+="/usr/bin/sudo -iu pi /usr/bin/python3 /home/pi/sync/py/Photo_Transfer/test.py"
# RUN+="/usr/bin/sudo -iu pi /usr/bin/python3 /home/pi/sync/py/Photo_Transfer/transfer2raspi.py"

ACTION=="add", KERNEL=="mmcblk0p1", SUBSYSTEM=="block", ENV{ID_FS_USAGE}="filesystem", RUN+="/bin/mkdir -p /media/mmc", RUN+="/usr/bin/systemd-mount --no-block $devnode /media/mmc"

ACTION=="remove", KERNEL=="mmcblk0p1", SUBSYSTEM=="block", ENV{ID_FS_USAGE}="filesystem", RUN+="/usr/bin/systemd-mount -u $devnode, RUN+="/bin/rmdir /media/mmc"

EOF

sudo udevadm control --reload
sudo systemctl daemon-reload
sudo systemctl restart systemd-udevd.service
# udevadm test /dev/sdc
# sudo udevadm trigger
systemctl status systemd-udevd.service

# 查看设备信息
udevadm info --name=/dev/sdb1
# 挂载的目录在 /run/media/system
# --timeout-idle-sec=1 默认空闲1秒后自动卸载。
# -A 设置 automount 单元的空闲超时时长。 也就是，如果自动挂载点空闲(无访问)超过了指定的时长，那么它将被自动卸载。 systemd.time(7) 手册详细的描述了时长的表示语法。 此选项对仅创建了临时 mount 单元的挂载点没有意义。注意，如果明确或者隐含(仅设置了一个参数)的设置了 --discover 选项， 并且检测到的块设备是U盘之类的可移动块设备，那么此选项的默认值是"1s"(一秒)， 否则，默认值是 "infinity"(永不超时)。
# Debian 9的systemd暂时还不支持 -u 参数。Debian 10已经支持。
```

### 磁盘加密

<https://wiki.tankywoo.com/other/raspberry.html>

<http://xmodulo.com/how-to-create-encrypted-disk-partition-on-linux.html>

<https://www.cyberciti.biz/hardware/howto-linux-hard-disk-encryption-with-luks-cryptsetup-command/>

<https://openwrt.org/docs/guide-user/storage/disk.encryption>

<https://www.tuicool.com/articles/3i2iuar>

挂载加密分区：

```bash
lsblk -f
dev_name="sdb3"
sudo cryptsetup open /dev/$dev_name $dev_name
lsblk -f
# 查看映射设备的状态
sudo cryptsetup luksDump /dev/$dev_name
# 删除编号1密钥槽，至少要保留一个密钥槽。
sudo cryptsetup luksKillSlot /dev/$dev_name 1
# 自动挂载
# 生成一个 64k 的、随机的 key file，设置为 root 用户只读。
sudo dd if=/dev/urandom of=/root/key.$dev_name bs=1024 count=64
sudo chmod 400 /root/key.$dev_name
# ---------------------------------------------------------------------
# Add the key file to LUKS configuration，提示确认密码。
sudo cryptsetup luksAddKey /dev/$dev_name /root/key.$dev_name
# ---------------------------------------------------------------------
# Verify that the key file has been successfully added，可以看到Keyslots下面多了一个密钥。
sudo cryptsetup luksDump /dev/$dev_name
# As you can see above, the key slot 1 has been occupied with the key file.
# Next, obtain the UUID of the encrypted block device.
luks_uuid=`sudo cryptsetup luksUUID /dev/$dev_name`
echo $luks_uuid
# Now, edit /etc/crypttab to add the following entry.
# <target name> <source device>  <key file> <options>
cat << EOF | sudo tee -a /etc/crypttab
sdb3 /dev/disk/by-uuid/$luks_uuid /root/key.$dev_name luks2,noauto
EOF
cat /etc/crypttab
# edit /etc/fstab to add mount point information.
cat << EOF | sudo tee -a /etc/fstab
/dev/mapper/$dev_name /mnt/$dev_name ext4 defaults,noatime,nofail,x-systemd.device-timeout=1  0  2
EOF
cat /etc/fstab
sudo umount /mnt/$dev_name
sudo mount -a
df -hT
```

创建加密分区：

```bash
# 安装 cryptsetup 工具。
sudo apt install cryptsetup
# 查看当前磁盘情况
lsblk -f
# ---------------------------------------------------------------------
# 使用cryptsetup组件初始化待加密分区(注意这个会擦除重写分区, 如有资料需注意备份)
# 输入大写的 YES 确认, 然后输入两遍密码。
dev_name="sdb3"
# 从 Debian 10 开始 Cryptsetup 默认在磁盘上使用 LUKS2 格式。
sudo cryptsetup --verbose --verify-passphrase --type luks2 luksFormat /dev/$dev_name
# ---------------------------------------------------------------------
# 打开加密分区, 映射到系统/var/mapper/下作为一个新的设备，需输入密码。
# name是映射到/dev/mapper/下的设备名, 可以任意写
# luksOpen 是旧的方法
sudo cryptsetup open /dev/$dev_name $dev_name
# 这时, lsblk -f 查看会看到多了一个新的磁盘.
# 第一次需要格式化这个磁盘, 不需要再分区, 直接格式化/新建文件系统整个磁盘即可:
sudo mke2fs -t ext4 /dev/mapper/$dev_name
# 以后就不需要再建文件系统了, 直接mount挂载即可。
# 默认挂载的用户是root。
sudo mkdir -p /mnt/$dev_name
sudo mount /dev/mapper/sdb3 /mnt/$dev_name
sudo umount /mnt/$dev_name

# 其它命令
# 查看映射设备的状态
sudo cryptsetup status /dev/mapper/$dev_name
# You can check LUKS configuration of the partition by running the following command, which will dump LUKS header information.
sudo cryptsetup luksDump /dev/$dev_name

# 自动挂载
# 生成一个 64k 的、随机的 key file，设置为 root 用户只读。
sudo dd if=/dev/urandom of=/root/key.$dev_name bs=1024 count=64
sudo chmod 400 /root/key.$dev_name
# ---------------------------------------------------------------------
# Add the key file to LUKS configuration，提示确认密码。
sudo cryptsetup luksAddKey /dev/$dev_name /root/key.$dev_name
# ---------------------------------------------------------------------
# Verify that the key file has been successfully added，可以看到Keyslots下面多了一个密钥。
sudo cryptsetup luksDump /dev/$dev_name
# As you can see above, the key slot 1 has been occupied with the key file.
# Next, obtain the UUID of the encrypted block device.
luks_uuid=`sudo cryptsetup luksUUID /dev/$dev_name`
echo $luks_uuid
# Now, edit /etc/crypttab to add the following entry.
# <target name> <source device>  <key file> <options>
cat << EOF | sudo tee -a /etc/crypttab
sdb3 /dev/disk/by-uuid/$luks_uuid /root/key.$dev_name luks2
EOF
cat /etc/crypttab
sudo mkdir -p /mnt/$dev_name
# edit /etc/fstab to add mount point information.
cat << EOF | sudo tee -a /etc/fstab
/dev/mapper/$dev_name /mnt/$dev_name ext4 defaults,noatime,nofail,x-systemd.device-timeout=1  0  2
EOF
cat /etc/fstab
sudo umount /mnt/$dev_name
sudo mount -a

# 自动挂载的目录所有者是 root，普通用户无法直接创建目录、文件。
# 可以创建一个目录，然后更改用户组。
cd /mnt/$dev_name
sudo mkdir -p test
sudo chown 1000:1000 test
```

用 cryptsetup 创建 LUKS 的虚拟加密盘（逻辑卷）

cryptsetup 也可以支持虚拟加密盘（逻辑加密盘）——类似于 TrueCrypt 那样。

何为“虚拟加密盘”？所谓的“虚拟加密盘”，就是说这个盘并【不是】对应物理分区，而是对应一个虚拟分区（逻辑卷）。这个虚拟分区，说白了就是一个大文件。虚拟分区有多大，这个文件就有多大。

“虚拟加密盘”的一个主要好处在于——可以拷贝复制。比如你可以在不同的机器之间复制这个虚假分区对应的大文件。甚至可以把这个大文件上传到云端（网盘）进行备份——这么干的好处参见《文件备份技巧：组合“虚拟加密盘”和“网盘” 》。

```bash
# 创建一个文件作为容器
# 下面用 dd 命令创建100MB的空文件，该文件位于 ~/.local/luks 路径。当然，你也可以指定其它的文件大小或其它的文件路径。
luks_name="luks"
luks_path="$HOME/.local/luks"
mkdir -p $luks_path
sudo dd if=/dev/zero of=$luks_path/$luks_name.vol bs=1M count=100
# ---------------------------------------------------------------------
# 用 LUKS 方式加密（格式化）该文件容器
# 使用前面章节提及的参数，对上述文件容器进行加密。得到一个虚拟的加密盘。
# 输入大写的 YES 确认, 然后输入两遍密码。
sudo cryptsetup -v luksFormat $luks_path/$luks_name.vol
# ---------------------------------------------------------------------
# 打开加密之后的文件容器
# 使用如下命令打开上述的文件容器，使用的映射名是 $luks_name 。
sudo cryptsetup open $luks_path/$luks_name.vol $luks_name
# 打开之后，该虚拟盘会被映射到 /dev/mapper/$luks_name
# 你可以用如下命令看到：
ls /dev/mapper/
# 创建文件系统
# 由于加密盘已经打开并映射到 /dev/mapper/$luks_name 你可以在 /dev/mapper/$luks_name 之上创建文件系统。命令如下（文件系统类型以 ext4 为例）
sudo mkfs.ext4 /dev/mapper/$luks_name
# 挂载文件系统
# 创建完文件系统之后，你还需要挂载该文件系统，才能使用它。挂载的步骤如下。
# 首先，你要先创建一个目录，作为【挂载点】。俺把“挂载点”的目录设定为 /mnt/xxx（当然，你可以用其它目录作为挂载点）。
sudo mkdir -p /mnt/$luks_name
# 创建好“挂载点”对应的目录，下面就可以进行文件系统的挂载。
sudo mount /dev/mapper/$luks_name /mnt/$luks_name
# 挂载好文件系统，用如下命令查看，就可以看到你刚才挂载的文件系统。
df -hT
# 接下来，你就可以通过 /mnt/$luks_name 目录去访问该文件系统。当你往 /mnt/$luks_name 下面创建下级目录或下级文件，这些东东将被存储到该虚拟加密盘上。

# 退出。当你使用完，要记得退出。包括下面两步：
# 卸载文件系统
sudo umount /mnt/$luks_name
# 关闭加密盘
sudo cryptsetup close $luks_name
```

当你使用 luksFormat 进行格式化的时候，下面是几个常用参数以及推荐的参数值：

|  参数名称   |   含义   |     推荐值      | 备注                                                         |
| :---------: | :------: | :-------------: | :----------------------------------------------------------- |
|  --cipher   | 加密方式 | aes-xts-plain64 | 默认为：aes-xts-plain64。AES 加密算法搭配 XTS 模式           |
| --key-size  | 密钥长度 |       512       | 默认为：512。因为 XTS 模式需要两对密钥，每个的长度是 256      |
|   --hash    | 散列算法 |     sha512      |                                                              |
| --iter-time | 迭代时间 |  最好大于 10000  | 默认为：2000。单位是毫秒。该值越大，暴力破解越难。但是打开加密盘时也要等待更久 |

常用的命令：

```bash
dev_name="sdb3"
# 查看header信息
sudo cryptsetup luksDump /dev/$dev_name
# 卸载加密盘
sudo umount /mnt/$dev_name
# 关闭加密盘映射
sudo cryptsetup close $dev_name
# 向 LUKS 设备添加密钥
sudo cryptsetup luksAddKey /dev/$dev_name
# 移除 LUKS 设备中指定的密钥或密钥文件
sudo cryptsetup luksRemoveKey /dev/$dev_name
# 更改 LUKS 设备中指定的密钥或密钥文件
sudo cryptsetup luksChangeKey /dev/$dev_name
```

### 创建分区

MBR 模式最多支持 4 个主分区，扩展分区从 5 开始。GPT 主分区个数不受限制

Linux 命令行下主要有三个分区工具：fdisk、gdisk、parted，三种分区工具的比较：

* gdisk 仅能处理 GPT 分区格式。
* parted（高级分区工具），parted 命令是由 GNU 组织开发的一款功能强大的磁盘分区和分区大小调整工具，与 fdisk 不同，它支持调整分区的大小。作为一种设计用于 Linux 的工具，它没有构建成处理与 fdisk 关联的多种分区类型，但是，它可以处理最常见的分区格式，包括：ext2、ext3、fat16、fat32、NTFS、ReiserFS、JFS、XFS、UFS、HFS 以及 Linux 交换分区。

* fdisk 只能用于 MBR 分区，MBR 模式不支持 2T 以上的分区格式。gdisk、parted 可以用于 GPT 分区。
* fdisk 大多数运维工作人员已经习惯这个交互模式。
* parted 命令在创建删除分区使用命令比较方便，但是功能不是太完善，没有备份还原命令。
* gdisk 在分区上命令和 fdisk 风格一样，使用方便，学习难度低且功能强大，**推荐使用**。

图形界面使用 Gparted，大部分的 LInux LiveCD 都会有这个工具。

>对 4k sector 硬盘分区，要实现扇区对齐，可以`parted` 和 `gdisk` 两个分区工具。
>
>gdisk 工具默认使用 2048 扇区（1MB）对齐。所以不用担心 4k 对齐了。
>
>parted 和 gdisk 两个分区工具，创建分区后，分区之间都没有间隙。
>
>Boot  disks  for  EFI-based  systems  require an EFI System Partition (gdisk internal code 0xEF00) formatted as FAT-32. I recommended making this partition 550 MiB. (Smaller ESPs are common, but some EFIs have flaky FAT drivers that necessitate a larger partition for reliable operation.)  Boot-related  files  are  stored  here. (Note that GNU Parted identifies such partitions as having the "boot flag" set.)
>
>Some  OSes'  GPT  utilities  create some blank space (typically 128 MiB) after each partition. The intent is to enable future disk utilities to use this space. Such free space is not required of GPT disks, but creating it may help in future disk maintenance. You can use GPT fdisk's relative partition positioning option  (speci‐fying the starting sector as '+128M', for instance) to simplify creating such gaps.

参考：<https://lvii.github.io/system/2013-10-26-parted-gpt-4k-sector-align-and-uefi/>

<https://blog.csdn.net/Icy_Ybk/article/details/88619890>

假设一块全新硬盘`sdb`共 20G，没有任何的分区信息，下面使用 gdisk 创建分区。

|           挂载点            |               ESP 分区                |                  /                   |                /home                 |
| :-------------------------: | :----------------------------------: | :----------------------------------: | :----------------------------------: |
|          分区大小           |                 300M                 |                 10G                  |            剩余的全部容量            |
|          分区类型           |                 ESP                  |        Linux x86-64 root (/)         |             Linux /home              |
| Partition GUID code（小写） | c12a7328-f81f-11d2-ba4b-00a0c93ec93b | 4f68bce3-e8cd-4db1-96e7-fbcaf984b709 | 933ac7e1-2eb4-4f13-b844-0e14e2aef915 |
|          Hex code           |                 ef00                 |                 8304                 |                 8302                 |

gdisk 默认是 8300 Linux filesystem，使用 DiskGenius 默认是 0700 Microsoft basic data。除了 ESP 其它的其实没有多大影响。借助 `systemd-gpt-auto-generator` 工具，Linux 可以将文件系统的配置集中到 GPT 分区表中，不用手动配置 `/etc/fstab` 就能实现自动挂载。

其它常用的分区类型：

>0700 Microsoft basic data
>
>8300 Linux filesystem
>
>8200 Linux swap

参考：<http://www.jinbuguo.com/systemd/systemd-gpt-auto-generator.html>

命令：

```sh
# 查看硬盘信息
$ lsblk
# 进入 gdisk 交互界面
$ sudo gdisk /dev/sdb
GPT fdisk (gdisk) version 1.0.3

Partition table scan:
  MBR: not present
  BSD: not present
  APM: not present
  GPT: not present

Creating new GPT entries.
# 查看帮助
$ Command (? for help): ?
b       back up GPT data to a file
c       change a partition's name
d       delete a partition
i       show detailed information on a partition
l       list known partition types
n       add a new partition
o       create a new empty GUID partition table (GPT)
p       print the partition table
q       quit without saving changes
r       recovery and transformation options (experts only)
s       sort partitions
t       change a partition's type code
v       verify disk
w       write table to disk and exit
x       extra functionality (experts only)
?       print this menu
# 创建一个新的 空 GUID 分区表（GPT）
Command (? for help): o
This option deletes all partitions and creates a new protective MBR.
Proceed? (Y/N): y
# 显示分区信息，暂时还啥都没有
$ Command (? for help): p
Disk /dev/sdb: 41943040 sectors, 20.0 GiB
Model: VMware Virtual S
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): FD2F28F7-7840-4F7A-A4ED-483B21B7BD9D
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 41943006
Partitions will be aligned on 2048-sector boundaries
Total free space is 41942973 sectors (20.0 GiB)

Number  Start (sector)    End (sector)  Size       Code  Name
# 没有输入的都是使用默认值。
# 创建新的分区 1，ESP 分区
$ Command (? for help): n
$ Partition number (1-128, default 1):
$ First sector (34-41943006, default = 2048) or {+-}size{KMGTP}:
$ Last sector (2048-41943006, default = 41943006) or {+-}size{KMGTP}: +10G
Current type is 'Linux filesystem'
$ Hex code or GUID (L to show codes, Enter = 8300):L
0700 Microsoft basic data  0c01 Microsoft reserved    2700 Windows RE
3000 ONIE boot             3001 ONIE config           3900 Plan 9
4100 PowerPC PReP boot     4200 Windows LDM data      4201 Windows LDM metadata
4202 Windows Storage Spac  7501 IBM GPFS              7f00 ChromeOS kernel
7f01 ChromeOS root         7f02 ChromeOS reserved     8200 Linux swap
8300 Linux filesystem      8301 Linux reserved        8302 Linux /home
8303 Linux x86 root (/)    8304 Linux x86-64 root (/  8305 Linux ARM64 root (/)
8306 Linux /srv            8307 Linux ARM32 root (/)  8400 Intel Rapid Start
8e00 Linux LVM             a000 Android bootloader    a001 Android bootloader 2
a002 Android boot          a003 Android recovery      a004 Android misc
a005 Android metadata      a006 Android system        a007 Android cache
a008 Android data          a009 Android persistent    a00a Android factory
a00b Android fastboot/ter  a00c Android OEM           a500 FreeBSD disklabel
a501 FreeBSD boot          a502 FreeBSD swap          a503 FreeBSD UFS
a504 FreeBSD ZFS           a505 FreeBSD Vinum/RAID    a580 Midnight BSD data
a581 Midnight BSD boot     a582 Midnight BSD swap     a583 Midnight BSD UFS
a584 Midnight BSD ZFS      a585 Midnight BSD Vinum    a600 OpenBSD disklabel
a800 Apple UFS             a901 NetBSD swap           a902 NetBSD FFS
a903 NetBSD LFS            a904 NetBSD concatenated   a905 NetBSD encrypted
a906 NetBSD RAID           ab00 Recovery HD           af00 Apple HFS/HFS+
af01 Apple RAID            af02 Apple RAID offline    af03 Apple label
Press the <Enter> key to see more codes:
af04 AppleTV recovery      af05 Apple Core Storage    af06 Apple SoftRAID Statu
af07 Apple SoftRAID Scrat  af08 Apple SoftRAID Volum  af09 Apple SoftRAID Cache
b300 QNX6 Power-Safe       bc00 Acronis Secure Zone   be00 Solaris boot
bf00 Solaris root          bf01 Solaris /usr & Mac Z  bf02 Solaris swap
bf03 Solaris backup        bf04 Solaris /var          bf05 Solaris /home
bf06 Solaris alternate se  bf07 Solaris Reserved 1    bf08 Solaris Reserved 2
bf09 Solaris Reserved 3    bf0a Solaris Reserved 4    bf0b Solaris Reserved 5
c001 HP-UX data            c002 HP-UX service         e100 ONIE boot
e101 ONIE config           ea00 Freedesktop $BOOT     eb00 Haiku BFS
ed00 Sony system partitio  ed01 Lenovo system partit  ef00 EFI System
ef01 MBR partition scheme  ef02 BIOS boot partition   f800 Ceph OSD
f801 Ceph dm-crypt OSD     f802 Ceph journal          f803 Ceph dm-crypt journa
f804 Ceph disk in creatio  f805 Ceph dm-crypt disk i  fb00 VMWare VMFS
fb01 VMWare reserved       fc00 VMWare kcore crash p  fd00 Linux RAID
Hex code or GUID (L to show codes, Enter = 8300): ef00
Changed type of partition to 'EFI System'
# 创建新的分区 2
Command (? for help): n
Partition number (2-128, default 2):
First sector (34-41943006, default = 616448) or {+-}size{KMGTP}:
Last sector (616448-41943006, default = 41943006) or {+-}size{KMGTP}: +10G
Current type is 'Linux filesystem'
Hex code or GUID (L to show codes, Enter = 8300): 8304
Changed type of partition to 'Linux x86-64 root (/)'
# 创建新的分区 3
Command (? for help): n
Partition number (3-128, default 3):
First sector (34-41943006, default = 21587968) or {+-}size{KMGTP}:
Last sector (21587968-41943006, default = 41943006) or {+-}size{KMGTP}:
Current type is 'Linux filesystem'
Hex code or GUID (L to show codes, Enter = 8300): 8302
Changed type of partition to 'Linux /home'
# 查看 sdb1 分区信息
Command (? for help): i
Partition number (1-3): 1
Partition GUID code: C12A7328-F81F-11D2-BA4B-00A0C93EC93B (EFI System)
Partition unique GUID: DB4B7F20-84F6-469F-B08C-B0AD19DE3E45
First sector: 2048 (at 1024.0 KiB)
Last sector: 616447 (at 301.0 MiB)
Partition size: 614400 sectors (300.0 MiB)
Attribute flags: 0000000000000000
Partition name: 'EFI System'
# 查看 sdb2 分区信息
Command (? for help): i
Partition number (1-3): 2
Partition GUID code: 4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709 (Linux x86-64 root (/))
Partition unique GUID: FCF2F6C0-15C6-4588-82F2-5B4067322009
First sector: 616448 (at 301.0 MiB)
Last sector: 21587967 (at 10.3 GiB)
Partition size: 20971520 sectors (10.0 GiB)
Attribute flags: 0000000000000000
Partition name: 'Linux x86-64 root (/)'
# 查看 sdb3 分区信息
Command (? for help): i
Partition number (1-3): 3
Partition GUID code: 933AC7E1-2EB4-4F13-B844-0E14E2AEF915 (Linux /home)
Partition unique GUID: 91459334-E0B1-4AFF-8607-C70ABCDFC9D3
First sector: 21587968 (at 10.3 GiB)
Last sector: 41943006 (at 20.0 GiB)
Partition size: 20355039 sectors (9.7 GiB)
Attribute flags: 0000000000000000
Partition name: 'Linux /home'
# 查看硬盘信息
Command (? for help): p
Disk /dev/sdb: 41943040 sectors, 20.0 GiB
Model: VMware Virtual S
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): FD2F28F7-7840-4F7A-A4ED-483B21B7BD9D
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 41943006
Partitions will be aligned on 2048-sector boundaries
Total free space is 2014 sectors (1007.0 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048          616447   300.0 MiB   EF00  EFI System
   2          616448        21587967   10.0 GiB    8304  Linux x86-64 root (/)
   3        21587968        41943006   9.7 GiB     8302  Linux /home
# 保存分区表更改并退出。
Command (? for help): w

Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
PARTITIONS!!

Do you want to proceed? (Y/N): y
OK; writing new GUID partition table (GPT) to /dev/sdb.
The operation has completed successfully.
# 查看硬盘信息
$ sudo fdisk -l
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk model: VMware Virtual S
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: FD2F28F7-7840-4F7A-A4ED-483B21B7BD9D

Device        Start      End  Sectors  Size Type
/dev/sdb1      2048   616447   614400  300M EFI System
/dev/sdb2    616448 21587967 20971520   10G Linux root (x86-64)
/dev/sdb3  21587968 41943006 20355039  9.7G Linux home
# 可以看出 2 个分区已经创建好了，但是还没有创建文件系统，下面使用 mkfs 创建文件系统。
# 指定创建 fat32，否则他会自动创建为 fat16。
$ sudo mkfs.fat -F 32 /dev/sdb1
$ sudo mkfs.ext4 /dev/sdb2
$ sudo mkfs.ext4 /dev/sdb3
$ sudo parted -l
Model: ATA VMware Virtual S (scsi)
Disk /dev/sdb: 21.5GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name                   Flags
 1      1049kB  316MB   315MB   fat32        EFI System             boot, esp
 2      316MB   11.1GB  10.7GB  ext4         Linux x86-64 root (/)
 3      11.1GB  21.5GB  10.4GB  ext4         Linux /home
# 创建完成，设置开机自动挂载
# 备份且配置文件
if [ ! -f /etc/fstab.bak ]; then sudo cp /etc/fstab /etc/fstab.bak; fi
# 创建挂载点
sudo mkdir -p /mnt/sdb1 /mnt/sdb2 /mnt/sdb3
cat << "EOF" | sudo tee -a /etc/fstab
/dev/sdb1  /mnt/sdb1  auto  defaults,noatime,nofail,x-systemd.device-timeout=1  0  2
/dev/sdb2  /mnt/sdb2  auto  defaults,noatime,nofail,x-systemd.device-timeout=1  0  2
/dev/sdb3  /mnt/sdb3  auto  defaults,noatime,nofail,x-systemd.device-timeout=1  0  2
EOF
clear
cat /etc/fstab
sudo mount -a
# 查看磁盘情况
$ lsblk -f /dev/sdb
NAME   FSTYPE LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINT
sdb
├─sdb1 vfat         2DFE-7EA7                             299.8M     0% /mnt/sdb1
├─sdb2 ext4         6e785fc3-ab28-4582-a4ca-d87f3666f554    9.2G     0% /mnt/sdb2
└─sdb3 ext4         9435a117-e60d-40df-a9f6-3d7c031444fe      9G     0% /mnt/sdb3
```

### SMART 监测

参考：<https://blog.shadypixel.com/monitoring-hard-drive-health-on-linux-with-smartmontools/>

<https://help.ubuntu.com/community/Smartmontools>

<https://www.centos.org/forums/viewtopic.php?t=62007>

<https://wiki.archlinux.org/index.php/S.M.A.R.T.>

S.M.A.R.T（Self-Monitoring Analysis and Reporting Technology），是硬盘的自我健康监测功能，只要是 1993 年之后的硬盘，基本上都会支持。

```sh
# 默认它 recommends 了 mailx 等一堆软件。
# 使用 --no-install-recommends 命令，不安装推荐的软件。
sudo apt-get install --no-install-recommends smartmontools
# -------------------------------------------------
# 显示硬盘的详情，包括自检信息。
sudo smartctl -a /dev/sdb
# 显示硬盘的简明特征信息，查看是否支持 smart 特性。
sudo smartctl -i /dev/sdb
# 开启 smart 功能。大部分都会默认开启的。
sudo smartctl --smart=on /dev/sdb
# 测试硬盘健康
sudo smartctl -t short /dev/sdb
sudo smartctl -t long /dev/sdb
# 查看检查结果，result 显示 passed 就表示没有问题。
sudo smartctl -H /dev/sdb
# 查看最近的检查结果
sudo smartctl -l selftest /dev/sdb
# smartd 主配置文件
cat /etc/smartd.conf
# man 手册
man smartd.conf
# 重启服务
sudo systemctl restart smartd
# 查看日志
journalctl -u smartd --no-pager
```

配置

```sh
# -------------------------------------------------
to_address=$(readini ~/.ssh/host.cfg mail to_address)
echo $to_address
if [ ! -f /etc/smartd.conf.bak ]; then sudo cp /etc/smartd.conf /etc/smartd.conf.bak; fi
cat << EOF | sudo tee /etc/smartd.conf
# 测试模式
#DEVICESCAN -a -m $to_address -M test
# 安静模式
#DEVICESCAN -H -m $to_address
# 详细模式
DEVICESCAN -a -o on -S on -n standby,q -s (S/../.././02|L/../../6/03) -I 190 -I 194 -W 4,45,55 -m $to_address
EOF
# DEVICESCAN -a monitor for all possible SMART errors on all disks.
# -a equivalent to -H -f -t -l error -l selftest -C 197 -U 198
# -o on enable automatic offline data collection.
# -S on enable automatic attribute autosave.
# -n standby,q do not check if disk is in standby, and suppress log message to that effect so as not to cause a write to disk
# -s (S/../.././02|L/../../6/03) start a short self-test every day between 2-3am, and an extended self test weekly on Saturdays between 3-4am.
# -W 4,35,40 log changes of 4 degrees or more, log when temp reaches 35 degrees, and log/email a warning when temp reaches 40
```

测试是否能正常发送邮件

```sh
# 将配置文件修改为测试模式，然后重启服务
sudo systemctl restart smartd
```

### 硬盘休眠

参考：<http://www.mkitby.com/2016/05/15/raspberry-pi-nas-manage-hdd-power/>

<http://hd-idle.sourceforge.net/>

最简单的方法，使用一个支持硬盘休眠的硬盘盒，绿联的硬盘盒就支持。

经测试，hdparm 无效，hd-idle 有效。如果 hd-idle 也不支持，可以试下 sdparm。

>hd-idle is a utility program for spinning-down external disks after a period of idle time.

需要下载源代码，编译为 deb 包。

>树莓派的源里已经有 hd-idle 软件包了可以直接使用 apt 安装了。

```bash
# hd-idle 使用一个特殊的系统文件来检测磁盘活动, 如果没有这个文件，那么就不能使用hd-idle。
cat /proc/diskstats
# 应该会看到如下的输出, 如果提示找不到文件或目录，那就不支持hd-idle。
   1       0 ram0 0 0 0 0 0 0 0 0 0 0 0
   1       1 ram1 0 0 0 0 0 0 0 0 0 0 0
   1       2 ram2 0 0 0 0 0 0 0 0 0 0 0
           ************
   8      17 sdb1 577 389 12608 2310 54 141 1808 330 0 1880 2640
   8      18 sdb2 90 0 6336 1520 0 0 0 0 0 1150 1520
   8      19 sdb3 84 0 6192 1580 0 0 0 0 0 1110 1580

# 安装编译需要的依赖包。
sudo apt-get -y install build-essential fakeroot debhelper
# 获取源代码
wget https://sourceforge.net/projects/hd-idle/files/hd-idle-1.05.tgz
# 解压缩进入目录
tar -xvf hd-idle-1.05.tgz && cd hd-idle
# 编译
dpkg-buildpackage -rfakeroot
# 安装
sudo dpkg -i ../hd-idle_*.deb
# 继续检查硬盘是否支持hd-idle
sudo hd-idle -i 0 -a sdb -i 300 -d
# You should see output like this
#probing sda: reads: 13418, writes: 594344
#probing sdb: reads: 146538, writes: 429152
#按 Ctrl+C 停止 hd-idle

# 立即停止硬盘，可以听下硬盘是否停止转动了。
sudo hd-idle -t sdb -d

# 编辑配置文件
sudo cp /etc/default/hd-idle /etc/default/hd-idle.bak
sudo nano /etc/default/hd-idle
# 修改下面来开启hd-idle
# 启用 hd-idle
START_HD_IDLE=true
# 调整空闲时间为 5 分钟 (60 秒 * 5=300)，设备为sdb
HD_IDLE_OPTS="-i 0 -a sdb -i 300 -l /var/log/hd-idle.log"
# 重启 hd-idle
systemctl status hd-idle.service
sudo systemctl restart hd-idle.service
# 查看日志，日志记录的是硬盘开始转动的开始、结束时间。
cat /var/log/hd-idle.log
>>> date: 2019-08-18, time: 10:33:39, disk: sdb, running: 901, stopped: 2521
```

## 用户、组管理

参考：<https://www.cnblogs.com/jackyyou/p/5498083.html>

文件：

`/etc/group` 文件包含所有组，并且能显示出用户是归属哪个用户组或哪几个用户组。用户组的特性在系统管理中为系统管理员提供了极大的方便，但安全性也是值得关注的，如某个用户下有对系统管理有最重要的内容，最好让用户拥有独立的用户组，或者是把用户下的文件的权限设置为完全私有；另外 root 用户组一般不要轻易把普通用户加入进去。

`/etc/shadow` 用户（user）影子口令文件

`/etc/passwd` 用户（user）的配置文件

`/etc/group`  用户组（group）配置文件

`/etc/gshadow` 用户组（group）的影子文件

命令：

```bash
# 查看当前用户所在的组
groups
# 也可以下面的命令
groups $USER
# 查看当前登录用户名
whoami

# 查看系统所有的组信息
cat /etc/group
# 查看指定用户组下的所有成员
getent group family


```

1）管理用户（user）的工具或命令；

 ```bash
# debian 下，useradd 命令创建用户是不会在/home 下自动创建与用户名同名的用户目录，而且不会自动选择 shell 版本，也没有设置密码，那么这个用户是不能登录的，需要使用 passwd 命令修改密码。会同时创建同名群组
useradd
# 创建用户，并附加到 family 组，不创建同名的组，主组仍是 users 用户组
sudo useradd qiuge -G family -N
groups qiuge
>>> qiuge : users family
# debian 下，adduser 命令创建用户是会在/home 下自动创建与用户名同名的用户目录，系统 shell 版本，会在创建时会提示输入密码，更加友好。会同时创建同名群组。
sudo adduser --ingroup family selina
# 为用户设置密码
sudo passwd
# 将用户 qiuge 从 family 组中移除
sudo passwd -d qiuge family
# 修改用户命令，可以通过 usermod 来修改登录名、用户的家目录等等；
sudo usermod qiuge -a -G family,users
# 删除用户
userdel
# pwck 是校验用户配置文件/etc/passwd 和/etc/shadow 文件内容是否合法或完整；
pwck
# 查看用户的 UID、GID 及所归属的用户组
id
# 更改用户信息工具
chfn
# 用户切换工具
su
# sudo 是通过另一个用户来执行命令（execute a command as another user），su 是用来切换用户，然后通过切换到的用户来完成相应的任务。但 sudo 能后面直接执行命令，比如 sudo 不需要 root 密码就可以执行 root 赋与的执行只有 root 才能执行相应的命令；但得通过 visudo 来编辑/etc/sudoers 来实现；
sudo
# visodo 是安全地编辑 /etc/sudoers 的方法，如果编辑错误，会有提示。
visudo
# 和 sudo 功能差不多
sudoedit
 ```

2）管理用户组（group）的工具或命令

```sh
# 添加用户组
sudo groupadd family
# 删除用户组
groupdel
# 修改用户组信息：将 kevin 组改名为 family
sudo groupmod -n family kevin
# 显示用户所属的用户组
groups
# 通过/etc/group 和/etc/gshadow 的文件内容来同步或创建/etc/gshadow，如果/etc/gshadow 不存在则创建；
grpck grpconv
# 注：通过/etc/group 和/etc/gshadow 文件内容来同步或创建/etc/group，然后删除 gshadow 文件；
grpunconv
# 设置用户组
gpasswd
```

### 批量修改用户密码

参考：<https://blog.csdn.net/xuwuhao/article/details/46618913>

对系统定期修改密码是一个很重要的安全常识，通常，我们修改用户密码都使用 passwd user 这样的命令来修改密码，但是这样会进入交互模式，即使使用脚本也不能很方便的批量修改，除非使用 expect 这样的软件来实现，难道修改一下密码还需要单独安装一个软件包吗？不，我们其实还有其他很多方法可以让我们避开交互的，下面具体写一下具体的实现方式：
第一种：

Debian 不支持 `--stdin` 参数

```sh
echo "123456" | passwd --stdin sftp
```

>优点：方便快捷
>
>缺点：如果你输入的指令能被别人通过 history 或者其他方式捕获，那么这样的方式是很不安全的，更重要的是如果密码同时含有单引号和双引号，那么则无法通过这种方法修改。
>
>说明：
>批量修改 linux 密码 passwd --stdin user 从标准输入中读取密码，所以用户可以在脚本中使用如 echo NewPasswd | passwd --stdin username 这种方式来批量更改密码 但在其它的一些发行版（如 Debian/Suse）所提供的 passwd 并不支持--stdin 这个参数

第二种：
a. 首先将用户名密码一起写入一个临时文件。

```sh
cat chpass.txt
root:123456
zhaohang:123456
```

b. 使用如下命令对用户口令进行修改：

```sh
chpasswd < chpass.txt
```

c. 可以使用 123456 来登录系统，密码修改完毕。

>优点：可以很快速方便的修改多个用户密码
>缺点：明文密码写在文件里仍然显得不够安全，但是避免了第一种修改方式不能有特殊字符串密码的情况。

第三种：

a. 用 `openssl passwd -6` 来生成用户口令，连同用户名一起写入文件。

```sh
# -salt val           Use provided salt
# -stdin              Read passwords from stdin
# -6                  SHA512-based password algorithm
# -5                  SHA256-based password algorithm
# -1                  MD5-based password algorithm
cat chpass.txt
root:$1$ri2hceVU$WIf.firUBn97JKswK9ExO0
zhaohang:$1$i/Gou7.v$Bh2K6sXmxV6/UCxJz8N7b.
```

b. 使用如下命令对用户口令进行修改：

```sh
chpasswd -e < chpass.txt
```

c. 可以使用 123456 来登录系统，密码修改完毕。

> 优点：可以很快速方便的修改多个用户密码。和上面两种相比大大增强了安全性

附加介绍：
openssl passwd -1 命令可以输出 shadow 里面的密码，把这个命令生成的秘串更改为你 shadow 里的密码，那么下次你登录系统就可以用你的生成密码的口令来登录了，使用这个命令，即使口令一样，多次执行生成的密码串也不一样。那个 hash 值对应的密码是完全随机的基于 64 位字符编码的 28 位长，因此要破解它是非常困难的，只要不用那些密码已经公布出来的 hash 值创建账号，即使这些密码文件被公布也还是比较安全的。使用旧的 unix 哈希可以去掉 -1 参数。

```sh
[root@WEB01 ~]# openssl passwd -6
Password: 123456
Verifying - Password: 123456
$1$ri2hceVU$WIf.firUBn97JKswK9ExO0

也可以直接使用如下命令来直接生成：
[root@WEB01 ~]# openssl passwd -6 123456
[root@WEB01 ~]# openssl passwd -6 -salt "yoctor" 123456
```

上面命令中的 salt 自己随便输入些东西。因为设置密码的时候密码密文是 MD5 加密的，在产生哈希值的时候系统回在密文中加如盐从而使密文无法反向破译。passwd 加密的时候系统加的 salt 是 时间。

## 远程访问

### SSH

服务器版的 Linux 一般都会默认安装 SSH Server，桌面版的可能默认没有安装，需要手动安装一下。

输入：`ps -e | grep ssh`，如果没有 `sshd`，说明没有安装 ssh server。

```sh
sudo apt install openssh-server
systemctl status ssh
```

ssh 的配置文件为 `/etc/ssh/sshd_config`。

默认情况下，ssh 就可以正常工作了，需要注意的是：

* 默认禁止 root 账户登录。
* 用户配置应设置为最小权限。`~/.ssh` 目录权限为 700，`~/.ssh/authorized_keys`文件权限为 600。

### SFTP

参考：<https://www.cnblogs.com/luyucheng/p/6094729.html>

<https://blog.csdn.net/yanzhenjie1003/article/details/70184221>

SFTP 是 Secure File Transfer Protocol 的缩写，安全文件传送协议。SFTP 使用加密传输认证信息和传输的数据，所以使用 SFTP 是非常安全的。SFTP 之于 FTP 可以理解为 Https 之于 Http，由于这种传输方式使用了加密/解密技术，所以传输效率比普通的 FTP 要低得多，如果您对网络安全性要求更高时，可以使用 SFTP 代替 FTP。

**需求**：

* 限制一个 Linux 用户，让他只能在指定的目录下进行添加、修改、删除操作，无法切换到上一级目录或其它目录。
* 只能使用 sftp 登录，不能用 ssh 登录。

使用 internal-sftp 带来两个好处：

（1）性能更好，在连接 sftp 的时候，系统不会 fork 出一个新的 sftp 进程；可使用`ps -e | grep sftp`命令查看 sftp 进程。

（2）可以在 ssh 的配置文件 `/etc/ssh/sshd_config` 中，使用 ChrootDirectory，Match，ForceCommand 等指令来限制登录 sftp 用户的行为。这部分另外写文章总结。请参考：[通过 SSH 配置纯 sftp 用户及权限](https://www.maixj.net/ict/ssh-sftp-21993)

注意：权限设置，参考：<https://www.cnblogs.com/buffer/p/3191540.html>

> 要实现 Chroot 功能，**目录权限的设置非常重要，否则无法登录**。目录权限设置上要遵循 2 点：
>
> 1. ChrootDirectory 设置的目录权限及其所有的上级文件夹权限，属主和属组必须是 root；
> 2. ChrootDirectory 设置的目录权限及其所有的上级文件夹权限，只有属主能拥有写权限，也就是说权限最大设置只能是 755。
>
> 如果不能遵循以上 2 点，即使是该目录仅属于某个用户，也无法 sftp 登录。

```sh
# 我们要建立一个专门管理 sftp 用户的用户组，方便我们管理权限。
sudo groupadd sftp
# 在该组下建立新用户，禁止任何形式的登录。
# 不禁止登录也可以，ssh 可以配置禁止 ssh 登录，这样的话仅本地登录，无法远程 ssh 登录。
sudo useradd -s /usr/sbin/nologin -g sftp -d /home/sftp sftp
# sudo usermod -s /usr/sbin/nologin sftp
# sudo usermod -d /home/ftp sftp
# -d, --home-dir HOME_DIR       新账户的主目录
# -s, --shell SHELL             新账户的登录 shell
# -g, --gid GROUP               新账户主组的名称或 ID
# -M, --no-create-home          不创建用户的主目录
#--------------------------------------------
# 设置用户密码
sudo passwd sftp
#--------------------------------------------
# 3.创建用户的根目录，用户就只能在此目录下活动
sudo mkdir -p /home/sftp
# 修改权限为 root 用户拥有
sudo chown root:root /home/sftp
# 修改权限为 root 可读写执行，其它用户可读
sudo chmod 755 /home/sftp
# 创建 sync 目录，用户可以在此目录创建、修改、删除文件、文件夹。
sudo mkdir -p /home/sftp/sync
sudo chown sftp:sftp /home/sftp/sync
# 方便其它用户往里面放文件
sudo chmod 777 /home/sftp/sync
ln -s /home/sftp/sync /mnt/sdb1/orico/sftp-sync
# 5.配置 sshd_config
if [ ! -f /etc/ssh/sshd_config.bak ]; then sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak; fi
sudo sed -i 's|^Subsystem\s*sftp\s*/usr/lib/openssh/sftp-server$|## &|' /etc/ssh/sshd_config
```

修改为下面内容，保存退出

```sh
# 添加在配置文件末尾
cat << "EOF" | sudo tee -a /etc/ssh/sshd_config
# 指定使用 sftp 服务使用系统自带的 internal-sftp
Subsystem sftp internal-sftp
# 匹配用户或组，如果要匹配多个组，多个组之间用逗号分割
Match Group sftp
    # 强制执行内部 internal-sftp，并忽略任何~/.ssh/rc 文件中的命令
    ForceCommand internal-sftp
    # 用 chroot 指定用户的根目录
    # chroot 的含义：https://www.ibm.com/developerworks/cn/linux/l-cn-chroot/
    ChrootDirectory /home/sftp
    # 禁止终端登录
    PermitTTY no
    # 禁止端口转发
    X11Forwarding no
    AllowTcpForwarding no
EOF
# 重启 ssh 服务
sudo systemctl restart ssh.service
# 测试一下
sftp -oPort=22 sftp@192.168.88.40
# sftp 登录 www 用户，进入 ui 目录，即可在/home/www/ui 下，对文件进行添加、修改、删除的操作
```

## 常用命令

### NTP 时间同步

Debian 开始使用 Systemd 内置的一个服务 `systemd-timesyncd.service` 来同步时间。

常用的时间服务器地址参考：<https://dns.icoa.cn/ntp/>

```sh
# ---------------------------------------------------------------------
sudo timedatectl set-timezone "Asia/Shanghai" && echo "时区设置为东 8 区成功！"
# 设置时间同步服务器
# 常用的时间服务器地址参考：https://dns.icoa.cn/ntp/
if [ ! -f /etc/systemd/timesyncd.conf.bak ]; then sudo cp /etc/systemd/timesyncd.conf /etc/systemd/timesyncd.conf.bak; fi
sudo sed -i 's/^#\?NTP=.*$/NTP=cn.pool.ntp.org ntp.aliyun.com time.asia.apple.com time1.cloud.tencent.com/' /etc/systemd/timesyncd.conf
sudo systemctl restart systemd-timesyncd.service
echo "同步系统时间成功！"
# 查看时间设置
timedatectl
```

新版的 Debian 不再使用 ntp.service。

```bash
# 时间不准，设置时间同步服务器
sudo cp /etc/ntp.conf /etc/ntp.conf.bak
sudo sed -i 's/#server ntp\.your-provider\.example/&\nserver ntp.tuna.tsinghua.edu.cn\nserver time.asia.apple.com iburst\nserver asia.pool.ntp.org iburst/' /etc/ntp.conf
# 强制要求NTP对表
sudo systemctl stop ntp.service
sudo ntpd -gq
sudo systemctl start ntp.service
# 查看当前日期时间
date
```

### 计划任务

常用的命令：

```bash
# 列出用户的计划任务
crontab -l
# 编辑用户的计划任务
crontab -e
```

cron 的格式：

```sh
# minute   hour   day   month   week   command
# For details see man 4 crontabs
# Example of job definition:
.---------------------------------- minute (0 - 59) 表示分钟
|  .------------------------------- hour (0 - 23)   表示小时
|  |  .---------------------------- day of month (1 - 31)   表示日期
|  |  |  .------------------------- month (1 - 12) OR jan,feb,mar,apr ... 表示月份
|  |  |  |  .---------------------- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat  表示星期（0 或 7 表示星期天）
|  |  |  |  |  .------------------- username  以哪个用户来执行
|  |  |  |  |  |            .------ command  要执行的命令，可以是系统命令，也可以是自己编写的脚本文件
|  |  |  |  |  |            |
*  *  *  *  * user-name  command to be executed
```

示例：

```sh
# 每天的 6:12 重启
12 6 * * * sleep 70 && sudo reboot
# 每 2 天的 6:12 重启一次
12 6 */2 * * sleep 70 && sudo reboot
```

### 中文 man

不推荐安装。里面的内容比较旧了，维护更新也不及时，最好还是看英文原版。

项目地址：<https://github.com/man-pages-zh/manpages-zh>

```sh
sudo apt install manpages-zh
```
