ip tuntap add tap0 mode tap 
ip addr add 10.0.0.1/24 dev tap0  
ip link set tap0 up 

iptables -P FORWARD ACCEPT 
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE 
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport ${BIND_PORT:-8888} -j DNAT --to-destination 10.0.0.2

sed -i "s/TARGET_HOST/$TARGET_HOST/g" /root/lkl/haproxy.cfg
sed -i "s/TARGET_PORT/$TARGET_PORT/g" /root/lkl/haproxy.cfg
sed -i "s/BIND_PORT/${BIND_PORT:-8888}/g" /root/lkl/haproxy.cfg

export LD_PRELOAD=/root/lkl/liblkl-hijack.so
export LKL_HIJACK_NET_QDISC="root|fq"
export LKL_HIJACK_SYSCTL="net.ipv4.tcp_congestion_control=bbr;net.ipv4.tcp_wmem=4096 65536 67108864"
export LKL_HIJACK_NET_IFTYPE=tap
export LKL_HIJACK_NET_IFPARAMS=tap0
export LKL_HIJACK_NET_IP=10.0.0.2
export LKL_HIJACK_NET_NETMASK_LEN=24
export LKL_HIJACK_NET_GATEWAY=10.0.0.1
export LKL_HIJACK_OFFLOAD="0x8883"
export LKL_HIJACK_DEBUG=0

haproxy -f /root/lkl/haproxy.cfg
