; Load in the rooms file
; 15x15 for the locations

.proc new_map
    fill_map()
    choose_room_num()
    choose_room_pos()
    ;mva #0 room_pos
    ;mva #0 room_num
    
    advance_ptr #rooms room_ptr #(room_width + 1) room_num ; Advance rooms pointer to the correct room
    ;place_up_tile()
    place_room()
    ;remove_edge_doors()
    ;place_doors()
    rts
    .endp

; Fill the whole map with walls
.proc fill_map
    mwa #map map_ptr        ; Init map pointer
    lda #MAP_WALL           ; Load in basic wall tile
    ldy #0                  ; Init horizontal index
    ldx #0                  ; Init vertical index
    
loop
    sta (map_ptr),y         ; Store tile at current map ptr
    iny                     ; Move one tile to the right
    cpy #map_width          ; Check to see if the line is complete
    bne loop                ; If not, keep looping

    ldy #0                  ; If the line is complete, reset horiz index
    adw map_ptr #map_width  ; Advance the map pointer one full line
    lda #MAP_WALL           ; Re-load the wall tile (adw overwrites A register)
    inx                     ; Advance the vertical line index
    cpx #map_height         ; Check to see if the lines have all been copied
    bne loop                ; If not, keep looping

    rts
    .endp

; Choose room to place
.proc choose_room_num
    random()        ; Choose a random 8-bit number
    lda rand        ; Load it in to the accumulator
    cmp #$10        ; See if the value is 16 or above
    bcc done        ; Value is 0-15, so we're done
    lsr             ; Otherwise, shift right until it is 0-15
    lsr
    lsr
    lsr

done
    sta room_num
    rts
    .endp

; Choose where to place the room
.proc choose_room_pos
    random()        ; Choose a random 8-bit number
    lda rand        ; Load it in to the accumulator
    cmp #$40        ; See if the value is below 64
    bcc done        ; It's less than 64, so we can place it
    lsr             ; If not, shift right until it is less
    lsr             ;    than 64
done
    sta room_pos    ; Store it into the room_pos
    rts
    .endp

.proc place_up_tile
    mwa room_ptr tmp_ptr            ; Make a copy of the room pointer

loop
    mwa tmp_ptr room_ptr            ; Copy the temp pointer back to room pointer
    random()                        ; Get random number
    cmp #(room_width * room_height) ; Verifies that the number is within the boundaries
    bcc loop                        ; It's too big, try again
    adbw room_ptr rand              ; Add to the room pointer

    ; Check to see if the tile is a floor tile
    ldy #0                          ; Reset Y
    lda (room_ptr),y                ; Load in the tile
    cmp #MAP_FLOOR                  ; Compare with the map tile
    bne loop                        ; If it's not a floor tile, keep trying until it is

    lda #MAP_UP                     ; Load in the up tile
    sta (room_ptr),y                ; Store it in the room tile

    mwa tmp_ptr room_ptr            ; Reset the room pointer
    rts
    .endp

; Copy the room data to the map
.proc place_room
    lda room_pos                                ; Load in the room position
    asl                                         ; Multiply by 2 because there are x and y for each entry
    tax                                         ; Store the room position into X

    ; Get room positions for x and y
    lda room_positions,x
    sta room_y
    inx
    lda room_positions,x
    sta room_x
    
    advance_ptr #map map_ptr #map_width room_y    ; Move the map_ptr to the correct position (y)
    adw map_ptr room_x                          ; Move the map_ptr to the correct x position
    mwa map_ptr tmp_ptr                         ; Make a copy of the map pointer so that it doesn't need to be calculated again

    ldx #0
    ldy #0
loop
    lda (room_ptr),y            ; Load the tile at room pointer
    sta (map_ptr),y             ; Store tile at current map ptr

    ; If it's an up tile, set the player_x and player_y positions
    ; cmp #MAP_UP
    ; bne next
    ; mva room_x player_x
    ; mva room_y player_y
next
    iny                         ; Move one tile to the right
    cpy #room_width             ; Check to see if the line is complete
    bne loop                    ; If not, keep looping

    ldy #0                      ; If the line is complete, reset horiz index
    adw map_ptr #map_width      ; Advance the map pointer one full line
    adw room_ptr #room_width    ; Advance the room pointer one full line
    inx                         ; Advance the vertical line index
    cpx #room_height            ; Check to see if the lines have all been copied
    bne loop                    ; If not, keep looping

    mwa tmp_ptr map_ptr         ; Reset the map pointer to the original position
    rts
    .endp

; Remove doors that are on the edge of the map
; Assumes room_ptr is in the correct location (the byte after the room data)
.proc remove_edge_doors
    ldy #0                  ; Reset Y
    lda (room_ptr),y        ; Load in doors for this room
    ldx #0                  ; Reset X
    and room_doors,x        ; AND with possible doors for this room
    sta doors

    rts
    .endp

; Place doors
.proc place_doors

check_north
    lda doors
    and #DOOR_NORTH
    bne place_north_door
    
check_south
    lda doors
    and #DOOR_SOUTH
    bne place_south_door
    
check_west
    lda doors
    and #DOOR_WEST
    bne place_west_door
    
check_east
    lda doors
    and #DOOR_EAST
    bne place_east_door
 
    jmp done

place_north_door
    mwa room_pos_ptr map_ptr
    sbw map_ptr #map_width
    adw map_ptr #(room_width / 2)
    lda #MAP_DOOR
    ldy #0
    sta (map_ptr),y
    jmp check_south

place_south_door
    mwa room_pos_ptr map_ptr
    ldy #0
loop_s
    adw map_ptr #map_width
    iny
    cpy #room_height
    bne loop_s

    adw map_ptr #(room_width / 2)
    lda #MAP_DOOR
    ldy #0
    sta (map_ptr),y
    jmp check_west

place_west_door
    mwa room_pos_ptr map_ptr
    ldy #0
loop_w
    adw map_ptr #map_width
    iny
    cpy #(room_height / 2)
    bne loop_w

    lda #MAP_DOOR
    ldy #0
    sta (map_ptr),y
    jmp check_east

place_east_door
    mwa room_pos_ptr map_ptr
    ldy #0
loop_e
    adw map_ptr #map_width
    iny
    cpy #(room_height / 2)
    bne loop_e

    adw map_ptr #room_width
                 
    lda #MAP_DOOR
    ldy #0
    sta (map_ptr),y

done
    rts
    .endp
