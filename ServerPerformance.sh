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
    df -h --output=source,pcent,target | tail -n +2 | head -n 5 | awk '{print $1, $2, $3}' | sed 's|/mnt/wsl.*|/mnt/wsl...|;s|/mnt/c|C:|;s|/mnt/d|D:|'
}

Top5CPU() {
    ps -eo user,pid,%cpu,%mem,etime,comm --sort=-%cpu | head -n 6
}

Bar() {
    CMD1=$(CPU)
    CMD2=$(MEMORY)
    CMD3=$(DISK)
    CMD4=$(Top5CPU)

    CPU_WIDTH=18
    MEM_WIDTH=30
    DISK_WIDTH=40
    PROC_WIDTH=50

    printf "%-${CPU_WIDTH}s %-${MEM_WIDTH}s %-${DISK_WIDTH}s %-${PROC_WIDTH}s\n" "CPU USAGE" "MEMORY USAGE" "DISK USAGE" "TOP 5 PROCESSES"
    printf "%-${CPU_WIDTH}s %-${MEM_WIDTH}s %-${DISK_WIDTH}s %-${PROC_WIDTH}s\n" "-----------" "-------------" "------------------------------" "--------------------------------------------------"

    printf "%-${CPU_WIDTH}s" "$(echo "$CMD1" | cut -c1-${CPU_WIDTH})"
    printf "%-${MEM_WIDTH}s" " "
    printf "%-${DISK_WIDTH}s" " "
    printf "%-${PROC_WIDTH}s\n" " "

    while IFS= read -r line; do
        printf "%-${CPU_WIDTH}s" " "
        printf "%-${MEM_WIDTH}s" "$(echo "$line" | cut -c1-${MEM_WIDTH})"
        printf "%-${DISK_WIDTH}s" " "
        printf "%-${PROC_WIDTH}s\n" " "
    done <<< "$CMD2"

    while IFS= read -r line; do
        printf "%-${CPU_WIDTH}s" " "
        printf "%-${MEM_WIDTH}s" " "
        printf "%-${DISK_WIDTH}s" "$(echo "$line" | cut -c1-${DISK_WIDTH})"
        printf "%-${PROC_WIDTH}s\n" " "
    done <<< "$CMD3"

    while IFS= read -r line; do
        printf "%-${CPU_WIDTH}s" " "
        printf "%-${MEM_WIDTH}s" " "
        printf "%-${DISK_WIDTH}s" " "
        printf "%-${PROC_WIDTH}s\n" "$(echo "$line" | cut -c1-${PROC_WIDTH})"
    done <<< "$CMD4"
}

Bar
