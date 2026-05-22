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
}
