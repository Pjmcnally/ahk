; SQL hotstrings
#IfWinActive ahk_exe Ssms.exe

; Functions used in this module
; ==============================================================================
make_query(query, dedent, runQuery:=true) {
    paste_contents(dedent(query, dedent))
    if (runQuery) {
        Send, {F5}
    }
}


; Hotstrings & Hotkeys in this module
; ==============================================================================
:o:bt::
    make_query(get_bt_query(), 8, false)
    Send, {UP 3}
Return

:o:pmc::
    make_query(get_pmc_query(), 8)
Return

#IfWinActive ; End SQL Hotstrings
