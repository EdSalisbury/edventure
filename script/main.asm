; EdVenture - An Adventure in Atari 8-Bit Assembly
; github.com/edsalisbury/edventure
; Mission: EdPossible
; youtube.com/MissionEdPossible
; Assemble in MADS: mads -l -t main.asm
; Video 5: More work with character sets

; ATASCII Table: https://www.atariwiki.org/wiki/attach/Atari%20ATASCII%20Table/ascii_atascii_table.pdf
; ATASCII 0-31 Screen code 64-95
; ATASCII 32-95 Screen code 0-63
; ATASCII 96-127 Screen code 96-127

; NTSC Color Palette: https://atariage.com/forums/uploads/monthly_10_2015/post-6369-0-47505700-1443889945.png
; PAL Color Palette: https://atariage.com/forums/uploads/monthly_10_2015/post-6369-0-90255700-1443889950.png

	org $2000

charset = $3c00 ; Character Set
screen = $4000  ; Screen buffer

	load_gfx()
	setup_screen()
	setup_colors()
	display_map()

	jmp *

	icl 'hardware.asm'
	icl 'dlist.asm'
	icl 'gfx.asm'

* ------------------------------------- *
* Proc: display_map                     *
* Displays the map                      *
* ------------------------------------- *
.proc display_map()
	ldx #0
loop
	mva map,x screen,x
	inx
	cpx #4
	bne loop
	rts

map
	.byte 3,4,3,4

	.endp

* ------------------------------------- *
* Proc: load_gfx                        *
* Loads graphics into the character set *
* ------------------------------------- *
.proc load_gfx()
	mva #>charset CHBAS

	ldx #0
loop
	mva gfx,x charset+8,x
	inx
	cpx #32
	bne loop
	rts
	.endp

* ----------------------------------- *
* Proc: setup_colors                  *
* Sets up colors                      *
* ----------------------------------- *
.proc setup_colors()
med_gray = $06
lt_gray = $0a
green = $c2
brown = $22
black = $00

	mva #med_gray COLOR0 ; %01
	mva #lt_gray COLOR1  ; %10
	mva #green COLOR2	 ; %11
	mva #brown COLOR3    ; %11 (inverse)
	mva #black COLOR4    ; %00
	rts
	.endp
