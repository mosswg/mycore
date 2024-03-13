  ;; Author: Moss Gallagher
  ;; Data: 10-Mar-24

%ifndef _Mycelium_std_math_
%define _Mycelium_std_math_

%include "std/int.asm"


; Args
;   rax: the number to find sqrt of
; Modifies
;   nothing
; Returns
;   rsi: the integer sqrt of rax
math#sqrt:
	cmp     rax, 0
	jle     .negative_root

	push    rbx
	push    rcx
	push    rdx
	push    r8
	push    r9

	mov     r8, rax
	mov     rax, 0
	mov     rbx, 0
	mov     rcx, r8
	inc     rcx

	.loop:
	dec     rcx
	cmp     rbx, rcx
	je      .return
	inc     rcx

	mov     rax, rbx
	add     rax, rcx
	shr     rax, 1
	mov     r9, rax
	mul     rax

	cmp     rax, r8
	jg      .m_squared_greater
	mov     rbx, r9
	jmp     .loop
	.m_squared_greater:
	mov     rcx, r9
	jmp     .loop


	.return:
	mov    rsi, rbx
	pop    r9
	pop    r8
	pop    rdx
	pop    rcx
	pop    rbx
	.negative_root:
	ret


; Args
;   rax: the number to find the prime factors of
; Modifies
;   nothing
; Returns
;   rsi: the array of prime factors
math#prime_factorization:
	push	rax
	push	rbx
	push	r8
	push	r9
	push	r10
	push	r11


	mov	r9, rax

	;; r10 = sqrt(r9) + 1
	mov	rax, r9
	call	math#sqrt
	mov	r10, rsi
	inc	r10

	;; r8 = array[r10]
	mov	rax, 0
	mov	rbx, type#int
  ;; new array into rsi
	call	arr#new

	mov	r8, rsi

	mov	r11, 1

	.loop:
	inc	r11
	xor	rdx, rdx
	cmp	r11, r10
	jge	.end_loop
	mov	rax, r9
	div	r11
	cmp	rdx, 0
	jne	.loop
	mov	r9, rax
	mov	rax, r8
	mov	rbx, r11
	;; push r11 to r8
	call	arr~push
	mov	rax, r9
	.inner_loop:
	mov	r9, rax
	xor	rdx, rdx
	div	r11
	cmp	rdx, 0
	je		.inner_loop
	jmp	.loop

	.end_loop:

	cmp	r9, 2
	jle	.return
	mov	rax, r8
	mov	rbx, r9
	;; set the element at index 5 of  array in r9 to 1
	call	arr~push

	.return:
	mov	rsi, r8
	pop	r11
	pop	r10
	pop	r9
	pop	r8
	pop	rbx
	pop	rax
	ret


; Args
;   rax: base
;   rbx: power
; Modifies
;   nothing
; Returns
;   rsi: base^power
math#power:
	push	r8
	push	r9
	push	r10
	push	r11
	push	r12
	push	rdx

	mov	r8, rax				; base
	mov	r9, rbx				; power
	mov	rsi, 1					; out
	and	rbx, 1
	jz 	.odd_pow
	mov	rsi, r8
	.odd_pow:
	mov	r11, r8				; prev
	mov	r12, r8				; tmp
	shr	r9, 1

	.loop:
	cmp	r9, 0
	je 	.return
	mov	rax, r11
	xor	rdx, rdx
	mul	r11
	mov	r12, rax
	mov	rax, r9
	and	rax, 1
	jz 	.dont_use
	mov	rax, rsi
	xor	rdx, rdx
	mul	r12
	mov	rsi, rax
	.dont_use:
	mov	r11, r12
	shr	r9, 1
	jmp .loop


	.return:
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
; Modifies
;   rax, rsi
; Returns
;   rsi: gcd(a, b)
math#gcd:
	push	r8 					; q
	push	r9						; r0
	push	r10					; r1
	push	rdx

	mov	r9, rax
	mov	r10, rbx


	.loop:
	cmp	r10, 0
	jz		.return
	mov	rax, r9
	xor	rdx, rdx
	div	r10
	mov	r8, rax
	mov	r9, r10
	mov	r10, rdx
	jmp	.loop



	.return:
	mov	rsi, r9
	pop	rdx
	pop	r10
	pop	r9
	pop	r8
	ret


; Args
;   rax: a
;   rbx: b
; Modifies
;   rax, rsi
; Returns
;   rsi: gcd(a, b)
;   rdi: s
;   r12: t
math#eea:
	push	r8 					; q
	push	r9						; r0
	push	r10					; r1
	push	r11					; s0
	;; 	r12					; s1
	push	r13					; t0
	push	r14					; t1
	push	rdx

	mov	r9, rax
	mov	r10, rbx
	mov	r11, 1
	mov	r12, 0

	mov	r13, 0
	mov	r14, 1


	.loop:
	cmp	r10, 0
	jz		.return
	mov	rax, r9
	xor	rdx, rdx
	div	r10
	mov	r8, rax
	mov	r9, r10
	mov	r10, rdx
	push	rax
	mul	r12
	mov	rdx, r11
	mov	r11, r12
	sub	rdx, rax
	mov	r12, rdx

	pop	rax
	mul	r14
	mov	rdx, r13
	mov	r13, r14
	sub	rdx, rax
	mov	r14, rdx

	jmp	.loop



	.return:
	mov	rsi, r9
	mov	rdi, r11
	mov	r12, r13
	pop	rdx
	pop	r14
	pop	r13
	pop	r11
	pop	r10
	pop	r9
	pop	r8
	ret



; Args
;   rax: a
; Modifies
;   rsi
; Returns
;   rsi: log_2(a)
math#log:
	bsr	rsi, rax
	ret



; Args
;   rax: a
; Modifies
;   rsi, rax, rbx
; Returns
;   zf: if a is prime
; Description
;   this is stupid
math#isprime:
	push r8						; a
	push r9						; sqrt(a)
	push r10						; loop counter

	mov r8, rax
	mov r10, 3


	xor rdx, rdx
	mov rbx, 2
	div rbx
	cmp rdx, 0
	je .composite

	mov rax, r8

	call math#sqrt
	mov r9, rsi
	inc r9
	.loop:
		cmp r10, r9
		jge .prime
		xor rdx, rdx
		mov rax, r8
		div r10
		cmp rdx, 0
		je .composite
		add r10, 2
	jmp .loop

	.composite:
	mov r10, 1
	cmp r10, 0
	jmp .return

	.prime:
	xor r10, r10
	cmp r10, 0
	.return:
	pop r10
	pop r9
	pop r8
	ret

%endif                          ; ifdef guard
