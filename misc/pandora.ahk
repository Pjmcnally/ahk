; I run Pandora on all of my computers. However, I run different
; versions depending on the computer. This set of hotkeys allows
; me to use a standard interface regardless of app or computer.

class PandoraInterface {
    SetVersion() {
        legacy_src := "C:\Program Files (x86)\Pandora\pandora.exe"
        winApp_src := "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Pandora\pandora.lnk"

        ; Test for Legacy version of Pandora Client and set config
        if (fileExist(legacy_src)) {
            This.Version := "Legacy"
            This.Source := legacy_src
            This.Window := "ahk_exe Pandora.exe"
            This.WaitInterval := 3000
        ; Test for winApp version of Pandora Client and set config
        } else if (FileExist(winApp_src)) {
            This.Version := "winApp"
            This.Source := winApp_src
            This.Window := "Pandora ahk_exe ApplicationFrameHost.exe"
            This.WaitInterval := 5000
        } else {
            MsgBox, % "Pandora not found. Unable to proceed."
        }
    }

    playPause() {
        if WinExist(This.Window) {
            if (This.Version = "Legacy") {
                ControlSend, , {Space}, % This.Window
            } else if This.Version = "winApp" {
                Send, {Media_Play_Pause}
            }
        } else {
            This.runMin()
        }
    }

    next() {
        if WinExist(This.Window) {
            if (This.Version = "Legacy") {
                ControlSend, , {Right}, % This.Window
            } else if This.Version = "winApp" {
                Send, {Media_Next}
            }
        } else {
            This.runMin()
        }
    }

    runMin() {
        ; Function to run then minimize Pandora.
        Run, % This.Source
        Sleep, % This.WaitInterval
        WinMinimize, % This.Window
    }

    kill() {
        if WinExist(This.Window) {
            WinClose, % This.Window
        }
    }

    minMax() {
        if (WinExist(This.Window) and WinActive(This.Window)) {
            WinMinimize, % This.Window
        } else if (WinExist(This.Window) and (!WinActive(This.Window))) {
            WinActivate, % This.Window
        } else {
            This.runMin()
        }
    }

    reset() {
        if WinExist(This.Window) {
            WinClose, % This.Window
            WinWaitClose, % This.Window
        }

        This.runMin()
    }
}

; Hotstrings in this module
; ------------------------------------------------------------------------------
; The Pandora object is instantiated in the Auto-Execution section of Core.ahk

; This hotkey plays/pauses the Windows Pandora client
F7::  ; F11
    pandora.playPause()
Return


; This hotkey skips to the next song on the Windows Pandora Client
F8::  ; F12
    pandora.Next()
Return


; This hotkey Maximizes or Minimize the Windows Pandora Client
^F7::  ; CTRL-F11
    pandora.minMax()
Return


; This hotkey resets (stops and starts) the Windows Pandora Client
+F7::  ; Shift-F11
    pandora.Reset()
Return


; This hotkey closes the Windows Pandora Client
^!F7::  ; CTRL-ALT-F11
    pandora.kill()
Return
