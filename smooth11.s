; Paola Cecilia Torrico Morón 453031
; Beata Tompos 455674
; Alberto Carlos Hernandez Ledesma 452984

.data

; global variables
coeff:     .double -0.5, 1.0, 0.5
N_SAMPLES: .word 10
;sample:    .double 1, 2, 1, 3, 5, 4, 1, 2, 3, 4
sample:    .double 1, 2, 1, 2, 1, 1, 2, 1, 2, 1
result:    .double 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0

.text
		ld    $a0, N_SAMPLES($0)

		daddi $t0, $0, 65535	;creates mask full of 1
		dsrl  $t0, $t0, 1		;creates mask of 01111...

		slti   $t7, $a0, 3		;set if less than 3 (coefficients)

		daddi $a1, $0, sample	;loads address of sample vector
		daddi $a2, $0, coeff	;loads address of coeff vector
		daddi $a3, $0, result	;loads address of result vector

		bnez  $t7, end			;branch if not 0 

		ld    $t1, ($a2)		;load value of coeff
		ld    $t2, 8($a2)
		ld    $t3, 16($a2)

		and   $t4, $t1, $t0		;absolute value of coeff
		and   $t5, $t2, $t0
		and   $t6, $t3, $t0

		mtc1  $t4, f4			;convert from int reg to float reg
		mtc1  $t5, f5
		add.d f7, f4, f5		;add coeff for norm
		
		mtc1  $t6, f6

		add.d f7, f7, f6		;norm
		
		l.d   f1, ($a2)			;load value of float coef	
		l.d   f2, 8($a2)
		l.d   f3, 16($a2)
		
		dsll  $a0, $a0, 3		;number of samples * 8 (address size)
		daddu $t1, $a0, $a1		;samples[N_SAMPLES]

		daddi $t1, $t1, -16		;samples[N_SAMPLES-2] not taking into account first and last number

		l.d   f31, ($a1)		;first value of sample
		
		l.d   f11, ($a1)		;loads value of float sample
for_loop:	
		
		;l.d   f11, ($a1)		;loads value of float sample			
		l.d   f12, 8($a1)		;loads value of float sample
		l.d   f13, 16($a1)		;loads value of float sample

		mul.d f21, f1, f11		;mult coef * sample
		mul.d f22, f2, f12 
		mul.d f23, f3, f13

		s.d   f31, ($a3)		;stores previuos value of  f31 (result) in memory

		add.d f29, f21, f22		;adds multiplied numbers
		add.d f30, f29, f23
						
		div.d f31, f30, f7		;divide by norm
		
		;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		l.d   f14, 24($a1)		;loads value of float sample

		mul.d f24, f1, f12		;mult coef * sample
		mul.d f25, f2, f13 
		mul.d f26, f3, f14

		s.d   f31, 8($a3)		;stores previuos value of  f31 (result) in memory

		add.d f29, f24, f25		;adds multiplied numbers
		add.d f30, f29, f26
						
		div.d f31, f30, f7		;divide by norm		
		
		;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		l.d   f15, 32($a1)		;loads value of float sample

		mul.d f21, f1, f13		;mult coef * sample
		mul.d f22, f2, f14 
		mul.d f23, f3, f15

		s.d   f31, 16($a3)		;stores previuos value of  f31 (result) in memory

		daddi $a1, $a1, 24		;samples ++
		
		add.d f29, f21, f22		;adds multiplied numbers
		add.d f30, f29, f23
			
		daddi $t8, $a1, 24	    ;to check if next loop possible
		
		daddi $a3, $a3, 24		;results ++			
		div.d f31, f30, f7		;divide by norm	
		slt   $t9, $t8, $t1		;set if less than 3 (coefficients)
		
		bnez $t9, for_loop
		
		l.d   f11, ($a1)		;loads value of float sample	
				
				
		beq $a1, $t1, last
		
extra_unroll:
		
		;l.d   f11, ($a1)		;loads value of float sample			
		l.d   f12, 8($a1)
		l.d   f13, 16($a1)

		mul.d f21, f1, f11		;mult coef * sample
		mul.d f22, f2, f12 
		mul.d f23, f3, f13

		s.d   f31, ($a3)		;stores previuos value of  f31 (result) in memory

		add.d f29, f21, f22		;adds multiplied numbers
		add.d f30, f29, f23
				
		daddi $a1, $a1, 8		;samples ++
		daddi $a3, $a3, 8		;results ++	
		
		div.d f31, f30, f7		;divide by norm
		bne $a1, $t1, extra_unroll  ;if (samples != last sample)
		
		l.d   f11, ($a1)		;loads value of float sample
		
end_loop:

		s.d f13,8($a3)			;stores the last value of sample in result
		s.d f31, ($a3)			;stores the last value of the loop computation
end:

		halt
		
last: 
		s.d f15,8($a3)			;stores the last value of sample in result
		s.d f31, ($a3)			;stores the last value of the loop computation
		
		daddi $a3, $0, result	;loads address of result vector

		halt
		