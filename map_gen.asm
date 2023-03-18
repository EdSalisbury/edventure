.proc new_map
    fill_map()

    ; Get room number between 0-15
    random8()
    and #15
    sta room_type

    ; Get room position between 0-63
    random8()
    and #63
    sta room_pos

    copy_room()
    place_up_tile()
    place_room()
    get_doors()
    place_doors()

    rts
    .endp

.proc fill_map
    mwa #map map_ptr        ; Reset map pointer
    lda #MAP_WALL           ; Load in wall tile

    ldy #0
    ldx #0
loop
    sta (map_ptr),y         ; Store tile
    iny                     ; Move one tile to the right
    cpy #map_width          ; Are we at the end of the line?
    bne loop                ; Nope, keep looping

    ldy #0                  ; Reset to the left edge
    adbw map_ptr #map_width ; Move to the next line
    lda #MAP_WALL           ; Re-load wall tile
    inx                     ; Advance the vertical line index
    cpx #map_height         ; Check to see if all of the lines have been copied
    bne loop                ; Nope, keep looping

    rts
    .endp

.proc copy_room
    advance_ptr #room_types room_ptr #(room_width * room_height) room_type #0

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
    lda room_pos            ; Load in room position
    asl                     ; Multiply by 2 because positions are 2 bytes wide
    tax                     ; Init X register

    lda room_positions,x    ; Load Y coordinate
    sta room_y              ; Save in room_y
    inx
    lda room_positions,x    ; Load X coordinate
    sta room_x              ; Save in room_x

    mva room_x tmp_x
    mva room_y tmp_y

    advance_ptr #map map_ptr #map_width room_y room_x
    mwa #tmp_room tmp_addr1

    ldx #0
    ldy #0
loop
    lda (tmp_addr1),y
    sta (map_ptr),y

    cmp #MAP_UP
    bne next
    mva tmp_x player_x
    mva tmp_y player_y
next
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

.proc get_doors
    ; Get possible doors for the room position
    ldy room_pos
    mwa #room_pos_doors tmp_addr1
    mwa #room_doors tmp_addr2
    lda (tmp_addr1),y
    sta (tmp_addr2),y

    ; Get doors for the room type
    ldy room_type                   ; Set up Y for getting room type
    mwa #room_type_doors tmp_addr1  ; Set up pointer for indirect addressing
    lda (tmp_addr1),y               ; Load room type into accumulator
    sta tmp                         ; Store room type into temp var

    ldy room_pos                    ; Set up Y for getting room pos
    lda (tmp_addr2),y               ; Load in room doors for this position
    and tmp                         ; AND with room type
    sta (tmp_addr2),y               ; Store back into room_doors

    rts
    .endp

.proc place_doors
    ldy room_pos                    ; Load room position into Y
    mwa #room_doors tmp_addr1       ; Set up pointer
    lda (tmp_addr1),y               ; Get room doors for position
    sta tmp                         ; Store rooms into tmp

check_north
    lda tmp
    and #DOOR_NORTH
    beq check_south
    place_north_door()

check_south
    lda tmp
    and #DOOR_SOUTH
    beq check_west
    place_south_door()

check_west
    lda tmp
    and #DOOR_WEST
    beq check_east
    place_west_door()

check_east
    lda tmp
    and #DOOR_EAST
    beq done
    place_east_door()
    
done
    rts
    .endp

.proc place_north_door
    advance_ptr #map map_ptr #map_width room_y room_x
    sbw map_ptr #map_width
    adw map_ptr #(room_width / 2)
    lda #MAP_DOOR
    ldy #0
    sta (map_ptr),y
    rts
    .endp

.proc place_south_door
    advance_ptr #map map_ptr #map_width room_y room_x
    ldy #0
loop
    adw map_ptr #map_width
    iny
    cpy #room_height
    bne loop

    adw map_ptr #(room_width / 2)
    lda #MAP_DOOR
    ldy #0
    sta (map_ptr),y
    rts
    .endp

.proc place_west_door
    advance_ptr #map map_ptr #map_width room_y room_x
    ldy #0
loop
    adw map_ptr #map_width
    iny
    cpy #(room_height / 2)
    bne loop

    lda #MAP_DOOR
    ldy #0
    sta (map_ptr),y
    rts
    .endp

.proc place_east_door
    advance_ptr #map map_ptr #map_width room_y room_x
    adw map_ptr #room_width
    ldy #0
loop
    adw map_ptr #map_width
    iny
    cpy #(room_height / 2)
    bne loop

    lda #MAP_DOOR
    ldy #0
    sta (map_ptr),y
    rts
    .endp
