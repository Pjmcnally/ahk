/*  I wrote this to solve an issue with standard ctrl-c, ctrl-x and ctrl-v
    hotkeys to copy, cut, and paste.

    However, I found a better solution which was to update the PSReadLine
    module. This can be done with the following command:
    Install-Module PSReadLine -Scope CurrentUser -AllowPrerelease -AllowClobber -Force

    This ahk file is now obsolete.
*/

#IfWinActive ahk_exe pwsh.exe

paste_terminal(str) {
    Loop, parse, str, `n, `r
    {
        SendInput, {Raw}%A_LoopField%
        SendInput, +{Enter}
    }

    SendInput {BackSpace}
}

^v::  ; Replace paste functionality in PowerShell Terminal
    paste_terminal(clipboard)
return

^c::  ; Replace copy functionality in PowerShell Terminal
    Send, !{space}
    Send, e{Enter}
return

#IfWinActive
