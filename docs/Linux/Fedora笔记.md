## 配置

配置 sudo 权限。

配置 dnf 源

```sh
sudo cp /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora.repo.bak
sudo cp /etc/yum.repos.d/fedora-updates.repo /etc/yum.repos.d/fedora-updates.repo.bak
sudo cp /etc/yum.repos.d/fedora-modular.repo /etc/yum.repos.d/fedora-modular.repo.bak
sudo cp /etc/yum.repos.d/fedora-updates-modular.repo /etc/yum.repos.d/fedora-updates-modular.repo.bak

sudo sed -i "s/#baseurl/baseurl/g" /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora-updates.repo /etc/yum.repos.d/fedora-modular.repo /etc/yum.repos.d/fedora-updates-modular.repo

sudo sed -i "s/metalink/#metalink/g" /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora-updates.repo /etc/yum.repos.d/fedora-modular.repo /etc/yum.repos.d/fedora-updates-modular.repo

sudo sed -i "s@http://download.fedoraproject.org/pub/fedora/linux@https://mirrors.huaweicloud.com/fedora@g" /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora-updates.repo /etc/yum.repos.d/fedora-modular.repo /etc/yum.repos.d/fedora-updates-modular.repo
```

更多 dnf 用法参考：<https://docs.fedoraproject.org/en-US/quick-docs/dnf/>

```sh
# 更新本地缓存，即可使用 TUNA 的软件源镜像
sudo dnf makecache
# 更新所有软件
sudo dnf update

# 搜索某个软件包
dnf search gnome-tweaks
# 删除无用孤立的软件包
sudo dnf autoremove
# 删除缓存的无用软件包
sudo dnf clean all

# 安装 gnome-tewaks(-tool)
sudo dnf install gnome-tweaks
# 然后就能看到程序里多了一个“优化”
```

gnome3 扩展：<https://extensions.gnome.org/>

安装其它的软件：参考：<https://docs.snapcraft.io/installing-snap-on-fedora/6755>

```sh
sudo dnf install snapd
sudo ln -s /var/lib/snapd/snap /snap

sudo snap refresh
sudo snap install pycharm-community --classic
```

pycharm、typora 都没有 rpm 包，泪奔了。

安装桌面环境：参考：

```sh
# 检查有哪些可用的桌面环境
dnf grouplist -v
# 安装 Cinnamon
sudo dnf install @cinnamon-desktop-environment
# sudo dnf install switchdesk switchdesk-gui
# 重启
```
