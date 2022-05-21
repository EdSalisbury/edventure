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

screen  = $8000 ; Screen buffer
charset = $5000 ; Character Set
pmg     = $6000 ; Player Missle Data

tmp = $0092

	setup_screen()
	setup_colors()
	mva #>charset CHBAS
	clear_pmg()
	load_pmg()
	setup_pmg()
	display_map()

game
	lda STICK0
	and #%0100
	beq left
	lda STICK0
	and #%1000
	beq right
	lda STICK0
	and #%0010
	beq down
	lda STICK0
	and #%0001
	beq up

	jmp game

left
	scroll_lu #2
	jmp game
up
	scroll_lu #$40
	jmp game
right
	scroll_rd #2
	jmp game
down
	scroll_rd #$40
	jmp game

	icl 'hardware.asm'
	icl 'dlist.asm'
	icl 'gfx.asm'
	icl 'pmgdata.asm'

* --------------------------------------------- *
* Proc: delay                                   *
* Uses VBLANKs to wait a certain amount of time *
* --------------------------------------------- *
.proc delay (.byte a) .reg
loop
	tax        		 ; number of VBLANKs to wait
start
	lda RTCLOK+2     ; check fastest moving RTCLOCK byte
wait
	cmp RTCLOK+2     ; VBLANK will update this
    beq wait         ; delay until VBLANK changes it
    dex              ; delay for a number of VBLANKs
    bpl start
	rts
	.endp

.proc scroll_lu (.byte a) .reg
	sta tmp
	delay #10
	ldy #16
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

.proc scroll_rd (.byte a) .reg
	sta tmp
	delay #10
	ldy #16
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
* Macro: blit_row                         *
* Copies one line of map to screen        *
* --------------------------------------- *
.macro blit_row map, screen
	ldx #0
	ldy #0
loop
	lda :map,x
	asl
	sta :screen,y
	iny
	clc
	adc #1
	sta :screen,y
	iny
	inx
	cpx #20
	bne loop
	.endm

.macro blit src, dest
	lda src
	asl
	sta dest
	clc
	adc #1
	sta dest+1
	rts
	.endm

.proc plot (.byte a .byte x .byte y) .reg
canvas = $870e
tile = $95
pos_x = $96
pos_y = $97

	sta tile
	stx pos_x
	;iny ; inc y so that the loop works even with 0
	sty pos_y

	mwa #canvas tmp

	; Increase tmp by how many rows there are
loop
 	lda tmp
 	clc
 	adc #$40
 	sta tmp
	lda tmp+1
 	adc #0
 	sta tmp+1
 	dey
 	bne loop

	; Multiply canvas x location by 2
	lda pos_x
	asl
	sta pos_x
	tay

	; Load tile back into accumulator
	lda tile

	asl
	sta (tmp),y
	clc
	adc #1
	iny
	sta (tmp),y
	rts
	.endp


* --------------------------------------- *
* Proc: display_map                       *
* Displays the current map                *
* --------------------------------------- *
.proc display_map
canvas_width = 28
canvas_height = 36
horiz_margin = 6
vert_margin = 10

char = $98
x = $99
y = $9a

map_pos_lo = $9b
map_pos_hi = $9c

	mwa #map map_pos_lo

	ldy #vert_margin
	sty y
vert
	ldx #horiz_margin
	stx x
horiz
	; Get new character and move map pointer
	; TODO: Make a proc for this
	ldy #0
	mva (map_pos_lo),y char
	clc
	lda map_pos_lo
	adc #1
	sta map_pos_lo
	lda map_pos_hi
	adc #0
	sta map_pos_hi
	plot char x y
	ldx x
	ldy y

	inx
	stx x
	cpx #(canvas_width-horiz_margin)
	bne horiz

	iny
	sty y
	cpy #(canvas_height-vert_margin)
	bne vert

	rts
	
map
	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.byte 1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0
	.byte 1,2,2,2,1,1,1,1,1,1,0,0,0,0,0,0
	.byte 1,2,2,2,3,2,2,2,2,1,0,0,0,0,0,0
	.byte 1,2,2,2,1,1,1,1,2,1,0,0,0,0,0,0
	.byte 1,1,1,1,1,0,0,1,2,1,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,1,2,1,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,1,2,1,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,1,2,1,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,1,2,1,1,1,1,0,0,0
	.byte 0,0,0,0,0,0,0,1,2,2,2,2,1,0,0,0
	.byte 0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0
	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.endp
