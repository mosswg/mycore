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
;   rbx: modulo
; Modifies
;   rsi
; Return
;   rsi: a (mod m)
mod#reduce:
	push rax
	xor rdx, rdx
	cqo
	idiv rbx
	cmp rdx, 0
	jge .non_neg
	add rdx, rbx
	.non_neg:
	mov rsi, rdx
	pop rax
	ret




; Args
;   rax: a
;   rbx: modulo
; Modifies
;   rsi
; Return
;   rsi: a^-1 (mod m)
mod#inverse:
	push rdi
	push r12
	call math#eea
	mov rsi, rdi
	pop r12
	pop rdi
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



; Args
;   rax: a
;   rbx: h
;   rcx: m
; Modifies
;   rsi
; Return
;   rsi: x where a^x = h (mod m)
mod#shanks:
	push r8						; a
	push r9						; h
	push r10						; m
	push r11						; n
	push r12						; L1
	push r13						; L2
	push r14						; g^-n
	push r15					; loop counter


	mov r8, rax
	mov r9, rbx
	mov r10, rcx

	mov rax, r10
	call math#sqrt
	inc rsi
	mov r11, rsi				; r11 = sqrt(m)

	mov rax, r8
	mov rbx, r11
	mov rcx, r10
	call mod#power

	mov rbx, rsi
	mov rax, r10
	call math#eea
	mov rax, r12
	mov rbx, r10
	call mod#reduce

	mov r14, rsi				; r14 = g^-n; doing this first since we need r12 for L1


	mov rax, r11
	mov rbx, type#int
	call arr#new

	mov r12, rsi

	mov rcx, 1
	mov rbx, 0
	mov rax, r12
	call arr~set

	mov rax, r11
	mov rbx, type#int
	call arr#new

	mov r13, rsi

	mov rcx, r9
	mov rbx, 0
	mov rax, r13
	call arr~set

	mov r15, 1

	.generation_loop:
	cmp r15, r11
	jge .end_gen
	mov rax, r12
	mov rbx, r15
	dec rbx
	call arr~get
	mov rax, rsi
	mov rbx, r8
	mov rcx, r10
	call mod#mul

	mov rcx, rsi
	mov rbx, r15
	mov rax, r12
	call arr~set

	mov rax, r13
	mov rbx, r15
	dec rbx
	call arr~get
	mov rax, rsi
	mov rbx, r14
	mov rcx, r10
	call mod#mul

	mov rcx, rsi
	mov rbx, r15
	mov rax, r13
	call arr~set

	inc r15
	jmp .generation_loop
	.end_gen:

	mov r15, 0					; inner loop
	mov r9, 0					; outer loop (we dont need r8-r10) anymore

	.outer_search_loop:
	xor r9, r9
	inc r15
	cmp r15, r11
	jge .return

	mov rax, r12
	mov rbx, r15
	call arr~get
	mov r8, rsi 				; we dont need r8-r10 anymore

	.inner_search_loop:
	cmp r9, r11
	jge .outer_search_loop
	mov rax, r13
	mov rbx, r9
	call arr~get
	mov rcx, rsi 				; we dont need r8-r10 anymore

	cmp r8, rcx
	je  .return
	inc r9
	jmp .inner_search_loop


	.return:
	mov rax, r9
	mul r11
	add rax, r15
	mov rbx, r10
	call mod#reduce
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	ret



; Args
;   rax: a
;   rbx: m
; Modifies
;   rsi
; Return
;   rsi: a! (mod m)
mod#factorial:
	push	r8					; a
	push	r9					; m
	push	r10				; out
	push	r11
	push	r12
	push	rdx

	mov	r8, rax
	mov	r9, rbx
	mov	r10, r8

	.loop:
	dec	r8
	cmp	r8, 1
	jle	.return
	mov	rax, r10
	mov	rbx, r8
	mov	rcx, r9
	call	mod#mul
	mov	r10, rsi
	jmp	.loop

	.return:
	mov	rsi, r10
	pop	rdx
	pop	r12
	pop	r11
	pop	r10
	pop	r9
	pop	r8
	ret


; Args
;   rax: a
;   rbx: b
;   rcx: m
;   rdx: n
; Modifies
;   rsi
; Return
;   rsi: x where x = a (mod m) and x = b (mod n). via x = a + s * (b - a) * m
mod#chinese_remainder:
	push r8					; a
	push r9					; b
	push r10					; m
	push r11					; n
	push r12					; used by eea

	mov  r8, rax
	mov  r9, rbx
	mov  r10, rcx
	mov  r11, rdx

	mov  rax, r10
	mov  rbx, r11
	call math#eea

	mov  rax, rdi

	sub  r9, r8					; r9 = -r9 + r8 (this is done to subtract r9 from r8 while perserving r8 for later
	mul  r9
	mul  r10
	add  rax, r8

	mov  r8, rax

	mov  rax, r10
	mul  r11

	mov  rbx, rax
	mov  rax, r8
	call mod#reduce

	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	ret


%endif
