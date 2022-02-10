	org $2000

screen = $4000

	lda RAMTOP
	sbc #8
	sta RAMTOP
	sta PMBASE
	setup_screen()

	mva #62 SDMCTL ; Single Line resolution
	mva #3 GRACTL ; Enable PMG
	mva #1 GRPRIOR ; Give players priority


	jmp *

	icl 'dlist.asm'
	icl 'hardware.asm'