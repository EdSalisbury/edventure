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
	.byte antic5 + lms, <screen, >screen
	.byte antic5, antic5, antic5, antic5, antic5
	.byte antic5, antic5, antic5, antic5, antic5, antic5
	.byte jvb, <dlist, >dlist
	.endp
