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

mkdir -p package/helloworld/trojan-plus/patches
pushd package/helloworld/trojan-plus/patches
    curl -sLO https://gist.github.com/BROBIRD/7644585651f249abe124d81a540fe808/raw/8d896921cb1bef2b4c37307e14bf5c7ffc895e46/001-fix-boost-deprecated_functions.patch
popd
chmod 644 package/helloworld/trojan-plus/patches/001-fix-boost-deprecated_functions.patch

# sed -i '58,59d' package/utils/bzip2/Makefile
# sed -i '57a\TARGET_CFLAGS += -fPIC -mno-mips16' package/utils/bzip2/Makefile
# sed -i '21a\PKG_BUILD_FLAGS:=no-mips16' package/utils/bzip2/Makefile
# sed -i '21a\PKG_ASLR_PIE:=0' package/utils/bzip2/Makefile
# sed -i '21a\PKG_LTO:=0' package/utils/bzip2/Makefile
# sed -i '21a\PKG_SHARED_LIBRARY:=0' package/utils/bzip2/Makefile
# sed -i 's/$(FPIC)/-fPIC/g' package/utils/bzip2/Makefile

# mkdir -p package/utils/bzip2/patches/
# cat > package/utils/bzip2/patches/010-fix-pic-flags.patch << 'EOF'
# --- a/Makefile-libbz2_so
# +++ b/Makefile-libbz2_so
# @@ -22,7 +22,7 @@
 
#  SHELL=/bin/sh
#  CC=gcc
# -BIGFILES=-D_FILE_OFFSET_BITS=64
# +BIGFILES=-D_FILE_OFFSET_BITS=64 -fPIC
#  CFLAGS=-fpic -fPIC $(BIGFILES) $(CFLAGS)
 
#  OBJS= blocksort.o  \
# @@ -35,7 +35,7 @@
#        decompress.o \
#        bzlib.o
 
# -all: $(OBJS)
# +all: CFLAGS+=-fPIC -fpic $(OBJS)
#  	$(CC) -shared -Wl,-soname -Wl,libbz2.so.1.0 -o libbz2.so.1.0.8 $(OBJS)
#  	$(CC) $(CFLAGS) -o bzip2-shared bzip2.c libbz2.so.1.0.8
#  	rm -f libbz2.so.1.0
# EOF

# chmod 644 package/utils/bzip2/patches/010-fix-pic-flags.patch



# mkdir -p feeds/packages/net/miniupnpd/patches

# # 创建补丁文件，直接修改miniupnpd源码的Makefile
# cat > feeds/packages/net/miniupnpd/patches/010-fix-mips-pic-flags.patch << 'EOF'
# --- a/Makefile
# +++ b/Makefile
# @@ -27,7 +27,7 @@
 
#  CFLAGS ?= -O -Wall -Wextra -Wstrict-prototypes -Wdeclaration-after-statement \
#            -Wno-unused-parameter -Wno-missing-field-initializers \
# -          -D_GNU_SOURCE -fno-strict-aliasing -fno-common \
# +          -D_GNU_SOURCE -fno-strict-aliasing -fno-common -fPIC \
#            -DMINIUPNPD_VERSION=\"$(VERSION)\"
 
#  #CFLAGS := $(CFLAGS) -ansi
# @@ -35,6 +35,9 @@
#  CFLAGS := $(CFLAGS) -D_BSD_SOURCE -D_DEFAULT_SOURCE
#  CFLAGS := $(CFLAGS) -Wno-array-parameter
 
# +# Ensure PIC flags are used for MIPS architecture
# +LDFLAGS += -fPIC
# +
#  # OpenWrt package
#  ifdef OPENWRT_BUILD
#  LDFLAGS += -luuid
# EOF

# # 设置补丁文件权限
# chmod 644 feeds/packages/net/miniupnpd/patches/010-fix-mips-pic-flags.patch

# # 另外，创建一个补丁确保OpenWRT传递的FPIC标志被正确使用
# cat > feeds/packages/net/miniupnpd/patches/020-ensure-fpic-flags.patch << 'EOF'
# --- a/Makefile
# +++ b/Makefile
# @@ -40,6 +40,9 @@
 
#  # OpenWrt package
#  ifdef OPENWRT_BUILD
# +# Ensure OpenWRT FPIC flags are used
# +CFLAGS += $(TARGET_CFLAGS)
# +LDFLAGS += $(TARGET_LDFLAGS)
#  LDFLAGS += -luuid
#  endif
 
# EOF

# # 设置补丁文件权限
# chmod 644 feeds/packages/net/miniupnpd/patches/020-ensure-fpic-flags.patch


# # openssl -> quictls
# rm -rf package/libs/openssl
# git clone https://github.com/sbwml/package_libs_openssl package/libs/openssl

# openssl hwrng
sed -i "/-openwrt/iOPENSSL_OPTIONS += enable-ktls '-DDEVRANDOM=\"\\\\\"/dev/urandom\\\\\"\"\'\n" package/libs/openssl/Makefile

# openssl -Ofast
sed -i "s/-O3/-Ofast/g" package/libs/openssl/Makefile

# # openssl: make compatible with v1.1 pkg 
# sed -i '/libcrypto.so/a\	$(LN) libcrypto.so.3 $(1)/usr/lib/libcrypto.so.1.1' package/libs/openssl/Makefile
# sed -i '/libssl.so/a\	$(LN) libssl.so.3 $(1)/usr/lib/libssl.so.1.1' package/libs/openssl/Makefile

# nghttp3
rm -rf feeds/packages/libs/nghttp3
git clone https://github.com/sbwml/package_libs_nghttp3 package/libs/nghttp3

# ngtcp2
rm -rf feeds/packages/libs/ngtcp2
git clone https://github.com/sbwml/package_libs_ngtcp2 package/libs/ngtcp2

# curl - http3/quic
rm -rf feeds/packages/net/curl
git clone https://github.com/sbwml/feeds_packages_net_curl feeds/packages/net/curl

# BBRv3 - linux-6.6
pushd target/linux/generic/backport-6.6
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0001-net-tcp_bbr-broaden-app-limited-rate-sample-detectio.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0002-net-tcp_bbr-v2-shrink-delivered_mstamp-first_tx_msta.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0003-net-tcp_bbr-v2-snapshot-packets-in-flight-at-transmi.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0004-net-tcp_bbr-v2-count-packets-lost-over-TCP-rate-samp.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0005-net-tcp_bbr-v2-export-FLAG_ECE-in-rate_sample.is_ece.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0006-net-tcp_bbr-v2-introduce-ca_ops-skb_marked_lost-CC-m.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0007-net-tcp_bbr-v2-adjust-skb-tx.in_flight-upon-merge-in.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0008-net-tcp_bbr-v2-adjust-skb-tx.in_flight-upon-split-in.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0009-net-tcp-add-new-ca-opts-flag-TCP_CONG_WANTS_CE_EVENT.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0010-net-tcp-re-generalize-TSO-sizing-in-TCP-CC-module-AP.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0011-net-tcp-add-fast_ack_mode-1-skip-rwin-check-in-tcp_f.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0012-net-tcp_bbr-v2-record-app-limited-status-of-TLP-repa.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0013-net-tcp_bbr-v2-inform-CC-module-of-losses-repaired-b.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0014-net-tcp_bbr-v2-introduce-is_acking_tlp_retrans_seq-i.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0015-tcp-introduce-per-route-feature-RTAX_FEATURE_ECN_LOW.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0016-net-tcp_bbr-v3-update-TCP-bbr-congestion-control-mod.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0017-net-tcp_bbr-v3-ensure-ECN-enabled-BBR-flows-set-ECT-.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0018-tcp-export-TCPI_OPT_ECN_LOW-in-tcp_info-tcpi_options.patch
popd