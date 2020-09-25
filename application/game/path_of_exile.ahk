class PoEInterface {
    __New() {
        this.LastActive := 0
        this.Active := false
        this.FlaskList := [1, 2, 3, 4]
        this.ActiveDelay := 2000  ; Milliseconds
    }

    getCharActive() {
        return  GetKeyState("LButton")
            || this.Active
            || (A_TickCount - this.LastActive) < this.ActiveDelay
    }

    activateRightClick() {
        ; capture when the last attack (Right click) was done
        ; we also track if the mouse button is being held down for continuous attack(s) and/or channelling skills
        this.Active := true
    }

    deactivateRightClick() {
        this.Active := false
        this.lastActive := A_TickCount
    }

    useFlasks() {
        if (this.getCharActive()) {
            for flask in this.FlaskList {
                Send, % flask
                Random, variableDelay, -99, 99
                Sleep, % variableDelay
            }
        } else {
            Send, f
        }
    }

    logout() {
        SendInput, {Enter}/exit{Enter}
    }

    clickRepeat() {
        while GetKeyState("control") {
            Random delay, 100, 150
            Sleep, % delay
            Click
        }
    }

    searchStash() {
        Input, var, T3 L1, {Space}{Tab}{Enter}
        Switch var {
            Case "a":
                clear_and_send("Map")
            Case "c":
                clear_and_send("Currency")
            Case "d":
                clear_and_send("Divination")
            Case "e":
                clear_and_send("Essence")
            Case "g":
                clear_and_send("Gem")
            Case "h":
                clear_and_send("Heist")
            Case "m":
                clear_and_send("Magic")
            Case "n":
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
    }

    enterHideout() {
        Send {Enter}/hideout{Enter}
    }

    checkMap() {
        badMods := ["Monsters reflect \d{2}. of Physical", "Players cannot Regenerate Life, Mana or Energy Shield", "Unidentified"]
        modsFound := ""

        if (InStr(Clipboard, "Map Tier")) {
            for index, mod in badMods {
                if RegExMatch(Clipboard, mod) {
                    modsFound := modsFound . mod . "`r`n"
                }
            }

            if (StrLen(modsFound)) {
                MsgBox, % "Beware, map contains bad mod(s)." . "`r`n`r`n" . modsFound
            }
        }
    }
}

#IfWinActive, ahk_exe PathOfExile_x64Steam.exe
^+r::  ; Ctrl-Shift-R
    run "Z:\Documents\Path of Building\POE-TradeMacro-2.16.0\Run_TradeMacro.ahk"
    run "Z:\Documents\Path of Building\POE-Trades-Companion-AHK-v-1-15-BETA_9991\POE Trades Companion.ahk"
Return

F9::poe.logout()
^h::poe.enterHideout()
^s::poe.searchStash()
^z::poe.clickRepeat()
~^c::poe.checkMap()

; Flask Macro hotkeys
~RButton::poe.activateRightClick()  ; pass-thru and call class method
~RButton up::poe.deactivateRightClick()  ; pass-thru and call class method
f::poe.useFlasks()
#IfWinActive
