#Requires AutoHotkey v2.0

#Include <Keyboard>

#HotIf WinActive("ahk_exe Desktop Nard.exe")

MButton::{
    Keyboard.SendWait("{Ctrl Down}", 100)
    Keyboard.SendWait("{Shift Down}", 100)
    Keyboard.SendWait("{Click Right Down}", 100)
    Keyboard.SendWait("{Click Right Up}", 100)
    Keyboard.SendWait("{Shift Up}", 100)
    Keyboard.SendWait("{Ctrl Up}", 100)
    KeyWait("MButton", "U")
}
XButton1::{
    Keyboard.SendWait("{Ctrl Down}", 100)
    Keyboard.SendWait("{Click Down}", 100)
    Keyboard.SendWait("{Click Up}", 100)
    Keyboard.SendWait("{Ctrl Up}", 100)
}
XButton2::{
    Keyboard.SendWait("{Alt Down}", 100)
    Keyboard.SendWait("{Click Down}", 100)
    Keyboard.SendWait("{Click Up}", 100)
    Keyboard.SendWait("{Alt Up}", 100)
}

#HotIf
