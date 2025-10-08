#!/bin/bash
#============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#============================================================

# curl -s https://github.com/immortalwrt/immortalwrt/raw/refs/heads/master/package/base-files/files/bin/config_generate > package/base-files/files/bin/config_generate

# Modify default IP
# sed -i 's/192.168.1.1/10.0.2.1/g' package/base-files/files/bin/config_generate
# sed -i '/--dport 53 -j REDIRECT --to-ports 53/d' package/lean/default-settings/files/zzz-default-settings
sed -i -r '/elseif szType == ("sip008"|'\''vmess'\'') then/i\\t\tresult.fast_open = "1"' feeds/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.lua

#只用ipv4地址订阅及更新
sed -i "s/wget -q/wget -4 -q/" feeds/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.lua
sed -i "s/wget --no-check-certificate/wget -4 --no-check-certificate/" feeds/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/update.lua

rm -rf feeds/luci/themes/luci-theme-argon
git clone --single-branch --depth=1 https://github.com/jerrykuku/luci-theme-argon.git package/extra/luci-theme-argon
git clone --single-branch --depth=1 https://github.com/jerrykuku/luci-app-argon-config.git package/extra/luci-app-argon-config
# sed -i '110d' feeds/packages/libs/qtbase/Makefile
# rm -rf target/linux/ramips/patches-5.4/999-fix-hwnat.patch
# rm -rf target/linux/ramips/patches-5.10/999-fix-hwnat.patch

# rm -rf package/network/services/dnsmasq
# ../gh-down.sh https://github.com/immortalwrt/immortalwrt/tree/master/package/network/services/dnsmasq package/network/services/dnsmasq

# rm -rf package/libs/openssl
# ../gh-down.sh https://github.com/immortalwrt/immortalwrt/tree/master/package/libs/openssl package/libs/openssl
# # openssl hwrng
# sed -i "/-openwrt/iOPENSSL_OPTIONS += enable-ktls '-DDEVRANDOM=\"\\\\\"/dev/urandom\\\\\"\"\'\n" package/libs/openssl/Makefile

# # openssl -Os
# sed -i "s/-O3/-Os/g" package/libs/openssl/Makefile

# # openssl: make compatible with v1.1 pkg 
# sed -i '/libcrypto.so/a\	$(LN) libcrypto.so.3 $(1)/usr/lib/libcrypto.so.1.1' package/libs/openssl/Makefile
# sed -i '/libssl.so/a\	$(LN) libssl.so.3 $(1)/usr/lib/libssl.so.1.1' package/libs/openssl/Makefile

# nghttp3
# rm -rf feeds/packages/libs/nghttp3
# git clone https://github.com/sbwml/package_libs_nghttp3 package/libs/nghttp3

# # ngtcp2
# rm -rf feeds/packages/libs/ngtcp2
# git clone --single-branch --depth=1 https://github.com/sbwml/package_libs_ngtcp2 package/libs/ngtcp2

# curl - http3/quic
# rm -rf feeds/packages/net/curl
# git clone --single-branch --depth=1 https://github.com/sbwml/feeds_packages_net_curl feeds/packages/net/curl

# # BBRv3 - linux-6.6
# pushd target/linux/generic/backport-6.6
# 	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0001-net-tcp_bbr-broaden-app-limited-rate-sample-detectio.patch
# 	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0002-net-tcp_bbr-v2-shrink-delivered_mstamp-first_tx_msta.patch
# 	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0003-net-tcp_bbr-v2-snapshot-packets-in-flight-at-transmi.patch
# 	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0004-net-tcp_bbr-v2-count-packets-lost-over-TCP-rate-samp.patch
# 	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0005-net-tcp_bbr-v2-export-FLAG_ECE-in-rate_sample.is_ece.patch
# 	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0006-net-tcp_bbr-v2-introduce-ca_ops-skb_marked_lost-CC-m.patch
# 	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0007-net-tcp_bbr-v2-adjust-skb-tx.in_flight-upon-merge-in.patch
# 	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0008-net-tcp_bbr-v2-adjust-skb-tx.in_flight-upon-split-in.patch
# 	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0009-net-tcp-add-new-ca-opts-flag-TCP_CONG_WANTS_CE_EVENT.patch
# 	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0010-net-tcp-re-generalize-TSO-sizing-in-TCP-CC-module-AP.patch
# 	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0011-net-tcp-add-fast_ack_mode-1-skip-rwin-check-in-tcp_f.patch
# 	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0012-net-tcp_bbr-v2-record-app-limited-status-of-TLP-repa.patch
# 	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0013-net-tcp_bbr-v2-inform-CC-module-of-losses-repaired-b.patch
# 	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0014-net-tcp_bbr-v2-introduce-is_acking_tlp_retrans_seq-i.patch
# 	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0015-tcp-introduce-per-route-feature-RTAX_FEATURE_ECN_LOW.patch
# 	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0016-net-tcp_bbr-v3-update-TCP-bbr-congestion-control-mod.patch
# 	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0017-net-tcp_bbr-v3-ensure-ECN-enabled-BBR-flows-set-ECT-.patch
# 	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0018-tcp-export-TCPI_OPT_ECN_LOW-in-tcp_info-tcpi_options.patch
# popd