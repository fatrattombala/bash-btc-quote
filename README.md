# bash-btc-quote
A simple bash script for displaying cryptocurrency prices in the unix shell bash. 
Uses the CoinGecko API. The version in the second branch is a pre-version to this
one, uses the Kraken-API and displays only BTC and ETH vs. USD and EUR - but it
is somehow faster.

# description
This simple Linux shell script uses the "jq" command line JSON data processor;
pls. install "jq" first (command line/bash: sudo apt install jq) then save the
script with an editor as i.e. "btc.sh" under a path for executables, (i.e.
~/.local/bin/) and make it executable ("sudo chmod +x btc"). Alternatively, you
can start it with "bash btc". The script uses market data from the coingecko
api ("powered by coingecko"). For a list of supported coins check
https://www.coingecko.com/. The skript shows all coins and cross-currencies
the api provides, even some coins as cross-currencies themselves - i.e. BTC
expressed in ETH or in Gold (XAU). For a short help-text, start the script with
the "--h" option. Enjoy!

