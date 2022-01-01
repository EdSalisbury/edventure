; EdVenture - An Adventure in Atari 8-Bit Assembly
; github.com/edsalisbury/edventure
; Mission: EdPossible
; youtube.com/MissionEdPossible
; Assemble in MADS: mads -l -t edventure.asm
; Video 2: Display List setup

    org $2000

SAVMSC   = $0058 ; Screen memory starting address
SDLSTL   = $0230 ; Display list starting address

screen = $4000  ; Our screen buffer

blank8 = $70    ; 8 blank lines in the display list
antic5 = 5      ; ANTIC mode 5 (4 colors, 4x8 characters, 40 columns, 12 rows)
lms = $40       ; Load memory scan
jvb = $41       ; Jump while vertical blank

; Set up Display list
    lda #<dlist
    sta SDLSTL
    lda #>dlist
    sta SDLSTL+1

;   change to:
;    mwa #dlist SDLSTL

; Copy greeting to the screen buffer
    ldy #0
loop
    lda hello,y
    sta screen,y
    iny
    bne loop

    jmp *

; Display list data
dlist
    .byte blank8, blank8, blank8
    .byte lms + antic5, <screen, >screen
    .byte antic5, antic5, antic5, antic5, antic5, antic5, antic5, antic5, antic5, antic5, antic5
    .byte jvb, <dlist, >dlist

; Data
hello
    .byte "HELLO ANTIC!"
