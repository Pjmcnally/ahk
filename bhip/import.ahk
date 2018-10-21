/*  Automate process of importing the UPDB
*/

; Classes
; ==============================================================================
class UpdbInterface {
    __New() {
        /*  Create new UpdbInterface Instance. Build GUI and prepare log file.
        */
        This.BuildGui()
        This.logFilePath := This.LogGeneratePath()
        This.LogWriteStart()
        This.PreCheck()
    }

    __Configure() {
        /*  Configure UpdbInterface for import run.
        */
        GuiControl, Hide, _button
        This.Log("`r`nConfiguring settings")
        This.Log("====================")
        This.UpdateStatus("Configuring Settings...")
        This.SetColors()
        This.SetWindowSize()
        This.SetCustomers()
        This.SetImportButtonLocation()
    }

    __PrepareImport() {
        /*  Prepare for Import run and wait for user input to begin.
        */
        This.UpdateProgressBar(0)
        This.Log("`r`nPlease select the customers you wish to import in this UI.")
        This.Log(">> Click 'Import' to begin.")
        This.UpdateStatus("Waiting for User...")
        GuiControl, , _button, Import
        GuiControl, Show, _button
    }

    __ImportLoop() {
        /*  Import all items when executed. Log final results.
        */
        GuiControl, Hide, _button
        For index, customer in This.customers {
            ; Check if row is checked and if yes import.
            next_row_checked := LV_GetNext(index - 1 , "Checked" )
            if (next_row_checked = index) {
                This.Import(customer)
            } else {
                This.Log(Format("`r`nSkipping Customer: {1}`r`n", customer.short_name))
                customer.status := "Skip"
            }

            ; Update UI to show status and increase progress bar
            LV_Modify(index, , , customer.status, customer.short_name)
            This.UpdateProgressBar(index / This.customers.MaxIndex() * 100)
        }

        This.UpdateStatus("Importing Complete. Posting Results.")
        This.log("`r`nThe following items were successfully imported:")
        For index, customer in This.customers {
            if customer.status = "Done" {
                This.Log(customer.short_name)
            }
        }

        This.log("`r`nThe following items failed and were not imported:")
        For index, customer in This.customers {
            if customer.status = "Fail" {
                This.Log(customer.short_name)
            }
        }

        This.log("`r`nThe following items were skipped and were not imported:")
        For index, customer in This.customers {
            if customer.status = "Skip" {
                This.Log(customer.short_name)
            }
        }
    }

    BuildGui() {
        Global current_action   ; I really hate Global but am not sure how to do it otherwise
        Global prog_bar         ; I really hate Global but am not sure how to do it otherwise
        Global _button          ; I really hate Global but am not sure how to do it otherwise
        Static customer_list
        Static log_window
        Gui, updb_gui:New, +AlwaysOnTop, UPDB Import Helper
        Gui, updb_gui:Font, underline s12
        Gui, updb_gui:Add, Text, x10 y10 w200, % "Current action: "
        Gui, updb_gui:Add, Text, x220 y10, % "Current Progress:"
        Gui, updb_gui:Font,  ; Reset font
        Gui, updb_gui:Add, Text, x10 y35 r3 w200 vCurrent_action,
        Gui, updb_gui:Add, Progress, x220 y35 w500 h40 cGreen BackgroundWhite +border vProg_bar
        Gui, updb_gui:Add, ListView, x10 y80 w200 h500 Grid Checked vCustomer_list, Import|Status|Name
        Gui, updb_gui:Add, Edit, ReadOnly x220 y80 w500 h500 vLog_window
        Gui, updb_gui:Add, Button, Default x10 w200 v_button gButtonAction, Ready
        Gui, updb_gui:Show
    }

    UpdateStatus(str) {
        GuiControl, , current_action, % str
    }

    UpdateProgressBar(num) {
        GuiControl, , prog_bar, % num
    }

    Log(str) {
        /*  Add log entry to log file. All entries are followed by a CRLF.
        */
        FileAppend, % str . "`r`n", % This.LogFilePath
        Control, EditPaste, % str . "`r`n", Edit1, UPDB Import Helper
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

    PreCheck() {
        This.UpdateStatus("Waiting for User...")
        This.Log("`r`nUser Setup:")
        This.log("====================")
        This.log("Before beginning please move the GUI so it is not covering IP Tools.")
        This.log("Please ensure that you are on the UPDB import screen in IP Tools.")
        This.log("Please ensure that no customers are currently checked in IP Tools.")
        This.log(">> Click 'Ready' when ready to proceed.")
    }

    SetColors() {
        /*  Set color variables used throughout script.
        */
        This.colors := {}
        This.colors.background := "0xFFFFFF"  ; Normal background color (not loading)
        This.colors.log_background := "0xEBEBEB"  ; Background color of import log
        This.colors.checkbox := "0xFAF6F1"
    }

    SetWindowSize() {
        /*  Gets and sets window size with logging.
        */
        This.Log("Getting window size...")
        This.window := This.FindWindowSize()
        This.Log("--> Window Width: " . This.window.width)
        This.Log("--> Window Height: " . This.window.height)
        This.Log("--> Window Title: " . This.Window.title)
    }

    FindWindowSize() {
        /*  Activate and find the size of IE window.

        Returns:
            dict: A dictionary containing the following values:
                x: x coord of top left corner of window relative to system
                y: y coord of top left corner of window relative to system
                width: Width of window in pixels
                height: Height of window in pixes
                title: Window Title
        */
        WinActivate, ahk_class IEFrame
        WinWaitActive, ahk_class IEFrame
        WinGetPos, x, y, w, h, A  ; A for active window
        WinGetActiveTitle, title

        res_hash := {}
        res_hash.x := x
        res_hash.y := y
        res_hash.width := w
        res_hash.height := h
        res_hash.title := title

        Return res_hash
    }

    SetCustomers() {
        This.Log("Finding Customers...")
        This.customers := This.FindCustomers()
        This.Log(Format("--> {1} customers found.", This.customers.Length()))
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
        while (temp_y < This.window.height) {
            PixelGetColor, pixel_color, checkbox_x, temp_y
            if (pixel_color = This.Colors.CheckBox) {
                ; When a checkbox is found build a customer dictionary
                new_customer := {}
                new_customer.short_name := This.GetCustomerName(name_x, temp_y)
                new_customer.x := checkbox_x
                new_customer.y := temp_y
                customers.push(new_customer)  ; Add customer to customers list

                LV_Add("Check", , , new_customer.short_name)
            }
            temp_y += 1
            This.UpdateProgressBar(temp_y/This.window.height * 100)
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
            This.ClickLocation(x, y)  ; Click in name box
            Sleep, 50  ; Brief pause to let click register

            Send, % "^c"  ; ctrl-c to copy contents of box
            ClipWait, 1  ; Wait up to 1 second for value.
        }

        return StrReplace(Clipboard, "`r`n")
    }

    SetImportButtonLocation() {
        /*  Gets and sets import button location with logging.
        */
        This.Log("Finding import button...")
        This.import_button := This.FindImportButton()
        This.Log("--> Import button x: " . This.import_button.x)
        This.Log("--> Import button y: " . This.import_button.y)
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

        last_customer := This.customers[This.customers.MaxIndex()]
        import_button.y := last_customer.y + 40

        return import_button
    }

    WaitForImport() {
        /*  Wait for import to complete. Use color of screen to determine state.
        */
        ; Check a specific spot for color change
        ; Spot is 100 pixels to the left of the import button
        spot_x := This.import_button.x - 100
        spot_y := This.import_button.y
        pause_interval := 2500

        importing := True
        while importing {
            Sleep, pause_interval
            WinActivate, % This.window.title

            PixelGetColor, pixel_color, spot_x, spot_y
            if (pixel_color = This.colors.background) {
                importing := False
            }
        }
    }

    Import(customer) {
        /*  Import specified item.

        ARGS:
            item (dict): An object containing customer attributes and info.
        */
        ; Setup new customer attributes
        customer.is_checked := False  ; Assume checkbox is not checked
        customer.success := False
        customer.try_count := 0

        This.UpdateStatus("Importing: " . customer.short_name)
        This.Log(Format("`r`nImporting Customer: {1}", customer.short_name))
        This.Log("============================================================")
        While (not customer.success and customer.try_count <= 5) {
            customer.try_count += 1
            if (not customer.is_checked) {  ; After a failure item remains checked
                This.ClickLocation(customer.x, customer.y)
                customer.is_checked := True
            }

            ; Start import and wait for import to finish
            This.ClickLocation(This.import_button.x, This.import_button.y)
            This.WaitForImport()
            This.Log("Import Complete. Checking results...")

            ; Check Import results and act accordingly.
            customer.success := this.CheckResults()
            if customer.success {
                This.Log(customer.short_name . " import successful`r`n`r`n")
                customer.status := "Done"
            } else if (customer.try_count <= 5) {
                This.Log(Format("Import failed {1} times. Retrying {2}`r`n", customer.try_count, customer.short_name))
            } else {
                This.ClickLocation(customer.x, customer.y)  ; To uncheck the customer.
                This.Log(Format("Import failed 5 times. Abandoning {1}`r`n`r`n", customer.short_name))
                customer.status := "Fail"
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
            x := This.import_button.x
            y := This.import_button.y + 100

            This.ClickLocation(x, y)  ; Click in results box
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

    ClickLocation(x, y) {
        WinActivate, % This.window.title
        WinWaitActive, % This.window.title
        MouseClick, Left, x, y
    }
}

; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
^!i::
    KeyWait, ctrl, L
    KeyWait, alt, L

    Global updb := New UpdbInterface
return

ButtonAction() {
    GuiControlGet, updb_status, , _button

    if (updb_status = "Ready") {
        updb.__Configure()
        updb.__PrepareImport()
    } else if (updb_status = "Import") {
        updb.__ImportLoop()
    }
}
