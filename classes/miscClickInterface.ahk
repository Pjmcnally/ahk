class MiscClickInterface {
    __New(window) {
        CoordMode, Pixel, Client
        CoordMode, Mouse, Client
        this.MouseX := 0
        this.MouseY := 0
        this.allowedPositionVarience := 0
        this.window := window

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
        if WinActive(this.window) {
            MouseGetPos, x, y
            if (!this.disableOnMove) {
                Click, Right
                return
            } else if (abs(x - this.MouseX) < this.allowedPositionVarience and abs(y - this.MouseY) < this.allowedPositionVarience) {
                Click, Right
                return
            }
        }

        this.ToggleFastClick(false)
    }

    ToggleFastClick(disableOnMove, clickDelay := 1000, allowedPositionVarience := 100) {
        if (this.FastClickActive) {
            this.DeactivateFastClick()
        } else {
            this.ActivateFastClick(disableOnMove, clickDelay, allowedPositionVarience)
        }
    }

    ActivateFastClick(disableOnMove, clickDelay, allowedPositionVarience) {
        this.FastClickActive := true
        this.disableOnMove := disableOnMove

        MouseGetPos, tempX, tempY
        this.MouseX := tempX
        this.MouseY := tempY
        this.allowedPositionVarience := allowedPositionVarience
        Click, Right

        ; Activate timer
        timer := this.FastClickTimer  ; Not sure why this line is necessary but it is.
        SetTimer, % timer, % clickDelay,
    }

    DeactivateFastClick() {
        this.FastClickActive := false

        ; deactivate timer
        timer := this.FastClickTimer  ; Not sure why this line is necessary but it is.
        SetTimer, % timer, OFF,
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
