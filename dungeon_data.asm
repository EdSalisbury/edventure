; floor params: starting_monster, window_size, monster_count
; indexed as (dungeon*floors_per_dungeon + floor) * 3
; last floor of each dungeon = dragon floor (dragon type implied by dungeon#)
floor_params
    ; dungeon 1 - white dragon
    dta  0, 3,  4   ; floor 1 - rat, zombie, skel m
    dta  0, 4,  5   ; floor 2 - + skel r
    dta  0, 5,  6   ; floor 3 - + bat
    dta  0, 6,  8   ; floor 4 - + slime
    dta  0, 3,  6   ; floor 5 - dragon + rat, zombie, skel m

    ; dungeon 2 - black dragon
    dta  4, 3,  5   ; floor 1 - bat, slime, snake
    dta  4, 4,  6   ; floor 2 - + gob m
    dta  4, 5,  7   ; floor 3 - + gob r
    dta  4, 6,  8   ; floor 4 - + gnoll
    dta  4, 3,  6   ; floor 5 - dragon + bat, slime, snake

    ; dungeon 3 - blue dragon
    dta  9, 3,  6   ; floor 1 - gnoll, spider, mutant
    dta  9, 4,  7   ; floor 2 - + troll
    dta  9, 5,  8   ; floor 3 - + imp
    dta  9, 6, 10   ; floor 4 - + werewolf
    dta  9, 3,  7   ; floor 5 - dragon + gnoll, spider, mutant

    ; dungeon 4 - red dragon
    dta 14, 3,  7   ; floor 1 - werewolf, scorp, owlbear
    dta 14, 4,  8   ; floor 2 - + mimic
    dta 14, 5,  9   ; floor 3 - + ghost
    dta 14, 6, 10   ; floor 4 - + demon
    dta 14, 3,  8   ; floor 5 - dragon + werewolf, scorp, owlbear

    ; dungeon 5 - gold dragon
    dta 18, 3,  8   ; floor 1 - ghost, demon, cyclops
    dta 18, 4,  9   ; floor 2 - + wyvern
    dta 18, 5, 10   ; floor 3 - + vampire
    dta 18, 6, 12   ; floor 4 - + gazer
    dta 18, 3, 10   ; floor 5 - dragon + ghost, demon, cyclops