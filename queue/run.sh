#!/bin/bash

export LC_ALL=C.UTF-8
export LANG=C.UTF-8
python3 /elba/WISEServices/queue_/src/py/server.py --ip_address 0.0.0.0 --port $1 --thread_pool_size $2 --db_host $3 --db_user $4
