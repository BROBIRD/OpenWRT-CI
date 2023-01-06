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
#downgrade openssl to 1.1.1q
curl -sL -m 30 --retry 2 https://github.com/coolsnowwolf/lede/raw/d12eff3e86736486a49c6342ea95628b7d9591f6/package/libs/openssl/Makefile -o package/libs/openssl/Makefile
curl -sL -m 30 --retry 2 https://github.com/coolsnowwolf/lede/raw/d12eff3e86736486a49c6342ea95628b7d9591f6/package/libs/openssl/patches/001-crypto-perlasm-ppc-xlate.pl-add-linux64v2-flavour.patch -o package/libs/openssl/patches/001-crypto-perlasm-ppc-xlate.pl-add-linux64v2-flavour.patch
curl -sL -m 30 --retry 2 https://github.com/coolsnowwolf/lede/raw/d12eff3e86736486a49c6342ea95628b7d9591f6/package/libs/openssl/patches/100-Configure-afalg-support.patch -o package/libs/openssl/patches/100-Configure-afalg-support.patch
curl -sL -m 30 --retry 2 https://github.com/coolsnowwolf/lede/raw/d12eff3e86736486a49c6342ea95628b7d9591f6/package/libs/openssl/patches/110-openwrt_targets.patch -o package/libs/openssl/patches/110-openwrt_targets.patch
curl -sL -m 30 --retry 2 https://github.com/coolsnowwolf/lede/raw/d12eff3e86736486a49c6342ea95628b7d9591f6/package/libs/openssl/patches/120-strip-cflags-from-binary.patch -o package/libs/openssl/patches/120-strip-cflags-from-binary.patch
curl -sL -m 30 --retry 2 https://github.com/coolsnowwolf/lede/raw/d12eff3e86736486a49c6342ea95628b7d9591f6/package/libs/openssl/patches/130-dont-build-tests-fuzz.patch -o package/libs/openssl/patches/130-dont-build-tests-fuzz.patch
curl -sL -m 30 --retry 2 https://github.com/coolsnowwolf/lede/raw/d12eff3e86736486a49c6342ea95628b7d9591f6/package/libs/openssl/patches/140-allow-prefer-chacha20.patch -o package/libs/openssl/patches/140-allow-prefer-chacha20.patch
curl -sL -m 30 --retry 2 https://github.com/coolsnowwolf/lede/raw/d12eff3e86736486a49c6342ea95628b7d9591f6/package/libs/openssl/patches/150-openssl.cnf-add-engines-conf.patch  -o package/libs/openssl/patches/150-openssl.cnf-add-engines-conf.patch 
curl -sL -m 30 --retry 2 https://github.com/coolsnowwolf/lede/raw/d12eff3e86736486a49c6342ea95628b7d9591f6/package/libs/openssl/patches/400-eng_devcrypto-save-ioctl-if-EVP_MD_.FLAG_ONESHOT.patch -o package/libs/openssl/patches/400-eng_devcrypto-save-ioctl-if-EVP_MD_.FLAG_ONESHOT.patch
curl -sL -m 30 --retry 2 https://github.com/coolsnowwolf/lede/raw/d12eff3e86736486a49c6342ea95628b7d9591f6/package/libs/openssl/patches/410-eng_devcrypto-add-configuration-options.patch -o package/libs/openssl/patches/410-eng_devcrypto-add-configuration-options.patch
curl -sL -m 30 --retry 2 https://github.com/coolsnowwolf/lede/raw/d12eff3e86736486a49c6342ea95628b7d9591f6/package/libs/openssl/patches/420-eng_devcrypto-add-command-to-dump-driver-info.patch -o package/libs/openssl/patches/420-eng_devcrypto-add-command-to-dump-driver-info.patch
curl -sL -m 30 --retry 2 https://github.com/coolsnowwolf/lede/raw/d12eff3e86736486a49c6342ea95628b7d9591f6/package/libs/openssl/patches/430-e_devcrypto-make-the-dev-crypto-engine-dynamic.patch -o package/libs/openssl/patches/430-e_devcrypto-make-the-dev-crypto-engine-dynamic.patch
curl -sL -m 30 --retry 2 https://github.com/coolsnowwolf/lede/raw/d12eff3e86736486a49c6342ea95628b7d9591f6/package/libs/openssl/patches/500-e_devcrypto-default-to-not-use-digests-in-engine.patch -o package/libs/openssl/patches/500-e_devcrypto-default-to-not-use-digests-in-engine.patch
curl -sL -m 30 --retry 2 https://github.com/coolsnowwolf/lede/raw/d12eff3e86736486a49c6342ea95628b7d9591f6/package/libs/openssl/patches/510-e_devcrypto-ignore-error-when-closing-session.patch -o package/libs/openssl/patches/510-e_devcrypto-ignore-error-when-closing-session.patch

#Backup OpenClash cofig
echo '/etc/openclash/' >> package/base-files/files/etc/sysupgrade.conf

# Update Luci theme argon  
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/extra/luci-theme-argon
# git clone https://github.com/jerrykuku/luci-app-argon-config.git package/extra/luci-app-argon-config