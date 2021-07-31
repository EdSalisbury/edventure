; EdVenture
; An exploration into Atari 8-Bit Programming
; Ed Salisbury
; 2021-07-30

    org $5000

IOCB2=$20   ; I/O Control Block
ICCOM=$342  ; Action command
ICBAL=$344  ; Buffer address (low byte)
ICBAH=$345  ; Buffer address (high byte)
ICAX1=$34a  ; Auxilliary information
ICAX2=$34b  ; Auxilliary information

CIOV=$e456  ; CIO Vector
 
eol=$9b
openCmd=$03
output=$08
buffAddr dta "E:", eol

openScreen
    ; Set the command to open
    ldx #IOCB2
    lda #openCmd
    sta ICCOM, x     ; Put $03 into $362

    ; Set buffer address (ICBA) to the address of our screen
    lda buffAddr & 255
    sta ICBAL, x
    lda buffAddr / 256
    sta ICBAH, x

    ; Set direction to output
    lda #output
    sta ICAX1, x
    lda #0
    sta ICAX2, x

    ; Jump to CIO vector to open the channel
    jsr CIOV
   
    
