#IfWinActive, ahk_exe Diablo IV.exe
; Basic hotkeys
!c::Send {Enter}

; Class base hotkeys
7::D4.GetSkill("{Numpad0}").Enable(250)  ; RMouse
8::D4.GetSkill("{Numpad1}").Enable(250)  ; Q
9::D4.GetSkill("{Numpad2}").Enable(250)  ; W
0::D4.GetSkill("{Numpad4}").Enable(250)  ; R

-::
    Send {Numpad0 Down}
    ; D4.GetSkill("{Numpad0}").Enable(100)  ; RMouse
    D4.GetSkill("{Numpad1}").Enable(250)  ; Q
    D4.GetSkill("{Numpad2}").Enable(250)  ; W
    D4.GetSkill("{Numpad4}").Enable(250)  ; R
return

; Disable all Hotkeys
~b::D4.DisableAll() ; Back
~i::D4.DisableAll() ; Inventory
~6::D4.DisableAll() ; Mount
#IfWinActive
