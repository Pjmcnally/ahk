/*  Open items from my RSS reader (Feedly) with a hotkey.

    The items are each opened in a background tab using a chrome extension:
    https://chrome.google.com/webstore/detail/feedly-background-tab/gjlijkhcebalcchkhgaiflaooghmoegk?hl=en-US
*/
#IfWinActive ahk_exe chrome.exe  ; Only run in Chrome


; Functions
; ==============================================================================
open_feedly_items(){
    /*  This function will open x comics in Feedly. When executed the next digit
        entered will provide x.
    */
    Input, num, L1 T3, {Tab}{Enter}{Space}
    If num is not Integer
        Return

    i := 0
    num := (num = 0 ? 10 : num) ; If input is 0 set val to 10
    While (i < num) {
        SendWait("j", 150)  ; "j" is the Feedly hotkey to open next item.
        SendWait(",", 150)  ; "," is my hotkey to open the open Feedly item in a new tab.
        i++
    }
}


; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
^j::open_feedly_items()


#IfWinActive ; Clear IfWinActive
