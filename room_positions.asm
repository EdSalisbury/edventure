    org room_positions
    ;  0  1  2  3  4  5  6  7
    ;  8  9 10 11 12 13 14 15
    ; 16 17 18 19 20 21 22 23
    ; 24 25 26 27 28 29 30 31
    ; 32 33 34 35 36 37 38 39
    ; 40 41 42 43 44 45 46 47
    ; 48 49 50 51 52 53 54 55
    ; 56 57 58 59 60 61 62 63
    .byte border + room_height * 0 + 0, border + room_width * 0 + 0   ; Room 0
    .byte border + room_height * 0 + 0, border + room_width * 1 + 1   ; Room 1
    .byte border + room_height * 0 + 0, border + room_width * 2 + 2   ; Room 2
    .byte border + room_height * 0 + 0, border + room_width * 3 + 3   ; Room 3
    .byte border + room_height * 0 + 0, border + room_width * 4 + 4   ; Room 4
    .byte border + room_height * 0 + 0, border + room_width * 5 + 5   ; Room 5
    .byte border + room_height * 0 + 0, border + room_width * 6 + 6   ; Room 6
    .byte border + room_height * 0 + 0, border + room_width * 7 + 7   ; Room 7
    
    .byte border + room_height * 1 + 1, border + room_width * 0 + 0   ; Room 8
    .byte border + room_height * 1 + 1, border + room_width * 1 + 1   ; Room 9
    .byte border + room_height * 1 + 1, border + room_width * 2 + 2   ; Room 10
    .byte border + room_height * 1 + 1, border + room_width * 3 + 3   ; Room 11
    .byte border + room_height * 1 + 1, border + room_width * 4 + 4   ; Room 12
    .byte border + room_height * 1 + 1, border + room_width * 5 + 5   ; Room 13
    .byte border + room_height * 1 + 1, border + room_width * 6 + 6   ; Room 14
    .byte border + room_height * 1 + 1, border + room_width * 7 + 7   ; Room 15
    
    .byte border + room_height * 2 + 2, border + room_width * 0 + 0   ; Room 16
    .byte border + room_height * 2 + 2, border + room_width * 1 + 1   ; Room 17
    .byte border + room_height * 2 + 2, border + room_width * 2 + 2   ; Room 18
    .byte border + room_height * 2 + 2, border + room_width * 3 + 3   ; Room 19
    .byte border + room_height * 2 + 2, border + room_width * 4 + 4   ; Room 20
    .byte border + room_height * 2 + 2, border + room_width * 5 + 5   ; Room 21
    .byte border + room_height * 2 + 2, border + room_width * 6 + 6   ; Room 22
    .byte border + room_height * 2 + 2, border + room_width * 7 + 7   ; Room 23
    
    .byte border + room_height * 3 + 3, border + room_width * 0 + 0   ; Room 24
    .byte border + room_height * 3 + 3, border + room_width * 1 + 1   ; Room 25
    .byte border + room_height * 3 + 3, border + room_width * 2 + 2   ; Room 26
    .byte border + room_height * 3 + 3, border + room_width * 3 + 3   ; Room 27
    .byte border + room_height * 3 + 3, border + room_width * 4 + 4   ; Room 28
    .byte border + room_height * 3 + 3, border + room_width * 5 + 5   ; Room 29
    .byte border + room_height * 3 + 3, border + room_width * 6 + 6   ; Room 30
    .byte border + room_height * 3 + 3, border + room_width * 7 + 7   ; Room 31
    
    .byte border + room_height * 4 + 4, border + room_width * 0 + 0   ; Room 32
    .byte border + room_height * 4 + 4, border + room_width * 1 + 1   ; Room 33
    .byte border + room_height * 4 + 4, border + room_width * 2 + 2   ; Room 34
    .byte border + room_height * 4 + 4, border + room_width * 3 + 3   ; Room 35
    .byte border + room_height * 4 + 4, border + room_width * 4 + 4   ; Room 36
    .byte border + room_height * 4 + 4, border + room_width * 5 + 5   ; Room 37
    .byte border + room_height * 4 + 4, border + room_width * 6 + 6   ; Room 38
    .byte border + room_height * 4 + 4, border + room_width * 7 + 7   ; Room 39
    
    .byte border + room_height * 5 + 5, border + room_width * 0 + 0   ; Room 40
    .byte border + room_height * 5 + 5, border + room_width * 1 + 1   ; Room 41
    .byte border + room_height * 5 + 5, border + room_width * 2 + 2   ; Room 42
    .byte border + room_height * 5 + 5, border + room_width * 3 + 3   ; Room 43
    .byte border + room_height * 5 + 5, border + room_width * 4 + 4   ; Room 44
    .byte border + room_height * 5 + 5, border + room_width * 5 + 5   ; Room 45
    .byte border + room_height * 5 + 5, border + room_width * 6 + 6   ; Room 46
    .byte border + room_height * 5 + 5, border + room_width * 7 + 7   ; Room 47
    
    .byte border + room_height * 6 + 6, border + room_width * 0 + 0   ; Room 48
    .byte border + room_height * 6 + 6, border + room_width * 1 + 1   ; Room 49
    .byte border + room_height * 6 + 6, border + room_width * 2 + 2   ; Room 50
    .byte border + room_height * 6 + 6, border + room_width * 3 + 3   ; Room 51
    .byte border + room_height * 6 + 6, border + room_width * 4 + 4   ; Room 52
    .byte border + room_height * 6 + 6, border + room_width * 5 + 5   ; Room 53
    .byte border + room_height * 6 + 6, border + room_width * 6 + 6   ; Room 54
    .byte border + room_height * 6 + 6, border + room_width * 7 + 7   ; Room 55
    
    .byte border + room_height * 7 + 7, border + room_width * 0 + 0   ; Room 56
    .byte border + room_height * 7 + 7, border + room_width * 1 + 1   ; Room 57
    .byte border + room_height * 7 + 7, border + room_width * 2 + 2   ; Room 58
    .byte border + room_height * 7 + 7, border + room_width * 3 + 3   ; Room 59
    .byte border + room_height * 7 + 7, border + room_width * 4 + 4   ; Room 60
    .byte border + room_height * 7 + 7, border + room_width * 5 + 5   ; Room 61
    .byte border + room_height * 7 + 7, border + room_width * 6 + 6   ; Room 62
    .byte border + room_height * 7 + 7, border + room_width * 7 + 7   ; Room 63
