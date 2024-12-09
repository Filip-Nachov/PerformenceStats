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

Bar() {
    CMD1=$(CPU)
    CMD2=$(MEMORY)
    CMD3=$(DISK)
    CMD4=$(Top5CPU)

    CPU_WIDTH=18
    MEM_WIDTH=30
    DISK_WIDTH=40
    PROC_WIDTH=50

    printf "%-20s %-20s %-20s %-20s\n" "CPU" "Memory" "Disk" "Process"
    printf "%-20s %-20s %-20s %-20s\n" "----" "-------" "----" "-------"
}

Bar
