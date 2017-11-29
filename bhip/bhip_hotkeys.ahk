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
        line := RegExReplace(line, "[\s_]*{color.*?}[\s_]*")  ; Remove all {color} tags and ajoining spaces and underscores
        line := RegExReplace(line, "\xA0+")  ; Remove all Non-breaking spaces
        line := RegexReplace(line, "\s*\*\s*")  ; Remove all * and adjoining whitespace
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
:co:mdad::Task-78{Tab 3}* Meeting with Milena{Enter}Creating and sending daily auto-docket report ; *'s for all items after first are auto-filled by JIRA
:co:mdev::Task-80{Tab 3}* Weekly DevOps Meeting
:co:mwad::Task-82{Tab 3}* Weekly Auto-Docket Meeting
:co:mrel::Task-83{Tab 3}* Weekly Release Meeting

; Signature/Ticket Hotstrings
:o:-p::--Patrick
:o:psig::Patrick McNally{Enter}DevOps Support{Enter}pmcnally@blackhillsip.com
:co:ifq::If there are any questions or there is anything more I can do to help please let me know.

; Daily auto-docket review Hotstrings
:co:crule::=AND(A2 <> "", B2 <> "", C2 <> "")
:co:abanf::US-90{tab}Application status does not contain "To Be Abandoned"{tab}There are notes that this is to be abandoned but the status wasn't updated.  Nothing we can do.
:co:miscf::Many codes{tab}Misc Doc code. Several rules tried.  All rules failed.{tab}We probably need to make a rule for this specific doc.{tab}
:co:!val::Procedure passed all rules. Docketing failed because of error validating application.{tab}I searched the client host system.  This matter doesn't exist.{tab}Docketer
:co:ratt::Procedure passed all rules. Required attributes were not extracted so docketing failed.{tab}We need to make/update an annotation to indentify and extract the following:{tab}Milena/Patrick
:co:eadr::
    recipients := "Jill{tab}Milena{tab}Leonie{tab}"  ; I don't use full emails here to protect from spam.  Autofill will complete them in my Outlook.
    subject := "Daily Auto-Docket Report"
    body := "All,{Enter}{Tab}I have attached the Daily Auto-Docket Report for " . f_date() . ".{Enter 2}{Tab}If there are any questions or there is anything more I can do to help please let me know."
    send_outlook_email(subject, body, recipients)
return

; SQL Hostrings
:o:bt::{/}{*}{ENTER}BEGIN TRAN{Enter 2}--commit{ENTER}ROLLBACK{ENTER}{*}{/}

; Complex Hotkeys
^!v::
    format_db_for_jira()  ; Run format_db_for_jira on contents on clipboard
return

^!f::
    clip_func("format_jira")  ; Run "format_jira" func on selected text
return
