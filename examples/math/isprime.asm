  ;; Author: Moss Gallagher
  ;; Date: 20-Oct-21

%include "std/sys.asm"
%include "std/args.asm"
%include "std/str.asm"
%include "std/mod.asm"

global _start

section .data
    not_num:    db " is not a number", 0
    prime:    db "prime", 0
    composite:    db "composite", 0
    arg1:       db "<number>", 0

section .text

_start:
    mov   r15, rsp
    call  main
    mov   eax, esi                ; exit code
    call  sys~exit                ; call exit

; args
;   rax: arg num
; return
;   rsi: arg as num
get_arg_to_num:
    call    args~get

    mov     rax, rsi
    call    str#new_cs

    mov     r9, rsi

    mov     rax, r9
    call    str~is_int
    jne     .non_number

    mov     rax, r9
    call    str~to_int

    ret

    .non_number:

    lea     rax, [r9]
    call    str~print

    mov     rax, not_num
    call    cstr~println

    mov   eax, 1
    call  sys~exit                ; call exit

main:
    mov     rax, 1
    push    arg1
    call    args~require
	add 	rsp, 8

	mov 	rax, 2
	call	get_arg_to_num

    mov     r10, rsi

    mov     rax, r10
    call    math#isprime

	jnz 	.composite

	.prime:
    mov     rax, prime
	jmp     .print
	.composite:
	mov     rax, composite

	.print:
    call    cstr~println

    jmp     .return


    .return:
    mov     rsi, 0
    ret
