#!/usr/bin/env bash

set -euo pipefail

# --- Dependencies check ---
for cmd in python3; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: '$cmd' is required but not installed." >&2
        exit 1
    fi
done

python3 -c "import yfinance" 2>/dev/null || {
    echo "Error: Python 'yfinance' package is required." >&2
    echo "Install it with: pip3 install yfinance" >&2
    exit 1
}

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# --- Defaults ---
CSV_MODE=false
TICKERS=()

# --- Usage ---
usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] [TICKER1 TICKER2 ...]

Fetch stock information from Yahoo Finance.

Options:
  -c, --csv       Output results in CSV format
  -h, --help      Show this help message

Examples:
  $(basename "$0") AAPL
  $(basename "$0") AAPL MSFT GOOGL
  $(basename "$0") --csv AAPL MSFT
  $(basename "$0")              (interactive mode)
EOF
    exit 0
}

# --- Parse arguments ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        -c|--csv)
            CSV_MODE=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        -*)
            echo "Unknown option: $1" >&2
            usage
            ;;
        *)
            TICKERS+=("$1")
            shift
            ;;
    esac
done

# --- Interactive mode ---
if [[ ${#TICKERS[@]} -eq 0 ]]; then
    echo -e "${BOLD}${CYAN}Stock Ticker Lookup${NC}"
    echo -e "${YELLOW}Enter ticker symbols separated by spaces (e.g., AAPL MSFT GOOGL):${NC}"
    read -r -p "> " input
    if [[ -z "$input" ]]; then
        echo "No tickers provided. Exiting." >&2
        exit 1
    fi
    # shellcheck disable=SC2206
    TICKERS=($input)
fi

# --- Fetch data using Python/yfinance ---
fetch_all() {
    local tickers_csv
    tickers_csv=$(IFS=,; echo "${TICKERS[*]}")

    python3 - "$tickers_csv" "$CSV_MODE" <<'PYEOF'
import sys
import logging
import yfinance as yf

logging.getLogger("yfinance").setLevel(logging.CRITICAL)

tickers_str = sys.argv[1]
csv_mode = sys.argv[2].lower() == "true"
tickers = [t.strip().upper() for t in tickers_str.split(",") if t.strip()]

if csv_mode:
    print("Ticker,Price,Change,ChangePercent,DayHigh,DayLow,Volume")

for symbol in tickers:
    try:
        ticker = yf.Ticker(symbol)
        info = ticker.fast_info

        price = getattr(info, "last_price", None)
        prev_close = getattr(info, "previous_close", None)

        if price is None:
            print(f"Error: Ticker '{symbol}' not found.", file=sys.stderr)
            continue

        change = price - prev_close if prev_close else 0
        change_pct = (change / prev_close * 100) if prev_close else 0

        day_high = getattr(info, "day_high", None) or "N/A"
        day_low = getattr(info, "day_low", None) or "N/A"
        volume = getattr(info, "last_volume", None) or 0
        currency = getattr(info, "currency", "USD")

        def fmt(v):
            return f"{v:.2f}" if isinstance(v, (int, float)) and v == v else "N/A"

        if csv_mode:
            print(f"{symbol},{price:.2f},{change:.2f},{change_pct:.2f},{fmt(day_high)},{fmt(day_low)},{int(volume)}")
        else:
            short_name = ticker.info.get("shortName", symbol)

            if change > 0:
                color = "\033[0;32m"
                sign = "+"
            elif change < 0:
                color = "\033[0;31m"
                sign = ""
            else:
                color = "\033[0m"
                sign = ""

            pct_sign = "+" if change_pct > 0 else ""

            vol_str = f"{int(volume):,}"

            print(f"\033[1m\033[0;36m{short_name} ({symbol})\033[0m")
            print(f"  Price:     \033[1m{currency} {price:.2f}\033[0m")
            print(f"  Change:    {color}{sign}{change:.2f} ({pct_sign}{change_pct:.2f}%)\033[0m")
            print(f"  Day Range: {currency} {fmt(day_low)} - {currency} {fmt(day_high)}")
            print(f"  Volume:    {vol_str}")
            print()

    except Exception as e:
        print(f"Error: Failed to fetch data for {symbol}: {e}", file=sys.stderr)
PYEOF
}

# --- Run ---
fetch_all
