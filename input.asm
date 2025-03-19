dir_offsets:
    .byte 0, -map_width, map_width, -1, 1

.proc read_joystick
	mva STICK0 stick_dir
    mva STRIG0 stick_btn

check_up
    lda stick_dir
    and #STICK_UP
	beq check_down
    mva #NORTH stick_dir
    
check_down
    lda stick_dir
    and #STICK_DOWN
	beq check_left
    mva #SOUTH stick_dir

check_left
    lda stick_dir
    and #STICK_LEFT
	beq check_right
    mva #WEST stick_dir

check_right
    lda stick_dir
    and #STICK_RIGHT
	beq process
    mva #EAST stick_dir

process
    lda stick_btn
    cmp #BUTTON_DOWN
    beq action

move
    player_move stick_dir
    rts

action
    mwa player_ptr tmp_ptr
    ldy stick_dir
    lda dir_offsets,Y
    sta tmp
    adbw tmp tmp_ptr
    
    ldy #0
    lda (tmp_ptr),y
check_door
    cmp #MAP_DOOR
    bne check_doorway
    open_door tmp_ptr
    rts
check_doorway
    cmp #MAP_DOORWAY
    bne none
    close_door tmp_ptr
    rts

none
    rts
    .endp

.proc player_move(.byte dir) .var
    mwa player_ptr tmp_ptr
    ldy dir
    lda dir_offsets,Y
    sta tmp
    adbw tmp tmp_ptr
    
    is_passable tmp_ptr
    bcc blocked
    mwa tmp_ptr player_ptr
blocked
    rts
    .endp

.proc is_passable(.byte map_ptr) .var
    lda no_clip
    bne passable
    ldy #0
    lda (map_ptr),y
    cmp #PASSABLE_MIN
    bcs passable
    clc
    rts
passable
    sec
    rts
    .endp

.proc open_door(.byte map_ptr) .var
    lda #MAP_DOORWAY
    ldy #0
    sta (map_ptr),y
    rts
.endp

.proc close_door(.byte map_ptr) .var
    lda #MAP_DOOR
    ldy #0
    sta (map_ptr),y
    rts
.endp
