  ;; Author: Moss Gallagher
  ;; Data: 11-Mar-24

%ifndef _Mycelium_std_mod_
%define _Mycelium_std_mod_

%include "std/int.asm"
%include "std/math.asm"


; Args
;   rax: a
;   rbx: b
;   rcx: modulo
; Modifies
;   rsi
; Return
;   rsi: a * b (mod m)
mod#mul:
	push rax
	mul rbx
	xor rdx, rdx
	div rcx
	mov rsi, rdx
	pop rax
	ret


; Args
;   rax: a
;   rbx: b
;   rcx: modulo
; Modifies
;   rsi
; Return
;   rsi: a^b (mod m)
mod#power:
	push	r8
	push	r9
	push	r10
	push	r11
	push	r12
	push	rdx

	mov	r8, rax				; base
	mov	r9, rbx				; power
	mov	r10, 1					; out
	and	rbx, 1
	jz 	.odd_pow
	mov	r10, r8
	.odd_pow:
	mov	r11, r8				; prev
	mov	r12, r8				; tmp
	shr	r9, 1

	.loop:
	cmp	r9, 0
	je 	.return
	mov	rax, r11
	mov	rbx, r11
	call	mod#mul
	mov	r12, rsi
	mov	rax, r9
	and	rax, 1
	jz 	.dont_use
	mov	rax, r10
	mov	rbx, r12
	call	mod#mul
	mov	r10, rsi
	.dont_use:
	mov	r11, r12
	shr	r9, 1
	jmp .loop


	.return:
	mov	rsi, r10
	pop	rdx
	pop	r12
	pop	r11
	pop	r10
	pop	r9
	pop	r8
	ret



%endif
