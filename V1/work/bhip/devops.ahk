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

; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================

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
