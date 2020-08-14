/*  Tool to help process of updating FIP passwords
*/


; AutoExecute Section
; ==============================================================================
#SingleInstance, force  ; Set Single instance to prevent concurrent execution
_gui := New FipPwToolInterface
Return  ; End AutoExecute


; Classes
; ==============================================================================
class FipPwToolInterface {
    __New() {
        /*  Create new FipPwToolInterface Instance, build and display GUI.
        */
        This.Version := "0.5.0"
        This.Title := "FIP PW Reset Tool"
        This.Title_str := Format("{1}  v{2}", This.Title, This.version)
        This.CurrentAttempt := 0
        This.BuildGui()
    }

    BuildGui() {
        /*  Build Gui.
        */
        ; I don't like the global but I can't get it to work any other way. These
        ; globals refer to Gui items that need global references to be read or updated.
        Global CurrentAttemptDisplay
        Global PasswordTextBox

        Gui, tool_gui:New, +AlwaysOnTop, % This.title_str
        Gui, tool_gui:Font, s12
        Gui, tool_gui:Add, Text, x10 y20, Password:
        Gui, tool_gui:Add, Edit, x85 y15 w205 vPasswordTextBox
        Gui, tool_gui:Font, s100
        Gui, tool_gui:Add, Text, x110 y70 vCurrentAttemptDisplay, % This.CurrentAttempt
        Gui, tool_gui:Font, s12
        Gui, tool_gui:Add, Button, Default x80 y130 w20 gDecreaseValue, -
        Gui, tool_gui:Add, Button, Default x200 y130 w20 gIncreaseValue, +
        Gui, tool_gui:Add, Button, Default x50 y250 w200 gUpdatePassword, Update Password
        Gui, tool_gui:Show, w300 h300
    }

    UpdateValue() {
        GuiControl, tool_gui:, CurrentAttemptDisplay, % This.CurrentAttempt
    }

    IncreaseValue() {
        This.CurrentAttempt := Mod(This.CurrentAttempt + 1, 6)
        This.UpdateValue()
    }

    DecreaseValue() {
        min := 0
        max := 5

        This.CurrentAttempt -= 1

        if (this.CurrentAttempt < min) {
            this.CurrentAttempt := max
        }
        This.UpdateValue()
    }

    GetBasePassword() {
        ; Get base password from text input box
        GuiControlGet, pass, , PasswordTextBox
        return pass
    }

    GetCurrentPassword() {
        ; Calculate and return password for current iteration in reset loop
        if (This.CurrentAttempt == 0) {
            return this.GetBasePassword()
        } else {
            return This.GetBasePassword() . This.CurrentAttempt
        }
    }

    GetNextPassword() {
        ; Build new password for attempt
        if (This.CurrentAttempt == 5) {
            return This.GetBasePassword()
        } else {
            return This.GetBasePassword() . (This.CurrentAttempt + 1)
        }
    }

    UpdatePassword() {
        ; Send values
        WinActivate, ahk_exe chrome.exe
        WinWaitActive, ahk_exe chrome.exe

        SendRaw, % This.GetCurrentPassword()
        Sleep, 100
        Send, {Tab}
        Sleep, 100
        SendRaw, % This.GetNextPassword()
        Sleep, 100
        Send, {Tab}
        Sleep, 100
        SendRaw, % This.GetNextPassword()
        Sleep, 100
        Send, {Tab}
        Sleep, 100
        Send, {Space}

        This.IncreaseValue()
    }
}


; Buttons
; ==============================================================================
DecreaseValue:
    _gui.DecreaseValue()
Return

IncreaseValue:
    _gui.IncreaseValue()
Return

UpdatePassword:
    _gui.UpdatePassword()
Return

tool_guiGuiClose:
    ; Destroy GUI window
    Gui, tool_gui:Destroy

    ; Close AHK
    ExitApp
Return
