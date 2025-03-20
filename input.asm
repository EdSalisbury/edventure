.proc read_joystick
    ldx STICK0
    ldy STRIG0
    mva #0 stick_dir

check_up
    txa
    and #STICK_UP
	bne check_down
    mva #NORTH stick_dir
    jmp check_button

check_down
    txa
    and #STICK_DOWN
	bne check_left
    mva #SOUTH stick_dir
    jmp check_button

check_left
    txa
    and #STICK_LEFT
	bne check_right
    mva #WEST stick_dir
    jmp check_button

check_right
    txa
    and #STICK_RIGHT
	bne check_button
    mva #EAST stick_dir

check_button
    cpy #BUTTON_DOWN
    bne move
action
    player_action()
    rts
move
    player_move()
    rts
    .endp

.proc player_action
    mwa player_ptr dir_ptr
    ldy stick_dir

check_north
    cpy #NORTH
    bne check_south
    sbw dir_ptr #map_width
    jmp get_tile
check_south
    cpy #SOUTH
    bne check_west
    adw dir_ptr #map_width
    jmp get_tile
check_west
    cpy #WEST
    bne check_east
    dec dir_ptr
    jmp get_tile
check_east
    cpy #EAST
    bne get_tile
    inc dir_ptr
get_tile
    ldy #0
    lda (dir_ptr),y
check_door
    cmp #MAP_DOOR
    bne check_doorway
    open_door()
    rts
check_doorway
    cmp #MAP_DOORWAY
    bne none
    close_door()
    rts
none
    rts
    .endp

.proc player_move
    mwa player_ptr dir_ptr
    ldy stick_dir
    cpy #0
    beq blocked
check_north
    cpy #NORTH
    bne check_south
    sbw dir_ptr #map_width
    jmp check_passable
check_south
    cpy #SOUTH
    bne check_west
    adw dir_ptr #map_width
    jmp check_passable
check_west
    cpy #WEST
    bne check_east
    dec dir_ptr
    jmp check_passable
check_east
    cpy #EAST
    bne check_passable
    inc dir_ptr
    jmp check_passable
check_passable
    is_passable()
    bcc blocked
    mwa dir_ptr player_ptr
blocked
    rts
    .endp

.proc is_passable
    lda no_clip
    bne passable
    ldy #0
    lda (dir_ptr),y
    cmp #PASSABLE_MIN
    bcc blocked
passable
    sec
    rts
blocked
    clc
    rts
    .endp

.proc open_door
    lda #MAP_DOORWAY
    ldy #0
    sta (dir_ptr),y
    rts
.endp

.proc close_door
    lda #MAP_DOOR
    ldy #0
    sta (dir_ptr),y
    rts
.endp
