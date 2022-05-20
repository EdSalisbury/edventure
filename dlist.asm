* --------------------------------------- *
* Proc: setup_screen                      *
* Sets up the display list for the screen *
* --------------------------------------- *
.proc setup_screen
blank8 = $70    ; 8 blank lines
lms = $40	    ; Load Memory Scan
jvb = $41	    ; Jump while vertical blank

antic2 = 2      ; Antic mode 2
antic5 = 5	    ; Antic mode 5

	mwa #dlist SDLSTL
	rts

dlist
	.byte blank8, blank8, blank8
	.byte antic5 + lms, $00, $80
	.byte antic5 + lms, $40, $80
	.byte antic5 + lms, $80, $80
	.byte antic5 + lms, $c0, $80
	.byte antic5 + lms, $00, $81
	.byte antic5 + lms, $40, $81
	.byte antic5 + lms, $80, $81
	.byte antic5 + lms, $c0, $81
	.byte antic5 + lms, $00, $82
	.byte antic5 + lms, $40, $82
	.byte antic5 + lms, $80, $82
	.byte antic5 + lms, $c0, $82
	.byte antic5 + lms, $00, $83
	.byte antic5 + lms, $40, $83
	.byte antic5 + lms, $80, $83
	.byte antic5 + lms, $c0, $83
	.byte jvb, <dlist, >dlist
	.endp
