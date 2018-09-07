#IfWinActive ahk_exe chrome.exe  ; Only run in Chrome

; Hotkey to open 10 items from my RSS reader with 1 key press. Works with Feedly
; Background Tab found here: HTTPS://chrome.google.com/webstore/detail/feedly-background-tab/gjlijkhcebalcchkhgaiflaooghmoegk?hl=en-US

open_comics(){
    /*  This function will open x comics in Feedly. When executed the next digit
        entered will provide x.
    */
    Input, num, L1 T3, {Tab}{Enter}{Space}
    If num is not Integer
        Return

    i := 0
    num := (num = 0 ? 10 : num) ; If input is 0 set val to 10
    While (i < num) {
        SendWait("j", 50)  ; "j" is the Feedly hotkey to open next item.
        SendWait(",", 50)  ; "," is my hotkey to open the open Feedly item in a new tab.
        i++
    }
}



^j::
    open_comics()
Return

#IfWinActive ; Clear IfWinActive
