#!/bin/bash
#This simple Linux shell script uses the "jq" command line JSON data processor
#pls. install "jq" first (sudo apt install jq) then save the skript with an
#editor as i.e.  "btc" under a path for executables, (i.e. ~/.local/bin/) and
#make it executable ("sudo chmod +x btc") the script uses market data from the
#kraken api; pls. feel free to use any other api. The script displays the
#current price of Bitcoin and Ether in USD and EUR.  If you don't like the
#colors, try playing around with the "tput setaf x" (color of characters) and
#"tput setab x" (background color); you might find the information frome here:
#https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
#useful. Enjoy!

DEF_FIAT1=USD
DEF_FIAT2=EUR
DEF_CRYP1=XBT
DEF_CRYP2=ETH

FIAT1=$DEF_FIAT1
FIAT2=$DEF_FIAT2
CRYP1=$DEF_CRYP1
CRYP2=$DEF_CRYP2

case $1 in
    -h|-help|--help) echo "Usage: btc [fiat] [altcoin]; cases for fiat can be  [eur|EUR|€|gbp|GBP|£|cad|CAD]"
        exit
        ;;
    gbp|GBP|£|-gbp|-GBP|-£) FIAT2=GBP
        ;;
    cad|CAD|-cad|-CAD) FIAT2=CAD
        ;;
    XRP|BCH|LTC|EOS|ADA|XTZ|XLM|LINK|XMR|TRX|ETC|DASH|ATOM|ZEC|BAT|XDG|USDC|USDT) CRYP2=$1
        ;;
    "") : # dummy
        ;;
    *) echo "Unknown parameter! Using defaults" 
        ;;
esac

if [ $# = 2 ]
then
case $2 in
    XRP|BCH|LTC|EOS|ADA|XTZ|XLM|LINK|XMR|TRX|ETC|DASH|ATOM|ZEC|BAT|XDG|USDC|USDT) CRYP2=$2
        ;;
    *) echo "Unknown crypto ticker!"
        ;;
esac
fi

echo "Fiat1=$FIAT1 Fiat2=$FIAT2 Cryp1=$CRYP1 Cryp2=$CRYP2"

Q1=$(curl -s "https://api.kraken.com/0/public/Ticker?pair=${CRYP1}${FIAT1}" \
| jq ".result.X${CRYP1}Z${FIAT1}.c[0] | tonumber" | sed 's/\.[0-9]\+//')
Q2=$(curl -s "https://api.kraken.com/0/public/Ticker?pair=${CRYP1}${FIAT2}" \
| jq ".result.X${CRYP1}Z${FIAT2}.c[0] | tonumber" | sed 's/\.[0-9]\+//')
Q3=$(curl -s "https://api.kraken.com/0/public/Ticker?pair=${CRYP2}${FIAT1}" \
| jq ".result.X${CRYP2}Z${FIAT1}.c[0] | tonumber" | sed 's/\.[0-9]\+//')
Q4=$(curl -s "https://api.kraken.com/0/public/Ticker?pair=${CRYP2}${FIAT2}" \
| jq ".result.X${CRYP2}Z${FIAT2}.c[0] | tonumber" | sed 's/\.[0-9]\+//')

# colors
RED=`tput setaf 1`
GREEN=`tput setaf 2`
WHITEBACK=`tput setab 7`
CYANBACK=`tput setab 6`
BOLD=`tput bold`
RESET=`tput sgr0`

# output
case "$FIAT1" in
    "EUR") FIAT1="€"
        ;;
    "USD") FIAT1="$"
        ;;
    "GBP") FIAT1="£"
        ;;
esac

case "$FIAT2" in
    "EUR") FIAT2="€"
        ;;
    "USD") FIAT2="$"
        ;;
    "GBP") FIAT2="£"
        ;;
esac

echo "${WHITEBACK}${BOLD}${RED}Bitcoin: ${FIAT1} ""$Q1""   ${FIAT2} ""$Q2${RESET}""    ${BOLD}${CYANBACK}${GREEN}${CRYP2}: ${FIAT1} ""$Q3""    ${FIAT2} ""$Q4${RESET}"

