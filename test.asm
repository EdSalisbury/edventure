
	org $b000

screen  			= $7000 ; Screen buffer (480 bytes)
blank8 = $70    ; 8 blank lines
lms = $40	    ; Load Memory Scan
jvb = $41	    ; Jump while vertical blank
antic5 = 5	    ; Antic mode 5
screen_ptr 	= $94

charset_ptr = $96
white = $0a
red = $32
black = $00
peach = $2c
blue = $92
gold = $2a
tmp_addr1	= $a0
tmp_addr2   = $a2

charset_dungeon_a_colors		= $aee0 ; 16 bytes
charset_outdoor_colors		= $aef0 ; 16 bytes
monsters_a_colors		= $af00 ; 16 bytes

cur_charset_a		= $7800 ; Current character set A (1K)
cur_charset_b		= $7c00 ; Current character set B (1K)

; 16K Cartridge ROM: $8000-BFFF - 16K
; 8000-8FFF
charset_dungeon_a 	= $8000 ; Main character set (1K)
charset_dungeon_b 	= $8400 ; Main character set (1K)
charset_outdoor_a 	= $8800 ; Character Set for outdoors (1K)
charset_outdoor_b 	= $8c00 ; Character Set for outdoors (1K)

; 9000-9FFF
monsters_a          = $9000 ; Monster characters (1K)
monsters_b          = $9400 ; Monster characters (1K)
; free
dlist				= $9800
clock				= $bf
anim_timer			= $c0
charset_a			= $c1
tmp			= $98
tmp2				= $bd
anim_speed 			= 20


	mva #white COLOR0 	; %01
	mva #red COLOR1  	; %10
	mva #blue COLOR2	; %11
	mva #gold COLOR3    ; %11 (inverse)
	mva #black COLOR4   ; %00

    
	mwa #dlist SDLSTL
    ;mva #>cur_charset_a CHBAS

    copy_data charset_dungeon_a cur_charset_a 4

num_monsters = $be
start_monster = $c2

    mva #5 num_monsters
    mva #3 start_monster

	copy_monsters monsters_a cur_charset_a start_monster num_monsters

    mva #>cur_charset_a CHBAS
    blit_screen

game
	mva RTCLK2 clock
	jmp game

    org dlist
	.byte blank8, blank8, blank8
	.byte antic5 + lms, <screen, >screen
	.byte antic5
	.byte antic5, antic5, antic5, antic5, antic5
	.byte antic5, antic5, antic5, antic5, antic5, antic5
	.byte jvb, <dlist, >dlist

.macro blit_screen
    mwa #screen screen_ptr
    mwa #cur_charset_a charset_ptr

    lda #0
    tay
loop
    tya
    sta (screen_ptr),y
    iny
    cpy #128
    bne loop
    
    .endm

    icl 'macros.asm'
	icl 'hardware.asm'
    icl 'charset_dungeon_a.asm'
	icl 'charset_dungeon_b.asm'
	icl 'charset_outdoor_a.asm'
	icl 'monsters_a.asm'
	icl 'monsters_b.asm'
	icl 'charset_dungeon_a_colors.asm'
	icl 'monsters_a_colors.asm'

