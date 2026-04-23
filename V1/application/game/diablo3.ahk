#IfWinActive, Diablo III
; Basic hotkeys
c::Send {Enter}

; Class base hotkeys
7::D3.GetSkill("q").Toggle(1000)
8::D3.GetSkill("w").Toggle(1000)
9::D3.GetSkill("e").Toggle(5000)
0::D3.GetSkill("r").Toggle(500)

-::  ; Start all
    D3.GetSkill("{Numpad1}").Enable(1000)  ; Q
    D3.GetSkill("{Numpad2}").Enable(1000)  ; W
    D3.GetSkill("{Numpad3}").Enable(5000)  ; E
    D3.GetSkill("{Numpad4}").Enable(500)  ; R
return

; Disable all Hotkeys
~Space::D3.DisableAll()
~m::D3.DisableAll()
~b::D3.DisableAll()
#IfWinActive ; End #IfWinActive for Diablo 3
