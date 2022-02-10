; EdVenture - An Adventure in Atari 8-Bit Assembly
; github.com/edsalisbury/edventure
; Mission: EdPossible
; youtube.com/MissionEdPossible
; Assemble in MADS: mads -l -t main.asm
; Video 6: Reorganization and more graphics

; ATASCII Table: https://www.atariwiki.org/wiki/attach/Atari%20ATASCII%20Table/ascii_atascii_table.pdf
; ATASCII 0-31 Screen code 64-95
; ATASCII 32-95 Screen code 0-63
; ATASCII 96-127 Screen code 96-127

; NTSC Color Palette: https://atariage.com/forums/uploads/monthly_10_2015/post-6369-0-47505700-1443889945.png
; PAL Color Palette: https://atariage.com/forums/uploads/monthly_10_2015/post-6369-0-90255700-1443889950.png

	org $2000

charset = $5000 ; Character Set
screen = $4000  ; Screen buffer

	setup_screen()
	setup_colors()
	;load_gfx()
	mva #>charset CHBAS
	display_map()

	jmp *

	icl 'hardware.asm'
	icl 'dlist.asm'
	icl 'gfx.asm'

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

	mva #med_gray COLOR0 ; %01
	mva #lt_gray COLOR1  ; %10
	mva #green COLOR2	 ; %11
	mva #brown COLOR3    ; %11 (inverse)
	mva #black COLOR4    ; %00
	rts
	.endp

* --------------------------------------- *
* Proc: load_gfx                          *
* Loads graphics into character set       *
* --------------------------------------- *
; .proc load_gfx
; 	mva #>charset CHBAS

; 	ldx #0
; loop
; 	mva gfx,x charset,x
; 	mva gfx+8,x charset+8,x
; 	mva gfx+16,x charset+16,x
; 	mva gfx+32,x charset+32,x
	
; 	inx
; 	cpx #128
; 	bne loop
; 	rts
; 	.endp

* --------------------------------------- *
* Proc: display_map                       *
* Displays the current map                *
* --------------------------------------- *
.proc display_map
	ldy #0
loop
	mva map,y screen,y
	mva map+40,y screen+40,y
	mva map+80,y screen+80,y
	mva map+120,y screen+120,y
	mva map+160,y screen+160,y
	mva map+200,y screen+200,y
	mva map+240,y screen+240,y
	mva map+280,y screen+280,y
	mva map+320,y screen+320,y
	mva map+360,y screen+360,y
	mva map+400,y screen+400,y
	mva map+440,y screen+440,y

	iny
	cpy #40
	bne loop
	rts
	
map
	.byte 2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3
	.byte 2,3,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,2,3
	.byte 2,3,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,2,3
	.byte 2,3,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,2,3
	.byte 2,3,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,2,3
	.byte 2,3,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,2,3
	.byte 2,3,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,2,3
	.byte 2,3,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,2,3,2,3,6,7,2,3,2,3
	.byte 2,3,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,2,3,4,5,4,5,4,5,2,3
	.byte 2,3,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,2,3,4,5,10,11,4,5,2,3
	.byte 2,3,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,2,3,4,5,4,5,4,5,2,3
	.byte 2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3
	.endp
