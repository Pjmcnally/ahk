class DungeonEncountersInterface {
    __New() {
        this.AutoBattle := false
        This.Timer := ObjBindMethod(this, "AutoBattleGo")
    }

    AutoBattleToggle() {
        (this.AutoBattle) ? this.AutoBattleStop() : this.AutoBattleStart()
    }

    AutoBattleStart() {
        this.AutoBattle := True
        this.AutoBattleGo()  ; Trigger immediately

        ; Activate timer
        timer := this.Timer  ; Not sure why this line is necessary but it is.
        SetTimer, % timer, 100,
    }

    AutoBattleStop() {
        this.AutoBattle := false

        ; Deactivate time
        timer := this.Timer
        setTimer, % timer, OFF
    }

    AutoBattleGo() {
        if (WinActive("DUNGEON ENCOUNTERS")) {
            Send, {Return}
        }
    }
}

#IfWinActive, ahk_exe DUNGEON ENCOUNTERS.exe
Space::de.AutoBattleToggle()

#IfWinActive
