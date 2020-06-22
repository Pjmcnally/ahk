; All of the items below are now obsolete due to PoE Trade Macro
; getItemName(str) {
;     /*  Items can be copied in PoE by mousing over and pressing ctrl-c. The
;         items name is always on the second line.

;         This function extracts the items name to be used in certain websites.
;     */

;     Array := StrSplit(str, "`r", "`n")
;     Return Array[2]
; }

; checkPoePrice() {
;     name := getItemName(clipboard)

;     Send, ^a
;     Send, % name
;     Send, {Enter}
; }

; #IfWinExist, ahk_exe PathOfExile_x64Steam.exe
; ^v::
;     if (WinActive("poe.ninja - Mozilla Firefox")
;         or WinActive("PoE Goods - Mozilla Firefox")
;         or WinActive("Trade - Path of Exile - Mozilla Firefox"))
;     {
;         checkPoePrice()
;     } else {
;         Send ^v
;     }
; #IfWinActive

#IfWinActive, ahk_exe PathOfExile_x64Steam.exe
^+r::  ; Ctrl-Shift-R
    run "Z:\Documents\Path of Building\POE-TradeMacro-2.16.0\Run_TradeMacro.ahk"
    run "Z:\Documents\Path of Building\POE-Trades-Companion-AHK-v-1-15-BETA_9991\POE Trades Companion.ahk"
Return

^h::
    Send {Enter}/hideout{Enter}
Return

^s::  ; Ctrl-S
    Input, var, T3 L1, {Space}{Tab}{Enter}
    Switch var {
        Case "c":
            clear_and_send("Currency")
        Case "d":
            clear_and_send("Divination")
        Case "e":
            clear_and_send("Essence")
        Case "g":
            clear_and_send("Gem")
        Case "m":
            clear_and_send("Magic")
        Case "o":
            clear_and_send("Tane's Laboratory")
        Case "p":
            clear_and_send("Prophecy")
        Case "r":
            clear_and_send("Rare")
        Case "s":
            clear_and_send("Seed")
        Case "u":
            clear_and_send("Unique")
        Case "v":
            clear_and_send("Veiled")
        Default:
            clear_and_send("Nothing Selected")
    }


#IfWinActive
