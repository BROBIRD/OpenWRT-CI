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
sed -i 's/192.168/10.0/g' package/base-files/files/bin/config_generate
sed -i '/--dport 53 -j REDIRECT --to-ports 53/d' package/lean/default-settings/files/zzz-default-settings
sed -i 's/\$1\$V4UetPzk\$CYXluq4wUazHjmCDBCqXF.:0/\$1\$oYZwH1vw$DIG7XTG6XBboLcS0wsM9z0:18039/g' package/lean/default-settings/files/zzz-default-settings
sed -i -r '/elseif szType == ("ssd"|'\''vmess'\'') then/i\\t\tresult.fast_open = "1"' feeds/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.lua

#Backup OpenClash cofig
echo '/etc/openclash/' >> package/base-files/files/etc/sysupgrade.conf

# Update Luci theme argon  
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/extra/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-app-argon-config.git package/extra/luci-app-argon-config

# Use nginx instead of uhttpd
sed -i 's/+uhttpd /+luci-nginx /g' feeds/luci/collections/luci/Makefile
sed -i 's/+uhttpd-mod-ubus //' feeds/luci/collections/luci/Makefile
sed -i 's/+uhttpd /+luci-nginx /g' feeds/luci/collections/luci-light/Makefile
sed -i "s/+luci /+luci-nginx /g" feeds/luci/collections/luci-ssl-openssl/Makefile
sed -i "s/+luci /+luci-nginx /g" feeds/luci/collections/luci-ssl/Makefile

# Optimization level -Ofast
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/target-modify_for_x86_64.patch | patch -p1

# openssl -> quictls
rm -rf package/libs/openssl
git clone https://github.com/sbwml/package_libs_openssl package/libs/openssl

# openssl hwrng
sed -i "/-openwrt/iOPENSSL_OPTIONS += enable-ktls '-DDEVRANDOM=\"\\\\\"/dev/urandom\\\\\"\"\'\n" package/libs/openssl/Makefile

# openssl -Ofast
sed -i "s/-O3/-Ofast/g" package/libs/openssl/Makefile

# openssl: make compatible with v1.1 pkg 
sed -i '/libcrypto.so/a\	$(LN) libcrypto.so.3 $(1)/usr/lib/libcrypto.so.1.1' package/libs/openssl/Makefile
sed -i '/libssl.so/a\	$(LN) libssl.so.3 $(1)/usr/lib/libssl.so.1.1' package/libs/openssl/Makefile

# nghttp3
git clone https://github.com/sbwml/package_libs_nghttp3 package/libs/nghttp3

# ngtcp2
git clone https://github.com/sbwml/package_libs_ngtcp2 package/libs/ngtcp2

# curl - http3/quic
rm -rf feeds/packages/net/curl
git clone https://github.com/sbwml/feeds_packages_net_curl feeds/packages/net/curl

# nginx - latest version
rm -rf feeds/packages/net/nginx
git clone https://github.com/sbwml/feeds_packages_net_nginx feeds/packages/net/nginx -b quic
curl -s https://raw.githubusercontent.com/kn007/patch/master/nginx_dynamic_tls_records.patch > feeds/packages/net/nginx/patches/nginx/105-nginx_dynamic_tls_records.patch
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g;s/procd_set_param stderr 1/procd_set_param stderr 0/g' feeds/packages/net/nginx/files/nginx.init
sed -i '261a\config NGINX_NJS_MODULE\n\tbool\n\tprompt "Enable NJS module"\n\thelp\n\t\tAdd support for Javascript dynamic module.\n\tdefault n\n' feeds/packages/net/nginx/Config_ssl.in
sed -i '582a\$(eval $(call BuildPackage,nginx-mod-njs))' feeds/packages/net/nginx/Makefile
sed -i '566a\ifeq ($(CONFIG_NGINX_NJS_MODULE),y)\n  $(eval $(call Download,nginx-njs))\n  $(Prepare/nginx-njs)\nendif\n' feeds/packages/net/nginx/Makefile
sed -i '453a\define Download/nginx-njs\n  VERSION:=9d4bf6c60aa60a828609f64d1b5c50f71bb7ef62\n  SUBDIR:=nginx-njs\n  FILE:=njs-$$(VERSION).tax.xz\n  URL:=https://github.com/nginx/njs.git\n  MIRROR_HASH:=skip\n  PROTO:=git\nendef\n\ndefine Prepare/nginx-njs\n\t$(eval $(Download/nginx-njs))\n\txzcat $(DL_DIR)/$(FILE) | tar -C $(PKG_BUILD_DIR) $(TAR_OPTIONS)\nendef\n' feeds/packages/net/nginx/Makefile
sed -i '330a\define Package/nginx-mod-njs\n  TITLE:=njs in nginx\n  SECTION:=net\n  CATEGORY:=Network\n  SUBMENU:=Web Servers/Proxies\n  TITLE:=dynamic module for Nginx\n  URL:=http://nginx.org/\n  DEPENDS:=+nginx\n  CONFLICTS:=nginx-all-module\nendef\n\ndefine Package/nginx-mod-njs/description\n Dynamic njs module for Nginx.\nendef\n' feeds/packages/net/nginx/Makefile
sed -i '310a\\t--add-module=$(PKG_BUILD_DIR)/nginx-njs \' feeds/packages/net/nginx/Makefile
sed -i '287a\  ifeq ($(CONFIG_NGINX_NJS_MODULE),y)\n    ADDITIONAL_MODULES += --add-module=$(PKG_BUILD_DIR)/nginx-njs\n  endif\n' feeds/packages/net/nginx/Makefile
sed -i '72a\\tCONFIG_NGINX_NJS_MODULE \\' feeds/packages/net/nginx/Makefile

# nginx - ubus
sed -i 's/ubus_parallel_req 2/ubus_parallel_req 6/g' feeds/packages/net/nginx/files-luci-support/60_nginx-luci-support
sed -i '/ubus_parallel_req/a\        ubus_script_timeout 600;' feeds/packages/net/nginx/files-luci-support/60_nginx-luci-support

# nginx - uwsgi timeout & enable brotli
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/nginx/luci.locations > feeds/packages/net/nginx/files-luci-support/luci.locations
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/nginx/uci.conf.template > feeds/packages/net/nginx-util/files/uci.conf.template

# BBRv3 - linux-6.1
pushd target/linux/generic/backport-6.1
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0001-net-tcp_bbr-broaden-app-limited-rate-sample-detectio.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0002-net-tcp_bbr-v2-shrink-delivered_mstamp-first_tx_msta.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0003-net-tcp_bbr-v2-snapshot-packets-in-flight-at-transmi.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0004-net-tcp_bbr-v2-count-packets-lost-over-TCP-rate-samp.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0005-net-tcp_bbr-v2-export-FLAG_ECE-in-rate_sample.is_ece.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0006-net-tcp_bbr-v2-introduce-ca_ops-skb_marked_lost-CC-m.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0007-net-tcp_bbr-v2-adjust-skb-tx.in_flight-upon-merge-in.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0008-net-tcp_bbr-v2-adjust-skb-tx.in_flight-upon-split-in.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0009-net-tcp-add-new-ca-opts-flag-TCP_CONG_WANTS_CE_EVENT.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0010-net-tcp-re-generalize-TSO-sizing-in-TCP-CC-module-AP.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0011-net-tcp-add-fast_ack_mode-1-skip-rwin-check-in-tcp_f.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0012-net-tcp_bbr-v2-record-app-limited-status-of-TLP-repa.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0013-net-tcp_bbr-v2-inform-CC-module-of-losses-repaired-b.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0014-net-tcp_bbr-v2-introduce-is_acking_tlp_retrans_seq-i.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0015-tcp-introduce-per-route-feature-RTAX_FEATURE_ECN_LOW.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0016-tcp-add-sysctls-for-TCP-PLB-parameters.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0017-tcp-add-PLB-functionality-for-TCP.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0018-net-tcp_bbr-v3-update-TCP-bbr-congestion-control-mod.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0019-net-tcp_bbr-v3-ensure-ECN-enabled-BBR-flows-set-ECT-.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/03175e52daa97839f58ebd46e9ccecf918fbe5ba/openwrt/patch/kernel-6.1/bbr3_6.1/010-bbr3-0020-tcp-export-TCPI_OPT_ECN_LOW-in-tcp_info-tcpi_options.patch
popd

# Try update acme.sh
sed -i 's/3.0.3/3.0.7/g' feeds/packages/net/acme/Makefile
sed -i 's/601a1688b5e2fdd567c3ee308be243e9329b286336e4a709ee2157eff7b06aaf/abd446d6bd45d0b44dca1dcbd931348797a3f82d1ed6fb171472eaf851a8d849/g' feeds/packages/net/acme/Makefile

# drop mosdns and v2ray-geodata packages that come with the source
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f

git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata