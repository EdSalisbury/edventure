monster_verbs ; Look up table
  dta a(str_verb_bites)                ; 0
  dta a(str_verb_claws)                ; 1              
  dta a(str_verb_hits)                 ; 2               
  dta a(str_verbs_stings)              ; 3             
  dta a(str_verbs_breathes_ice)        ; 4       
  dta a(str_verbs_breathes_acid)       ; 5      
  dta a(str_verbs_breathes_lightning)  ; 6
  dta a(str_verbs_breathes_fire)       ; 7

monster_name_lo
    dta <str_mon_rat,<str_mon_zombie,<str_mon_skel_m,<str_mon_skel_r
    dta <str_mon_bat,<str_mon_slime,<str_mon_snake,<str_mon_gob_m
    dta <str_mon_gob_r,<str_mon_gnoll,<str_mon_spider,<str_mon_mutant
    dta <str_mon_troll,<str_mon_imp,<str_mon_wolf,<str_mon_scorp
    dta <str_mon_owlbear,<str_mon_mimic,<str_mon_ghost,<str_mon_demon
    dta <str_mon_cyclops,<str_mon_wyvern,<str_mon_vampire,<str_mon_gazer
    dta <str_mon_wdragon,<str_mon_bdragon,<str_mon_bldragon
    dta <str_mon_rdragon,<str_mon_gdragon

monster_name_hi
    dta >str_mon_rat,>str_mon_zombie,>str_mon_skel_m,>str_mon_skel_r
    dta >str_mon_bat,>str_mon_slime,>str_mon_snake,>str_mon_gob_m
    dta >str_mon_gob_r,>str_mon_gnoll,>str_mon_spider,>str_mon_mutant
    dta >str_mon_troll,>str_mon_imp,>str_mon_wolf,>str_mon_scorp
    dta >str_mon_owlbear,>str_mon_mimic,>str_mon_ghost,>str_mon_demon
    dta >str_mon_cyclops,>str_mon_wyvern,>str_mon_vampire,>str_mon_gazer
    dta >str_mon_wdragon,>str_mon_bdragon,>str_mon_bldragon
    dta >str_mon_rdragon,>str_mon_gdragon

; attack damage
monster_attack
    dta  2, 2, 3, 3, 2, 1, 4, 4  ; rat, zombie, skel m, skel r, bat, slime, snake, gob m
    dta  5, 5, 6, 8, 6, 9, 8,10  ; gnoll, spider, mutant, troll, imp, wolf, scorp, owlbear
    dta 12, 7,14,15,13,12,16     ; mimic, ghost, demon, cyclops, wyvern, vampire, gazer
    dta 18,20,22,25,30           ; dragons

; defense
monster_defense
    dta  0, 1, 2, 1, 0, 0, 1, 2  ; rat, zombie, skel m, skel r, bat, slime, snake, gob m
    dta  3, 2, 3, 5, 2, 4, 5, 6  ; gnoll, spider, mutant, troll, imp, wolf, scorp, owlbear
    dta  8, 3, 7, 8, 6, 7, 8     ; mimic, ghost, demon, cyclops, wyvern, vampire, gazer
    dta 10,11,12,14,15           ; dragons

; aggressiveness (0=always flees, 255=never flees)
monster_aggr
    dta  20,255,255,200, 30,255,180,100  ; rat, zombie, skel m, skel r, bat, slime, snake, gob m
    dta  80,180,210,150,240,150,230,200  ; gnoll, spider, mutant, troll, imp, wolf, scorp, owlbear
    dta 255,200,240,220,200,180,255      ; mimic, ghost, demon, cyclops, wyvern, vampire, gazer
    dta 255,255,255,255,255              ; dragons

; detection range (tiles)
monster_detect
    dta  4, 2, 5, 7, 8, 2, 4, 6  ; rat, zombie, skel m, skel r, bat, slime, snake, gob m
    dta  8, 4, 5, 4, 6, 8, 4, 5  ; gnoll, spider, mutant, troll, imp, wolf, scorp, owlbear
    dta  0,10, 8, 7,10,10,12     ; mimic, ghost, demon, cyclops, wyvern, vampire, gazer
    dta 12,12,12,12,12           ; dragons

; speed (0=stationary, 1=slow, 2=normal, 3=fast, 4=very fast)
monster_speed
    dta  3, 1, 2, 1, 4, 1, 2, 2  ; rat, zombie, skel m, skel r, bat, slime, snake, gob m
    dta  2, 3, 2, 2, 3, 3, 2, 2  ; gnoll, spider, mutant, troll, imp, wolf, scorp, owlbear
    dta  0, 3, 2, 1, 3, 3, 2     ; mimic, ghost, demon, cyclops, wyvern, vampire, gazer
    dta  1, 1, 1, 1, 1           ; dragons (slow but terrifying)


; verb id (0=bites,1=claws,2=hits,3=stings,4-7=breath)
monster_verb_id
    dta  0, 0, 2, 2, 0, 3, 0, 1  ; rat, zombie, skel m, skel r, bat, slime, snake, gob m
    dta  2, 1, 0, 2, 1, 1, 1, 3  ; gob r, gnoll, spider, mutant, troll, imp, wolf, scorp
    dta  1, 2, 3, 1, 2, 1, 0, 3  ; owlbear, mimic, ghost, demon, cyclops, wyvern, vampire, gazer
    dta  4, 5, 6, 7, 7           ; dragons
