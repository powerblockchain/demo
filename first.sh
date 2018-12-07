#!/bin/bash
apiserver=$(cat ./apiserver.txt)
address=$(cat ./address.txt)
text=$(curl $apiserver/api/v1/asset/balance/$address/TTT)
errMsg=$(echo $text | jq .errMsg)
if [ $errMsg = '"success"' ];then
  stable=$(echo $text | jq .data.stable)
  pending=$(echo $text | jq .data.pending)
  let balance=$stable+$pending
  echo $balance > balance.txt
else
  echo "error"
fi
