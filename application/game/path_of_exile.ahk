logout() {
    /* This is the older version. Potentially against the macro rules
    BlockInput On
    SendInput, {Esc}
    WinGetPos,,,Width,Height,A
    X := (Width / 2)
    Y := Height * .44
    MouseClick, Left, X, Y, 1, 1
    BlockInput Off
    */

    SendInput, {Enter}/exit{Enter}
}

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
        Case "N":
            clear_and_send("Normal")
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
Return

F9::logout()

#IfWinActive
