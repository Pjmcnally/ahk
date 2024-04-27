class MelvorInterface {
    __New() {
        CoordMode, Pixel, Client
        CoordMode, Mouse, Client
        this.MouseX := 0
        this.MouseY := 0

        this.disableOnMove := true
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
        MouseGetPos, x, y
        if (!this.disableOnMove) or (this.disableOnMove and x = this.MouseX and y = this.MouseY) {
            Click
        } else {
            this.ToggleFastClick(false)
        }

    }

    ToggleFastClick(disableOnMove, clickDelay) {
        this.disableOnMove := disableOnMove
        timer := this.FastClickTimer  ; Not sure why this line is necessary but it is.

        if (this.FastClickActive) {
            ; deactivate timer
            SetTimer, % timer, OFF,
        } else {
            MouseGetPos, tempX, tempY
            this.MouseX := tempX
            this.MouseY := tempY
            this.FastClick()  ; Trigger immediately

            ; Activate timer
            SetTimer, % timer, % clickDelay,
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
^Space::melvor.ToggleFastClick(true, 1000)
^!Space::melvor.ToggleFastClick(false, 1000)

^g::Send, % "game.gp.add()"
^i::Send, % "game.bank.addItemByID('" . Trim(CLIPBOARD) . "', , true, true, false){Left 20}"
^p::Send, % "game.petManager.unlockPetByID('" . Trim(CLIPBOARD) . "');"
^t::Send, % "game.testForOffline(){Left 1}"
#IfWinActive ; End #IfWinActive

/*
For discovering marks
for (let i = 0; i < 61; i += 1) {game.summoning.discoverMark(game.summoning.actions.getObjectByID('melvorTotH:LightningSpirit'));}
*/
