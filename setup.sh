#!/bin/bash
#Check Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }
#check OS version
check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
   # get_your_ip
	IPAddress=`wget http://members.3322.org/dyndns/getip -O - -q ; echo`;
}
install(){
	check_sys
	if [[ ${release} = "centos" ]]; then
yum groupinstall "Development Tools" -y
yum install wget curl tar unzip -y
yum install -y gcc gettext-devel unzip autoconf automake make zlib-devel libtool xmlto asciidoc udns-devel libev-devel
yum install -y pcre pcre-devel perl perl-devel cpio expat-devel openssl-devel mbedtls-devel screen nano
curl --silent --location https://rpm.nodesource.com/setup_6.x | sudo bash -
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
sudo yum -y install nodejs
cd /root
wget -N -P  /root https://github.com/jedisct1/libsodium/releases/download/1.0.13/libsodium-1.0.13.tar.gz
tar xvf libsodium-1.0.13.tar.gz && rm -rf libsodium-1.0.13.tar.gz
pushd libsodium-1.0.13
./configure --prefix=/usr && make
make install
popd
wget https://github.com/ARMmbed/mbedtls/archive/mbedtls-2.5.1.tar.gz
tar xvf mbedtls-2.5.1.tar.gz && rm -rf mbedtls-2.5.1.tar.gz
pushd mbedtls-mbedtls-2.5.1
make SHARED=1 CFLAGS=-fPIC
make DESTDIR=/usr install
popd
ldconfig
cd /root 
wget -N -P  /root https://github.com/shadowsocks/shadowsocks-libev/releases/download/v3.0.8/shadowsocks-libev-3.0.8.tar.gz
tar -xf shadowsocks-libev-3.0.8.tar.gz && rm -rf shadowsocks-libev-3.0.8.tar.gz && cd shadowsocks-libev-3.0.8
./configure
make && make install
npm i -g shadowsocks-manager
screen -dmS ss-manager ss-manager -m aes-256-cfb -u --manager-address 127.0.0.1:6001
cd
mkdir -p ~/.ssmgr/
wget -N -P  /root/.ssmgr/ https://raw.githubusercontent.com/xhucoder/myself-ssmgr-setting/master/ss.yml
wget -N -P  /root/.ssmgr/ https://raw.githubusercontent.com/xhucoder/myself-ssmgr-setting/master/webgui.yml
sed -i "s#X.X.X.X#${IPAddress}#g" /root/.ssmgr/webgui.yml
cd ~/.ssmgr
screen -dmS ssmgr ssmgr -c ss.yml
screen -dmS webgui ssmgr -c webgui.yml
cd
systemctl start firewalld
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=80/udp --permanent
firewall-cmd --reload

		else
apt-get update
apt-get remove -y apache*
apt-get install -y build-essential npm wget curl tar git unzip gettext build-essential screen autoconf automake libtool openssl libssl-dev zlib1g-dev xmlto asciidoc libpcre3-dev libudns-dev libev-dev vim
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
apt-get install -y nodejs
wget -N -P  /root https://github.com/jedisct1/libsodium/releases/download/1.0.13/libsodium-1.0.13.tar.gz
tar xvf libsodium-1.0.13.tar.gz && rm -rf libsodium-1.0.13.tar.gz
pushd libsodium-1.0.13
./configure --prefix=/usr && make
make install
popd
wget https://github.com/ARMmbed/mbedtls/archive/mbedtls-2.5.1.tar.gz
tar xvf mbedtls-2.5.1.tar.gz && rm -rf mbedtls-2.5.1.tar.gz
pushd mbedtls-mbedtls-2.5.1
make SHARED=1 CFLAGS=-fPIC
make DESTDIR=/usr install
popd
ldconfig
sudo apt update
sudo apt install shadowsocks-libev
cd
npm i -g shadowsocks-manager
screen -dmS ss-manager ss-manager -m aes-256-cfb -u --manager-address 127.0.0.1:6001
cd
mkdir -p ~/.ssmgr/
wget -N -P  /root/.ssmgr/ https://raw.githubusercontent.com/xhucoder/myself-ssmgr-setting/master/ss.yml
wget -N -P  /root/.ssmgr/ https://raw.githubusercontent.com/xhucoder/myself-ssmgr-setting/master/webgui.yml
sed -i "s#X.X.X.X#${IPAddress}#g" /root/.ssmgr/webgui.yml
cd ~/.ssmgr
screen -dmS ssmgr ssmgr -c ss.yml
screen -dmS webgui ssmgr -c webgui.yml
cd
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 80 -j ACCEPT
service iptables restart
                fi
}
install

	echo "#############################################################"
	echo "# Install SS-mgr  Success                                   #"
	echo "# website:地址栏输入服务器ip查看网页                          #"
	echo "# Author: xhu                                               #"
	echo "#############################################################"
