#!/bin/bash
me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
whois=`cat ./whois`
telegramapi="334808005:AAFG5Bw4swD1ZPTPkQ80TRGjkFDiXwVoGvk"
telegramchat="124071029"
router="http://$whois.herokuapp.com/"
bot=$me
date=`date '+%Y-%m-%d%H:%M:%S'`
git="http://104.128.85.102/$me?get=$date"


########################################################################
# Author: RizaMasykur
# MAIN FUNCTION
########################################################################
function mainbot {

  echo "bot running"
  echo "bot kopet"
  echo 'munyuk kejepit'

}

########################################################################
# Author: RizaMasykur
# CORE
########################################################################
while true; do
  echo 'Init bot    : '$whois - $me

  switch=`curl -sSXGET $router?get=$bot`
  power=`echo $switch | ./bin/jq --raw-output .data.power`
  type=`echo $switch | ./bin/jq --raw-output .data.type`

  ####
  #default bot is off
  ####
  if [ "$power" == null ]
    then
    power="mati"
  fi
  if [ "$type" == null ]
    then
    type="running"
  fi

  ####
  #trigger
  ####

  #powering-off
  if [ "$power" == "off" ]
    then
    curl -sS -X POST "$router?set=" -H 'content-type: application/json' -d '{"key":"'$bot'","value": {"power":"poweroff","type":"running"}}' > /dev/null
    curl -XGET 'https://api.telegram.org/bot'$telegramapi'/sendMessage?text=shutdown%20bot%20-%20'$me'%20/%20http://'$whois'.herokuapp.com&chat_id='$telegramchat > /dev/null
  fi

  #powering-on
  if [ "$power" == "on" ]
    then
    curl -sS -X POST "$router?set=" -H 'content-type: application/json' -d '{"key":"'$bot'","value": {"power":"wakeup","type":"running"}}' > /dev/null
    curl -XGET 'https://api.telegram.org/bot'$telegramapi'/sendMessage?text=wake%20up%20bot%20-%20'$me'%20/%20http://'$whois'.herokuapp.com&chat_id='$telegramchat > /dev/null
  fi

  #upgrading process
  if [ "$type" == "update" ]
    then
    curl -sS -X POST "$router?set=" -H 'content-type: application/json' -d '{"key":"'$bot'","value": {"power":"'$power'","type":"updating"}}' > /dev/null
    curl -XGET 'https://api.telegram.org/bot'$telegramapi'/sendMessage?text=update%20bot%20-%20'$me'%20/%20http://'$whois'.herokuapp.com&chat_id='$telegramchat > /dev/null

    echo "======================"
    echo "merlin upgrading"
    echo "======================"

    echo "update status"
    rm -rf bash-app/$me > /dev/null
    echo "remove old file"
    wget -q -O /tmp/$me $git > /dev/null
    echo "downloading new file"
    cp -r /tmp/$me bash-app/$me > /dev/null
    echo "replace with new"
    touch /tmp/$me
    if [ ! -f /tmp/$me ]; then
      echo ""
    else
      rm -rf /tmp/$me > /dev/null
    fi
    echo "clearing cache"
    echo "======================"
    echo "merlin reboot"
    echo "======================"
    exit
  else
    echo ""
  fi


  #bot is on
  if [ "$power" == "wakeup" ]
    then

      #main bot is here
      mainbot
      echo ""

  else
    echo "power off"
    exit;
  fi

  echo $power - $type;
  #cek turahan attachment sek
  echo "====================="
  sleep 2

done

########################################################################
# CORE END
########################################################################
