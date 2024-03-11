    ;; Author: Moss Gallagher
    ;; Data:   19-Oct-21

%include "std/type.asm"
%include "std/arr.asm"


global _start

section .data
  arr_size: equ 25

section .text

_start:
  mov   r15, rsp
  call  main
  mov   eax, esi                ; exit code
  call  sys~exit                ; call exit

main:
    mov     rax, arr_size
    mov     rbx, type#int
  ;; new array into rsi
    call    arr#new

    mov     rax, rsi
    call    arr~printn

    ret
