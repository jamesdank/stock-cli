# stock-cli
A clean and simple Bash-powered stock lookup tool that fetches stock data from Yahoo Finance using Python and `yfinance`.  Use it to quickly check stock prices from the terminal, view multiple tickers at once, export results as CSV, or run it interactively.
---

## ✨ Features

- 📊 Look up one or more stock tickers
- 💬 Interactive mode when no ticker is provided
- 📁 CSV export for spreadsheets or scripts
- 🟢 Color-coded gains
- 🔴 Color-coded losses
- 💵 Displays current price
- 📈 Displays daily change and percentage change
- 📉 Displays day high and day low
- 🔊 Displays trading volume
- ✅ Built-in dependency checks
- 🧾 Built-in help menu

---

## 🖥️ Preview

```bash
./stock.sh AAPL MSFT GOOGL
```

Example output:

```text
Apple Inc. (AAPL)
  Price:     USD 192.35
  Change:    +1.20 (+0.63%)
  Day Range: USD 190.25 - USD 193.10
  Volume:    45,678,900

Microsoft Corporation (MSFT)
  Price:     USD 420.15
  Change:    -2.45 (-0.58%)
  Day Range: USD 418.75 - USD 424.00
  Volume:    23,456,789
```

---

## 📦 Requirements

This script requires:

- Bash
- Python 3
- Python package: `yfinance`

---

## 🔧 Install Dependencies

Install `yfinance` with:

```bash
pip3 install yfinance
```

Or:

```bash
python3 -m pip install yfinance
```

---

## 🚀 Installation

Clone the repository:

```bash
git clone https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git
cd YOUR-REPO-NAME
```

Make the script executable:

```bash
chmod +x stock.sh
```

Run it:

```bash
./stock.sh AAPL
```

---

## 🌍 Optional: Install Globally

To run the script from anywhere, move it into your local bin directory:

```bash
mkdir -p ~/.local/bin
cp stock.sh ~/.local/bin/stock
chmod +x ~/.local/bin/stock
```

Now you can run:

```bash
stock AAPL
```

Or:

```bash
stock AAPL MSFT GOOGL
```

---

## 🧪 Usage

```bash
./stock.sh [OPTIONS] [TICKER1 TICKER2 ...]
```

---

## ⚙️ Options

| Option | Description |
|---|---|
| `-c`, `--csv` | Output results in CSV format |
| `-h`, `--help` | Show the help menu |

---

## 📌 Examples

### Single ticker

```bash
./stock.sh AAPL
```

### Multiple tickers

```bash
./stock.sh AAPL MSFT GOOGL
```

### CSV output

```bash
./stock.sh --csv AAPL MSFT
```

### Save CSV output to a file

```bash
./stock.sh --csv AAPL MSFT GOOGL > stocks.csv
```

### Interactive mode

Run the script without arguments:

```bash
./stock.sh
```

You will be prompted to enter ticker symbols:

```text
Stock Ticker Lookup
Enter ticker symbols separated by spaces (e.g., AAPL MSFT GOOGL):
> AAPL MSFT GOOGL
```

### Help menu

```bash
./stock.sh --help
```

---

## 📁 CSV Output Example

```csv
Ticker,Price,Change,ChangePercent,DayHigh,DayLow,Volume
AAPL,192.35,1.20,0.63,193.10,190.25,45678900
MSFT,420.15,-2.45,-0.58,424.00,418.75,23456789
```

CSV mode is useful for:

- Spreadsheets
- Reports
- Logging
- Automation
- Shell scripts

---

## 🧠 How It Works

The script uses Bash for:

- Command-line argument parsing
- Interactive prompts
- CSV mode handling
- Terminal colors
- Dependency checks

It uses Python with `yfinance` to fetch:

- Last price
- Previous close
- Daily change
- Daily percentage change
- Day high
- Day low
- Volume
- Currency
- Company name

---

## 🛡️ Error Handling

The script checks for required dependencies before running.

If Python 3 is missing:

```text
Error: 'python3' is required but not installed.
```

If `yfinance` is missing:

```text
Error: Python 'yfinance' package is required.
Install it with: pip3 install yfinance
```

If a ticker cannot be found, the script will skip it and display an error message.

---

## 📝 Notes

Stock data is provided through the `yfinance` Python package, which retrieves market data from Yahoo Finance.

This tool is intended for quick terminal lookups and personal use.

It is not financial advice.

---

## 📄 License

MIT License

You are free to use, modify, and share this project.
