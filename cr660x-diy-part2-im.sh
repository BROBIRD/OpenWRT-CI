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
sed -i -r '/elseif szType == ("sip008"|'\''vmess'\'') then/i\\t\tresult.fast_open = "1"' package/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.lua

#只用ipv4地址订阅及更新
sed -i "s/wget -q/wget -4 -q/" feeds/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.lua
sed -i "s/wget --no-check-certificate/wget -4 --no-check-certificate/" feeds/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/update.lua
sed -i "s/wget -q/wget -4 -q/" package/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.lua
sed -i "s/wget --no-check-certificate/wget -4 --no-check-certificate/" package/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/update.lua

rm -rf feeds/luci/themes/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/extra/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/extra/luci-app-argon-config
# sed -i '110d' feeds/packages/libs/qtbase/Makefile
# rm -rf target/linux/ramips/patches-5.4/999-fix-hwnat.patch
# rm -rf target/linux/ramips/patches-5.10/999-fix-hwnat.patch

sed -i '58,59d' package/utils/bzip2/Makefile
sed -i '57a\TARGET_CFLAGS += -fPIC -mno-mips16' package/utils/bzip2/Makefile
sed -i '21a\PKG_BUILD_FLAGS:=no-mips16' package/utils/bzip2/Makefile
sed -i '21a\PKG_ASLR_PIE:=0' package/utils/bzip2/Makefile
sed -i '21a\PKG_LTO:=0' package/utils/bzip2/Makefile
sed -i '21a\PKG_SHARED_LIBRARY:=0' package/utils/bzip2/Makefile
sed -i 's/$(FPIC)/-fPIC/g' package/utils/bzip2/Makefile

# openssl -> quictls
rm -rf package/libs/openssl
git clone https://github.com/sbwml/package_libs_openssl package/libs/openssl

# curl - http3/quic
rm -rf feeds/packages/net/curl
git clone https://github.com/sbwml/feeds_packages_net_curl feeds/packages/net/curl