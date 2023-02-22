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
room_width = 15
room_height = 15
room_number = 0
map_pos = 0
    mwa #map map_ptr
    adw map_ptr #(map_width * 9)  ; Add 9 rows
    adw map_ptr #9                ; Add 9 columns

    mwa #rooms room_ptr
    ; Advance for whichever room it is

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

   ; adw room_ptr #room_width

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
    mwa #map map_ptr
    adw map_ptr #(map_width * 8)
    adw map_ptr #(9 + room_width / 2)                
    lda #MAP_DOOR
    sta (map_ptr),y
    jmp check_south

place_south_door:
    mwa #map map_ptr
    adw map_ptr #(map_width * (9 + room_height))
    adw map_ptr #(9 + room_width / 2)                
    lda #MAP_DOOR
    sta (map_ptr),y
    jmp check_west

place_west_door:
    mwa #map map_ptr
    adw map_ptr #(map_width * (9 + room_height / 2)) 
    adw map_ptr #8                
    lda #MAP_DOOR
    sta (map_ptr),y
    jmp check_east

place_east_door:
    mwa #map map_ptr
    adw map_ptr #(map_width * (9 + room_height / 2)) 
    adw map_ptr #(9 + room_width)               
    lda #MAP_DOOR
    sta (map_ptr),y

done:
    rts
    .endp





