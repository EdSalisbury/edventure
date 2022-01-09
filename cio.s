; EdVenture
; An exploration into Atari 8-Bit Programming
; Ed Salisbury
; 2021-07-30

; Things to check:
;   output and putrec, correct?
;   Is the # implied with ldx, lda, etc. if using a variable name?

    org $5000

IOCB2=$20   ; I/O Control Block
ICCOM=$342  ; Action command
ICBAL=$344  ; Buffer address (low byte)
ICBAH=$345  ; Buffer address (high byte)
ICBLL=$348  ; Buffer length (low byte)
ICBLH=$349  ; Buffer length (high byte)
ICAX1=$34a  ; Auxilliary information
ICAX2=$34b  ; Auxilliary information

CIOV=$e456  ; CIO Vector

PUTREC=$09

buffLength=255
eol=$9b
openCmd=$03
output=$08
buffAddr dta "E:", eol
textBuffer=*

openScreen
    ; Set the command to open
    ldx #IOCB2
    lda #openCmd
    sta ICCOM, x     ; Put $03 into $362

    ; Set buffer address (ICBA) to the address of our screen
    lda < buffAddr
    sta ICBAL, x
    lda > buffAddr
    sta ICBAH, x

    ; Set direction to output
    lda #output
    sta ICAX1, x
    lda #0
    sta ICAX2, x

    ; Jump to CIO vector to open the channel
    jsr CIOV
   
    ; Set the command to print
    lda #PUTREC
    sta ICCOM, x

    ; Set buffer address to the text buffer
    lda < textBuffer
    sta ICBAL, x
    lda > textBuffer
    sta ICBAH, x

    rts

print
    ldx #IOCB2
    lda < buffLength
    sta ICBLL, x
    lda > buffLength
    sta ICBLH, x

    jsr CIOV

    rts
