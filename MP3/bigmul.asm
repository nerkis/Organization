/ *********************
/ *                   *
/ *  Bignum Multiply  *
/ *                   *
/ *********************

	page
/ Signed multiply of bigWords source operands to 2*bigWords destination.
/ No restrictions on operand overlap
/	jms bigmul
/	-> -> sourceA
/	-> -> sourceB
/	-> -> destination	/ 2*bigWords

bigmul:	0
	jms	fetchArgs; 3; bigmul; srcA

/ Allocate and zero product
	sta2
	jms	bigpush
	dca	prod
	jms	bigset2; prod

/ Do the work
	jms	multiply

/ return product
	jms	bigcopy2; prod; dst

	sta2
	jms	bigpop

	jmp i	bigmul

srcA,	0	/ ->sourceA
srcB,	0	/ ->sourceB
dst,	0	/ ->destination
prod,	0	/ ->product on stack


multiply,0000
	tad (-bigWords		
	dca outCount		/ save count for outer loop
	tad srcB		
	dca srcBPtr		/ for traversing srcB indexes
	tad prod
	dca prodPtr		/ for traversing prod indexes

outLoop,tad i srcBPtr		/ get value of first srcB word
	isz srcBPtr
	sna
	jmp subEnd		/ if srcB word = 0, end this iteration
	dca operand		/ hold srcB value 
	tad (-bigWords		
	dca inCount		/ save count for inner loop
	tad srcA
	dca srcAPtr		/ for traversing srcA indexes
	tad prodPtr
	dca partProd		/ keep track of partial products
	dca carry

inLoop,	tad i srcAPtr		/ get value of first srcA word
	isz srcAPtr
	mql muy			/ if srcAPtr, load into MQ and multiply

operand,0000			
	swp			/ swap MQ and AC
	tad i partProd		/ get value of partial product
	dca i partProd		
	isz partProd
	mqa			/ if more partial products, or MQ into AC
	szl
	cll iac			/ if link not 0, clear it and AC = 1
	tad i partProd
	tad carry		/ add carry to partial product
	dca i partProd
	ral			
	dca carry		/ update carry
	isz inCount		
	jmp inLoop		/ if inCount not 0, continue loop

subEnd,	isz prodPtr
	isz outCount
	jmp outLoop		/ if outCount not 0, continue loop

	jmp i	multiply	/ return from subroutine
	-bigWords
	bigsub

outCount, 0	/ counter for outer loop
srcBPtr,  0	/ ->sourceB
prodPtr,  0	/ ->prod
inCount,  0	/ counter for inner loop
srcAPtr,  0	/ ->sourceA
partProd, 0	/ ->partial product
carry,	  0
