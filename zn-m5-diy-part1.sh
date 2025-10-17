#!/bin/bash
#=============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=============================================================


# sed -i '$a\src-git smpackage https://github.com/kenzok8/small-package' feeds.conf.default
# rm -rf feeds/smpackage/{base-files,dnsmasq,firewall*,fullconenat,libnftnl,nftables,ppp,opkg,ucl,upx,vsftpd*,miniupnpd-iptables,wireless-regdb}

# sed -i 's/+luci-compat/+luci-base/g' package/lean/default-settings/Makefile

rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}
git clone https://github.com/sbwml/openwrt_helloworld package/helloworld

# Uncomment a feed source
sed -i '$a\src-git helloworld https://github.com/fw876/helloworld' feeds.conf.default
# sed -i '$a\src-git passwall https://github.com/xiaorouji/openwrt-passwall' feeds.conf.default

# # 更新 golang 1.24 版本
# rm -rf feeds/packages/lang/golang
# git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# sed -i '53i\TARGET_CFLAGS += -fPIC' package/network/utils/fullconenat/Makefile

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default
# git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/extra/luci-app-jd-dailybonus
# git clone --single-branch --depth=1 https://github.com/stevenjoezhang/luci-app-adguardhome.git package/extra/luci-app-adguardhome
# sed -i '11i\PKG_BUILD_DEPENDS += lua/host luci-base/host' package/extra/luci-app-adguardhome/Makefile

git clone --single-branch --depth=1 https://github.com/EasyTier/luci-app-easytier.git package/extra/easytier