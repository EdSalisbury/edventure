; EdVenture - An Adventure in Atari 8-Bit Assembly
; github.com/edsalisbury/edventure
; Mission: EdPossible
; youtube.com/MissionEdPossible
; Assemble in MADS: mads -l -t edventure.asm
; Video 3: Fun with character sets!

; ATASCII Table: https://www.atariwiki.org/wiki/attach/Atari%20ATASCII%20Table/ascii_atascii_table.pdf
; ATASCII 0-31 Screen code 64-95
; ATASCII 32-95 Screen code 0-63
; ATASCII 96-127 Screen code 96-127

    org $2000

SAVMSC   = $0058 ; Screen memory starting address
SDLSTL   = $0230 ; Display list starting address
CHBAS	 = $02f4 ; Character Base register

chrset = $3C00  ; Our character set buffer
screen = $4000  ; Our screen buffer

blank8 = $70    ; 8 blank lines in the display list
antic5 = 5      ; ANTIC mode 5 (4 colors, 4x8 characters, 40 columns, 12 rows)
lms = $40       ; Load memory scan
jvb = $41       ; Jump while vertical blank

; Set up Display list
    mwa #dlist SDLSTL

; Use Custom character set
; Charsets always start at the start of a page
; ANTIC knows this, so will multiply whatever number is in CHBAS by 256
; The following two lines are equivelant
	mva #>chrset CHBAS
	;mva #$24 CHBAS
	; Also equivelant

	;lda #$24
	;sta CHBAS

; Copy custom characters to character set buffer
	ldx #0
next_line
	mva charset,x chrset,x
	inx
	cpx #8
	bne next_line

; Display ball
	lda #0
    sta screen
	lda #1
	sta screen + 1

    jmp *

; Display list data
dlist
    .byte blank8, blank8, blank8
    //.byte lms + antic5, <screen, >screen
    .byte lms + 2, <screen, >screen
    .byte antic5, antic5, antic5, antic5, antic5, antic5, antic5, antic5, antic5, antic5, antic5, antic5
    .byte jvb, <dlist, >dlist

; Data
charset
	.byte %00000000
	.byte %00011000
	.byte %00111100
	.byte %01111110
	.byte %01111110
	.byte %00111100
	.byte %00011000
	.byte %00000000

; Change to:
; charset
; 	.byte %00000000
; 	.byte %00000011
; 	.byte %00001101
; 	.byte %00110110
; 	.byte %00110110
; 	.byte %00001101
; 	.byte %00000011
; 	.byte %00000000

; 	.byte %00000000
; 	.byte %11000000
; 	.byte %01110000
; 	.byte %10011100
; 	.byte %10011100
; 	.byte %01110000
; 	.byte %11000000
; 	.byte %00000000