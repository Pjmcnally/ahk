#IfWinActive, ahk_exe Hexcells Infinite.exe

; Hotkey to make excape do what it should in this otherwise awesome game
Escape::
    MouseGetPos,  mouse_x, mouse_y
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

    MouseMove, %dest_x%, %dest_y%, 0
    Click Down
    Sleep 50
    Click Up
    MouseMove, % mouse_x, mouse_y, 0
Return

#IfWinActive
