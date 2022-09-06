class HadesInterface {
    ; Set general attributes
    static DateTimePattern := "yyyy-MM-dd_HHmmss"
    static DateTimeRegex := "\d{4}-\d{2}-\d{2}_\d{6}"
    static RootFolder := "Z:\Documents\Saved Games\"
    static SaveGameFolder := HadesInterface.RootFolder . "Hades"
    static BackupFolder := HadesInterface.RootFolder . "_Backup"

    __New() {
        logFilePath := this.RootFolder . "HadesInterfaceLog.txt"
        this.Log := New Logger(logFilePath)
        this.Log.Write("Initializing Hades Interface")
    }

    copyCurrentSaveToBackup() {
        this.Log.Write("--> Copying current save to backup")
        dest_fold_path := this.BackupFolder . "\Hades_" . f_date("", this.DateTimePattern)
        this.Log.Write("----> Copying " . this.SaveGameFolder . " to " . dest_fold_path)

        try {
            FileCopyDir, % this.SaveGameFolder, % dest_fold_path, True
            this.Log.Write("------> Copy Successful")
            this.playSound("Success")
        } catch e {
            this.Log.WriteError("Error occurred while copying files", e, true)
        }
    }

    moveCurrentSaveToTemp() {
        this.Log.Write("----> Moving current save to Temp")
        dest_fold_path := this.SaveGameFolder . "_Temp_" . f_date("", this.DateTimePattern)
        this.Log.Write("------> Copying " . this.SaveGameFolder . " to " . dest_fold_path)

        try {
            FileMoveDir, % this.SaveGameFolder, % dest_fold_path, R
        } catch e {
            this.Log.WriteError("Error occurred while moving files", e, true)
        }
    }

    restoreMostRecentSave() {
        this.Log.Write("--> Restoring Most Recent Save")
        IfWinExist, ahk_exe Hades.exe
        {
            this.Log.WriteError("Hades is running. Unable to proceed.", "", true)
            return
        }

        this.moveCurrentSaveToTemp()
        mostRecentFile := this.getMostRecentBackup()

        fullPath := this.BackupFolder . "\" . mostRecentFile
        this.Log.Write("----> Copying Backup From " . fullPath . " to " . this.SaveGameFolder)
        try {
            FileCopyDir, % fullPath, % this.SaveGameFolder, True
            this.playSound("Success")
        } catch e {
            this.Log.WriteError("Error occurred while copying files", e, true)
        }

        Sleep, 2000
        run steam://rungameid/1145360  ; Run Hades
    }

    getMostRecentBackup() {
        this.Log.Write("----> Getting most recent save from backup")
        mostRecentBackup :=

        regexPattern := "^Hades_" . this.DateTimeRegex . "$"
        Loop, Files, % this.BackupFolder . "\*", D
        {
            ; Filter to only folders that match the correct pattern
            if (RegExMatch(A_LoopFileName, regexPattern)) {
                this.Log.Write("------> Checking: " . A_LoopFileName)
                if (A_LoopFileName > mostRecentBackup) {
                    mostRecentBackup := A_LoopFileName
                }
            }
        }

        this.Log.Write("----> Most Recent Backup: " . mostRecentBackup)
        return mostRecentBackup
    }

    playSound(mode) {
        ; Magic numbers --> https://www.autohotkey.com/docs/commands/SoundPlay.htm
        if (mode == "Success") {
            SoundPlay, *48
        } else if (mode == "Error") {
            SoundPlay, *16
        } else {
            throw "Invalid mode"
        }
    }

    gunReload() {
        ; This used the keyboard binding instead of gamepad. Both work at the same time.
        KeyWait, Joy3

        Send, {r down}
        sleep 50
        Send, {r up}
    }
}

^!+b::hades.restoreMostRecentSave()
; Joy10::hades.restoreMostRecentSave()

#IfWinActive, ahk_exe Hades.exe
; Joy3::hades.gunReload()  ; Hestia - Shoot and reload
; Joy4::hades.gunReload()  ; Other guns - Special and reload
Joy10::hades.copyCurrentSaveToBackup()

#IfWinActive  ; Reset IfWinActive
