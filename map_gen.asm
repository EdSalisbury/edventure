.macro get_room_pos
    random8()
    and #63
    sta room_pos
    .endm

.macro get_room_type
    random8()
    and #15
    sta room_type
    .endm

.proc new_map
    mva #0 num_rooms
    mva #8 max_rooms

    fill_map
    get_room_pos
    get_room_type
    copy_room
    place_special_tile #MAP_UP
    inc num_rooms
    jmp place

last_room
    place_special_tile #MAP_DOWN
    place_room
    jmp done

next_room
    get_room_type
    copy_room

check_last
    inc num_rooms
    lda num_rooms
    cmp max_rooms
    beq last_room

place
    place_room
    get_doors

    walk_room
    jmp next_room

done
    place_doors

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

.proc place_special_tile (.byte x) .reg
    ;##TRACE "Placing special tile %d" (x)
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

    txa
    sta (tmp_addr1),y

    rts
    .endp

.proc place_room
    ;##TRACE "Place room #%d" db(room_pos)
    lda room_pos            ; Load in room position
    set_room_occupied room_pos
    lda room_pos
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
    ;##TRACE "moving player"
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
    mwa #avail_doors tmp_addr2
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
    sta doors

    bne done
    mva #1 dead_end
    ;#TRACE "Dead end found!"
done
    rts
    .endp

.proc place_doors
    ;##TRACE "Placing doors"
    mva #0 room_pos
    mwa #placed_doors tmp_addr1     ; Set up pointer
loop
    ldy #0
    lda (tmp_addr1),y
    beq done
    sta doors                       ; Store doors into tmp
    lda room_pos
    asl                     ; Multiply by 2 because positions are 2 bytes wide
    tax                     ; Init X register

    ;##TRACE "Room pos: %d" db(room_pos)
    ;##TRACE "X: %d" (x)
    lda room_positions,x    ; Load Y coordinate
    sta room_y              ; Save in room_y
    inx
    lda room_positions,x    ; Load X coordinate
    sta room_x              ; Save in room_x

    ;##TRACE "room_x: %d room_y: %d" db(room_x) db(room_y)

check_north
    lda doors
    and #DOOR_NORTH
    beq check_south
    place_north_door

check_south
    lda doors
    and #DOOR_SOUTH
    beq check_west
    place_south_door

check_west
    lda doors
    and #DOOR_WEST
    beq check_east
    place_west_door

check_east
    lda doors
    and #DOOR_EAST
    beq done
    place_east_door
    
done
    inw tmp_addr1
    inc room_pos
    lda room_pos
    cmp #64
    bcc loop

    rts
    .endp

.proc place_north_door
    advance_ptr #map map_ptr #map_width room_y room_x
    sbbw map_ptr #map_width
    adbw map_ptr #(room_width / 2)
    lda #MAP_DOOR
    ldy #0
    sta (map_ptr),y
    rts
    .endp

.proc place_south_door
    advance_ptr #map map_ptr #map_width room_y room_x
    ldy #0
loop
    adbw map_ptr #map_width
    iny
    cpy #room_height
    bne loop

    adbw map_ptr #(room_width / 2)
    lda #MAP_DOOR
    ldy #0
    sta (map_ptr),y
    rts
    .endp

.proc place_west_door
    advance_ptr #map map_ptr #map_width room_y room_x
    dew map_ptr
    ldy #0
loop
    adbw map_ptr #map_width
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
    adbw map_ptr #room_width
    ldy #0
loop
    adbw map_ptr #map_width
    iny
    cpy #(room_height / 2)
    bne loop

    lda #MAP_DOOR
    ldy #0
    sta (map_ptr),y
    rts
    .endp

.proc walk_room  
pick
    mwa #placed_doors placed_doors_ptr
    mwa #avail_doors avail_doors_ptr

    ldy room_pos
    lda (avail_doors_ptr),y
    sta doors

    random8()
    and #15
    and doors
    sta doors

check_north
    check_north_door
    beq check_south
    walk_north room_pos
    jmp done

check_south
    check_south_door
    beq check_west
    walk_south room_pos
    jmp done

check_west
    check_west_door
    beq check_east
    walk_west room_pos
    jmp done

check_east
    check_east_door
    beq pick
    walk_east room_pos

done
    rts
    .endp

.proc check_north_door
    lda doors
    cmp #DOOR_NORTH
    bne false

    lda room_pos
    sub #8
    sta tmp
    get_room_occupied tmp
    beq true
    ldy room_pos
    lda (avail_doors_ptr),y
    sub #DOOR_NORTH
    sta (avail_doors_ptr),y
    bne false
true
    lda #1
    rts
false
    lda #0
    rts
    .endp

.proc check_south_door
    lda doors
    cmp #DOOR_SOUTH
    bne false

    lda room_pos
    add #8
    sta tmp
    get_room_occupied tmp
    beq true
    ldy room_pos
    lda (avail_doors_ptr),y
    sub #DOOR_SOUTH
    sta (avail_doors_ptr),y
    bne false

true
    lda #1
    rts
false
    lda #0
    rts
    .endp

.proc check_west_door
    lda doors
    cmp #DOOR_WEST
    bne false

    lda room_pos
    sub #1
    sta tmp
    get_room_occupied tmp
    beq true
    ldy room_pos
    lda (avail_doors_ptr),y
    sub #DOOR_WEST
    sta (avail_doors_ptr),y
    bne false

true
    lda #1
    rts
false
    lda #0
    rts
    .endp

.proc check_east_door
    lda doors
    cmp #DOOR_EAST
    bne false

    lda room_pos
    add #1
    sta tmp
    get_room_occupied tmp
    beq true
    ldy room_pos
    lda (avail_doors_ptr),y
    sub #DOOR_EAST
    sta (avail_doors_ptr),y
    bne false

true
    lda #1
    rts
false
    lda #0
    rts
    .endp

; Walk north
; Input Registers:
; Y = room position
; Updates current avail and placed doors
; Moves room position to new room
; Updates new available doors to prevent backtracking
.proc walk_north (.byte y) .reg
    ; Add door to placed rooms in current room
    lda (placed_doors_ptr),y
    add #DOOR_NORTH
    sta (placed_doors_ptr),y

    ; Remove door from available doors in current room
    lda (avail_doors_ptr),y
    sub #DOOR_NORTH
    sta (avail_doors_ptr),y

    ; Move the room position
    lda room_pos
    sub #map_room_columns
    sta room_pos

    get_doors()

    ; Remove door from available doors in the new room
    ldy room_pos
    lda (avail_doors_ptr),y
    sub #DOOR_SOUTH
    sta (avail_doors_ptr),y
    
    rts
    .endp

; Walk south
; Input Registers:
; Y = room position
; Updates current avail and placed doors
; Moves room position to new room
; Updates new available doors to prevent backtracking
.proc walk_south (.byte y) .reg
    ; Add door to placed rooms in current room
    lda (placed_doors_ptr),y
    add #DOOR_SOUTH
    sta (placed_doors_ptr),y

    ; Remove door from available doors in current room
    lda (avail_doors_ptr),y
    sub #DOOR_SOUTH
    sta (avail_doors_ptr),y
    ; Move the room position
    lda room_pos
    add #map_room_columns
    sta room_pos
    
    get_doors()

    ; Remove door from available doors in the new room
    ldy room_pos
    lda (avail_doors_ptr),y
    sub #DOOR_NORTH
    sta (avail_doors_ptr),y
    
    rts
    .endp

; Walk west
; Input Registers:
; Y = room position
; Updates current avail and placed doors
; Moves room position to new room
; Updates new available doors to prevent backtracking
.proc walk_west (.byte y) .reg
    ; Add door to placed rooms in current room
    lda (placed_doors_ptr),y
    add #DOOR_WEST
    sta (placed_doors_ptr),y

    ; Remove door from available doors in current room
    lda (avail_doors_ptr),y
    sub #DOOR_WEST
    sta (avail_doors_ptr),y

    ; Move the room position
    dec room_pos
    
    get_doors()

    ; Remove door from available doors in the new room
    ldy room_pos
    lda (avail_doors_ptr),y
    sub #DOOR_EAST
    sta (avail_doors_ptr),y

    rts
    .endp

; Walk east
; Input Registers:
; Y = room position
; Updates current avail and placed doors
; Moves room position to new room
; Updates new available doors to prevent backtracking
.proc walk_east (.byte y) .reg
    ; Add door to placed rooms in current room
    lda (placed_doors_ptr),y
    add #DOOR_EAST
    sta (placed_doors_ptr),y

    ; Remove door from available doors in current room
    lda (avail_doors_ptr),y
    sub #DOOR_EAST
    sta (avail_doors_ptr),y

    ; Move the room position
    inc room_pos

    get_doors()

    ; Remove door from available doors in the new room
    ldy room_pos
    lda (avail_doors_ptr),y
    sub #DOOR_WEST
    sta (avail_doors_ptr),y
    
    rts
    .endp

.proc get_room_occupied (.byte a) .reg
bitmap = tmp
    sta room_row
    and #7                      ; Mask the last 3 bits as the column (mod 8)
    sta room_col                ; Store column to a temp variable
    lda room_row
    lsr                         ; Divide by 8 to get the row
    lsr
    lsr
    sta room_row                ; Store the room row
    tay                         ; Copy the room row to Y (index of occupied_rooms)
    lda (occupied_rooms_ptr),y  ; Load in the correct byte for the row
    sta bitmap                  ; Store bitmap into tmp

    lda room_col                ; Load in the column
    tay                         ; Copy to Y register
    lda (pow2_ptr),y            ; Get the power of 2 for the column
    and bitmap                  ; AND with tmp to get the value of the bit position
    ; A contains the result

    rts
    .endp

.proc set_room_occupied (.byte a) .reg
bitmap = tmp

    sta room_row
    and #7                      ; Mask the last 3 bits as the column (mod 8)
    sta room_col                ; Store column to a temp variable
    lda room_row
    lsr                         ; Divide by 8 to get the row
    lsr
    lsr
    sta room_row                ; Save into row
    tay                         ; Copy the room row to Y (index of occupied_rooms)
    lda (occupied_rooms_ptr),y  ; Load in the correct byte for the row
    sta bitmap
    lda room_col                ; Load in the column
    tay                         ; Copy to Y register
    lda (pow2_ptr),y            ; Get the power of 2 for the column
    ora bitmap                  ; OR with bitmap to get the value of the bit position
    sta bitmap                  ; Save it back to the bitmap
    lda room_row                ; Load the room row
    tay                         ; Set Y to the room row index
    lda bitmap                  ; Load the bitmap back into the accumulator
    sta (occupied_rooms_ptr),y  ; Store the bitmap into occupied room for appropriate index
    rts
    .endp
