ASMSOURCES = conprtio.asm discio.asm figforth.asm romwbw.asm
NABUSCRS = nabu.scr knight.scr scooby.scr daf44.scr
CPMSCRS = screens.scr

all: figforth.img nabu.dsk

forth.com: $(ASMSOURCES)
	uz80as -V -t z80 figforth.asm $@ figforth.lst

$(CPMSCRS) $(NABUSCRS): %.scr: %.s
	./txt2scr.sh -s127 $< > $@

figforth.img: forth.com $(CPMSCRS)
	dd if=/dev/zero of=$@ bs=512 count=2880
	mkfs.cpm -f wbw_fd144 $@
	$(foreach SCR, forth.com $(CPMSCRS), \
		cpmcp -f wbw_fd144 $@ $(SCR) 0:$(SCR) ; \
	)

nabu.dsk: forth.com $(NABUSCRS)
	dd if=/dev/zero of=$@ bs=512 count=16384
	mkfs.cpm -f naburn8mb $@
	$(foreach SCR, forth.com $(NABUSCRS), \
		cpmcp -f naburn8mb $@ $(SCR) 0:$(SCR) ; \
	)

clean:
	@rm -f *.lst *.img *.dsk *.com *.scr
