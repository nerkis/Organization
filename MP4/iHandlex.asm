/ ***********************
/ *                     *
/ *  Interrupt Handler  *
/ *                     *
/ ***********************

	page
/ Interrupt handler entry point. This code is used by all interrupts.
intHandle:
	0
	dca saveAC	/ save value of AC
	rar		/ rotate right to get L value into AC
	dca saveL	/ save value of link

	/ get MQ into AC and dca to saveMQ?

	pirc		/ check if clock interrupt
	tad (-1		/ pirc will return 1 if clock
	sna
	jms i clkHandle
	cla
	
	pirc		/ check if printer interrupt
	tad (-7		/ pirc will return 7 if clock
	sna
	jms i prntHandle
	cla

	hlt		/ for interrupts not dealt with?

	/ **** Your handlers can return here when done, and then you must:

	/ restore PDP-8 state
	/ put saveMQ into MQ
	cla cll
	tad saveL
	ral		/ rotate left to get value into L
	tad saveAC	/ restore AC

	ion
	jmp i 0		/ return to address stored at address 0


saveAC, 0	/ to save AC value
saveL, 	0	/ to save L value

/ interrupt handler addresses
clkHandle,  clock
prntHandle, print	

/ If you are using an interrupt vector, here is a good place to put it. The
/ value read into AC by pirc is:
/	 0: unused
/	 1: clock
/	 2: unused
/	 3: RF08 disc
/	 4: unused
/	 5: ASR33 keyboard
/	 6: unused
/	 7: ASR33 printer


/ *********************
/ *                   *
/ *  Clock Interrupt  *
/ *                   *
/ *********************

/ Here is a good place to put your clock interrupt handler. Increment clkLo,
/ and if it overflows increment clkHi. Both are already defined in izero.pal8.
/ You must also restart the clock, in the same way that ie.pal8 does at the
/ start of the program.

clock,	0
	clkcf		/ clear clock flag

	tad (clkPer	/ restart the clock
	ceil
	cla
/	dca clklo	/ zero clock--needed?

/ ***********************
/ *                     *
/ *  Printer Interrupt  *
/ *                     *
/ ***********************

/ Here is a good place to put your printer interrupt handler.
/ You can read a character from the print ring like this:
/
/	jms readRing; ptRing
/	/ returns here if ring was     empty, with AC = 0
/	/ returns here if ring was not empty, with character in AC

/ printer interrupt outline
/ read character from printer ring
/ ring empty?
/ if no, start character printing with tls
/ if yes, clear printer flag with tcf
/ 	"active" = false

/ *********************
/ *                   *
/ *  Write Character  *
/ *                   *
/ *********************

/ Here is a good place to put your write character subroutine.
/ You can write a character to the print ring like this:
/
/	/ put the character in AC
/	jms writeRing; ptRing
/	/ returns here if ring was     full, AC = 0
/	/ returns here if ring was not full, AC = 0
wrChar:	0

/ pong wrchar routine:
/wrchar,	0
/	tsf		/ printer ready?
/	jmp .-1		/ no, keep waiting
/	tls		/ yes, send character to printer
/	kcc
/	jmp i wrchar

/ write character outline
/ start, iof
/ active?
/ if no, ion, start character printing tls, active = true
/ if yes, write character to printer ring
/ 	ion
/ 	ring full?
/		if no, done
/ 		if yes, jmp start

/ active is a variable

/ ******************
/ *                *
/ *  Printer Ring  *
/ *                *
/ ******************

/ Initialize printer ring.
initPtRing:
	0
	dca	ptAct
	tcf
	tad	(200-ringStruct
	jms	initRing; ptRing
	jmp i	initPtRing

/ Allocate space for ring
	page
ptRing:	0	/ one entire page
	page
