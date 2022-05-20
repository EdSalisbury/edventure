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
	beq scroll_left
	lda STICK0
	and #%1000
	beq scroll_right
	; lda STICK0
	; and #%0010
	; beq scroll_down
	; lda STICK0
	; and #%0001
	; beq scroll_up

	jmp game

;.proc scroll (.byte offset)

; .proc myproc (.byte myvar+1) .var
; .var _myvar .byte
; myvar mva #0 _myvar

;     rts
; 	.endp


scroll_down
	delay #10
	ldy #16
	ldx #4
dn_loop
	clc
	lda setup_screen.dlist,x
	adc #$40
	sta setup_screen.dlist,x
	inx
	lda setup_screen.dlist,x
	adc #0
	sta setup_screen.dlist,x
	inx
	inx
	dey
	bne dn_loop

	jmp game

scroll_up
	delay #10
	ldy #16
	ldx #4
up_loop
	sec
	lda setup_screen.dlist,x
	sbc #$40
	sta setup_screen.dlist,x
	inx
	lda setup_screen.dlist,x
	sbc #0
	sta setup_screen.dlist,x
	inx
	inx
	dey
	bne up_loop

	jmp game

scroll_left
	delay #10
	ldy #16
	ldx #4
loop
	sec
	lda setup_screen.dlist,x
	sbc #$02
	sta setup_screen.dlist,x
	inx
	lda setup_screen.dlist,x
	sbc #$00
	sta setup_screen.dlist,x
	inx
	inx
	dey
	bne loop
	jmp game

scroll_right
	delay #10
	ldy #16
	ldx #4
loop2
	clc
	lda setup_screen.dlist,x
	adc #$02
	sta setup_screen.dlist,x
	inx
	lda setup_screen.dlist,x
	adc #$00
	sta setup_screen.dlist,x
	inx
	inx
	dey
	bne loop2
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
	lda :src
	asl
	sta :dest
	clc
	adc #1
	sta :dest+1
	.endm
* --------------------------------------- *
* Proc: display_map                       *
* Displays the current map                *
* --------------------------------------- *
.proc display_map
; Canvas size is 256x256
; Clear the canvas
; blit the map into the middle of the canvas
; calculate the viewport position

canvas = $870e

canvas_width = 64
canvas_height = 64
vert_offset = 12
hor_offset = 12

	; Line 1
	blit map canvas
	blit map+1 canvas+2
	blit map+2 canvas+4
	blit map+3 canvas+6
	blit map+4 canvas+8

	; Line 2
	blit map+5 canvas+64
	blit map+6 canvas+64+2
	blit map+7 canvas+64+4
	blit map+8 canvas+64+6
	blit map+9 canvas+64+8

	; Line 3
	blit map+10 canvas+128
	blit map+11 canvas+128+2
	blit map+12 canvas+128+4
	blit map+13 canvas+128+6
	blit map+14 canvas+128+8

	; Line 4
	blit map+15 canvas+192
	blit map+16 canvas+192+2
	blit map+17 canvas+192+4
	blit map+18 canvas+192+6
	blit map+19 canvas+192+8

	; Line 5
	blit map+20 canvas+256
	blit map+21 canvas+256+2
	blit map+22 canvas+256+4
	blit map+23 canvas+256+6
	blit map+24 canvas+256+8

	rts
	
map
	.byte 1,1,1,1,1
	.byte 1,2,2,2,1
	.byte 1,2,2,2,1
	.byte 1,2,2,2,1
	.byte 1,1,1,1,1

	.endp
