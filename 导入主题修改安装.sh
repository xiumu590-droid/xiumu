#!/usr/bin/env bash
set -euo pipefail

# MIUI 主题的基础路径(这里使用了零宽字符).
THEME_META_DIR="/storage/emulated/0/​Android/data/com.android.thememanager/files/MIUI/theme/.data/meta/theme"
# 是否生成 .bak 备份（1=启用，0=关闭，建议关闭，否则会出现修改完之后会多一个主题）
ENABLE_BACKUP=0

echo "欢迎使用MerakXingChen制作的脚本，QQ群656100875"

if [[ ! -d "$THEME_META_DIR" ]]; then
  echo "找不到主题元数据目录：$THEME_META_DIR" >&2
  echo "如果你在 Termux 里运行，请先执行：termux-setup-storage 并授予存储权限。" >&2
  exit 1
fi

extract_titles() {
  # 从单个元数据文件里提取所有 titles 块的 zh_CN/fallback 文本，并且输出：每行一个标题；若无法提取则不输出任何内容。
  local file="$1"

  awk '
    function count_char(str, ch,    n, i) {
      n = 0
      for (i = 1; i <= length(str); i++) {
        if (substr(str, i, 1) == ch) n++
      }
      return n
    }

    function extract_value(line, key,    pat, s) {
      pat = "\"" key "\"[[:space:]]*:[[:space:]]*\"[^\"]*\""
      if (match(line, pat)) {
        s = substr(line, RSTART, RLENGTH)
        sub(/^[^:]*:[[:space:]]*"/, "", s)
        sub(/"$/, "", s)
        return s
      }
      return ""
    }

    BEGIN {
      in_titles = 0
      brace = 0
      fallback = ""
      found_zh = 0
    }

    {
      if (!in_titles && $0 ~ /"titles"[[:space:]]*:[[:space:]]*{/) {
        in_titles = 1
        brace = 0
        fallback = ""
        found_zh = 0
      }

      if (in_titles) {
        if (!found_zh) {
          v = extract_value($0, "zh_CN")
          if (v != "") {
            print v
            found_zh = 1
          }
        }

        if (fallback == "") {
          v = extract_value($0, "fallback")
          if (v != "") fallback = v
        }

        brace += count_char($0, "{") - count_char($0, "}")
        if (brace <= 0) {
          if (!found_zh && fallback != "") print fallback
          in_titles = 0
        }
      }
    }
  ' "$file" 2>/dev/null
}

extract_title_fallback() {
  # 当 awk 无法解析时，尝试用 grep/sed 直接抓取首个 zh_CN/fallback。
  local file="$1"

  local hit
  hit=$(grep -a -m1 -oE '"zh_CN"[[:space:]]*:[[:space:]]*"[^"]*"' "$file" 2>/dev/null || true)
  if [[ -n "$hit" ]]; then
    sed -E 's/.*:[[:space:]]*"//; s/"$//' <<<"$hit"
    return 0
  fi

  hit=$(grep -a -m1 -oE '"fallback"[[:space:]]*:[[:space:]]*"[^"]*"' "$file" 2>/dev/null || true)
  if [[ -n "$hit" ]]; then
    sed -E 's/.*:[[:space:]]*"//; s/"$//' <<<"$hit"
    return 0
  fi

  return 1
}

mapfile -t meta_files < <(find "$THEME_META_DIR" -maxdepth 1 -type f -print)
if [[ ${#meta_files[@]} -eq 0 ]]; then
  echo "在目录下未找到任何元数据文件：$THEME_META_DIR" >&2
  exit 1
fi

declare -a titles
declare -a sources

for file in "${meta_files[@]}"; do
  extracted_any=false
  while IFS= read -r title; do
    [[ -z "$title" ]] && continue
    extracted_any=true
    titles+=("$title")
    sources+=("$file")
  done < <(extract_titles "$file")

  if [[ "$extracted_any" == false ]]; then
    if title=$(extract_title_fallback "$file"); then
      titles+=("$title")
      sources+=("$file")
    else
      titles+=("[未解析] $(basename "$file")")
      sources+=("$file")
    fi
  fi
done

echo "共找到 ${#titles[@]} 个主题："
for idx in "${!titles[@]}"; do
  printf "%2d) %s (%s)\n" "$((idx + 1))" "${titles[idx]}" "$(basename "${sources[idx]}")"
done

read -rp "请选择编号 1-${#titles[@]}: " choice

while true; do
  if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#titles[@]} )); then
    selected_index=$((choice - 1))
    break
  fi
  read -rp "无效编号，请重新输入 1-${#titles[@]}: " choice
done

echo "你选择了 \"${titles[selected_index]}\""
echo "对应文件：${sources[selected_index]}"

update_content_path() {
  local meta_file="$1"
  local meta_basename
  meta_basename=$(basename "$meta_file")
  local meta_stem
  meta_stem="${meta_basename%.*}"

  local content_file="/storage/emulated/0/Android/data/com.android.thememanager/files/MIUI/theme/.data/content/theme/${meta_stem}.mrc"
  local target_path="/system/../${content_file#/}"
  local legacy_content_file="/storage/emulated/0/Android/data/com.android.thememanager/files/MIUI/theme/.data/content/theme/${meta_stem}.mrm"
  local legacy_target_path="/system/../${legacy_content_file#/}"
  local content_dir
  content_dir=$(dirname "$content_file")

  local last_content_path
  last_content_path=$(
    sed -nE ':a;N;$!ba;s#((.|\n)*)"contentPath"[[:space:]]*:[[:space:]]*(null|"[^"]*")(.|\n)*#\3#p' \
      "$meta_file" 2>/dev/null || true
  )

  if [[ -z "$last_content_path" ]]; then
    echo "未找到 contentPath 字段，跳过。"
    return 0
  fi

  local desired_quoted="\"$target_path\""
  local legacy_quoted="\"$legacy_target_path\""

  if [[ "$last_content_path" == "$desired_quoted" ]]; then
    echo "最后一个 contentPath 已经是目标值，跳过。"
    return 0
  fi

  if [[ "$last_content_path" != "null" && "$last_content_path" != "$legacy_quoted" ]]; then
    echo "最后一个 contentPath 已存在且不是目标值，跳过。"
    return 0
  fi

  if [[ ! -d "$content_dir" ]]; then
    echo "警告：内容目录不存在：$content_dir" >&2
  elif [[ ! -x "$content_dir" ]]; then
    echo "警告：无权限访问内容目录：$content_dir" >&2
  elif [[ ! -e "$content_file" ]]; then
    echo "警告：内容文件不存在：$content_file" >&2
  elif [[ ! -f "$content_file" ]]; then
    echo "警告：内容路径不是普通文件：$content_file" >&2
  fi

  local tmp_file
  tmp_file=$(mktemp "${meta_file}.tmp.XXXXXX") || {
    echo "修改失败：无法创建临时文件。" >&2
    return 1
  }

  if ! sed -E ':a;N;$!ba;s#((.|\n)*)"contentPath"[[:space:]]*:[[:space:]]*(null|"[^"]*")#\1"contentPath": "'"$target_path"'"#' \
    "$meta_file" >"$tmp_file"; then
    rm -f "$tmp_file"
    echo "修改失败：无法处理文件内容。" >&2
    return 1
  fi

  if cmp -s "$meta_file" "$tmp_file"; then
    rm -f "$tmp_file"
    echo "未做修改。"
    return 0
  fi

  if [[ "$ENABLE_BACKUP" == "1" ]]; then
    local backup_file="${meta_file}.bak"
    if ! cp -p "$meta_file" "$backup_file" 2>/dev/null; then
      echo "警告：备份失败（仍将继续写入修改）：$backup_file" >&2
    fi
  fi

  if cat "$tmp_file" >"$meta_file"; then
    rm -f "$tmp_file"
    echo "已更新最后一个 contentPath：$target_path"
    return 0
  fi

  rm -f "$tmp_file"
  echo "修改失败：无法写入文件：$meta_file" >&2
  return 1
}

update_content_path "${sources[selected_index]}"
