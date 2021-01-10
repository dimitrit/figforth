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
RTCGETTIM	.EQU	20H	; rtc get time
RTCSETTIM	.EQU	21H	; rtc set time
;
;
#DEFINE	HBIOS	RST	08
;
;
;
TBUF	.FILL	6,0
;
;	ROMWBW LOW LEVEL ROUTINES
;
	.BYTE	84H		; TIME ( -- addr )
	.TEXT	"TIM"		; Get the RTC time and leave the address of the 
	.BYTE	'E'+$80		; 6 byte date/time buffer, YMDHMS. Each byte is 
	.WORD	ARROW-6		; BCD encoded.
TIME:	.WORD	$+2
	EXX
	PUSH	BC
	LD	HL,TBUF
	LD	B,RTCGETTIM
	HBIOS
	POP	BC
	EXX
	LD	HL,TBUF
	JHPUSH
;
	.BYTE	85H		; STIME ( addr -- )
	.TEXT	"STIM"		; Set the RTC time. addr is the address of the
	.BYTE	'E'+$80		; 6 byte date/time buffer, YMDHMS. Each byte is
	.WORD	TIME-7		; BCD encoded.
STIME	.WORD	$+2
	EXX
	POP	HL
	PUSH	BC
	LD	B,RTCSETTIM
	HBIOS
	POP	BC
	EXX
	JNEXT
;
;	ROMWBW HIGH LEVEL ROUTINES
;

;
;