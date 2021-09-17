/*  DevOps functions, hotstrings, and hotkeys used at BHIP.
*/

; Functions
; ==============================================================================
get_dep_remote() {
    /*  Run on remote system after updating all branches to pull down changes.
    */

    ; Join with "; " so command is on one line for Windows Terminal
    str =
    (LTrim Join;`s
        workon DevOpsLive
        Write-Host
        Write-Host "Updating Live deploy"
        Write-Host "===================="
        git checkout deploy
        git fetch --all --prune
        git pull
        workon DevOpsTest;
        Write-Host
        Write-Host "Updating Test master"
        Write-Host "===================="
        git checkout master
        git fetch --all --prune
        git pull
        Write-Host
        Write-Host "Updating Test test"
        Write-Host "=================="
        git checkout test
        git fetch --all --prune
        git pull
        Write-Host
        Write-Host "Updating Test deploy"
        Write-Host "===================="
        git checkout deploy
        git fetch --all --prune
        git pull
        Write-Host
        Write-Host "Returning to Master"
        Write-Host "==================="
        git checkout master
    )

    ; Collapse to one line to work with new multi-line paste function of Windows Terminal
    Return str
}

get_dep_local() {
    /*  Run on local system after merging a branch into master.
    */

    ; Join with "; " so command is on one line for Windows Terminal
    str =
    (LTrim Join;`s
        workon DevOps
        Write-Host
        Write-Host "Pulling changes to master"
        Write-Host "========================="
        git checkout master
        git fetch --all --prune
        git pull
        Write-Host
        Write-Host "Merging master into test"
        Write-Host "========================"
        git checkout test
        git fetch --all --prune
        git merge master
        git push
        Write-Host
        Write-Host "Merging master into deploy"
        Write-Host "=========================="
        git checkout deploy
        git fetch --all --prune
        git merge master
        git push
        Write-Host
        Write-Host "Returning to Master"
        Write-Host "==================="
        git checkout master
    )

    return str
}

test_credential() {
    /*  Script to quickly run cred test for use when testing on multiple
    systems.

    Before you start create a file like this containing the needed values:
    [values]
    url=""
    cert=""
    username=""
    password=""
    guid=""
    */

    file := "C:\Users\Patrick\Desktop\test.txt"
    elements := ["url", "cert", "username", "password", "guid"]
    object := {}

    for index, item in elements {
        IniRead, value, % file, Values, % item
        object[item] := value
    }

    Send, % object.url
    Send, {Tab}
    Send, % object.cert
    Send, {Tab 2}
    Send, % object.username
    Send, {Tab}
    SendRaw, % object.password
    Send, {Tab}
    Send, % object.guid
    Send, {Tab 4}
    Send, {Enter}
}

Class PtoExtractorInterface {
    __New() {
        This.PtoExtractor := "PTO Extractor"
        This.FinishedPopUp := "PTOExtractor Finished"
        This.ErrorPopUp := "Clear Errors"
        This.LoopCount := 0
        This.ToolTipString := "AHK PTO Extractor Assistant`r`n`r`nLoop Count: {1}`r`n`r`nPress Ctrl-Alt-R to cancel"
        This.CheckFrequency := 100

        ; Set timer attribute / Start timer
        This.Timer := ObjBindMethod(this, "Run")
        timer := this.Timer  ; Not sure why this line is necessary but it is.
        SetTimer, % timer, % this.CheckFrequency,
    }

    run() {
        ToolTip, % Format(This.ToolTipString, This.LoopCount), 25, 25

        ; Check if process finished
        if (WinExist(This.FinishedPopUp)) {
            This.LoopCount += 1

            ; Close popup window
            WinActivate, % This.FinishedPopUp
            WinWaitActive, % This.FinishedPopUp
            Send {Enter}

            ; Update CoordMode for relative clicks
            CoordMode, Mouse, Window

            ; Reset Xml Errors
            WinActivate, % This.PtoExtractor
            WinWaitActive, % This.PtoExtractor
            Click 775, 835

            ; Clear pop up
            WinWaitActive, % This.ErrorPopUp
            Click 275, 125

            ; Restart process
            WinWaitActive, % This.PtoExtractor
            Click 75, 835

            ; Reset CoordMode to default
            CoordMode, Mouse, Screen
        }
    }
}

; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
^!+p::New PtoExtractorInterface

; Hotstrings
; ==============================================================================
:*:depLocal::
    paste_contents(get_dep_local())
Return

:*:depRemote::
    paste_contents(get_dep_remote())
Return

:co:credtestgo::
    test_credential()
Return

:co:credtestrun::
    Send, % get_tester_path()
Return

:coX:newcustnum::
    send_new_cust_num_email()
Return
