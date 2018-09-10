/*  Hotkeys, Hotstrings, Functions used at BHIP.

This module contains all of the Hotkeys, Hotstrings and functions I use at BHIP.
*/

; Functions used in this module
; ==============================================================================
fill_scrape_mail_date() {
        /*  Fill scrape start dates and mail start date into jobs screen.

        Args:
            None
        Return:
            None
    */
    InputBox, scrape_start, % "Scrape Start", % "Please enter scrape start date"
    if ErrorLevel
        Exit
    InputBox, mail_start, % "Mail Start", % "Please enter mail start date"
    if ErrorLevel
        Exit
    InputBox, num, % "Number?", % "Please enter the number of lines to fill"
    if ErrorLevel
        Exit
    i = 0
    box_height := 24

    While(i < num) {
        if (Mod(i, 20) = 0) {
            KeyWait, LButton, D
            MouseGetPos, x, y
        }

        Sleep, 200
        Send {Click, 2}
        Sleep, 200
        Send, % scrape_start
        Click, 325, 1225, 2  ; Magic number for location of mail date box
        Sleep, 200
        Send, % mail_start

        y += box_height
        MouseMove, x, y

        i += 1
    }
}

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

    str := RegExReplace(str, "\xA0+", " ")  ; Replace all Non-breaking spaces with normal ones
    str := RegExReplace(str, "\*?{color.*?}(.*?){color}\*?", "$1")  ; Remove all {color tags} and linked * tags leaving surrounding text.
    str := RegexReplace(str, "\*(.*?)\*", "$1")  ; Remove all * tags leaving surrounded text
    str := RegExReplace(str, "\_(.*?)\_", "$1")  ; Remove all _ tags leaving surrounded text
    str := RegexReplace(str, "\+(.*?)\+", "$1")  ; Remove all + tags leaving surrounded text
    str := RegExReplace(str, "\[{2,}(.*?)\]{2,}", "[$1]")  ; Convert double brackets to single.
    str := RegExReplace(str, "(?:(\[)\s+|\s+(\]))", "$1$2")  ; Remove any spaces immediately inside of open bracket or before closing bracket
    str := RegExReplace(str, "\[(.*?)\|\]", "$1")  ; Remove any link tags with no link content
    str := RegExReplace(str, "m)^ *(.*?) *$", "$1")  ; Trim spaces from beginning and end of lines
    str := RegExReplace(str, "`a)(`r`n){2}", "`r`n")  ; Collapse any single empty lines.
    str := RegExReplace(str, "`a)(`r`n){3,}", "`r`n`r`n")  ; Reduce any stretch of multiple empty lines to 1 empty line.
    str := RegExReplace(str, "^([fF]rom:.*)$", "----`r`n`r`n$1")  ; Add ---- divider before next email
    str := RegExReplace(str, get_bhip_sig_address())  ; Remove BHIP address block
    str := RegExReplace(str, get_bhip_sig_conf())  ; Remove bhip conf statement

    Return str
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

paste_as_sql_list() {
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

; Hotstrings & Hotkeys in this module
; ==============================================================================
; Misc Hotstrings
:co:{f::From error log:{Enter}{{}code{}}{Enter}^v{Enter}{{}code{}}
:co:{c::{{}code{}}{Enter}^v{Enter}{{}code{}}
:co:{q::{{}quote{}}{Enter}^v{Enter}{{}quote{}}
:co:b1::BACKLOG 001!o

; Time tracking hotkeys
:co:mbhip::Task-136{Tab 3}* Monthly BHIP Meeting
:co:mday::Task-121{Tab 3}* Daily Huddle

; Signature/Ticket Hotstrings
:co:ifq::If there are any questions or there is anything more I can do to help please let me know.
:o:psig::
    SendLines(["Patrick McNally", "DevOps Support", get_my_bhip_email()])
Return

; Complex Hotkeys
^!v::  ; ctrl-alt-v
    format_db_for_jira()  ; Run format_db_for_jira on contents on clipboard
Return

^!f::  ; ctrl-alt-f
    clip_func("format_jira")  ; Run "format_jira" func on selected text
Return

^!d::  ; ctrl-alt-d
    fill_scrape_mail_date()
Return

^+!l::  ; ctrl-alt-shift-l
    paste_as_sql_list()
Return
