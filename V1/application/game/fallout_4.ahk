#IfWinActive, ahk_exe Fallout4.exe

; I have no idea what this does or why I made it.
; t::
;     Send {Enter down}
;     Sleep 25
;     Send {Enter up}
; Return

/* This is to fix the annoying way "Esc" works in Fallout 4. In most menus and the
Pip-Boy escape will not exit the current menu but will instead bring up the Pause menu.

This is counter intuitive and frustrating. To fix this I re-bound the Pause hotkey (I
used "F9" - The "Load" button near escape on my keyboard). I then created this hotkey to
hit both Escape and Tab when Escape is pressed
*/
GetRobotParts() {
    delay := 100
    robotParts := ["player.AddItem 00106D98 6", "player.AddItem 0006907B 6", "player.AddItem 000AEC5E 9", "player.AddItem 0006907A 11", "player.AddItem 001BF72E 8"]
    for key, val in robotParts {
        Paste_contents(val)
        KeyWait Return, D
        Sleep 100
    }

    return
}


~Escape::Tab
; ^r::GetRobotParts()

#IfWinActive
