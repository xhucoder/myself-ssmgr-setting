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
install_soft_for_each(){
	check_sys
	if [[ ${release} = "centos" ]]; then
		yum update -y
		yum groupinstall "Development Tools" -y
		yum install -y wget curl tar unzip -y
		yum install gcc gettext autoconf libtool automake make pcre-devel asciidoc xmlto udns-devel libev-devel -y
		yum install -y gcc gettext gettext-devel unzip autoconf automake make zlib-devel libtool xmlto asciidoc udns-devel libev-devel vim epel-release libsodium-devel libsodium
		yum install epel-release -y
        yum install -y pcre pcre-devel perl perl-devel cpio expat-devel openssl-devel mbedtls-devel screen nano
	else
		apt-get update
		apt-get remove -y apache*
		apt-get install -y build-essential npm wget curl tar git unzip gettext build-essential screen autoconf automake libtool openssl libssl-dev zlib1g-dev xmlto asciidoc libpcre3-dev libudns-dev libev-dev vim
	fi
}
install_nodejs(){
	curl --silent --location https://rpm.nodesource.com/setup_6.x | sudo bash -
	curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
	sudo yum -y install nodejs
	sudo yum install gcc-c++ make
}
install_libsodium(){
	cd /root
	wget -N -P  /root https://github.com/jedisct1/libsodium/releases/download/1.0.13/libsodium-1.0.13.tar.gz
	tar xvf libsodium-1.0.13.tar.gz && rm -rf libsodium-1.0.13.tar.gz
	pushd libsodium-1.0.13
	./configure --prefix=/usr && make
	make install
	popd
	wget https://github.com/ARMmbed/mbedtls/archive/mbedtls-2.5.1.tar.gz
	tar xvf mbedtls-2.5.1-gpl.tgz && rm -rf mbedtls-2.5.1-gpl.tgz
	pushd mbedtls-2.5.1
	make SHARED=1 CFLAGS=-fPIC
	make DESTDIR=/usr install
	popd
	ldconfig
}
install_ss_libev(){
	cd /root 
	wget -N -P  /root https://github.com/shadowsocks/shadowsocks-libev/releases/download/v3.0.8/shadowsocks-libev-3.0.8.tar.gz
	tar -xf shadowsocks-libev-3.0.8.tar.gz && rm -rf shadowsocks-libev-3.0.8.tar.gz && cd shadowsocks-libev-3.0.8
	./configure
	make && make install
	cd
}
install_ss_ubuntu(){
	sudo add-apt-repository ppa:max-c-lv/shadowsocks-libev
	sudo apt-get update
	sudo apt install shadowsocks-libev
	cd
}
install_ss_for_each(){
	if [[ ${release} = "centos" ]]; then
		install_ss_libev
	else
		install_ss_ubuntu
	fi
}
install_ss_mgr(){
	install_soft_for_each
	install_nodejs
	install_libsodium
	install_ss_for_each
	cd
	npm i -g shadowsocks-manager
	cd
	
	
}
ss_mgr_s(){
	install_ss_mgr
	cd
	mkdir -p ~/.ssmgr/
	screen -dmS ss-manager ss-manager -m aes-256-cfb -u --manager-address 127.0.0.1:6001
	rm -fr /root/.ssmgr/default.yml
	wget -N -P  /root/.ssmgr/ https://raw.githubusercontent.com/xhucoder/myself-ssmgr-setting/master/default.yml
	cd ~/.ssmgr
	screen -dmS ssmgr ssmgr -c default.yml
	cd

	
}
ss_mgr_m(){
	ss_mgr_s
	cd 
	wget -N -P  /root/.ssmgr/ https://raw.githubusercontent.com/xhucoder/myself-ssmgr-setting/master/webgui.yml
	sed -i "s#127.0.0.1#${IPAddress}#g" /root/.ssmgr/webgui.yml
	cd ~/.ssmgr
	screen -dmS webgui ssmgr -c webgui.yml
	cd

}
ss_mgr_m
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 80 -j ACCEPT
iptables-save
systemctl start firewalld
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=80/udp --permanent
firewall-cmd --reload
	echo "#############################################################"
	echo "# Install SS-mgr  Success                                   #"
	echo "# Github:                                                   #"
	echo "# Author: xhucoder                                          #"
	echo "#############################################################"