# Systemd 服务管理

参考：[Linux 二零](https://itboon.github.io/linux-20/)

## 介绍

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


sudo journalctl -u pkgctl-syncthing.service --since today
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

## systemd.path

测试

```sh
mkdir -p ~/.config/systemd/user
cat << "EOF" | tee ~/.config/systemd/user/monitor_photos.path
[Unit]
Description = monitor /volume1/homes/kevin/备份/sync/Home/Pictures/照片

[Path]
PathChanged = /volume1/homes/kevin/备份/sync/Home/Pictures/照片
Unit = monitor_photos.service

[Install]
WantedBy = multi-user.target
EOF

#-----------------------------------------------------------------
cat << "EOF" | tee ~/.config/systemd/user/monitor_photos.service
[Unit]
Description = monitor_photos.path

[Service]
# 自定义配置，运行等级低一点
Nice=10
ExecStart = /bin/bash /volume1/homes/kevin/pycode/cron/rs.sh > /volume1/homes/kevin/pycode/cron/rs.log
EOF

# 如果不需要开机后就自动启动监控的话，可省略下面这段
# 如果开机就监控，则加上这段，并执行
systemctl --user enable monitor_photos.path

systemctl --user daemon-reload

# 随系统自动启动 systemd 用户实例
# 默认用户服务是用户登录后才能启用，要么开启自动登录，要么设置无需登录就能启动服务
# Systemd 支持通过 --user 参数管理用户级别的后台程序，不过这存在一个问题，如果用户退出登录后，属于该用户的后台服务会被终止。
# 如果希望用户退出后仍然保持服务的运行，可以使用下面的命令启用用户的逗留状态
sudo loginctl enable-linger $USER
# 查看用户日志
journalctl -e --user-unit=monitor_photos.path
```
