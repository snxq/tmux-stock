# tmux-stock

在 tmux 状态栏显示实时股票行情的 TPM 插件。

## 功能

- 支持 A 股（沪/深）、美股、港股
- 显示当前价格和涨跌幅
- 自动识别休市状态
- 支持 TPM 安装
- 支持通过 tmux option 配置自选股

## 使用 TPM 安装

确保已经安装 [TPM](https://github.com/tmux-plugins/tpm)，然后在 `~/.tmux.conf` 中添加：

```tmux
set -g @plugin 'snxq/tmux-stock'
```

重新加载 tmux 配置后，按 TPM 的安装快捷键 `prefix + I` 安装插件。

插件默认会自动把股票行情追加到 `status-right` 左侧。你也可以配置刷新间隔：

```tmux
set -g status-interval 5
```

## 配置自选股

推荐直接在 `~/.tmux.conf` 中配置：

```tmux
set -g @tmux-stock-symbols 'sh000001:上证,hk00700:腾讯,gb_aapl:苹果'
```

格式为 `代码:显示名`，多个股票用英文逗号分隔。

代码规则：
| 市场 | 前缀 | 示例 |
|------|------|------|
| 上海 A 股 | `sh` | `sh600519` |
| 深圳 A 股 | `sz` | `sz000858` |
| 美股 | `gb_` | `gb_aapl` |
| 港股 | `hk` | `hk00700` |

## 可选配置

关闭自动追加 `status-right`：

```tmux
set -g @tmux-stock-auto-status-right 'off'
```

关闭后可以手动配置：

```tmux
set -g status-right '#(~/.tmux/plugins/tmux-stock/stock.sh)  %H:%M'
```

## 依赖

- `curl`
- `iconv`（通常随系统自带）
- `awk`
