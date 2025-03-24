#IfWinActive ahk_exe The Perfect Tower II.exe

; 1::perfectTower.KeepAwake()
~Space::Click
^Space::perfectTower.ToggleFastClick(false, 1000)
~LButton::perfectTower.DeactivateFastClick()
; RButton::perfectTower.ToggleFastClick(false, 10)

#IfWinActive
