#Requires AutoHotkey v2.0

class Keyboard {
    /**
     * @description `SendWait()`
     * Transmits keystrokes to the system using defined SendMode (SendInput by default).
     * Keys can either be transmitted in normal or literal mode.
     * @param {(String)} Keys
     * The keystrokes to send.
     * @param {(Number)} wait
     * The time to wait after sending the keystrokes, in milliseconds.
     * @param {(Boolean)} literal
     * Whether to send the keystrokes literally. If `true`, the keystrokes will be sent as raw text.
     * If `false`, the keystrokes will be sent as normal. Some symbols have special meanings in normal mode and will be interpreted as such.
     * For example, `!` will be interpreted as the Alt key, `^` will be interpreted as the Control key, and `+` will be interpreted as the Shift key.
     * @returns {(String)}
     * Empty string is always returned.
     */
    static SendWait(Keys, wait, literal:=false) {
        if literal {
            SendText(Keys)
        } else {
            Send(Keys)
        }

        Sleep(wait)
    }
}
