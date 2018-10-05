/*  Recreate Copy and Paste functionality in Windows PowerShell.

    I wrote this to solve an issue with standard ctrl-c, ctrl-x and ctrl-v
    hotkeys to copy, cut, and paste.

    However, I found a better solution which was to update the PSReadLine
    module. This can be done with the following command:
    Install-Module PSReadLine -Scope CurrentUser -AllowPrerelease -AllowClobber -Force

    This ahk file is now obsolete and is not being loaded.
*/
#IfWinActive ahk_exe pwsh.exe


; Functions
; ==============================================================================
paste_terminal(str) {
    Loop, parse, str, `n, `r
    {
        SendInput, {Raw}%A_LoopField%
        SendInput, +{Enter}
    }

    SendInput {BackSpace}
}


; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
^v::paste_terminal(clipboard)  ; Replace paste functionality in PowerShell Terminal

^c::  ; Replace copy functionality in PowerShell Terminal
    Send, !{Space}  ; Key command to open action menu in PowerShell terminal
    Send, e{Enter}  ; Key command to copy selected text
Return

#IfWinActive
