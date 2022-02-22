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
#sed -i 's/192.168.1/10.0.0/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/Linux/g' package/base-files/files/bin/config_generate
sed -i '/--dport 53 -j REDIRECT --to-ports 53/d' package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0/d' package/lean/default-settings/files/zzz-default-settings
echo "sed -i 's/lock/#lock/g' /etc/ppp/options" >> package/lean/default-settings/files/zzz-default-settings
echo "echo 'refuse-eap' >> /etc/ppp/options" >> package/lean/default-settings/files/zzz-default-settings
echo "echo 'refuse-pap' >> /etc/ppp/options" >> package/lean/default-settings/files/zzz-default-settings
echo 'exit 0' >> package/lean/default-settings/files/zzz-default-settings
sed -i -r '/elseif szType == ("ssd"|'\''vmess'\'') then/i\\t\tresult.fast_open = "1"' feeds/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.lua
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/extra/luci-theme-argon
rm -rf target/linux/ramips/patches-5.4/999-fix-hwnat.patch
rm -rf target/linux/ramips/patches-5.10/999-fix-hwnat.patch