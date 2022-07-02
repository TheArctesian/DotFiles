#!/bin/bash

#################################
## Begin of user-editable part ##
#################################

POOL=asia2.ethermine.org:4444 
WALLET=0x206BcCF64aB61A0Bd90F97732625815aDe3AbD33.newWorker

#################################
##  End of user-editable part  ##
#################################

cd "$(dirname "$0")"

./lolMiner --algo ETHASH --pool $POOL --user $WALLET $@
while [ $? -eq 42 ]; do
    sleep 10s
    ./lolMiner --algo ETHASH --pool $POOL --user $WALLET $@
done
