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

.macro copy_data src dest num_pages
    mwa #:src tmp_addr1
    mwa #:dest tmp_addr2

    ldy #0
    ldx #0
loop
    lda (tmp_addr1),y
    sta (tmp_addr2),y
    iny
    bne loop
    inc tmp_addr1 + 1
    inc tmp_addr2 + 1
    inx
    cpx #:num_pages
    bne loop
    .endm

.macro copy_monsters start end
    mwa #monsters_a tmp_addr1
    mwa #cur_charset_a tmp_addr2

    adw tmp_addr2 #(86 * 8)

    lda #:start
    asl
    tay

    lda #:end
    asl
    asl
    asl
    asl
    sta tmp

loop
    lda (tmp_addr1),y
    sta (tmp_addr2),y
    iny

    cpy tmp
    bne loop

    .endm
