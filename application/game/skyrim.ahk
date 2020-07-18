class SkyrimInterface {
    __New() {
        This.running := 0
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

    ToggleSkill(skillTime, waitTime) {
        This.running := !(This.running)

        if (This.Running) {
            This.skillTime := skillTime
            This.waitTime := waitTime

            This.StartTimer()
        } else {
            This.StopTimer()
        }
    }

    useSkill() {
        Click, down
        Sleep, % This.skillTime
        Click, up
    }
}

#IfWinActive, ahk_exe SkyrimSE.exe

NumpadEnter::Send {Enter}
Numpad1::skyrim.UseSkill(1000, 2500)  ; Transmute
Numpad2::skyrim.UseSkill(10000, 15000)  ; Detect Life


#IfWinActive ; Disable previous active window
