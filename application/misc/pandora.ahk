/*  Create standard hotkey interface for Pandora.

    I run Pandora on all of my computers. However, I run different versions
    depending on the computer. This set of hotkeys allows me to use a standard
    interface regardless of app or computer.
*/

; Classes
; ==============================================================================
class PandoraInterface {
    __New() {
        This.SetVersion()
    }

    SetVersion() {
        /*  Find and set version of Pandora on system.
        */
        legacy_src := "C:\Program Files (x86)\Pandora\pandora.exe"
        winApp_src := "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Pandora\pandora.lnk"

        ; Test for winApp version of Pandora Client and set config
        if (FileExist(winApp_src)) {
            This.Version := "winApp"
            This.Source := winApp_src
            This.Window := "Pandora ahk_exe ApplicationFrameHost.exe"
            This.WaitInterval := 5000
        ; Test for Legacy version of Pandora Client and set config
        } else if (fileExist(legacy_src)) {
            This.Version := "Legacy"
            This.Source := legacy_src
            This.Window := "ahk_exe Pandora.exe"
            This.WaitInterval := 3000
        } else {
            MsgBox, % "Pandora not found. Unable to proceed."
        }
    }

    playPause() {
        /*  Play or Pause current song.
        */
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
        /*  Skip current song.
        */
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
        /*  Run then minimize Pandora.
        */
        Run, % This.Source
        Sleep, % This.WaitInterval
        WinMinimize, % This.Window
    }

    kill() {
        /*  Kill the active Pandora window
        */
        if WinExist(This.Window) {
            WinClose, % This.Window
        }
    }

    minMax() {
        /*  Maximize or minimize the active Pandora window
        */
        if (WinExist(This.Window) and WinActive(This.Window)) {
            WinMinimize, % This.Window
        } else if (WinExist(This.Window) and (!WinActive(This.Window))) {
            WinActivate, % This.Window
        } else {
            This.runMin()
        }
    }

    reset() {
        /*  Kill and then restart the active Pandora window
        */
        if WinExist(This.Window) {
            WinClose, % This.Window
            WinWaitClose, % This.Window
        }

        This.runMin()
    }
}

; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
; The Pandora object is instantiated in the Auto-Execution section of Core.ahk
  F7::pandora.playPause()   ; Plays/Pause the current song in the Pandora client
  F8::pandora.Next()        ; Skip to current song in the Pandora Client
 ^F7::pandora.minMax()      ; Maximize or Minimize the Pandora Client
 +F7::pandora.Reset()       ; Reset (stops and starts) the Pandora Client
^!F7::pandora.kill()        ; Close the Pandora Client
