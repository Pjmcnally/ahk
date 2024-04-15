#IfWinExist ahk_exe vlc.exe

~LButton::
    MouseGetPos , OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
    if (inStr(OutputVarControl, "VLC video"))
        Send, {Media_Play_Pause}
return

#IfWinExist
