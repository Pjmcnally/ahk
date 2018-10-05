/*  SQL Hotkeys, Hotstrings, Functions used at BHIP.
*/
#IfWinActive ahk_exe Ssms.exe

; Functions
; ==============================================================================
make_query(query, dedent, runQuery:=true, extraAction:="") {
    /*  Execute provided SQL Query
    */
    paste_contents(dedent(query, dedent))
    if (runQuery) {
        Send, {F5}
    }

    if(extraAction):
        Send, %extraAction%
}

paste_as_sql_list() {
    /*  Paste items copied from excel or SSMS as formatted list
    */
    raw_str := Trim(Clipboard, "`r`n`t")
    array := StrSplit(raw_str, "`n", "`r")
    str := ""

    Loop, % array.MaxIndex()
    {
        str := str . "'" . array[A_Index] . "'"
        if (A_Index < (array.MaxIndex())) {
            str := str . ",`r`n"
        }
    }
    paste_contents(str)

    Return
}


; Hotstrings
; ==============================================================================
:Xo:bt::make_query(get_bt_query(), 8, false, "{UP 3}")
:Xo:pmc::make_query(get_pmc_query(), 8)


; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
^!+l::paste_as_sql_list()

#IfWinActive ; End SQL Hotstrings
