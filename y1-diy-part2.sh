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
sed -i 's/192.168.1/192.168.4/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/Linux/g' package/base-files/files/bin/config_generate
sed -i '/--dport 53 -j REDIRECT --to-ports 53/d' package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0/d' package/lean/default-settings/files/zzz-default-settings
echo "sed -i 's/lock/#lock/g' /etc/ppp/options" >> package/lean/default-settings/files/zzz-default-settings
echo "echo 'refuse-eap' >> /etc/ppp/options" >> package/lean/default-settings/files/zzz-default-settings
echo "echo 'refuse-pap' >> /etc/ppp/options" >> package/lean/default-settings/files/zzz-default-settings
echo 'exit 0' >> package/lean/default-settings/files/zzz-default-settings
#sed -i -r '/elseif szType == ("sip008"|'\''vmess'\'') then/i\\t\tresult.fast_open = "1"' feeds/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.lua

#只用ipv4地址订阅及更新
# sed -i "s/wget -q/wget -4 -q/" feeds/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.lua
# sed -i "s/wget --no-check-certificate/wget -4 --no-check-certificate/" feeds/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/update.lua
# Update Luci theme argon  
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/extra/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-app-argon-config.git package/extra/luci-app-argon-config