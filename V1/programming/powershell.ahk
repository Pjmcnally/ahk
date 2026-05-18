/*  PowerShell functions, hotstrings, and hotkeys.
*/


; Functions
; ==============================================================================
diff_folders(src, dst) {
    /*  This script was a first attempt to make it easier to deploy a folder of
        PowerShell scripts to a network folder. This script would check for
        differences and then the sync_folder script would sync the folders.
        Both of these scripts were abandoned and Git was instead used to solve
        the problem of deployment.
    */

    ; PowerShell script to diff the files
    PsScript =
    (
        param($param1, $param2)

        $SrcCont = Get-ChildItem $param1 -File -Recurse | ForEach {Get-Content $_.FullName}
        $DstCont = Get-ChildItem $param2 -File -Recurse | ForEach {Get-Content $_.FullName}
        Compare-Object $SrcCont $DstCont > "C:\Users\Patrick\Documents\temp.txt"
    )

    ; Execute the PowerShell script. Diff results stored at C:\Users\Patrick\Documents\temp.txt
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
