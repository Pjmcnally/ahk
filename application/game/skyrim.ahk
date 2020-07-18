class SkyrimInterface {
    __New() {
        This.running := 0
        This.CurrentSkill := ""
        This.skillTime := 1000
        This.waitTime := 1000
        This.Timer := ObjBindMethod(this, "UseSkill")
    }

    StartTimer() {
        timer := this.Timer  ; Not sure why this line is necessary but it is.
        SetTimer, % timer, % this.waitTime,
    }

    StopTimer() {
        timer := this.Timer
        setTimer, % timer, OFF  ; Turn off timer
    }

    ToggleSkill(skillName, skillTime, waitTime) {
        if (skillName != this.CurrentSkill) {
            This.StopTime()  ; Kill old time

            This.skillTime := skillTime
            This.waitTime := waitTime
            This.CurrentSkill := skillName

            This.Running := True
            This.UseSkill()
            This.StartTimer()
        } else if (This.Running) {
            This.Running := False
            This.StopTimer()
        } else {
            This.Running := True
            This.UseSkill()
            This.StartTimer()
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
Numpad1::skyrim.ToggleSkill("Transmute", 1000, 2500)
Numpad2::skyrim.ToggleSkill("Detect Life", 18000, 15000)


#IfWinActive ; Disable previous active window
