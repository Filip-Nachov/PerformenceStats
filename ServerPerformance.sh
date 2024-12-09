#!/bin/bash

CPU() {
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
}

MEMORY() {
    USED_MEM=$(free -m | grep "Mem" | awk '{print $3}')
    FREE_MEM=$(free -m | grep "Mem" | awk '{print $4}')
    echo "Used memory: ${USED_MEM}MB Free memory: ${FREE_MEM}MB"
}

DISK() {
    df -h
}

Top5CPU() {
    ps -eo user,pid,%cpu,%mem,etime,comm --sort=-%cpu | head -n 6
}

Bar() {
    CMD1=$(CPU)
    CMD2=$(MEMORY)
    CMD3=$(DISK)
    CMD4=$(Top5CPU)
    echo '     CPU USAGE                   MEM USAGE                        DISK MEMORY                            TOP 5 procceses     '
    echo '_____________________      _______________________    _________________________________________     _________________________'
    echo "      ${CMD1}                       ${CMD2}                           ${CMD3}                                 ${CMD4}        "
}

Bar
