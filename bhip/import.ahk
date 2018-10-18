/*  Automate process of importing the UPDB
*/

; Classes
; ==============================================================================
class UpdbInterface {
    __New() {
        ; Create log file
        This.logFilePath := This.LogGeneratePath()
        This.LogWriteStart()

        This.Log("--> Configuring settings")
        This.Background := 0xFFFFFF  ; Normal Background color (not loading)

        This.Log("----> Getting window size...")
        This.window := This.FindWindowSize()

        This.Log("----> Finding import button...")
        ; This.import_button := This.FindImportButton()

        This.Log("----> Finding check box and name columns...")
        ; This.columns := This.FindColumns()

        ; ; Items to process
        ; This.customersThis.set_customer_names()
        ; This.Unprocessed := [17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
        ; This.Success := []
        ; This.Failed := []

        ; ; Coordinates of checkboxes and names
        ; This.columns := {}
        ; This.columns.y := 300
        ; This.columns.y_interval := 31
        ; This.columns.checkbox_x := 220
        ; this.columns.name_x := 325

        ; ; Coordinates of import button
        ; This.import_button := {}
        ; This.import_button.x := 2475
        ; This.import_button.y := This.FindImportButtonY()
        ; MouseMove, This.Import_button.x, This.Import_button.y
    }

; CLEANED UP FUNCTIONS
; ==============================================================================
    FindWindowSize() {
        /*  Activate and find the size of IE window.

        Returns:
            dict: A dictionary containing the following values:
                x: X coord of top left corner of window relative to system
                y: X coord of top left corner of window relative to system
                width: Width of window in pixels
                height: Height of window in pixes
        */
        WinActivate, ahk_class IEFrame
        WinWaitActive, ahk_class IEFrame
        WinGetPos, x, y, w, h, A  ; A for active window

        res_hash := {}
        res_hash.x := x
        res_hash.y := y
        res_hash.width := w
        res_hash.height := h

        Return res_hash
    }


    Log(str) {
        /*  Add log entry to log file. All entries are followed by a CRLF.
        */
        FileAppend, % str, % This.LogFilePath
        FileAppend, % "`r`n", % This.LogFilePath
    }

    LogGeneratePath() {
        /*  Create log file path.

        Returns:
            str: Path to log file location.
        */
        file_name := Format("{1}\UpdbImportLog_{2}-{3}-{4}.txt", A_Desktop, A_YYYY, A_MM, A_DD)

        Return file_name
    }

    LogWriteStart() {
        /*  Write opening line to log file
        */
        FormatTime, timeStr, , yyyy-MM-dd HH:mm
        This.Log(Format("Running UPDB Import starting at {1}", timeStr))
    }




; ==============================================================================
    FindImportButton() {
        temp_y_coord := 1350
        dot_color := This.Background

        ; From the bottom of the screen find the bottom of the import button.
        While (dot_color = This.Background) {
            temp_y_coord -= 10

            MouseMove, This.Import_button.x, temp_y_coord
            Sleep, 500
            MouseMove, 100, 100
            Sleep, 200

            PixelGetColor, dot_color, This.import_button.x, temp_y_coord
        }
        import_bottom := temp_y_coord
        MsgBox, % import_bottom

        ; From the bottom of the import button find the top
        While (dot_color != This.Background) {
            temp_y_coord -= 5
            PixelGetColor, dot_color, This.import_button.x, temp_y_coord
        }
        import_top := temp_y_coord

        MsgBox, % import_top
        ; Return import_button_y to midpoint of top and bottom
        Return (import_top + import_bottom) // 2
    }

    ClickImport() {
        /*  Click button to begin import.
        */

        live_import_button_y := 865
        test_import_button_y := 650

        MouseClick, Left, import_button_x, test_import_button_y
    }

    CheckBox(num) {
        /*  Check the box for a specified item.

        ARGS:
            num (int): The number representing the item (0-18)
        */
        x := This.columns.checkbox_x
        y := This.columns.y + (num * This.columns.y_interval)

        ; Click checkbox
        MouseClick, Left, x, y
    }

    GetName(num) {
        /*  Get name of customer being imported.

        ARGS:
            num (int): The number representing the customer (0-18)
        */
        x := This.columns.name_x
        y := This.columns.y + (num * This.columns.y_interval)

        MouseClick, Left, x, y  ; Click in name box
        Sleep, 500

        Send, % "^c"  ; ctrl-c to copy contents of box
        Sleep, 1000

        return Clipboard
    }

    WaitForImport() {
        /*  Wait for import to complete. Use color of screen to determine state.
        */
        importing := True
        while importing {
            Sleep, 2500
            WinActivate ahk_exe iexplore.exe

            PixelGetColor, dot_color, 50, 1300
            if (dot_color = This.Background) {
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
        customer := This.GetName()
        item_checked := False  ; Assume item not checked
        success := False
        try_count := 0

        This.Log(Format("Importing item number {1}. Customer: {2}", item, customer))
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
                This.Success.Push(customer)
            } else if (try_count <= 5) {
                This.Log(Format("Item Failed: Try count at {1}", try_count))
                This.Log("Retrying Item`r`n")
            } else {
                This.Log("Item has failed 5 times. Abandoning item`r`n`r`n")
                This.Failed.Push(customer)
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

; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
^!i::
    KeyWait, ctrl, L
    KeyWait, alt, L

    updb := New UpdbInterface
    ; updb.MainLoop()
return
