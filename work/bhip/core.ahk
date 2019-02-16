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

        To use this set the Setting Summary filter to contains and enter some
        value. It doesn't matter if no items are showing but there must not be
        more than 1 screen worth of items as the scrolling bar throws off some
        of the click references.

        You may also need to update the StartDate box x position as it can be
        influenced by credential name length.

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
    start_date_box_x_pos := 940

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
        Click, %start_date_box_x_pos%, 425, 2  ; Click top square Start Date box.
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

; Hotstrings
; ==============================================================================
; Miscellaneous
:co:b1::BACKLOG 001!o

; Test matters
:Xco*:testmatter::Send, % get_test_matter()

; Signature/Ticket Hotstrings
:co:ifq::If there are any questions or there is anything more I can do to help please let me know.
:Xo:psig::SendLines(["Patrick McNally", "DevOps Support", get_my_bhip_email()])

; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
^!d::fill_scrape_mail_date()
