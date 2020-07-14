#!/bin/sh


# To re-run the script with fresh changes, run the command
# terraform destroy


if [ -z $1 ]; then
        echo "Please provide a path to your working directory."
        echo "Usage: bash test-mr.sh <working_directory>"
        exit 0
fi


terraform plan -var="home=$1" -out planfile


terraform apply planfile

wait


echo '***' Master and Workers are ready.

echo '***' Checking containers and opening master CLI.

docker info

docker exec -d -w /go/master master /bin/sh -c "go run mrmaster.go pg-*.txt >> master.out"
#>> master.txt

if [ $? -eq 0 ]; then
    echo "Master process started successfully"
else
    echo "FAIL"
    exit 1
fi

#echo "Building libraries"
#
#
#go build -buildmode=plugin mrapps/wc.go
#if [ $? -eq 0 ]; then
#    echo "Map/reduce functions built successfully"
#else
#    echo "FAIL: Could not build map/reduce library. Abort."
#    exit 1
#fi


echo "Beginning worker processes"


#docker exec -d -w /go/worker worker1 go run mrworker.go wc.so
docker exec -d -w /go/worker worker1 /bin/sh -c "go run mrworker.go wc.so >> worker1.out"
if [ $? -eq 0 ]; then
    echo "Worker1 process started successfully"
else
    echo "FAIL"
    exit 1
fi


#docker exec -d -w /go/worker worker2 go run mrworker.go wc.so
docker exec -d -w /go/worker worker2 /bin/sh -c "go run mrworker.go wc.so >> worker2.out"
if [ $? -eq 0 ]; then
    echo "Worker2 process started successfully"
else
    echo "FAIL"
    exit 1
fi


#docker exec -d -w /go/worker worker3 go run mrworker.go wc.so
docker exec -d -w /go/worker worker3 /bin/sh -c "go run mrworker.go wc.so >> worker3.out"
if [ $? -eq 0 ]; then
    echo "Worker3 process started successfully"
else
    echo "FAIL"
    exit 1
fi