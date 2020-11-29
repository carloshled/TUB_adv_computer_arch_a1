		.data
; Control and Data Registers
CR:			.word32 0x10000
DR:			.word32 0x10008

; global variables
N_SAMPLES:	.word 10
N_COEFFS:	.word 3
;NORM:		.word 2
sample:		.double 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
coeff:		.double -1, 2, 3
result:		.double 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0

; smooth functions variables
;i:			.word 0
;j:			.word 0
norm:		.double 2.0

.text
		ld    $a0, N_SAMPLES($0)
		
		slti   $t7, $a0, 3		;set if less than 3 (coefficients)
		
		bnez  $t7, end			;branch if not 0 
		
		daddi $a1, $0, sample	;loads address of sample vector
		daddi $a2, $0, coeff	;loads address of coeff vector
		daddi $a3, $0, result	;loads address of result vector
		
		daddi $t0, $0, 65535	;creates mask full of 1
		dsrl  $t0, $t0, 1		;creates mask of 01111...
		
		ld    $t1, ($a2)		;load value of coeff
		ld    $t2, 8($a2)
		ld    $t3, 16($a2)
		
		and   $t4, $t1, $t0		;absolute value of coeff
		and   $t5, $t2, $t0
		and   $t6, $t3, $t0
		
		mtc1  $t4, f4			;convert from int reg to float reg
		mtc1  $t5, f5
		mtc1  $t6, f6
		
		add.d f7, f4, f5		;add coeff
		add.d f7, f7, f6		;norm
		
		
		;daddi $t0, $0, norm
		
		l.d   f1, ($a2)			;load value of float coef	
		l.d   f2, 8($a2)
		l.d   f3, 16($a2)
		
		l.d   f11, ($a1)		;loads value of float sample			
		l.d   f12, 8($a1)
		l.d   f13, 16($a1)
				
		mul.d f21, f1, f11		;mult coef * sample
		mul.d f22, f2, f12 
		mul.d f23, f3, f13

		add.d f30, f21, f22		;adds multiplied numbers
		add.d f30, f30, f23
		
		div.d f31, f30, f7		;divide by norm
		
		s.d   f31, ($a3)		;stores float value f31 (result) in address mem a3
		
end:
		halt
		
		