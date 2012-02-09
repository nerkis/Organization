/ page 0
	*20
saveAC,	0

	page
/ main program for pong game. bounces one bit of AC back and forth as
/ long as player presses a key at the right time 
main,	jms serve	
serveR, cla cll
	kcc
	tad startRt	/ put 0002 in AC to start on right
loop1,	jms wait	
	cll ral		
	szl
	jmp LSet1	/ L set, skip zero-L handling instructions
	ksf
	jmp loop1	/ keep moving left
	jms bell	/ keyboard flag set early, ring bell
	kcc
	jmp serveL	/ bell rang, jump to other player's serve
LSet1,  ksf		
	jms bell	/ L set but no keyboard flag, ring bell
serveL,	ksf
	jms serve	/ bell rang, other player's serve
	cla cll
	kcc
	tad startLt	/ put 2000 in AC to start on left
loop2,	jms wait	
	cll rar	
	szl
	jmp LSet2	/ L set, skip zero-L handling instructions
	ksf
	jmp loop2	/ keep moving right
	jms bell	/ keyboard flag set early, ring bell
	jmp main	/ bell rang, other player's serve
LSet2,	ksf		
	jms bell	/ L set but no keyboard flag, ring bell
	ksf		
	jmp main	/ bell rang, jump to other player's serve
	kcc
	jmp serveR	/ no miss, rotate the other way
	
startRt,0002	
startLt,2000

	page
/ wait for an 'S' to be typed on the teletype
serve,	0
loop,	jms rdchar
	tad (-"S	/ is character an S?
	sza cla		
	jmp loop	/ no S, check again
	jmp i serve	

/ read next character to AC
rdchar,	0
	ksf		/ character ready to read?
	jmp .-1		/ no, keep trying
	krb		/ yes, read it
	jmp i rdchar

/ write character in AC
wrchar,	0
	tsf		/ printer ready?
	jmp .-1		/ no, keep waiting
	tls		/ yes, send character to printer
	kcc
	jmp i wrchar

/ ring bell on the teletype after a miss
bell,	0
	tls		/ set printer flag so we know it's ready
	cla		
	tad (207)	/ set acc to bell sound
	jms wrchar	
	jmp i bell

	page
/ wait for a period of time determined by the low 6 bits of the switch
/ register, while displaying the caller's contents of A in the console
/ lights
wait,	0		
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
	jmp i wait

loCount,0		/ low 12 bits of counter
hiCount,0		/ high 12 bits of counter	

