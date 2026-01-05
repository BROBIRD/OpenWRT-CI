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
sed -i -r '/elseif szType == ("sip008"|"vmess") then/i\\t\tresult.fast_open = "1"' feeds/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.lua

#只用ipv4地址订阅及更新
sed -i "s/wget -q/wget -4 -q/" feeds/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.lua
sed -i "s/wget --no-check-certificate/wget -4 --no-check-certificate/" feeds/helloworld/luci-app-ssr-plus/root/usr/share/shadowsocksr/update.lua

#Backup OpenClash cofig
echo '/etc/openclash/' >> package/base-files/files/etc/sysupgrade.conf

# Update Luci theme argon  
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config
git clone -b 18.06 --single-branch --depth=1 https://github.com/jerrykuku/luci-theme-argon.git package/extra/luci-theme-argon
git clone -b 18.06 --single-branch --depth=1 https://github.com/jerrykuku/luci-app-argon-config.git package/extra/luci-app-argon-config

# Use nginx instead of uhttpd
sed -i 's/+uhttpd /+luci-nginx /g' feeds/luci/collections/luci/Makefile
sed -i 's/+uhttpd-mod-ubus //' feeds/luci/collections/luci/Makefile
sed -i 's/+uhttpd /+luci-nginx /g' feeds/luci/collections/luci-light/Makefile
sed -i "s/+luci /+luci-nginx /g" feeds/luci/collections/luci-ssl-openssl/Makefile
sed -i "s/+luci /+luci-nginx /g" feeds/luci/collections/luci-ssl/Makefile

sed -i 's#check_status fastpath#check_status fastpath > /dev/null#g' feeds/luci/applications/luci-app-turboacc/luasrc/controller/turboacc.lua

# Optimization level -Ofast
# curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/target-modify_for_x86_64.patch | patch -p1

# # openssl - quictls
# pushd package/libs/openssl/patches
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0001-QUIC-Add-support-for-BoringSSL-QUIC-APIs.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0002-QUIC-New-method-to-get-QUIC-secret-length.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0003-QUIC-Make-temp-secret-names-less-confusing.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0004-QUIC-Move-QUIC-transport-params-to-encrypted-extensi.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0005-QUIC-Use-proper-secrets-for-handshake.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0006-QUIC-Handle-partial-handshake-messages.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0007-QUIC-Fix-quic_transport-constructors-parsers.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0008-QUIC-Reset-init-state-in-SSL_process_quic_post_hands.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0009-QUIC-Don-t-process-an-incomplete-message.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0010-QUIC-Quick-fix-s2c-to-c2s-for-early-secret.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0011-QUIC-Add-client-early-traffic-secret-storage.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0012-QUIC-Add-OPENSSL_NO_QUIC-wrapper.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0013-QUIC-Correctly-disable-middlebox-compat.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0014-QUIC-Move-QUIC-code-out-of-tls13_change_cipher_state.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0015-QUIC-Tweeks-to-quic_change_cipher_state.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0016-QUIC-Add-support-for-more-secrets.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0017-QUIC-Fix-resumption-secret.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0018-QUIC-Handle-EndOfEarlyData-and-MaxEarlyData.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0019-QUIC-Fall-through-for-0RTT.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0020-QUIC-Some-cleanup-for-the-main-QUIC-changes.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0021-QUIC-Prevent-KeyUpdate-for-QUIC.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0022-QUIC-Test-KeyUpdate-rejection.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0023-QUIC-Buffer-all-provided-quic-data.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0024-QUIC-Enforce-consistent-encryption-level-for-handsha.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0025-QUIC-add-v1-quic_transport_parameters.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0026-QUIC-return-success-when-no-post-handshake-data.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0027-QUIC-__owur-makes-no-sense-for-void-return-values.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0028-QUIC-remove-SSL_R_BAD_DATA_LENGTH-unused.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0029-QUIC-SSLerr-ERR_raise-ERR_LIB_SSL.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0030-QUIC-Add-compile-run-time-checking-for-QUIC.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0031-QUIC-Add-early-data-support.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0032-QUIC-Make-SSL_provide_quic_data-accept-0-length-data.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0033-QUIC-Process-multiple-post-handshake-messages-in-a-s.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0034-QUIC-Fix-CI.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0035-QUIC-Break-up-header-body-processing.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0036-QUIC-Don-t-muck-with-FIPS-checksums.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0037-QUIC-Update-RFC-references.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0038-QUIC-revert-white-space-change.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0039-QUIC-use-SSL_IS_QUIC-in-more-places.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0040-QUIC-Error-when-non-empty-session_id-in-CH.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0041-QUIC-Update-SSL_clear-to-clear-quic-data.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0042-QUIC-Better-SSL_clear.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0043-QUIC-Fix-extension-test.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0044-QUIC-Update-metadata-version.patch
# popd

# # openssl benchmarks
# pushd package/libs/openssl/patches
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/901-Revert-speed-Pass-IV-to-EVP_CipherInit_ex-for-evp-ru.patch
#     curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/902-Revert-apps-speed.c-Fix-the-benchmarking-for-AEAD-ci.patch
# popd

# openssl hwrng
sed -i "/-openwrt/iOPENSSL_OPTIONS += enable-ktls '-DDEVRANDOM=\"\\\\\"/dev/urandom\\\\\"\"\'\n" package/libs/openssl/Makefile

# openssl -Ofast
sed -i "s/-O3/-Ofast/g" package/libs/openssl/Makefile

# # openssl: make compatible with v1.1 pkg 
# sed -i '/libcrypto.so/a\	$(LN) libcrypto.so.3 $(1)/usr/lib/libcrypto.so.1.1' package/libs/openssl/Makefile
# sed -i '/libssl.so/a\	$(LN) libssl.so.3 $(1)/usr/lib/libssl.so.1.1' package/libs/openssl/Makefile

# nghttp3
../gh-down.sh https://github.com/immortalwrt/packages/tree/master/libs/nghttp3 package/libs/nghttp3
# git clone https://github.com/sbwml/package_libs_nghttp3 package/libs/nghttp3

# ngtcp2
git clone --single-branch --depth=1 https://github.com/sbwml/package_libs_ngtcp2 package/libs/ngtcp2

# curl - http3/quic
rm -rf feeds/packages/net/curl
git clone --single-branch --depth=1 https://github.com/sbwml/feeds_packages_net_curl feeds/packages/net/curl

# nginx - latest version
rm -rf feeds/packages/net/nginx
git clone --single-branch --depth=1 https://github.com/sbwml/feeds_packages_net_nginx -b quic+zstd feeds/packages/net/nginx
# curl -s https://raw.githubusercontent.com/kn007/patch/e2fcf45e320bb8317042b6796b8f9dd42ffdb25c/nginx_dynamic_tls_records.patch > feeds/packages/net/nginx/patches/nginx/105-nginx_dynamic_tls_records.patch
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g;s/procd_set_param stderr 1/procd_set_param stderr 0/g' feeds/packages/net/nginx/files/nginx.init
sed -i 's/1.26.2/1.28.0/g' feeds/packages/net/nginx/Makefile
sed -i 's/627fe086209bba80a2853a0add9d958d7ebbdffa1a8467a5784c9a6b4f03d738/c6b5c6b086c0df9d3ca3ff5e084c1d0ef909e6038279c71c1c3e985f576ff76a/g' feeds/packages/net/nginx/Makefile

# uwsgi - latest version
rm -rf feeds/packages/net/uwsgi
../gh-down.sh https://github.com/immortalwrt/packages/tree/master/net/uwsgi feeds/packages/net/uwsgi

rm -rf feeds/packages/net/uwsgi/files-luci-support
../gh-down.sh https://github.com/coolsnowwolf/packages/tree/master/net/uwsgi/files-luci-support feeds/packages/net/uwsgi/files-luci-support

# sed -i '261a\config NGINX_NJS_MODULE\n\tbool\n\tprompt "Enable NJS module"\n\thelp\n\t\tAdd support for Javascript dynamic module.\n\tdefault n\n' feeds/packages/net/nginx/Config_ssl.in
# # sed -i '582a\$(eval $(call BuildPackage,nginx-mod-njs))' feeds/packages/net/nginx/Makefile
# sed -i '566a\ifeq ($(CONFIG_NGINX_NJS_MODULE),y)\n  $(eval $(call Download,nginx-njs))\n  $(Prepare/nginx-njs)\nendif\n' feeds/packages/net/nginx/Makefile
# sed -i '453a\define Download/nginx-njs\n  VERSION:=9d4bf6c60aa60a828609f64d1b5c50f71bb7ef62\n  SUBDIR:=nginx-njs\n  FILE:=njs-$$(VERSION).tar.xz\n  URL:=https://github.com/nginx/njs.git\n  MIRROR_HASH:=skip\n  PROTO:=git\nendef\n\ndefine Prepare/nginx-njs\n\t$(eval $(Download/nginx-njs))\n\txzcat $(DL_DIR)/$(FILE) | tar -C $(PKG_BUILD_DIR) $(TAR_OPTIONS)\nendef\n' feeds/packages/net/nginx/Makefile
# sed -i '330a\define Package/nginx-mod-njs\n  TITLE:=njs in nginx\n  SECTION:=net\n  CATEGORY:=Network\n  SUBMENU:=Web Servers/Proxies\n  TITLE:=dynamic module for Nginx\n  URL:=http://nginx.org/\n  DEPENDS:=+nginx\n  CONFLICTS:=nginx-all-module\nendef\n\ndefine Package/nginx-mod-njs/description\n Dynamic njs module for Nginx.\nendef\n' feeds/packages/net/nginx/Makefile
# sed -i '311 s#^#\t--add-module=$(PKG_BUILD_DIR)/nginx-njs/nginx \\\n#' feeds/packages/net/nginx/Makefile
# sed -i '293 s/^/\tCONFIG_NGINX_NJS_MODULE:=y\n/' feeds/packages/net/nginx/Makefile
# sed -i '287a\  ifeq ($(CONFIG_NGINX_NJS_MODULE),y)\n    ADDITIONAL_MODULES += --add-module=$(PKG_BUILD_DIR)/nginx-njs/nginx\n  endif\n' feeds/packages/net/nginx/Makefile
# sed -i '73 s/^/\tCONFIG_NGINX_NJS_MODULE \\\n/' feeds/packages/net/nginx/Makefile

# nginx - ubus
sed -i 's/ubus_parallel_req 2/ubus_parallel_req 6/g' feeds/packages/net/nginx/files-luci-support/60_nginx-luci-support
sed -i '/ubus_parallel_req/a\        ubus_script_timeout 600;' feeds/packages/net/nginx/files-luci-support/60_nginx-luci-support

# nginx - uwsgi timeout & enable brotli+zstd
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/nginx/luci.locations > feeds/packages/net/nginx/files-luci-support/luci.locations
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/nginx/uci.conf.template > feeds/packages/net/nginx-util/files/uci.conf.template

# BBRv3 - linux-6.12
pushd target/linux/generic/backport-6.12
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0001-net-tcp_bbr-broaden-app-limited-rate-sample-detectio.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0002-net-tcp_bbr-v2-shrink-delivered_mstamp-first_tx_msta.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0003-net-tcp_bbr-v2-snapshot-packets-in-flight-at-transmi.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0004-net-tcp_bbr-v2-count-packets-lost-over-TCP-rate-samp.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0005-net-tcp_bbr-v2-export-FLAG_ECE-in-rate_sample.is_ece.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0006-net-tcp_bbr-v2-introduce-ca_ops-skb_marked_lost-CC-m.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0007-net-tcp_bbr-v2-adjust-skb-tx.in_flight-upon-merge-in.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0008-net-tcp_bbr-v2-adjust-skb-tx.in_flight-upon-split-in.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0009-net-tcp-add-new-ca-opts-flag-TCP_CONG_WANTS_CE_EVENT.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0010-net-tcp-re-generalize-TSO-sizing-in-TCP-CC-module-AP.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0011-net-tcp-add-fast_ack_mode-1-skip-rwin-check-in-tcp_f.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0012-net-tcp_bbr-v2-record-app-limited-status-of-TLP-repa.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0013-net-tcp_bbr-v2-inform-CC-module-of-losses-repaired-b.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0014-net-tcp_bbr-v2-introduce-is_acking_tlp_retrans_seq-i.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0015-tcp-introduce-per-route-feature-RTAX_FEATURE_ECN_LOW.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0016-net-tcp_bbr-v3-update-TCP-bbr-congestion-control-mod.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0017-net-tcp_bbr-v3-ensure-ECN-enabled-BBR-flows-set-ECT-.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0018-tcp-export-TCPI_OPT_ECN_LOW-in-tcp_info-tcpi_options.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0019-x86-cfi-bpf-Add-tso_segs-and-skb_marked_lost-to-bpf_.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/021c0f4b77258923a7a3c735565e19d1acb410b3/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0020-net-tcp_bbr-v3-silence-Wconstant-logical-operand.patch
popd


# Try update acme.sh
sed -i 's/3.0.7/3.1.2/g' feeds/packages/net/acme/Makefile
sed -i 's/abd446d6bd45d0b44dca1dcbd931348797a3f82d1ed6fb171472eaf851a8d849/a51511ad0e2912be45125cf189401e4ae776ca1a29d5768f020a1e35a9560186/g' feeds/packages/net/acme/Makefile

# drop mosdns and v2ray-geodata packages that come with the source
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f

git clone --single-branch --depth=1 https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone --single-branch --depth=1 https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

rm -rf feeds/smpackage/gost/patches
rm -rf feeds/smpackage/luci-app-gost
../gh-down.sh https://github.com/kenzok8/openwrt-packages/tree/master/luci-app-gost feeds/smpackage/luci-app-gost
rm -rf feeds/smpackage/{base-files,dnsmasq,firewall*,fullconenat,libnftnl,nftables,ppp,opkg,ucl,upx,vsftpd*,miniupnpd-iptables,wireless-regdb,tcping}

git clone --single-branch --depth=1 https://github.com/EasyTier/luci-app-easytier.git package/extra/luci-app-easytier

rm -fr feeds/luci/applications/luci-app-zerotier
git clone --depth=1 https://github.com/BROBIRD/luci-app-zerotier.git feeds/luci/applications/luci-app-zerotier

# sed -i 's#+$(NINJA) -C $(HOST_BUILD_DIR)/out#ninja -C $(HOST_BUILD_DIR)/out#g' feeds/helloworld/gn/Makefile

rm -rf feeds/packages/net/microsocks
# ln -s feeds/smpackage/net/microsocks feeds/packages/net/microsocks
./scripts/feeds install -a
