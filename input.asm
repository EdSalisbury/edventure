.proc read_joystick
    ldx STICK0              ; Load stick direction bitmap into X
    ;ldy STRIG0              ; Load trigger state into Y (1 = not pressed, 0 = pressed)
    clr stick_dir           ; Clear stick_dir variable

check_up
    txa                     ; Copy X into A
    and #STICK_UP           ; Check if stick is pressing up
    bne check_down          ; If not up, check down
    mva #NORTH stick_dir    ; Set stick_dir to north
    jmp check_button        ; Go check button state

check_down
    txa                     ; Copy X into A
    and #STICK_DOWN         ; Check if stick is pressing down
    bne check_left          ; If not down, check left
    mva #SOUTH stick_dir    ; Set stick_dir to south
    jmp check_button        ; Go check button state

check_left
    txa                     ; Copy X into A
    and #STICK_LEFT         ; Check if stick is pressing left
    bne check_right         ; If not left, check right
    mva #WEST stick_dir     ; Set stick_dir to west
    jmp check_button        ; Go check button state

check_right
    txa                     ; Copy X into A
    and #STICK_RIGHT        ; Check if stick is pressing right
    bne check_button        ; If not right, check button
    mva #EAST stick_dir     ; Set stick_dir to east
    jmp check_button        ; Go check button state

check_button
    cpy #BUTTON_DOWN        ; Check if button is down
    bne move                ; Not pressing so move

action
    player_action()         ; Perform action
    rts

move
    player_move()           ; Perform movement
    rts

    .endp

.proc player_action
    mva player_ptr dir_ptr  ; Reset direction pointer
    ldy stick_dir           ; Stick direction (0 = no direction, 1 = north, 2 = south, 3 = west, 4 = east)

check_north
    cpy #NORTH              ; Is the player pointing north?
    bne check_south         ; Nope, skip to next check
    sbw dir_ptr #map_width  ; Move up one row
    jmp get_tile            ; Go get the tile

check_south
    cpy #SOUTH              ; Is the player pointing south?
    bne check_west          ; Nope, skip to next check
    adw dir_ptr #map_width  ; Move down one row
    jmp get_tile            ; Go get the tile

check_west
    cpy #WEST               ; Is the player pointing west?
    bne check_east          ; Nope, skip to next check
    dew dir_ptr             ; Move left one column
    jmp get_tile            ; Go get the tile

check_east
    cpy #EAST               ; Is the player pointing east?
    bne get_tile            ; Nope, skip to get the tile
    inw dir_ptr             ; Move right one column
    jmp get_tile            ; Go get the tile

get_tile
    ldy #0                  ; Init Y
    lda (dir_ptr),Y         ; Get tile by dereference the direction pointer

check_door
    cmp #MAP_DOOR           ; Is it a door?
    bne check_doorway       ; Nope, skip to next check
    open_door()             ; Open the door
    rts

check_doorway
    cmp #MAP_DOORWAY        ; Is it a doorway?
    bne none                ; Nope, we're done
    close_door()            ; Close the door
    rts

none
    rts
    .endp


