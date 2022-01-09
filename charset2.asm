sm_ptr = $58
ch = $2f4
chr = $2400
rom_chr = $e000

	org $2000

	.proc main
	mva #>chr ch

	ldx #0
copy_loop
	mva rom_chr,x chr,x
	mva rom_chr+$100,x chr+$100,x
	mva rom_chr+$200,x chr+$200,x
	mva rom_chr+$300,x chr+$300,x
	inx
	bne copy_loop

	ldx #0
space_loop
	mva charset.wall1,x chr,x
	inx
	cpx #8
	bne space_loop

	ldx #0
space_loop2
	mva charset.wall2,x chr+8,x
	inx
	cpx #8
	bne space_loop2

	ldy #0
loop	tya
	sta (sm_ptr),y
	iny
	bne loop

	jmp *

        .local charset
wall1
        .byte %11101010
        .byte %10010101
        .byte %01010101
        .byte %00000000
        .byte %10010011
        .byte %01010011
        .byte %01010010
        .byte %00000000

wall2
        .byte %01001111
        .byte %01001110
        .byte %01001001
        .byte %00000000
        .byte %11111010
        .byte %10100101
        .byte %01010101
        .byte %00000000
        .endl
	
	.endp