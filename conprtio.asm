;  CP/M CONSOLE & PRINTER INTERFACE
;
; Last update:
;
; 850511 - Saved BC' prior to CP/M calls
; 841010 - Saved IX & IY prior to CP/M calls
; 840909 - Converted all BIOS calls to BDOS calls for compatibility
;          with CP/M 3.0
;
;
;
LSTOUT	.EQU	05H		;printer output
DCONIO	.EQU	06H		;direct console I/O
;
RUBOUT	.EQU	7FH
INPREQ	.EQU	0FFH		;DCONIO input request
;
EPRINT:	.BYTE	0		;printer flag
				;0=disabled, 1=enabled
;
SYSENT:	PUSH	BC
	PUSH	DE
	PUSH	HL
	PUSH	IX
	PUSH	IY
	exx
	push	bc		;save ip (if used as such)
	exx
	CALL	BDOSS		;perform function (C)
	exx
	pop	bc		;restore ip
	exx
	POP	IY
	POP	IX
	POP	HL
	POP	DE
	POP	BC
	RET
;
CSTAT:	PUSH	BC
	LD	C,DCONIO	;direct console I/O
	LD	E,INPREQ	;input request
	CALL	SYSENT		;any CHR typed?
	POP	BC		;if yes, (A)<--CHAR
	RET			;else    (A)<--00H (ignore CHR)
;
CIN:	PUSH	BC
	LD	C,DCONIO	;direct console I/O
	LD	E,INPREQ	;request input
CINLP:	CALL	SYSENT		;(A)<--CHR (or 0 if nothing typed)
	OR	A
	JR	Z,CINLP		;wait for CHR to be typed
	CP	RUBOUT
	JR	NZ,CIN0
	LD	A,BSOUT		;convert RUB to ^H
CIN0:	CP	HT
	JR	NZ,CIN1
	LD	A,ABL		;convert HT to space
CIN1:	RES	7,A		;(MSB)<--0
	POP	BC
	RET
;
COUT:	PUSH	BC
	PUSH	DE		;save (E) = CHR
	LD	C,DCONIO	;direct console output
	CALL	SYSENT		;send (E) to CON:
	POP	DE
	POP	BC
	RET
;
POUT:	PUSH	BC
	LD	C,LSTOUT
	CALL	SYSENT		;send (E) to LST:
	POP	BC
	RET
;
CPOUT:	CALL	COUT		;send (E) to console
	LD	A,(EPRINT)
	OR	A		;if (EPRINT) <> 0
	CALL	NZ,POUT		;send (E) to LST:
	RET
;
;	FORTH TO CP/M SERIAL I/O INTERFACE
;
PQTER:	CALL	CSTAT
	LD	HL,0
	OR	A		;CHR TYPED?
	JR	Z,PQTE1		;NO
	INC	L		;YES, (S1)<--TRUE
PQTE1:	JHPUSH
;
PKEY:	CALL	CIN		;READ CHR FROM CONSOLE
	CP	DLE		;^P?
	LD	E,A
	JR	NZ,PKEY1	;NO
	LD	HL,EPRINT
	LD	E,ABL		;(E)<--BLANK
	LD	A,(HL)
	XOR	01H		;TOGGLE (EPRINT) LSB
	LD	(HL),A
PKEY1:	LD	L,E
	LD	H,0
	JHPUSH			;(S1)LB<--CHR
;
PEMIT:	.WORD	$+2		;(EMIT) orphan
	POP	DE		;(E)<--(S1)LB = CHR
	LD	A,E
	CP	BSOUT
	JR	NZ,PEMIT1
	CALL	COUT		;backspace
	LD	E,ABL		;blank
	CALL	COUT		;erase CHR on CON:
	LD	E,BSOUT		;backspace
PEMIT1:	CALL	CPOUT		;send CHR to CON:
				;and LST: if (EPRINT)=01H
	JNEXT
;
PCR:	.WORD	$+2		; (CR) orphan
	LD	E,ACR
	CALL	CPOUT		;output CR
	LD	E,LF
	CALL	CPOUT		;and LF
	JNEXT
;
;
;
