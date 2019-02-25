/*  This was used as part of a 1 time operation to load some customers into
the test system.
*/

get_customers_from_csv(file_path) {
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

main() {
    customers := get_customers_from_csv(get_customer_info())

    for index, customer in customers {
        add_customer(customer)
        add_credential(customer)
    }
}

+^!t::
    main()
Return
