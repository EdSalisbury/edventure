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

.macro advance_ptr data ptr width count offset
    mwa :data :ptr
    lda :count  ; Check to make sure it's not 0
    beq done    ; If it is, we're done

    ldy #0
loop
    adbw :ptr :width
    iny
    cpy :count
    bne loop

done
    adbw :ptr :offset
    .endm