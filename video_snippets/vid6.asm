; EdVenture - An Adventure in Atari 8-Bit Assembly
; github.com/edsalisbury/edventure
; Mission: EdPossible
; youtube.com/MissionEdPossible
; Assemble in MADS: mads -l -t edventure.asm
; Video 6: Basic map

    org $2000

; Hardware
SAVMSC   = $0058 ; Screen memory starting address
SDLSTL   = $0230 ; Display list starting address
CHBAS	 = $02f4 ; Character Base register
COLOR0 	 = $02c4 ; Color for %01
COLOR1   = $02c5 ; Color for %10
COLOR2   = $02c6 ; Color for %11 (normal)
COLOR3   = $02c7 ; Color for %11 (inverse)
COLOR4   = $02c8 ; Color for %00 (background)

; Buffers
screen = $4000  ; Our screen buffer
chrset = $2400  ; Our character set buffer

; Display List
blank8 = $70    ; 8 blank lines in the display list
antic5 = $05    ; ANTIC mode 5 (4 colors, 4x8 characters, 40 columns, 12 rows)
lms = $40       ; Load memory scan
jvb = $41       ; Jump while vertical blank

; Colors
med_gray = $06
lt_gray = $0a
green = $c2
brown = $22
black = $00


; Set up Display list
    mwa #dlist SDLSTL

; Use Custom character set
	mva #>chrset CHBAS

; Copy custom characters to character set buffer
	ldx #0
next_line
	mva charset,x chrset,x
	mva charset+$100,x chrset+$100,x
	mva charset+$200,x chrset+$200,x
	mva charset+$300,x chrset+$300,x
	inx
	bne next_line

; Change colors
	mva #med_gray COLOR0
	mva #lt_gray COLOR1
	mva #green COLOR2
	mva #brown COLOR3
	mva #black COLOR4

; Display map
	ldx #0
map_loop
	mva map,x screen,x
	inx
	cpx #120
	bne map_loop

    jmp *

; Display list data
dlist
    .byte blank8, blank8, blank8
    .byte lms + antic5, <screen, >screen
    .byte antic5, antic5, antic5, antic5, antic5, antic5, antic5, antic5, antic5, antic5, antic5, antic5
    .byte jvb, <dlist, >dlist

map
	.byte 2, 3, 2, 3, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.byte 2, 3, 10, 11, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.byte 2, 3, 2, 3, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

	icl "charset.asm"