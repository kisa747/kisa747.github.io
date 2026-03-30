## 安装 Docker

参考：<https://docs.docker.com/engine/install/debian/>

<https://mirrors.tuna.tsinghua.edu.cn/help/docker-ce/>

Debian 下安装 Docker：

```sh
sudo systemctl restart systemd-timesyncd.service
#------------------------------------------------
sudo apt-get update
# 安装依赖
sudo apt-get install ca-certificates curl gnupg
# 添加 Docker 官方的 GPG 密钥
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# 设置稳定版仓库
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# 最后安装
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add your user to the docker group.
sudo usermod -aG docker $USER
groups $USER
```

Docker Hub 使用国内源，参考：<https://mirrors.ustc.edu.cn/help/dockerhub.html>

<https://github.com/cmliu/CF-Workers-docker.io>

```sh
# 临时使用国内源
# docker pull docker.mirrors.ustc.edu.cn/library/nextcloud
# docker pull docker.mirrors.ustc.edu.cn/library/mariadb

# 持久使用国内源
# 在配置文件 /etc/docker/daemon.json 中加入：
cat << "EOF" | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": ["https://docker.m.daocloud.io"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
# 检查 Docker Hub 是否生效
docker info
#------------------------------------------------
# Verify that you can run docker commands without sudo.
docker run hello-world

docker version
docker info
# Configure Docker to start on boot
sudo systemctl enable docker
```

## Docker 知识

### Docker 架构

| Docker 镜像 (Images)    | Docker 镜像是用于创建 Docker 容器的模板。                    |
| ---------------------- | ------------------------------------------------------------ |
| Docker 容器 (Container) | 容器是独立运行的一个或一组应用。                             |
| Docker 客户端 (Client)  | Docker 客户端通过命令行或者其他工具使用 Docker API (<https://docs.docker.com/reference/api/docker_remote_api>) 与 Docker 的守护进程通信。 |
| Docker 主机 (Host)      | 一个物理或者虚拟的机器用于执行 Docker 守护进程和容器。       |
| Docker 仓库 (Registry)  | Docker 仓库用来保存镜像，可以理解为代码控制中的代码仓库。Docker Hub([https://hub.docker.com](https://hub.docker.com/)) 提供了庞大的镜像集合供使用。 |
| Docker Machine         | Docker Machine 是一个简化 Docker 安装的命令行工具，通过一个简单的命令行即可在相应的平台上安装 Docker，比如 VirtualBox、Digital Ocean、Microsoft Azure。 |

### 常用命令

参考：<http://www.ruanyifeng.com/blog/2018/02/docker-tutorial.html>

<http://www.ruanyifeng.com/blog/2018/02/docker-wordpress-tutorial.html>

可以在 <https://hub.docker.com/> 搜索并查看各种镜像。

```sh
# 命令行下搜索镜像
docker search ubuntu
# 下载最新的 latest ubuntu
docker pull ubuntu
# 列出本机的所有 image 文件。
docker image ls
# 删除 image 文件
docker image rm ubuntu
# 查看正在运行的容器
docker ps
# 查看所有的容器
docker ps -a
# 删除指定的容器 [names/container id]
docker rm wordpress
# 删除指定的容器，并 Remove the volumes associated with the container
# 如果没有指定位置，外部卷的位置在 /var/lib/docker/volumes
docker rm -v wordpress

# 运行，非后台
docker-compose up
# 启动 Seafile 服务
docker-compose up -d
# 关闭服务
docker-compose stop
# 删除对应的容器
docker-compose rm
```

### image、容器

每个 image，官方都会有说明，有哪些参数，哪些环境变量。

<https://hub.docker.com>

比如常用的 mariadb，有以下环境变量：

```ini
MYSQL_ROOT_PASSWORD:
MYSQL_DATABASE:
MYSQL_USER:
MYSQL_PASSWORD:
MYSQL_ALLOW_EMPTY_PASSWORD: no
MYSQL_RANDOM_ROOT_PASSWORD: no
```

wordpress 有以下的环境变量：

```ini
WORDPRESS_DB_HOST: db
WORDPRESS_DB_USER: exampleuser
WORDPRESS_DB_PASSWORD: examplepass
WORDPRESS_DB_NAME: exampledb
```

### compose

参考：<https://docs.docker.com/compose/compose-file/>

## 安装 NextCloud

参考：<https://github.com/nextcloud/docker>

docker-compose.yml 参考：<https://github.com/nextcloud/docker/blob/master/.examples/docker-compose/insecure/mariadb/apache/docker-compose.yml>

详细的语法：<https://github.com/compose-spec/compose-spec/blob/master/spec.md>

```sh
# 使用 SQLite 数据库，不推荐。
# docker run -d -p 8080:80 -v /home/kisa747/.local/nextcloud/data:/var/www/html/data nextcloud

# 使用 MariaDB 数据库，推荐。
cd ~
cat << EOF | tee ~/docker-compose.yml
version: '3'
services:
  db:
    image: mariadb
    command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
    #restart: "no"
    restart: always
    volumes:
      - $HOME/.local/nextcloud/mariadb:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=123456
      - MYSQL_PASSWORD=123456
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud

  app:
    image: nextcloud
    #restart: "no"
    restart: always
    ports:
      - 8080:80
    volumes:
      - $HOME/.local/nextcloud/data:/var/www/html/data
    environment:
      - MYSQL_HOST=db
      - MYSQL_PASSWORD=123456
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
    depends_on:
      - db

volumes:
  db:
  nextcloud:
EOF
# 首次启动，需要创建容器，并关联。
docker-compose up
# 开机后台启动服务
docker-compose up -d
# If you started Compose with docker-compose up -d, stop your services once you’ve finished with them:
# 关闭服务
docker-compose stop
# 由于设置了 restart: always 参数，重启系统、Docker，对应的容器仍会自动启动。
# 要想不让它自动重启，可以修改 docker-compose.yml，然后重新配置容器：
docker-compose build
# 启动容器
docker-compose start
```

安装成功后，即可网页登录，创建管理员账号等操作。

WEB 地址：<http://localhost:8080/>

## 安装 Seafile

参考官方文档：[https://docs.seafile.com/published/seafile-manual-cn/docker/用Docker部署Seafile.md](https://docs.seafile.com/published/seafile-manual-cn/docker/用Docker部署Seafile.md)

总结：Seafile 存储文件的方式很奇葩，它把所有的文件都给分解成块存储，也就是只有使用 Seafile 才能恢复出真正的文件，所以 Seafile 没啥使用价值。

```sh
# 因为 Seafile v7.x.x 容器是通过 docker-compose 命令运行的，所以您应该先在服务器上安装该命令。
sudo apt-get install docker-compose -y
#
cat << EOF | tee docker-compose.yml
version: '2.0'
services:
  db:
    image: mariadb:10.1
    container_name: seafile-mysql
    environment:
      - MYSQL_ROOT_PASSWORD=db_dev  # Requested, set the root's password of MySQL service.
      - MYSQL_LOG_CONSOLE=true
    volumes:
      - /opt/seafile-mysql/db:/var/lib/mysql  # Requested, specifies the path to MySQL data persistent store.
    networks:
      - seafile-net

  memcached:
    image: memcached:1.5.6
    container_name: seafile-memcached
    entrypoint: memcached -m 256
    networks:
      - seafile-net

  seafile:
    image: seafileltd/seafile-mc:latest
    container_name: seafile
    ports:
      - "80:80"
#     - "443:443"  # If https is enabled, cancel the comment.
    volumes:
      - /opt/seafile-data:/shared   # Requested, specifies the path to Seafile data persistent store.
    environment:
      - DB_HOST=db
      - DB_ROOT_PASSWD=db_dev  # Requested, the value shuold be root's password of MySQL service.
#      - TIME_ZONE=Asia/Shanghai # Optional, default is UTC. Should be uncomment and set to your local time zone.
      - SEAFILE_ADMIN_EMAIL=kisa747 # Specifies Seafile admin user, default is 'me@example.com'.
      - SEAFILE_ADMIN_PASSWORD=123456     # Specifies Seafile admin password, default is 'asecret'.
      - SEAFILE_SERVER_LETSENCRYPT=false   # Whether to use https or not.
      - SEAFILE_SERVER_HOSTNAME=192.168.88.42 # Specifies your host name if https is enabled.
    depends_on:
      - db
      - memcached
    networks:
      - seafile-net

networks:
  seafile-net:
EOF

# 测试
docker-compose up
# 启动 Seafile 服务
docker-compose up -d
# 关闭服务
docker-compose stop

# 升级 Seafile 服务
docker pull seafileltd/seafile-mc:latest
# docker-compose down
docker-compose up -d
```

## 安装 Wordpress

```sh
cat << EOF | tee docker-compose.yml
version: "3"
services:
    db:
        image: mariadb
        container_name: wordpressdb
        environment:
            MYSQL_ROOT_PASSWORD: 123456
            MYSQL_DATABASE: wordpress
        volumes:
            - $HOME/.local/wordpress/mariadb:/var/lib/mysql
    web:
        image: wordpress
        container_name: wordpress
        environment:
            WORDPRESS_DB_HOST: db
            WORDPRESS_DB_PASSWORD: 123456
        ports:
            - 8080:80
        volumes:
            - $HOME/.local/wordpress/html:/var/www/html
        depends_on:
            - db
EOF
docker-compose up
docker-compose rm
sudo rm -rf ~/.local/wordpress
```

### 安装 YAAW

先安装 Apache、Nginx、Lighttpd。

参考：<https://hub.docker.com/_/nginx>

```sh
mkdir -p ~/nginx/www ~/nginx/conf
cd ~/nginx

docker run -p 80:80 --name mynginx --rm nginx
# 看到 Welcome to nginx! 说明已经成功了。
cd www
git clone https://github.com/binux/yaaw.git
# 测试 yaaw
docker run -p 80:80 --name mynginx \
--rm \
-v $HOME/nginx/yaaw:/usr/share/nginx/html \
nginx
# 如果看到 yaaw 界面，就说成功了。
# 下一步，创建开机启动。
# -v $HOME/nginx/conf/nginx.conf:/etc/nginx/nginx.conf
# http://kisa747.gitee.io/#path=http://192.168.88.40:6800/jsonrpc
```
