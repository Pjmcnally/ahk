; This ahk file contains my scripts that interact with the Windows Pandora Client.


; Functions used in this module
; ------------------------------------------------------------------------------
runPandoraMin() {
    ; Function to run then minimize Pandora.
    pandora := "Pandora ahk_exe ApplicationFrameHost.exe"
    pandora_src := "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Pandora\pandora"

    Run, % pandora_src
    Sleep, 5000
    WinMinimize, % pandora
}

pandoraCmd(command) {
    ; Function to pass command (param as string) to Pandora.
    pandora := "Pandora ahk_exe ApplicationFrameHost.exe"

    If WinExist(pandora) {
        Send, % command
    } else {
        runPandoraMin()
    }
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
    pandoraCmd("{Media_Play_Pause}")  ; Send {Space} to Pandora (Pause/Play)
return


; This hotkey skips to the next song on the Windows Pandora Client
F12::  ; F12 - Same as "Media Next" on my BHIP Keyboard
    pandoraCmd("{Media_Next}")  ; Send {Right} to Pandora (Next track)
return


; This hotkey Maximizes or Minimize the Windows Pandora Client
^F11::  ; CTRL-F11
    minMaxWindow("Pandora ahk_exe ApplicationFrameHost.exe")
return


; This hotkey closes the Windows Pandora Client
^!F11::  ; CTRL-ALT-F11
    closeWindow("Pandora ahk_exe ApplicationFrameHost.exe")
return
