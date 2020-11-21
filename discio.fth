;  CP/M DISC INTERFACE
;
; Last update:
;
; 881228 - EXTEND's R/W address now initialized with blanks
; 860120 - EXTEND's R/W address now HERE, was Osborne video ram
; 850511 - saved BC' in 'BDOS'
; 850227 - saved index regs. in 'BDOS'
; 840812 - added EXTEND
; 840731 - installed BDOS calls
;
;
; CP/M BDOS CALLS USED (as per Albert van der Horst, HCCH)
;
; R/W reads or writes a sector in the file specified when invoking
; Z80 fig-FORTH (A>Z80FORTH d:filename.ext), using the default FCB.
; More than one disc may be accessed by temporary use of a user de-
; fined FCB.
;
;
;
DEFFCB	EQU	005CH		;default FCB
;
;	CP/M FUNCTIONS
;
OPNFIL	EQU	0FH		;open file
CLSFIL	EQU	10H		;close file
SETDMA	EQU	1AH		;set DMA address
WRTRND	EQU	22H		;write random
;
;
;	FORTH variables & constants used in disc interface
;
	DEFB	83H		;FCB (current FCB address)
	DM	'FCB'
	DEFW	PTSTO-5
FCB:	DEFW	DOCON,DEFFCB
;
	DEFB	84H		;REC# (returns address of random rec.#)
	DM	'REC#'
	DEFW	FCB-6
RECADR:	DEFW	DOCOL,FCB
	DEFW	LIT,21H
	DEFW	PLUS
	DEFW	SEMIS
;
	DEFB	83H		;USE
	DM	'USE'
	DEFW	RECADR-7
USE:	DEFW	DOVAR,0		;/ initialised by CLD
;
	DEFB	84H		;PREV
	DM	'PREV'
	DEFW	USE-6
PREV:	DEFW	DOVAR,0		;/ initialised by CLD
;
	DEFB	85H		;#BUFF
	DM	'#BUFF'
	DEFW	PREV-07H
NOBUF:	DEFW	DOCON,NBUF
;
	DEFB	8AH		;DISK-ERROR
	DM	'DISK-ERROR'
	DEFW	NOBUF-08H
DSKERR:	DEFW	DOVAR,0
;
;	DISC INTERFACE HIGH LEVEL ROUTINES
;
	DEFB	84H		;+BUF
	DM	'+BUF'
	DEFW	DSKERR-0DH
PBUF:	DEFW	DOCOL
	DEFW	LIT,CO
	DEFW	PLUS,DUP
	DEFW	LIMIT,EQUAL
	DEFW	ZBRAN,PBUF1-$
	DEFW	DROP,FIRST
PBUF1:	DEFW	DUP,PREV
	DEFW	AT,SUBB
	DEFW	SEMIS
;
	DEFB	86H		;UPDATE
	DM	'UPDATE'
	DEFW	PBUF-07H
UPDAT:	DEFW	DOCOL,PREV
	DEFW	AT,AT
	DEFW	LIT,8000H
	DEFW	ORR
	DEFW	PREV,AT
	DEFW	STORE,SEMIS
;
	DEFB	8DH		;EMPTY-BUFFERS
	DM	'EMPTY-BUFFERS'
	DEFW	UPDAT-9
MTBUF:	DEFW	DOCOL,FIRST
	DEFW	LIMIT,OVER
	DEFW	SUBB,ERASEE
	DEFW	SEMIS
;
	DEFB	83H		;DR0
	DM	'DR0'
	DEFW	MTBUF-10H
DRZER:	DEFW	DOCOL
	DEFW	ZERO
	DEFW	OFSET,STORE
	DEFW	SEMIS
;
	DEFB	83H		;DR1
	DM	'DR1'
	DEFW	DRZER-6
DRONE:	DEFW	DOCOL
	DEFW	LIT,1600	;Osborne DD
DRON2:	DEFW	OFSET,STORE
	DEFW	SEMIS
;
	DEFB	86H		;BUFFER
	DM	'BUFFER'
	DEFW	DRONE-6
BUFFE:	DEFW	DOCOL,USE
	DEFW	AT,DUP
	DEFW	TOR
BUFF1:	DEFW	PBUF		;won't work if single buffer
	DEFW	ZBRAN,BUFF1-$
	DEFW	USE,STORE
	DEFW	RR,AT
	DEFW	ZLESS
	DEFW	ZBRAN,BUFF2-$
	DEFW	RR,TWOP
	DEFW	RR,AT
	DEFW	LIT,7FFFH
	DEFW	ANDD,ZERO
	DEFW	RSLW
BUFF2:	DEFW	RR,STORE
	DEFW	RR,PREV
	DEFW	STORE,FROMR
	DEFW	TWOP,SEMIS
;
	DEFB	85H		;BLOCK
	DM	'BLOCK'
	DEFW	BUFFE-9
BLOCK:	DEFW	DOCOL,OFSET
	DEFW	AT,PLUS
	DEFW	TOR,PREV
	DEFW	AT,DUP
	DEFW	AT,RR
	DEFW	SUBB
	DEFW	DUP,PLUS
	DEFW	ZBRAN,BLOC1-$
BLOC2:	DEFW	PBUF,ZEQU
	DEFW	ZBRAN,BLOC3-$
	DEFW	DROP,RR
	DEFW	BUFFE,DUP
	DEFW	RR,ONE
	DEFW	RSLW
	DEFW	TWOMIN		;/
BLOC3:	DEFW	DUP,AT
	DEFW	RR,SUBB
	DEFW	DUP,PLUS
	DEFW	ZEQU
	DEFW	ZBRAN,BLOC2-$
	DEFW	DUP,PREV
	DEFW	STORE
BLOC1:	DEFW	FROMR,DROP
	DEFW	TWOP,SEMIS
;
	DEFB	84H		;BDOS  (CP/M function call)
	DM	'BDOS'
	DEFW	BLOCK-8
BDOS:	DEFW	$+2
	EXX			;SAVE IP
	POP	BC		;(C) <-- (S1)LB = CP/M function code
	POP	DE		;(DE) <-- (S2)  = parameter
	push	ix		;/
	push	iy		;/
	exx
	push	bc		;/ save ip
	exx
	CALL	BDOSS		;return value in A
	exx
	pop	bc		;restore ip
	exx
	pop	iy		;/
	pop	ix		;/
	EXX			;restore IP
	LD	L,A
	LD	H,00H
	JHPUSH			;(S1) <-- (HL) = returned value
;
	DEFB	83H		;R/W
	DM	'R/W'
	DEFW	BDOS-07H
RSLW:	DEFW	DOCOL
	DEFW	TOR		;store R/W flag
	DEFW	RECADR,STORE
	DEFW	ZERO,RECADR	;set record #
	DEFW	TWOP,CSTOR
	DEFW	LIT,SETDMA
	DEFW	BDOS,DROP	;set DMA address
	DEFW	LIT,WRTRND
	DEFW	FROMR,SUBB	;select READ or WRITE
	DEFW	FCB,SWAP
	DEFW	BDOS		;do it
	DEFW	DSKERR,STORE	;store return code
	DEFW	SEMIS
;
	DEFB	85H		;FLUSH
	DM	'FLUSH'
	DEFW	RSLW-6
FLUSH:	DEFW	DOCOL
	DEFW	NOBUF,ONEP
	DEFW	ZERO,XDO
FLUS1:	DEFW	ZERO,BUFFE
	DEFW	DROP
	DEFW	XLOOP,FLUS1-$
	DEFW	SEMIS
;
;
	defb	86h			;/ EXTEND
	dm	'EXTEND'
	defw	flush-08h
extend:
	defw	docol
	defw	here			;/ fill with b/buf blanks
	defw	bbuf
	defw	blank
	defw	lit
	defw	0008h
	defw	star
	defw	zero
extnd1:
	defw	onep			; begin
	defw	here			;/ was lit,f000h (Osborne video ram)
	defw	over
	defw	one
	defw	rslw
	defw	dskerr
	defw	at
	defw	zbran
	defw	extnd1-$		; until
	defw	swap
	defw	over
	defw	plus
	defw	swap
	defw	xdo			; do
extnd2:
	defw	here			;/ was lit,f000h (Osborne video ram)
	defw	ido
	defw	zero
	defw	rslw
	defw	xloop
	defw	extnd2-$		; loop
	defw	fcb
	defw	lit
	defw	clsfil
	defw	bdos			; close file
	defw	drop			; discard return code
	defw	fcb
	defw	lit
	defw	opnfil
	defw	bdos			; & re-open
	defw	drop			; discard return code
	defw	semis
;
;
	DEFB	84H		;LOAD
	DM	'LOAD'
	DEFW	EXTEND-09H
LOAD:	DEFW	DOCOL,BLK
	DEFW	AT,TOR
	DEFW	INN,AT
	DEFW	TOR,ZERO
	DEFW	INN,STORE
	DEFW	BSCR,STAR
	DEFW	BLK,STORE	;BLK <-- SCR * B/SCR
	DEFW	INTER		;INTERPRET FROM OTHER SCREEN
	DEFW	FROMR,INN
	DEFW	STORE
	DEFW	FROMR,BLK
	DEFW	STORE,SEMIS
;
	DEFB	0C3H		;-->
	DM	'-->'
	DEFW	LOAD-7
ARROW:	DEFW	DOCOL,QLOAD
	DEFW	ZERO
	DEFW	INN,STORE
	DEFW	BSCR,BLK
	DEFW	AT,OVER
	DEFW	MODD,SUBB
	DEFW	BLK,PSTOR
	DEFW	SEMIS
;
;
;
