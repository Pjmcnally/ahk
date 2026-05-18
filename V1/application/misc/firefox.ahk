/*  Open items from my RSS reader (Feedly) with a hotkey.

    The items are each opened in a background tab using a firefox extension:
    https://addons.mozilla.org/en-US/firefox/addon/feedly_open_background_tab/
*/
#IfWinActive ahk_exe firefox.exe  ; Only run in Firefox


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
        SendWait("j", 50)  ; "j" is the Feedly hotkey to open next item.
        SendWait(";", 50)  ; ";" is my hotkey to open the open Feedly item in a new tab.
        i++
    }
}

open_inoreader_items(){
    /*  This function will open x comics in Feedly. When executed the next digit
        entered will provide x.
    */
    Input, num, L1 T3, {Tab}{Enter}{Space}
    If num is not Integer
        Return

    i := 0
    num := (num = 0 ? 10 : num) ; If input is 0 set val to 10
    While (i < num) {
        SendWait("n", 50)  ; "j" is the Feedly hotkey to open next item.
        SendWait("b", 50)  ; ";" is my hotkey to open the open Feedly item in a new tab.
        i++
    }
}


; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
; ^j::open_feedly_items()
^n::open_inoreader_items()


#IfWinActive ; Clear IfWinActive
