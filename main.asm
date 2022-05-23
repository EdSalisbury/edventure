; EdVenture - An Adventure in Atari 8-Bit Assembly
; github.com/edsalisbury/edventure
; Mission: EdPossible
; youtube.com/MissionEdPossible
; Assemble in MADS: mads -l -t main.asm
; Episode 11: Scrolling

; ATASCII Table: https://www.atariwiki.org/wiki/attach/Atari%20ATASCII%20Table/ascii_atascii_table.pdf
; ATASCII 0-31 Screen code 64-95
; ATASCII 32-95 Screen code 0-63
; ATASCII 96-127 Screen code 96-127

; NTSC Color Palette: https://atariage.com/forums/uploads/monthly_10_2015/post-6369-0-47505700-1443889945.png
; PAL Color Palette: https://atariage.com/forums/uploads/monthly_10_2015/post-6369-0-90255700-1443889950.png
; PMG Memory Map: https://www.atarimagazines.com/compute/issue64/atari_animation.gif

	org $2000

map     = $3000 ; Map
charset = $4000 ; Character Set
pmg     = $5000 ; Player Missle Data
canvas  = $6000 ; Screen buffer

stick_up    = %0001
stick_down  = %0010 
stick_left  = %0100
stick_right = %1000

	setup_screen()
	setup_colors()
	mva #>charset CHBAS
	clear_pmg()
	load_pmg()
	setup_pmg()
	copy_map_to_canvas()

game
	lda STICK0
	and #stick_up
	beq up

	lda STICK0
	and #stick_down
	beq down

	lda STICK0
	and #stick_left
	beq left

	lda STICK0
	and #stick_right
	beq right

	jmp game

up
	delay #5
	scroll_lu #$80
	jmp game

down
	delay #5
	scroll_rd #$80
	jmp game

left
	delay #5
	scroll_lu #2
	jmp game

right
	delay #5
	scroll_rd #2
	jmp game

* --------------------------------------- *
* Proc: delay                             *
* Uses Real-time clock to delay x/60 secs *
* --------------------------------------- *
.proc delay (.byte x) .reg
start
	lda RTCLK2
wait
	cmp RTCLK2
	beq wait

	dex
	bne start

	rts
	.endp

* --------------------------------------- *
* Proc: scroll_lu                         *
* Scroll left or up                       *
* --------------------------------------- *
.proc scroll_lu (.byte a) .reg
tmp = $92
	sta tmp

	ldy #12
	ldx #4
loop
	sec
	lda setup_screen.dlist,x
	sbc tmp
	sta setup_screen.dlist,x
	inx
	lda setup_screen.dlist,x
	sbc #0
	sta setup_screen.dlist,x
	inx
	inx
	dey
	bne loop

	rts
	.endp

* --------------------------------------- *
* Proc: scroll_rd                         *
* Scroll right or down                    *
* --------------------------------------- *
.proc scroll_rd (.byte a) .reg
tmp = $92
	sta tmp

	ldy #12
	ldx #4
loop
	clc
	lda setup_screen.dlist,x
	adc tmp
	sta setup_screen.dlist,x
	inx
	lda setup_screen.dlist,x
	adc #0
	sta setup_screen.dlist,x
	inx
	inx
	dey
	bne loop

	rts
	.endp


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
* Proc: copy_map_to_canvas                *
* Copies map to canvas with interpolation *
* --------------------------------------- *
.proc copy_map_to_canvas
map_ptr = $92
canvas_ptr = $94

	mwa #map map_ptr
	mwa #canvas canvas_ptr

	ldy #0
loop
	lda (map_ptr),y
	asl
	sta (canvas_ptr),y

	inc canvas_ptr
	bne next
	inc canvas_ptr+1

next
	add #1
	sta (canvas_ptr),y
	iny
	bne loop

	inc map_ptr+1
	inc canvas_ptr+1

	lda map_ptr+1
	cmp #>(map + $1000)
	bne loop

	rts
	.endp

	icl 'hardware.asm'
	icl 'dlist.asm'
	icl 'pmgdata.asm'
	icl 'map.asm'
	icl 'gfx.asm'
