  ;; Author: Moss Gallagher
  ;; Data: 13-Mar-24

%ifndef _Mycelium_std_float_
%define _Mycelium_std_float_

%include "std/out.asm"
%include "std/str.asm"


section .data
    fpucw:       dw 0
    ften:       dd 10.0
    fpusave:	  times 128 db 0


section .text

float~init:
	fninit
	fstcw [fpucw]
	fwait
	mov   rax,[fpucw]

	or    rax,0C00h

	push  rax
	fldcw word [rsp]
	pop   rax

	ret

; Args
;   st0: float number
; Modifies
;   rsi
; Return
;   rsi: rax as an int
float~to_int:
	push    rsi
	fisttp   qword [rsp]
	pop     rsi
	ret

; Args
;   rax: out string
;   st0: number
; Modifies
;   rsi
; Return
;   rsi: string length
float~to_cstring:
	push r8
	push r9
	push r10
	mov  r8, rax
	fld st0						; duplicate st0 twice
	fst st4
	fld st0						; duplicate st0 twice



	fldz
	fcomip  st1
	jge     .non_neg								; jmp non_neg if 0 < st0
	mov    r11b, '-'
	mov    [rax], r11b
	inc    rax
	neg    rbx

	.non_neg:
	call float~to_int
	mov  rbx, rsi
	call int~to_cstring
	mov  r9, rsi				; r9 = length of the string after concating the integer part
	frndint
	fsub						; st0 = st0 - floor(st0)
	fld  dword [ften]
	fxch st0, st1				; st1 = 10f


	fldz
	fcomip    st0, st1
	je       .return
	lea      rbx, [r8+r9]
	mov      r10b, '.'
	mov      [rbx], r10b
	inc      r9

	mov rax, 0					; counter
	.loop:
	fldz
	fcomip    st0, st1
	je       .return
	cmp      rax, 8
	jge      .return
	fmul     st0, st1
	fld      st0
	frndint
	fsub      st1, st0
	call     float~to_int		; rsi = integer part of st0
	mov      rdx, rsi

	lea      rbx, [r8+r9]
	mov      r10b, 48
	add      r10b, dl
	mov      [rbx], r10b

	inc      r9
	inc      rax
	jmp      .loop


	.return:
	mov rax, r8
	mov rsi, r9
	fld st4
	pop r10
	pop r9
	pop r8
	ret



; Args
;   rax: the number to be printed
; Returns
;   void
float~print:
  .debug:
  push  rbp
  mov   rbp, rsp
  push  rbx
  push  rax

  lea   rax, [rsp-16]
  call  float~to_cstring
  lea   rax, [rsp-16]
  mov   rbx, rsi
  call  out~puts

  pop   rax
  pop   rbx
  pop   rbp
  ret

; Args
;   st0: the number to be printed
; Modifies
;   rbx
; Returns
;   void
float~println:
  .debug:
  push  rbp
  mov   rbp, rsp

  push  rsi

  mov   rax, rsp
  call  float~to_cstring

  lea   rbx, [rsp]
  add   rbx, rsi
  mov   al, 0xA
  mov   [rbx], al

  mov   rax, rsp
  mov   rbx, rsi
  inc   rbx
  call  out~puts

  pop   rsi
  pop   rbp
  ret


%endif
