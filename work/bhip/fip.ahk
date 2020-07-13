upload_fip_reports() {
    /* Uploads reports to FIP host systems
    */

    reportList := get_fip_report_list()  ; Local function to hide report info.
    for i, r in reportList {
        check_fip_report(r)
        ifMsgBox Yes
        {
            upload_fip_report(r)
        }
        ifMsgBox Cancel
        {
            return false
        }
    }

    MsgBox, % "Process Complete"
}

upload_fip_report(report_filename) {
    default_wait := 500
    name := get_report_name(report_filename)
    Sleep, % default_wait

    SendWait("{Tab 8}", default_wait)  ; Navigate to Import Report drop down
    SendWait("{down 2}", default_wait)  ; Select "Import Report"
    SendWait("{Tab}", default_wait)  ; Hit "Tab" to select option
    SendWait("{Tab}", default_wait)  ; Hit "Tab" to navigate to "Go" button
    SendWait("{Space}", 2000)  ; Hit "Go" button
    ClickWait("{Space}" default_wait)  ; Open file selection window
    WinWaitActive Open  ; Wait for file selection window to be active
    Sleep, default_wait
    SendWait(report_filename, default_wait)  ; Enter file name
    SendWait("{Enter}", 1000)  ; Enter to confirm file name
    WinWaitActive ahk_exe chrome.exe ; Wait for chrome to be available again
    SendWait("{Tab}", default_wait)  ; navigate to "Import" button
    SendWait("{Enter}", 2000)  ; Engage "Import" button
    ClickWait(225, 855, 1, 1000)  ; Click to enter report
    ClickWait(1750, 485, 1, 1000)  ; Click to enter "Sharing"
    MsgBox, 4096, % "Security Exempt", % "Set security exempt and return to Reports Manager screen.`r`n`r`nClick when ready to proceed"
}

check_fip_report(report_filename) {
    default_wait := 500
    name := get_report_name(report_filename)

    WinActivate IP Management for the Extended Enterprise - Google Chrome
    WinWaitActive IP Management for the Extended Enterprise - Google Chrome, , 2

    Sleep, 1000
    ClickWait(300, 500, 2, default_wait)
    SendWait("^a", default_wait)
    SendWait(name, default_wait)
    SendWait("{Enter}", default_wait)
    MsgBox, 3, % "Check Report", % "Ready to upload report: " . name . "`r`n`r`nDoes this report need to be uploaded?"
}

get_report_name(report_filename) {
    return RegExReplace(report_filename, "\.[Zz]ip")
}

update_fip_password_loop(){
    /*  Add docstring
    */
    Input, num, L1 T3, {Tab}{Enter}{Space}
    If num is not Integer
        Return

    Send, ^v
    if (num != 0) {
        Send, %num%
    }
    Send, {Tab}

    if (num = 5) {
        num := ""
    } else {
        num += 1
    }
    Send, ^v
    Send, %num%{Tab}
    Send, ^v
    Send, %num%{Tab}
}


; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
^!p::  ; Ctrl-Alt-p
    update_fip_password_loop()
return

^!+u::  ; Ctrl-Alt-Shift-U
    upload_fip_reports()
Return
