.macro inc16 addr
	inc :addr
	bne skip_carry
	inc :addr + 1
skip_carry
	.endm

.macro adbw src val
	lda :src
	add :val
	sta :src
	bcc skip_carry
	inc :src + 1
skip_carry
	.endm