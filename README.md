# fig-FORTH 1.3 for Z80

A fig-FORTH<sup>1</sup> implementation for the Z80 that can be built using TASM (Telemark Assembler):

```
$ tasm -80 -b figforth.z80 forth.com forth.lst
```

The resulting `forth.com` executable can be run in CP/M. For example<sup>2</sup>:
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

## Editor
The fig-FORTH EDITOR<sup>3</sup> can be loaded from the `SCREENS.FRT` file:
```
A>FORTH SCREENS.FRT

Z80 fig-FORTH 1.3a
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
0 P EAT MORE PIES! ok
1 LIST 
SCR # 1 
  0 EAT MORE PIES!
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
ok
FLUSH ok
BYE 
A>
```

## References
1. William Ragsdale, _'fig-FORTH INSTALLATION MANUAL'_ (San Carlos, CA: FORTH INTEREST GROUP, 1980)
2. John James, _‘What Is Forth? A Tutorial Introduction’_, in BYTE, 5.8 (1980), 100–26
3. Bill Stoddart, _'EDITOR USER MANUAL'_, (London, UK: FIG United Kingdom, ND)
