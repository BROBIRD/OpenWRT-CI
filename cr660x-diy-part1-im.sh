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
# sed -i '$a\src-git passwall https://github.com/xiaorouji/openwrt-passwall' feeds.conf.default
# sed -i '$a src-git smpackage https://github.com/kenzok8/small-package' feeds.conf.default

# 移除 openwrt feeds 自带的核心包
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}
git clone https://github.com/sbwml/openwrt_helloworld package/helloworld
sed -i 's/f01eb9a10300ac6f7d5cd9759a9a47980a9c9c8c5868e25b705c63e711706032/da36e99151e2d67e4eee8d6e33e5e65b158cbe43306edece7e30c638c4ac6baa/g' package/helloworld/naiveproxy/Makefile
sed -i '/PKG_VERSION:=136\.0\.7103\.44/{n;s/PKG_RELEASE:=1/PKG_RELEASE:=2/}' package/helloworld/naiveproxy/Makefile

# 更新 golang 1.23 版本
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang
sed -i '53i\TARGET_CFLAGS += -fPIC' package/network/utils/fullconenat/Makefile

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default
# git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/extra/luci-app-jd-dailybonus
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/extra/luci-app-adguardhome
sed -i '11i\PKG_BUILD_DEPENDS += lua/host luci-base/host' package/extra/luci-app-adguardhome/Makefile

# sed -i '58,59d' package/utils/bzip2/Makefile
# sed -i '57a\TARGET_CFLAGS += -fPIC' package/utils/bzip2/Makefile
# sed -i 's/$(FPIC)/-fPIC/g' package/utils/bzip2/Makefile