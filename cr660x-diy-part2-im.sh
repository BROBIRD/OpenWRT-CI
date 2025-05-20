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
sed -i 's/192.168.1/192.168.2/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/Linux/g' package/base-files/files/bin/config_generate
sed -i -r '/elseif szType == ("sip008"|'\''vmess'\'') then/i\\t\tresult.fast_open = "1"' feeds/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.lua
sed -i -r '/elseif szType == ("sip008"|'\''vmess'\'') then/i\\t\tresult.fast_open = "1"' feeds/smpackage/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.lua

#只用ipv4地址订阅及更新
sed -i "s/wget -q/wget -4 -q/" feeds/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.lua
sed -i "s/wget --no-check-certificate/wget -4 --no-check-certificate/" feeds/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/update.lua
sed -i "s/wget -q/wget -4 -q/" feeds/smpackage/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.lua
sed -i "s/wget --no-check-certificate/wget -4 --no-check-certificate/" feeds/smpackage/luci-app-ssr-plus/root/usr/share/shadowsocksr/update.lua

rm -rf feeds/luci/themes/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/extra/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/extra/luci-app-argon-config
# sed -i '110d' feeds/packages/libs/qtbase/Makefile
# rm -rf target/linux/ramips/patches-5.4/999-fix-hwnat.patch
# rm -rf target/linux/ramips/patches-5.10/999-fix-hwnat.patch