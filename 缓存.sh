#!/system/bin/sh

# ==========================================
# 配置区域 - 可按需修改
# ==========================================
LOG_MAIN="/sdcard/黑名单日志.log"
LOG_FCM="/sdcard/fcm广播.log"
MAX_SIZE_KB=50                    # 日志最大大小（KB）
MAX_SIZE=$((MAX_SIZE_KB * 1024))  # 转换为bytes
TEMP_EXEC="临时文件sh"

# ==========================================
# 函数：检查并清理日志文件（超过指定大小则重置）
# ==========================================
check_and_clean_log() {
    local log_file="$1"
    if [ -f "$log_file" ]; then
        # 获取文件大小（兼容stat/busybox/ls）
        local cur_size
        cur_size=$(stat -c%s "$log_file" 2>/dev/null || busybox stat -c%s "$log_file" 2>/dev/null || ls -l "$log_file" | awk '{print $5}')
        
        if [ "$cur_size" -gt "$MAX_SIZE" ]; then
            rm -f "$log_file"
            echo "# [$(date '+%F %T')] 日志超过 ${MAX_SIZE_KB}KB，已自动清理并重建" >> "$log_file"
            echo "" >> "$log_file"
        fi
    fi
}

# ==========================================
# 后台任务：FCM心跳循环（300秒/次）
# ==========================================
(
while true; do
    # 检查并清理FCM日志
    check_and_clean_log "$LOG_FCM"
    
    # 追加写入FCM日志（带时间戳和执行输出）
    {
        echo "# $(date '+%F %T') - FCM心跳广播"
        echo ">>> 执行 GTALK_HEARTBEAT"
        am broadcast -a com.google.android.intent.action.GTALK_HEARTBEAT 2>&1
        echo ">>> 执行 MCS_HEARTBEAT"
        am broadcast -a com.google.android.intent.action.MCS_HEARTBEAT 2>&1
        echo "----------------------------------------"
        echo ""
    } >> "$LOG_FCM"
    
    sleep 300
done
) &

# ==========================================
# 主循环：原2700秒周期脚本（执行与日志分离）
# ==========================================
while true; do
    CURRENT_TIME=$(date '+%F %T')
    
    # ---- 步骤1: 生成执行脚本（> 覆盖写入，用于执行） ----
    {
        echo "#!/system/bin/sh"
        echo "# 生成时间: $CURRENT_TIME"
        pm list packages -3 | sed 's/^package:/dumpsys deviceidle whitelist -/'
    } > "$TEMP_EXEC"
    
    # ---- 步骤2: 追加到主日志（>> 追加写入，用于查看记录） ----
    {
        echo "# $CURRENT_TIME"
        pm list packages -3 | sed 's/^package:/dumpsys deviceidle whitelist -/'
        echo ""
    } >> "$LOG_MAIN"
    
    # ---- 步骤3: 检查主日志大小，超限清理 ----
    check_and_clean_log "$LOG_MAIN"
    
    # ---- 步骤4: 执行临时文件（执行与日志分离） ----
    sh "$TEMP_EXEC"
    
    sleep 2700
done
