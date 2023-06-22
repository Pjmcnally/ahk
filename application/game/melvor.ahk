; This file has been rendered obsolete by mods. They do the job better and don't take
; all computer inputs while doing it.

class MelvorInterface {
    __New() {
        CoordMode, Pixel, Client
        CoordMode, Mouse, Client

        this.FastClickActive := false
        this.FastClickTimer := ObjBindMethod(this, "FastClick")
    }

    KeepAwake() {
        while (true) {
            Random, x, 500, 1000
            MouseMove, x, x
            Sleep, 10000
        }
    }

    FastClick() {
        Click
    }

    ToggleFastClick() {
        timer := this.FastClickTimer  ; Not sure why this line is necessary but it is.

        if (this.FastClickActive) {
            ; deactivate timer
            SetTimer, % timer, OFF,
        } else {
            this.FastClick()  ; Trigger immediately

            ; Activate timer
            SetTimer, % timer, % 10,
        }

        ; Update FastClickActive to its opposite
        this.FastClickActive := !this.FastClickActive
    }

    RandomClick() {
        MouseGetPos x, y

        While (True) {
            MouseMove x + 20, y + 20
            Sleep, 1000

            MouseMove x, y
            Click
            Sleep 10000
        }
    }
}


#IfWinActive, Melvor Idle
^1::melvor.KeepAwake()
^2::melvor.RandomClick()
^Space::melvor.ToggleFastClick()

^i::Send, % "game.bank.addItemByID("""", , true, true, false)"
^g::Send, % "game.gp.add()"
#IfWinActive ; End #IfWinActive
