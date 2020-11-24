# fig-FORTH 1.1 for Z80

A fig-FORTH<sup>1</sup> implementation for the Z80 that can be built using TASM (Telemark Assembler):

```
$ tasm -80 -b figforth.z80 forth.com forth.lst
```

The resulting `forth.com` executable can be run in CP/M: 
```
A>FORTH STARTUP.FRT

Z80 fig-FORTH 1.1g
: HELLO 5 0 DO CR ." Hello World! " LOOP ; ok
HELLO 
Hello World! 
Hello World! 
Hello World! 
Hello World! 
Hello World! ok
BYE 
A>
```

## References
1. William Ragsdale, _'fig-FORTH INSTALLATION MANUAL'_ (San Carlos, CA: FORTH INTEREST GROUP, 1980)
2. John James, _‘What Is Forth? A Tutorial Introduction’_, in BYTE, 5.8 (1980), 100–26
