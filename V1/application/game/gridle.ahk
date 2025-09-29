#IfWinActive, ahk_exe GridleDemo.exe

XButton2::gridle.ToggleFastClick(False, 25)
^Space::
    KeyWait Space
    Send {Space Down}

#IfWinActive
