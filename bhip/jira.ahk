/*  Details on JIRA shortcuts (used below)

    https://confluence.atlassian.com/agile066/jira-agile-user-s-guide/using-keyboard-shortcuts
    https://www.atlassian.com/blog/jira-software/4-ways-get-jira-keyboard-shortcuts
*/

/*  Actual hotkeys to use in JIRA

    i --> Assign to me
    m --> Jumps to new comment
*/

; To make this work I need to add a bit of logic. Set the "close" action by project
; Also use an IfWinActive to filter for only chrome jira windows
; !c::Send .close{Enter}
