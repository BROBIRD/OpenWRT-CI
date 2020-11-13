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
sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default


git clone https://github.com/kongfl888/luci-app-adguardhome.git package/extra/luci-app-adguardhome
sed -i '13i\PKG_BUILD_DEPENDS += lua/host luci-base/host' package/extra/luci-app-adguardhome/Makefile
git clone https://github.com/txyiezero/luci-app-udp2raw.git package/extra/luci-app-udp2raw
sed -i '65,68d' package/extra/luci-app-udp2raw/Makefile
git clone https://github.com/txyiezero/openwrt-udp2raw.git package/extra/openwrt-udp2raw
git clone https://github.com/haodong/luci-app-speederv2.git package/extra/luci-app-speederv2
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/extra/luci-app-jd-dailybonus