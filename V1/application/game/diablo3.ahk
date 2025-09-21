#IfWinActive, Diablo III
; Basic hotkeys
c::Click

; Class base hotkeys
;7::D3.GetSkill("q").Toggle(120000)
8::D3.GetSkill("w").Toggle(4000)
9::D3.GetSkill("e").Toggle(1000)
0::D3.GetSkill("r").Toggle(1000)

-::  ; Start all
    ; D3.GetSkill("{Numpad1}").Enable(10000)  ; Q
    D3.GetSkill("{Numpad2}").Enable(4000)  ; W
    D3.GetSkill("{Numpad3}").Enable(1000)  ; E
    D3.GetSkill("{Numpad4}").Enable(1000)  ; R
return

; Disable all Hotkeys
~Space::D3.DisableAll()
~m::D3.DisableAll()
~b::D3.DisableAll()
#IfWinActive ; End #IfWinActive for Diablo 3
