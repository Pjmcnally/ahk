/*  JIRA Hotkeys, Hotstrings, Functions used at BHIP.

    Details on JIRA shortcuts (used below)

    https://confluence.atlassian.com/agile066/jira-agile-user-s-guide/using-keyboard-shortcuts
    https://www.atlassian.com/blog/jira-software/4-ways-get-jira-keyboard-shortcuts

    Actual hotkeys to use in JIRA

    i --> Assign to me
    m --> Jumps to new comment
*/

#IfWinActive ahk_exe chrome.exe

; Functions
; ==============================================================================
close_issue() {
    wait := 250

    if (WinActive("TECH")) {
        close_command := "Close"
    } else if (WinActive("HELP")){
        close_command := "Resolve this issue"
    } else if (WinActive("TASK")){
        close_command := "Done"
    }

    SendWait(., wait)
    SendWait(close_command, wait)
    SendWait("{Enter}", wait)
    SendWait("{shift down}{tab 2}{shift up}", wait)
    Send, {Enter}
}

format_db_for_jira() {
    /*  Format content copied out of MSSMS as a table for JIRA and paste results.
    */
    res := ""
    CrLf := "`r`n"
    str := Clipboard

    Loop, parse, str, `n, `r
    {
        div_char := (A_Index == 1) ? "||" : "|"  ; || in header. | elsewhere.
        Loop, Parse, A_LoopField, `t
        {
            If (A_Index == 1) {  ; If first elem precede with div char
                res := res . div_char
            }
            res := res . A_LoopField . div_char
        }
        res := res . CrLf
    }

    paste_contents(res)
    Return
}

; Hotstrings
; ==============================================================================
:?o:sr::Self resolved^{Enter}


; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
^!v::format_db_for_jira()  ; Run format_db_for_jira on contents on clipboard
^!f::clip_func("format_jira_email")  ; Run "format_jira" func on selected text

!c::
    KeyWait Alt  ; Wait for release as alt will interfere with func sends
    close_issue()
Return

#IfWinActive  ; Clear IfWinActive
