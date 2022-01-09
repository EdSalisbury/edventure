; Written in 2019 by Rob McMullen, https://playermissile.com/dli_tutorial/
; Copyright and related rights waived via CC0: https://creativecommons.org/publicdomain/zero/1.0/

        org $3000
	icl "hardware.s"

init
        ; load display list & fill with test data
        lda #<dlist
        sta sdlstl
        lda #>dlist
        sta sdlstl+1

forever
        jmp forever

dlist
        dta $70,$70,$70  ; 24 blank lines
        dta $46,$00,$40  ; Mode 6 + LMS, setting screen memory to $4000
        dta 6            ; Mode 6
        dta $70          ; 8 blank lines
        dta 7,7,7,7,7    ; 5 lines of Mode 7
        dta $70          ; 8 blank lines
        dta 2            ; single line of Mode 2
        dta $70,$70,$70  ; 24 blank lines
        dta 2,4          ; Mode 2 followed by mode 4
        dta $70          ; 8 blank lines
        dta 2,5          ; Mode 2 followed by mode 5
        dta $41,<dlist,>dlist ; JVB, restart same display list on next frame

        org $4000

        ;       01234567890123456789
        .byte "   player"
        .byte $4f ; slash using lower-case color
        .byte           "missile   "
        .byte "  podcast presents  "

        .byte +$c0, "   A CRASH COURSE   "
        .byte +$c0, "         ON         "
        .byte +$c0, "      ADVANCED      "
        .byte +$c0, "    DISPLAY LIST    "
        .byte +$c0, "     INTERRUPTS     "

        ;    0123456789012345678901234567890123456789
        dta d" Available at http://playermissile.com  "

        dta d" Here's some ANTIC mode 4:              "
        dta d"0123456789012345678901234567890123456789"

        dta d" And here's some ANTIC mode 5:          "
        dta d"0123456789012345678901234567890123456789"

; tell DOS where to run the program when loaded
	run init