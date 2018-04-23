#IfWinActive ahk_exe chrome.exe  ; Only run in Chrome

; Hotkey to open 10 ites from my rss reader with 1 keypress. Works with Feedly
; Background Tab found here: https://chrome.google.com/webstore/detail/feedly-background-tab/gjlijkhcebalcchkhgaiflaooghmoegk?hl=en-US

open_comics(){
    /*  This function will open x comics in Feedly. When executed the next digit
        entered will provide x.
    */
    Input, num, L1 T3, {Tab}{Enter}{Space}
    If num is not Integer
        return

    i := 0
    num := (num = 0 ? 10 : num) ; If input is 0 set val to 10
    While (i < num) {
        Send, j  ; "j" is the Feedly hotkey to open next item.
        Sleep, 50
        Send, ,  ; "," is my hotkey to open the open Feedly item in a new tab.
        Sleep, 50
        i++
    }
}



^j::
    open_comics()
return

#IfWinActive ; Clear IfWinActive

