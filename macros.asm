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
    ; Tiles are 2 chacters wide
    ; In the dungeon/outdoor charset, there's an open section starting at character 88
    mwa #:src tmp_addr1
    mwa #:dest tmp_addr2

    adw tmp_addr2 #(88 * 8)

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
    lda (tmp_addr1),y
    sta (tmp_addr2),y
    iny

    cpy #192
    bne loop

.endm


.macro ldi addr
    ldy #0
    lda (:addr),y
.endm

.macro sti addr
    ldy #0
    sta (:addr),y
.endm

.macro clr addr
    mva #0 :addr
.endm

.macro debug
	;##TRACE "\nDEBUG:\n"
    ;##TRACE "player_x (0x%02X): 0x%02X (%03d)            player_y (0x%02X): 0x%02X (%03d)            player_ptr (0x%04X): 0x%04X (%05d)    map_ptr (0x%04X): 0x%04X (%05d)" player_x db(player_x) db(player_x) player_y db(player_y) db(player_y) player_ptr dw(player_ptr) dw(player_ptr) map_ptr dw(map_ptr) dw(map_ptr)
	;##TRACE "screen_ptr (0x%04X): 0x%04X (%05d)    status_ptr (0x%04X): 0x%04X (%05d)    input_timer (0x%02X): 0x%02X (%03d)         stick_btn (0x%02X): 0x%02X (%03d)" screen_ptr dw(screen_ptr) dw(screen_ptr) status_ptr dw(status_ptr) dw(status_ptr) input_timer db(input_timer) db(input_timer) stick_btn db(stick_btn) db(stick_btn)
	;##TRACE "stick_action (0x%02X): 0x%02X (%03d)        tmp (0x%02X): 0x%02X (%03d)                 tmp1 (0x%02X): 0x%02X (%03d)                tmp2 (0x%02X): 0x%02X (%03d)" stick_action db(stick_action) db(stick_action) tmp db(tmp) db(tmp) tmp1 db(tmp1) db(tmp1) tmp2 db(tmp2) db(tmp2)
	;##TRACE "tmp_x (0x%02X): 0x%02X (%03d)               tmp_y (0x%02X): 0x%02X (%03d)               rand (0x%02X): 0x%02X (%03d)                rand16 (0x%04X): 0x%04X (%05d)" tmp_x db(tmp_x) db(tmp_x) tmp_y db(tmp_y) db(tmp_y) rand db(rand) db(rand) rand16 dw(rand16) dw(rand16)
	;##TRACE "anim_timer (0x%02X): 0x%02X (%03d)          charset_a (0x%02X): 0x%02X (%03d)           no_clip (0x%02X): 0x%02X (%03d)             char_colors_ptr (0x%04X): 0x%04X (%05d)" anim_timer db(anim_timer) db(anim_timer) charset_a db(charset_a) db(charset_a) no_clip db(no_clip) db(no_clip) char_colors_ptr dw(char_colors_ptr) dw(char_colors_ptr)
	;##TRACE "room_ptr (0x%04X): 0x%04X (%05d)      room_col (0x%02X): 0x%02X (%03d)            room_row (0x%02X): 0x%02X (%03d)            doors (0x%02X): 0x%02X (%03d)" room_ptr dw(room_ptr) dw(room_ptr) room_col db(room_col) db(room_col) room_row db(room_row) db(room_row) doors db(doors) db(doors)
	;jmp $FFFF
.endm