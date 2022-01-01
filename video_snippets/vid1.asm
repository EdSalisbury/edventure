; EdVenture - An Adventure in Atari 8-Bit Assembly
; github.com/edsalisbury/edventure
; Mission: EdPossible
; youtube.com/MissionEdPossible
; Assemble in MADS: mads -l -t edventure.asm
; Video 1: Initial Setup

    org $2000

SAVMSC = $0058 ; Screen memory address

    ldy #0
loop
    lda hello,y
    sta (SAVMSC),y
    iny
    bne loop

    jmp *

; Data
hello
    .byte "HELLO ATARI!"
