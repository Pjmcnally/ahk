/*  IP Tools functions, hotstrings, and hotkeys used at BHIP.
*/


setup_country(country) {
    /*  This is a one time use function to create a mass export layouts and
    templates for all missing countries in our system.

    This could probably be re-structured and improved but because it is a one
    time solution I am not worried about long term maintainability.
    */

    wait := 200
    name_string := "Generic-" . country

    ; Program paths
    flexi_layout := "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ABBYY FlexiCapture 12\Tools\FlexiLayout Studio.lnk"
    flexi_admin := "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ABBYY FlexiCapture 12\Administrator Station.lnk"

    ; Folder paths
    base_path := "E:\Dropbox\FlexiCapture\Layouts and Projects\" . country
    export_languages_path := base_path . "\ExportLanguages.txt"
    layouts_path := base_path . "\Layouts\" . name_string
    project_path := base_path . "\Projects\" . name_string
    template_path := project_path . "\Templates"
    results_path := "C:\Users\Patrick\Desktop\Results\" . country
    FileCreateDir, % results_path

    ; File paths
    fsp_path := layouts_path . "\" . name_string . ".fsp"
    afl_path := layouts_path . "\" . name_string . ".afl"
    fcdot_path := template_path . "\" . name_string . ".fcdot"
    doc_path := "E:\Dropbox\BHIP-Sys-Docs\Support\Test Doc For IPT Configuration.pdf"
    generic_layout := "E:\Dropbox\FlexiCapture\Layouts and Projects\Generic\Layouts\Generic.fsp"
    country_code := "E:\Dropbox\BHIP-Share\JIRA\HELP\HELP-09055\Country by Country Code.txt"

    ; Create Export Languages file
    if (!FileExist(export_languages_path)) {
        FileAppend, % "English,", % export_languages_path
    }
    Run, % export_languages_path
    WinActivate ahk_class Notepad++
    WinWaitActive ahk_class Notepad++
    Send, {End}

    ; Close any open FlexiCapture windows
    while (WinExist("ABBYY FlexiLayout Studio 12")) {
        WinClose, % "ABBYY FlexiLayout Studio 12"
        Sleep, wait
    }

    if (!FileExist(fsp_path)) {
        ; This chunk of code was modified and has not been tested.
        Run, % generic_layout
        WinWaitActive, ahk_exe FlexiLayoutStudio.exe

        ; Update name of FlexiLayout
        Click 65, 575
        SendWait("{f2}", wait)
        SendWait(name_string, wait)
        SendWait("{Enter}", wait)
        SendWait("^s", wait)

        ; Save as to new location
        SendWait("{alt}", wait)
        SendWait("f", wait)
        SendWait("a", wait)
        WinWaitActive Save Copy
        SendWait("!n", wait)  ; Activate "file name" box
        Send, % name_string . "{Enter}"
        WinWaitActive ahk_exe FlexiLayoutStudio.exe

        ; Close generic layout
        SendWait("!x", wait)
    }

    ; Run and wait for FlexiCapture Layout
    Run, % fsp_path
    WinWaitActive ahk_exe FlexiLayoutStudio.exe
    Sleep, % wait * 5  ; This wait is need or the command may not be received.

    ; Open languages menu
    SendWait("!l", wait)
    SendWait("{Up}", wait)
    SendWait("{Enter}", wait)

    ; Get country value from country code file
    iniRead, full_country_name, % country_code, % "List by code", % country

    ; Pause to manually update languages
    MsgBox, , % "Country: " . full_Country_name, % "Creating layout for: " . full_country_name . "`r`n`r`nUpdate languages as necessary."

    ; Save and close ExportLanguages file
    WinActivate ahk_class Notepad++
    WinWaitActive ahk_class Notepad++
    SendWait("^s", wait)
    SendWait("^w", wait)

    ; Reactivate FlexiCapture to save
    WinActivate ahk_exe FlexiLayoutStudio.exe
    WinWaitActive ahk_exe FlexiLayoutStudio.exe
    SendWait("{Enter}", wait)  ; Close any open windows
    if (WinExist("Properties of " . name_string)) {
        SoundBeep
        MsgBox, % "Properties Window Still open"
    }

    WinActivate ahk_exe FlexiLayoutStudio.exe
    WinWaitActive ahk_exe FlexiLayoutStudio.exe
    SendWait("^s", wait)  ; Save project

    ; Activate export menu
    SendWait("{alt}", wait)
    SendWait("f", wait)
    SendWait("e", wait)
    WinWaitActive Export FlexiLayout

    ; Add file name and save
    SendWait("!n", wait)  ; Activate "file name" box
    SendWait(afl_path, wait)  ; Enter new file name
    SendWait("{Enter}", wait * 2.5)  ; Enter to save
    SendWait("{Enter}", wait * 2.5)  ; Enter to clear "File already exists" warning
    SendWait("^s", wait)  ; Save
    SendWait("!x", wait)  ; Quit
    Sleep, % wait * 5

    ; Launch Admin Station
    Run, % flexi_admin
    Sleep, % wait
    SendWait("{Enter}", wait)
    WinWaitActive ahk_exe FlexiCapture.exe

    ; Check if Project already exits (it shouldn't)
    if (FileExist(project_path)) {
        Run, % base_path . "\Projects"
        MsgBox, % "Project folder already exits.`r`n`r`nResolve then press Enter to continue"
    }

    ; Create new project
    SendWait("^+n", wait)
    SendWait(project_path, wait)
    SendWait("{Enter}", wait)

    ; Open and wait for Doc Def window
    SendWait("^t", wait)
    WinWaitActive Document Definitions

    ; Open and wait for New Doc Def window
    SendWait("!w", wait)  ; Create new doc def
    WinWaitActive Create New Document Definition

    ; Enter path to file
    SendWait("!r", wait)  ; Open "Load from file" window
    WinWaitActive Load Images  ; Wait for window
    SendWait(doc_path, wait)  ; Enter path to document
    SendWait("{Enter}", wait)  ; Press "Enter" to close

    ; Enter path fo FlexiLayout
    WinWaitActive Create New Document Definition
    SendWait("!F", wait)  ; Check FlexiLayout box
    SendWait("!w", wait)  ; Browse to FlexiLayout
    WinWaitActive Open FlexiLayout File
    SendWait(afl_path, wait)  ; Enter layout path
    SendWait("{Enter}", wait)

    ; Configure settings for new doc def
    WinWaitActive Create New Document Definition
    SendWait("!N", wait)  ; Go to next screen
    SendWait(name_string, wait)  ; Enter name
    SendWait("!O", wait)  ; Select "OCR" as text type
    SendWait("{Enter}", wait)

    ; Save and close document definition
    WinWaitActive Document Definition Editor
    SendWait("^s", wait)
    SendWait("!{f4}", wait * 5)

    ; Publish Document definition
    WinWaitActive ahk_exe FlexiCapture.exe
    SendWait("!p", wait)  ; Publish definition
    SendWait("{Enter}", wait)  ; Close publication window
    SendWait("{Enter}", wait)  ; Close doc def window
    SendWait("!{f4}", wait * 5)  ; Close admin Station

    ; Check Work
    if (!FileExist(fsp_path)) {
        MsgBox, % ".fsp file doesn't exist. Fix before continuing."
    }
    if (!FileExist(afl_path)) {
        MsgBox, % ".afl file doesn't exist. Fix before continuing."
    }
    if (!FileExist(fcdot_path)) {
        MsgBox, % ".fcdot file doesn't exist. Fix before continuing."
    }
    if (!FileExist(export_languages_path)) {
        MsgBox, % "ExportLanguages.txt doesn't exist. Fix before continuing."
    }

    ; Copy results files to results path
    FileCopy, % fcdot_path, % results_path
    FileCopy, % export_languages_path, % results_path
    Sleep, wait * 5
}


main() {
    ; Already done: ["AD", "AE", "AL", "AM", "AO", "AP", "AR", "AT", "AU", "BD", "BE", "BG", "BH", "BN", "BO", "BX", "BY", "CA", "CH", "CL", "CO", ]
    countries := ["CR", "CU", "CY", "CZ", "DK", "DO", "DZ", "EC", "EE", "EG", "ES", "FI", "FJ", "FR", "GC", "GE", "GH", "GR", "GT", "GY", "HK", "HN", "HR", "HU", "IB", "ID", "IE", "IN", "IQ", "IR", "IT", "JO", "KE", "KG", "KH", "KW", "KZ", "LI", "LT", "LU", "LV", "MA", "MC", "MD", "MG", "MK", "MN", "MO", "MT", "MX", "MZ", "NA", "NG", "NI", "NL", "NO", "NP", "NZ", "OA", "OM", "PA", "PE", "PH", "PK", "PL", "PO", "PR", "PT", "PY", "QA", "RO", "RS", "SA", "SE", "SG", "SI", "SK", "SL", "SM", "TH", "TJ", "TM", "TR", "TZ", "UA", "UG", "UK", "UY", "UZ", "VE", "VN", "WD", "WP", "ZA"]
    for i, v in countries {
        setup_country(v)
    }
}

!^+z::main()
