; EdVenture
; An exploration into Atari 8-Bit Programming
; Ed Salisbury
; 2021-07-30

IOCB2=$20   ; I/O Control Block
ICCOM=$342  ; Action command
ICBAL=$344  ; Buffer address (low byte)
ICBAH=$345  ; Buffer address (high byte)

eol=$9b
openCmd=$03
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

    





