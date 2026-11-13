#Requires AutoHotkey v2.0

; Includes
#Include "%A_LineFile%\..\..\Lib\Internal"
#Include "Keyboard.ahk"

SelectSet(key, delay:=50) {
    Keyboard.SendWait('{q down}', delay)
    Keyboard.SendWait(key, delay)
    Keyboard.SendWait('{q up}', delay)
}



; TODO: Document and clean up this file
;@region Hotkeys
#HotIf WinActive("ahk_exe IdleWizard.exe")

`:: {
    while(true) {
        ControlSend("b", , "ahk_exe IdleWizard.exe")
        Sleep(250)
        ControlSend("{Up}", , "ahk_exe IdleWizard.exe")
        Sleep(250)
        ; ControlClick("X1245 Y890", "ahk_exe IdleWizard.exe")
        ; Sleep(250)
    }
}

Up:: {
    Keyboard.SendWait("b", 25)
    Keyboard.SendWait("{Up}", 25)
    Sleep(100)
}

F1::SelectSet('1')
F2::SelectSet('2')
F3::SelectSet('3')
F4::SelectSet('4')
F5::SelectSet('5')
F6::SelectSet('6')
F7::SelectSet('7')
F8::SelectSet('8')
F9::SelectSet('9')
F10::SelectSet('0')



#HotIf
;@endRegion
