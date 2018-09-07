; SQL hotstrings
#IfWinActive ahk_exe Ssms.exe

; Functions used in this module
; ==============================================================================
check_process_mon() {
    query =
        (
SELECT
    *
FROM
    dbo.ProcessMonitor
WHERE
    isMonitored = '1'
    AND CurrentStatus <> 'OK'
        )
    paste_contents(query)
    Send, {F5}
}

begin_tran() {
    query =
        (
/*
BEGIN TRAN

--commit
ROLLBACK
*/
        )
    paste_contents(query)
    Send, {UP 3}
}


; Hotstrings & Hotkeys in this module
; ==============================================================================
:o:bt::
    begin_tran()
Return

:o:pmc::
    check_process_mon()
Return

#IfWinActive ; End SQL Hotstrings
