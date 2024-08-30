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

.macro copy_monsters src dest start count
    ; Characters are 8 bytes wide
    ; Tiles are 2 bytes wide
    ; In the dungeon/outdoor charset, there's an open section starting at character 88

    mwa #:src tmp_addr1         ; Copy monsters_X address to tmp_addr1 
    mwa #:dest tmp_addr2        ; Copy cur_charset_X address to tmp_addr2

    adw tmp_addr2 #(88 * 8)         ; Move over to location in charset where monsters start
    adw tmp_addr1 #(:start * 16)    ; Move over to the starting monster location
    
    lda #(:count * 16)          ; Start at the correct byte (8 * 2) for the ending monster       
    tay                         ; Store in Y for looping
    
loop
    dey                         ; Pre-decrement Y
    lda (tmp_addr1),y           ; Load monster character
    sta (tmp_addr2),y           ; Store monster character into charset
    cpy #0                      ; Check to see if Y=0
    bne loop                    ; Y > 0, so keep looping

    .endm
