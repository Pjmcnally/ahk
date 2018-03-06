/*  This file contains one-off or temorary scripts that I don't use anymore but
    still want to archive.
*/

restore_win_defender_q() {
    /*  A large number of files were captures by windows defender. I wrote this
        script to check the checkbox for each one and save the data for that
        quarentined object.

        This was a one-off script to resolve a specific problem.
    */
    total := 0
    stop := GetKeyState("shift")

    While (!stop) {
        total += 1

        ; Get text content and write to file
        Send {Tab}
        Sleep, 100
        Send ^a
        Sleep, 200
        FileAppend, % get_highlighted(FALSE), C:\Users\Patrick\Desktop\WindowsDefenderQuarentine.txt
        FileAppend, `r`n`r`n, C:\Users\Patrick\Desktop\WindowsDefenderQuarentine.txt
        Sleep, 100
        Send +{Tab}

        ; Check and advance
        Send {Space}
        Sleep 100
        Send {Down}
        Sleep 100

        ; Get keystay to see if time to stop
        stop := GetKeyState("shift")
    }

    MsgBox, % total
}



diff_folders(src, dst) {
    /*  This script was a first attempt to make it easier to deploy a folder of
        PowerShell scripts to a network folder. This script would check for
        differences and then the sync_folder script would sync the folders.
        Both of these scripts were abandoned and Git was instead used to solve
        the problem of deployment.
    */

    ; Powershell script to diff the files
    PsScript =
    (
        param($param1, $param2)

        $SrcCont = Get-ChildItem $param1 -File -Recurse | ForEach {Get-Content $_.FullName}
        $DstCont = Get-ChildItem $param2 -File -Recurse | ForEach {Get-Content $_.FullName}
        Compare-Object $SrcCont $DstCont > "C:\Users\Patrick\Documents\temp.txt"
    )

    ; Execute the Pshell script. Diff results stored at C:\Users\Patrick\Documents\temp.txt
    RunWait PowerShell.exe -Command &{%PsScript%} '%src%' '%dst%',, hide

    ; Reads results. Notifies if differences found or not.
    FileRead, f_cont, C:\Users\Patrick\Documents\temp.txt
    if (f_cont) {
        MsgBox, % "Comparing " . src . " with " . dst . "`r`n`r`nDifferences Found."
        Run C:\Users\Patrick\Documents\temp.txt
    } else {
        MsgBox, % "Comparing " . src . " with " . dst . "`r`n`r`nNo differences Found."
        FileDelete, C:\Users\Patrick\Documents\temp.txt
    }
}

sync_folders(src, dst) {
    /*  This script was a first attempt to make it easier to deploy a folder of
        PowerShell scripts to a network folder. This would sync the folders.
        Both of these scripts were abandoned and Git was instead used to solve
        the problem of deployment.
    */

    ; Copy folder from src to dev
    FileCopyDir, % src, % dst, 1  ; 1 flag = overwrite files
    MsgBox, % "Files Copied from " . src . " to " . dst . " ."
}
