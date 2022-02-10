SDLSTL = $0230  ; Display list starting address
CHBAS  = $02f4  ; CHaracter BAse Register
COLOR0 = $02c4	; Color for %01
COLOR1 = $02c5  ; Color for %10
COLOR2 = $02c6  ; Color for %11 (normal)
COLOR3 = $02c7  ; Color for %11 (inverse)
COLOR4 = $02c8  ; Color for %00 (background)

HPOSP0 = $D000 ; Horizontal position of player 0
HPOSP1 = $D001 ; Horizontal position of player 1
HPOSP2 = $D002 ; Horizontal position of player 2
HPOSP3 = $D003 ; Horizontal position of player 3
HPOSM0 = $D004 ; Horizontal position of missile 0
HPOSM1 = $D005 ; Horizontal position of missile 1
HPOSM2 = $D006 ; Horizontal position of missile 2
HPOSM3 = $D007 ; Horizontal position of missile 3
SIZEP0 = $D008 ; Size (width) of player 0 (0-3)
SIZEP1 = $D009 ; Size (width) of player 1 (0-3)
SIZEP2 = $D010 ; Size (width) of player 2 (0-3)
SIZEP3 = $D011 ; Size (width) of player 3 (0-3)
SIZEM = $D00C ; Size of all missiles
COLPM0 = $D012 ; Color of player and missile 0
COLPM1 = $D013 ; Color of player and missile 1
COLPM2 = $D014 ; Color of player and missile 2
COLPM3 = $D015 ; Color of player and missile 3
COLPF0 = $D016 ; Color of playfield 0
COLPF1 = $D017 ; Color of playfield 1
COLPF2 = $D018 ; Color of playfield 2
COLPF3 = $D019 ; Color of playfield 3 / Player 4
COLBK = $D01A ; Color of background
PRIOR = $D01B ; Priority order - which players are on top - bit 4=1 (enable player 4)
GRACTL = $D01D ; 53277 - Enable/disable PMG
PMBASE = $D407 ; 54279 - Player Missile Graphics Base address
PCOLR0 = $2C0 ; 704
PCOLR1 = $2C1
PCOLR2 = $2C2
PCOLR3 = $2C3

SDMCTL = $22F ; 559 ; 46 ($2E) = double line resolution
MEMTOP = $2E5 ; 741
RAMTOP = $6A ; 106
GRPRIOR = $26F ; 623

