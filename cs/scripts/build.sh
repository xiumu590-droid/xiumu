#!/bin/bash

# 如果命令以非零状态退出，则立即退出
set -e

# 编译 AdGuard DNS 过滤器
hostlist-compiler -c configuration.json -o Filters/filter.txt --verbose

# 编译 AdGuard DNS 弹出主机过滤器
hostlist-compiler -c configuration_popup_filter.json -o Filters/adguard_popup_filter.txt --verbose
node scripts/popup_filter_build.js Filters/adguard_popup_filter.txt