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
	.byte antic5 + lms, $00, $86
	.byte antic5 + lms, $40, $86
	.byte antic5 + lms, $80, $86
	.byte antic5 + lms, $c0, $86
	.byte antic5 + lms, $00, $87
	.byte antic5 + lms, $40, $87
	.byte antic5 + lms, $80, $87
	.byte antic5 + lms, $c0, $87
	.byte antic5 + lms, $00, $88
	.byte antic5 + lms, $40, $88
	.byte antic5 + lms, $80, $88
	.byte antic5 + lms, $c0, $88
	.byte antic5 + lms, $00, $89
	.byte antic5 + lms, $40, $89
	.byte antic5 + lms, $80, $89
	.byte antic5 + lms, $c0, $89
	.byte jvb, <dlist, >dlist
	.endp
