/*  Core file functions.

This module contains core file functions that are used by other modules.
This file should also be loaded as other files may fail to load without it.
*/

; Functions
; ==============================================================================
sort_files() {
    /*  Sorts files into a "left" and "right" folder.

        Source, Left and Right folder are provided through input boxes. Each
        file in the Source folder will be run. Press the left or right arrow
        key to move into the corresponding folder.
    */
    InputBox, rev_dir, % "Run folder", % "Please enter the folder location to sort:"
    if ErrorLevel
        Exit
    IfNotExist, % rev_dir
        Exit  ; TODO: Add error message here.

    InputBox, left_fold, % "Left Folder", % "Please enter the LEFT folder:"
    if ErrorLevel
        Exit
    IfNotExist, % left_fold
        Exit  ; TODO: Add error message here.

    InputBox, right_fold, % "Right Folder", % "Please enter the RIGHT folder:"
    if ErrorLevel
        Exit
    IfNotExist, % right_fold
        Exit  ; TODO: Add error message here.


    total_count := ComObjCreate("Scripting.FileSystemObject").GetFolder(rev_dir).Files.Count
    Progress, M2 R0-%total_count%, % "Files Done:`r`n0", % "Total Files: " . total_count, "Sorting Files"

    Loop, Files, % rev_dir "\*.*"
    {
        Progress, %A_Index%, % "Sorting File: " . A_Index "`r`n" . A_LoopFileName

        Run, % A_LoopFileFullPath
        Sleep, 150

        dest := ""
        while (not dest) {
            Sleep, 10
            if (GetKeyState("Left") = 1) {
                dest := left_fold
                break
            }
            if (GetKeyState("Right") = 1) {
                dest := right_fold
                break
            }
        }

        Send, ^w
        Sleep, 150

        FileMove, % A_LoopFileFullPath, % dest
    }

    Progress, Off

    Return
}
