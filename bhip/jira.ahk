/*  Details on JIRA shortcuts (used below)

    https://confluence.atlassian.com/agile066/jira-agile-user-s-guide/using-keyboard-shortcuts
    https://www.atlassian.com/blog/jira-software/4-ways-get-jira-keyboard-shortcuts
*/

/*  Actual hotkeys to use in JIRA

    i --> Assign to me
    m --> Jumps to new comment
*/

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

#IfWinActive ahk_exe chrome.exe


; To make this work I need to add a bit of logic. Set the "close" action by project
; Also use an IfWinActive to filter for only chrome jira windows
!c::
    KeyWait Alt
    close_issue()
return

#IfWinActive
