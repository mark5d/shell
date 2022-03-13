#! /bin/sh
swapoff -a
num=$(sed -n '/dev\/mapper\/centos-swap/=' /etc/fstab)
sed -i "${num},${num}s/^/#/" /etc/fstab

result=$?
if [[ $result == 0 ]]; then 
    echo "swap已经关闭!"
else
    echo "swap关闭失败!"
    exit $result
fi

free -m

sudo systemctl stop firewalld.service

sudo systemctl disable firewalld.service

result=$?
if [[ $result == 0 ]]; then 
    echo "firewalld已经永久关闭!"
else
    echo "firewalld关闭失败!"
    exit $result
fi

