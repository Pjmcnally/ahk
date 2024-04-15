#IfWinActive, ahk_exe Diablo IV.exe
; Basic hotkeys
!c::Send {Enter}

; Class base hotkeys
d::D4.GetSkill("{Rbutton}").Enable(100)

; Disable all Hotkeys
~Rbutton::D4.DisableAll() ; Right Click
~Tab::D4.DisableAll() ; Map
~b::D4.DisableAll() ; Back
~i::D4.DisableAll() ; Inventory
~m::D4.DisableAll() ; Map
~6::D4.DisableAll() ; Mount


#IfWinActive
