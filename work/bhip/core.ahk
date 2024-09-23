/*  Core functions, hotstrings, and hotkeys used at BHIP.

    These hotkeys are all non-program specific and used at BHIP.
*/

; Functions
; ==============================================================================
send_outlook_email(subject, body, recipients := "", cc_recipients := "") {
    /*  Fill content into Outlook email.

        Args:
            subject (str): The subject of the email
            body (str): The body of the email
            recipients (str): Optional. Recipients of email.
        Return:
            None
    */
    WinActivate, Untitled - Message (HTML)
    WinWaitActive, Untitled - Message (HTML)

    Send, %recipients%{Tab}
    Send, %cc_recipients%{Tab}
    Send, %subject%{Tab}
    Send, %body%

    Return
}

; Hotstrings
; ==============================================================================
; Miscellaneous
:co:b1::BACKLOG 001!o

; Signature/Ticket Hotstrings
:co:ifq::If there are any questions, or if there is anything more we can do to help, please let us know.
:Xo:psig::SendLines(["Patrick McNally", "IP Technology Specialist 3", get_my_bhip_email()])

; Excel Hotstring
:co:xdate::yyyy/mm/dd hh:mm AM/PM

; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
