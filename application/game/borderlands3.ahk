/*  Borderlands 3 AHK scripts
*/

#IfWinActive ahk_exe Borderlands3.exe ; Only run in Borderlands 2

press_while_held(TriggerKey, ResultKey, Delay) {
    Sleep, 500  ; Do not trigger on simple clicks - Only when held down
    while GetKeyState(TriggerKey, "P")
        Send, % ResultKey
        Sleep, % Delay

    return
}

; ~LButton::
;     press_while_held("LButton", "g", 2000)
; return

; This should always be at the bottom
#IfWinActive ; End #IfWinActive for Borderlands
