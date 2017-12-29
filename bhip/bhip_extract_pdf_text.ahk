save_as_text() {
    in_dir := "C:\Users\Patrick\Desktop\ocr"
    out_dir := "C:\Users\Patrick\Desktop\text"

    Loop, Files, % in_dir "\*.pdf"
    {
        content := get_text(A_LoopFileFullPath)
        out_file := make_new_filename(out_dir, A_LoopFileName, ".txt")
        write_output(out_file, content)
    }
}


make_new_filename(dir, basename, new_ext) {
    new_filename := dir "\" basename
    new_filename := RegExReplace(new_filename, "\..*", new_ext)
    return new_filename
}


get_text(file_path) {
    ; This is a clunky way to get text from a while.
    Run, % file_path
    Sleep, 500
    Send ^a
    Sleep, 500
    Send ^c
    Sleep, 3000
    WinClose, ahk_exe Acrobat.exe
    Sleep, 500

    return Clipboard
}


write_output(file, content) {
    f := FileOpen(file, "w")
    f.write(content)
    f.close()
}


review_files() {
    InputBox, in_dir, "Directory", "Enter directory..."
    if ErrorLevel
        Exit
    InputBox, search_phrase, "Search Phrase", "Enter Search Phrase"
    if ErrorLevel
        Exit

    total_count := ComObjCreate("Scripting.FileSystemObject").GetFolder(in_dir ).Files.Count
    Progress, M2 R0-%total_count%, % "Files Done:`r`n0", % "Total Files: " . total_count, "File Review"

    ; TODO: Limit this loop so it only runs while Adobe is active window.
    ; Right now you have to be careful while using this not to change window focus.
    Loop, Files, % in_dir "\*.pdf"
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

^+!p::
    save_as_text()
return

^+!r::
    timer_wrapper("review_files")
return
