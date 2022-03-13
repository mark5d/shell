#! /bin/sh
version=$([ ! -n "$1" ] && echo "19.03.15" || echo "$1")

sudo yum remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine

result=$?
if [[ $result == 0 ]]; then 
    echo "docker卸载成功!"
    sudo yum install -y yum-utils
else
    echo "docker卸载失败!"
    exit $result
fi

result=$?
if [[ $result == 0 ]]; then 
    echo "yum-utils安装成功!"
    sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
else
    echo "yum-utils安装失败!"
    exit $result
fi



result=$?
if [[ $result == 0 ]]; then 
    echo "docker程序下载地址设置成功!"
    sudo yum install -y docker-ce-$version docker-ce-cli-$version containerd.io
else
    echo "docker程序下载地址设置失败!"
    exit $result
fi

result=$?
if [[ $result == 0 ]]; then 
    echo "docker程序安装成功!"
    sudo systemctl start docker
else
    echo "docker程序安装失败!"
    exit $result
fi

result=$?
if [[ $result == 0 ]]; then 
    echo "docker程序启动成功!"
    cat > /etc/docker/daemon.json <<EOF 
        { 
            "registry-mirrors": ["https://fpmdgx5m.mirror.aliyuncs.com"],
            "exec-opts": ["native.cgroupdriver=systemd"] 
        }
EOF
else
    echo "docker程序启动失败!"
    exit $result
fi


result=$?
if [[ $result == 0 ]]; then 
    echo "docker配置成功!"
    sudo systemctl daemon-reload
else
    echo "docker配置失败!"
    exit $result
fi

result=$?
if [[ $result == 0 ]]; then 
    echo "docker配置启动成功!"
    sudo systemctl restart docker
else
    echo "docker配置启动失败!"
    exit $result
fi

result=$?
if [[ $result == 0 ]]; then 
    echo "docker重启成功!"
    sudo systemctl enable docker
else
    echo "docker重启失败!"
    exit $result
fi

result=$?
if [[ $result == 0 ]]; then 
    echo "docker安装与配置完成!"
    sudo systemctl enable docker
else
    echo "docker设置自动启动失败!"
    exit $result
fi