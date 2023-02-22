    ; Load in the rooms file
    ; 15x15 for the locations
    ; Fill the whole map with walls

    .proc new_map
        mwa #map map_ptr        ; Init map pointer
        lda #MAP_WALL           ; Load in basic wall tile
        ldy #0                  ; Init horizontal index
        ldx #0                  ; Init vertical index
        
    loop:
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

    place_room()
        rts
        .endp

.proc place_room

room_number = 0
room_pos = 1

room_y = tmp
room_x = tmp + 1
room_pos_ptr = tmp_addr1

    
    ; Get the correct position of the room coordinates (multiply by 2)
    lda #room_pos
    asl
    tax

    ; Get room position
    lda room_positions,x
    sta room_y
    inx
    lda room_positions,x
    sta room_x

    ; Move the map_ptr to the correct position (y)
    mwa #map map_ptr
    ldy #0
y_loop:
    adw map_ptr #map_width
    iny
    cpy room_y
    bne y_loop

    ; Move the map_ptr to the correct position (x)
    adw map_ptr room_x

    ; Make a copy of the map pointer for later
    mwa map_ptr room_pos_ptr

    ; Move the room pointer to the correct location
    mwa #rooms room_ptr

    ldx #0
    ldy #0
loop:
    lda (room_ptr),y
    sta (map_ptr),y         ; Store tile at current map ptr
    iny                     ; Move one tile to the right
    cpy #room_width         ; Check to see if the line is complete
    bne loop                ; If not, keep looping

    ldy #0                  ; If the line is complete, reset horiz index
    adw map_ptr #map_width  ; Advance the map pointer one full line
    adw room_ptr #room_width
    inx                     ; Advance the vertical line index
    cpx #room_height        ; Check to see if the lines have all been copied
    bne loop                ; If not, keep looping


    mwa room_pos_ptr map_ptr
    ; Remove doors that are on the edge

DOOR_NORTH = %1000
DOOR_SOUTH = %0100
DOOR_WEST  = %0010
DOOR_EAST  = %0001
doors = tmp
    ldy #0
    lda (room_ptr),y        ; Load in doors for this room
    ldx #0                  ; Room number
    and room_doors,x        ; AND with possible doors for this room
    sta doors

    ldy #0
   ; Place possible doors
check_north:
    lda doors
    and #DOOR_NORTH
    bne place_north_door
    
check_south:
    lda doors
    and #DOOR_SOUTH
    bne place_south_door
    
check_west:
    lda doors
    and #DOOR_WEST
    bne place_west_door
    
check_east:
    lda doors
    and #DOOR_EAST
    bne place_east_door
 
    jmp done

place_north_door:
    mwa room_pos_ptr map_ptr
    sbw map_ptr #map_width
    adw map_ptr #(room_width / 2)
    lda #MAP_DOOR
    ldy #0
    sta (map_ptr),y
    jmp check_south

place_south_door:
    mwa room_pos_ptr map_ptr
    ldy #0
loop_s:
    adw map_ptr #map_width
    iny
    cpy #room_height
    bne loop_s

    adw map_ptr #(room_width / 2)
    lda #MAP_DOOR
    ldy #0
    sta (map_ptr),y
    jmp check_west

place_west_door:
    mwa room_pos_ptr map_ptr
    ldy #0
loop_w:
    adw map_ptr #map_width
    iny
    cpy #(room_height / 2)
    bne loop_w

    lda #MAP_DOOR
    ldy #0
    sta (map_ptr),y
    jmp check_east

place_east_door:
    mwa room_pos_ptr map_ptr
    ldy #0
loop_e:
    adw map_ptr #map_width
    iny
    cpy #(room_height / 2)
    bne loop_e

    adw map_ptr #room_width
                 
    lda #MAP_DOOR
    ldy #0
    sta (map_ptr),y

done:
    rts
    .endp

; Based off of Brad Smith's LFSR algorithm here: https://github.com/bbbradsmith/prng_6502
.proc random_bs
    ldy #8
    lda seed
top
    asl
    rol seed+1
    bcc next
    eor #$39
next:
    dey
    bne top
    sta seed
    rts
    .endp

; https://forums.atariage.com/topic/159268-random-numbers/#comment-1958751
.proc random16
    lda rand
    lsr
    rol rand + 1
    bcc no_eor
    eor #$b4
no_eor:
    sta rand
    eor rand + 1
    rts
    .endp

.proc random8
    lda rand
    lsr
    bcc no_eor
    eor #$b4
no_eor:
    sta rand
    rts
    .endp

