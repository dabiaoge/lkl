# Linux Kernel Library for speed up

使用LKL开启BBR实现网络加速（Docker版）

大家都知道，BBR是可以与锐速媲美的加速方案，无奈BBR必须在Linux内核4.9以上版本才能支持，而突破这个限制的办法，就是最近非常火爆的LKL（Linux Kernel Library）了！ 91yun出品的一键包已经非常不错了，本人不才，给大家提供一个Docker版本，简单方便！
    
一、前提和限制：
1、Docker必须在3.10内核以上才能完美运行，请使用uname -r命令查看内核的版本，必须大于等于3.10哦！
OpenVZ默认的内核是2.6.32，无法支持Docker，就不能愉快的玩耍了，请大家用KVM、XEN或者实体机来运行这个加速器。

2、必须在VPS控制面板打开TUN/TAP选项，大部分VPS供应商都会默认打开这个选项
怎么判断TUN/TAP有没有开打呢？用root运行命令：
cat /dev/net/tun
如果命令返回信息为：
cat: /dev/net/tun: File descriptor in bad state
恭喜你，你的VPS TUN/TAP已经可以使用
如果命令返回信息为：
cat: /dev/net/tun: No such device
或者其它，说明TUN/TAP设备没有被正确配置


二、安装Docker
用root执行以下命令：

**wget -qO- https://get.docker.com/  |  bash**

三、运行镜像：
1、运行shadowsocks的docker容器：

**docker run -d  -e  PASSWORD=sspass   -p 8388:8388  --name shadowsocks   wuqz/sss:latest**

注意，这是一个标准版python的shadowsocks，不是ssr哦，如果有需求可以自己替换为其他镜像启动。
其中，sspass可以替换为你需要设置的shadowsocks密码。默认加密方式是aes-256-cfb，可以通过METHOD环境变量调整加密方式

2、运行加速器，加速shadowsocks
**docker run -d --privileged  --link  shadowsocks:myhost  -e  TARGET_HOST=myhost -e TARGET_PORT=8388   -p 8888:8888   --name lkl   wuqz/lkl:latest**

注意，上述命令需要用root权限执行，TARGET_HOST就是你需要加速的服务器/容器，TARGET_PORT为需要加速的端口，BIND_PORT变量就是加速器的端口，默认是8888。 命令中的8388是shadowsocks默认的端口。

这样，你就可以访问VPS服务器的外网地址，端口为8888，密码为sspass，加密方式为aes-256-cfb的shadowsocks了！

3、停止命令：
**docker stop shadowsocks lkl**

四、其他
这个镜像的妙处，是可以对任意网络服务器进行加速，如果你的WEB服务器运行在1234端口，那么你可以这样来对这个端口进行加速：
docker run -d --privileged   -e  TARGET_HOST=服务器外网IP -e TARGET_PORT=1234   -p 80:8888     wuqz/lkl:latest 

这样访问服务器的80端口，就是加速后访问WEB服务器了！
同样的道理，也可以进行端口转发！

源码在
https://github.com/dabiaoge/lkl
如有问题，请在github联系我。

使用本镜像造成的任何后果和技术问题，本人概不负责。


