			.data
; Control and Data Registers
CR:			.word32 0x10000
DR:			.word32 0x10008

; global variables
N_SAMPLES:	.word 10
N_COEFFS:	.word 3
sample:		.double 1, 2, 1, 2, 1, 1, 2, 1, 2, 1
coeff:		.double -0.5, 1, 0.5
result:		.double 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0

; smooth functions variables
i:			.word 0
j:			.word 0
norm:		.double 0.0

		.text
.main:
	; CR and DR init for print
	lwu r1,CR(r0) 		;Control Register
	lwu r2,DR(r0) 		;Data Register
	daddi r10,r0,1

	ld r3,N_SAMPLES(r0) ; r3 = N_SAMPLES
	ld r4,N_COEFFS(r0)  ; r4 = N_COEFFS

	; if (N_SAMPLES>=N_COEFFS)
	slt r8, r4, r3 		; if N_COEFFS < N_SAMPLES
	beq r8, r0, smooth 	; jump to sooth

	sd r4,(r2)			; print N_COEFFS to test 
	sd r10,(r1)

	; for (i=0; i<N_SAMPLES; i++)
	ld r5, i(r0) 		; r5 = i = 0
for:
	slt r8, r5, r3 		; if i > N_SAMPLES
	beq r8, r0, endfor 	; jump to endfor

	sd r5,(r2)			; print i
	sd r10,(r1)			; still print

	daddui r5, r5, 1	; i++
	
	j for

endfor: 
	j end

smooth: ; smooth method, I test it with writing N_SAMPLES to terminal
	sd r3,(r2)
	sd r10,(r1)


end:
		halt