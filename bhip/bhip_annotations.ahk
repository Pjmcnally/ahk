extract_pdf_text() {
    InputBox, ocr_dir, % "Input Folder", % "Please enter the input folder containing PDFs to extract:"
    if ErrorLevel
        Exit

    InputBox, text_dir, % "Output Folder", % "Please enter the output folder for text to be saved:"
    if ErrorLevel
        Exit
    IfNotExist, % txt_dir
        FileCreateDir, % txt_dir

    pdfs := ocr_dir . "\*.pdf"
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

rename_adobe_bookmarks() {
        /*  Renames bookmarks in Adobe Acrobat document. Replaces old with new.

        Args:
            None
        Return:
            None
    */
    InputBox, old, % "Text to change", % "Please enter the regex pattern to search for."
    if ErrorLevel
        Exit
    InputBox, new, % "Replacement Text", % "Please enter the replacment text. Leave blank to remove old text."
    if ErrorLevel
        Exit
    InputBox, num, % "Number?", % "Please enter the number of bookmarks to change. Hit enter to change all."
    if ErrorLevel
        Exit
    if (num = "") {  ; If num is empty set to arbitrarily large num.
        num = 10000000
    }

    WinActivate ahk_exe Acrobat.exe
    WinWait ahk_exe Acrobat.exe

    i = 0
    While(i < num) {
        Send, {F2}  ; f2 to edit bookmark
        Sleep, 100

        str := get_highlighted()  ; Get text of bookmark (highlighte dy default)
        new_str := RegExReplace(str, old, new)  ; Replace old with new
        paste_contents(new_str)  ; Paste new string.
        Send, {Enter}  ; Stop editing bookmark

        if (str = new_str) {
            Break
        } else {
            Sleep, 100
            Send, {Down}
            i += 1
        }
    }
}

; The two hotkeys below dynamically call timer_wrapper to avoid error at
; startup if timer_wrapper doesn't exist.
^+!e::
    extract_pdf_text()
return

^+!r::
    review_files()
return

^!a::
    rename_adobe_bookmarks()
return
