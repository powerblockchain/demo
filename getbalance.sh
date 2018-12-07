#!/bin/bash

#获得服务器api地址
apiserver=$(cat ./apiserver.txt)
#获得充电庄的钱包地址
address=$(cat ./address.txt)
#获得1 TTT与时间的对应规则（秒）
rule=$(cat ./rule.txt)
#获得pin针角
pin=$(cat ./pin.txt)
#获得多久执行一次(秒)
looptime=$(cat ./looptime.txt)
#获得上次余额
lastbalance=$(cat ./balance.txt)
#请求api获得该充电庄钱包地址的余额
text=$(curl $apiserver/api/v1/asset/balance/$address/TTT)
errMsg=$(echo $text | jq .errMsg)
if [ $errMsg = '"success"' ];then
  #获得正确的数据
  stable=$(echo $text | jq .data.stable)
  pending=$(echo $text | jq .data.pending)
  #稳定的和未稳定的加在一起是当前的充电庄钱包地址余额
  let balance=$stable+$pending
  #echo $balance
  #获得最新的支付
  let amount=$balance-$lastbalance
  #echo $lastbalance
  #echo $amount
  #如果最新支付的大于0，说明有支付
  if [ $amount -gt 0 ];then
    #计算每个TTT可以充电多久
    #计算 amount（notes） 是多少个TTT
    let TTT=$amount/1000000
    let powertime=$TTT*rule
    #对时间只取整数部分（秒）
    let intpowertime=$(echo $powertime| awk '{print int($0)}')
    echo $intpowertime
    #对GPIO pin针角执行高电平（充电）
    echo power on
    ./power.sh $pin 1
    #更新余额
    echo $balance > balance.txt
    #延时 powertime 秒，输出低电平（断电）。
    sleep $intpowertime
    echo power off
    ./power.sh $pin 0
    #继续执行，等待支付.
    ./getbalance.sh
  else
    #没有支付，不做任何处理。
    echo "no payment in"
    #延时 looptime
    sleep $looptime
    #继续执行，等待支付。
    ./getbalance.sh
  fi
else
  #出现错误（网络或其他原因）
  echo "error"
fi
