#IfWinActive, ahk_exe Hexcells Infinite.exe

; Hotkey to make excape do what it should in this otherwise awesome game
Escape::
    ; There are all kinds of magic numbers in here but I am tired and going to bed.
    ; TO DO: Comment or refactor magic numbers
    PixelGetColor, c_val_1, 965, 875
    PixelGetColor, c_val_2, 0, 0

    if (c_val_1 = "0xF2F2F2" or c_val_1 = "0xFFFFFF") {
        dest_x = 965
        dest_y = 875
    } else if (c_val_2 = "0x414141") {
        dest_x = 960
        dest_y = 750
    } else {
        dest_x = 50
        dest_y = 50
    }

    click_and_return(dest_x, dest_y)

Return

#IfWinActive
