#IfWinActive ahk_exe chrome.exe  ; Only run in Chrome

; Hotkey to open 10 ites from my rss reader with 1 keypress. Works with Feedly
; Background Tab found here: https://chrome.google.com/webstore/detail/feedly-background-tab/gjlijkhcebalcchkhgaiflaooghmoegk?hl=en-US
^j::
    Input, OutVar, L1 T3, {Tab}{Enter}{Space}
    If OutVar is not Integer
        Return

    i := 0
    While (i < OutVar) {
        Send, j  ; "j" is the Feedly hotkey to open next item.
        Send, ,  ; "," is my hotkey to open the open Feedly item in a new tab.
        Sleep, 50
        i++
    }
Return

#IfWinActive ; Clear IfWinActive
