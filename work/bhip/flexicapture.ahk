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
    navigate_to_layout_folder(country, wait)
    Send, % name_string . "{Enter}"
    Sleep, 1000
}

add_languages(country) {
    wait := 200
    name_string := "Generic-" . country
    base_path := "E:\Dropbox\FlexiCapture\Layouts and Projects\" . country
    export_languages_path := base_path . "\ExportLanguages.txt"
    layout_path := base_path . "\Layouts\" . name_string . "\" . name_string . ".fsp"


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
    Run, % layout_path
    WinWaitActive ahk_exe FlexiLayoutStudio.exe
    Sleep, 1000
    SendWait("!l", wait)
    SendWait("{Up}", wait)
    SendWait("{Enter}", wait)

    ; Pause to manually update languages
    MsgBox, % "Update languages as necessary.`r`n`r`nEnter to continue"

    ; Close ExportLanguages file
    WinActivate ahk_class Notepad++
    WinWaitActive ahk_class Notepad++
    SendWait("^w", wait)

    ; Reactivate FlexiCapture to save and export
    WinActivate ahk_exe FlexiLayoutStudio.exe
    WinWaitActive ahk_exe FlexiLayoutStudio.exe
    SendWait("{Enter}", wait)
    SendWait("^s", wait)
    SendWait("{alt}", wait)
    SendWait("f", wait)
    SendWait("e", wait)
    Sleep, 1000
    navigate_to_layout_folder(country, wait)
    SendWait("{Enter}", wait)
    SendWait("^s", wait)
    SendWait("!x", wait)
    Sleep, 1000
}

navigate_to_layout_folder(country, wait) {
    Click, 416, 48,  ; Click on "Up one level"
    Sleep, % wait
    Click, 416, 48,  ; Click on "Up one level"
    Sleep, % wait
    Click, 416, 48,  ; Click on "Up one level"
    Sleep, % wait
    Click, 300, 175  ; Click in main box
    Sleep, % wait
    SendWait(country, wait)
    SendWait("{Enter}", wait)
    Click, 150, 100, 2  ; Select first option - Layouts
    Sleep, % wait
    Click, 150, 100, 2  ; Select first option - Generic-??
    Sleep, % wait
    Click, 225, 425  ; Click in file name field
    Sleep, % wait
}

main() {
    ; Already done: ["AD", "AE", "AL", "AM", "AO", "AP", "AR", "AT", "AU", "BD", "BE", "BG", "BH", "BN", "BO", ]
    countries := ["BX", "BY", "CA", "CH", "CL", "CO", "CR", "CU", "CY", "CZ", "DK", "DO", "DZ", "EC", "EE", "EG", "ES", "FI", "FJ", "FR", "GC", "GE", "GH", "GR", "GT", "GY", "HK", "HN", "HR", "HU", "IB", "ID", "IE", "IN", "IQ", "IR", "IT", "JO", "KE", "KG", "KH", "KW", "KZ", "LI", "LT", "LU", "LV", "MA", "MC", "MD", "MG", "MK", "MN", "MO", "MT", "MX", "MZ", "NA", "NG", "NI", "NL", "NO", "NP", "NZ", "OA", "OM", "PA", "PE", "PH", "PK", "PL", "PO", "PR", "PT", "PY", "QA", "RO", "RS", "SA", "SE", "SG", "SI", "SK", "SL", "SM", "TH", "TJ", "TM", "TR", "TZ", "UA", "UG", "UK", "UY", "UZ", "VE", "VN", "WD", "WP", "ZA"]
    for i, v in countries {
        add_languages(v)

        Return
    }
}

!^+z::main()
