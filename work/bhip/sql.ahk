/*  SQL functions, hotstrings, and hotkeys used at BHIP.
*/
#IfWinActive ahk_exe Ssms.exe || ahk_exe azuredatastudio.exe

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

ToggleComment() {
    str := get_highlighted()
    isComment := true

    Loop, parse, str, `n, `r
    {
        if not (RegexMatch(A_LoopField, "^\s*--.*")) {
            isComment := False
            break
        }
    }

    if isComment {
        Send, ^k^u  ; Uncomment highlighted lines
    } else {
        Send, ^k^c  ; Comment highlighted lines
    }
}


; Hotstrings
; ==============================================================================
:Xo:bt::make_query(get_bt_query(), 8, False, "{UP 3}")
:Xo:pmc::make_query(get_pmc_query(), 8)
:o:alxml::
    SendRaw, % "[OldValue] = CAST(OldValues as xml).value('(/row/@<ATTRIBUTE>)[1]', 'varchar(50)'),"
    Send, {Enter}
    SendRaw, % "[NewValue] = CAST(NewValues as xml).value('(/row/@<ATTRIBUTE>)[1]', 'varchar(50)')"
Return



; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
^!+l::paste_as_sql_list()
^/::ToggleComment()

#IfWinActive ; End SQL Hotstrings
