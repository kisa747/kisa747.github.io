## 笔记

参考：

 <https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html>

## Samba 配置

参考：<https://www.linuxprobe.com/chapter-12.html>

<https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html>

<https://linuxconfig.org/how-to-configure-samba-server-share-on-debian-9-stretch-linux>

主配置文件为 `/etc/samba/smb.conf` ，树莓派的默认配置如下：

```ini
[global]
   workgroup = WORKGROUP  #工作组名称
   dns proxy = no
   log file = /var/log/samba/log.%m  # 定义日志文件的存放位置与名称，参数%m为来访的主机名
   max log size = 1000  #定义日志文件的最大容量为 1000KB，默认为 5000KB。
   syslog = 0
   panic action = /usr/share/samba/panic-action %d
   server role = standalone server
   passdb backend = tdbsam  #定义用户后台的类型，共有 3 种
   # tdbsam：默认值，一般使用此值。创建数据库文件并使用 pdbedit 命令建立 Samba 服务程序的用户
   # smbpasswd：旧参数，使用的话，samba 部分功能无法使用。使用 smbpasswd 命令为系统用户设置 Samba 服务程序的密码
   # ldapsam：基于 LDAP 服务进行账户验证
   obey pam restrictions = yes
   unix password sync = yes
   passwd program = /usr/bin/passwd %u
   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
   pam password change = yes
   map to guest = bad user
   usershare allow guests = yes
   # https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html#CLIENTMAXPROTOCOL
   # 默认值 SMB2_02，个别无法访问可以设为 NT1（最大兼容性，支持 SMB1、2、3），最高值为 SMB3_11（Windows 10 SMB3 version）
   client min protocol = SMB2_02
[homes]
   comment = Home Directories
   browseable = no
   read only = no
   create mask = 0700
   directory mask = 0700
   valid users = %S
[printers]
   comment = All Printers
   browseable = no
   path = /var/spool/samba
   printable = yes
   guest ok = no
   read only = yes
   create mask = 0700
[print$]
   comment = Printer Drivers
   path = /var/lib/samba/printers
   browseable = yes
   read only = yes
   guest ok = no
[public]
    comment = 共享目录
    path = /home/public
    browseable = yes
    read only = no
    writeable = yes
    # 通过下面 4 个参数精确控制读写权限
    valid users =
    invalid users =
    read list =
    write list =
    create mask = 0666
    directory mask = 0777
    hide dot files = yes
    vfs objects =  recycle
  recycle:repository = .trash/%U
  recycle:keeptree = yes
  recycle:versions = yes
  recycle:touch = yes
  recycle:touch_mtime = no
  recycle:directory_mode = 0777
  recycle:subdir_mode = 0700
  recycle:exclude = *.tmp|*.temp
  recycle:exclude_dir =
  recycle:maxsize = 0
```

## 全局配置

```ini
# This will prevent nmbd to search for NetBIOS names through DNS.
dns proxy = no
# Specifies that nmbd(8) when acting as a WINS server and finding that a NetBIOS name has not been registered, should treat the NetBIOS name word-for-word as a DNS name and do a lookup with the DNS server for that name on behalf of the name-querying client.
# Note that the maximum length for a NetBIOS name is 15 characters, so the DNS name (or DNS alias) can likewise only be 15 characters, maximum.
# nmbd spawns a second copy of itself to do the DNS name lookup requests, as doing a name lookup is a blocking action.
# Default: dns proxy = yes

security = user #安全验证的方式，总共有 4 种
# user：默认值，因此可以无需配置。需验证来访主机提供的口令后才可以访问；提升了安全性
# share：来访主机无需验证口令；比较方便，但安全性很差
# server：使用独立的远程主机验证来访主机提供的口令（集中管理账户）
# domain：使用域控制器进行身份验证

syslog = 0  # 记录日志的等级（0-4），默认为 1。数字越大，记录日志越详细。
# 0 - LOG_ERR
# 1 - LOG_WARNING
# 2 - LOG_NOTICE
# 3 - LOG_INFO
# 4 - LOG_DEBUG

panic action = /usr/share/samba/panic-action %d
# Do something sensible when Samba crashes: mail the admin a backtrace
# %d - the process id of the current server process.

# Server role. Defines in which mode Samba will operate. Possible
# values are "standalone server", "member server", "classic primary
# domain controller", "classic backup domain controller", "active
# directory domain controller".
#
# Most people will want "standalone sever" or "member server".
# Running as "active directory domain controller" will require first
# running "samba-tool domain provision" to wipe databases and create a
# new domain.
server role = standalone server

obey pam restrictions = yes
# When Samba 3.0 is configured to enable PAM support (i.e. --with-pam), this parameter will control whether or not Samba should obey PAM's account and session management directives. The default behavior is to use PAM for clear text authentication only and to ignore any account or session management. Note that Samba always ignores PAM for authentication in the case of encrypt passwords = yes. The reason is that PAM modules cannot support the challenge/response authentication mechanism needed in the presence of SMB password encryption.
# Default: obey pam restrictions = no

# This boolean parameter controls whether Samba attempts to sync the Unix
# password with the SMB password when the encrypted SMB password in the
# passdb is changed.
unix password sync = yes
# This boolean parameter controls whether Samba attempts to synchronize the UNIX password with the SMB password when the encrypted SMB password in the smbpasswd file is changed. If this is set to yes the program specified in the passwd program parameter is called AS ROOT - to allow the new UNIX password to be set without access to the old UNIX password (as the SMB password change code has no access to the old password cleartext, only the new).
# This option has no effect if samba is running as an active directory domain controller, in that case have a look at the password hash gpg key ids option and the samba-tool user syncpasswords command.
# Default: unix password sync = no

# For Unix password sync to work on a Debian GNU/Linux system, the following
# parameters must be set (thanks to Ian Kahan <<kahan@informatik.tu-muenchen.de> for
# sending the correct chat script for the passwd program in Debian Sarge).
passwd program = /usr/bin/passwd %u
passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .

# This boolean controls whether PAM will be used for password changes
# when requested by an SMB client instead of the program listed in
# 'passwd program'. The default is 'no'.
pam password change = yes

# This option controls how unsuccessful authentication attempts are mapped
# to anonymous connections
map to guest = bad user

# Allow users who've been granted usershare privileges to create
# public shares, not just authenticated ones
usershare allow guests = yes
# This parameter controls whether user defined shares are allowed to be accessed by non-authenticated users or not. It is the equivalent of allowing people who can create a share the option of setting guest ok = yes in a share definition. Due to its security sensitive nature, the default is set to off.
# Default: usershare allow guests = no
```

## 添加用户

```sh
# 添加用户 pi，并修改密码，两个命令是一样的。推荐使用 smbpasswd。
sudo smbpasswd -a pi
sudo pdbedit -a pi
# 查看所有 samba 用户
sudo pdbedit -L

# 删除指定 samba 用户
sudo pdbedit -x a


sudo systemctl restart nmbd.service
sudo systemctl restart smbd.service
```

通过 smbpasswd 添加的用户必须是系统中存在的用户。

参考：<https://www.cnblogs.com/jary-wang/archive/2013/05/21/3091343.html>

>​    注意，这里的用户名必须是 linux 中存在的用户，可以使用 `useradd` 命令在系统中添加一个用户，然后再增加一个对应的 samba 用户，也 就是一个用户名使用的是两套密码。一个是系统用户密码，另一个密码存储在/etc/samba/smbpasswd 文件中的 samba 密码，这样可以防止系统用户密钥外泄带来的安全隐患。
>
>​    除了上面的措施外，samba 还提供了一个更安全的方法，用户名映射功能，这样做的好处是防止系统内的真实用户名暴露，在 smb.conf 中增 加 username map = /etc/samba/smbuser设定，再手工建立该文件。
>
>username map 参数详解：
>
>​    比如有一个系统用户名为 zyhyt.org，同时我们也设定其为 samba 的登录名，虽然是两套独立的密码，但依然告诉了用户，我系统内 也存在 zyhyt.org 这个用户。严格的说这也是违背系统安全规则的，不法人士可能会利用该用户名暴力猜解获得系统内帐户权限。
>
>​    samba 提供的用户名 映射功能，只需编辑 smbuser 文>件，格式为：真实的用户名 = 映射出的用户名（随便自定义）；zyhyt.org = nas_guest nas_nobody（可以映射出多个用户名，注意中间的空格）。设定完成后，我们只需将 nas_guest 告诉用户即可，无须担心真实的 zyhyt.org 用户名暴露。

因为添加 samba 账号必须要有系统账号，为提高安全性，加的系统账号不给 shell，也不指定主目录。

以创建用户 `test` 为例：

```sh
sudo groupadd test -g 6000
sudo useradd test -u 6000 -g 6000 -s /usr/sbin/nologin -d /dev/null
```

## 启用软连接

谨慎使用此功能，因为启用后，samba 会把软连接当做普通文件夹处理，删除软连接就是真实地删除了源文件夹。

```sh
[global]
    # 启用可以访问软连接，这个要全局设置
    unix extensions  = no
#    启用可以访问软连接，这 2 个参数可以局部设置
#    wide links = yes
#    follow symlinks = yes
[orico]
    # 启用可以访问软连接，这 2 个参数可以局部设置
    wide links = yes
    follow symlinks = yes
```
