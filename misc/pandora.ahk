; This ahk file contains my scripts that interact with the Windows Pandora Client.

; ------------------------------------------------------------------------------
; Functions used in this module

runPandoraMin() {
    Run, pandora.exe, C:\Program Files (x86)\Pandora\
    Sleep, 1000
    WinMinimize, Pandora
}

pandoraCmd(command) {
    IfWinExist, Pandora                     ; Check if Pandora Exists
        ControlSend, , %command%, Pandora   ; Send command
    Else
        runPandoraMin()                     ; Run and minimize Pandora
}


; ------------------------------------------------------------------------------
; Hotstrings in this module

; This hotkey plays/pauses the Windows Pandora client
F11::                                       ; For laptop compatibility (No media keys)
Media_Play_Pause::                          ; Fn-F11 (The media play button on my bhip keyboard)
    pandoraCmd("{Space}")                   ; Send {Space} to Pandora (Pause/Play)
Return

; This hotkey skips to the next song on the Windows Pandora Client
F12::                                       ; For laptop compatibility (No media keys)
Media_Next::                                ; Fn-F12 (The media next button on my bhip keyboard)
    pandoraCmd("{Right}")                   ; Send {Right} to Pandora (Next track)
Return

; This hotkey Runs/Maximizes/Minimize the Windows Pandora Client
^F11::                                      ; CTRL-F11 (The media play button on my bhip keyboard)
    ifWinNotExist, Pandora                  ; Run Pandora if not running
        runPandoraMin()

    Else
        IfWinActive, Pandora                ; If Active
            WinMinimize, Pandora            ; Minimize
        else                                ; If not active
            WinActivate, Pandora            ; Activate
Return

; This hotkey closes the Windows Pandora Client
^!F11::  ; CTRL-ALT-F11 (The media play button on my bhip keyboard)
    ifWinExist, Pandora
        WinClose, Pandora
Return


