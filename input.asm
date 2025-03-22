.proc read_joystick
    ; Temp vars used
    cur_btn = tmp1          ; Current button state
    
    mva STRIG0 cur_btn      ; Get current button state from HW register (1 = up, 0 = down)
    bne up                  ; If current button state is non-zero, the button is up
down                        ; The button is currently down
    lda stick_btn           ; Get the previous button state
    bne done                ; If previous button state is non-zero and current button state is zero, it was just pushed
held                        ; The button is held down
    lda stick_action        ; Get the action state
    bne done                ; If the action state is non-zero, don't do the action again
    read_direction()        ; Update the direction pointer
    player_action()         ; Do the action
    
    jmp done                ; Skip to done
up                          ; The button is currently up
    read_direction()        ; Update the direction pointer
    player_move()           ; Move the player
    clr stick_action        ; If the player is moving, we don't care about the action state so reset it                      
done
    mva cur_btn stick_btn   ; Set the stick button for next time
    rts
    .endp

; Get the direction from the joystick and update dir_ptr
; Does not support diagonal movement, and is processed in the following priority order: UP, DOWN, LEFT, RIGHT
.proc read_direction
    ; Temp vars used
    stick_dir = tmp2            ; Current stick direction
    
    ; Init
    mwa player_ptr dir_ptr      ; Copy the player pointer to the direction ptr as a base
    mva STICK0 stick_dir        ; Load stick bitmap from HW register

check_up
    and #STICK_UP               ; Check to see if it's pushed UP
    bne check_down              ; It's not pushed UP, so move to the next check
    sbw dir_ptr #map_width      ; It is pushed UP, so move the temp pointer up one line
    rts                         ; We're done updating the dir pointer (this will take priority)
check_down
    lda stick_dir               ; Re-copy non-mutated stick dir to A
    and #STICK_DOWN             ; Check to see if it's pushed DOWN
    bne check_left              ; It's not pushed DOWN, so move to the next check
    adw dir_ptr #map_width      ; It is pushed DOWN, so move the temp pointer down one line
    rts
check_left
    lda stick_dir               ; Re-copy non-mutated stick dir to AA
    and #STICK_LEFT             ; Check to see if it's pushed LEFT
    bne check_right             ; It's not pushed LEFT, so move to the next check
    dec dir_ptr                 ; It is pushed LEFT, so move the temp pointer left one
check_right
    lda stick_dir               ; Re-copy non-mutated stick dir to A
    and #STICK_RIGHT            ; Check to see if it's pushed RIGHT
    bne done                    ; If not, we're done checking
    inc dir_ptr                 ; It is pushed RIGHT, so move the temp pointer left one
done
    rts
    .endp

; Player action
.proc player_action
    ldi dir_ptr
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

; Player Movement
.proc player_move
    ldi dir_ptr
    beq blocked

check_passable
    is_passable()
    bcc blocked
    mwa dir_ptr player_ptr
blocked
    rts
    .endp

; Check to see if a tile is passable
.proc is_passable
    lda no_clip
    bne passable
    ldi dir_ptr
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
    sti dir_ptr
    inc stick_action        ; Set the action state so that it can't fire off too soon
    rts
.endp

.proc close_door
    lda #MAP_DOOR
    sti dir_ptr
    inc stick_action        ; Set the action state so that it can't fire off too soon
    rts
.endp
