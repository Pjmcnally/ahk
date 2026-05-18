#IfWinActive ahk_exe yaig.exe

random_typing() {
    ToolTip, Typing
    While True {
        if WinActive("ahk_exe yaig.exe") {
            Send, "abcdefg"
            Sleep, 50
        }
    }
}

XButton1::random_typing()



#IfWinActive ; Deactivate previous IfWinActive
