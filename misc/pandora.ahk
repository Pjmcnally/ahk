; This ahk file contains my scripts that interact with the Windows Pandora Client.


; Functions used in this module
; ------------------------------------------------------------------------------
runPandoraMin() {
    ; Function to run then minimize Pandora.
    Run, % "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Pandora\pandora"
    Sleep, 5000
    WinMinimize, Pandora
}

pandoraCmd(command) {
    ; Function to pass command (param as string) to Pandora.
    IfWinExist, Pandora
        Send, % command
    else
        runPandoraMin()
}


; Hotstrings in this module
; ------------------------------------------------------------------------------
; This hotkey plays/pauses the Windows Pandora client
F11::  ; F11 - Same as "Media Play" on my BHIP Keyboard
    pandoraCmd("{Media_Play_Pause}")  ; Send {Space} to Pandora (Pause/Play)
return


; This hotkey skips to the next song on the Windows Pandora Client
F12::  ; F12 - Same as "Media Next" on my BHIP Keyboard
    pandoraCmd("{Media_Next}")  ; Send {Right} to Pandora (Next track)
return

; This hotkey Maximizes or Minimize the Windows Pandora Client
^F11::  ; CTRL-F11
    ifWinNotExist, Pandora
        runPandoraMin()
    else
        IfWinActive, Pandora
            WinMinimize, Pandora
        else
            ; WinActivate isn't working but re-running the program does.
            Run, % "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Pandora\pandora"
return


; This hotkey closes the Windows Pandora Client
^!F11::  ; CTRL-ALT-F11
    ifWinExist, Pandora
        WinClose, Pandora
return


; ; Reset Pandora Client. This resolves the "Connect" issue.
; ; I believe this is now obsolete with the new Pandora app. Testing currently.
; +F11::  ; Shift-F11
;     ifWinExist, Pandora
;         WinClose, Pandora
;         WinWaitClose, Pandora

;     ifWinNotExist, Pandora
;         runPandoraMin()
; return
