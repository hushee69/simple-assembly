#!/bin/bash

file_input=$1;
nasm -f elf -F dwarf -g $file_input 
file_input="${file_input%.*}.o";
ld -m elf_i386 -o $2 $file_input 
