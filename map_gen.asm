.proc new_map
    fill_map()
    choose_room_num()
    choose_room_pos()
    ;mva #0 room_num
    ;mva #0 room_pos
    copy_room()
    place_up_tile()
    place_room()
    rts
    .endp

.proc fill_map
    mwa #map map_ptr        ; Reset map pointer
    lda #MAP_WALL           ; Load in wall tile
    
    ldy #0                  ; Init Y
    ldx #0                  ; Init X
loop
    sta (map_ptr),y         ; Store tile
    iny                     ; Move one tile to the right
    cpy #map_width          ; See if we're at the end of the line
    bne loop                ; We're not, keep looping

    ldy #0                  ; Move to start of line
    adbw map_ptr #map_width ; Move to the next line
    lda #MAP_WALL           ; Re-load wall tile because it gets overwritten
    inx                     ; Advance the vertical line index
    cpx #map_height         ; Check to see if all of the lines have been copied
    bne loop                ; Not yet, keep looping

    rts
    .endp

.proc choose_room_num
    random8()               ; Get random number between 0-255
    lda rand                ; Load in the random number
    cmp #16                 ; Check to see if value is below 16
    bcc done                ; Value is 0-15, we're done
    lsr                     ; Otherwise, shift right 4 times
    lsr
    lsr
    lsr
done
    sta room_num
    rts
    .endp

.proc choose_room_pos
    random8()               ; Get random number between 0-255
    lda rand                ; Load in random number
    cmp #64                 ; Check to see if value is below 64
    bcc done                ; Value is 0-63, we're done
    lsr                     ; Otherwise, shift right 2 times
    lsr
done
    sta room_pos
    rts
    .endp

.proc copy_room
    ; Move room pointer to correct location
    advance_ptr #rooms room_ptr #(room_width * room_height) room_num #0

    mwa #tmp_room tmp_addr1

    ldy #0
loop
    lda (room_ptr),y
    sta (tmp_addr1),y
    iny
    cpy #(room_width * room_height)
    bne loop

    rts
    .endp

.proc place_up_tile
loop
    mwa #tmp_room tmp_addr1
    random8()
    cmp #(room_width * room_height)
    bcs loop
    adbw tmp_addr1 rand

    ldy #0
    lda (tmp_addr1),y
    cmp #MAP_FLOOR
    bne loop

    lda #MAP_UP
    sta (tmp_addr1),y

    rts
    .endp

.proc place_room
    ; Load map coordinates for room position
    lda room_pos            ; Load in room position
    asl                     ; Multiply by 2 becase position is yx coords
    tax                     ; Init X with room position
    
    lda room_positions,x    ; Load Y coordinate
    sta room_y              ; Save in room_y
    inx
    lda room_positions,x    ; Load X coordinate
    sta room_x              ; Save in room_x

    mva room_x tmp_x
    mva room_y tmp_y

    ; Move map pointer to correct location
    advance_ptr #map map_ptr #map_width room_y room_x
    mwa #tmp_room tmp_addr1

    ldx #0
    ldy #0
loop
    lda (tmp_addr1),y        ; Load tile
    sta (map_ptr),y
    
    ; If it's an up tile, set the player_x and player_y positions
    cmp #MAP_UP
    bne next
    mva tmp_x player_x
    mva tmp_y player_y
next     ; Save tile
    inc tmp_x
    iny
    cpy #room_width
    bne loop

    ldy #0
    inc tmp_y
    mva room_x tmp_x
    adbw map_ptr #map_width
    adbw tmp_addr1 #room_width
    inx
    cpx #room_height
    bne loop

    rts
    .endp
    
