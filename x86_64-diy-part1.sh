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
sed -i 's/;openwrt-23.05//g' feeds.conf.default
sed -i '$a\src-git smpackage https://github.com/kenzok8/small-package' feeds.conf.default
# sed -i '$a\src-git passwall https://github.com/xiaorouji/openwrt-passwall' feeds.conf.default


# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default


# git clone https://github.com/jerrykuku/lua-maxminddb.git package/lean/lua-maxminddb
# # git clone https://github.com/jerrykuku/luci-app-vssr.git package/lean/luci-app-vssr
# git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/extra/luci-app-adguardhome
# sed -i '11i\PKG_BUILD_DEPENDS += lua/host luci-base/host' package/extra/luci-app-adguardhome/Makefile

# git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/extra/luci-app-jd-dailybonus

mkdir package/extra/luci-app-openclash
cd package/extra/luci-app-openclash
git init
git remote add -f origin https://github.com/vernesong/OpenClash.git
git config core.sparsecheckout true
echo "luci-app-openclash" >> .git/info/sparse-checkout
git pull --depth 1 origin master
git branch --set-upstream-to=origin/master master
cd -
# integration clash core 实现编译更新后直接可用，不用手动下载clash内核
# curl -sL -m 30 --retry 2 https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/meta/clash-linux-amd64.tar.gz -o /tmp/clash.tar.gz
# tar zxvf /tmp/clash.tar.gz -C /tmp >/dev/null 2>&1
# chmod +x /tmp/clash >/dev/null 2>&1
# mkdir -p .../package/extra/luci-app-openclash/luci-app-openclash/files/etc/openclash/core
# mv /tmp/clash .../package/extra/luci-app-openclash/luci-app-openclash/files/etc/openclash/core/clash >/dev/null 2>&1
# rm -rf /tmp/clash.tar.gz >/dev/null 2>&1

# mkdir package/extra/gost
# cd package/extra/gost
# git init
# git remote add -f origin https://github.com/kenzok8/openwrt-packages.git
# git config core.sparsecheckout true
# echo "luci-app-gost" >> .git/info/sparse-checkout
# echo "gost" >> .git/info/sparse-checkout
# git pull --depth 1 origin master
# git branch --set-upstream-to=origin/master master
# rm -rf gost/patches
# cd -


# git clone https://github.com/sirpdboy/luci-app-eqosplus package/extra/luci-app-eqosplus
# git clone https://github.com/sirpdboy/luci-app-lucky.git package/extra/luci-app-lucky
git clone https://github.com/sirpdboy/luci-app-advancedplus.git package/extra/luci-app-advancedplus