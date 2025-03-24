#IfWinActive ahk_exe Increlution.exe

; ##Standard 1cook 1raw queue
gather_cook(trigger, sequence, count := 0) {
    MouseGetPos, X, Y
    i := 0
    Loop {
        for Key, Var in sequence {
            Y_temp := Y + (53 * Var)
            MouseMove, X, Y_Temp, 0
            Sleep, 1
            Click, right
            Sleep, 1
        }

        i += 1
        If ((count > 0 and i = count) or count = 0 and !GetKeyState(trigger, "p")) {
            break
        }
    }
    Return
}

XButton1::gather_cook("XButton1", [0, 2, 4])  ; herring, bread, cake
XButton2::gather_cook("XButton2", [0, 1], 20)

#IfWinActive
