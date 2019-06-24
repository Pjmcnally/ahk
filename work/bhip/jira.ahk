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
close_issue() {
    /*  Close active issue in JIRA.
    */
    wait := 250

    if (WinActive("TECH")) {
        close_command := "Close"
    } else if (WinActive("HELP")){
        close_command := "Resolve this issue"
    } else if (WinActive("TASK")){
        close_command := "Done"
    }

    SendWait(., wait)
    SendWait(close_command, wait)
    SendWait("{Enter}", wait)
    SendWait("{shift down}{tab 2}{shift up}", wait)
    Send, {Enter}
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
    str := RegExReplace(str, "s)\*?{color.*?}(.*?){color}\*?", "$1")  ; Remove all {color tags} and linked * tags leaving surrounding text.
    str := RegexReplace(str, "(?<![\n\*])\*(.*?)\*", "$1")  ; Remove all * tags leaving surrounded text. Leave list formatting unmodified
    str := RegExReplace(str, "\_(.*?)\_", "$1")  ; Remove all _ tags leaving surrounded text
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

tech_1356() {
    ticket := "Tech-1356"
    message := "* Login to AutoWeb processes"

    if (A_Hour < 16) {
        time_entry(ticket, message, "12:30 PM", "12:35 PM")
    } else {
        time_entry(ticket, message, "4:00 PM", "4:05 PM")
    }
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
:?o:sr::Self resolved^{Enter}
:o*:{f::From error log:{Enter}{{}code{}}{Enter}^v{Enter}{{}code{}}
:o*:{c::{{}code{}}{Enter}^v{Enter}{{}code{}}
:o*:{q::{{}quote{}}{Enter}^v{Enter}{{}quote{}}

; Time tracking hotkeys
:?coX:tlws::tech_1356()
:coX:mday::time_entry("Task-121", "* Daily Huddle", "10:00 AM", "now")
:coX:mbhip::time_entry("Task-136", "* Monthly BHIP Meeting")
:coX:mver::time_entry("Task-184", "* Weekly verification and FlexiCapture meeting", "9:00 AM", "9:30 AM")
:coX:mtech::time_entry("Task-187", "* Weekly technology meeting", "1:30 PM", "now")
:coX:tsteve::time_entry("task-169", "* Investigate and resolve request")
:coX:tann::time_entry("task-206", "* Investigate and resolve request")
:coX:irc::Send, % "* Investigate{Enter}Resolve{Enter}Close"
:coX:iru::Send, % "* Investigate{Enter}Respond{Enter}Update"


; Chrome only Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
!c::
    KeyWait, Alt, L  ; Wait for release as alt will interfere with func sends
    close_issue()
Return

#IfWinActive  ; Clear IfWinActive
