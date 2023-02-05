* --------------------------------------- *
* Proc: setup_screen                      *
* Sets up the display list for the screen *
* --------------------------------------- *
.proc setup_screen
blank8 = $70    ; 8 blank lines
lms = $40	    ; Load Memory Scan
jvb = $41	    ; Jump while vertical blank
NMIEN_DLI = $80
NMIEN_VBI = $64

antic4 = 4      ; Antic mode 4
antic5 = 5	    ; Antic mode 5

	mwa #dlist SDLSTL
	mwa #dli1 VDSLST
	lda #NMIEN_VBI | NMIEN_DLI
	sta NMIEN
	rts

dlist
	.byte blank8, blank8, blank8
	.byte antic4 + lms + NMIEN_DLI, <status_line, >status_line
	.byte antic5 + lms, <screen, >screen
	.byte antic5, antic5, antic5, antic5, antic5
	.byte antic5, antic5, antic5, antic5, antic5 + NMIEN_DLI, antic4
	.byte jvb, <dlist, >dlist
	

dli1
	pha
	lda #1
	sta WSYNC
	mva #>charset_dungeon_a CHBASE
	blit_screen()
	mwa #dli2 VDSLST
	pla
	rti

dli2
	pha
	lda #1
	sta WSYNC
	mva #>charset_outdoor_a CHBASE
	mwa #dli1 VDSLST
	pla
	rti

	.endp