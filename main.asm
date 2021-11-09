; EdVenture - An Adventure in Atari 8-Bit Assembly
; github.com/edsalisbury/edventure
; Mission: EdPossible
; youtube.com/MissionEdPossible
; Assemble in MADS: mads -l -t main.asm
; Video 3: Fun with character sets!

	org $2000

SDLSTL = $0230  ; Display list starting address
CHBAS = $02f4   ; CHaracter BAse Register

charset = $3c00 ; Character Set
screen = $4000  ; Screen buffer
blank8 = $70    ; 8 blank lines
lms = $40	    ; Load Memory Scan
jvb = $41	    ; Jump while vertical blank

antic2 = 2      ; Antic mode 2
antic5 = 5	    ; Antic mode 5

; Load display list
	mwa #dlist SDLSTL

; Set up character set
	mva #>charset CHBAS

	ldx #0
loop
	mva chars,x charset,x
	inx
	cpx #16
	bne loop

	ldy #0
loop2
	mva scene,y screen,y
	iny
	cpy #2
	bne loop2

	jmp *

; Display List
dlist
	.byte blank8, blank8, blank8
	.byte antic5 + lms, <screen, >screen
	.byte antic5, antic5, antic5, antic5, antic5, antic5
	.byte antic5, antic5, antic5, antic5, antic5
	.byte jvb, <dlist, >dlist

; %00 = 0
; %01 = 1
; %10 = 2
; %11 = 3

scene
	.byte " !"

chars
	.byte %00000000
	.byte %00000001
	.byte %00000110
	.byte %00011011
	.byte %00011011
	.byte %00000110
	.byte %00000001
	.byte %00000000

	.byte %00000000
	.byte %01000000
	.byte %10010000
	.byte %11100100
	.byte %11100100
	.byte %10010000
	.byte %01000000
	.byte %00000000
	