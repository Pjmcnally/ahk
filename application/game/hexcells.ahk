#IfWinActive, ahk_exe Hexcells Infinite.exe

quit_func() {
    ; There are all kinds of magic numbers in here but I am tired and going to bed.
    ; TO DO: Comment or refactor magic numbers
    PixelGetColor, c_val_1, 965, 875
    PixelGetColor, c_val_2, 0, 0
    PixelGetColor, c_val_3, 1865, 1050

    if (c_val_1 = "0xF2F2F2" or c_val_1 = "0xFFFFFF") {
        dest_x = 965
        dest_y = 875
    } else if (c_val_2 = "0x414141") {
        dest_x = 960
        dest_y = 750
    } else if (c_val_3 = "0xCCCCCC") {
        dest_x = 1000
        dest_y = 1000
    } else {
        dest_x = 50
        dest_y = 50
    }

    click_and_return(dest_x, dest_y)
}

; Hotkey to make escape do what it should in this otherwise awesome game
Escape::
    quit_func()
Return

#IfWinActive
