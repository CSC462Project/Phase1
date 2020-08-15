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


if [ $? -eq 0 ]; then
    echo "Master process started successfully"
else
    echo "FAIL"
    exit 1
fi


echo "Building libraries"

docker exec -w /go/worker worker1 /bin/sh -c "go build -buildmode=plugin mrapps/wc.go"
wait
if [ $? -eq 0 ]; then
    echo "Map/reduce functions built successfully"
else
    echo "FAIL: Could not build map/reduce library. Abort."
    exit 1
fi



echo "Beginning worker processes"


docker exec -d -w /go/worker worker1 /bin/sh -c "go run mrworker.go wc.so >> worker1_10.out"
if [ $? -eq 0 ]; then
    echo "Worker1 process started successfully"
else
    echo "FAIL"
    exit 1
fi


docker exec -d -w /go/worker worker2 /bin/sh -c "go run mrworker.go wc.so >> worker2_10.out"
if [ $? -eq 0 ]; then
    echo "Worker2 process started successfully"
else
    echo "FAIL"
    exit 1
fi

docker exec -d -w /go/worker worker3 /bin/sh -c "go run mrworker.go wc.so >> worker3_10.out"
if [ $? -eq 0 ]; then
    echo "Worker3 process started successfully"
else
    echo "FAIL"
    exit 1
fi

docker exec -d -w /go/worker worker4 /bin/sh -c "go run mrworker.go wc.so >> worker4_10.out"
if [ $? -eq 0 ]; then
    echo "Worker4 process started successfully"
else
    echo "FAIL"
    exit 1
fi

docker exec -d -w /go/worker worker5 /bin/sh -c "go run mrworker.go wc.so >> worker5_10.out"
if [ $? -eq 0 ]; then
    echo "Worker5 process started successfully"
else
    echo "FAIL"
    exit 1
fi
docker exec -d -w /go/worker worker6 /bin/sh -c "go run mrworker.go wc.so >> worker6_10.out"
if [ $? -eq 0 ]; then
    echo "Worker6 process started successfully"
else
    echo "FAIL"
    exit 1
fi

docker exec -d -w /go/worker worker7 /bin/sh -c "go run mrworker.go wc.so >> worker7_10.out"
if [ $? -eq 0 ]; then
    echo "Worker7 process started successfully"
else
    echo "FAIL"
    exit 1
fi

docker exec -d -w /go/worker worker8 /bin/sh -c "go run mrworker.go wc.so >> worker8_10.out"
if [ $? -eq 0 ]; then
    echo "Worker8 process started successfully"
else
    echo "FAIL"
    exit 1
fi

docker exec -d -w /go/worker worker9 /bin/sh -c "go run mrworker.go wc.so >> worker9_10.out"
if [ $? -eq 0 ]; then
    echo "Worker9 process started successfully"
else
    echo "FAIL"
    exit 1
fi

docker exec -d -w /go/worker worker10 /bin/sh -c "go run mrworker.go wc.so >> worker10_10.out"
if [ $? -eq 0 ]; then
    echo "Worker10 process started successfully"
else
    echo "FAIL"
    exit 1
fi

