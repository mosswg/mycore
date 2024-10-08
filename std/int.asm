  ;; Author: Moss Gallagher
  ;; Data: 13-Oct-21

%ifndef _Mycelium_std_int_
%define _Mycelium_std_int_

%include "std/out.asm"
%include "std/str.asm"
%include "std/arr.asm"

; Args
;   rax: out string
;   rbx: number
; Modifies
;   rsi
; Return
;   rsi: string length
int~to_cstring:
  push  rbp
  mov   rbp, rsp


  push  rdx             ; Save the registers we don't want to affect after the function
  push  rcx
  push  r8
  push  r9
  push  r10
  push  r11
  push	r12                     ; str len
  push  rax

  mov	r12, 0

	cmp	rbx, 0
	jge	.non_neg
  mov	r11b, '-'
	mov	[rax], r11b
	add	rax, 1
  inc	r12
  neg	rbx
  .non_neg:
  mov   r9, rax         ; Move the out string to a place we don't need for other functions
  mov   r8, rbx
  mov   rax, rbx
  call  int~digits
  add	r12, rsi

  cmp   rsi, 1
  jne   .multidigit
  .singledigit:
    lea   rbx, [r9]
    mov   r11b, 48
    add   r11b, al
    mov   [rbx], r11b
    mov   r11b, 0x0
    mov   [r9+1], r11b
    jmp .return
  .multidigit:
  sub   rsi, 1

  mov rcx, 1
  mov r10, 10


  jmp .loop_check
  .loop:
    xor rdx, rdx
    div r10

    lea rbx, [r9]
    add rbx, rsi
    mov r11b, 48
    add r11b, dl
    mov [rbx], r11b

    sub rsi, 1
  .loop_check:
    cmp rsi, 0
  jge .loop

  .return:
  mov	rsi, r12
  pop   rax
  mov	rbx, r8

  pop	r12
  pop   r11
  pop   r10
  pop   r9
  pop   r8
  pop   rcx
  pop   rdx
  pop   rbp
  ret



int.to_hex_arr:   db "0123456789abcdedf"
; Args
;   rax: number
; Return
;   rsi: int as string in reversed hex
;   rdi: number of hex digits
int~to_string_rhex:
  push  r8                      ; number
  push  r9                      ; string
  push  rbp
  mov   rbp, rsp
  ;;    rbp - 8                   Out string

  call  str#new

  mov   r9, rsi

  jmp   .loop_check
  .loop:
    mov   rax, r8
    mov   rbx, 16

    div   rbx

    mov   r8, rax

    mov   rbx, [int.to_hex_arr + rdx]
    mov   rax, r9

    call  arr~push

  .loop_check:
    cmp   r8, 1
    jge   .loop

  mov rsi, r8

  pop   rbp
  pop   r9
  pop   r8
  ret



; Args
;   rax: the number to be printed
; Returns
;   void
int~print:
  .debug:
  push  rbp
  mov   rbp, rsp
  push  rbx
  push  rax

  mov   rbx, rax
  lea   rax, [rsp-16]
  call  int~to_cstring
  lea   rax, [rsp-16]
  mov   rbx, rsi
  call  out~puts

  pop   rax
  pop   rbx
  pop   rbp
  ret



; Args
;   rax: the number to be printed
; Modifies
;   rbx
; Returns
;   void
int~println:
  .debug:
  push  rbp
  mov   rbp, rsp

  push  rax
  push  rsi

  mov   rbx, rax
  mov   rax, rsp
  call  int~to_cstring

  lea   rbx, [rsp]
  add   rbx, rsi
  mov   al, 0xA
  mov   [rbx], al

  mov   rax, rsp
  mov   rbx, rsi
  add   rbx, 1
  call  out~puts

  pop   rsi
  pop   rax
  pop   rbp
  ret

; Args
;   rax: number
; Returns
;   rsi: number of digits
int~digits:
  push  rbp
  mov   rbp, rsp

  cmp   rax, 0
  jne   .non_zero
  mov   rsi, 1
  pop   rbp
  ret
  .non_zero:
  push  rax
  push  rcx
  push  rdx

  mov   rsi, 0
  mov   ecx, 10

  jmp .loop_check
  .loop:
    xor edx, edx
    div ecx
    add rsi, 1
  .loop_check:
    cmp rax, 1
    jge .loop

  pop   rdx
  pop   rcx
  pop   rax
  pop   rbp
  ret


; Args
;   rax: int number
; Modifies
;   rsi
; Return
;   st0: rax as a float
int~to_float:
  push  rax
  fild  qword [rsp]
  pop   rax
  ret


%endif                          ; ifdef guard
