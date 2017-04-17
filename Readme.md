# lkl
## Linux Kernel Library for speed up

## 对于使用本镜像造成的任何后果，本人概不负责

## 环境变量
- TARGET_HOST  加速目标服务器
- TARGET_PORT  加速目标端口
- BIND_PORT    本地绑定端口 默认为8888

## docker启动命令参考：
```
docker run --rm  \
           --privileged  \
           --link your_container_name:myhost \
           -e TARGET_HOST=myhost \
           -e TARGET_PORT=8388 \
           -p 8888:8888 \
           wuqz/lkl:latest
```
