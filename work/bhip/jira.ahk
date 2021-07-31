/*  JIRA functions, hotstrings, and hotkeys used at BHIP.

    Details on JIRA shortcuts (used below)

    https://confluence.atlassian.com/agile066/jira-agile-user-s-guide/using-keyboard-shortcuts
    https://www.atlassian.com/blog/jira-software/4-ways-get-jira-keyboard-shortcuts

    Actual hotkeys to use in JIRA

    i --> Assign to me
    m --> Jumps to new comment
*/


; Functions
; ==============================================================================
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

format_jira_email(str) {
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
    str := RegExReplace(str, "s)\*?{color:.*?}(.*?){color}\*?", "$1")  ; Remove all {color tags} that are making text black and linked * tags leaving surrounding text.
    str := RegexReplace(str, "(?<![\n\*])\*(.*?)\*", "$1")  ; Remove all * tags leaving surrounded text. Leave list formatting unmodified
    ; str := RegExReplace(str, "\_(.*?)\_", "$1")  ; Remove all _ tags leaving surrounded text
    str := RegexReplace(str, "\+(.*?)\+", "$1")  ; Remove all + tags leaving surrounded text
    str := RegExReplace(str, "\[{2,}(.*?)\]{2,}", "[$1]")  ; Convert double brackets to single.
    str := RegExReplace(str, "(?:(\[)\s+|\s+(\]))", "$1$2")  ; Remove any spaces immediately inside of open bracket or before closing bracket
    str := RegExReplace(str, "\[(.*?)\|\]", "$1")  ; Remove any link tags with no link content
    str := RegExReplace(str, "m)^ *(.*?) *$", "$1")  ; Trim spaces from beginning and end of lines
    str := RegExReplace(str, "(\r\n|\r|\n){2}", "`r`n")  ; Collapse any single empty lines.
    str := RegExReplace(str, "(\r\n|\r|\n){3,}", "`r`n`r`n")  ; Reduce any stretch of multiple empty lines to 1 empty line.
    str := RegExReplace(str, "m)^[fF](rom:.*)$", "----`r`n`r`nF$1")  ; Add ---- divider before each email
    str := RegExReplace(str, get_bhip_sig_address())  ; Remove BHIP address block
    str := RegExReplace(str, get_bhip_sig_conf())  ; Remove bhip conf statement

    str := RegExReplace(str, "^----`r`n`r`n", "")  ; Remove first divider if string starts with divider
    Return str
}

at_message(array) {
    For x, v in array {
        Send, % v . ", "
    }
}

time_entry(ticket, message, start_time:="", end_time="") {
    wait := 50

    ; Clear current ticket number & enter new ticket number
    SendWait("{Backspace}", wait)
    SendWait("{Backspace}", wait)
    SendWait(ticket, wait)

    SendWait("{Tab}", wait)
    if (start_time) {
        if (string_lower(start_time) = "now") {
            FormatTime, start_time, , % "hh:mm tt"
        }
        SendWait(start_time, wait)
    }

    SendWait("{Tab}", wait)
    if (end_time) {
        if (string_lower(end_time) = "now") {
            FormatTime, end_time, , % "hh:mm tt"
        }
        SendWait(end_time, wait)
    }

    SendWait("{Tab}", wait)
    SendWAit("^a", wait)
    SendWait(message, 50)
}

stop_using_pm_in_the_morning() {
    if (A_Hour < 12) {
        MsgBox, 20, AM/PM, Are you sure you meant PM?

        IfMsgBox, No
            Send, {Backspace 2}AM
    }
    Send, {TAB}
}

; Hotstrings
; ==============================================================================

; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
^!v::format_db_for_jira()  ; Run format_db_for_jira on contents on clipboard
^!f::clip_func("format_jira_email")  ; Run "format_jira" func on selected text


#IfWinActive ahk_exe chrome.exe

; Chrome only Hotstrings
; ==============================================================================
; Jira comment hotstrings
:Xco:@devs::at_message(get_devs())
:Xco:@ops::at_message(get_dev_ops())
:o:sr::Self resolved^{Enter}
:o*:{f::From error log:{Enter}{{}code{}}{Enter}^v{Enter}{{}code{}}
:o*:{c::{{}code{}}{Enter}^v{Enter}{{}code{}}
:o*:{q::{{}quote{}}{Enter}^v{Enter}{{}quote{}}

#IfWinActive  ; Clear IfWinActive

; Time tracking hotkeys
#IfWinActive Timetracker - IP Tools DevApps - Google Chrome

:coX:mday::time_entry("Task-121", "* Daily Huddle", "10:00 AM", "10:15 AM")
:coX:mbhip::time_entry("Task-136", "* Monthly BHIP Meeting")
:coX:mtech::time_entry("Task-187", "* Weekly technology meeting", "1:30 PM", "now")
:coX:mdevops::time_entry("Task-318", "* Weekly DevOps meeting")
:coX:mtrain::time_entry("task-804", "* Weekly developer training meeting")
:coX:tsteve::time_entry("task-169", "* Investigate and resolve request")
:coX:tann::time_entry("task-206", "* Investigate and resolve request")
:coX:ttom::time_entry("task-205", "* Send weekly status email to Tom")
:coX:temail::time_entry("task-205", "* Manage general emails received by ")
:coX:ttest::time_entry("task-135", "* Clean up errors in Test")
:coX:irc::Send, % "* Investigate{Enter}Resolve{Enter}Close"
:coX:iru::Send, % "* Investigate{Enter}Respond{Enter}Update"
:B0oX:pm::stop_using_pm_in_the_morning()

#IfWinActive  ; Clear IfWinActive
