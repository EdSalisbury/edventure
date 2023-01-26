* --------------------------------------- *
* Proc: setup_screen                      *
* Sets up the display list for the screen *
* --------------------------------------- *
.proc setup_screen
blank8 = $70    ; 8 blank lines
lms = $40	    ; Load Memory Scan
jvb = $41	    ; Jump while vertical blank

antic4 = 4      ; Antic mode 2
antic5 = 5	    ; Antic mode 5

	mwa #dlist SDLSTL
	; Add DLI
	mwa #dli1 VDSLST
	lda #NMIEN_VBI | NMIEN_DLI
	sta NMIEN
	
	; ldx #>vbi
	; ldy #<vbi
	; lda #7
	; jsr SETVBV
 
	rts

dlist
	.byte blank8, blank8, blank8
	.byte antic4 + lms + NMIEN_DLI, <status_line, >status_line
	.byte antic5 + lms, <screen, >screen, antic5, antic5, antic5, antic5
	.byte antic5, antic5, antic5, antic5, antic5, antic5 + NMIEN_DLI, antic4 
	.byte jvb, <dlist, >dlist
	.endp

dli1
	pha
	txa
	pha
	tya
	pha
	lda #1
	sta WSYNC
	mva #>charset_dungeon_a CHBASE
	blit_playfield()
	pla
	tay
	pla
	tax
	pla
	mwa #dli2 VDSLST
	rti

dli2
	pha
	txa
	pha
	tya
	pha
	lda #1
	sta WSYNC
	mva #>charset_outdoor_a CHBASE
	pla
	tay
	pla
	tax
	pla
	mwa #dli1 VDSLST
	rti

vbi
	;read_joystick()
	;blit_playfield()
	mwa #dli1 VDSLST
	jmp XITVBV
