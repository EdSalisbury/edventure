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
    adw :ptr :width
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
    lda (tmp_addr1), y
    sta (tmp_addr2), y
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

    adw tmp_addr2 #(86 * 8) ; Monsters offset in the character set
    
    lda #:start
    asl             ; Multiply by two because tiles are two chars wide
    tay

    lda #:end
    asl
    asl
    asl
    asl
    sta tmp

loop
    lda (tmp_addr1), y
    sta (tmp_addr2), y
    iny

    cpy tmp
    bne loop
    
    .endm

.proc place_monsters (.byte x,a) .reg
    //;##TRACE "Placing monsters"
    sta tmp2
    //;##TRACE "X: %d" @x
pick

    random16
    //;##TRACE "Random monster chosen: %d" @a
    and #15
    //;##TRACE "AND #15: %d" @a
    cmp tmp2
    bcs pick
    
    add #43
    sta tmp

place
    //;##TRACE "Placing monster %d" db(tmp)
    ; pick random x
    random16
    and #$7f
    ;cmp #map_width
    ;bcs place
    sta tmp_x
    ; pick random y
    random16
    and #$7f
    ;cmp #map_height
    ;bcs place
    sta tmp_y
    //;##TRACE "tmp_x = %d, tmp_y = %d" db(tmp_x) db(tmp_y)

    advance_ptr #map map_ptr #map_width tmp_y tmp_x
    ldy #0
    lda (map_ptr),y
    ;##TRACE "map_ptr[%d][%d] (%04x): %d" db(tmp_x) db(tmp_y) dw(map_ptr) @a
    cmp #MAP_FLOOR
    bne place
    lda tmp
    //;##TRACE "Placing monster %d at %d,%d" db(tmp) db(tmp_x) db(tmp_y)
    sta (map_ptr),y
    dex
   // ;##TRACE "X = %d" @x
    bne pick
    
    rts
    .endp