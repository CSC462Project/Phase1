#!/bin/sh

terraform plan -out planfile

terraform apply planfile

echo '***' Master and Workers are ready.

echo '***' Checking containers and opeing master CLI.

docker info



docker exec -it master /bin/bash || exit 1

(cd ../go/master && go run mrmaster.go pg-*.txt) || exit 1






docker exec -it worker2 /bin/bash

docker exec -it worker3 /bin/bash