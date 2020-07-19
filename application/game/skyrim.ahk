class SkyrimInterface {
    __New() {
        This.CurrentSkill := ""
        This.skillTime := 0
        This.waitTime := 0
        This.running := 0
        This.Timer := ObjBindMethod(this, "UseSkill")
    }

    StartLoop() {
        This.Running := True

        timer := this.Timer  ; Not sure why this line is necessary but it is.
        freq := This.WaitTime + This.SkillTime  ; Calculate total time for loop

        SetTimer, % timer, % freq,
        This.UseSkill()
    }

    StopLoop() {
        This.Running := False

        timer := this.Timer
        setTimer, % timer, OFF  ; Turn off timer
    }

    ToggleSkill(skillName, skillTime, waitTime) {
        if (skillName != this.CurrentSkill) {
            This.StopLoop()  ; Kill old time

            This.SkillTime := skillTime
            This.WaitTime := waitTime
            This.CurrentSkill := skillName

            This.StartLoop()
        } else if (This.Running) {
            This.StopLoop()
        } else {
            This.StartLoop()
        }
    }

    UseSkill() {
        Click, down
        Sleep, % This.skillTime
        Click, up
    }
}

#IfWinActive, ahk_exe SkyrimSE.exe

NumpadEnter::Send {Enter}
Numpad1::skyrim.ToggleSkill("Transmute", 1000, 1000)
Numpad2::skyrim.ToggleSkill("Detect Life", 30000, 100)
Numpad3::skyrim.ToggleSkill("Muffle", 1000, 1000)


#IfWinActive ; Disable previous active window
