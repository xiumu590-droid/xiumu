#!/system/bin/sh

# ==========================================
# 配置区域
# ==========================================
LOG_MAIN="/sdcard/应用白名单移除.log"
LOG_FCM="/sdcard/fcm广播.log"
MAX_SIZE_KB=50
MAX_SIZE=$((MAX_SIZE_KB * 1024))

PKG_QQ="com.tencent.mobileqq"

# ==========================================
# 新增：应用名称查询函数（混合模式）
# ==========================================
get_app_name() {
    local pkg="$1"
    case "$pkg" in
        "com.tencent.mm") echo "微信" ;;
        "com.tencent.mobileqq") echo "QQ" ;;
        "com.zhiliaoapp.musically") echo "TikTok" ;;
        "com.ss.android.ugc.aweme") echo "抖音" ;;
        "com.github.android") echo "GitHub" ;;
        "com.google.android.youtube") echo "YouTube" ;;
        "com.microsoft.office.outlook") echo "Outlook" ;;
        "com.android.vending") echo "Google Play" ;;
        "com.google.android.gms") echo "Google服务" ;;
        "com.google.android.gsf") echo "Google服务框架" ;;
        "com.roblox.client") echo "Roblox" ;;
        "nu.gpu.nagram") echo "Nagram" ;;
        "com.okinc.okex.gp") echo "欧易OKX" ;;
        "com.alibaba.aliyun") echo "阿里云" ;;
        "com.axlebolt.standoff2") echo "对峙2" ;;
        "com.whatsapp") echo "WhatsApp" ;;
        "com.facebook.katana") echo "Facebook" ;;
        "com.instagram.android") echo "Instagram" ;;
        "com.twitter.android") echo "Twitter" ;;
        "org.telegram.messenger"|"telegram") echo "Telegram" ;;
        "com.discord") echo "Discord" ;;
        "com.spotify.music") echo "Spotify" ;;
        "com.valvesoftware.android.steam.community") echo "Steam" ;;
        "com.rezvorck.tiktokplugin") echo "TikTok插件" ;;
        *) 
            # 未知应用：提取最后一段并首字母大写
            local short=$(echo "$pkg" | sed 's/.*\.//')
            echo "$short"
            ;;
    esac
}

# ==========================================
# 工具函数
# ==========================================
check_and_clean_log() {
    local log_file="$1"
    if [ -f "$log_file" ]; then
        local cur_size
        cur_size=$(stat -c%s "$log_file" 2>/dev/null || busybox stat -c%s "$log_file" 2>/dev/null || ls -l "$log_file" | awk '{print $5}')
        
        if [ "$cur_size" -gt "$MAX_SIZE" ]; then
            rm -f "$log_file"
            echo "# [$(date '+%F %T')] 日志超过 ${MAX_SIZE_KB}KB，已自动清理" >> "$log_file"
            echo "" >> "$log_file"
        fi
    fi
}

get_fcm_packages() {
    for pkg in $(pm list packages -3 | cut -d: -f2 | grep -v "^com.tencent.mobileqq\$"); do 
        if dumpsys package "$pkg" 2>/dev/null | grep -q "com.google.android.c2dm.permission.RECEIVE"; then 
            echo "$pkg"
        fi
    done | sort -u
}

# ==========================================
# 修改：移除白名单函数（增加应用名参数）
# ==========================================
remove_whitelist() {
    local pkg_name="$1"
    local app_name="$2"  # 新增：传入可读的应用名称
    
    echo "[${app_name}]: "  # 显示应用名
    echo "  包名: ${pkg_name}"  # 第二行显示包名（便于精确识别）
    
    dumpsys deviceidle whitelist -"${pkg_name}" >/dev/null 2>&1
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        echo "  状态: ✓ 已移除白名单"
    else
        echo "  状态: ✗ 失败(码:$exit_code)"
    fi
    echo ""
}

# ==========================================
# FCM心跳循环（保持不变）
# ==========================================
fcm_loop() {
    sleep 2
    
    while true; do
        check_and_clean_log "$LOG_FCM"
        
        {
            echo "# $(date '+%F %T') - FCM心跳广播"
            
            echo ">>> [1/2] GTALK_HEARTBEAT"
            result1=$(am broadcast -a com.google.android.intent.action.GTALK_HEARTBEAT 2>&1)
            if [ $? -eq 0 ] && ! echo "$result1" | grep -qi "failure\|failed"; then
                echo "状态: 成功"
            else
                echo "状态: 失败 - $result1"
            fi
            
            echo ">>> [2/2] MCS_HEARTBEAT"
            result2=$(am broadcast -a com.google.android.intent.action.MCS_HEARTBEAT 2>&1)
            if [ $? -eq 0 ] && ! echo "$result2" | grep -qi "failure\|failed"; then
                echo "状态: 成功"
            else
                echo "状态: 失败 - $result2"
            fi
            
            echo "----------------------------------------"
            echo ""
        } >> "$LOG_FCM"
        
        sleep 300
    done
}

# ==========================================
# 主循环（修改：增加应用名显示）
# ==========================================
main_loop() {
    while true; do
        CURRENT_TIME=$(date '+%F %T')
        
        check_and_clean_log "$LOG_MAIN"
        
        {
            echo "# $CURRENT_TIME - 开始移除应用电池白名单"
            echo "---"
            
            echo "# 正在扫描支持FCM推送的应用（排除QQ）..."
            fcm_apps=$(get_fcm_packages)
            
            if [ -z "$fcm_apps" ]; then
                echo "未检测到FCM应用"
                echo ""
            else
                app_count=$(echo "$fcm_apps" | wc -l)
                echo "检测到 ${app_count} 个FCM应用"
                echo ""
                
                # 修改：遍历处理时查询应用名称
                echo "$fcm_apps" | while read pkg; do
                    app_name=$(get_app_name "$pkg")  # 查询应用名
                    remove_whitelist "$pkg" "$app_name"  # 同时传入包名和应用名
                done
            fi
            
            echo "---"
            
            # QQ 处理（使用函数获取名称，保持一致性）
            qq_name=$(get_app_name "$PKG_QQ")
            remove_whitelist "$PKG_QQ" "$qq_name"
            
            echo "---"
            echo "完成时间: $(date '+%F %T')"
            echo ""
        } >> "$LOG_MAIN"
        
        sleep 2700
    done
}

# ==========================================
# 初始化
# ==========================================
echo "[$(date '+%F %T')] 初始化：检查并清理历史日志..."

if [ -f "$LOG_MAIN" ]; then
    rm -f "$LOG_MAIN"
    echo "✓ 已删除旧日志: $LOG_MAIN"
fi

if [ -f "$LOG_FCM" ]; then
    rm -f "$LOG_FCM"
    echo "✓ 已删除旧日志: $LOG_FCM"
fi

echo "[$(date '+%F %T')] 初始化完成"
echo ""

# ==========================================
# 启动
# ==========================================
echo "[$(date '+%F %T')] 启动双循环守护进程..."

fcm_loop &
PID_FCM=$!
echo "FCM广播循环已启动 (PID: $PID_FCM) - 间隔: 300秒"

main_loop &
PID_MAIN=$!
echo "FCM应用白名单管理循环已启动 (PID: $PID_MAIN) - 间隔: 2700秒"

echo "脚本运行中，按 Ctrl+C 或执行 'kill $PID_FCM $PID_MAIN' 停止"
wait
