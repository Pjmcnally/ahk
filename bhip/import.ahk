/*  Automate process of importing the UPDB
*/

; Classes
; ==============================================================================
class UpdbInterface {
    __New() {
        ; Items to process
        This.Unprocessed := [17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1] ; , 0]
        This.Success := []
        This.Failed := []

        ; Create log file
        This.CreateLogFile()
    }

    Log(str) {
        /*  Add log entry to log file. All entries are followed by a CRLF.
        */
        CRLF := "`r`n"
        FileAppend, % str, % This.LogFilePath
        FileAppend, % CRLF, % This.LogFilePath
    }

    CreateLogFile() {
        /*  Create or get log file and save location as attribute of object.
        */
        base_path := "C:\Users\Patrick\Desktop\"
        file_name := Format("{1}UpdbImportLog_{2}-{3}-{4}.txt", base_path, A_YYYY, A_MM, A_DD)

        This.LogFilePath := file_name
    }

    ClickImport() {
        /*  Click button to begin import.
        */
        MouseClick, Left, 2475, 865
    }

    CheckBox(num) {
        /*  Check the box for a specified item.

        ARGS:
            num (int): The number representing the item (0-18)
        */
        ; x coordinate of checkbox column
        x := 220

        ; y coordinate of item to check (calculated from given num)
        base_y := 300
        y_interval := 31
        y := base_y + (num * y_interval)

        ; Click checkbox
        MouseClick, Left, x, y
    }

    WaitForImport() {
        /*  Wait for import to complete. Use color of screen to determine state.
        */
        importing := True
        while importing {
            Sleep, 2500
            WinActivate ahk_exe iexplore.exe

            PixelGetColor, dot_color, 50, 1300
            if (dot_color = 0xFFFFFF) {
                importing := False
            }
        }
    }

    Import(item) {
        /*  Import specified item.

        ARGS:
            item (int): The number corresponding to a checkbox counting from the
            top down.
        */
        item_checked := False  ; Assume item not checked
        success := False
        try_count := 0


        This.Log(Format("Importing item number {1}", item))
        This.Log("============================================================")
        While (not success and try_count < 5) {
            try_count += 1
            if (not item_checked) {  ; After a failure item remains checked
                This.CheckBox(item)
                item_checked := True
            }
            This.ClickImport()
            This.WaitForImport()
            success := this.CheckResults()

            if success {
                This.Log("Item Succeeded`r`n`r`n")
                This.Success.Push(item)
            } else if (try_count <= 5) {
                This.Log(Format("Item Failed: Try count at {1}", try_count))
                This.Log("Retrying Item`r`n")
            } else {
                This.Log("Item has failed 5 times. Abandoning item`r`n`r`n")
                This.Failed.Push(item)
                This.CheckBox(item)  ; To uncheck the item.
            }
        }
    }

    CheckResults() {
        /*  Check the results of am import run.

        RETURNS:
            (bool): Boolean referring to success of import run.
        */
        pattern := "FINISHED: [1] Items Processed - [1] Successful, [0] Errors"
        res := This.GetResults()
        This.Log(res)

        return InStr(res, pattern) > 0
    }

    GetResults() {
        /*  Get results string by copying contents of output box of import.
        */
        try_count = 0
        res := ""

        While (not res) {
            MouseClick, Left, 1000, 1000  ; Click in results box
            Sleep, 200

            Send, % "^a"  ; ctrl-a to select all text
            Sleep, 200

            if (try_count < 5) {
                ; True to persist clipboard, False to not skip error if no text
                res := get_highlighted(persist:=True, e:=False)
                try_count += 1
            } else {
                res := "ERROR: Unable to extract results"
            }
        }

        return res
    }

    MainLoop() {
        /*  Import all items when executed. Log final results.
        */
        While (This.Unprocessed.Length() > 0) {
            This.Import(This.Unprocessed.Pop())
        }

        This.log("`r`nThe following items were successfully imported:")
        For item, value in This.Succeeded {
            This.Log(value)
        }

        This.log("`r`nThe following items failed and were not imported:")
        For item, value in This.Failed {
            This.Log(value)
        }
    }
}

#IfWinActive ahk_exe iexplore.exe

; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
^!i::
    updb := New UpdbInterface
    updb.MainLoop()
return

#IfWinActive
