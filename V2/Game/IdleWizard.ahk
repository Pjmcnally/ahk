#Requires AutoHotkey v2.0

; TODO: Document and clean up this file
;@region Hotkeys
#HotIf WinActive("ahk_exe IdleWizard.exe")

F1:: {
    while(true) {
        ControlSend("b", , "ahk_exe IdleWizard.exe")
        Sleep(250)
        ControlSend("{Up}", , "ahk_exe IdleWizard.exe")
        Sleep(250)
        ; ControlClick("X1245 Y890", "ahk_exe IdleWizard.exe")
        ; Sleep(250)
    }
}

Up:: {
    Keyboard.SendWait("{Up}", 25)
    Keyboard.SendWait("b", 25)
}

#HotIf
;@endRegion
