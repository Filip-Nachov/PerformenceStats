#!/bin/bash


CPU() {
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
}

MEMORY() {
    USED_MEM = $(free -h | grep "Mem" | awk '{print $3}')
}

MEMORY
