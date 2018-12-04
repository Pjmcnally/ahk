/*  Core functions, hotstrings, and hotkeys used at BHIP.

    These hotkeys are all non-program specific and used at BHIP.
*/

; Functions
; ==============================================================================
send_outlook_email(subject, body, recipients := "") {
    /*  Fill content into Outlook email.

        Args:
            subject (str): The subject of the email
            body (str): The body of the email
            recipients (str): Optional. Recipients of email.
        Return:
            None
    */
    if (recipients) {
        Send, %recipients%{Tab 2}
    }
    Send, %subject%{Tab}
    Send, % body

    Return
}

fill_scrape_mail_date() {
        /*  Fill scrape start dates and mail start date into jobs screen.

        Filter to 1 result before running or the process won't work. Also set
        filter to "Contains"

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
    InputBox, array_str, % "USPTO Customer Numbers", % "Add a comma separated list of USPTO Customer Numbers."
    ; InputBox, num, % "Number?", % "Please enter the number of lines to fill"
    ; if ErrorLevel
    ;     Exit

    array := StrSplit(array_str, ",", " ")
    wait := 300

    For i, val in array {
        ; Make sure to sort by "Start Date Asc before starting. That way the
        ; newly entered item will be "Sorted to the bottom" and the top box
        ; will always be empty.

        WinActivate, Black Hills IP - IP Tools - Internet Explorer
        WinWaitActive, Black Hills IP - IP Tools - Internet Explorer

        Click, 2538, 397, 1
        Sleep, % wait
        Click, 2500, 760, 1
        Sleep, % wait
        Send, % val
        Sleep, % wait
        Send, {Enter}
        Sleep, % wait
        Click, 765, 425, 2  ; Click top square Start Date box.
        Sleep, % wait
        Send, ^a
        Send, % scrape_start  ; Enter Date
        Sleep, % wait
        Click, 325, 1210, 2  ; Click in MailDateStart box.
        Sleep, % wait
        Send, ^a
        Send, % mail_start  ; Enter Date
        Sleep, % wait

        i += 1
    }
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
    str := RegexReplace(str, "\*(.*?)\*", "$1")  ; Remove all * tags leaving surrounded text
    str := RegExReplace(str, "\_(.*?)\_", "$1")  ; Remove all _ tags leaving surrounded text
    str := RegexReplace(str, "\+(.*?)\+", "$1")  ; Remove all + tags leaving surrounded text
    str := RegExReplace(str, "\[{2,}(.*?)\]{2,}", "[$1]")  ; Convert double brackets to single.
    str := RegExReplace(str, "(?:(\[)\s+|\s+(\]))", "$1$2")  ; Remove any spaces immediately inside of open bracket or before closing bracket
    str := RegExReplace(str, "\[(.*?)\|\]", "$1")  ; Remove any link tags with no link content
    str := RegExReplace(str, "m)^ *(.*?) *$", "$1")  ; Trim spaces from beginning and end of lines
    str := RegExReplace(str, "(\r\n|\r|\n){2}", "`r`n")  ; Collapse any single empty lines.
    str := RegExReplace(str, "(\r\n|\r|\n){3,}", "`r`n`r`n")  ; Reduce any stretch of multiple empty lines to 1 empty line.
    str := RegExReplace(str, "m)^[fF](rom:.*)$", "----`r`n`r`nF$1")  ; Add ---- divider before next email
    str := RegExReplace(str, get_bhip_sig_address())  ; Remove BHIP address block
    str := RegExReplace(str, get_bhip_sig_conf())  ; Remove bhip conf statement

    Return str
}


; Hotstrings
; ==============================================================================
; Miscellaneous
:o*:{f::From error log:{Enter}{{}code{}}{Enter}^v{Enter}{{}code{}}
:o*:{c::{{}code{}}{Enter}^v{Enter}{{}code{}}
:o*:{q::{{}quote{}}{Enter}^v{Enter}{{}quote{}}
:co:b1::BACKLOG 001!o

; Time tracking hotkeys
:co:mbhip::Task-136{Tab 3}* Monthly BHIP Meeting
:co:mday::Task-121{Tab 3}* Daily Huddle
:co:mver::Task-184{Tab 3}* Weekly verification and flexicapture meeting
:co:mtech::Task-187{Tab 3}* Weekly technology meeting
:co:tlws::Tech-1356{Tab 3}* Login to WorkSite DMS

; Test matters
:Xco:ustest::Send, % get_test_matter("us")
:Xco:cntest::Send, % get_test_matter("cn")

; Signature/Ticket Hotstrings
:co:ifq::If there are any questions or there is anything more I can do to help please let me know.
:Xo:psig::SendLines(["Patrick McNally", "DevOps Support", get_my_bhip_email()])

; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
^!d::fill_scrape_mail_date()
