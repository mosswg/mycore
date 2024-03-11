  ;; Author: Moss Gallagher
  ;; Date: 20-Oct-21

%include "std/sys.asm"
%include "std/args.asm"
%include "std/str.asm"
%include "std/math.asm"

global _start

section .data
    not_num:    db " is not a number", 0
    arg1:       db "<number>", 0

section .text

_start:
    mov   r15, rsp
    call  main
    mov   eax, esi                ; exit code
    call  sys~exit                ; call exit

main:
    mov     rax, 1
    push    arg1
    call    args~require
    pop     rax

    mov     rax, 2
    call    args~get

    mov     rax, rsi
    call    str#new_cs

    mov     r9, rsi

    mov     rax, r9
    call    str~is_int
    jne     .non_number

    mov     rax, r9
    call    str~to_int

    mov     r10, rsi

    mov     rax, r10
    call    math#prime_factorization

    mov     rax, rsi

    call    arr~printn

    jmp     .return
    .non_number:

    lea     rax, [r9]
    call    str~print

    mov     rax, not_num
    call    cstr~println

    .return:
    mov     rsi, 0
    ret
