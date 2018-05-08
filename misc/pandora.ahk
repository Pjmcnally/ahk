; I run pandora on all of my computers. However, I run differnt
; versions depending on the computer. This set of hotkeys allows
; me to use a standard interface regardless of app or computer.

class PandoraInterface {
    SetVersion() {
        legacy_src := "C:\Program Files (x86)\Pandora\pandora.exe"
        winapp_src := "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Pandora\pandora.lnk"

        ; Test for Legacy version of Pandora Client and set config
        if (fileExist(legacy_src)) {
            This.Version := "Legacy"
            This.Source := legacy_src
            This.Window := "ahk_exe Pandora.exe"
            This.Wait := 3000
        ; Test for WinApp version of Pandora Client and set config
        } else if (FileExist(winapp_src)) {
            This.Version := "WinApp"
            This.Source := winapp_src
            This.Window := "Pandora ahk_exe ApplicationFrameHost.exe"
            This.Wait := 5000
        } else {
            MsgBox, % "Pandora not found. Unable to proceed."
        }
    }

    playPause() {
        if WinExist(This.Window) {
            if (This.Version = "Legacy") {
                ControlSend, , {Space}, % This.Window
            } else if This.Version = "WinApp" {
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
            } else if This.Version = "WinApp" {
                Send, {Media_Next}
            }
        } else {
            This.runMin()
        }
    }

    runMin() {
        ; Function to run then minimize Pandora.
        Run, % This.Source
        Sleep, % This.Wait
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

; Functions in this module
; ------------------------------------------------------------------------------
PandoraPlay() {
    pandora := new PandoraInterface
    pandora.SetVersion()
    pandora.playPause()
}

PandoraNext() {
    pandora := new PandoraInterface
    pandora.SetVersion()
    pandora.Next()
}

PandoraMinMax() {
    pandora := new PandoraInterface
    pandora.SetVersion()
    pandora.minMax()
}

PandoraReset() {
    pandora := new PandoraInterface
    pandora.SetVersion()
    pandora.Reset()
}

PandoraClose() {
    pandora := new PandoraInterface
    pandora.SetVersion()
    pandora.kill()
}

; Hotstrings in this module
; ------------------------------------------------------------------------------
; This hotkey plays/pauses the Windows Pandora client
F11::  ; F11
    PandoraPlay()
return


; This hotkey skips to the next song on the Windows Pandora Client
F12::  ; F12
    PandoraNext()
return


; This hotkey Maximizes or Minimize the Windows Pandora Client
^F11::  ; CTRL-F11
    PandoraMinMax()
return


; This hotkey Maximizes or Minimize the Windows Pandora Client
+F11::  ; Shift-F11
    PandoraReset()
return


; This hotkey closes the Windows Pandora Client
^!F11::  ; CTRL-ALT-F11
    PandoraClose()
return
