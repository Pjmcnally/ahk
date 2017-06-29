; This ahk file contains my scripts that interact with the Windows Pandora Client.

; This hotkey plays/pauses the Windows Pandora client
Media_Play_Pause:: ; Fn-F11 (The media play button on my bhip keyboard)
    IfWinExist, Pandora                   ; Check if Pandora Exists
        ControlSend, , {Space}, Pandora   ; Send Spacebar (Play/Pause)
    Else
        Run, pandora.exe, C:\Program Files (x86)\Pandora\
        Sleep, 10000
        WinMinimize, Pandora
Return

; This hotkey skips to the next sone on the Windows Pandora Client
Media_Next::  ; Fn-F12 (The media next button on my bhip keyboard)
    ifWinExist, Pandora                   ; Check if Pandora Exists
        ControlSend, , {Right}, Pandora   ; Send Right (Next Song)
    Else
        Run, pandora.exe, C:\Program Files (x86)\Pandora\
        Sleep, 10000
        WinMinimize, Pandora
Return

; This hotkey Runs/Maximizes/Minimize the Windows Pandora Client
^F11::  ; CTRL-F11 (The media play button on my bhip keyboard)
    ifWinNotExist, Pandora                ; Run Pandora if not running
        Run, pandora.exe, C:\Program Files (x86)\Pandora\
        Sleep, 10000
        WinMinimize, Pandora
    Else
        IfWinActive, Pandora              ; If Active
            WinMinimize, Pandora          ; Minimize
        else                              ; If not active
            WinActivate, Pandora          ; Activate
Return

; This hotkey closes the Windows Pandora Client
^!F11::  ; CTRL-ALT-F11 (The media play button on my bhip keyboard)
    ifWinExist, Pandora
        WinClose, Pandora
Return
