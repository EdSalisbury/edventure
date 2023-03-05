.macro inc16 addr
    inc :addr
    bne skip_carry
    inc :addr + 1
skip_carry
    .endm

.macro dec16 addr
    lda :addr
    bne skip_borrow
    dec :addr + 1
skip_borrow
    dec :addr
    .endm

.macro adbw src val
    lda :src
    add :val
    sta :src
    bcc skip_carry
    inc :src + 1
skip_carry
    .endm

.macro advance_ptr orig ptr width count
    mwa :orig :ptr
    ldy #0
loop
    adbw :ptr :width
    iny
    cpy :count
    bne loop
    .endm