; This ahk file contains the scripts that I use at BHIP.

; ------------------------------------------------------------------------------
; Functions used in this module

format_jira(str){
    ; This function formats text in JIRA recieved through email
    ; It's main purpose is to remove extra lines and {color} tags
    e_count := 0                                            ; Count of empty lines
    Loop, parse, str, `n, `r                                ; Loop over lines of str
    {
        string := RegExReplace(A_LoopField, "U){color.*}")  ; Remove all {color} tags
        string := RegExReplace(string, "\xA0+")             ; Remove all Non-breaking spaces
        string := Trim(string)                              ; Trim whitespace

        if (string) {                                       ; If there is a sting
            if (e_count > 1){                               ; That was preceeded by more than 1 empty line
                send {Enter}                                ; Add an empty line
            }
            Send {Raw}%string%                              ; Send this line
            Send {Enter}                                    ; Send newline
            e_count := 0                                    ; Set empty line count to 0
        } else {
            e_count += 1                                    ; Increment empty line count
        }
    }
}

; ------------------------------------------------------------------------------
; Hotstrings in this module

; Misc Hotstrings
:co:pinfo::Patrick{Tab}McNally{Tab}Pmcnally@blackhillsip.com{Tab}{Down}{Tab}{Tab}{Space}
:o:{c::{{}code{}}^v{{}code{}}
:co:b1::BACKLOG 001!o

; Signature/Ticket Hotstrings
:o:-p::--Patrick
:o:psig::Patrick McNally{Enter}DevOps Support{Enter}pmcnally@blackhillsip.com
:o:ppdone::This is resolved.{Enter 2}The database was updated to move the documents into "L" status.{Enter 2}The placeholder file was swapped in, xod files were created for each PDF in the JDS and the original file was restored.
:co:ifq::If there are any questions or there is anything more I can do to help please let me know.
^!f::
    Send ^a                     ; To select all
    clip_func("format_jira")    ; Run "format_jira" func on selected text
return

; SQL Hostrings
:o:bt::{/}{*}{ENTER}BEGIN TRAN{Enter 2}--commit{ENTER}ROLLBACK{ENTER}{*}{/}
