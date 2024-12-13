#!/bin/bash

PrintDelay() {
    local text="$1"
    local delay="$2"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo
}


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
    df -h --output=source,pcent | tail -n +2
}

Top5CPU() {
    ps -eo user,pid,%cpu,%mem,etime,comm --sort=-%cpu | head -n 6
}

Bar() {
    CMD1=$(CPU)
    CMD2=$(MEMORY)
    CMD3=$(DISK)
    CMD4=$(Top5CPU)

    PrintDelay "CPU USAGE" 0.02
    PrintDelay "-----------" 0.01
    PrintDelay "$CMD1" 0.03
    PrintDelay "" 0.01

    PrintDelay "MEMORY USAGE" 0.02
    PrintDelay "------------" 0.01
    while IFS= read -r line; do
        PrintDelay "$line" 0.03
    done <<< "$CMD2"
    PrintDelay "" 0.01

    PrintDelay "DISK USAGE" 0.02
    PrintDelay "----------" 0.01
    while IFS= read -r line; do
        PrintDelay "$line" 0.03
    done <<< "$CMD3"
    PrintDelay "" 0.05

    PrintDelay "TOP 5 PROCESSES" 0.02
    PrintDelay "---------------" 0.01
    while IFS= read -r line; do
        PrintDelay "$line" 0.03
    done <<< "$CMD4"
}


Bar
