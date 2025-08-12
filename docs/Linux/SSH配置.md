# SSH 配置

`OpenSSH`包含了许多`ssh`工具

1. `ssh`：远程管理
2. `scp`：远程传输
3. `ssh-keygen`：公/私钥生成
4. `ssh-add/ssh-agent`：私钥缓存
5. `ssh-copy-id`：复制本地公钥到远程服务器

## 配置 SSH 免密登录

1、本地生成公钥和私钥

在 `git-bash` 中输入命令：

```bash
# 新版的ssh默认使用 ed25519 算法，速度更快、密钥更短、更安全。
ssh-keygen -t ed25519 -C "LOVE_2025"
# 将在 %userprofile%\.ssh 目录下生2个文件 id_ed25519、id_ed25519.pub
# 注意：任何时候都不要泄露私钥文件“id_ed25519”
# id_ed25519        SSH密钥
# id_ed25519.pub    SSH公钥

# 使用传统RSA算法生成 SSH key，默认是2048位，足够安全了，也可以指定4096。
ssh-keygen -t rsa -b 4096 -C "**"
```

2、将公钥上传至服务器

```sh
# 使用这个工具更好，自动配置权限。
ssh-copy-id -p 22 username@hostname
```

SSH 配置

```ini
# ~/.ssh/config
Host syno
    Hostname hostname
    User kevin
    Port 20002

Host debian
    Hostname hostname.local
    User kevin
    Port 22
```
