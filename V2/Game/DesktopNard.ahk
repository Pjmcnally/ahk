; Directives
#Requires AutoHotkey v2.0

; Includes
#Include "%A_LineFile%\..\..\Lib\Internal"
#Include "Keyboard.ahk"

; Hotkeys
#HotIf WinActive("ahk_exe Desktop Nard.exe")
; Sell Items
XButton1::{
    Keyboard.SendWait("{Ctrl Down}{Shift Down}{Click Right Down}", 50)
    Keyboard.SendWait("{Click Right Down}", 50)
    Keyboard.SendWait("{Click Right Up}", 50)
    Keyboard.SendWait("{Click Right Up}{Shift Up}{Ctrl Up}", 50)
}

; Buy max upgrades
XButton2::{
    Keyboard.SendWait("{Alt Down}", 100)
    Keyboard.SendWait("{Click Down}", 100)
    Keyboard.SendWait("{Click Up}", 100)
    Keyboard.SendWait("{Alt Up}", 100)
}
#HotIf

; Functions
