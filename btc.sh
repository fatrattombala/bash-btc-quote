#!/bin/bash
#This simple Linux shell script uses the "jq" command line JSON data processor;
#pls. install "jq" first (command line/bash: sudo apt install jq) then save the
#script with an editor as i.e. "btc.sh" under a path for executables, (i.e.
#~/.local/bin/) and make it executable ("sudo chmod +x btc"). Alternatively, you
#can start it with "bash btc". The script uses market data from the coingecko
#api ("powered by coingecko"). For a list of supported coins check
#https://www.coingecko.com/. The skript shows all coins and cross-currencies
#the api provides, even some coins as cross-currencies themselves - i.e. BTC
#expressed in ETH or in Gold (XAU). For a short help-text, start the script with
#the "--h" option. Enjoy!

# default coins and currencies
DEF_CUR1="\"usd\""
DEF_CUR2="\"eur\""
DEF_COIN1="\"btc\""
DEF_COIN2="\"eth\""

COIN_ARR=(${DEF_COIN1} ${DEF_COIN2})
CURR_ARR=(${DEF_CUR1} ${DEF_CUR2})

DIGITS=0
ONELINE=0

# load supported coins and currencies from coingecko
COINS=$(curl -s "https://api.coingecko.com/api/v3/coins/list")
SUPVSCUR=$(curl -s "https://api.coingecko.com/api/v3/simple/supported_vs_currencies")

# put skript-arguments into an array
while [ "$1" != "" ]
    do
        ARGS+=("$1") && shift
    done

# help text
HELP="Usage: btc [-d] [-1] [--h] [--c] [-coin_ticker_1 -coin_ticker_2 -coin_ticker_3...] [+currency_ticker_1 +currency_ticker_2 +currency_ticker_3...]
Example: $ bash btc.sh -d -XMR -XRP +NZD +xau
Tickers don't have to be in capital letters.
Arguments:
-d      show prices with decimal places
-1      new line for each crypto
-h, --h this help text
--c     display list with supported 'versus currencies'"

# function for displaying list with versus currencies
displayvscur() {
    VSCUR=$(curl -s "https://api.coingecko.com/api/v3/exchange_rates")
    UN_ARR=($(echo "$VSCUR" | jq -r ".rates | keys_unsorted[]"))
    mapfile -t NM_ARR < <(echo "$VSCUR" | jq -r ".[][].name")
    # https://www.computerhope.com/unix/bash/mapfile.htm
    coun=0
    for i in "${UN_ARR[@]}"; do
        echo -n "$(echo ${i} | tr a-z A-Z)..."
        echo -n "${NM_ARR[coun]}"
        echo
        coun=$((coun+1))
    done
    }        

# handle arguments: one array for the coins, another for the currencies
for ARG in "${ARGS[@]}"
    do
       ARG=$(echo $ARG | tr A-Z a-z)
       if [ "$ARG" == "-btc" ] || [ "$ARG" == "-eth" ] \
          || [ "$ARG" == "+usd" ] || [ "$ARG" == "+eur" ]; then continue
       elif [ "$ARG" == "-h" ] || [ "$ARG" == "-help" ] \
          || [ "$ARG" == "--help" ]; then
           echo "$HELP"; exit
       elif [ "$ARG" == "-d" ]; then
           DIGITS=1
       elif [ "$ARG" == "-1" ]; then
           ONELINE=1
       elif [ "$ARG" == "--c" ]; then
           displayvscur
           exit
       elif [ "${ARG:0:1}" == "-" ]; then
       COIN_ARR+=($(echo "$COINS" | jq ".[]|select(.symbol==\"${ARG:1}\")|.symbol"))
       elif [ "${ARG:0:1}" == "+" ]; then
       CURR_ARR+=($(echo "$SUPVSCUR" | jq ".[]|select(.==\"${ARG:1}\")"))
    fi
    done

# get the IDs of the coins in an own array, the symbols won't work with the api 
for i in ${COIN_ARR[@]}; do
    COIN_ID_ARR+=($(echo $COINS | jq ".[]|select(.symbol==$i)|.id"))
    done 

# convert the arrays in strings
COIN_STRING=$(echo ${COIN_ID_ARR[@]} | tr -d "\"" | tr " " ",")
CURR_STRING=$(echo ${CURR_ARR[@]} | tr -d "\"" | tr " " ",")

# do the api-query with the coin-IDs and the currencies
JQUERY=$(curl -s "https://api.coingecko.com/api/v3/simple/price?ids=${COIN_STRING},&vs_currencies=${CURR_STRING}")

# colors
F1=`tput setaf 1` # red
F2=`tput setaf 2` # green
F3=`tput setaf 3` # yellow
F4=`tput setaf 4` # blue
F5=`tput setaf 5` # magenta
F6=`tput setaf 6` # cyan
F7=`tput setaf 7` # white
FG=($F1 $F2 $F3 $F4 $F5 $F6 $F7)
B1=`tput setab 1`
B2=`tput setab 2`
B3=`tput setab 3`
B4=`tput setab 4`
B5=`tput setab 5`
B6=`tput setab 6`
B7=`tput setab 7`
BG=($B4 $B5 $B6 $B7 $B1 $B2 $B3)
# BG=($B5 $B6 $B7 $B1 $B2 $B3 $B4)
# BG=($B6 $B7 $B1 $B2 $B3 $B4 $B5)
BLD=`tput bold`
RSET=`tput sgr0`

# output
co=0
for COIN in ${COIN_ID_ARR[@]}; do
    echo -n ${FG[$co]}${BG[$co]}${BLD} 
    echo -n " ${COIN:1:-1}: "
    for CURR in ${CURR_ARR[@]}; do
            JQD=$(echo ${JQUERY} | jq .${COIN}.${CURR})
            NQD=$(echo ${CURR:1:-1} | tr a-z A-Z)
            case "$NQD" in
                "EUR") NQD="€"
                    ;;
                "USD") NQD="$"
                    ;;
                "GBP") NQD="£"
                    ;;
            esac
        if [ $DIGITS == "1" ]; then
        echo -n "${NQD} ${JQD} "
        else
        echo -n "${NQD} $(echo ${JQD} | sed 's/\.[0-9]\+//') "
    fi
    done
    echo -n ${RSET}
    echo -n "   "
    if [ $ONELINE == "1" ]; then
        echo
    fi
    co=$((co+1))
    if [ $co == 6 ]; then co=0; fi
done
echo
exit


