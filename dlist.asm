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
	.byte antic5 + lms, $00, $60
	.byte antic5 + lms, $80, $60
	.byte antic5 + lms, $00, $61
	.byte antic5 + lms, $80, $61
	.byte antic5 + lms, $00, $62
	.byte antic5 + lms, $80, $62
	.byte antic5 + lms, $00, $63
	.byte antic5 + lms, $80, $63
	.byte antic5 + lms, $00, $64
	.byte antic5 + lms, $80, $64
	.byte antic5 + lms, $00, $65
	.byte antic5 + lms, $80, $65
	.byte jvb, <dlist, >dlist
	.endp
