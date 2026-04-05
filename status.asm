.proc print_status
  lda #0
  sta status_line + 1   ; leading space at pos 1
  ldy #0
  ldx #2                ; text starts at pos 2

loop
  lda (status_str_ptr), y
  cmp #$ff              ; Look for sentinel char (FF)
  beq fill
  sta status_line,x
  iny
  inx
  cpx #39               ; End of line
  bne loop
  beq set_timer         ; filled to edge, nothing to fill

fill
  lda #0

fill_loop
  cpx #39
  beq set_timer
  sta status_line,x
  inx
  bne fill_loop

set_timer
  lda clock
  add #status_duration
  sta status_timer
  rts

.endp

.macro tick_status
	lda status_timer
	beq done
	cmp clock
	bne done
	jsr reset_top_border
	lda #0
	sta status_timer
done
.endm

