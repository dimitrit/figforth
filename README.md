# Z80 fig-FORTH 1.3

> <h2><i>figForth Refuses to Die<sup>1</sup></i></h2>   
<br/>    
A fig-FORTH<sup>2</sup> implementation for the Z80 that can be built using TASM<sup>3</sup>:
   
```
$ tasm -80 -b figforth.z80 forth.com forth.lst
```

The resulting `forth.com` executable can be run in CP/M. For example<sup>4</sup>:
```
A>FORTH

No file
Z80 fig-FORTH 1.3a
: CUBE ( N -> N.  CUBE A NUMBER ) 
   DUP DUP  ( NOW THERE ARE THREE COPIES ) 
   * * 
   ; ok
5 CUBE . 125 ok
-28 CUBE . -21952 ok
HEX 17 CUBE BINARY . DECIMAL 10111110000111 ok
BYE 
A>
```

## Custom Words
This fig-FORTH implementation includes the following custom words:

`FILE cccc`   
Closes the current .FTH file, and opens the given file. 

`FTYPE`&nbsp;&nbsp;&nbsp;&nbsp;`--- addr`   
A constant containing the three character file type used by `FILE`.   
Defaults to .FTH

`P@`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`n1 --- n2`   
Reads hardware port **n1**.

`P!`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`n1 n2 ---`   
Writes the value of **n1** to hardware port **n2**.

## fig-FORTH Editor
The fig-FORTH EDITOR<sup>5</sup> is included in the `SCREENS.FTH` file:
```
FILE SCREENS ok
7 12 INDEX 

  7 ( fig-FORTH EDITOR V2.0 SCR 1 of 6)
  8 ( fig-FORTH EDITOR V2.0 SCR 2 of 6)
  9 ( fig-FORTH EDITOR V2.0 SCR 3 of 6)
 10 ( fig-FORTH EDITOR V2.0 SCR 4 of 6)
 11 ( fig-FORTH EDITOR V2.0 SCR 5 of 6)
 12 ( fig-FORTH EDITOR V2.0 SCR 6 of 6)ok
7 LOAD 2DROP MSG # 4  R MSG # 4  I MSG # 4  ok
EDITOR ok
1 CLEAR ok
0 P ( EAT MORE PIES! ) ok
1 LIST 
SCR # 1 
  0 ( EAT MORE PIES! )
  1 
  2 
  3 
 ... 
 14 
 15 
ok
FLUSH ok
```

## References
1. C. H. Ting, _Systems Guide to figForth_, 3rd Edn (San Mateo, CA: Offete Enterprises, 2013), p. vi
2. William Ragsdale, _'fig-FORTH INSTALLATION MANUAL'_ (San Carlos, CA: FORTH INTEREST GROUP, 1980)
3. Thomas Anderson, _The Telemark Assembler (TASM) User's Manual (1998)_, Vintagecomputer <http://www.vintagecomputer.net/software/TASM/TASMMAN.HTM> [Accessed 14 December 2020]
4. John James, _‘What Is Forth? A Tutorial Introduction’_, in BYTE, 5.8 (1980), 100–26
5. Bill Stoddart, _'EDITOR USER MANUAL'_, (London, UK: FIG United Kingdom, ND)
