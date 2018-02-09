; This ahk file contains my scripts that interact with the Windows Pandora Client.


; Functions used in this module
; ------------------------------------------------------------------------------
runPandoraMin() {
    ; Function to run then minimize Pandora.
    Run, pandora.exe, C:\Program Files (x86)\Pandora\
    Sleep, 2000
    WinMinimize, Pandora
}

pandoraCmd(command) {
    ; Function to pass command (param as string) to Pandora.
    IfWinExist, Pandora
        ControlSend, , %command%, Pandora
    else
        runPandoraMin()
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


; This hotkey resolves the "Connect" issue w/the Pandora desktop client.
+F11::  ; Shift-F11
    ifWinExist, Pandora
        WinClose, Pandora
        WinWaitClose, Pandora

    ifWinNotExist, Pandora
        runPandoraMin()
return


; This hotkey Maximizes or Minimize the Windows Pandora Client
^F11::  ; CTRL-F11
    ifWinNotExist, Pandora
        runPandoraMin()
    else
        IfWinActive, Pandora
            WinMinimize, Pandora
        else
            WinActivate, Pandora
return


; This hotkey closes the Windows Pandora Client
^!F11::  ; CTRL-ALT-F11
    ifWinExist, Pandora
        WinClose, Pandora
return


