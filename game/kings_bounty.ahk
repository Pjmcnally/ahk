; This is a hotstring I made to automatically adjust my army in Kings Bounty

#IfWinActive, kingsbounty
F1:: ;Gear Switcher
    BlockInput, On
    SetMouseDelay, 20
    ; army 1
    Click 816, 1000, 2  ; double click army 1
    click 325, 550 ; click to dismiss army
    click 950, 600 ; click to confirm prompt
    ; army 2
    Click 901, 1000, 2  ; click to select army 1
    click 325, 550 ; click to dismiss army
    click 950, 600 ; click to confirm prompt
    ; army 3
    Click 987, 1000, 2  ; click to select army 1
    click 325, 550 ; click to dismiss army
    click 950, 600 ; click to confirm prompt
    ; army 4
    Click 1069, 1000, 2  ; click to select army 1
    click 325, 550 ; click to dismiss army
    click 950, 600 ; click to confirm prompt
    ; army 5
    Click 1153, 1000, 2  ; click to select army 1
    click 325, 550 ; click to dismiss army
    click 950, 600 ; click to confirm prompt
    BlockInput, Off
return

F2:: ;new dragon eye
    sendinput item addon3_artefact_eye_of_drakkentir
return

; This should always be at the bottom
#IfWinActive ; End #IfWinActive for Kings Bounty
