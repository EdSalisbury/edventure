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

; RAM: $2000-7FFF - 24K
; 16K Cartridge ROM: $8000-BFFF - 16K
; Maximum Usable RAM and ROM: 2000-BFFF = 40K
	org $b000

; RAM $2000-7FFF
map					= $2000 ; 16,641 bytes
; NOTE: Temporarily using more than 16k due to borders
screen				= $7000 ; 480 bytes
status_line			= $71E0 ; 40 bytes
tmp_room			= $7208 ; 225 bytes

pmg					= $7400 ; 1K

; ROM $8000-8FFF
charset_dungeon_a 	= $8000 ; 1K
charset_dungeon_b 	= $8400 ; 1K
charset_outdoor_a 	= $8800 ; 1K
charset_outdoor_b 	= $8c00 ; 1K
; ROM $9000-9FFF
monsters_a			= $9000 ; 1K
monsters_b			= $9400 ; 1K
; 512 bytes free
; ROM $A000-AFFF
rooms				= $a000 ; 3600 Bytes
room_positions		= $ae10 ; 32 Bytes
; ROM $B000-BFFF (Code)

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

tmp_addr1	= $a0
tmp_addr2   = $a2

screen_char_width = 40
screen_width = 19
screen_height = 11


playfield_width = 11
playfield_height = 11

game_timer = $a4
game_tick = 10

status_ptr = $a5
room_ptr = $a7

rand = $aa
room_num = $ab
room_pos = $ac
room_x = $ad
room_y = $ae
room_pos_ptr = $af ; 16-bit

doors = $b1
tmp_ptr = $b2 ; 16-bit
tmp1 = $b4
tmp2 = $b5

; Colors
white = $0a
red = $32
black = $00
peach = $2c
blue = $92
gold = $2a

border = 6
map_width = 127 + border * 2
map_height = 127 + border * 2
room_width = 15
room_height = 15

	;mva #3 rand ; Seed the random number generator (will use RANDOM in the future)
	mva RANDOM rand

	clear_pmg()
	load_pmg()
	setup_pmg()
 	setup_colors()
 	mva #>charset_outdoor_a CHBAS
 	display_borders()
 	update_ui()
	new_map()
	setup_screen()

 	update_player_tiles()
 	reset_timer

game
 	lda RTCLK2
 	cmp game_timer
 	bne game

 	read_joystick()
	blit_screen()
 	reset_timer

 	jmp game

.macro reset_timer
	lda RTCLK2
	add #game_tick
	sta game_timer
	.endm

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
	cmp #55
	bcc done
	dec player_y
	update_player_tiles()
	jmp done

move_down
	lda down_tile
	cmp #55
	bcc done
	inc player_y
	update_player_tiles()
	jmp done

move_left
	lda left_tile
	cmp #55
	bcc done
	dec player_x
	update_player_tiles()
	jmp done

move_right
	lda right_tile
	cmp #55
	bcc done
	inc player_x
	update_player_tiles()
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

	icl 'pmgdata.asm'

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

.macro blit_tile
	lda (map_ptr),y			; Load the tile from the map
	asl						; Multiply by two to get left character
	sta (screen_ptr),y		; Store the left character
	inc16 screen_ptr		; Advance the screen pointer
	add #1					; Add one to get right character
	sta (screen_ptr),y		; Store the right character
	adw map_ptr #1			; Advance the map pointer
	adw screen_ptr #1		; Advance the screen pointer	
	.endm

.macro blit_circle_line body, map_space, screen_space
	mwa map_ptr tmp_addr1
	mwa screen_ptr tmp_addr2
	
	adw map_ptr #:map_space
	adw screen_ptr #:screen_space
	ldx #:body
loop
	blit_tile()
	dex
	bne loop

	mwa tmp_addr1 map_ptr
	mwa tmp_addr2 screen_ptr
	.endm

.proc map_offset
	mwa #map map_ptr
	mwa #screen screen_ptr

	; Shift vertically for player's y position
	lda player_y
	sub #(playfield_height / 2)
	tay
loop
	adw map_ptr #map_width
	dey
	bne loop

	; Shift horizontally for player's x position
	lda player_x
	sub #(playfield_width / 2)
	sta tmp
	lda #0
	sta tmp + 1
	adw map_ptr tmp

	rts
	.endp

.proc update_player_tiles
	mwa #map map_ptr

	ldy player_y
loop
	adw map_ptr #map_width
	dey
	bne loop

	adbw map_ptr player_x

	; Get the tile the player is on
	ldy #0
	lda (map_ptr),y
	sta on_tile

	; Get the tile to the left of the player
	dec16 map_ptr
	lda (map_ptr),y
	sta left_tile

	; Get the tile to the right of the player
	inc16 map_ptr
	inc16 map_ptr
	lda (map_ptr),y
	sta right_tile

	; Get the tile above the player
	dec16 map_ptr
	sbw map_ptr #map_width
	lda (map_ptr),y
	sta up_tile

	; Get the tile below the player
	adw map_ptr #(map_width * 2)
	lda (map_ptr),y
	sta down_tile

	rts
	.endp

.macro blit_char char addr pos
	lda :char
	ldy :pos
	sta (:addr),y
	.endm

.macro blit_char_row char addr start end
	lda :char
	ldy :start
loop
	sta (:addr),y
	iny
	cpy :end
	bcc loop
	.endm

.proc display_borders
	mwa #status_line status_ptr
	mwa #screen screen_ptr

	blit_char #UI_NW_BORDER status_ptr #0
	blit_char_row #UI_HORIZ_BORDER status_ptr #1 #23
	blit_char #UI_TOP_TEE status_ptr #23
	blit_char_row #UI_HORIZ_BORDER status_ptr #24 #39
	blit_char #UI_NE_BORDER status_ptr #39
	
	ldx #playfield_height
loop
	blit_char #UI_VERT_BORDER screen_ptr #0
	blit_char #UI_VERT_BORDER screen_ptr #23
	blit_char #UI_VERT_BORDER screen_ptr #39
	adw screen_ptr #screen_char_width
	dex
	bne loop

	blit_char #UI_SW_BORDER screen_ptr #0
	blit_char_row #UI_HORIZ_BORDER screen_ptr #1 #23
	blit_char #UI_BOTTOM_TEE screen_ptr #23
	blit_char_row #UI_HORIZ_BORDER screen_ptr #24 #39
	blit_char #UI_SE_BORDER screen_ptr #39
	
	rts
	.endp

.proc update_ui
	mwa #screen screen_ptr
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
	blit_char #UI_HP_3_QTR screen_ptr #34
	blit_char #UI_BAR_RIGHT screen_ptr #35

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

	adw screen_ptr #screen_char_width

	; XP Bar
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


.proc blit_screen
	map_offset()

	ldy #0
	; Line #1
	adw screen_ptr #screen_char_width
	adw map_ptr #map_width
	blit_circle_line 5, 3, 7

	; Line #2
	adw screen_ptr #screen_char_width
	adw map_ptr #map_width
	blit_circle_line 7, 2, 5

	; Line #3
	adw screen_ptr #screen_char_width
	adw map_ptr #map_width
	blit_circle_line 9, 1, 3

	; Line #4
	adw screen_ptr #screen_char_width
	adw map_ptr #map_width
	blit_circle_line 9, 1, 3

	; Line #5
	adw screen_ptr #screen_char_width
	adw map_ptr #map_width
	blit_circle_line 9, 1, 3

	; Line #6
	adw screen_ptr #screen_char_width
	adw map_ptr #map_width
	blit_circle_line 9, 1, 3

	; Line #7
	adw screen_ptr #screen_char_width
	adw map_ptr #map_width
	blit_circle_line 9, 1, 3

	; Line #8
	adw screen_ptr #screen_char_width
	adw map_ptr #map_width
	blit_circle_line 7, 2, 5

	; Line #9
	adw screen_ptr #screen_char_width
	adw map_ptr #map_width
	blit_circle_line 5, 3, 7

	rts
	.endp

; Uses a linear-feedback shift register (LFSR) to generate 8-bit pseudo-random numbers
; More info: https://en.wikipedia.org/wiki/Linear-feedback_shift_register
; Also here: https://forums.atariage.com/topic/159268-random-numbers/#comment-1958751
; Also here: https://github.com/bbbradsmith/prng_6502

.proc random8
    lda rand		; Load in seed (either from initial or previous run)
    lsr				; Shift accumulator 1 bit to the right
    bcc no_eor		; Carry flag contains last bit prior to shifting, if it's 0, skip XOR
    eor #$b4		; XOR with feedback value that produces a good sequence
no_eor
    sta rand		; Store the random number
    rts				; Return
    .endp

	icl 'macros.asm'
	icl 'labels.asm'
	icl 'hardware.asm'
	icl 'dlist.asm'
	icl 'map_gen.asm'
	icl 'charset_dungeon_a.asm'
	icl 'charset_outdoor_a.asm'
	icl 'monsters_a.asm'
	icl 'rooms.asm'
