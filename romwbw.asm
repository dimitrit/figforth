; RomWBW extensions
;
; Last update:
;
; 200110 - initial version
;
;
;	RomWBW FUNCTIONS
;
CIOIN		.EQU	00H	; character input
CIOIST		.EQU    02H     ; character input status
;
RTCGETTIM	.EQU	20H	; RTC get time
RTCSETTIM	.EQU	21H	; RTC set time
;
VDARES		.EQU	42H	; video reset
VDASCP		.EQU	45H	; video set cursor position
;
CURCON		.EQU	80H	; 'current console' unit number
;
#DEFINE	HBIOS	RST	08
;
;
;	ROMWBW LOW LEVEL ROUTINES
;
	.BYTE	84H		; KEY? ( -- c t ¦ f )
	.TEXT	"KEY"		; Check if a key has been pressed. Returns false
	.BYTE	'?'+$80		; if no key has been pressed. If a key has been
	.WORD	ARROW-6		; pressed, returns true and the key's ascii code. 
KEYQ:	.WORD	$+2
	PUSH	BC
	LD	C,CURCON	
	LD	B,CIOIST
	HBIOS
	OR	A
	JR	NZ,KEYQ1
	POP	BC
	LD	HL,0
	JHPUSH
KEYQ1:	LD	C,CURCON
	LD	B,CIOIN
	HBIOS
	POP	BC
	LD	HL,0
	OR	A
	JR	NZ,KEYQ2 
	LD	L,1
	LD	D,0
	PUSH	DE
KEYQ2:	JHPUSH
;
	.BYTE	84H		; TIME ( -- addr )
	.TEXT	"TIM"		; Get the RTC time and leave the address of the 
	.BYTE	'E'+$80		; 6 byte date/time buffer, YMDHMS. Each byte is 
	.WORD	KEYQ-7		; BCD encoded.
TIME:	.WORD	$+2
	PUSH	BC
	LD	HL,ORIG+28H
	LD	B,RTCGETTIM
	HBIOS
	POP	BC
	LD	HL,ORIG+28H
	JHPUSH
;
	.BYTE	85H		; STIME ( addr -- )
	.TEXT	"STIM"		; Set the RTC time. addr is the address of the
	.BYTE	'E'+$80		; 6 byte date/time buffer, YMDHMS. Each byte is
	.WORD	TIME-7		; BCD encoded.
STIME:	.WORD	$+2
	POP	HL
	PUSH	BC
	LD	B,RTCSETTIM
	HBIOS
	POP	BC
	JNEXT
;
	.BYTE	83H		; CLS ( -- )
	.TEXT	"CL"		; Clear VDU screen.
	.BYTE	'S'+$80
	.WORD	STIME-8
CLS:	.WORD	$+2
	PUSH	BC
	LD	HL,(ORIG+26H)
	LD	C,L
	LD	B,VDARES
	HBIOS
	POP	BC
	JNEXT		
;
	.BYTE	82H		; AT ( col row -- )
	.BYTE	'A'		; Positions the text cursor at the given position.
	.BYTE	'T'+$80		; Both column and row positions are zero indexed,
	.WORD	CLS-6		; i.e. 0 0 AT will move the cursor to the top left.
SETPOS:	.WORD	$+2		; Note that AT does *not* update OUT.
	POP	HL
	POP	DE
	PUSH	BC
	LD	D,L
	LD	HL,(ORIG+26H)
	LD	C,L
	LD	B,VDASCP
	HBIOS
	POP	BC
	JNEXT
;
;	ROMWBW HIGH LEVEL ROUTINES
;
	.BYTE	82H		; .B ( n -- )
	.BYTE	'.'		; Print a BCD value, converted to decimal. No
	.BYTE	'B'+$80		; following blank is printed.
	.WORD	SETPOS-5
BCD:	.WORD	DOCOL
	.WORD	DUP
	.WORD	TWOSLA	
	.WORD	TWOSLA	
	.WORD	TWOSLA	
	.WORD	TWOSLA	
	.WORD	LIT,30H
	.WORD	PLUS
	.WORD	EMIT
	.WORD	LIT,0FH
	.WORD	ANDD
	.WORD	LIT,30H
	.WORD	PLUS
	.WORD	EMIT
	.WORD	SEMIS
;
;