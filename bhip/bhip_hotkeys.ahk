; Misc Hotstrings for BHIP tickets
:co:ifq::If there are any questions or there is anything more I can do to help please let me know.
:o:{c::{{}code{}}^v{{}code{}}
:o:-p::--Patrick
:o:ppdone::This is resolved.{Enter 2}Karl ran the SQL to update the status in the database.{Enter 2}I swapped out the file with the password protected file, created the xod file, and then swapped the files back.

; Hostrings for various hosts
:co:pinfo::Patrick{Tab}McNally{Tab}Pmcnally@blackhillsip.com{Tab}{Down}{Tab}{Tab}{Space}

; Misc Text Hotstrings
:co:b1::BACKLOG 001!o

^!u::
    ; This doesn't seem to be working consistantly.  Work on this.
    ClipSaved := ClipboardAll           ; Save the entire clipboard to a variable of your choice.
    Clipboard =                         ; Empty clipboard

    Send ^c                             ; Copy highlight text to clipboard
    ClipWait                            ; Wait for clipboard to contain text
    StringUpper, up_clip, Clipboard     ; StringUpper contents of clipboard
    Send, %up_clip%                     ; Send upper case string 

    Clipboard := ClipSaved              ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
    ClipSaved =                         ; Free the memory in case the clipboard was very large.
Return
