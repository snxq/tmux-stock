#!/bin/bash
# tmux status bar stock ticker
# Format: "CODE:LABEL"  (CODE = sina finance code, LABEL = display name)

TMUX_SYMBOLS=$(tmux show-option -gqv @tmux-stock-symbols 2>/dev/null || true)

STOCKS=(
    "sh000001:上证"
    "sh600415:小废品城"
)

if [ -n "$TMUX_SYMBOLS" ]; then
    IFS=',' read -ra STOCKS <<< "$TMUX_SYMBOLS"
fi

codes=""
for entry in "${STOCKS[@]}"; do
    code="${entry%%:*}"
    codes="${codes}${code},"
done
codes="${codes%,}"

data=$(curl -s "https://hq.sinajs.cn/list=${codes}" \
    -H 'Referer: https://finance.sina.com.cn' 2>/dev/null \
    | iconv -f gbk -t utf-8 2>/dev/null)

result=""
for entry in "${STOCKS[@]}"; do
    code="${entry%%:*}"
    label="${entry##*:}"

    line=$(echo "$data" | grep "hq_str_${code}=")
    raw=$(echo "$line" | sed 's/.*="//' | sed 's/".*//')
    if [ -z "$raw" ]; then
        result="${result}${label}:N/A  "
        continue
    fi

    IFS=',' read -ra fields <<< "$raw"

    # gb_ prefix = US stocks: fields[1]=current, fields[2]=change_amount
    # hk prefix = HK stocks: fields[6]=current, fields[8]=change_percent
    # others (A-shares, index): fields[2]=prev_close, fields[3]=current
    if [[ "$code" == gb_* ]]; then
        current="${fields[1]}"
        change="${fields[2]}"
    elif [[ "$code" == hk* ]]; then
        current="${fields[6]}"
        change="${fields[8]}"
    else
        current="${fields[3]}"
        prev_close="${fields[2]}"
        if [ -n "$prev_close" ] && [ "$prev_close" != "0.000" ]; then
            change=$(awk "BEGIN {printf \"%.2f\", ($current - $prev_close) / $prev_close * 100}")
        else
            change="0.00"
        fi
    fi

    if [ -z "$current" ] || [ "$current" = "0.000" ] || [ "$current" = "0.00" ]; then
        result="${result}${label}:休市  "
        continue
    fi

    sign=""
    if awk "BEGIN {exit !($change > 0)}"; then
        sign="+"
    fi

    result="${result}${label} ${current} ${sign}${change}%  "
done

echo "$result" | sed 's/  $//'
