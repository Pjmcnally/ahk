/*  This file contains one-off or temporary scripts that I don't use anymore but
    still want to archive.
*/

restore_win_defender_q() {
    /*  A large number of files were captures by windows defender. I wrote this
        script to check the checkbox for each one and save the data for that
        quarantined object.

        This was a one-off script to resolve a specific problem.
    */
    total := 0
    stop := GetKeyState("shift")

    While (!stop) {
        total += 1

        ; Get text content and write to file
        SendWait("{Tab}", 100)
        SendWait("^a", 200)
        FileAppend, % get_highlighted(FALSE), C:\Users\Patrick\Desktop\WindowsDefenderQuarantine.txt
        FileAppend, `r`n`r`n, C:\Users\Patrick\Desktop\WindowsDefenderQuarantine.txt
        Sleep, 100
        Send +{Tab}

        ; Check and advance
        SendWait("{Space}", 100)
        SendWait("{Down}", 100)

        ; Get key state to see if time to stop
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

sync_folders(src, dst) {
    /*  This script was a first attempt to make it easier to deploy a folder of
        PowerShell scripts to a network folder. This would sync the folders.
        Both of these scripts were abandoned and Git was instead used to solve
        the problem of deployment.
    */

    ; Copy folder from source to destination
    FileCopyDir, % src, % dst, 1  ; 1 flag = overwrite files
    MsgBox, % "Files Copied from " . src . " to " . dst . " ."
}

click_the_button() {
    x := 1438
    y := 473
    PixelGetColor, OutputVar, x, y

    CRLF := "`r`n"

    FormatTime, now, , % "yyyy-MM-dd HH:mm:ss"
    FileAppend, % CRLF . now . " Pixel Color: " . OutputVar, % "C:\Users\Patrick\Desktop\clicked.txt"

    if (OutputVar = 0x4B4B4B) {
        FileAppend, % CRLF . now . " --> Clicking Button.", % "C:\Users\Patrick\Desktop\clicked.txt"
        TrayTip, % "Click", % "Clicking Button", ,

        Click x, y
    }
}