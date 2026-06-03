; Directives
#Requires AutoHotkey v2.0

class Mouse {
    /**
     * @description `ClickWait()`
     * Moves the mouse, clicks x times and waits for the specified amount of time.
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

    /**
     * @description `_FastClick()`
     * Internal method for performing fast clicks. Not intended to be called directly. Use `ToggleFastClick()` instead.
     * @param {(String)} window
     * The window to check before clicking. If window is not active, the process will be terminated.
     * @param {(Boolean)} disableOnMove
     * Whether to disable fast clicking when the mouse is moved.
     * @param {(Number)} startX
     * The initial x-coordinate of the mouse.
     * @param {(Number)} startY
     * The initial y-coordinate of the mouse.
     * @param {(Number)} allowedPositionVariance
     * The allowed variance in position (by pixels) for the cursor before terminating the process. Only used when disableOnMove is set to true.
     * @param {(Number)} Wait
     * The time to wait after performing the click in ms. Must be at least 25ms.
     * @returns {(String)}
     * Empty string is always returned.
     */
    static _FastClick(window, disableOnMove, startX, startY, allowedPositionVariance) {
        ; Continue clicking only if the specified window is active
        continueClicking := WinActive(window)

        ; If disableOnMove is enabled, check if the mouse is still within the allowed variance from the starting position.
        if (continueClicking and disableOnMove) {
            MouseGetPos(&currentX, &currentY)
            continueClicking := (
                abs(currentX - startX) < allowedPositionVariance and
                abs(currentY - startY) < allowedPositionVariance
            )
        }

        ; If continueClicking is still true after the checks, perform the click. Otherwise, toggle fast clicking off.
        if (continueClicking) {
            ToolTip("Clicking")

            ; Do 3 part click (Down, Sleep, Up) to ensure the click registers. A single Click command may not register in some applications.
            Click("Down")
            Sleep(10)
            Click("Up")
        } else {
            this.ToggleFastClick()
        }
    }

    /**
     * @description `ToggleFastClick()`
     * Toggles fast clicking on or off.
     * @param {(Number)} clickDelay
     * The delay between clicks, in milliseconds.
     * Default is 100ms. Must be at least 25ms.
     * @param {(Boolean)} disableOnMove
     * Whether to disable fast clicking when the mouse is moved.
     * Default is false.
     * @param {(Number)} allowedPositionVariance
     * The allowed variance in position (by pixels) for the cursor before terminating the process. Only used when disableOnMove is set to true.
     * Default is 100 pixels.
     * @returns {(String)}
     * Empty string is always returned.
     */
    static ToggleFastClick(clickDelay := 100, disableOnMove := false, allowedPositionVariance := 100) {
        ; Create static variables to track state and timer
        static active
        static FastClickTimer
        static minClickDelay := 25

        if (clickDelay < minClickDelay) {
            throw ValueError("clickDelay must be at least " . minClickDelay . "ms.")
        }

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
            fastClickTimer := ObjBindMethod(this, "_FastClick", window, disableOnMove, startX, startY, allowedPositionVariance)
            SetTimer(fastClickTimer, clickDelay)
        } else {
            SetTimer(fastClickTimer, 0)
            ToolTip()
        }
    }
}
