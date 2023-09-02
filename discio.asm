;  CP/M DISC INTERFACE
;
; Last update:
;
; 201212 - added FILE
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
DEFFCB	.EQU	005CH		;default FCB
;
;	CP/M FUNCTIONS
;
OPNFIL	.EQU	0FH		;open file
CLSFIL	.EQU	10H		;close file
SETDMA	.EQU	1AH		;set DMA address
WRTRND	.EQU	22H		;write random
;
MAXLEN	.EQU	08H		;max filename length
FTLEN	.EQU	03H		;filetype length
;
;	FORTH variables & constants used in disc interface
;
	.BYTE	83H		;FCB (current FCB address)
	.TEXT	"FC"
	.BYTE	'B'+$80
	.WORD	PTSTO-5
FCB:	.WORD	DOCON,DEFFCB
;
	.BYTE	84H		;REC# (returns address of random rec.#)
	.TEXT	"REC"
	.BYTE	'#'+$80
	.WORD	FCB-6
RECADR:	.WORD	DOCOL,FCB
	.WORD	LIT,21H
	.WORD	PLUS
	.WORD	SEMIS
;
	.BYTE	83H		;USE
	.TEXT	"US"
	.BYTE	'E'+$80
	.WORD	RECADR-7
USE:	.WORD	DOVAR,0		;/ initialised by CLD
;
	.BYTE	84H		;PREV
	.TEXT	"PRE"
	.BYTE	'V'+$80
	.WORD	USE-6
PREV:	.WORD	DOVAR,0		;/ initialised by CLD
;
	.BYTE	85H		;#BUFF
	.TEXT	"#BUF"
	.BYTE	'F'+$80
	.WORD	PREV-07H
NOBUF:	.WORD	DOCON,NBUF
;
	.BYTE	8AH		;DISK-ERROR
	.TEXT	"DISK-ERRO"
	.BYTE	'R'+$80
	.WORD	NOBUF-08H
DSKERR:	.WORD	DOVAR,0
;
;	DISC INTERFACE HIGH LEVEL ROUTINES
;
	.BYTE	84H		;+BUF
	.TEXT	"+BU"
	.BYTE	'F'+$80
	.WORD	DSKERR-0DH
PBUF:	.WORD	DOCOL
	.WORD	LIT,CO
	.WORD	PLUS,DUP
	.WORD	LIMIT,EQUAL
	.WORD	ZBRAN
	.WORD	PBUF1-$
	.WORD	DROP,FIRST
PBUF1:	.WORD	DUP,PREV
	.WORD	AT,SUBB
	.WORD	SEMIS
;
	.BYTE	86H		;UPDATE
	.TEXT	"UPDAT"
	.BYTE	'E'+$80
	.WORD	PBUF-07H
UPDAT:	.WORD	DOCOL,PREV
	.WORD	AT,AT
	.WORD	LIT,8000H
	.WORD	ORR
	.WORD	PREV,AT
	.WORD	STORE,SEMIS
;
	.BYTE	8DH		;EMPTY-BUFFERS
	.TEXT	"EMPTY-BUFFER"
	.BYTE	'S'+$80
	.WORD	UPDAT-9
MTBUF:	.WORD	DOCOL,FIRST
	.WORD	LIMIT,OVER
	.WORD	SUBB,ERASEE
	.WORD	SEMIS
;
	.BYTE	83H		;DR0
	.TEXT	"DR"
	.BYTE	'0'+$80
	.WORD	MTBUF-10H
DRZER:	.WORD	DOCOL
	.WORD	ZERO
	.WORD	OFSET,STORE
	.WORD	SEMIS
;
	.BYTE	83H		;DR1
	.TEXT	"DR"
	.BYTE	'1'+$80
	.WORD	DRZER-6
DRONE:	.WORD	DOCOL
	.WORD	LIT,1600	;Osborne DD
DRON2:	.WORD	OFSET,STORE
	.WORD	SEMIS
;
	.BYTE	86H		;BUFFER
	.TEXT	"BUFFE"
	.BYTE	'R'+$80
	.WORD	DRONE-6
BUFFE:	.WORD	DOCOL,USE
	.WORD	AT,DUP
	.WORD	TOR
BUFF1:	.WORD	PBUF		; won't work if single buffer
	.WORD	ZBRAN
	.WORD	BUFF1-$
	.WORD	USE,STORE
	.WORD	RR,AT
	.WORD	ZLESS
	.WORD	ZBRAN
	.WORD	BUFF2-$
	.WORD	RR,TWOP
	.WORD	RR,AT
	.WORD	LIT,7FFFH
	.WORD	ANDD,ZERO
	.WORD	RSLW
BUFF2:	.WORD	RR,STORE
	.WORD	RR,PREV
	.WORD	STORE,FROMR
	.WORD	TWOP,SEMIS
;
	.BYTE	85H		;BLOCK
	.TEXT	"BLOC"
	.BYTE	'K'+$80
	.WORD	BUFFE-9
BLOCK:	.WORD	DOCOL,OFSET
	.WORD	AT,PLUS
	.WORD	TOR,PREV
	.WORD	AT,DUP
	.WORD	AT,RR
	.WORD	SUBB
	.WORD	DUP,PLUS
	.WORD	ZBRAN
	.WORD	BLOC1-$
BLOC2:	.WORD	PBUF,ZEQU
	.WORD	ZBRAN
	.WORD	BLOC3-$
	.WORD	DROP,RR
	.WORD	BUFFE,DUP
	.WORD	RR,ONE
	.WORD	RSLW
	.WORD	TWOMIN		;/
BLOC3:	.WORD	DUP,AT
	.WORD	RR,SUBB
	.WORD	DUP,PLUS
	.WORD	ZEQU
	.WORD	ZBRAN
	.WORD	BLOC2-$
	.WORD	DUP,PREV
	.WORD	STORE
BLOC1:	.WORD	FROMR,DROP
	.WORD	TWOP,SEMIS
;
	.BYTE	84H		;BDOS  (CP/M function call)
	.TEXT	"BDO"
	.BYTE	'S'+$80
	.WORD	BLOCK-8
BDOS:	.WORD	$+2
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
	.BYTE	83H		;R/W
	.TEXT	"R/"
	.BYTE	'W'+$80
	.WORD	BDOS-07H
RSLW:	.WORD	DOCOL
	.WORD	TOR		;store R/W flag
	.WORD	RECADR,STORE
	.WORD	ZERO,RECADR	;set record #
	.WORD	TWOP,CSTOR
	.WORD	LIT,SETDMA
	.WORD	BDOS,DROP	;set DMA address
	.WORD	LIT,WRTRND
	.WORD	FROMR,SUBB	;select READ or WRITE
	.WORD	FCB,SWAP
	.WORD	BDOS		;do it
	.WORD	DSKERR,STORE	;store return code
	.WORD	SEMIS
;
	.BYTE	85H		;FLUSH
	.TEXT	"FLUS"
	.BYTE	'H'+$80
	.WORD	RSLW-6
FLUSH:	.WORD	DOCOL
	.WORD	NOBUF,ONEP
	.WORD	ZERO,XDO
FLUS1:	.WORD	ZERO,BUFFE
	.WORD	DROP
	.WORD	XLOOP
	.WORD	FLUS1-$
	.WORD	SEMIS
;
	.BYTE	86h			;/ EXTEND
	.TEXT	"EXTEN"
	.BYTE	'D'+$80
	.WORD	FLUSH-08h
EXTEND:
	.WORD	DOCOL
	.WORD	HERE			;/ fill with b/buf blanks
	.WORD	BBUF
	.WORD	BLANK
	.WORD	LIT
	.WORD	0008h
	.WORD	STAR
	.WORD	ZERO
EXTND1:
	.WORD	ONEP			; begin
	.WORD	HERE			;/ was lit,f000h (Osborne video ram)
	.WORD	OVER
	.WORD	ONE
	.WORD	RSLW
	.WORD	DSKERR
	.WORD	AT
	.WORD	ZBRAN
	.WORD	EXTND1-$		; until
	.WORD	SWAP
	.WORD	OVER
	.WORD	PLUS
	.WORD	SWAP
	.WORD	XDO			; do
EXTND2:
	.WORD	HERE			;/ was lit,f000h (Osborne video ram)
	.WORD	IDO
	.WORD	ZERO
	.WORD	RSLW
	.WORD	XLOOP
	.WORD	EXTND2-$		; loop
	.WORD	FCB
	.WORD	LIT
	.WORD	CLSFIL
	.WORD	BDOS			; close file
	.WORD	DROP			; discard return code
	.WORD	FOPEN
	.WORD	DROP
	.WORD	SEMIS
;
	.WORD	85H
	.TEXT	"FOPE"			; FOPEN ( --- f )
	.BYTE	'N'+$80			; Opens a file that currently exists in the
	.WORD	EXTEND-9		; disk directory for the currently active
FOPEN	.WORD	DOCOL			; user number. A true flag indicates failure.
	.WORD	FCB
	.WORD	LIT,OPNFIL		; open file
	.WORD	BDOS
	.WORD	LIT,0FFH		; check for error
	.WORD	EQUAL
	.WORD	DUP
	.WORD	ZEQU
	.WORD	WARN,STORE		; set WARNING variable
	.WORD	SEMIS
;
	.BYTE	85H
	.TEXT	"FTYP"			; FTYPE ( --- addr )
	.BYTE	'E'+$80			; Returns address of file type used
	.WORD	FOPEN-8			; with FILE.
FTYPE	.WORD	DOCON,DEFFT
DEFFT	.TEXT	"SCR"			; default file type
;
	.BYTE	84H			; FILE used in the form 
	.TEXT	"FIL"			;     FILE cccc
	.BYTE	'E'+$80			; Closes the current file and attempts
	.WORD	FTYPE-08H		; to open the file with the given name.
FILE:	.WORD	DOCOL			; The file type is determined by FTYPE.
	.WORD	FCB
	.WORD	LIT,CLSFIL		; close existing file
	.WORD	BDOS
	.WORD	DROP
	.WORD	MTBUF			; clear buffer
	.WORD	FCB			; clear FCB
	.WORD	LIT,10H
	.WORD	ZERO
	.WORD	FILL			
	.WORD	BL,WORD			; get filename
	.WORD	HERE
	.WORD	COUNT
	.WORD	LIT,MAXLEN	
	.WORD	MIN			; truncate filename if required
	.WORD	FCB
	.WORD	ONEP
	.WORD	DUP
	.WORD	LIT,MAXLEN
	.WORD	BLANK			; blank filename in fcb
	.WORD	FTYPE
	.WORD	OVER
	.WORD	LIT,MAXLEN
	.WORD	PLUS
	.WORD	LIT,FTLEN
	.WORD	CMOVE			; set file type
	.WORD	SWAP
	.WORD	CMOVE
	.WORD	FOPEN
	.WORD	LIT,8
	.WORD	QERR	
	.WORD	SEMIS
;
	.BYTE	84H			;LOAD
	.TEXT	"LOA"
	.BYTE	'D'+$80
	.WORD	FILE-07H
LOAD:	.WORD	DOCOL,BLK
	.WORD	AT,TOR
	.WORD	INN,AT
	.WORD	TOR,ZERO
	.WORD	INN,STORE
	.WORD	BSCR,STAR
	.WORD	BLK,STORE		;BLK <-- SCR * B/SCR
	.WORD	INTER			;INTERPRET FROM OTHER SCREEN
	.WORD	FROMR,INN
	.WORD	STORE
	.WORD	FROMR,BLK
	.WORD	STORE,SEMIS
;
	.BYTE	0C3H			;-->
	.TEXT	"--"
	.BYTE	'>'+$80
	.WORD	LOAD-7
ARROW:	.WORD	DOCOL,QLOAD
	.WORD	ZERO
	.WORD	INN,STORE
	.WORD	BSCR,BLK
	.WORD	AT,OVER
	.WORD	MODD,SUBB
	.WORD	BLK,PSTOR
	.WORD	SEMIS
;
;
;
