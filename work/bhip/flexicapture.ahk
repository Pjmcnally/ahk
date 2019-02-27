update_and_save_layout(country) {
    wait := 200
    name_string := "Generic-" . country

    WinActivate, ahk_exe FlexiLayoutStudio.exe
    WinWaitActive, ahk_exe FlexiLayoutStudio.exe

    ; Update name of FlexiLayout
    Click 65, 575
    SendWait("{f2}", wait)
    SendWait(name_string, wait)
    SendWait("{Enter}", wait)
    Send, ^s
    Sleep, % wait

    ; Save as to new location
    SendWait("{alt}", wait)
    SendWait("f", wait)
    SendWait("a", wait)
    Sleep, 1000
    Click, 416, 48,  ; Click on "Up one level"
    Sleep, % wait
    Click, 416, 48,  ; Click on "Up one level"
    Sleep, % wait
    Click, 416, 48,  ; Click on "Up one level"
    Sleep, % wait
    Click, 300, 175  ; Click in main box
    Sleep, % wait
    Send, % country
    Sleep, % wait
    Send, {Enter}
    Sleep, % wait
    Click, 150, 100, 2  ; Select first option - Layouts
    Sleep, % wait
    Click, 150, 100, 2  ; Select first option - Generic-??
    Sleep, % wait
    Click, 225, 425  ; Click in file name field
    Send, % name_string . "{Enter}"
    Sleep, 1000
}

main() {
    ; Already done ["CA", "AU", "IN", "MX", "ZA", "HK", "SG", "GC", "NZ", "FR", "CL", "ID", "TH", "IT", "AR", "CH", "NL", "CO", "UA", "ES", "PH", "PL", "VN", "TR", "SE", "IE", "PE", "NO", "DK", "BE", "PK", "PY", "PA", "IB", "AE", "CZ", "SA", "HU", "RO", "UY", "FI", "EG", "AT", "GR", "AP", "CR", "SK", "PT", "UZ", "MK", "GT", "HN", "OM", "WP", "SI", "KZ", "LT", "BY", "VE", "EC", "OA", "CU", "MZ", "BG", "DO", "JO", "DZ", "CY", "MA", "MC", "BO", "IQ", "GH", "KE", "BD", "EE", "RS", "TZ", "UG", "AL", "KG", "GE", "MO", "HR", "MG", "LI", "NI", "FJ", "PO", "TJ", "MD", "GY", "AM", "PR", "NP", "KW", "MT", "KH", "NA", "UK", ]
    countries := ["AD", "SM", "LV", "BN", "IR", "SL", "TM", "QA", "BX", "NG", "WD", "BH", "MN", "LU", "AO"]
    for i, v in countries {
        update_and_save_layout(v)
    }
}

!^+z::main()
