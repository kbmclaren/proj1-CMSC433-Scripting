#!/bin/bash
##
## Script to download Yahoo historical quotes using the new cookie authenticated site.
##
## Usage: get-yahoo-quotes SYMBOL
##
##
## Author: Brad Lucas brad@beaconhill.com
## Latest: https://github.com/bradlucas/get-yahoo-quotes
##
## Copyright (c) 2017 Brad Lucas - All Rights Reserved
##
##
## History
##
## 06-03-2017 : Created script
##
## ----------------------------------------------------------------------------------------------------

SYMBOL=$1
if [[ -z $SYMBOL ]]; then
  echo "Please enter a SYMBOL as the first parameter to this script"
  exit
fi

#get start/stop date
while [[ -z TEMP_START_DATE]]
do
  read -p "Please enter a starting date (mm/dd/yyyy) for download: "
  TEMP_START_DATE
done
read -p "Now enter a stopping date(mm/dd/yyyy) for download: "
TEMP_END_DATE


longMonthList = "01 03 05 07 08 10 12"
shortMonthList = "04 06 09 11"
lonelyMonth = "02"


if [[ -z TEMP_END_DATE ]]; 
then
  IFS='/' read -ra TEMP_ARRAY <<< "$TEMP_START_DATE"
  targetMonth="${TEMP_ARRAY[0]}"
  targetYear="${TEMP_ARRAY[2]}"

  for month in $longMonthList
  do 
    case $month in
    $targetMonth)
    TEMP_END_DATE="${targetMonth}/31/${targetYear}"
    ;;
    *)
    ;;
    esac
  done

  for month in $shortMonthList
  do 
    case $month in
    $targetMonth)
    TEMP_END_DATE="${targetMonth}/30/${targetYear}"
    ;;
    *)
    ;;
    esac
  done

  for month in $lonelyMonth
  do
    case $month in 
    $targetMonth)
    TEMP_END_DATE="${targetMonth}/29/${targetYear}"
    ;;
    *)
    ;;
    esac
  done
fi

#convert input
startToEpoch=$(date -d "${TEMP_START_DATE} 00:00:00" + "%s" )
stopToEpoch=$(date -d "${TEMP_END_DATE} 00:00:00" + "%s" )

#validate input
if  [[ $startToEpoch >= 0 && $startToEpoch <= $(date +%s)]]; 
then
  if [[ $stopToEpoch <= $(date +%s) && $stopToEpoch > $startToEpoch]]; 
  then
    #valid date range 
    echo "good date range"
  else exit $?
  fi
else exit $?
fi
 
#while [[ $startToEpoch < 0 || $startToEpoch > $(date +%s) || $stopToEpoch > $(date +%s) || $stopToEpoch <= $startToEpoch]]


echo "Downloading quotes for $SYMBOL beginning "

function log () {
  # To remove logging comment echo statement and uncoment the :
  echo $1
  # :
}

# Period values are 'Seconds since 1970-01-01 00:00:00 UTC'. Also known as Unix time or epoch time.
# Let's just assume we want it all and ask for a date range that starts at 1/1/1970.
# NOTE: This doesn't work for old synbols like IBM which has Yahoo has back to 1962
START_DATE=$startToEpoch
END_DATE=$stopToEpoch

# Store the cookie in a temp file
cookieJar=$(mktemp)

# Get the crumb value
function getCrumb () {
  # Sometimes the value has an octal character
  # echo will convert it
  # https://stackoverflow.com/a/28328480

  # curl the url then replace the } characters with line feeds. This takes the large json one line and turns it into about 3000 lines
  # grep for the CrumbStore line
  # then copy out the value
  # lastly, remove any quotes
  echo -en "$(curl -s --cookie-jar $cookieJar $1)" | tr "}" "\n" | grep CrumbStore | cut -d':' -f 3 | sed 's+"++g'
}

# TODO If crumb is blank then we probably don't have a valid symbol
URL="https://finance.yahoo.com/quote/$SYMBOL/?p=$SYMBOL"
log $URL
crumb=$(getCrumb $URL)
log $crumb
log "CRUMB: $crumb"
if [[ -z $crumb ]]; then
  echo "Error finding a valid crumb value"
  exit
fi


# Build url with SYMBOL, START_DATE, END_DATE
BASE_URL="https://query1.finance.yahoo.com/v7/finance/download/$SYMBOL?period1=$START_DATE&period2=$END_DATE&interval=1d&events=history"
log $BASE_URL

# Add the crumb value
URL="$BASE_URL&crumb=$crumb"
log "URL: $URL"

# Download to
curl -s --cookie $cookieJar  $URL > $SYMBOL.csv

echo "Data dowmloaded to $SYMBOL.csv"
