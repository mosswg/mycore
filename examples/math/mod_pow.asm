  ;; Author: Moss Gallagher
  ;; Date: 20-Oct-21

%include "std/sys.asm"
%include "std/args.asm"
%include "std/str.asm"
%include "std/mod.asm"

global _start

section .data
    not_num:    db " is not a number", 0
    arg1:       db "<base>", 0
    arg2:       db "<power>", 0
    arg3:       db "<modulo>", 0

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
    mov     rax, 3
    push    arg1
	push	arg2
	push	arg3
    call    args~require
	add 	rsp, 24

	mov 	rax, 2
	call	get_arg_to_num

    mov     r10, rsi

	mov 	rax, 3
	call	get_arg_to_num

    mov     r11, rsi

	mov 	rax, 4
	call	get_arg_to_num

    mov     r12, rsi

    mov     rax, r10
    mov     rbx, r11
    mov     rcx, r12
    call    mod#power

    mov     rax, rsi

    call    int~println

    jmp     .return

    .return:
    mov     rsi, 0
    ret
