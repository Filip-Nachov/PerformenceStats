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

    CPU_WIDTH=18
    MEM_WIDTH=30
    DISK_WIDTH=40
    PROC_WIDTH=50

    printf "%-${CPU_WIDTH}s" "CPU Usage:"
    printf "%-${MEM_WIDTH}s" "Memory Usage:"
    printf "%-${DISK_WIDTH}s" "Disk Usage:"
    printf "%-${PROC_WIDTH}s\n" "Top 5 CPU Processes:"

    printf "%-${CPU_WIDTH}s" "$(CPU)"
    printf "%-${MEM_WIDTH}s" "$(MEMORY)"
    printf "%-${DISK_WIDTH}s" "$(DISK)"
    printf "%-${PROC_WIDTH}s\n" " "

    printf "%-${CPU_WIDTH}s" ""
    printf "%-${MEM_WIDTH}s" ""
    printf "%-${DISK_WIDTH}s" ""
    printf "%-${PROC_WIDTH}s\n" "$(Top5CPU)" 
}

Bar
