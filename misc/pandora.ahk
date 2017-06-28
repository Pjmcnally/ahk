; This ahk file contains my scripts that interact with the Windows Pandora Client.

; Media Buttons
Media_Play_Pause::
    IfWinExist, Pandora                   ; Check if Pandora Exists
        ControlSend, , {Space}, Pandora   ; Send Spacebar (Play/Pause)
    Else
        Run, pandora.exe, C:\Program Files (x86)\Pandora\
Return

Media_Next::
    ifWinExist, Pandora                   ; Check if Pandora Exists
        ControlSend, , {Right}, Pandora   ; Send Right (Next Song)
    Else
        Run, pandora.exe, C:\Program Files (x86)\Pandora\
Return

^F11::
    ifWinNotExist, Pandora                ; Run Pandora if not running
        Run, pandora.exe, C:\Program Files (x86)\Pandora\
    Else
        IfWinActive, Pandora              ; If Active
            WinMinimize, Pandora          ; Minimize
        else                              ; If not active
            WinActivate, Pandora          ; Activate
Return

