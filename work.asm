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

charset = $5000 ; Character Set (1K)
screen = $4000  ; Screen buffer
pmg = $3000 ; PMG (1K)
pmg_p0 = $3200
pmg_p1 = $3280
pmg_p2 = $3300
pmg_p3 = $3380

; Page 0 vars
pmgdata = $92 ; Player-Missile Graphics Data location (2K)
ylocp0 = $94
ylocp1 = $96
ylocp2 = $98
ylocp3 = $9a

; Free Memory locations
; 92-CA - Basic
; CB-CF - Unused
; D0-23 - Unused
; E0-EF - Floating point registers

	; lda RAMTOP
	; sec ; set carry flag
	; sbc #4 ; subtract 4 pages (1K) for double line resolution
	; sta RAMTOP
	; sta PMBASE

	; Store the pmg location
	; sta pmgdata+1 ; high byte
	; lda #0
	; sta pmgdata

	lda #>pmg
	sta PMBASE
	;sta pmgdata+1
	;lda #0
	;sta pmgdata

	mva #46 SDMCTL ; Single Line resolution
	mva #3 GRACTL  ; Enable PMG
	mva #1 GRPRIOR ; Give players priority
	
	setup_screen()
	setup_colors()

	mva #>charset CHBAS

	; mva #0 SIZEP0 ; Normal width
	; mva #0 SIZEP1
	; mva #0 SIZEP2
	; mva #0 SIZEP3

	; Set player positions
	lda #120
	sta HPOSP0
	sta HPOSP1
	sta HPOSP2
	sta HPOSP3
	
	; Set player colors
	mva #$f2 PCOLR0
	mva #$2e PCOLR1
	mva #$80 PCOLR2
	mva #$0e PCOLR3

	; ylocp0 = pmgdata + 512
	; ylocp1 = pmgdata + 640
	; ylocp2 = pmgdata + 768
	; ylocp3 = pmgdata + 896

	; pmgdata = $0060
	; ylocp0 = $0062
	; ylocp1 = $8062
	; ylocp2 = $0063
	; ylocp3 = $8063

	;lda pmgdata+1
	; lda #>pmg
	; clc
	; adc #2
	; sta ylocp0+1
	; sta ylocp1+1
	; adc #1
	; sta ylocp2+1
	; sta ylocp3+1

	; lda #64 ; Start on line 0
	; sta ylocp0
	; sta ylocp2
	; lda #192 ; line 0 + offset of 128
	; sta ylocp1
	; sta ylocp3

	; Clear memory
	ldy #0
	lda #0
clear_loop
	;sta (pmgdata),y
	sta pmg,y
	inx
	bne clear_loop
	
	ldx #0
load_p0
	;mva p0,y (ylocp0),y
	;mva p0,y pmg_p0,y
	mva p0,x pmg_p0+64,x
	inx
	cpx #8
	bne load_p0

	ldy #0
load_p1
	;mva p1,y (ylocp1),y
	mva p1,y pmg_p1+64,y
	iny
	cpy #8
	bne load_p1

	ldy #0
load_p2
	;mva p2,y (ylocp2),y
	mva p2,y pmg_p2+64,y
	iny
	cpy #8
	bne load_p2

	ldy #0
load_p3
	;mva p3,y (ylocp3),y
	mva p3,y pmg_p3+64,y
	iny
	cpy #8
	bne load_p3


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
	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.byte 2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,0,0
	.byte 2,3,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,2,3,0,0
	.byte 2,3,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,2,3,0,0
	.byte 2,3,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,2,3,0,0
	.byte 2,3,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,2,3,0,0
	.byte 2,3,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,2,3,2,3,6,7,2,3,2,3,0,0
	.byte 2,3,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,2,3,4,5,4,5,4,5,2,3,0,0
	.byte 2,3,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,2,3,4,5,10,11,4,5,2,3,0,0
	.byte 2,3,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,2,3,4,5,4,5,4,5,2,3,0,0
	.byte 2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,0,0
	.byte 12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,0,0

	.endp


p0 ; black
	.byte %00111100
	.byte %01000000
	.byte %01010100
	.byte %00000001
	.byte %00000000
	.byte %10000000
	.byte %00000000
	.byte %00110110

p1 ; flesh
	.byte %00000000
	.byte %00111100
	.byte %00101000
	.byte %00111100
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

p2 ; blue
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %01111110
	.byte %00111100
	.byte %00100100
	.byte %00000000

p3 ; color 4
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
