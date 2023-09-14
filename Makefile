figforth: figforth.img

figforth.img: figforth.com SCREENS.SCR
	@rm -f figforth.img
	@mkfs.cpm -f wbw_fd144 figforth.img
	@cpmcp -f wbw_fd144 figforth.img figforth.com 0:forth.com
	@cpmcp -f wbw_fd144 figforth.img SCREENS.SCR 0:screens.scr

C.DSK: figforth.com NABU.SCR
	@rm -f C.DSK
	@mkfs.cpm -f naburn8mb C.DSK
	@cpmcp -f naburn8mb C.DSK figforth.com 0:forth.com
	@cpmcp -f naburn8mb C.DSK NABU.SCR 0:nabu.scr

figforth.com: conprtio.asm discio.asm figforth.asm romwbw.asm
	@uz80as -V -t z80 figforth.asm figforth.com figforth.lst

NABU.SCR: nabu.s
	./txt2scr.sh nabu.s > NABU.SCR

clean:
	@rm -f *.lst *.img *.com NABU.SCR
