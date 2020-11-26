# fig-FORTH 1.1 for Z80

A fig-FORTH<sup>1</sup> implementation for the Z80 that can be built using TASM (Telemark Assembler):

```
$ tasm -80 -b figforth.z80 forth.com forth.lst
```

The resulting `forth.com` executable can be run in CP/M. For example<sup>2</sup>:
```
A>FORTH STARTUP.FRT

Z80 fig-FORTH 1.1g
: CUBE ( N -> N. CUBE A NUMBER) 
   DUP DUP ( NOW THERE ARE THREE COPIES ) 
   * *     ( GET THE CUBE ) 
   ; ok
5 CUBE . 125 ok
-28 CUBE . -21952 ok
BYE 
A>
```

## References
1. William Ragsdale, _'fig-FORTH INSTALLATION MANUAL'_ (San Carlos, CA: FORTH INTEREST GROUP, 1980)
2. John James, _‘What Is Forth? A Tutorial Introduction’_, in BYTE, 5.8 (1980), 100–26
