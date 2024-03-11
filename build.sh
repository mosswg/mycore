#!/bin/bash

nasm -g -f elf64 $1 -o tmp && ld tmp -o $(basename $1 .asm) && rm tmp
