/*  Hotkeys, Hotstrings, Functions used at BHIP.

This module contains all of the Hotkeys, Hotstrings and functions I use at BHIP.
*/

; Functions used in this module
; ==============================================================================
format_jira(str) {
    /*  Reformat text sent into JIRA from Outlook email.

        Outlook add extra line breaks to emails sent to JIRA.  Also, JETI tries
        to process colors and adds {color} tags around all text (even black).
        These "features" combine to make text very hard to read.

        This function cleans up the text and makes it much more human readable.

        Args:
            str (str): The text to be cleaned up.
        Return:
            str: The cleaned text.
    */
    res := ""
    CrLf := "`r`n"
    empty_count := 0

    Loop, parse, str, `n, `r
    {
        line := A_LoopField
        line := RegExReplace(line, "{color.*?}\s*(.*?)\s*{color}", "$1")  ; Remove all {color} tags and surrounding spaces leaving contained text
        line := RegexReplace(line, "\*\s*(.*?)\s*\*", "$1")  ; Remove all * tags leaving surrounded text
        line := RegExReplace(line, "_{2,}(.*?)_{2,}", "_$1_")  ; Remove all double underscores.
        line := RegExReplace(line, "\[{2,}(.*?)\]{2,}", "[$1]")  ; Remove all double brackets.
        line := RegExReplace(line, "\[(.*?)\|\]", "$1")  ; Remove any link tags with no link content
        line := RegExReplace(line, "\xA0+")  ; Remove all Non-breaking spaces

        line := Trim(line)  ; Trim whitespace


        if not (line) {  ; Some lines end up empty.  Consecutive emply lines are collapsed to 1.
            empty_count += 1
        } else if (line and empty_count > 1 ) {  ; If a line is preceeded by multiple empty lines append it too string with preceeding empty line
            res := res . CrLf . line . Crlf
            empty_count := 0
        } else {  ; Otherwise just add to string.
            res := res . line . CrLf
            empty_count := 0
        }
    }

    return res
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
            If (A_Index == 1) {  ; If first elem preceed with div char
                res := res . div_char
            }
            res := res . A_LoopField . div_char
        }
        res := res . CrLf
    }

    paste_contents(res)
    return
}

format_db_for_get_files() {
    /*  Format content copied out of MSSMS as a powershell hash table.

        Search to get data with columns jd & jds (order is important)
    */
    CrLf := "`r`n"
    res := "$files = @{" . CrLf
    str := Clipboard

    Loop, parse, str, `n, `r
    {
        Loop, Parse, A_LoopField, `t
        {
            if (A_index = 1) {
                res := res . "`t'" . A_loopField . "'" . " = '"
            } else {
                res := res . A_LoopField . "'"
            }
        }
        res := res . CrLf
    }

    res := res . "}"

    paste_contents(res)
    return
}

daily_auto_docket_review_code(elems) {
    for key, value in elems {
        Send, % value
        Send {tab}
    }
}

copy_num() {
    Send {tab 4}{Down}^c
}

edit_last() {
    Send {ShiftDown}{tab 2}{ShiftUp}{F2}{space}
}

; Hotstrings & Hotkeys in this module
; ==============================================================================
; Misc Hotstrings
:co:pinfo::Patrick{Tab}McNally{Tab}Pmcnally@blackhillsip.com{Tab}{Down}{Tab}{Tab}{Space}
:co:{f::From error log:{Enter}{{}code{}}{Enter}^v{Enter}{{}code{}}
:co:{c::{{}code{}}{Enter}^v{Enter}{{}code{}}
:co:b1::BACKLOG 001!o
:co:fd::For documentation please see: ^v
:co:nopr::Notice of Publication

; Meeting hotkeys (for time entry)
:co:mdad::Task-78{Tab 3}* Getting raw data for auto-docket review{Enter}Parsing data and updating auto-docket review spreadsheet  ; *'s for all items after first are auto-filled by JIRA
:co:mdev::Task-80{Tab 3}* Weekly DevOps Meeting
:co:mwad::Task-82{Tab 3}* Weekly Auto-Docket Meeting
:co:mrel::Task-83{Tab 3}* Weekly Release Meeting

; Signature/Ticket Hotstrings
:o:-p::--Patrick
:o:psig::Patrick McNally{Enter}DevOps Support{Enter}pmcnally@blackhillsip.com
:co:ifq::If there are any questions or there is anything more I can do to help please let me know.

; Daily auto-docket review Hotstrings
#IfWinActive ahk_exe EXCEL.EXE
:co:abanf::
    elems :=  ["US-90", "Document failed rule: Application status does not contain ""To Be Abandoned""", "This is not an issue with Auto-Docketing. This should be reviewed by a docketer.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:appinf::
    elems := ["US-10", "Document failed rule: Contains text ""Applicant initiated""", "Document broken into odd pieces. The piece the rule was applied to was only the cover letter. Other pieces contained the text", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:codef::
    input, code, V, {SPACE},
    if (code) {
        code := ""
    } else {
        code := "{BACKSPACE}Misc codes"
    }

    elems := [code, "Document failed multiple rules. None of the tried p-codes are correct for this document.", "For this to work we would need to make a p-code for this specific document.", "Milena"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:multh::
    elems := ["", "Document passed all rules. Docketing failed due to duplicate host activities found error", "This means that there are multiple possible activities in the Host system for this activity to be docketed into.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:multc::
    elems := ["", "Document passed all rules for multiple procedure codes.", "Auto-docketing unable to complete as it can't determing which procedure code to use. We need to make the rules more specific.", "Milena"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:multd::
    input, code, V, {SPACE},
    elems := ["", "Document passed all rules. Auto-Docketing failed because multiple documents with the same name were received", "I do not believe this is an issue we can/need to fix in the auto-docket system.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:valf::
    input, code, V, {SPACE},
    elems := ["", "Document passed all rules. Docketing failed due to error validating application.", "I searched the client host system. This matter doesn't exist.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:ratt::
    input, code, V, {SPACE},
    elems := ["", "Document passed all rules. Docketing failed due to empty required attributes.", "We need to make/update an annotation to indentify and extract the following:", "Milena/Patrick"]
    daily_auto_docket_review_code(elems)
    edit_last()
    input, temp, V, {TAB}
    Send, {TAB}
    copy_num()
return

:co:finf::
    elems := ["US-62", "Document failed rule: Document contains text ""MADE FINAL""", "This is not an OCR issue. The text ""Made final"" does not appear in the document. The final checkbox is checked.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:finof::
    elems := ["US-62", "Document failed rule: Document contains text ""MADE FINAL""", "This is an OCR issue. The text ""Made final"" does appear in the document but was not OCR'd correctly.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:quef::
    input, code, V, {SPACE},
    elems := ["", "Document passed all rules. Docket action set to Queued so document was not automatically docketed.", "This is not an error. Documents set to Queue are supposed to be reviewed before docketing.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:intf::
    elems := ["This is not an issue with auto-docketing. This should be reviewed by a docketer.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
#IfWinActive  ; Clear #IfWinActive from above

; SQL Hostrings
:o:bt::{/}{*}{ENTER}BEGIN TRAN{Enter 2}--commit{ENTER}ROLLBACK{ENTER}{*}{/}

; Complex Hotkeys
^!v::
    format_db_for_jira()  ; Run format_db_for_jira on contents on clipboard
return

^!b::
    format_db_for_get_files()  ; Run format_db_for_jira on contents on clipboard
return

^!f::
    clip_func("format_jira")  ; Run "format_jira" func on selected text
return
