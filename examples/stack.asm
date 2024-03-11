  ;; Author: Moss Gallagher
  ;; Date: 12-Oct-21

%include "std/sys.asm"
%include "std/int.asm"

global _start

section .text

_start:
  mov   r15, rsp
  call  main
  mov   eax, esi                ; exit code
  call  sys~exit                ; call exit

main:
  mov  r8, rsp
  mov  r9, rbp
  push r8
  push r9
  mov  r10, rsp
  mov  r11, rbp
  pop  r12
  pop  r12
  sub  r8, r10
  sub  r9, r11
  mov  rax, r8
  call int~println
  mov  rax, r9
  call int~println

  .return:
  mov   rsi, 0
  ret
