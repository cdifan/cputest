
	move.l #$80002010,a1
	move.b #$4,7(a1)

PRINT_LOOP:
	move.b (a0)+,d0
	beq.s PRINT_DONE
	bsr.s PRINT_CHAR
	bra.s PRINT_LOOP

PRINT_CHAR:
	move.l #$80002010,a1

PRINT_WAIT:
	btst #2,3(a1)
	beq.s PRINT_WAIT
	move.b d0,9(a1)
	rts

PRINT_DONE:
	moveq #13,d0
	bsr.s PRINT_CHAR
	moveq #10,d0
	bsr.s PRINT_CHAR

