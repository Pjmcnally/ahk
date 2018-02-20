extract_pdf_text() {
    InputBox, base_dir, % "Run Folder", % "Please enter the folder location for the run to extract:"
    if ErrorLevel
        Exit

    ocr_dir := base_dir . "\ocr"
    pdfs := ocr_dir . "\*.pdf"

    txt_dir := base_dir . "\text"
    IfNotExist, % txt_dir
        FileCreateDir, % txt_dir

    total_count := ComObjCreate("Scripting.FileSystemObject").GetFolder(ocr_dir).Files.Count
    Progress, M2 R0-%total_count%, % "Files Done:`r`n0", % "Total Files: " . total_count, "Text Extaction"

    Loop, Files, % pdfs
    {
        Progress, %A_Index%, % "Reviewing File: " . A_Index "`r`n" . A_LoopFileName
        SplitPath, A_LoopFileFullPath, name, dir, ext, base_name
        out_file := txt_dir "\" base_name ".txt"
        save_pdf_as_text(A_LoopFileFullPath, out_file)
    }

    Progress, Off
}


save_pdf_as_text(in_file, out_file) {
    Run, % in_file
    Sleep, 300
    Send !fhmt  ; Key combination in Adobe to Save as plain text file.
    Sleep, 200
    Send, % out_file  ; Type new file name into save box
    Sleep, 200
    Send, {Enter}  ; Hit enter to save file
    Sleep, 100
    Send, y  ; Hit "y" to save over existing file (does nothing if no prompt)
    Sleep, 100
    Send, ^w  ; Close file
    Sleep, 100
}


review_files() {
    InputBox, rev_dir, % "Run folder", % "Please enter the folder location to review:"
    if ErrorLevel
        Exit
    InputBox, search_phrase, % "Search Phrase", % "Please enter the search phrase:"
    if ErrorLevel
        Exit

    IfNotExist, % rev_dir
        Exit  ; TODO: Add error message here.

    total_count := ComObjCreate("Scripting.FileSystemObject").GetFolder(rev_dir).Files.Count
    Progress, M2 R0-%total_count%, % "Files Done:`r`n0", % "Total Files: " . total_count, "File Review"

    ; TODO: Limit this loop so it only runs while Adobe is active window.
    ; Right now you have to be careful while using this not to change window focus.
    Loop, Files, % rev_dir "\*.pdf"
    {
        Progress, %A_Index%, % "Reviewing File: " . A_Index "`r`n" . A_LoopFileName
        Run, % A_LoopFileFullPath
        Sleep, 150
        Send, ^f
        Sleep, 150
        Send, %search_phrase% {Enter}
        KeyWait Space, D
        Send, ^w
        Sleep, 150
    }

    Progress, Off

    return
}


; The two hotkeys below dynamically call timer_wrapper to avoid error at
; startup if timer_wrapper doesn't exist.
^+!e::
    if IsFunc("timer_wrapper") {
        %timer_wrapper%("extract_pdf_text")
    } else {
        extract_pdf_text()
    }
return

^+!r::
    if IsFunc("timer_wrapper") {
        %timer_wrapper%("review_files")
    } else {
        extract_pdf_text()
    }
return
