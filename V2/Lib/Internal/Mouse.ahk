; Directives
#Requires AutoHotkey v2.0

class Mouse {
    /**
     * @description `ClickWait()`
     * Moves the mouse to the specified coordinates and performs the specified number of clicks, then waits for the specified amount of time.
     * @param {(Number)} X
     * The x-coordinate to move the mouse to.
     * @param {(Number)} Y
     * The y-coordinate to move the mouse to.
     * @param {(Number)} Num
     * The number of clicks to perform. 0 will move the mouse without clicking.
     * @param {(Number)} Wait
     * The time to wait after performing the clicks, in milliseconds.
     * @returns {(String)}
     * Empty string is always returned.
     */
    static ClickWait(X, Y, Num, Wait) {
        Click(X, Y, Num)
        Sleep(Wait)
    }

    static FastClick(window, disableOnMove, startX, startY, allowedPositionVariance) {
        if WinActive(window) {
            ToolTip("Clicking")
            MouseGetPos(&currentX, &currentY)
            if (!disableOnMove) {
                Click("Down")
                Sleep(25)
                Click("Up")
                return
            } else if (abs(currentX - startX) < allowedPositionVariance and abs(currentY - startY) < allowedPositionVariance) {
                Click()
                return
            }
        }

        this.ToggleFastClick()
    }

    static ToggleFastClick(clickDelay := 1000, disableOnMove := false, allowedPositionVariance := 100) {
        ; Create static variables to track state and timer
        static active
        static FastClickTimer

        ; Instantiate active only on first invocation of the method
        if (!IsSet(active)) {
            active := false
        }

        ; Toggle to new state
        active := !active

        ; Create effect of new state.
        if (active) {
            Click() ; Click immediately on activation to avoid initial delay
            MouseGetPos(&startX, &startY, &window)
            fastClickTimer := ObjBindMethod(this, "FastClick", window, disableOnMove, startX, startY, allowedPositionVariance)
            SetTimer(fastClickTimer, clickDelay)
        } else {
            SetTimer(fastClickTimer, 0)
            ToolTip()
        }
    }
}
