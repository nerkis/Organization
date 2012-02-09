/ WAIT SUBROUTINE

/ Wait for a period of time determined by the low 6 bits of the switch
/ register, while displaying the caller's contents of A in the console
/ lights.
wait,	0		/ return address placed here by JMS
	dca saveAC	/ save AC so we can use it
	osr		/ read switch register into AC
	and (0077	/ mask off high six bits
	cma		/ -64 <= AC <= -1
	dca hiCount	/ put in high-order part of 24-bit counter
	tad saveAC	/ restore AC so user can see it while waiting
wait1,	isz loCount	/ inner loop, 4096 iterations
	jmp wait1
	isz hiCount	/ outer loop, count determined by switches
	jmp wait1
	jmp i wait	/ return from subroutine

loCount,0		/ low 12 bits of counter
hiCount,0		/ high 12 bits of counter

