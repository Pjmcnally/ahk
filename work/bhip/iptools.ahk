/*  IP Tools functions, hotstrings, and hotkeys used at BHIP.
*/

; Functions
; ==============================================================================
get_customers_from_csv(file_path) {
    /*  Pulls customer data from pre-created csv file (saved results of db
        query).
    */
    customers := []
    attributes := ["ClientNumber", "Name", "ShortName", "State", "RegNum", "Practitioner", "FileName", "Password"]

    Loop, Read, % file_path
    {
        current_customer := {}
        Loop, Parse, A_LoopReadLine, CSV
            current_customer[attributes[A_index]] := A_LoopField

        customers.push(current_customer)
    }

    Return customers
}

add_customer(customer) {
    /*  Adds core customer information to IP Tools.
    */
    big_wait := 2000  ; Use for page loads and transitions
    small_wait := 500  ; Use between other operations

    ; Activate IE Window
    WinActivate, Black Hills IP - IP Tools - Internet Explorer
    WinWaitActive, Black Hills IP - IP Tools - Internet Explorer

    ; Start creation of new customer
    ClickWait(325, 115, 1, big_wait)  ; Click customers tab
    ClickWait(2440, 151, 1, big_wait)  ; Click "Add new customer"

    ; Add Customer Main info
    ClickWait(65, 180, 1, big_wait)  ; Activate main tab
    ClickWait(170, 200, 1, small_wait)  ; Click inside Customer num box
    SendWait(customer.ClientNumber . "{Tab}", small_wait)
    SendWait(customer.Name . "{Tab}", small_wait)
    SendWait(customer.ShortName, small_wait)
    ClickWait(465, 560, 1, small_wait)
    SendWait(customer.State . "{Tab}", small_wait)

    ; Add pricing info
    ClickWait(50, 225, 1, big_wait)  ; Click Pricing Tab
    ClickWait(370, 300, 1, small_wait)  ; Click in first text box

    ; Loop over 2 rows of 3 boxes with extra tab
    Loop, 2 {
        Loop, 3 {
            SendWait(1 . "{Tab}", small_wait)
        }
        SendWait("{Tab}", small_wait)
    }
    ; Loop over 6 remaining boxes
    Loop, 6 {
        SendWait(1 . "{Tab}", small_wait)
    }


    ; Add Job info
    ClickWait(65, 322, 1, big_wait)  ; Click on Jobs tab
    ClickWait(2515, 185, 1, big_wait)  ; Click Add new job
    ClickWait(210, 240, 2, small_wait)
    SendWait("Daily Docketing{Tab}", small_wait)
    ClickWait(50, 1350, 1, small_wait)
}

add_credential(customer) {
    /*  Adds credential information to IP Tools
    */
    big_wait := 2000  ; Use for page loads and transitions
    small_wait := 500  ; Use between other operations

    ; Activate IE Window
    WinActivate, Black Hills IP - IP Tools - Internet Explorer
    WinWaitActive, Black Hills IP - IP Tools - Internet Explorer

    ClickWait(1005, 115, 1, big_wait)  ; Click Admin Tab
    ClickWait(75, 590, 1, big_wait)  ; Click Credentials tab
    ClickWait(225, 1350, 1, big_wait)  ; Click "Add new Credential"

    ; Enter Credential info
    ClickWait(370, 230, 1, small_wait)  ; Click Customer name
    SendWait(customer.Name . "{Enter}{Tab}", small_wait)
    SendWait("United{Enter}{Tab}", small_wait)
    SendWait(customer.ShortName . "-USPTO{Tab}", small_wait)
    SendWait("{Space}{Tab 4}", small_wait)
    SendWait("<INSERT VALUE>" . "{Tab}", small_wait)
    SendWait("<INSERT VALUE>" . "{tab}", small_wait)
    SendWait("<INSERT VALUE>" . "{tab 4}", small_wait)
    SendWait(customer.RegNum . "{Enter}", small_wait)
    SendWait("{Tab}" . customer.Practitioner . "{Tab}", small_wait)
    ClickWait(450, 740, 1, small_wait)  ; Click on New num action dropdown
    ClickWait(450, 785, 1, small_wait)  ; Select option (Report)
    ClickWait(450, 770, 1, small_wait)  ; Click on Scrape action
    ClickWait(450, 830, 1, small_wait)  ; Select option (xml+docs)
    ClickWait(450, 790, 1, small_wait)  ; Click in Filename box
    SendWait(customer.FileName . "{Enter}", small_wait)
    SendWait("{Tab}", small_wait)
    SendRaw, % customer.Password
    Send, {Tab}

    ClickWait(195, 870, 1, big_wait)  ; Click Save
}

add_customers_to_iptools() {
    /*  Adds customer and credential info to IP Tools.

        This was used once to bulk add customers to our test system.
    */
    customer_file_path = ""
    customers := get_customers_from_csv(customer_file_path)

    for index, customer in customers {
        add_customer(customer)
        add_credential(customer)
    }
}

fill_scrape_mail_date() {
    /*  Fill scrape start dates and mail start date into jobs screen.

    To use this set the Setting Summary filter to contains and enter some
    value. It doesn't matter if no items are showing but there must not be
    more than 1 screen worth of items as the scrolling bar throws off some
    of the click references.

    You may also need to update the StartDate box x position as it can be
    influenced by credential name length.

    Args:
        None
    Return:
        None
    */
    InputBox, scrape_start, % "Scrape Start", % "Please enter scrape start date"
    if ErrorLevel
        Exit
    InputBox, mail_start, % "Mail Start", % "Please enter mail start date"
    if ErrorLevel
        Exit
    InputBox, array_str, % "USPTO Customer Numbers", % "Add a comma separated list of USPTO Customer Numbers."
    ; InputBox, num, % "Number?", % "Please enter the number of lines to fill"
    ; if ErrorLevel
    ;     Exit

    array := StrSplit(array_str, ",", " ")
    wait := 300
    start_date_box_x_pos := 785

    For i, val in array {
        ; Make sure to sort by "Start Date Asc before starting. That way the
        ; newly entered item will be "Sorted to the bottom" and the top box
        ; will always be empty.

        WinActivate, Black Hills IP - IP Tools - Internet Explorer
        WinWaitActive, Black Hills IP - IP Tools - Internet Explorer

        Click, 2538, 397, 1  ; Click "filter button" for Setting Summary
        Sleep, % wait
        Click, 2500, 760, 1  ; Click to enter filter value
        Sleep, % wait
        Send, % val  ; Send filter value
        Sleep, % wait
        Send, {Enter}
        Sleep, % wait
        Click, %start_date_box_x_pos%, 425, 2  ; Click top square Start Date box.
        Sleep, % wait
        Send, ^a  ; Highlight any previously entered text
        Send, % scrape_start  ; Enter Date
        Sleep, % wait
        Click, 325, 1210, 2  ; Click in MailDateStart box.
        Sleep, % wait
        Send, ^a  ; Highlight any previously entered text
        Send, % mail_start  ; Enter Date
        Sleep, % wait

        i += 1
    }
}

skip_documents() {
    wait := 400
    file_path :=
    skip_message :=

    Loop, Read, % file_path
    {
        ; Fill in next matter number
        KeyWait, ~, D
        Click, 2375, 185
        Sleep, wait
        Send, ^a,
        Sleep, wait
        Send, {BackSpace}
        Send, % A_LoopReadLine
        KeyWait, ~

        ; Remove any pending activities
        KeyWait, ~, D
        Click, 2070, 210  ; Select all pending activities
        Sleep, wait
        Click, 2225, 180  ; Click to select dropdown
        Sleep, wait
        Click, 2225, 280  ; Click to select "Remove"
        Sleep, wait
        Click, 2315, 180  ; Click "Go" to remove activity
        Sleep, wait
        Click, 50, 550  ; Select "New Documents Screen"
        KeyWait, ~

        ; Activate document screen and skip documents
        KeyWait, ~, D
        Click, 65, 1275  ; Select all pending documents
        Sleep, wait
        Click, 280, 580  ; Skip all pending documents
        Sleep, wait
        KeyWait, ~, D

        ; Fill in Skipping box
        KeyWait, ~, D
        Send, % "O"
        Sleep, wait
        Send, % skip_message
        Sleep, 500
        Send, % "{Tab}"
        Sleep, wait
        Send, % "{Enter}"
        KeyWait, ~

        KeyWait, ~, D
        Click, 520, 110
        KeyWait, ~
    }
}

; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
^!d::fill_scrape_mail_date()
; ^!z::skip_documents()
