	org $2000
        icl "hardware.s"
        

chr = $2400
num_chars = 128
screen = $4000

init
        mwa #dlist SDLSTL

; Use custom character set
        mva #>chr CHBAS

        ldx #0
next_line
        mva charset,x chr,x
        mva charset+$100,x chr+$100,x
        mva charset+$200,x chr+$200,x
        mva charset+$300,x chr+$300,x
        inx
        bne next_line

; Main Loop
        jsr vblank

; Copy map to screen
        ldx #0
        ldy #0
map_loop
        mva map,y screen,x
        mva map+$80,y screen+$100,x
        iny
        inx
        inx
        bne map_loop

        ldx #0
fill_loop
        lda screen,x
        clc
        adc #1
        inx
        sta screen,x
        dex
        lda screen+$100,x
        clc
        adc #1
        inx
        sta screen+$100,x
        inx
        bne fill_loop

        jmp *

vblank
        pha
        mva #$06 COLOR0 ; Medium Gray ; 708 ; 01
        mva #$0a COLOR1 ; Light gray ; 709 ; 10
        mva #$c2 COLOR2 ; Green ; 710 ; 11
        mva #$22 COLOR3 ; Brown ; 711 ; 11 (Inverse)
        mva #$00 COLOR4 ; Background (black) ; 712 ; 00

        lda #1
        sta 540
vblank_loop
        lda 540
        bne vblank_loop
        pla
        rts

dlist
        dta $70,$70,$70  ; 24 blank lines
        dta $45,$00,$40  ; Mode 5 + LMS, setting screen memory to $4000
        dta 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5
        dta $41,<dlist,>dlist ; JVB, restart same display list on next frame
   

        .local map
        .byte 2, 4, 2, 6, 2, 6, 4, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        .byte 6, 14, 10, 10, 2, 10, 12, 10, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        .byte 2, 12, 10, 10, 2, 12, 12, 10, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        .byte 2, 2, 146, 2, 4, 2, 22, 2, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        .byte 2, 10, 10, 10, 2, 12, 12, 12, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        .byte 2, 10, 10, 10, 2, 12, 12, 12, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        .byte 2, 2, 2, 146, 2, 2, 146, 2, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        .byte 6, 14, 10, 10, 2, 10, 12, 10, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        .byte 2, 12, 10, 10, 2, 12, 12, 10, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        .byte 4, 10, 10, 10, 2, 12, 12, 12, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        .byte 2, 2, 4, 2, 6, 2, 4, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        .endl

        icl "data.s"

        run init