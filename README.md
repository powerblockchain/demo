### 区块链支付充电桩演示 

> 使用shell脚本（bash），配合TrustNote通用钱包，在树梅派下执行。不依靠任何编程语言。

### how to use 如何使用

1. first
第一次输入以下命令。

```
./first.sh
```

this command will get balance or address.txt to save a default balance.

2. checking new payment

之后，执行以下命令即可自动检测有无支付。

use a timer to exec this command
```
./getbalance.sh
```

### config 配置

address.txt

这里存放充电桩的钱包地址，每个充电桩都有一个唯一的钱包地址。

apiserver.txt

这里是API的地址，即充电桩调用api查询自己是否有新的支付到帐。

测试网使用 http://150.109.57.242:6002
正式网使用 http://150.109.50.199:6002

looptime.txt

这里写循环时间，单位为秒。

pin.txt

这里是配置树梅派的pin针脚，接继电器的pin口。

rule.txt

1 TTT 能充多少秒的电
