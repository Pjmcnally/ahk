; This ahk file contains my scripts that interact with the Windows Pandora Client.


; Functions used in this module
; ------------------------------------------------------------------------------
runPandoraMin() {
    ; Function to run then minimize Pandora.
    Run, % "C:\Program Files (x86)\Pandora\pandora.exe"
    Sleep, 2000
    WinMinimize, Pandora
}

pandoraCmd(command) {
    ; Function to pass command (param as string) to Pandora.
    if WinExist("ahk_exe Pandora.exe") {
        ControlSend, , %command%, Pandora
    } else {
        runPandoraMin()
    }
}

resetPandora() {
    pandora := "ahk_exe Pandora.exe"
    if WinExist(pandora) {
        WinClose, % pandora
        WinWaitClose, % pandora
    }

    runPandoraMin()
}

closeWindow(window) {
    if WinExist(window) {
        WinClose, % window
    }
}


minMaxWindow(window) {
    if (WinExist(window) and WinActive(window)) {
        WinMinimize, % window
    } else if (WinExist(window) and (!WinActive(window))) {
        WinActivate, % window
    } else {
        runPandoraMin()
    }
}


; Hotstrings in this module
; ------------------------------------------------------------------------------

; This hotkey plays/pauses the Windows Pandora client
F11::  ; F11 - Same as "Media Play" on my BHIP Keyboard
    pandoraCmd("{Space}")  ; Send {Space} to Pandora (Pause/Play)
return


; This hotkey skips to the next song on the Windows Pandora Client
F12::  ; F12 - Same as "Media Next" on my BHIP Keyboard
    pandoraCmd("{Right}")  ; Send {Right} to Pandora (Next track)
return


; Reset Pandora Client. This resolves the "Connect" issue.
+F11::  ; Shift-F11
    resetPandora()
return


; This hotkey Maximizes or Minimize the Windows Pandora Client
^F11::  ; CTRL-F11
    minMaxWindow("ahk_exe Pandora.exe")
return


; This hotkey closes the Windows Pandora Client
^!F11::  ; CTRL-ALT-F11
    closeWindow("ahk_exe Pandora.exe")
return



