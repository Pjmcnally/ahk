useSkills() {
    skillList := []  ; Enable for Tempest Rush Monk
    ; skillList := ["q", "w", "e", "r"]  ; Enable for WW
    ; skillList := ["q", "w", "e"]  ; Enable for Rend

    for i in skillList {
        Send, % skillList[i]
        Random, variableDelay, -99, 99
        Sleep, % variableDelay
    }
}


~lButton::
    if GetKeyState("rButton") {
        useSkills()
    }
Return


#IfWinActive, Diablo III



; This should always be at the bottom
#IfWinActive ; End #IfWinActive for Diablo 3
