#!/bin/bash
#=============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=============================================================

# Uncomment a feed source
sed -i '$a\src-git helloworld https://github.com/fw876/helloworld' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/extra/luci-app-jd-dailybonus
git clone https://github.com/Hyy2001X/luci-app-adguardhome.git package/extra/luci-app-adguardhome
sed -i '10i\PKG_BUILD_DEPENDS += lua/host luci-base/host' package/extra/luci-app-adguardhome/Makefile