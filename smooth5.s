		.data
; Control and Data Registers
CR:			.word32 0x10000
DR:			.word32 0x10008

; global variables
N_SAMPLES:	.word 10
N_COEFFS:	.word 3
NORM:		.word 2
sample:		.double 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
coeff:		.double 1, 2, 3
result:		.double 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0

; smooth functions variables
i:			.word 0
j:			.word 0
norm:		.double 0.0

		.text
.main:
	; CR and DR init for print
	;lwu r1,CR(r0) 		;Control Register
	;lwu r2,DR(r0) 		;Data Register
	;daddi r10,r0,1

	ld r3,N_SAMPLES(r0) ; r3 = N_SAMPLES
	ld r4,N_COEFFS(r0)  ; r4 = N_COEFFS
	l.d f24,NORM(r0)     ; f24 = NORM
	
	ld r5,NORM(R0)		; R5 = NORM
	
	daddi $r24, $0, result
	
	daddi $t0, $0, coeff	
	l.d   f1, ($t0)				
	l.d   f2, 8($t0)
	l.d   f3, 16($t0)
		
	ld    $t1, N_SAMPLES($0)
	daddi $t2, $0, sample
	
	dsll  $t1, $t1, 3			; move one forward
	daddu $t3, $t2, $t1         ; sample[N_SAMPLES] address
	
loop:

	l.d   f10, ($t2)
	l.d   f11, 8($t2)
	l.d   f12, 16($t2)
	
	mul.d f20, f10, f1
	mul.d f21, f11, f2 
	mul.d f22, f12, f3 
	
	add.d f30, f20, f21
	add.d f30, f30, f22
	
	;div.d f31, f30, f24
	
	s.d f30, ($r5)

end:
		halt
