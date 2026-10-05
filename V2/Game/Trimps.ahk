#Requires AutoHotkey v2.0

; TODO: Document and clean up this file
SaveTrimps() {
    trimpsSaveWindow := "Save As ahk_exe Trimps.exe"
    if WinExist(trimpsSaveWindow) {
        WinActivate(trimpsSaveWindow)
        if (WinWaitActive(trimpsSaveWindow, , 5)) {
            Send("!s") ; Hotkey to save file and close "Save As" window
        }
    }
}

ToggleTrimpsSave() {
    static toggleActive := false

    ; Flip Toggle Status
    toggleActive := !toggleActive

    if (toggleActive) {
        SetTimer(SaveTrimps, 1000)
        ToolTip("Saving Trimps", 0, 0)
    } else {
        ; Clear Timer and ToolTip.
        SetTimer(SaveTrimps, 0)
        ToolTip()
    }
}

#HotIf WinActive("ahk_exe Trimps.exe")

^!F1::ToggleTrimpsSave()

#HotIf
