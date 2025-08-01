# OMV

## 安装

[官方文档](https://docs.openmediavault.org/en/latest/installation/on_debian.html)

Debian下安装 OMV，不能有桌面环境

```sh
# Install the openmediavault keyring manually
sudo apt-get install --yes gnupg
wget --quiet --output-document=- https://packages.openmediavault.org/public/archive.key | sudo gpg --dearmor --yes --output "/usr/share/keyrings/openmediavault-archive-keyring.gpg"

# Add the package repositories
cat <<EOF | sudo tee /etc/apt/sources.list.d/openmediavault.list
deb [signed-by=/usr/share/keyrings/openmediavault-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/public sandworm main
deb [signed-by=/usr/share/keyrings/openmediavault-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/packages sandworm main
## Uncomment the following line to add software from the proposed repository.
# deb [signed-by=/usr/share/keyrings/openmediavault-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/public sandworm-proposed main
# deb [signed-by=/usr/share/keyrings/openmediavault-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/packages sandworm-proposed main
## This software is not part of OpenMediaVault, but is offered by third-party
## developers as a service to OpenMediaVault users.
# deb [signed-by=/usr/share/keyrings/openmediavault-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/public sandworm partner
# deb [signed-by=/usr/share/keyrings/openmediavault-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/packages sandworm partner
EOF

# Install the openmediavault package，需要安装188个软件包
export LANG=C.UTF-8
export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none
sudo apt-get update
sudo apt-get --yes --auto-remove --show-upgraded \
    --allow-downgrades --allow-change-held-packages \
    --no-install-recommends \
    --option DPkg::Options::="--force-confdef" \
    --option DPkg::Options::="--force-confold" \
    install openmediavault

# Populate the openmediavault database with several existing system settings, e.g. the network configuration
sudo omv-confdbadm populate
```

登录web后台，账号 admin ，密码 openmediavault，修改密码，将用户添加到_ssh用户组中，修改自动登出时间1天。

```sh
# 修改
sudo omv-firstaid

# 删除 apt缓存
sudo apt-get clean
```

