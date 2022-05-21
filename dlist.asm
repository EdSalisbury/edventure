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
	.byte antic5 + lms, $00, $70
	.byte antic5 + lms, $80, $70
	.byte antic5 + lms, $00, $71
	.byte antic5 + lms, $80, $71
	.byte antic5 + lms, $00, $72
	.byte antic5 + lms, $80, $72
	.byte antic5 + lms, $00, $73
	.byte antic5 + lms, $80, $73
	.byte antic5 + lms, $00, $74
	.byte antic5 + lms, $80, $74
	.byte antic5 + lms, $00, $75
	.byte antic5 + lms, $80, $75
	.byte antic5 + lms, $00, $76
	.byte antic5 + lms, $80, $76
	.byte antic5 + lms, $00, $77
	.byte antic5 + lms, $80, $77
	.byte jvb, <dlist, >dlist
	.endp
