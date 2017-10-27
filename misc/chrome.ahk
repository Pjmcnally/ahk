#IfWinActive ahk_exe chrome.exe  ; Only run in Chrome

; Hotkey to open 10 ites from my rss reader with 1 keypress. Works with Feedly
; Background Tab found here: https://chrome.google.com/webstore/detail/feedly-background-tab/gjlijkhcebalcchkhgaiflaooghmoegk?hl=en-US
^j::
    ; j is a hotkey in Feedly to open next item
    ; , is my hotkey to open the currently open item in a new background tab.
    Input, OutVar, L2 T5, {Tab}{Enter}{Space}
    i := 0
    While (i < OutVar) {
        Send, j,
        Sleep, 50
        i++
    }
Return

#IfWinActive ; Clear IfWinActive
