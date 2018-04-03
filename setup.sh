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
sudo yum groupinstall "Development Tools" -y
sudo yum install wget git zip   gcc gcc-c++ -y
sudo yum install wget curl tar unzip -y
sudo yum install -y gcc gettext-devel unzip autoconf automake make zlib-devel libtool xmlto asciidoc udns-devel libev-devel
sudo yum install -y pcre pcre-devel perl perl-devel cpio expat-devel openssl-devel mbedtls-devel screen nano
sudo yum install gettext gcc autoconf libtool automake make asciidoc xmlto c-ares-devel libev-devel -y
sudo yum install -y gcc-c++ make
sudo curl --silent --location https://rpm.nodesource.com/setup_6.x | sudo bash -
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
sudo apt-get update
sudo apt-get remove -y apache*
sudo apt-get install -y build-essential npm wget curl tar git unzip gettext build-essential screen autoconf automake libtool openssl libssl-dev zlib1g-dev xmlto asciidoc libpcre3-dev libudns-dev libev-dev vim
sudo apt-get install --no-install-recommends gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libc-ares-dev automake libmbedtls-dev libsodium-dev -y
sudo apt-get install --no-install-recommends gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libc-ares-dev automake libmbedtls-dev libsodium-dev -y
sudo curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo wget -N -P  /root https://github.com/jedisct1/libsodium/releases/download/1.0.13/libsodium-1.0.13.tar.gz
sudo tar xvf libsodium-1.0.13.tar.gz && rm -rf libsodium-1.0.13.tar.gz
pushd libsodium-1.0.13
sudo ./configure --prefix=/usr
sudo make
sudo make install
popd
sudo wget https://github.com/ARMmbed/mbedtls/archive/mbedtls-2.5.1.tar.gz
sudo tar xvf mbedtls-2.5.1.tar.gz && rm -rf mbedtls-2.5.1.tar.gz
pushd mbedtls-mbedtls-2.5.1
sudo make SHARED=1 CFLAGS=-fPIC
sudo make DESTDIR=/usr install
popd
sudo ldconfig
sudo add-apt-repository ppa:max-c-lv/shadowsocks-libev -y
sudo apt-get update -y
sudo apt install shadowsocks-libev -y
cd
sudo npm i -g shadowsocks-manager
sudo screen -dmS ss-manager ss-manager -m aes-256-cfb -u --manager-address 127.0.0.1:6001
cd
sudo mkdir -p ~/.ssmgr/
sudo wget -N -P  /root/.ssmgr/ https://raw.githubusercontent.com/xhucoder/myself-ssmgr-setting/master/ss.yml
sudo wget -N -P  /root/.ssmgr/ https://raw.githubusercontent.com/xhucoder/myself-ssmgr-setting/master/webgui.yml
sudo sed -i "s#X.X.X.X#${IPAddress}#g" /root/.ssmgr/webgui.yml
cd ~/.ssmgr
sudo screen -dmS ssmgr ssmgr -c ss.yml
sudo screen -dmS webgui ssmgr -c webgui.yml
cd
                fi
}
install

	echo "#############################################################"
	echo "# Install SS-mgr  Success                                   #"
	echo "# website:地址栏输入服务器ip查看网页                          #"
	echo "# Author: xhu                                               #"
	echo "#############################################################"
