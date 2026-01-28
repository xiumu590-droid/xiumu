#!/system/bin/sh

LOG="/sdcard/黑名单日志.log"
MAX_SIZE=51200

# ===== 新增：后台心跳循环（1分钟/次） =====
(
while true; do
    am broadcast -a com.google.android.intent.action.GTALK_HEARTBEAT
    am broadcast -a com.google.android.intent.action.MCS_HEARTBEAT
    sleep 300
done
) &

# ===== 原脚本保持不变（2700秒周期） =====
while true; do
    # 1. 生成本轮内容（先放内存变量）
    CONTENTS="# $(date '+%F %T')\n"
    CONTENTS="$CONTENTS$(pm list packages -3 | sed 's/^package://' | sed 's/^/dumpsys deviceidle whitelist -/')\n"

    # 2. 判断旧文件大小
    if [ -f "$LOG" ]; then
        CUR_SIZE=$(stat -c%s "$LOG" 2>/dev/null || busybox stat -c%s "$LOG" 2>/dev/null || ls -l "$LOG" | awk '{print $5}')
        [ "$CUR_SIZE" -gt "$MAX_SIZE" ] && rm -f "$LOG"
    fi

    # 3. 写入本轮内容（追加模式，文件不存在会自动创建）
    printf "$CONTENTS" >> "$LOG"

    # 4. 可选：立即执行
    sh "$LOG"

    sleep 2700
done
