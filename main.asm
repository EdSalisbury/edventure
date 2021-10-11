; EdVenture - An Adventure in Atari 8-Bit Assembly
; github.com/edsalisbury/edventure
; Mission: EdPossible
; youtube.com/MissionEdPossible
; Assemble in MADS: mads -l -t main.asm
; Video 1: Initial Setup

	org $2000

SAVMSC = $0058 ; Screen memory address
SDLSTL = $0230 ; Display list starting address

screen = $4000 ; Screen buffer
blank8 = $70   ; 8 blank lines
lms = $40	   ; Load Memory Scan
jvb = $41	   ; Jump while vertical blank

antic2 = 2     ; Antic mode 2
antic3 = 3	   ; Antic mode 3
antic4 = 4	   ; Antic mode 4
antic5 = 5	   ; Antic mode 5
antic6 = 6	   ; Antic mode 6
antic7 = 7	   ; Antic mode 7

; Load display list
	lda #<dlist
	sta SDLSTL
	lda #>dlist
	sta SDLSTL+1

; Main loop
	ldy #0
loop
	lda hello,y
	sta screen,y
	iny
	cpy #12
	bne loop

	jmp *

; Display List
dlist
	.byte blank8, blank8, blank8
	.byte antic5 + lms, <screen, >screen
	.byte antic5, antic5, antic5, antic5, antic5, antic5
	.byte antic5, antic5, antic5, antic5, antic5
	.byte jvb, <dlist, >dlist

; Data
hello
	.byte "HELLO ATARI!"
