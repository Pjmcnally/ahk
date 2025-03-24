
#IfWinActive ahk_exe adventure-capitalist.exe

1::adCap.KeepAwake()
Space::adCap.ToggleFastClick(false, 10)
~LButton::adCap.DeactivateFastClick()
RButton::adCap.ToggleFastClick(false, 10)

#IfWinActive
