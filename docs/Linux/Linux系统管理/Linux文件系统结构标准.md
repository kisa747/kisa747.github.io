## 文件系统层次结构标准 (FHS)(for Linux)

参考：<https://blog.csdn.net/qq_29753285/article/details/69791332>

## usrmerge

参考：<https://www.debian.org/releases/buster/amd64/release-notes/ch-whats-new.zh-cn.html#merged-usr>

<https://www.freedesktop.org/wiki/Software/systemd/TheCaseForTheUsrMerge/>

<https://fedoraproject.org/wiki/Features/UsrMove>

Debian 10 在全新安装的系统上默认启用 /usr 合并。也就是说，在全新安装系统时，`/bin`、`/sbin` 和 `/lib` 目录下的内容将默认安装至对应的 `/usr` 目录下的位置。`/bin`、`/sbin` 和 `/lib` 将变成指向 `/usr/` 下面真实目录的软链接。具体来说如下所示：

```sh
/bin → /usr/bin
/sbin → /usr/sbin
/lib → /usr/lib
```

当升级到 buster 时，系统将保持不变，尽管有需要时可以使用 `usrmerge` 软件包进行转换。[freedesktop.org](https://www.freedesktop.org/) 项目建立的[维基](https://www.freedesktop.org/wiki/Software/systemd/TheCaseForTheUsrMerge/)中说明了这样做的大多数理由。

这次变更应当不会影响只运行由 Debian 提供软件的用户，但安装或构建第三方软件包的用户需要注意。

# 文件系统层次结构标准 - 简介

**开发者** [Linux 基金会](https://en.wikipedia.org/wiki/Linux_Foundation)

**初始版本** 1994 年 2 月 14 日

**最新版本** 3.0 (2015 年 6 月 3 日)

**网站** [官网](http://www.linuxfoundation.org/collaborate/workgroups/lsb/fhs)

文件系统层次结构标准 (FHS) 定义了在类 Unix 系统中的目录结构和目录内容。它由 Linux 基金会维护，最新版为 2015 年六月三日发布的 3.0 版，仅用于 Linux 的各类发行版中。

## 目录结构

在 FHS 中，所有的（包括存储于不同物理/虚拟设备中的）文件和目录都存在于根目录 / 下。其中，部分目录仅当特定系统（如 X Window）安装后才会存在。

下表中大部分目录都以相似的功能存在于所有的 UNIX 系统中。但是，以下的描述仅针对 FHS，且对非 Linux 系统并非权威

- /  主层次结构的根&&整个文件系统的根目录

  - **/bin**  所有用户在单用户模式中必须具备的二进制命令文件，如 cat, ls, cp.

  - **/boot** Boot loader 文件，如 kernels, initrd.

  - **/dev**  必要的 device 文件，如 /dev/null.

  - **/etc**   特定主机 全系统 的配置文件

    一直以来，这个名字本身就有争议。在早期由 Bell labs 所撰写的 UNIX 实现文档中，/etc 被当作附加 (etcetera) 目录，因为历史上这个文件夹用来保存所有不属于其他地方的文件（但 FHS 限制/etc 仅用于保存静态配置文件，不能保存二进制文件）。从早期的文档发布以来，这个文件夹的名字就被人们以不同的方式重新定义。最近的释义包括如”Editable Text Configuration”或“Extended Tool Chest”词源

    - **/etc/opt**  保存在/opt/中的插件包的配置文件
    - **/etc/sgml** 处理 SGML 的程序（如 catalogs）的配置文件
    - **/etc/X11** X Window System, version 11 的配置文件
    - **/etc/xml**  处理 xml 的程序（如 catalogs）的配置文件

  - **/home**  用户的个人目录，包含保存的文件和个人设置等

  - **/lib**  /bin/ 和/sbin/ 中必须的依赖库

  - **/lib** Alternate format essential libraries. Such directories are optional, but if they exist, they have some requirements.

  - **/media** 一些可以热拔插的介质（如 CD-ROMs）的挂载点 (在 FHS-2.3 中出现).

  - **/mnt**  临时挂载的文件系统

  - **/opt**   可选的应用程序包

  - **/proc**  将进程和内核信息以文件形式呈现的虚拟文件系统。在 Linux 中，与 procfs mount(进程文件系统) 对应

  - **/root**  root 用户的个人目录

  - **/run**  运行时变量数据：从本次启动到现在的系统信息。如当前登陆的用户和正在运行的守护进程

  - **/sbin**  必备的系统可执行文件，如 fsck, init, route.

  - **/srv**   本系统提供的特定站点的数据。如 web 服务器提供的数据和脚本，FTP 服务器提供的数据，VCS 的仓库

  - **/sys**   包含连接到本台计算机的设备信息

  - **/tmp**  临时文件 (和/var/tmp 相同). 通常在重启后清空，并且受到严格的大小限制

  - **/usr**      只读用户数据的次要层次，包含大部分（多）用户功能和应用

    - **/usr/bin**       所有用户的非必要的二进制可执行文件 (在单用户模式中不需要)
    - **/usr/include**    Standard include files.
    - **/usr/lib**      /usr/bin/ 和 /usr/sbin/ 中的二进制文件的依赖库
    - **/usr/lib**              Alternate format libraries (optional).
    - **/usr/local**    仅针对当前主机的 本地数据的第三个层次。一般包含其他的子目录，如 bin/, lib/, share/
    - **/usr/sbin**    非必须的系统二进制文件，如多种网络服务的守护进程
    - **/usr/share**    结构独立（共享）的数据
    - **/usr/src**     源代码，如 内核的源代码和它的头文件
    - **/usr/X11R6**  X Window System, Version 11, Release 6 (up to FHS-2.3, optional).

  - **/var**       Variable files:各种在系统运行中，内容会不停改变的文件。如日志文件，spool files，和临时的电子邮件文件

    - **/var/cache** 应用缓存数据。这类文件由于耗时的 I/O 或计算而被生成在本地。应用必须能够重新生成或转储这些文件，以保证这些数据被删除时不会造成数据丢失。（意思就是这些东西删了不会造成不良后果）

    - **/var/lib**  状态信息。程序运行时会改变的持久化数据，如 数据库，packaging system metadata, etc.

    - **/var/lock** Lock files. 追踪当前正在使用的资源的文件。

    - **/var/log** Log files. 各种日志。

    - **/var/mail** Mailbox files. 在某些发行版中，这些文件被放在已经不推荐使用的`/var/spool/mail` 目录中。

    - **/var/opt** 来自保存在`/opt` 中的插件包的可变数据。

    - **/var/run** Run-time variable data. 这个目录包含描述系统的自启动以来的系统信息数据
      在 FHS 3.0 中， `/var/run` 被 `/run` 替代。系统不应该在使用`/var/run` 或者提供`/var/run` 到 `/run` 的符号连接，防止出现兼容性倒退

    - /var/spool

      Spool for tasks waiting to be processed, e.g., print queues and outgoing mail queue.

      - **/var/spool/mail** 不建议使用的用户邮箱位置，见`/var/mail`

    - **/var/tmp** 重启时会被保存的临时数据

## FHS 约定

大多数 Linux 发行版遵循`文件系统层次结构标准(FHS)`，并且为保持 FHS 约定发布了相关政策。GoboLinux 和 NixOS 提供了有意不遵循 FHS 约定的实现
有些基本遵循这个标准的发行版在部分方面有些违背，如

- 现代 Linux 发行版将`/sys` 作为可以被连接到此系统的设备修改和保存的虚拟文件系统 (sysfs，相当于`/proc`)，但是许多 UNIX 和类 UNIX 系统使用`/sys` 作为指向 `kernel source tree` 的符号连接
- 许多现代 UNIX 系统（像 FreeBSD，通过它的端口系统）安装第三方包至`/usr/local` 然而却将本应是操作系统的代码放在`/usr` 中
- 一些 Linux 发行版不再区分`/lib` 与`/usr/lib`,并且将`lib` 作为指向 `/usr/lib` 的软连接
- 一些 Linux 发行版不再区分 `/bin` 与 `/usr/bin` 和`/sbin` 与`/usr/sbin` 。他们将 `/bin` 作为指向 `/usr/bin` 的软连接，将`/sbin` 作为指向`/usr/sbin` 的软连接

现代 Linux 发行版将`/run` 作为 (遵循 FHS3.0 的) 保存不稳定的运行时数据的临时文件系统 (tmpfs)。根据 FHS2.3，这类数据被保存在`/var/run` ，但是由于在启动时这个目录并不总是可用，会导致一些问题。所以，这些程序必须借助欺骗的方式，如使用类似 `/dev/.udev`, `/dev/.mdadm`, `/dev/.systemd` 或 `/dev/.mount` 等并不是用来保存这些数据的设备目录。除其他好处外，这样也会使根目录以只读方式挂载的系统更容易使用。例如，以下是 Debian 在 2013 年的 Wheezy 版本中作出的改变：

- /dev/.*→ /run/*
- /dev/shm → /run/shm
- /dev/shm/*→ /run/*
- /etc/*(writeable files) → /run/*
- /lib/init/rw → /run
- /var/lock → /run/lock
- /var/run → /run
- /tmp → /run/tmp

## 历史

当 FHS 被以 FSSTND (Filesystem Standard 的缩写) 被创建时，其他 UNIX 和类 UNIX 系统已经有了他们自己的标准。比较典型的例子有 自从 Version 7 Unix (in 1979) 发布以来就存在的`the hier(7) description of file system layout`； `the SunOS filesystem(7)` 和它的后继 `the Solaris filesystem(5)`

## 历史版本

| legend | Version | Release Date | Notes                                           |
| ------ | ------- | ------------ | ----------------------------------------------- |
| 旧版本 | 1       | 1994/2/14    | FSSTND                                          |
| 旧版本 | 1.1     | 1994/10/9    | FSSTND                                          |
| 旧版本 | 1.2     | 1995/3/28    | FSSTND                                          |
| 旧版本 | 2       | 1997/10/26   | FHS 2.0 直接继承自 FSSTND 1.2。FSSTND 更名为 FHS |
| 旧版本 | 2.1     | 2000/4/12    | FHS                                             |
| 旧版本 | 2.2     | 2001/5/23    | FHS                                             |
| 仍支持 | 2.3     | 2004/1/29    | FHS                                             |
| 最新版 | 3       | 2015/5/18    | FHS                                             |
