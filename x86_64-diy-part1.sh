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


git clone https://github.com/kongfl888/luci-app-adguardhome.git package/extra/luci-app-adguardhome
sed -i '13i\PKG_BUILD_DEPENDS += lua/host luci-base/host' package/extra/luci-app-adguardhome/Makefile
git clone https://github.com/Andylive5518/luci-app-udp2raw.git package/extra/luci-app-udp2raw
sed -i '65,68d' package/extra/luci-app-udp2raw/Makefile
git clone https://github.com/txyiezero/openwrt-udp2raw.git package/extra/openwrt-udp2raw
git clone https://github.com/haodong/luci-app-speederv2.git package/extra/luci-app-speederv2
curl -sL -m 30 --retry 2 https://github.com/wangyu-/UDPspeeder/releases/latest/download/speederv2_binaries.tar.gz -o /tmp/speederv2_binaries.tar.gz
tar zxvf /tmp/speederv2_binaries.tar.gz -C /tmp >/dev/null 2>&1
chmod +x /tmp/speederv2_amd64 >/dev/null 2>&1
mkdir -p package/extra/luci-app-speederv2/files/root/usr/bin
mv /tmp/speederv2_amd64 package/extra/luci-app-speederv2/files/root/usr/bin/speederv2 >/dev/null 2>&1
rm -rf /tmp/speederv2_binaries.tar.gz >/dev/null 2>&1
sed -i '71i\	$(INSTALL_DIR) $(1)/usr/bin' package/extra/luci-app-speederv2/Makefile
sed -i '72i\	$(INSTALL_BIN) ./files/root/usr/bin/speederv2 $(1)/usr/bin/speederv2' package/extra/luci-app-speederv2/Makefile

git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/extra/luci-app-jd-dailybonus

mkdir package/extra/luci-app-openclash
cd package/extra/luci-app-openclash
git init
git remote add -f origin https://github.com/vernesong/OpenClash.git
git config core.sparsecheckout true
echo "luci-app-openclash" >> .git/info/sparse-checkout
git pull origin master
git branch --set-upstream-to=origin/master master
cd -
# integration clash core 实现编译更新后直接可用，不用手动下载clash内核
curl -sL -m 30 --retry 2 https://github.com/vernesong/OpenClash/releases/download/Clash/clash-linux-amd64.tar.gz -o /tmp/clash.tar.gz
tar zxvf /tmp/clash.tar.gz -C /tmp >/dev/null 2>&1
chmod +x /tmp/clash >/dev/null 2>&1
mkdir -p package/extra/luci-app-openclash/luci-app-openclash/files/etc/openclash/core
mv /tmp/clash package/extra/luci-app-openclash/luci-app-openclash/files/etc/openclash/core/clash >/dev/null 2>&1
rm -rf /tmp/clash.tar.gz >/dev/null 2>&1

curl -sL -m 30 --retry 2 https://github.com/vernesong/OpenClash/releases/download/TUN/clash-linux-amd64.tar.gz -o /tmp/clash.tar.gz
tar zxvf /tmp/clash.tar.gz -C /tmp >/dev/null 2>&1
chmod +x /tmp/clash >/dev/null 2>&1
mkdir -p package/extra/luci-app-openclash/luci-app-openclash/files/etc/openclash/core
mv /tmp/clash package/extra/luci-app-openclash/luci-app-openclash/files/etc/openclash/core/clash_game >/dev/null 2>&1
rm -rf /tmp/clash.tar.gz >/dev/null 2>&1

CORE_LV=$(curl -sL --connect-timeout 10 --retry 2 https://raw.githubusercontent.com/vernesong/OpenClash/master/core_version | sed -n '2p' 2>/dev/null)
curl -sL -m 30 --retry 2 https://github.com/vernesong/OpenClash/releases/download/TUN-Premium/clash-linux-amd64-"$CORE_LV".gz -o /tmp/clash.gz
gzip -cd /tmp/clash.gz > /tmp/clash
chmod +x /tmp/clash >/dev/null 2>&1
mkdir -p package/extra/luci-app-openclash/luci-app-openclash/files/etc/openclash/core
mv /tmp/clash package/extra/luci-app-openclash/luci-app-openclash/files/etc/openclash/core/clash_tun >/dev/null 2>&1
rm -rf /tmp/clash.gz >/dev/null 2>&1
