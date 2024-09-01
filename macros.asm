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

.macro copy_bytes src dest num_bytes
    mwa #:src tmp_addr1
    mwa #:dest tmp_addr2

    ldy #0
loop
    lda (tmp_addr1),y
    sta (tmp_addr2),y
    iny
    cpy #:num_bytes
    bne loop

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

.macro copy_monster_colors src dest start
    mwa #:src tmp_addr1
    mwa #:dest tmp_addr2
    
    ; Multiply starting monster by 3 to start on the correct index
    lda :start
    asl
    add :start
    tay

    lda (tmp_addr1),y
    sta :dest + 11
    iny
    lda (tmp_addr1),y
    sta :dest + 12
    iny
    lda (tmp_addr1),y
    sta :dest + 13

.endm

.macro copy_monsters src dest start
    ; Characters are 8 bytes wide
    ; Tiles are 2 bytes wide
    ; In the dungeon/outdoor charset, there's an open section starting at character 88

    mwa #:src tmp_addr1         ; Copy monsters_X address to tmp_addr1 
    mwa #:dest tmp_addr2        ; Copy cur_charset_X address to tmp_addr2

    adw tmp_addr2 #(88 * 8)     ; Move over to location in charset where monsters start
    
    
    lda :start
    cmp #16
    bne shift
    adw tmp_addr1 #256
    jmp done
shift
    asl
    asl
    asl
    asl
    sta tmp
    adbw tmp_addr1 tmp
done


    ldy #0
loop
    lda (tmp_addr1),y           ; Load monster character
    sta (tmp_addr2),y           ; Store monster character into charset
    iny
    cpy #192
    bne loop                    ; Y > 0, so keep looping

.endm
