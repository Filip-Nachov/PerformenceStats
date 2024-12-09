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

MEMORY
