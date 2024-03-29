cmake_minimum_required(VERSION 3.15)
project(mycelium_examples)

set(CMAKE_ASM_NASM_OBJECT_FORMAT elf64)
set(CMAKE_ASM_NASM_LINK_EXECUTABLE "ld <CMAKE_ASM_NASM_LINK_FLAGS> <LINK_FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES>")
set(CMAKE_ASM_NASM_FLAGS -g)

enable_language(ASM_NASM)

set(CMAKE_VERBOSE_MAKEFILE ON)


add_executable(print
        print.asm
        )

add_executable(args
        args.asm
        )

add_executable(list
        list.asm
        )

add_executable(list-resize
        list_resize.asm
        )

add_executable(list-typed-elements
        list_typed_elements.asm
        )

add_executable(arr
        arr.asm
        )

add_executable(file
        file.asm
        )

add_executable(str-split
        str_split.asm
        )

add_executable(str-parse
        str_parse.asm
        )

add_executable(substr
        substr.asm
        )

add_executable(arr-cat
        arr_cat.asm
        )

include_directories(examples ..)
