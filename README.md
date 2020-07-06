# bash-btc-quote
A simple bash script for displaying cryptocurrency prices in the unix shell bash. 
Uses the Kraken API. This was the first version of the skript; it is faster than
the CoinGecko-API-Version, but displays only BTC and ETH with much fewer options.

# description
This simple Linux shell script uses the "jq" command line JSON data processor
pls. install "jq" first (sudo apt install jq) then save the skript with an
editor as i.e. "btc" under a path for executables, (i.e. ~/.local/bin/) and
make it executable ("sudo chmod +x btc") the script uses market data from the
kraken api; pls. feel free to use any other api. The script displays the
current price of Bitcoin and Ether in USD and EUR. If you don't like the
colors, try playing around with the "tput setaf x" (color of characters) and
"tput setab x" (background color); you might find the information frome here:
https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
useful. Enjoy!
