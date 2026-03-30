# Immich 笔记

Immich 是一款可以自己搭建的相册管理系统，支持：

- 手机自动备份照片和视频
- 人脸识别、时间轴、地图浏览
- 网页版 + App 双端访问
- 开源、免费、超酷！

## 安装

参考官方的安装指南：<https://immich.app/docs/install/docker-compose>

```sh
# 升级 immich
docker compose pull && docker compose up -d

# https://x2j3uwo3.mirror.aliyuncs.com
# https://docker.m.daocloud.io
#"https://docker.1panel.live", "https://hub.iyuu.cn"
#"https://dockerpull.com"

cat << "EOF" | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": ["https://docker.fxxk.dedyn.io"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
docker compose up -d
```

网页登录 <http://debian.local:2283>

手机登录：<http://debian.local:2283/api>
