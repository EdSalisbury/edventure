; EdVenture - An Adventure in Atari 8-Bit Assembly
; github.com/edsalisbury/edventure
; Mission: EdPossible
; youtube.com/MissionEdPossible
; Assemble in MADS: mads -l -t main.asm
; Episode 8: Tile-based maps

; ATASCII Table: https://www.atariwiki.org/wiki/attach/Atari%20ATASCII%20Table/ascii_atascii_table.pdf
; ATASCII 0-31 Screen code 64-95
; ATASCII 32-95 Screen code 0-63
; ATASCII 96-127 Screen code 96-127

; NTSC Color Palette: https://atariage.com/forums/uploads/monthly_10_2015/post-6369-0-47505700-1443889945.png
; PAL Color Palette: https://atariage.com/forums/uploads/monthly_10_2015/post-6369-0-90255700-1443889950.png
; PMG Memory Map: https://www.atarimagazines.com/compute/issue64/atari_animation.gif

	org $2000

screen  = $4000 ; Screen buffer
charset = $5000 ; Character Set
pmg     = $6000 ; Player Missle Data

	setup_screen()
	setup_colors()
	mva #>charset CHBAS
	clear_pmg()
	load_pmg()
	setup_pmg()
	display_map()

	jmp *

	icl 'hardware.asm'
	icl 'dlist.asm'
	icl 'gfx.asm'
	icl 'pmgdata.asm'

* --------------------------------------- *
* Proc: setup_colors                      *
* Sets up colors                          *
* --------------------------------------- *
.proc setup_colors
med_gray = $06
lt_gray = $0a
green = $c2
brown = $22
black = $00
peach = $2c
blue = $80

	; Character Set Colors
	mva #med_gray COLOR0 ; %01
	mva #lt_gray COLOR1  ; %10
	mva #green COLOR2	 ; %11
	mva #brown COLOR3    ; %11 (inverse)
	mva #black COLOR4    ; %00

	; Player-Missile Colors
	mva #brown PCOLR0
	mva #peach PCOLR1
	mva #blue PCOLR2
	mva #black PCOLR3

	rts
	.endp

* --------------------------------------- *
* Proc: clear_pmg                         *
* Clears memory for Player-Missile Gfx    *
* --------------------------------------- *
.proc clear_pmg
pmg_p0 = pmg + $200
pmg_p1 = pmg + $280
pmg_p2 = pmg + $300
pmg_p3 = pmg + $380

	ldx #$80
	lda #0
loop
	dex
	sta pmg_p0,x
	sta pmg_p1,x
	sta pmg_p2,x
	sta pmg_p3,x
	bne loop
	rts
	.endp

* --------------------------------------- *
* Proc: load_pmg                          *
* Load PMG Graphics                       *
* --------------------------------------- *
.proc load_pmg
pmg_p0 = pmg + $200
pmg_p1 = pmg + $280
pmg_p2 = pmg + $300
pmg_p3 = pmg + $380

	ldx #0
loop
	mva pmgdata,x pmg_p0+64,x
	mva pmgdata+8,x pmg_p1+64,x
	mva pmgdata+16,x pmg_p2+64,x
	mva pmgdata+24,x pmg_p3+64,x
	inx
	cpx #8
	bne loop
	rts
	.endp

* --------------------------------------- *
* Proc: setup_pmg                         *
* Sets up Player-Missile Graphics System  *
* --------------------------------------- *
.proc setup_pmg
	mva #>pmg PMBASE
	mva #46 SDMCTL ; Single Line resolution
	mva #3 GRACTL  ; Enable PMG
	mva #1 GRPRIOR ; Give players priority
	lda #120
	sta HPOSP0
	sta HPOSP1
	sta HPOSP2
	sta HPOSP3
	rts
	.endp

* --------------------------------------- *
* Macro: blit_row                         *
* Copies map row to screen                *
* --------------------------------------- *
.macro blit_row map, screen
	ldx #0
	ldy #0
loop
	lda :map,x
	asl
	sta :screen,y
	clc
	adc #1
	iny
	sta :screen,y
	iny
	inx
	cpx #20
	bne loop
	.endm

* --------------------------------------- *
* Proc: display_map                       *
* Displays the current map                *
* --------------------------------------- *
.proc display_map
	blit_row map,screen
	blit_row map+20,screen+40
	blit_row map+40 screen+80
	blit_row map+60 screen+120
	blit_row map+80 screen+160
	blit_row map+100 screen+200
	blit_row map+120 screen+240
	blit_row map+140 screen+280
	blit_row map+160 screen+320
	blit_row map+180 screen+360
	blit_row map+200 screen+400
	blit_row map+220 screen+440
	rts
	
map
	.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	.byte 1,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,1
	.byte 1,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,1
	.byte 1,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,1
	.byte 1,2,2,2,2,2,2,2,2,2,2,3,2,2,2,2,2,2,2,1
	.byte 1,2,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,1
	.byte 1,2,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,1
	.byte 1,2,1,2,2,2,2,2,2,2,2,1,1,3,1,1,1,3,1,1
	.byte 1,2,1,2,2,2,2,2,2,2,2,1,2,2,2,1,2,2,2,1
	.byte 1,2,1,1,1,1,1,1,1,1,2,1,2,2,2,1,2,5,2,1
	.byte 1,2,2,2,2,2,2,2,2,2,2,1,2,2,2,1,2,2,2,1
	.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1

	.endp
