#IfWinActive, ahk_exe Hexcells Infinite.exe

; Hotkey to make excape do what it should in this otherwise awesome game
Escape::
    MouseGetPos,  mouse_x, mouse_y
    MouseMove, 50, 50, 0  ; Hardcoded value of "Exit" control in game
    Click Down
    Sleep 50
    Click Up
    MouseMove, % mouse_x, mouse_y, 0
Return

#IfWinActive
