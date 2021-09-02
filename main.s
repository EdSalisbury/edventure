	org $2000
        icl "hardware.s"

chr = $2400
rom_chr = $e000

last_line = $cb
cur_char = $cc
last_char = $cd

chr_lo = $ce
chr_hi = $cf

init
        lda #<dlist
        sta sdlstl
        lda #>dlist
        sta sdlstl + 1

; Use custom character set
        mva #>chr CHBAS

        ldy #0
        ldx #0
next_line
        lda charset, y
        sta chr, x
        inx
        iny
        cpy #24
        bne next_line

; ; Temporary main
; 	ldy #0
; main_loop
; 	tya
; 	sta (SAVMSC),y
; 	iny
; 	bne main_loop

; 	jmp *


        ldx #0
loop
        lda #1
        sta $4000, X
        inx
        lda #2
        sta $4000, X
        inx
        jsr vblank

        jmp loop

vblank
        pha
        ; Set colors
        lda #$70
        sta $2c4
        lda #$76
        sta $2c5
        lda #$7E
        sta $2c6

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
        dta 5, 5, 5, 5, 5, 5
        dta $41,<dlist,>dlist ; JVB, restart same display list on next frame

        .local charset
        .byte 0, 0, 0, 0, 0, 0, 0, 0
wall1
        .byte %11101010
        .byte %10010101
        .byte %01010101
        .byte %00000000
        .byte %10010011
        .byte %01010011
        .byte %01010010
        .byte %00000000

wall2
        .byte %01001111
        .byte %01001110
        .byte %01001001
        .byte %00000000
        .byte %11111010
        .byte %10100101
        .byte %01010101
        .byte %00000000
        .endl

        run init