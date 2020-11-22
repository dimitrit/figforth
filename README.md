# fig-FORTH 1.1 for Z80

A fig-FORTH implementation for the Z80 that can be built using TASM (Telemark Assembler):

```
$ tasm -80 -b figforth.z80 forth.com forth.lst
```

The resulting `forth.com` executable can be run in CP/M: 
```
A>FORTH STARTUP.FRT

Z80 fig-FORTH 1.1g
: TEST 5 0 DO CR ." Hello World! " LOOP ; ok
TEST 
Hello World! 
Hello World! 
Hello World! 
Hello World! 
Hello World! ok
BYE 
A>
```