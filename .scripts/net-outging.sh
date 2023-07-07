#!/bin/bash

netstat -ntlp | awk '$6 == "SYN_SENT" {print $7}' | sed 's/\/.*//' | sort | uniq -c | while read count name; do
    host=$(getent hosts $name | awk '{print $1}')
    if [[ $host ]]; then
        echo "$host - $name ($count connections)"
    else
        echo "$name ($count connections)"
    fi
done
