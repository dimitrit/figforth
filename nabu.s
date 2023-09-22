
SCR#0
  0
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
 11
 12
 13
 14
 15

SCR#1
  0              * N A B U   F O R T H *
  1
  2       THIS FORTH IMPLEMENTATION IS BASED ON
  3          THE fig-FORTH MODEL COURTESY OF
  4           THE FORTH INTEREST GROUP, 1979
  5             AND TI FORTH, COURTESY OF
  6              TEXAS INSTRUMENTS, 1983.
  7
  8    FOR INFORMATION AND DOCUMENTATION REFER TO:
  9
 10       HTTPS://GITHUB.COM/DIMITRIT/FIGFORTH
 11
 12 FURTHER DISTRIBUTION MUST INCLUDE THE ABOVE NOTICE.
 13
 14
 15

SCR#2
  0 **********************  fig-FORTH  MODEL  **********************
  1
  2                      Through the courtesy of
  3
  4                       FORTH INTEREST GROUP
  5                          P. O. BOX 1105
  6                      SAN CARLOS, CA. 94070
  7
  8
  9                            RELEASE 1
 10                      WITH COMPILER SECURITY
 11                              AND
 12                       VARIABLE LENGTH NAMES
 13
 14
 15         Further distribution must include the above notice.

SCR#3
  0
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
 11
 12
 13
 14
 15

SCR#4
  0 (  ERROR MESSAGES  )
  1 EMPTY STACK
  2 DICTIONARY FULL
  3 HAS INCORRECT ADDRESS MODE
  4 ISN'T UNIQUE
  5
  6 DISC RANGE ?
  7 FULL STACK
  8 DISC ERROR !
  9
 10
 11
 12
 13
 14
 15 FORTH INTEREST GROUP                                 MAY 1, 1979

SCR#5
  0 (  ERROR MESSAGES  )
  1 COMPILATION ONLY, USE IN DEFINITION
  2 EXECUTION ONLY
  3 CONDITIONALS NOT PAIRED
  4 DEFINITON NOT FINISHED
  5 IN PROTECTED DICTIONARY
  6 USE ONLY WHEN LOADING
  7 DECLARE VOCABULARY
  8 OFF CURRENT EDITING SCREEN
  9
 10
 11
 12
 13
 14
 15 FORTH INTEREST GROUP                                 MAY 1, 1979

SCR#6
  0
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
 11
 12
 13
 14
 15

SCR#7
  0 ( fig-FORTH EDITOR V2.0 SCR 1 of 6)
  1 FORTH DEFINITIONS HEX
  2 : TEXT   HERE C/L 1+ BLANKS WORD HERE PAD C/L 1+ CMOVE ;
  3 : LINE   DUP FFF0 AND 17 ?ERROR SCR @ (LINE) DROP ;
  4 : 2DROP   DROP DROP ;
  5 : 2SWAP   ROT >R ROT R> ;
  6 VOCABULARY EDITOR IMMEDIATE HEX
  7 : WHERE  DUP B/SCR / DUP SCR ! ." SCR # " DECIMAL .
  8          SWAP C/L /MOD C/L * ROT BLOCK + CR C/L TYPE CR
  9          HERE C@ - SPACES 5E EMIT [COMPILE] EDITOR QUIT ;
 10 -->
 11
 12
 13
 14
 15

SCR#8
  0 ( fig-FORTH EDITOR V2.0 SCR 2 of 6)
  1 EDITOR DEFINITIONS HEX    0 R# !
  2 : #LOCATE  R# @ C/L /MOD ;
  3 : #LEAD    #LOCATE LINE SWAP ;
  4 : #LAG     #LEAD DUP >R + C/L R> - ;
  5 : -MOVE    LINE C/L CMOVE UPDATE ;
  6 : H        LINE PAD 1+ C/L DUP PAD C! CMOVE ;
  7 : E        LINE C/L BLANKS UPDATE ;
  8 : S        DUP 1- 0E DO I LINE I 1+ -MOVE -1 +LOOP E ;
  9 : D        DUP H 0F DUP ROT DO I 1+ LINE I -MOVE LOOP E ;
 10 : M        R# +! CR SPACE #LEAD TYPE 5F EMIT #LAG TYPE #LOCATE
 11            . DROP ;
 12 : T        DUP C/L * R# ! H 0 M ;
 13 -->
 14
 15

SCR#9
  0 ( fig-FORTH EDITOR V2.0 SCR 3 of 6)
  1 : L     SCR @ LIST 0 M ;
  2 : R     PAD 1+ SWAP -MOVE ;
  3 : P     1 TEXT R ;
  4 : I     DUP S R ;
  5 : TOP   0 R# ! ;
  6 : CLEAR SCR ! 10 0 DO FORTH I EDITOR E LOOP ;
  7 : COPY     ( source target --- )
  8   FORTH B/SCR * SWAP B/SCR * SWAP     ( compute 1st buffers)
  9   B/SCR 0 DO DUP I + BUFFER DROP LOOP   ( reserve buffers)
 10   B/SCR 0 DO
 11           OVER I + BLOCK OVER I + BLOCK B/BUF CMOVE UPDATE
 12           LOOP
 13   DROP DROP FLUSH EDITOR ;
 14
 15 -->

SCR#10
  0 ( fig-FORTH EDITOR V2.0 SCR 4 of 6)
  1 : -TEXT  SWAP -DUP IF OVER + SWAP
  2          DO DUP C@ FORTH I C@ - IF 0= LEAVE ELSE 1+ THEN LOOP
  3          ELSE DROP 0= THEN ;
  4 : MATCH  >R >R 2DUP R> R> 2SWAP OVER + SWAP DO 2DUP FORTH
  5          I -TEXT IF >R 2DROP R> - I SWAP - 0 SWAP 0 0 LEAVE THEN
  6          LOOP 2DROP SWAP 0= SWAP ;
  7 : 1LINE  #LAG PAD COUNT MATCH R# +! ;
  8 : FIND   BEGIN 3FF R# @ < IF TOP PAD HERE C/L 1+ CMOVE 0
  9          ERROR ENDIF 1LINE UNTIL ;
 10 -->
 11
 12
 13
 14
 15

SCR#11
  0 ( fig-FORTH EDITOR V2.0 SCR 5 of 6)
  1 : DELETE  >R #LAG + FORTH R - #LAG R MINUS R# +! #LEAD + SWAP
  2           CMOVE R> BLANKS UPDATE ;
  3 : N       FIND 0 M ;
  4 : F       1 TEXT N ;
  5 : B       PAD C@ MINUS M ;
  6 : X       1 TEXT FIND PAD C@ DELETE 0 M ;
  7 : TILL    #LEAD + 1 TEXT 1LINE 0= 0 ?ERROR #LEAD + SWAP -
  8           DELETE 0 M ;
  9 -->
 10
 11
 12
 13
 14
 15

SCR#12
  0 ( fig-FORTH EDITOR V2.0 SCR 6 of 6)
  1 : C      1 TEXT PAD COUNT #LAG ROT OVER MIN >R FORTH R R# +!
  2          R - >R DUP HERE R CMOVE HERE #LEAD + R> CMOVE R>
  3          CMOVE UPDATE 0 M ;
  4 : TS      10 0 DO FORTH I EDITOR T LOOP TOP ;
  5 FORTH DEFINITIONS DECIMAL
  6 LATEST 12 +ORIGIN !
  7 HERE   28 +ORIGIN !
  8 HERE   30 +ORIGIN !
  9 ' EDITOR 6 + 32 +ORIGIN !
 10 HERE FENCE !
 11 ;S
 12
 13
 14
 15

SCR#13
  0
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
 11
 12
 13
 14
 15

SCR#14
  0 ( DEBUG SCR 1 of 2)  0 VARIABLE BASE'
  1  : <HEX   BASE @ BASE' ! HEX ;       ( 0/1  SWITCH TO HEX)
  2  : HEX>   BASE' @ BASE !     ;       ( 1/0  AND BACK)
  3  (        1/0  PRINT IN HEX REGARDLESS OF BASE)
  4  : H.     <HEX 0 <# # # # # #> TYPE SPACE HEX> ;
  5  (        1/0  IDEM FOR A SINGLE BYTE)
  6  : B.     <HEX 0 <# # # #> TYPE HEX> ;
  7  : BASE?  BASE @ H. ;                ( 0/0 TRUE VALUE OF BASE)
  8  : ^      ( 0/0 NON DESTRUCTIVE STACK PRINT)
  9           CR ." S: " SP@ S0 @ ( FIND LIMITS)
 10           BEGIN OVER OVER = 0=
 11           WHILE 2 - DUP @ H.
 12           REPEAT
 13           DROP DROP
 14  ;
 15                                                 -->

SCR#15
  0 ( DEBUG SCR 2 of 2)  <HEX
  1  :  DUMP   ( 2/0  DUMPS FROM ADDRESS-2 AMOUNT-1 BYTES)
  2            OVER + SWAP FFF0 AND
  3            DO
  4               CR I H. ." : "
  5               I
  6               10 0 DO
  7                  DUP I + C@ B.
  8                  I 2 MOD IF SPACE THEN
  9               LOOP
 10               1B EMIT 67 EMIT
 11               10 0 DO DUP I + C@ EMIT LOOP
 12               1B EMIT 47 EMIT
 13               DROP
 14            10 +LOOP         CR
 15  ;

SCR#16
  0
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
 11
 12
 13
 14
 15

SCR#17
  0 ( fig-FORTH 8080 Assembler with Z80 extensions       SCR 1 of 5)
  1
  2 HEX VOCABULARY ASSEMBLER IMMEDIATE
  3 ' ASSEMBLER CFA ' ;CODE 0A + !
  4 : CODE   ?EXEC CREATE [COMPILE] ASSEMBLER !CSP ; IMMEDIATE
  5 : C;     CURRENT @ CONTEXT ! ?EXEC ?CSP SMUDGE ; IMMEDIATE
  6 : LABEL  ?EXEC 0 VARIABLE  SMUDGE -2 ALLOT
  7          [COMPILE] ASSEMBLER !CSP ; IMMEDIATE
  8 : 8*     DUP + DUP + DUP + ;
  9
 10 ASSEMBLER DEFINITIONS
 11 -->
 12
 13
 14
 15

SCR#18
  0 ( fig-FORTH 8080 Assembler with Z80 extensions       SCR 2 of 5)
  1
  2 4 CONSTANT H   5 CONSTANT L   7 CONSTANT A   6 CONSTANT PSW
  3 2 CONSTANT D   3 CONSTANT E   0 CONSTANT B   1 CONSTANT C
  4 6 CONSTANT M   6 CONSTANT SP
  5
  6 : 1MI   <BUILDS C, DOES> C@ C, ;
  7 : 2MI   <BUILDS C, DOES> C@ + C, ;
  8 : 3MI   <BUILDS C, DOES> C@ SWAP 8* + C, ;
  9 : 4MI   <BUILDS C, DOES> C@ C, C, ;
 10 : 5MI   <BUILDS C, DOES> C@ C, , ;
 11 -->
 12
 13
 14
 15

SCR#19
  0 ( fig-FORTH 8080 Assembler with Z80 extensions       SCR 3 of 5)
  1
  2 00 1MI NOP   76 1MI HLT   F3 1MI DI    FB 1MI EI    07 1MI RLC
  3 0F 1MI RRC   17 1MI RAL   1F 1MI RAR   E9 1MI PCHL  F9 1MI SPHL
  4 E3 1MI XTHL  EB 1MI XCHG  27 1MI DAA   2F 1MI CMA   37 1MI STC
  5 3F 1MI CMC   08 1MI EXAF  D9 1MI EXX   C0 1MI RNZ   C8 1MI RZ
  6 D0 1MI RNC   D8 1MI RC    E0 1MI RPO   E8 1MI RPE   F0 1MI RP
  7 F8 1MI RM    C9 1MI RET
  8
  9 80 2MI ADD   88 2MI ADC   90 2MI SUB   98 2MI SBB   A0 2MI ANA
 10 A8 2MI XRA   B0 2MI ORA   B8 2MI CMP
 11
 12 09 3MI DAD   C1 3MI POP   C5 3MI PUSH  02 3MI STAX  0A 3MI LDAX
 13 04 3MI INR   05 3MI DCR   03 3MI INX   0B 3MI DCX   C7 3MI RST
 14 -->
 15

SCR#20
  0 ( fig-FORTH 8080 Assembler with Z80 extensions       SCR 4 of 5)
  1
  2 D3 4MI OUT   DB 4MI IN    C6 4MI ADI   CE 4MI ACI   D6 4MI SUI
  3 DE 4MI SBI   E6 4MI ANI   EE 4MI XRI   F6 4MI ORI   FE 4MI CPI
  4
  5 22 5MI SHLD  2A 5MI LHLD  32 5MI STA   3A 5MI LDA   C4 5MI CNZ
  6 CC 5MI CZ    D4 5MI CNC   DC 5MI CC    E4 5MI CPO   EC 5MI CPE
  7 F4 5MI CP    FC 5MI CM    CD 5MI CALL  C3 5MI JMP
  8
  9 C2 CONSTANT 0=  D2 CONSTANT CS  E2 CONSTANT PE  F2 CONSTANT 0<
 10
 11 : NOT   8 + ;            : MOV   8* 40 + + C, ;
 12 : MVI   8* 6 + C, C, ;   : LXI   8* 1+ C, , ;
 13 : PCIX  DD C, E9 C,  ;   : PCIY  FD C, E9 C, ;
 14 -->
 15

SCR#21
  0 ( fig-FORTH 8080 Assembler with Z80 extensions       SCR 5 of 5)
  1
  2 : ENDIF   2 ?PAIRS HERE SWAP ! ;
  3 : THEN    [COMPILE] ENDIF ;
  4 : IF      C, HERE 0 , 2 ;
  5 : ELSE    2 ?PAIRS C3 IF ROT SWAP ENDIF 2 ;
  6 : BEGIN   HERE 1 ;
  7 : UNTIL   SWAP 1 ?PAIRS C, , ;
  8 : AGAIN   1 ?PAIRS C3 C, , ;
  9 : WHILE   IF 2+ ;
 10 : REPEAT  >R >R AGAIN R> R> 2- ENDIF ;
 11
 12 FORTH DEFINITIONS DECIMAL
 13 ;S
 14
 15

SCR#22
  0
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
 11
 12
 13
 14
 15

SCR#23
  0 ( NABU PC fig-FORTH extensions - SEP 7, 2023)
  1 BASE @ >R HEX CR ." Loading NABU extensions "
  2 : AWTR ( B N --- ) 41 P! 40 P! ;
  3 : SOUND ( CH N D --- ) SP@ C@ B AWTR SP@ 1+ C@ C AWTR
  4    DROP SWAP >R 0 8 AWTR 0 9 AWTR 0 A AWTR 10 R@ 8 + AWTR
  5    SP@ C@ R@ 2 * AWTR SP@ 1+ C@ R> 2 * 1+ AWTR DROP 0 D AWTR ;
  6 : HONK ( --- ) 0 A02 880 SOUND ;
  7 : BEEP ( --- ) 0 71 880 SOUND ;
  8 0 6 AWTR 78 7 AWTR 0 8 AWTR 0 9 AWTR 0 A AWTR
  9 0 B AWTR 0 C AWTR 0 D AWTR
 10
 11
 12
 13
 14
 15 R> BASE ! -->

SCR#24
  0 ( Graphics Primitives - SCR 1 of 5 )
  1 BASE @ >R HEX ." ."
  2 : VWTR ( B N --- ) 80 OR SWAP A1 P! A1 P! ;
  3 : VSBW ( B VADDR --- ) SP@ C@ A1 P! SP@ 1+ C@ 3F AND
  4        40 OR A1 P! DROP A0 P! ;
  5 : VSBR ( VADDR --- B ) SP@ C@ A1 P! SP@ 1+ C@ 3F AND
  6        A1 P! DROP A0 P@ ;
  7 : VMBW ( ADDR VADDR COUNT --- ) >R SP@ C@ A1 P! SP@ 1+ C@
  8        3F AND 40 OR A1 P! DROP R> 0 DO DUP I + C@ A0 P!
  9        LOOP DROP ;
 10 : VMBR ( VADDR ADDR COUNT --- ) ROT SP@ C@ A1 P! SP@ 1+ C@
 11        3F AND A1 P! DROP 0 DO A0 P@ OVER I + C! LOOP DROP ;
 12 : VFILL ( VADDR COUNT B --- ) ROT SP@ C@ A1 P! SP@ 1+ C@
 13        3F AND 40 OR A1 P! DROP SWAP 0 DO DUP A0 P! LOOP
 14        DROP ;
 15 R> BASE ! -->

SCR#25
  0 ( Graphics Primitives - SCR 2 of 5 )
  1 BASE @ >R HEX ." ."
  2 0 VARIABLE COLTAB 0 VARIABLE SATR 0 VARIABLE SMTN
  3 0 VARIABLE PDT 0 VARIABLE SPDTAB 0 VARIABLE VDPMDE
  4 0 VARIABLE SCRN_BUF 280 ALLOT 0 VARIABLE VDPREG
  5 0 VARIABLE SCRN_WIDTH 0 VARIABLE SCRN_START
  6 3C0 VARIABLE SCRN_END 0 VARIABLE CURPOS
  7
  8
  9
 10
 11
 12
 13 : CLS ( --- )
 14   SCRN_START @ DUP CURPOS ! SCRN_END @ OVER - 20 VFILL ;
 15 R> BASE ! -->

SCR#26
  0 ( Graphics Primitives - SCR 3 of 5 )
  1 BASE @ >R HEX ." ."
  2 : (CHAR) >R -2 6 DO SP@ 1+ C@ PAD I + DUP >R C!
  3   SP@ C@ R> 1+ C! DROP -2 +LOOP PAD R> 8 VMBW ;
  4 : CHAR ( W1 W2 W3 W4 CH --- ) 8 * PDT @ + (CHAR) ;
  5 : CHARPAT ( CH --- W1 W2 W3 W4 )
  6   8 * PDT @ + PAD 8 VMBR 8 0 DO PAD I + DUP >R C@ 100 *
  7   R> 1+ C@ + 2 +LOOP ;
  8 : SPCHAR ( N1 N2 N3 N4 CH ) 8 * SPDTAB @ + (CHAR) ;
  9
 10
 11
 12
 13
 14
15 R> BASE ! -->

SCR#27
  0 ( Graphics Primitives - SCR 4 of 5 ) BASE @ >R HEX ." ."
  1 : VCHAR ( X Y CNT CH --- )
  2 >R >R SCRN_WIDTH @ * + SCRN_END @ SCRN_START @ - SWAP R>
  3 R> SWAP 0 DO SWAP OVER OVER SCRN_START @ + VSBW SCRN_WIDTH
  4 @ + ROT OVER OVER /MOD IF 1+ SCRN_WIDTH @ OVER OVER = IF -
  5 ELSE DROP ENDIF ENDIF ROT DROP ROT LOOP DROP DROP DROP ;
  6 : HCHAR ( X Y CNT CH --- ) >R >R SCRN_WIDTH @ * +
  7   SCRN_START @ + R> R> VFILL ;
  8 : GCHAR ( X Y --- ASCII ) SCRN_WIDTH @ * + SCRN_START @ +
  9   VSBR ;
 10 : GOTOXY ( X Y --- ) SCRN_WIDTH @ * + SCRN_START @ +
 11   CURPOS ! ;
 12 : COLOR ( FG BG CHSET --- ) >R SWAP 10 * + R> COLTAB @ +
 13   VSBW ;
 14 : SCREEN ( C --- ) 7 VWTR ;
 15 R> BASE ! -->

SCR#28
  0 ( Graphics Primitives - SCR 5 of 5 ) BASE @ >R HEX ." ."
  1 : (SCROLL) ( n s --- ) >R
  2   DUP R@ * SCRN_START @ + SCRN_WIDTH @ + SCRN_BUF R@ VMBR
  3   SCRN_BUF SWAP R@ * SCRN_START @ + R> VMBW ;
  4 : ?SCROLL ( --- ) CURPOS @ 1+ SCRN_END @ > IF
  5   SCRN_END @ SCRN_START @ - SCRN_WIDTH @ 8 * / 0 DO I
  6   SCRN_WIDTH @ 8 * (SCROLL) LOOP SCRN_END @ SCRN_WIDTH @ -
  7   CURPOS ! CURPOS @ SCRN_WIDTH @ 20 VFILL THEN ;
  8 : (EMIT) ( CH --- ) DUP 7 = IF DROP HONK ELSE DUP 8 = IF
  9   DROP CURPOS @ 1- CURPOS ! CURPOS @ 1 20 VFILL ELSE
 10   >R CURPOS @ 1 R> VFILL 1 CURPOS +! ?SCROLL THEN THEN ;
 11 : (CR) ( --- ) CURPOS @ SCRN_START @ - DUP SCRN_WIDTH @
 12   /MOD DROP - SCRN_WIDTH @ + SCRN_START @ + CURPOS !
 13   ?SCROLL ;
 14
 15 R> BASE ! -->

SCR#29
  0 ( VDP Modes - SCR 1 of 2 )
  1 BASE @ >R HEX ." ."
  2 : TEXT 28 SCRN_WIDTH ! 1800 SCRN_START ! 1BC0 SCRN_END !
  3   CLS ' (EMIT) 2 - ' EMIT ! ' (CR) 2 - ' CR ! D2 VDPREG C!
  4   0 0 VWTR D2 1 VWTR 6 2 VWTR 0 4 VWTR F5 7 VWTR ;
  5 : TEXT2 50 SCRN_WIDTH ! 1000 SCRN_START ! 1780 SCRN_END !
  6   SCRN_START @ DUP CURPOS ! 780 20 VFILL D2 VDPREG C!
  7   ' (EMIT) 2 - ' EMIT ! ' (CR) 2 - ' CR !
  8   4 0 VWTR D2 1 VWTR 7 2 VWTR 0 4 VWTR F4 7 VWTR ;
  9 : GRAPHICS 20 SCRN_WIDTH ! 1800 SCRN_START ! 1B00 SCRN_END !
 10   2000 COLTAB ! 1B00 SATR ! 3800 SPDTAB ! C2 VDPREG C!
 11   CLS ' (EMIT) 2 - ' EMIT ! ' (CR) 2 - ' CR !
 12   2000 20 F6 VFILL
 12   0 0 VWTR C2 1 VWTR 6 2 VWTR 80 3 VWTR 0 4 VWTR
 13   36 5 VWTR 7 6 VWTR 1 7 VWTR ;
 15 R> BASE ! -->

SCR#30
  0 ( VDP Modes - SCR 2 of 2 )
  1 BASE @ >R HEX ." ."
  2 : MULTI ( TODO ) ;
  3 : GRAPHICS2 ( TODO ) ;
  4
  5
  6
  7
  8
  9
 10
 11
 12
 13
 14
 15 R> BASE ! -->

SCR#31
  0 ( Sprites - SCR 1 of 2 ) BASE @ >R HEX ." ."
  1 : MAGNIFY ( N --- )
  2   VDPREG C@ 0FC AND + DUP VDPREG C! 1 VWTR ;
  3 : SPRPAT ( CH S --- ) 4 * SATR @ 2+ + VSBW ;
  4 : SPRPUT ( DX DY S --- )
  5   4 * SATR @ + >R 1- SWAP 100 U* DROP + SP@ R> 2 VMBW DROP ;
  6 : SPRCOL ( C S --- ) 4 * SATR @ 3 + + DUP >R VSBR 0F0 AND OR
  7   R> VSBW ;
  8 : SPRITE ( DX DY COL CH S --- )
  9   DUP >R SPRPAT R@ SPRCOL R> SPRPUT ;
 10
 11 R> BASE ! SPACE ." Done!" CR ;S
 12
 13
 14
 15

SCR#32
  0 ( NABU-LIB Standard font definitions - SCR #1/7 )
  1 ( https://github.com/DJSures/NABU-LIB )
  2 BASE @ >R HEX 60 VARIABLE STDCHR
  3 0000 , 0000 , 0000 , 0000 , ( SPACE )
  4 2020 , 2020 , 0020 , 0020 , ( ! )
  5 5050 , 0050 , 0000 , 0000 , ( " )
  6 5050 , 50F8 , 50F8 , 0050 , ( # )
  7 7820 , 70A0 , F028 , 0020 , ( $ )
  8 C8C0 , 2010 , 9840 , 0018 , ( % )
  9 A040 , 40A0 , 90A8 , 0068 , ( & )
 10 2020 , 0020 , 0000 , 0000 , ( ' )
 11 4020 , 8080 , 4080 , 0020 , ( ( )
 12 1020 , 0808 , 1008 , 0020 , ( ) )
 13 A820 , 2070 , A870 , 0020 , ( * )
 14 2000 , F820 , 2020 , 0000 , ( + )
 15 0000 , 0000 , 2020 , 0040 , ( , ) -->

SCR#33
  0 ( NABU-LIB Standard font definition - SCR #2/7 )
  1 0000 , F800 , 0000 , 0000 , ( - )
  2 0000 , 0000 , 0000 , 0020 , ( . )
  3 0800 , 2010 , 8040 , 0000 , ( / )
  4 8870 , A898 , 88C8 , 0070 , ( 0 )
  5 6020 , 2020 , 2020 , 0070 , ( 1 )
  6 8870 , 3008 , 8040 , 00F8 , ( 2 )
  7 08F8 , 3010 , 8808 , 0070 , ( 3 )
  8 3010 , 9050 , 10F8 , 0010 , ( 4 )
  9 80F8 , 08F0 , 8808 , 0070 , ( 5 )
 10 4038 , F080 , 8888 , 0070 , ( 6 )
 11 08F8 , 2010 , 4040 , 0040 , ( 7 )
 12 8870 , 7088 , 8888 , 0070 , ( 8 )
 13 8870 , 7888 , 1008 , 00E0 , ( 9 )
 14 0000 , 0020 , 0020 , 0000 , ( : )
 15 0000 , 0020 , 2020 , 0040 , ( ; ) -->

SCR#34
  0 ( NABU-LIB Standard font definition - SCR #3/7 )
  1 2010 , 8040 , 2040 , 0010 , ( < )
  2 0000 , 00F8 , 00F8 , 0000 , ( = )
  3 2040 , 0810 , 2010 , 0040 , ( > )
  4 8870 , 2010 , 0020 , 0020 , ( ? )
  5 8870 , B8A8 , 80B0 , 0078 , ( @ )
  6 5020 , 8888 , 88F8 , 0088 , ( A )
  7 88F0 , F088 , 8888 , 00F0 , ( B )
  8 8870 , 8080 , 8880 , 0070 , ( C )
  9 88F0 , 8888 , 8888 , 00F0 , ( D )
 10 80F8 , F080 , 8080 , 00F8 , ( E )
 11 80F8 , F080 , 8080 , 0080 , ( F )
 12 8078 , 8080 , 8898 , 0078 , ( G )
 13 8888 , F888 , 8888 , 0088 , ( H )
 14 2070 , 2020 , 2020 , 0070 , ( I )
 15 0808 , 0808 , 8808 , 0070 , ( J ) -->

SCR#35
  0 ( NABU-LIB Standard font definition - SCR #4/7 )
  1 9088 , C0A0 , 90A0 , 0088 , ( K )
  2 8080 , 8080 , 8080 , 00F8 , ( L )
  3 D888 , A8A8 , 8888 , 0088 , ( M )
  4 8888 , A8C8 , 8898 , 0088 , ( N )
  5 8870 , 8888 , 8888 , 0070 , ( O )
  6 88F0 , F088 , 8080 , 0080 , ( P )
  7 8870 , 8888 , 90A8 , 0068 , ( Q )
  8 88F0 , F088 , 90A0 , 0088 , ( R )
  9 8870 , 7080 , 8808 , 0070 , ( S )
 10 20F8 , 2020 , 2020 , 0020 , ( T )
 11 8888 , 8888 , 8888 , 0070 , ( U )
 12 8888 , 8888 , 5088 , 0020 , ( V )
 13 8888 , A888 , D8A8 , 0088 , ( W )
 14 8888 , 2050 , 8850 , 0088 , ( X )
 15 8888 , 2050 , 2020 , 0020 , ( Y ) -->

SCR#36
  0 ( NABU-LIB Standard font definition - SCR #5/7 )
  1 08F8 , 2010 , 8040 , 00F8 , ( Z )
  2 4078 , 4040 , 4040 , 0078 , ( [ )
  3 8000 , 2040 , 0810 , 0000 , ( \ )
  4 10F0 , 1010 , 1010 , 00F0 , ( ] )
  5 0000 , 5020 , 0088 , 0000 , ( ^ )
  6 0000 , 0000 , 0000 , F800 , ( _ )
  7 2040 , 0010 , 0000 , 0000 , ( ` )
  8 0000 , 8870 , 88F8 , 0088 , ( a )
  9 0000 , 48F0 , 4870 , 00F0 , ( b )
 10 0000 , 8078 , 8080 , 0078 , ( c )
 11 0000 , 48F0 , 4848 , 00F0 , ( d )
 12 0000 , 80F0 , 80E0 , 00F0 , ( e )
 13 0000 , 80F0 , 80E0 , 0080 , ( f )
 14 0000 , 8078 , 88B8 , 0070 , ( g )
 15 0000 , 8888 , 88F8 , 0088 , ( h ) -->

SCR#37
  0 ( NABU-LIB Standard font definition - SCR #6/7 )
  1 0000 , 2070 , 2020 , 00F8 , ( i )
  2 0000 , 2070 , A020 , 00E0 , ( j )
  3 0000 , A090 , A0C0 , 0090 , ( k )
  4 0000 , 8080 , 8080 , 00F8 , ( l )
  5 0000 , D888 , 88A8 , 0088 , ( m )
  6 0000 , C888 , 98A8 , 0088 , ( n )
  7 0000 , 8870 , 8888 , 0070 , ( o )
  8 0000 , 88F0 , 80F0 , 0080 , ( p )
  9 0000 , 88F8 , 90A8 , 00E8 , ( q )
 10 0000 , 88F8 , A0F8 , 0090 , ( r )
 11 0000 , 8078 , 0870 , 00F0 , ( s )
 12 0000 , 20F8 , 2020 , 0020 , ( t )
 13 0000 , 8888 , 8888 , 0070 , ( u )
 14 0000 , 8888 , A090 , 0040 , ( v )
 15 0000 , 8888 , D8A8 , 0088 , ( w ) -->

SCR#38
  0 ( NABU-LIB Standard font definition - SCR #7/7 )
  1 0000 , 7088 , 7020 , 0088 , ( x )
  2 0000 , 5088 , 2020 , 0020 , ( y )
  3 0000 , 10F8 , 4020 , 00F8 , ( z )
  4 4038 , C020 , 4020 , 0038 , ( { )
  5 2040 , 0810 , 2010 , 0040 , ( > )
  6 10E0 , 1820 , 1020 , 00E0 , ( } )
  7 A840 , 0010 , 0000 , 0000 , ( ~ )
  8 50A8 , 50A8 , 50A8 , 00A8 ,
  9 R> BASE ! ;S
 10
 11 Use VMBW to load the standard font, eg:
 12
 13   HEX STDCHR 2 + 800 20 8 * + 60 VMBW
 14
 15

SCR#39
  0 ( NABU-LIB note definitions)
  1 ( https://github.com/DJSures/NABU-LIB )
  2 BASE @ >R HEX 48 VARIABLE NOTES
  3 0D5C , 0C9C , 0BE7 , 0B3C , 0A9B , 0A02 , 0972 , 08EB ,
  4 086A , 07F2 , 077F , 0714 , 06AE , 064E , 05F3 , 059E ,
  5 054D , 0501 , 04B9 , 0475 , 0435 , 03F9 , 03BF , 038A ,
  6 0357 , 0327 , 02F9 , 02CF , 02A6 , 0280 , 025C , 023A ,
  7 021A , 01FC , 01DF , 01C5 , 01AB , 0193 , 017C , 0167 ,
  8 0153 , 0140 , 012E , 011D , 010D , 00FE , 00EF , 00E2 ,
  9 00D5 , 00C9 , 00BE , 00B3 , 00A9 , 00A0 , 0097 , 008E ,
 10 0086 , 007F , 0077 , 0071 , 006A , 0064 , 005F , 0059 ,
 11 0054 , 0050 , 004B , 0047 , 0043 , 003F , 003B , 0038 ,
 12 : MIDI ( N --- M ) 2 * 2+ NOTES + @ ;
 13 R> BASE ! ;S
 14
 15

SCR#40
  0 ( SPRITES DEMO [SCR 1 OF 3]                   DT 21-SEP-23 )
  1 GRAPHICS CLS 2 MAGNIFY HEX ( KNIGHT SPRITE PATTERN )
  2 0103 1312 1313 1317 0 SPCHAR 3F1F 1B13 0303 0303 1 SPCHAR
  3 C0E0 E020 E0E0 E0FE 2 SPCHAR F6E2 F6FC 6860 6060 3 SPCHAR
  4 0103 1312 1313 1317 4 SPCHAR 3F1F 1B13 0303 0000 5 SPCHAR
  5 C0E0 E020 E0E0 E0FE 6 SPCHAR F6E2 F6FC 6860 6060 7 SPCHAR
  6 0103 1312 1313 1317 8 SPCHAR 3F1F 1B13 0303 0303 9 SPCHAR
  7 C0E0 E020 E0E0 E0FE A SPCHAR F6E2 F6FC 6860 0000 B SPCHAR
  8 0103 1312 1313 1317 C SPCHAR 3F1F 1B13 0303 0000 D SPCHAR
  9 C0E0 E020 E0E0 E0FE E SPCHAR F6E2 F6FC 6860 0000 F SPCHAR
 10 50 VARIABLE DX 25 VARIABLE DY 2 VARIABLE SPD 2 VARIABLE HGHT
 11 : DELAY 0 DO LOOP ;
 12 : RUN 1 SPD ! ;
 13 : WALK 2 SPD ! ;
 14 : HIGH 6 HGHT ! ;
 15 -->

SCR#41
  0 ( SPRITES DEMO [SCR 2 OF 3]                   DT 21-SEP-23 )
  1 : JUMP DX @ DY @ 2DUP 2 + D 0 SPRPAT 2 + 0 SPRPUT 400 DELAY
  2   0 0 SPRPAT 2DUP 0 SPRPUT 100 DELAY 2DUP HGHT @ - 0 SPRPUT
  3   800 DELAY 0 SPRPUT 2 HGHT ! ;
  4 : CLOAK 0 0 SPRCOL ;
  5 : UNCLOAK 2 0 SPRCOL ;
  6 : ANIMATE 2 MOD 4 * 4 + 0 SPRPAT ;
  7 : MOVEX DO DX @ OVER + DX ! I ANIMATE I DY @ 0 SPRPUT
  8   SPD @ 200 * DELAY DUP +LOOP DROP 0 0 SPRPAT ;
  9 : MOVEY DO DY @ OVER + DY ! I ANIMATE DX @ I 0 SPRPUT
 10   SPD @ 200 * DELAY DUP +LOOP DROP 0 0 SPRPAT ;
 11 : LEFT -1 DX @ DUP 10 - SWAP MOVEX ;
 12 : RIGHT 1 DX @ DUP 10 + SWAP MOVEX ;
 13 : UP -1 DY @ DUP 10 - SWAP MOVEY ;
 14 : DOWN 1 DY @ DUP 10 + SWAP MOVEY ;
 15 -->

SCR#42
  0 ( SPRITES DEMO [SCR 3 OF 2]                   DT 21-SEP-23 )
  1
  2 DX @ DY @ 2 0 0 SPRITE ;S
  3
  4   A SIMPLE DEMO THAT ALLOWS YOU TO WALK (OR RUN OR JUMP) A
  5   GREEN KNIGHT AROUND THE SCREEN.
  6
  7
  8
  9
 10
 11
 12
 13
 14
 15

SCR#43
  0
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
 11
 12
 13
 14
 15

SCR#44
  0
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
 11
 12
 13
 14
 15

SCR#45
  0
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
 11
 12
 13
 14
 15

SCR#46
  0
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
 11
 12
 13
 14
 15

SCR#47
  0
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
 11
 12
 13
 14
 15

SCR#48
  0
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
 11
 12
 13
 14
 15

SCR#49
  0
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
 11
 12
 13
 14
 15

SCR#50
  0
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
 11
 12
 13
 14
 15
