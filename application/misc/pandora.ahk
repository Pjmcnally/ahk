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

        ; Because Pandora is now a Windows 10 App it cannot be run by just accessing the
        ; exe. To resolve this issue create a shortcut and add that shortcut to the
        ; start menu using the path below. To create the shortcut do the following:
        ; 1. Windows + R
        ; 2. Enter: shell:AppsFolder
        ; 3. Right click Pandora and click Create Shortcut
        ; 4. Create folder and copy shortcut to folder
        winApp_src := "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Pandora\Pandora.lnk"

        if (FileExist(winApp_src)) {
            ; Set general attributes
            This.Version := "winApp"
            This.Source := winApp_src
            This.Window := "ahk_exe Pandora.exe"

            ; Set wait times
            This.SmallWait := 1000
            This.BigWait := 4000

            ; Set positions and size attributes
            ; This.x -= 7  ; This solves invisible padding on the window.
            This.x := This.getSysTopLeft()
            This.y := 0
            This.Height := 585
            This.Width := 500
        } else {
            MsgBox, % "Pandora not found. Unable to proceed."
        }
    }

    getSysTopLeft() {
        ; Get count of monitors
        SysGet, num_mons, MonitorCount

        ; Loop over monitors. Find left most monitor.
        x_coords := Array()
        Loop, % num_mons {
            SysGet, coords, MonitorWorkArea, % A_Index
            x_coords.push(coordsLeft)
        }

        Return Min(x_coords*)
    }

    playPause() {
        /*  Play or Pause current song.
        */
        if WinExist(This.Window) {
            Send, {Media_Play_Pause}
            This.setPos()
        } else {
            This.runMin()
        }
    }

    next() {
        /*  Skip current song.
        */
        if WinExist(This.Window) {
            Send, {Media_Next}
            This.setPos()
        } else {
            This.runMin()
        }
    }

    runMin() {
        /*  Run then minimize Pandora.
        */
        Run, % This.Source

        ; Set window position and minimize
        Sleep, % This.SmallWait
        This.SetPos()
        WinMinimize, % This.Window

        ; Start music
        Sleep, % This.BigWait
        This.playPause()
    }

    setPos() {
        WinGetPos, tempX, tempY, tempW, tempH, % This.Window
        if (tempX != This.x or tempY != this.y or tempW != this.Width or tempH != This.Height) {
            WinMove, % This.Window, , % This.x, This.y, This.Width, This.Height
        }
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
            This.SetPos()
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
