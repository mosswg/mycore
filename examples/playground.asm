;; Author: Moss Gallagher
;; Date: 11-Mar-24

%include "std/sys.asm"

global _start

section .data
section .text

_start:
  mov   r15, rsp
  call  main
  mov   eax, esi                ; exit code
  call  sys~exit                ; call exit

main:
  mov   rax, 16
  and   rax, 1
  jnz   .end
  mov   rbx, 4
  .end:

  .return:
  mov   rsi, 0
  ret
