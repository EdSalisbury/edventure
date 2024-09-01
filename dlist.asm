* --------------------------------------- *
* Proc: setup_screen                      *
* Sets up the display list for the screen *
* --------------------------------------- *
	org dlist

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

	; Wait until a VBLANK occurs
	lda RTCLK2
loop
	cmp RTCLK2
	beq loop


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
	pha							; Push A onto the stack
	lda #1						; WSYNC just needs a non-zero value
	sta WSYNC					; Store the 1 into WSYNC - This will block while waiting
	lda charset_a				; See if charset_a is set to 0 or non-zero
	bne use_charset_b			; If charset_a is 0, zero flag is set, so it will jump to use_charset_b
	mva #>cur_charset_a CHBASE	; If not, we're using charset A, so copy to CHBASE
	jmp done					; Skip over use_charset_b

use_charset_b
	mva #>cur_charset_b CHBASE  ; We're using charset B, so copy to CHBASE

done
	mwa #dli2 VDSLST
	set_colors			
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