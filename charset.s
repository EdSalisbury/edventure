        org $0600
        jmp movdat

chbas=$02f4                             ; Character Base Register
newadr=$5000
tablen=1024

mvsrce=$b0                              ; Page zero pointer
mvdest=mvsrce+2
chradr=mvdest+2

lenptr=$6000
ramchr=lenptr+2

shape   dta %00010001
        dta %00010001
        dta %00010001
        dta %11111111
        dta %01000100
        dta %01000100
        dta %01000100
        dta %11111111

start=movdat

movdat
        lda #0
        sta mvsrce
        lda chbas
        sta mvsrce+1

        lda #newadr&255
        sta mvdest
        lda #newadr/256
        sta mvdest+1

        lda #tablen&255
        sta lenptr
        lda #tablen/256
        sta lenptr+1

        ldy $0
        ldx lenptr+1
        beq mvpart

mvpage
        lda (mvsrce),y
        sta (mvdest),y
        iny
        bne mvpage
        inc mvsrce+1
        inc mvdest+1
        dex
        bne mvpage

mvpart
        ldx lenptr
        beq mvexit

mvlast
        lda (mvsrce),y
        sta (mvdest),y
        inx
        dex
        bne mvlast

mvexit
        lda #33
        sta ramchr
        lda #0
        sta ramchr+1
        lda ramchr
        clc
        asl.a
        rol ramchr+1
        asl.a
        rol ramchr+1
        asl.a
        rol ramchr+1
        sta ramchr

fndadr
        clc
        lda ramchr
        adc #newadr&255
        sta chradr
        lda ramchr+1
        adc #newadr/256
        sta chradr+1

newchr
        ldy #0
doshape
        lda shape,y
        sta (chradr),y
        iny
        cpy #8
        bcc doshape
        lda #newadr/256
        sta chbas

fini
        rts