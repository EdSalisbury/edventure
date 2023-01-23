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

map     			= $3000 ; Map
pmg     			= $4000 ; Player Missle Data
charset_dungeon_a 	= $5000 ; Main character set
charset_outdoor_a 	= $6000 ; Character Set for outdoors
monsters_a          = $7000 ; Monster characters
status_line			= $6400
screen  			= $8000 ; Screen buffer

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

status_ptr  = $a0

screen_char_width = 40
screen_width = 19
screen_height = 11
map_width = 49
map_height = 49

; Colors
white = $0a
red = $32
black = $00
peach = $2c
blue = $92
gold = $2a

	lda #16
	sta player_x
	sta player_y

	mva #>charset_outdoor_a CHBAS
	setup_screen()
	setup_colors()
	clear_pmg()
	load_pmg()
	setup_pmg()

	display_borders()
	update_ui()
	blit_screen()

game
	;read_joystick()
	
	jmp game

.proc read_joystick
	pha
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
	blit_screen()
	jmp done

move_down
	lda down_tile
	cmp #1
	beq done
	delay #5
	lda player_y
	add #1
	sta player_y
	blit_screen()
	jmp done

move_left
	lda left_tile
	cmp #1
	beq done
	delay #5
	lda player_x
	sub #1
	sta player_x
	blit_screen()
	jmp done

move_right
	lda right_tile
	cmp #1
	beq done
	delay #5
	lda player_x
	add #1
	sta player_x
	blit_screen()
	jmp done

done
	pla
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


	; Character Set Colors
	mva #white COLOR0 	; %01
	mva #red COLOR1  	; %10
	mva #blue COLOR2	; %11
	mva #gold COLOR3    ; %11 (inverse)
	mva #black COLOR4   ; %00

	; Player-Missile Colors
	mva #red PCOLR0
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
	mva pmgdata,x pmg_p0+60,x
	mva pmgdata+8,x pmg_p1+60,x
	mva pmgdata+16,x pmg_p2+60,x
	mva pmgdata+24,x pmg_p3+60,x
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
	lda #92
	sta HPOSP0
	sta HPOSP1
	sta HPOSP2
	sta HPOSP3
	rts
	.endp

.macro inc16 addr
	inc :addr
	bne skip_carry
	inc :addr + 1
skip_carry
	.endm

.macro blit_tile
	lda (map_ptr),y			; Load the tile from the map
	asl						; Multiply by two to get left character
	sta (screen_ptr),y		; Store the left character
	inc16 screen_ptr		; Advance the screen pointer
	add #1					; Add one to get right character
	sta (screen_ptr),y		; Store the right character
	inc16 map_ptr			; Advance the map pointer
	inc16 screen_ptr		; Advance the screen pointer	
	.endm

.macro blit_circle_line body, map_space, screen_space_left, screen_space_right
	adw map_ptr #:map_space
	adw screen_ptr #:screen_space_left
	ldx #:body
loop
	blit_tile()
	dex
	bne loop

	adw map_ptr #:map_space
	adw map_ptr #(map_width - screen_width)
	adw screen_ptr #:screen_space_right
	adw screen_ptr #(screen_char_width - screen_width * 2)
	.endm

.proc map_offset
	pha
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

	pla
	rts
	.endp

.macro blit_char char addr pos
	lda :char
	ldy :pos
	sta (:addr),y
	.endm

.macro blit_char_line char addr start end
	lda :char
	ldy :start
loop
	sta (:addr),y
	iny
	cpy :end
	bcc loop
	.endm

.proc update_ui
	mwa #screen screen_ptr

; UI_WHITE_KEY_ICON_LEFT	= 10
; UI_WHITE_KEY_ICON_RIGHT	= 11
; UI_BLACK_KEY_ICON_LEFT	= 12
; UI_BLACK_KEY_ICON_RIGHT	= 13
; UI_BLUE_KEY_ICON_LEFT	= 14
; UI_BLUE_KEY_ICON_RIGHT	= 15
; UI_RED_KEY_ICON_LEFT	= 16
; UI_RED_KEY_ICON_RIGHT	= 17
; UI_GOLD_KEY_ICON_LEFT	= 18 + 128
; UI_GOLD_KEY_ICON_RIGHT	= 19 + 128

UI_WHITE_KEY_ICON		= 10
UI_KEY_ICON_RIGHT		= 11
UI_BLUE_KEY_ICON		= 12
UI_RED_KEY_ICON			= 13
UI_GOLD_KEY_ICON		= 14 + 128
UI_BLACK_KEY_CAP_LEFT	= 15
UI_BLACK_KEY_ICON_LEFT	= 16
UI_BLACK_KEY_ICON_RIGHT	= 17
UI_BLACK_KEY_CAP_RIGHT	= 18

UI_MELEE_ICON_LEFT 		= 26
UI_MELEE_ICON_RIGHT 	= 27
UI_DEFENSE_ICON_LEFT 	= 28
UI_DEFENSE_ICON_RIGHT 	= 29
UI_RANGED_ICON_LEFT 	= 30
UI_RANGED_ICON_RIGHT 	= 31
UI_FORTITUDE_ICON_LEFT 	= 32
UI_FORTITUDE_ICON_RIGHT = 33
UI_TORCH_ICON_LEFT		= 34 + 128
UI_TORCH_ICON_RIGHT		= 35 + 128
UI_COIN_ICON_LEFT		= 36 + 128
UI_COIN_ICON_RIGHT		= 37 + 128
UI_POTION_ICON_LEFT		= 38
UI_POTION_ICON_RIGHT	= 39
UI_HP_ICON_LEFT 		= 40
UI_HP_ICON_RIGHT 		= 41
UI_XP_ICON_LEFT 		= 42
UI_XP_ICON_RIGHT 		= 43
UI_NUMBER_0				= 44
UI_NUMBER_1				= 45
UI_NUMBER_2				= 46
UI_NUMBER_3				= 47
UI_NUMBER_4				= 48
UI_NUMBER_5				= 49
UI_NUMBER_6				= 50
UI_NUMBER_7				= 51
UI_NUMBER_8				= 52
UI_NUMBER_9				= 53
UI_BAR_LEFT 			= 54
UI_BAR_RIGHT 			= 55
UI_BAR_EMPTY			= 56
UI_COLON				= 57
UI_HP_QTR				= 58
UI_HP_HALF				= 59
UI_HP_3_QTR				= 60
UI_HP_FULL 				= 61
UI_XP_QTR				= 62
UI_XP_HALF				= 63
UI_XP_3_QTR				= 64
UI_XP_FULL 				= 65

UI_BLANK_GEM_ICON_LEFT	= 66
UI_BLANK_GEM_ICON_RIGHT = 67
UI_WHITE_GEM_ICON_LEFT	= 68
UI_WHITE_GEM_ICON_RIGHT = 69
UI_BLACK_GEM_ICON_LEFT	= 70
UI_BLACK_GEM_ICON_RIGHT = 71
UI_BLUE_GEM_ICON_LEFT	= 72
UI_BLUE_GEM_ICON_RIGHT 	= 73
UI_RED_GEM_ICON_LEFT	= 74
UI_RED_GEM_ICON_RIGHT 	= 75
UI_GOLD_GEM_ICON_LEFT	= 76 + 128
UI_GOLD_GEM_ICON_RIGHT 	= 77 + 128
UI_AMULET_NW_ICON_LEFT	= 78
UI_AMULET_NW_ICON_RIGHT	= 79
UI_AMULET_NE_ICON_LEFT	= 80
UI_AMULET_NE_ICON_RIGHT	= 81
UI_AMULET_SW_ICON_LEFT	= 82
UI_AMULET_SW_ICON_RIGHT	= 83
UI_AMULET_SE_ICON_LEFT	= 84
UI_AMULET_SE_ICON_RIGHT	= 85
	
	; HP Bar
	blit_char #UI_HP_ICON_LEFT screen_ptr #25
	blit_char #UI_HP_ICON_RIGHT screen_ptr #26
	blit_char #UI_COLON screen_ptr #27
	blit_char #UI_BAR_LEFT screen_ptr #28
	blit_char #UI_HP_FULL screen_ptr #29
	blit_char #UI_HP_FULL screen_ptr #30
	blit_char #UI_HP_FULL screen_ptr #31
	blit_char #UI_HP_FULL screen_ptr #32
	blit_char #UI_HP_FULL screen_ptr #33
	blit_char #UI_HP_FULL screen_ptr #34
	blit_char #UI_HP_3_QTR screen_ptr #35
	blit_char #UI_BAR_RIGHT screen_ptr #36
	adw screen_ptr #screen_char_width

	; Skills
	blit_char #UI_MELEE_ICON_LEFT screen_ptr #25
	blit_char #UI_MELEE_ICON_RIGHT screen_ptr #26
	blit_char #UI_COLON screen_ptr #27
	blit_char #UI_NUMBER_0 screen_ptr #28
	blit_char #UI_NUMBER_0 screen_ptr #29
	blit_char #UI_NUMBER_0 screen_ptr #30

	blit_char #UI_RANGED_ICON_LEFT screen_ptr #32
	blit_char #UI_RANGED_ICON_RIGHT screen_ptr #33
	blit_char #UI_COLON screen_ptr #34
	blit_char #UI_NUMBER_0 screen_ptr #35
	blit_char #UI_NUMBER_0 screen_ptr #36
	blit_char #UI_NUMBER_0 screen_ptr #37
	adw screen_ptr #screen_char_width

	blit_char #UI_DEFENSE_ICON_LEFT screen_ptr #25
	blit_char #UI_DEFENSE_ICON_RIGHT screen_ptr #26
	blit_char #UI_COLON screen_ptr #27
	blit_char #UI_NUMBER_0 screen_ptr #28
	blit_char #UI_NUMBER_0 screen_ptr #29
	blit_char #UI_NUMBER_0 screen_ptr #30

	blit_char #UI_FORTITUDE_ICON_LEFT screen_ptr #32
	blit_char #UI_FORTITUDE_ICON_RIGHT screen_ptr #33
	blit_char #UI_COLON screen_ptr #34
	blit_char #UI_NUMBER_0 screen_ptr #35
	blit_char #UI_NUMBER_0 screen_ptr #36
	blit_char #UI_NUMBER_0 screen_ptr #37


	; XP Bar
	adw screen_ptr #screen_char_width
	blit_char #UI_XP_ICON_LEFT screen_ptr #25
	blit_char #UI_XP_ICON_RIGHT screen_ptr #26
	blit_char #UI_COLON screen_ptr #27
	blit_char #UI_BAR_LEFT screen_ptr #28
	blit_char #UI_XP_FULL screen_ptr #29
	blit_char #UI_XP_FULL screen_ptr #30
	blit_char #UI_XP_FULL screen_ptr #31
	blit_char #UI_XP_FULL screen_ptr #32
	blit_char #UI_XP_FULL screen_ptr #33
	blit_char #UI_XP_FULL screen_ptr #34
	blit_char #UI_XP_HALF screen_ptr #35
	blit_char #UI_BAR_EMPTY screen_ptr #36
	blit_char #UI_BAR_EMPTY screen_ptr #37
	blit_char #UI_BAR_RIGHT screen_ptr #38

	adw screen_ptr #screen_char_width

	; Inventory
	blit_char #UI_TORCH_ICON_LEFT screen_ptr #25
	blit_char #UI_TORCH_ICON_RIGHT screen_ptr #26
	blit_char #UI_COLON screen_ptr #27
	blit_char #UI_NUMBER_0 screen_ptr #28
	blit_char #UI_NUMBER_0 screen_ptr #29
	blit_char #UI_NUMBER_0 screen_ptr #30

	blit_char #UI_POTION_ICON_LEFT screen_ptr #32
	blit_char #UI_POTION_ICON_RIGHT screen_ptr #33
	blit_char #UI_COLON screen_ptr #34
	blit_char #UI_NUMBER_0 screen_ptr #35
	blit_char #UI_NUMBER_0 screen_ptr #36
	blit_char #UI_NUMBER_0 screen_ptr #37

	adw screen_ptr #screen_char_width
	blit_char #UI_COIN_ICON_LEFT screen_ptr #25
	blit_char #UI_COIN_ICON_RIGHT screen_ptr #26
	blit_char #UI_COLON screen_ptr #27
	blit_char #UI_NUMBER_0 screen_ptr #28
	blit_char #UI_NUMBER_0 screen_ptr #29
	blit_char #UI_NUMBER_0 screen_ptr #30
	blit_char #UI_NUMBER_0 screen_ptr #31
	blit_char #UI_NUMBER_0 screen_ptr #32

	; Amulet
	adw screen_ptr #screen_char_width
	adw screen_ptr #screen_char_width
	blit_char #UI_AMULET_NW_ICON_LEFT screen_ptr #29
	blit_char #UI_AMULET_NW_ICON_RIGHT screen_ptr #30
	blit_char #UI_BLACK_GEM_ICON_LEFT screen_ptr #31
	blit_char #UI_BLACK_GEM_ICON_RIGHT screen_ptr #32
	blit_char #UI_AMULET_NE_ICON_LEFT screen_ptr #33
	blit_char #UI_AMULET_NE_ICON_RIGHT screen_ptr #34

	adw screen_ptr #screen_char_width
	blit_char #UI_BLUE_GEM_ICON_LEFT screen_ptr #29
	blit_char #UI_BLUE_GEM_ICON_RIGHT screen_ptr #30
	blit_char #UI_WHITE_GEM_ICON_LEFT screen_ptr #31
	blit_char #UI_WHITE_GEM_ICON_RIGHT screen_ptr #32
	blit_char #UI_RED_GEM_ICON_LEFT screen_ptr #33
	blit_char #UI_RED_GEM_ICON_RIGHT screen_ptr #34

	adw screen_ptr #screen_char_width
	blit_char #UI_AMULET_SW_ICON_LEFT screen_ptr #29
	blit_char #UI_AMULET_SW_ICON_RIGHT screen_ptr #30
	blit_char #UI_GOLD_GEM_ICON_LEFT screen_ptr #31
	blit_char #UI_GOLD_GEM_ICON_RIGHT screen_ptr #32
	blit_char #UI_AMULET_SE_ICON_LEFT screen_ptr #33
	blit_char #UI_AMULET_SE_ICON_RIGHT screen_ptr #34

	; Keys
	sbw screen_ptr #(screen_char_width * 2)

	; blit_char #UI_BLUE_KEY_ICON_LEFT screen_ptr #26
	; blit_char #UI_BLUE_KEY_ICON_RIGHT screen_ptr #27
	; blit_char #UI_BLACK_KEY_ICON_LEFT screen_ptr #36
	; blit_char #UI_BLACK_KEY_ICON_RIGHT screen_ptr #37
	; adw screen_ptr #screen_char_width

	; blit_char #UI_RED_KEY_ICON_LEFT screen_ptr #26
	; blit_char #UI_RED_KEY_ICON_RIGHT screen_ptr #27
	; blit_char #UI_WHITE_KEY_ICON_LEFT screen_ptr #36
	; blit_char #UI_WHITE_KEY_ICON_RIGHT screen_ptr #37

	; adw screen_ptr #screen_char_width
	; blit_char #UI_GOLD_KEY_ICON_LEFT screen_ptr #26
	; blit_char #UI_GOLD_KEY_ICON_RIGHT screen_ptr #27

	blit_char #UI_BLUE_KEY_ICON screen_ptr #26
	blit_char #UI_KEY_ICON_RIGHT screen_ptr #27

	blit_char #UI_BLACK_KEY_CAP_LEFT screen_ptr #35
	blit_char #UI_BLACK_KEY_ICON_LEFT screen_ptr #36
	blit_char #UI_BLACK_KEY_ICON_RIGHT screen_ptr #37
	blit_char #UI_BLACK_KEY_CAP_RIGHT screen_ptr #38

	adw screen_ptr #screen_char_width
	blit_char #UI_RED_KEY_ICON screen_ptr #26
	blit_char #UI_KEY_ICON_RIGHT screen_ptr #27
	blit_char #UI_WHITE_KEY_ICON screen_ptr #36
	blit_char #UI_KEY_ICON_RIGHT screen_ptr #37

	adw screen_ptr #screen_char_width
	blit_char #UI_GOLD_KEY_ICON screen_ptr #26
	blit_char #UI_KEY_ICON_RIGHT screen_ptr #27
	rts
	.endp



.proc display_borders
	mwa #status_line status_ptr
	mwa #screen screen_ptr

	; Top (status) line
	blit_char #12 status_ptr #0
	blit_char_line #4 status_ptr #1 #23
	blit_char #10 status_ptr #23
	blit_char_line #4 status_ptr #24 #39
	blit_char #13 status_ptr #39

	; Main body
	ldx #11
loop
	blit_char #1 screen_ptr #0
	blit_char #1 screen_ptr #23
	blit_char #1 screen_ptr #39
	adw screen_ptr #40
	dex
	bne loop

	; Bottom line
	blit_char #14 screen_ptr #0
	blit_char_line #4 screen_ptr #1 #23
	blit_char #11 screen_ptr #23
	blit_char_line #4 screen_ptr #24 #39
	blit_char #15 screen_ptr #39

	rts
	.endp

.proc blit_screen
	pha
	map_offset()

	ldy #0

	; 1 Blank lines
	adw screen_ptr #(screen_char_width)
	adw map_ptr #(map_width * 2)
	
	; Top 3 lines of the circle
	blit_circle_line 5, 7, 7, 21
	blit_circle_line 7, 6, 5, 19
	blit_circle_line 9, 5, 3, 17

	; Line above the player
	adw map_ptr #9				; Advance to the tile above the player
	lda (map_ptr),y				; Load in the tile
	sta up_tile					; Store the tile
	sbw map_ptr #9				; Undo math
	blit_circle_line 9, 5, 3, 17

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
	blit_circle_line 9, 5, 3, 17

	; Line below the player
	adw map_ptr #9				; Advance to the tile below the player
	lda (map_ptr),y				; Load in the tile
	sta down_tile				; Store the tile
	sbw map_ptr #9				; Undo math
	blit_circle_line 9, 5, 3, 17
	
	; Bottom 3 lines of the circle
	blit_circle_line 9, 5, 3, 17
	blit_circle_line 7, 6, 5, 19
	blit_circle_line 5, 7, 7, 21
	pla
	rts
.endp

	icl 'hardware.asm'
	icl 'dlist.asm'
	icl 'pmgdata.asm'
	icl 'map.asm'
	icl 'charset_dungeon_a.asm'
	icl 'charset_outdoor_a.asm'
	icl 'monsters_a.asm'
