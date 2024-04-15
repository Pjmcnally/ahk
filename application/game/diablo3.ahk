#IfWinActive, Diablo III
; Basic hotkeys
c::Send {Enter}

; Class base hotkeys
; 7::D3.GetSkill("q").Toggle(1000)
8::D3.GetSkill("w").Toggle(4000)
9::D3.GetSkill("e").Toggle(1000)
0::D3.GetSkill("r").Toggle(1000)

; Disable all Hotkeys
~Space::D3.DisableAll()
~m::D3.DisableAll()
~b::D3.DisableAll()
#IfWinActive ; End #IfWinActive for Diablo 3
