cmake_minimum_required(VERSION 3.15)
project(mycelium_std)

set(CMAKE_ASM_NASM_LINK_EXECUTABLE "ld <CMAKE_ASM_NASM_LINK_FLAGS> <LINK_FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES>")

include_directories(..)

set(CMAKE_ASM_NASM_OBJECT_FORMAT elf64)

enable_language(ASM_NASM)

set(CMAKE_ASM_NASM_OBJECT_FORMAT elf64)

add_library(mycelium_std
        sys.asm
        str.asm
        out.asm
        arr.asm
        type.asm
        int.asm
        tuple.asm
        list.asm
        exception.asm
        mem.asm
        cstr.asm
        args.asm
        file.asm
        )
