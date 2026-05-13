#!/usr/bin/env bash

CURRENT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
STOCK_SCRIPT="$CURRENT_DIR/stock.sh"
STATUS_SEGMENT="#($STOCK_SCRIPT)"
AUTO_STATUS_RIGHT=$(tmux show-option -gqv @tmux-stock-auto-status-right 2>/dev/null || true)

if [ "$AUTO_STATUS_RIGHT" = "off" ]; then
    exit 0
fi

STATUS_RIGHT=$(tmux show-option -gqv status-right 2>/dev/null || true)

if [[ "$STATUS_RIGHT" != *"$STATUS_SEGMENT"* ]]; then
    tmux set-option -g status-right "$STATUS_SEGMENT  $STATUS_RIGHT"
fi
