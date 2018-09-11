; SQL hotstrings
#IfWinActive ahk_exe Ssms.exe

; Functions used in this module
; ==============================================================================
check_process_mon() {
    query =
    (
        SELECT
            pm.ProcessName,
            pm.CurrentStatus,
            pma.AlertStart,
            pma.AlertEnd,
            pma.ActionLog
        FROM
            dbo.ProcessMonitor pm
            INNER JOIN dbo.ProcessMonitorAlert pma ON pma.ProcessMonitorId = pm.ProcessMonitorId
                AND pma.AlertEnd is null
        WHERE
            pm.isMonitored = '1'
            AND pm.CurrentStatus <> 'OK'
        ORDER BY
            pma.AlertStart ASC
    )

    paste_contents(dedent(query, 8))
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
