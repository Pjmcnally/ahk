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
    SendWait("!n", wait)  ; Activate "file name" box
    Send, % name_string . "{Enter}"
    Sleep, 1000
}

add_languages(country) {
    wait := 200
    name_string := "Generic-" . country
    base_path := "E:\Dropbox\FlexiCapture\Layouts and Projects\" . country
    export_languages_path := base_path . "\ExportLanguages.txt"
    layouts_path := base_path . "\Layouts\" . name_string . "\"
    fsp_path := layouts_path . name_string . ".fsp"
    afl_path := layouts_path . name_string . ".afl"

    ; Create Export Languages file
    if (!FileExist(export_languages_path)) {
        FileAppend, % "English,", % export_languages_path
    }
    Run, % export_languages_path
    WinActivate ahk_class Notepad++
    WinWaitActive ahk_class Notepad++
    Send, {End}

    ; Close any open FlexiCapture windows
    flexi_window = WinExist("ABBYY FlexiLayout Studio 12")
    if (flexi_window) {
        WinClose, % "ABBYY FlexiLayout Studio 12"
    }

    ; Activate FlexiCapture and Open languages menu
    Run, % fsp_path
    WinWaitActive ahk_exe FlexiLayoutStudio.exe
    Sleep, % wait * 10
    SendWait("!l", wait)
    SendWait("{Up}", wait)
    SendWait("{Enter}", wait)

    ; Pause to manually update languages
    MsgBox, % "Update languages as necessary.`r`n`r`nEnter to continue"

    ; Save and close ExportLanguages file
    WinActivate ahk_class Notepad++
    WinWaitActive ahk_class Notepad++
    SendWait("^s", wait)
    SendWait("^w", wait)

    ; Reactivate FlexiCapture to save
    WinActivate ahk_exe FlexiLayoutStudio.exe
    WinWaitActive ahk_exe FlexiLayoutStudio.exe
    SendWait("{Enter}", wait)  ; Close any open windows
    SendWait("^s", wait)  ; Save project

    ; Activate export menu
    SendWait("{alt}", wait)
    SendWait("f", wait)
    SendWait("e", wait)
    Sleep, % wait * 5

    ; Add file name and save
    SendWait("!n", wait)  ; Activate "file name" box
    SendWait(afl_path, wait * 2.5)  ; Enter new file name
    SendWait("{Enter}", wait * 2.5)  ; Enter to save
    SendWait("{Enter}", wait * 2.5)  ; Enter to clear "File already exists" warning
    SendWait("^s", wait)  ; Save
    SendWait("!x", wait)  ; Quit
    Sleep, % wait * 5
}


main() {
    ; Already done: []
    countries := ["AD", "AE", "AL", "AM", "AO", "AP", "AR", "AT", "AU", "BD", "BE", "BG", "BH", "BN", "BO", "BX", "BY", "CA", "CH", "CL", "CO", "CR", "CU", "CY", "CZ", "DK", "DO", "DZ", "EC", "EE", "EG", "ES", "FI", "FJ", "FR", "GC", "GE", "GH", "GR", "GT", "GY", "HK", "HN", "HR", "HU", "IB", "ID", "IE", "IN", "IQ", "IR", "IT", "JO", "KE", "KG", "KH", "KW", "KZ", "LI", "LT", "LU", "LV", "MA", "MC", "MD", "MG", "MK", "MN", "MO", "MT", "MX", "MZ", "NA", "NG", "NI", "NL", "NO", "NP", "NZ", "OA", "OM", "PA", "PE", "PH", "PK", "PL", "PO", "PR", "PT", "PY", "QA", "RO", "RS", "SA", "SE", "SG", "SI", "SK", "SL", "SM", "TH", "TJ", "TM", "TR", "TZ", "UA", "UG", "UK", "UY", "UZ", "VE", "VN", "WD", "WP", "ZA"]
    for i, v in countries {
        add_languages(v)
    }
}

!^+z::main()
