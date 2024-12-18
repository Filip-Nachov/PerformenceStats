#!/bin/bash

CPU() {
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
}

MEMORY() {
    USED_MEM=$(free -m | grep "Mem" | awk '{print $3}')
    FREE_MEM=$(free -m | grep "Mem" | awk '{print $4}')
    echo "Used memory: ${USED_MEM}MB"
    echo "Free memory: ${FREE_MEM}MB"
}

DISK() {
    df -h --exclude-type=tmpfs --exclude-type=devtmpfs --output=source,used,avail,pcent,target
    
    echo
    
}

Top5CPU() {
    ps -eo user,pid,%cpu,%mem,etime,comm --sort=-%cpu | head -n 6
}

Bar() {
    CMD1=$(CPU)
    CMD2=$(MEMORY)
    CMD3=$(DISK)
    CMD4=$(Top5CPU)

    echo "CPU USAGE"
    echo "-----------" 
    echo "$CMD1" 
    echo "" 

    echo "MEMORY USAGE" 
    echo "------------" 
    while IFS= read -r line; do
        echo "$line" 
    done <<< "$CMD2"
    echo "" 

    echo "DISK USAGE"
    echo "----------" 
    while IFS= read -r line; do
        echo "$line"
    done <<< "$CMD3"
    echo "" 

    echo "TOP 5 PROCESSES" 
    echo "---------------"
    while IFS= read -r line; do
        echo "$line"
    done <<< "$CMD4"
}


Bar
