get_choice(title, prompt, array) {
    /*  Takes and array. Returns an element of the array chosen by the user.
    */

    Static format_choice := % ""

    ; Build string of choices from array
    l_box_string := ""
    For index, elem in array {
        l_box_string := l_box_string . elem . "|"
    }

    ; Build Gui to take user choice
    Gui, choice:New,, % title
    Gui, choice:Font, s12
    Gui, choice:Add, Text, , % prompt
    Gui, choice:Add, ListBox, x25 y+10  vformat_choice, % l_box_string
    Gui, choice:Add, Button, x35 y+20 gButtonOk, OK
    Gui, choice:Add, Button, x+65 gButtonCancel, Cancel
    Gui, choice:Show, ,

    ; Wait for response return if received else error.
    WinWaitClose, % title
    if (format_choice) {
        return format_choice
    } else {
        ErrorLevel = 1
        return
    }

    ; Button handlers
    buttonOk:
        Gui Submit
    choiceGuiClose:
    ButtonCancel:
        Gui Destroy
    return
}


convert_pdf() {
    base_delay = 250  ; Do not set below 100
    format_map := {"Text": "!fhmt", "Jpeg": "!fhij"}
    formats := []
    for key, value in format_map
        formats.Push(key)

    ; Get inputs
    choice := get_choice("Output Format", "Please select desired output format:", formats)
    if ErrorLevel
        Exit

    InputBox, ocr_dir, % "Input Folder", % "Please enter the input folder containing PDFs to convert:"
    if ErrorLevel
        Exit

    InputBox, txt_dir, % "Output Folder", % "Please enter the output folder for converted files:"
    if ErrorLevel
        Exit
    IfNotExist, % txt_dir
        FileCreateDir, % txt_dir


    ; Process PDF's
    pdfs := ocr_dir . "\*.pdf"
    total_count := ComObjCreate("Scripting.FileSystemObject").GetFolder(ocr_dir).Files.Count
    Progress, M2 R0-%total_count%, % "Files Done:`r`n0", % "Total Files: " . total_count, "Text Extaction"

    Loop, Files, % pdfs
    {
        Progress, %A_Index%, % "Extracting File: " . A_Index "`r`n" . A_LoopFileName
        SplitPath, A_LoopFileFullPath, name, dir, ext, base_name
        out_file := txt_dir "\" base_name ".txt"
        save_pdf_as(A_LoopFileFullPath, out_file, base_delay, format_map[choice])
    }

    Progress, Off
}


save_pdf_as(in_file, out_file, base_delay, format_string) {
    Run, % in_file
    Sleep, % (base_delay + 200)
    Send, % format_string  ; Key combination in Adobe to Save as specified format.
    Sleep, % (base_delay + 100)
    Send, % out_file  ; Type new file name into save box
    Sleep, % (base_delay + 100)
    Send, {Enter}  ; Hit enter to save file
    Sleep, % base_delay
    Send, y{Enter}  ; Hit "y" to save over existing file or close other prompt
    Sleep, % base_delay
    Send, ^w  ; Close file
    Sleep, % base_delay
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


paste_as_sql_list() {
    raw_str := Trim(Clipboard, "`r`n`t")
    array := StrSplit(raw_str, "`n", "`r")
    str := ""

    Loop, % array.MaxIndex()
    {
        str := str . "'" . array[A_Index] . "'"
        if (A_Index < (array.MaxIndex())) {
            str := str . ",`r`n"
        }
    }
    paste_contents(str)

    return
}

; The two hotkeys below dynamically call timer_wrapper to avoid error at
; startup if timer_wrapper doesn't exist.
^+!e::
    convert_pdf()
return

^+!r::
    review_files()
return

^!a::
    rename_adobe_bookmarks()
return

^+!l::
    paste_as_sql_list()
return
