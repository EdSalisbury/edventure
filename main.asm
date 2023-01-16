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

map     	= $3000 ; Map
charset 	= $4000 ; Character Set
pmg     	= $5000 ; Player Missle Data
screen  	= $6000 ; Screen buffer

stick_up    = %0001
stick_down  = %0010 
stick_left  = %0100
stick_right = %1000

map_ptr 	= $92
screen_ptr 	= $94
player_x	= $96
player_y	= $97
tmp			= $98
up_tile		= $9a
down_tile	= $9b
left_tile	= $9c
right_tile	= $9d
on_tile		= $9e

screen_char_width = 40
screen_width = 19
screen_height = 11
map_width = 49
map_height = 49

	lda #16
	sta player_x
	sta player_y

	setup_screen()
	setup_colors()
	mva #>charset CHBAS
	clear_pmg()
	load_pmg()
	setup_pmg()

game
	read_joystick()
	blit_screen()
	jmp game

.proc read_joystick
	lda STICK0
	and #stick_up
	beq move_up

	lda STICK0
	and #stick_down
	beq move_down

	lda STICK0
	and #stick_left
	beq move_left

	lda STICK0
	and #stick_right
	beq move_right

	jmp done

move_up
	lda up_tile
	cmp #1
	beq done
	delay #5
	lda player_y
	sub #1
	sta player_y
	jmp done

move_down
	lda down_tile
	cmp #1
	beq done
	delay #5
	lda player_y
	add #1
	sta player_y
	jmp done

move_left
	lda left_tile
	cmp #1
	beq done
	delay #5
	lda player_x
	sub #1
	sta player_x
	jmp done

move_right
	lda right_tile
	cmp #1
	beq done
	delay #5
	lda player_x
	add #1
	sta player_x
	jmp done

done
	rts
	.endp

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

.macro blit_tile
	lda (map_ptr),y			; Load the tile from the map
	asl						; Multiply by two to get left character
	sta (screen_ptr),y		; Store the left character
	inc screen_ptr			; Advance the screen pointer
	add #1					; Add one to get right character
	sta (screen_ptr),y		; Store the right character
	adw map_ptr #1			; Advance the map pointer
	adw screen_ptr #1		; Advance the screen pointer	
	.endm

.macro blit_circle_line body, map_space, screen_space
	adw map_ptr #:map_space
	adw screen_ptr #:screen_space
	ldx #:body
loop
	blit_tile()
	dex
	bne loop

	adw map_ptr #:map_space
	adw map_ptr #(map_width - screen_width)
	adw screen_ptr #:screen_space
	adw screen_ptr #(screen_char_width - screen_width * 2)
	.endm

.proc map_offset
	mwa #map map_ptr
	mwa #screen screen_ptr

	; Shift vertically for player's y position
	lda player_y
	sub #(screen_height / 2)
	sub #1
	tay
loop
	adw map_ptr #map_width
	dey
	bne loop

	; Shift horizontally for player's x position
	lda player_x
	sub #(screen_width / 2)
	sta tmp
	lda #0
	sta tmp + 1
	adw map_ptr tmp

	rts
	.endp

.proc blit_screen
	map_offset()

	ldy #0

	; 2 Blank lines
	adw screen_ptr #(screen_char_width * 2)
	adw map_ptr #(map_width * 2)
	
	; Top 3 lines of the circle
	blit_circle_line 5, 7, 14
	blit_circle_line 7, 6, 12
	blit_circle_line 9, 5, 10

	; Line above the player
	adw map_ptr #9				; Advance to the tile above the player
	lda (map_ptr),y				; Load in the tile
	sta up_tile					; Store the tile
	sbw map_ptr #9				; Undo math
	blit_circle_line 9, 5, 10

	adw map_ptr #8				; Advance to the tile to the left of the player
	lda (map_ptr),y				; Load in the tile
	sta left_tile				; Store the tile
	adw map_ptr #1				; Advance to the tile that the player is on
	lda (map_ptr),y				; Load in the tile
	sta on_tile					; Store the tile
	adw map_ptr #1				; Advance to the tile to the right of the player
	lda (map_ptr),y				; Load in the tile
	sta right_tile				; Store the tile
	sbw map_ptr #10				; Undo math
	blit_circle_line 9, 5, 10

	; Line below the player
	adw map_ptr #9				; Advance to the tile below the player
	lda (map_ptr),y				; Load in the tile
	sta down_tile				; Store the tile
	sbw map_ptr #9				; Undo math
	blit_circle_line 9, 5, 10
	
	; Bottom 3 lines of the circle
	blit_circle_line 9, 5, 10
	blit_circle_line 7, 6, 12
	blit_circle_line 5, 7, 14
	rts
.endp


* --------------------------------------- *
* Proc: copy_map_to_screen                *
* Copies map to screen with interpolation *
* --------------------------------------- *
.proc copy_map_to_screen




	ldy #0
loop
	lda (map_ptr),y
	asl
	sta (screen_ptr),y

	inc screen_ptr
	bne next
	inc screen_ptr+1

next
	add #1
	sta (screen_ptr),y
	iny
	bne loop

	inc map_ptr+1
	inc screen_ptr+1

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
