#IfWinActive, ahk_exe Diablo IV.exe
; Basic hotkeys
!c::Send {Enter}

; Class base hotkeys
7::D4.GetSkill("q").Enable(250)
8::D4.GetSkill("w").Enable(250)
;9::D4.GetSkill("{Rbutton}").Enable(100)
0::D4.GetSkill("r").Enable(250)

; Disable all Hotkeys
~b::D4.DisableAll() ; Back
~i::D4.DisableAll() ; Inventory
~6::D4.DisableAll() ; Mount
#IfWinActive
