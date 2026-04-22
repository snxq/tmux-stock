# tmux-stock

在 tmux 状态栏显示实时股票行情的脚本。

## 功能

- 支持 A 股（沪/深）、美股、港股
- 显示当前价格和涨跌幅
- 自动识别休市状态

## 使用方法

### 1. 编辑自选股列表

打开 `stock.sh`，修改 `STOCKS` 数组，格式为 `"代码:显示名"`：

```bash
STOCKS=(
    "sh000001:上证"       # 上证指数
    "sz399001:深成指"     # 深证成指
    "sh600519:茅台"       # A 股（上海）
    "sz000858:五粮液"     # A 股（深圳）
    "gb_aapl:苹果"        # 美股
    "gb_tsla:特斯拉"      # 美股
    "hk00700:腾讯"        # 港股
)
```

代码规则：
| 市场 | 前缀 | 示例 |
|------|------|------|
| 上海 A 股 | `sh` | `sh600519` |
| 深圳 A 股 | `sz` | `sz000858` |
| 美股 | `gb_` | `gb_aapl` |
| 港股 | `hk` | `hk00700` |

### 2. 配置 tmux 状态栏

在 `~/.tmux.conf` 中添加：

```bash
set -g status-interval 5
set -g status-right '#(~/src/snxq/tmux-stock/stock.sh)  %H:%M'
```

`status-interval` 控制刷新间隔（秒），建议 5-10 秒。

### 3. 生效配置

```bash
tmux source-file ~/.tmux.conf
```

## 依赖

- `curl`
- `iconv`（通常随系统自带）
- `awk`
