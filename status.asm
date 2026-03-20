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

; Write byte in A as two hex digits at status_line position X
; Trashes A, Y. X advances by 2.
.proc print_hex
    pha
    lsr
    lsr
    lsr
    lsr
    jsr hex_nibble
    pla
    and #$0f
    jsr hex_nibble
    rts

hex_nibble
    cmp #10
    bcc digit
    add #7              ; 'A'-'9'-1 offset
digit
    add #$30            ; ATASCII '0'
    sta status_line,x
    inx
    rts
    .endp

; Write debug vars to status line: F:xx P:xxxx M:xxxx
; F=floor_index, P=player_ptr (hi:lo), M=map_ptr after map_offset (hi:lo)
.proc print_debug_status
    lda #$46            ; 'F'
    sta status_line+0
    lda #$3A            ; ':'
    sta status_line+1
    ldx #2
    lda floor_index
    jsr print_hex       ; pos 2-3

    lda #$20            ; ' '
    sta status_line+4
    lda #$50            ; 'P'
    sta status_line+5
    lda #$3A            ; ':'
    sta status_line+6
    ldx #7
    lda player_ptr+1    ; hi byte
    jsr print_hex       ; pos 7-8
    lda player_ptr      ; lo byte
    jsr print_hex       ; pos 9-10

    ; Compute map_offset into tmp_addr1 = player_ptr - (playfield_height/2 * map_width) - (playfield_width/2)
    mwa player_ptr tmp_addr1
    sbw tmp_addr1 #(playfield_height / 2 * map_width)
    sbw tmp_addr1 #(playfield_width / 2)

    lda #$20            ; ' '
    sta status_line+11
    lda #$4D            ; 'M'
    sta status_line+12
    lda #$3A            ; ':'
    sta status_line+13
    ldx #14
    lda tmp_addr1+1     ; hi byte
    jsr print_hex       ; pos 14-15
    lda tmp_addr1       ; lo byte
    jsr print_hex       ; pos 15-16

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

