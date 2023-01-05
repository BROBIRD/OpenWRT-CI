#!/bin/bash
#============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#============================================================

# Modify default IP
sed -i 's/192.168/10.0/g' package/base-files/files/bin/config_generate
sed -i '/--dport 53 -j REDIRECT --to-ports 53/d' package/lean/default-settings/files/zzz-default-settings
sed -i 's/\$1\$V4UetPzk\$CYXluq4wUazHjmCDBCqXF.:0/\$1\$oYZwH1vw$DIG7XTG6XBboLcS0wsM9z0:18039/g' package/lean/default-settings/files/zzz-default-settings
sed -i -r '/elseif szType == ("ssd"|'\''vmess'\'') then/i\\t\tresult.fast_open = "1"' feeds/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.lua
sed -i 's/security-key-builtin/security-key-builtin \\/g' feeds/packages/net/openssh/Makefile
#Backup OpenClash cofig
echo '/etc/openclash/' >> package/base-files/files/etc/sysupgrade.conf

# Update Luci theme argon  
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/extra/luci-theme-argon
# git clone https://github.com/jerrykuku/luci-app-argon-config.git package/extra/luci-app-argon-config