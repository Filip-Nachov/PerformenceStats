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
    df -h --output=source,pcent | tail -n +2 | \
        sed 's|/mnt/wsl.*|/mnt/wsl...|;s|/mnt/c|C:|;s|/mnt/d|D:|'
}

Top5CPU() {
    ps -eo user,pid,%cpu,%mem,etime,comm --sort=-%cpu | head -n 6
}

CalculateMaxWidth() {
    local maxWidth=0
    for str in "$@"; do
        local length=${#str}
        if ((length > max_width)); then
            max_width=$length
        fi
    done
    echo $max_width
}

Bar() {
    CMD1=$(CPU)
    CMD2=$(MEMORY)
    CMD3=$(DISK)
    CMD4=$(Top5CPU)

    CPU_WIDTH=$(CalculateMaxWidth "CPU USAGE" "$CMD1")
    MEM_WIDTH=$(CalculateMaxWidth "MEMORY USAGE" "$CMD2")
    DISK_WIDTH=$(CalculateMaxWidth "DISK USAGE" "$CMD3")
    PROC_WIDTH=$(CalculateMaxWidth "TOP 5 PROCESSES" "$CMD4")
}

Bar
