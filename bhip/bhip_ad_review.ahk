/*  These scripts and functions are no longer needed. This file is not loaded.

    This file exists as an archive.
*/

; Functions used in this module
; ==============================================================================
daily_auto_docket_review_code(elems) {
    for key, value in elems {
        Send, % value
        Send {Tab}
    }
}

get_input(fallback="") {
    /*  Function allows text to be entered (and shown on screen).
        text input will be finished by pressing {Space} or {Escape}.
    */
    input, in_text, V, {Space}{Escape},
    if (ErrorLevel = "EndKey:Escape") {
        Exit
    } else {
        ; If in_text is empty send the fallback. Othewise send nothing as in_text was already typed
        return, % ( in_text = "" ? fallback : "")
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
; Daily auto-docket review Hotstrings (Excel)
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
    elems := [get_input("{BACKSPACE}Misc codes"), "Document failed multiple rules. None of the tried p-codes are correct for this document.", "For this to work we would need to make a p-code for this specific document.", "Milena"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:expf::
    elems := [get_input(), "Document failed rule: Contains text ""TO EXPIRE 3 MONTHS""", "This is an OCR issue. The text was OCR'd as """ . Clipboard . """", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:finf::
    elems := ["US-62", "Document failed rule: Contains text ""MADE FINAL""", "This is not an OCR issue. The text ""Made final"" does not appear in the document. The final checkbox is checked.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:finof::
    elems := ["US-62", "Document failed rule: Contains text ""MADE FINAL""", "This is an OCR issue. The text ""Made final"" does appear in the document but was not OCR'd correctly.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:hostf::
    elems := [get_input(), "Document passed all rules. Docketing failed due to host not ready for docketing.", "This is usually due to missing value, missing completed value or other configuration issue.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:intf::
    elems := ["This is not an issue with auto-docketing. This should be reviewed by a docketer.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:multc::
    elems := ["", "Document passed all rules for multiple procedure codes.", "Auto-docketing unable to complete as it can't determing which procedure code to use. We need to make the rules more specific.", "Milena"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:multd::
    elems := [get_input(), "Document passed all rules. Auto-Docketing failed because multiple documents with the same name were received", "This is not an issue with auto-docketing. This should be reviewed by a docketer.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:multh::
    elems := [get_input(), "Document passed all rules. Docketing failed due to duplicate host activities found error", "This is not an issue with auto-docketing. This should be reviewed by a docketer.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:multm::
    elems := [get_input(), "Document failed rule: Multi-Matter Document Indentified.", "This is not an issue with auto-docketing. This should be reviewed by a docketer.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:oathf::
    elems := ["US-95", "Document failed rule: Annotation not match Oath or Declaration.", "This is an intentional failure. This is desired behaviour.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:ocrf::
    elems := ["This is an OCR issue. The text was OCR'd as """ . Clipboard . """", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:quef::
    elems := [get_input(), "Document passed all rules. Docket action set to Queued so document was not automatically docketed.", "This is not an error. Documents set to Queue are supposed to be reviewed before docketing.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:ratt::
    elems := [get_input(), "Document passed all rules. Docketing failed due to empty required attributes.", "We need to make/update an annotation to indentify and extract the following:", "Milena/Patrick"]
    daily_auto_docket_review_code(elems)
    edit_last()
    input, temp, V, {TAB}
    Send, {TAB}
    copy_num()
return

:co:techf::
    elems := [get_input(), "Document passed all rules. Document failed to docket due to a technical error.", "This is not an auto-docket issue. The error is intermittant and a rare event. We are looking into it.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:timeoutf::
    elems := [get_input(), "Document failed rule: Over Extended Pending Validation Time", "Matter is still pending validation. Item was removed from auto-docket after timeout window expired.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:transf::
    elems := ["US-95", "Document failed rule: PTO Trans History does not contain ""Mail Notice of Allowance""", "This is an intentional failure. This is desired behaviour.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:upf::
    elems := ["US-206", "Document failed rule: Not contains text ""UPDATED FILING RECEIPT""", "This code and document should both be reviewed.", "Milena/Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return

:co:valf::
    elems := [get_input(), "Document passed all rules. Docketing failed due to error validating application.", "This is not an issue with auto-docketing. This should be reviewed by a docketer.", "Docketer"]
    daily_auto_docket_review_code(elems)
    copy_num()
return
#IfWinActive  ; End Excel Hostrings
