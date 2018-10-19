/*  Automate process of importing the UPDB
*/

; Classes
; ==============================================================================
class UpdbInterface {
    __New() {
        ; Create log viewer and log file
        This.BuildGui()
        This.logFilePath := This.LogGeneratePath()
        This.LogWriteStart()

        This.Log("--> Configuring settings")
        This.SetColors()
        This.SetWindowSize()
        This.SetImportButtonLocation()
        This.SetCustomers()

        ; ; Items to process
        ; This.customersThis.set_customer_names()
        ; This.Unprocessed := [17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
        ; This.Success := []
        ; This.Failed := []


    }

; CLEANED UP FUNCTIONS
; ==============================================================================
    BuildGui() {
        Static Console
        Gui, +AlwaysOnTop
        Gui, Add, Edit, ReadOnly x10 y10 w500 h500 vConsole
        Gui, Show, , test window
    }

    Log(str) {
        /*  Add log entry to log file. All entries are followed by a CRLF.
        */
        FileAppend, % str . "`r`n", % This.LogFilePath
        Control, EditPaste, % str . "`r`n", Edit1, test window
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

    SetColors() {
        /*  Set color variables used throughout script.
        */
        This.Colors := {}
        This.Colors.Background := 0xFFFFFF  ; Normal Background color (not loading)
        This.Colors.LogBackground := 0xEBEBEB  ; Background color of import log
        This.Colors.CheckBox := 0xFAF6F1
    }

    SetWindowSize() {
        /*  Gets and sets window size with logging.
        */
        This.Log("----> Getting window size...")
        This.window := This.FindWindowSize()
        This.Log("------> Window Width: " . This.window.width)
        This.Log("------> Window Height: " . This.window.height)
    }

    FindWindowSize() {
        /*  Activate and find the size of IE window.

        Returns:
            dict: A dictionary containing the following values:
                x: x coord of top left corner of window relative to system
                y: y coord of top left corner of window relative to system
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

    SetImportButtonLocation() {
        /*  Gets and sets import button location with logging.
        */
        This.Log("----> Finding import button...")
        This.import_button := This.FindImportButton()
        This.Log("------> Import button x: " . This.import_button.x)
        This.Log("------> Import button y: " . This.import_button.y)
    }

    FindImportButton() {
        /*  Find the location of the import button

        Returns:
            dict: A dictionary containing the following values:
                x: x coord of center of input button
                y: y coord of center of input button
        */
        import_button := {}  ; Create dict to store import_button attributes
        import_button.x := This.window.width - 100  ; Set x near left of screen
        temp_y_coord := This.window.height - 100  ; Set y near bottom of screen
        pixel_color := This.colors.background  ; Arbitrarily set pixel color to background

        ; From the bottom of the screen find the bottom of the import button.
        While (pixel_color = This.colors.background || pixel_color = This.colors.LogBackground) {
            If not WinActive("ahk_class IEFrame") {
                WinActivate, ahk_class IEFrame
                WinWaitActive, ahk_class IEFrame
            }
            temp_y_coord -= 10
            PixelGetColor, pixel_color, import_button.x, temp_y_coord
        }
        temp_bottom := temp_y_coord

        ; From the bottom of the import button find the top
        While (pixel_color != This.colors.background) {
            If not WinActive("ahk_class IEFrame") {
                WinActivate, ahk_class IEFrame
                WinWaitActive, ahk_class IEFrame
            }
            temp_y_coord -= 5
            PixelGetColor, pixel_color, import_button.x, temp_y_coord
        }
        temp_top := temp_y_coord

        ; Calculate vertical center of input button
        import_button.y := (temp_top + temp_bottom) // 2

        return import_button
    }

    SetCustomers() {
        This.Log("----> Finding Customers...")
        This.customers := This.FindCustomers()
        This.Log(Format("----> {1} customers found.", This.customers.Length()))
    }

    FindCustomers() {
        /*  Find customers by searching import page.

        Returns:
            array: Contains customer objects. Each object has the following info:
                short_name: The name of the customer
                x: The x value of the customers checkbox
                y: The y value of the customers checkbox
        */
        temp_y := 200  ; y value to start searching at.
        name_x := 300  ; x value of name column (doesn't seem to change)
        checkbox_x := 200  ; x value of checkbox column (doesn't seem to change)

        customers := []  ; Customers list to be be returned

        ; Search for checkboxes from top of screen while above import button
        while (temp_y < This.import_button.y) {
            PixelGetColor, pixel_color, checkbox_x, temp_y
            if (pixel_color = This.Colors.CheckBox) {
                ; When a checkbox is found build a customer dictionary
                new_customer := {}
                new_customer.short_name := This.GetCustomerName(name_x, temp_y)
                new_customer.x := checkbox_x
                new_customer.y := temp_y
                customers.push(new_customer)  ; Add customer to customers list

                this.Log(Format("------> Customer: {1}, Found At: {2}, {3}"
                    , new_customer.short_name
                    , new_customer.x
                    , new_customer.y))
            }
            temp_y += 1
        }

        Return customers
    }

    GetCustomerName(x, y) {
        /*  Get name of customer to import.

        ARGS:
            num (int): The number representing the customer (0-18)
        */
        ClipBoard := ""  ; Clear clipboard
        try_count := 0
        While (not ClipBoard and try_count < 5) {
            try_count += 1
            MouseClick, Left, x, y  ; Click in name box
            Sleep, 50  ; Brief pause to let click register

            Send, % "^c"  ; ctrl-c to copy contents of box
            ClipWait, 1  ; Wait up to 1 second for value.
        }

        return StrReplace(Clipboard, "`r`n")
    }



; ==============================================================================

    ClickImport() {
        /*  Click button to begin import.
        */
        MouseClick, Left, This.import_button.x, This.import_button.y
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
