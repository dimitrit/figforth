# Z80 fig-FORTH 1.3

> <h2><i>figForth Refuses to Die<sup>1</sup></i></h2>   
<br/>    
A fig-FORTH<sup>2</sup> implementation for the Z80 that can be built using TASM<sup>3</sup>:
   
```
$ tasm -80 -b figforth.asm forth.com forth.lst
```

The resulting `forth.com` executable can be run in CP/M. For example<sup>4</sup>:
```
A>FORTH ↵

Z80 fig-FORTH 1.3b
: CUBE ( N -> N.  CUBE A NUMBER ) ↵
   DUP DUP  ( NOW THERE ARE THREE COPIES ) ↵
   * * ↵
; ↵ ok
5 CUBE . 125 ↵ ok
-28 CUBE . ↵ -21952 ok
HEX 17 CUBE BINARY . DECIMAL ↵ 10111110000111 ok
BYE ↵
A>
```

## Custom Words
This fig-FORTH implementation includes the following custom words:

`FILE cccc`   
Close the current .FTH file, and opens the given file. Note that a 
file can be loaded automatically on startup by specifying its name on 
the command line, e.g. `FORTH SCREENS.FTH`. Startup will be aborted 
with a `No File` error message if the file cannot be opened.

`FTYPE`&nbsp;&nbsp;&nbsp;&nbsp;` --- addr `   
A constant containing the three character file type used by `FILE`.   
Defaults to **.FTH**.

## RomWBW extensions
Support for RomWBW HBIOS features<sup>5</sup> is included when fig-FORTH 
is built with the `-DROMWBW` flag:

`.B`&nbsp;&nbsp;&nbsp;&nbsp;` n -- `   
Print a BCD value, converted to decimal. No following blank is printed.

`AT`&nbsp;&nbsp;&nbsp;&nbsp;` col row --- `   
Position the text cursor at the given position. Both column and 
row positions are zero indexed, thus `0 0 AT` will move the cursor
to the top left. Note that `AT` does *not* update `OUT`.

`CLS`&nbsp;&nbsp;&nbsp;&nbsp;` --- `   
Clear VDU screen.

`KEY?`&nbsp;&nbsp;&nbsp;&nbsp;` --- c t ¦ f `   
Check if a key has been pressed. Returns false if no key has been
pressed. Returns true and the key's ascii code if a key has been
pressed. 

`STIME`&nbsp;&nbsp;&nbsp;&nbsp;` addr --- `   
Set the RTC time. addr is the address of the 6 byte date/time buffer, 
YMDHMS. Each byte is BCD encoded.

`TIME`&nbsp;&nbsp;&nbsp;&nbsp;` --- addr `   
Get the RTC time and leave the address of the 6 byte date/time buffer, 
YMDHMS. Each byte is BCD encoded.

## fig-FORTH Editor
The fig-FORTH EDITOR<sup>6</sup> is included in the `SCREENS.FTH` file:
```
FILE SCREENS ↵ ok
7 12 INDEX ↵

  7 ( fig-FORTH EDITOR V2.0 SCR 1 of 6)
  8 ( fig-FORTH EDITOR V2.0 SCR 2 of 6)
  9 ( fig-FORTH EDITOR V2.0 SCR 3 of 6)
 10 ( fig-FORTH EDITOR V2.0 SCR 4 of 6)
 11 ( fig-FORTH EDITOR V2.0 SCR 5 of 6)
 12 ( fig-FORTH EDITOR V2.0 SCR 6 of 6)ok
7 LOAD ↵ 2DROP MSG # 4  R MSG # 4  I MSG # 4  ok
EDITOR ↵ ok
1 CLEAR ↵ ok
0 P ( EAT MORE PIES! ) ↵ ok
1 LIST ↵
SCR # 1 
  0 ( EAT MORE PIES! )
  1 
  2 
  3 
 ... 
 14 
 15 
ok
FLUSH ↵ ok
```

## fig-FORTH 8080/Z80 Assembler
The fig-FORTH assembler enables the creation of both full and defining 
words using assembly language. 

The assembler is invoked using `CODE`, which creates a dictionary entry 
with given name and then assembles the mnemonics following. The mnemonics
are based on the 8080 instruction set with Z80 specific extensions. 
The assembly code must end with `PCIX` to ensure control is returned to Forth. 

Note that Forth postfix notation applies between opcodes and operands.

```
CODE FOO  ( n1 n2 -- n3 as sum of n1 + n2 )
  H POP   ( get first number from stack   )
  D POP   ( get second number from stack  )
  D DAD   ( add hl and de, result in hl   )
  H PUSH  ( push result to top of stack   )
  PCIX    ( jump to NEXT                  )
C;  ( end of definition, return to FORTH  )
```

The following rules apply when creating words using the assembler:

1. The `BC` register pair must be preserved across words.
1. Avoid use of the Z80 alternative register set.
1. Do NOT use the `IY` or `IX` registers, which are used by fig-FORTH to
keep track of the inner interpreter routine.
1. Definitions must end with `PCIX` (cf. `JNEXT` in `figforth.asm`) or 
`PCIY` (cf. `JHPUSH`).

Additionally, the assembler performs minimal checks which means that it is 
easy to create illegal instructions, resulting in systems hangs or crashes.

## References
1. C. H. Ting, _Systems Guide to figForth_, 3rd Edn (San Mateo, CA: Offete Enterprises, 2013), p. vi
2. William Ragsdale, _'fig-FORTH INSTALLATION MANUAL'_ (San Carlos, CA: FORTH INTEREST GROUP, 1980)
3. Thomas Anderson, _The Telemark Assembler (TASM) User's Manual (1998)_, Vintagecomputer <http://www.vintagecomputer.net/software/TASM/TASMMAN.HTM> [Accessed 14 December 2020]
4. John James, _‘What Is Forth? A Tutorial Introduction’_, in BYTE, 5.8 (1980), 100–26
5. Wayne Warthen, _RomWBW Architecture_, (RetroBrew Computers Group, 2020)   
6. Bill Stoddart, _'EDITOR USER MANUAL'_, (London, UK: FIG United Kingdom, ND)
