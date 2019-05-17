/*  DevOps functions, hotstrings, and hotkeys used at BHIP.
*/

; Functions
; ==============================================================================
get_dep_remote() {
    /*  Run on remote system after updating all branches to pull down changes.
    */
    str =
    ( LTrim
        workon DevOpsLive
        write-host "``r``nUpdating Live deploy`r`n===================="
        git checkout deploy
        git fetch --all --prune
        git pull
        workon DevOpsTest;
        write-host "``r``nUpdating Test master`r`n===================="
        git checkout master
        git fetch --all --prune
        git pull
        write-host "``r``nUpdating Test test`r`n===================="
        git checkout test
        git fetch --all --prune
        git pull
        write-host "``r``nUpdating Test deploy`r`n===================="
        git checkout deploy
        git fetch --all --prune
        git pull
        Write-Host "`r`nReturning to Master`r`n===================="
        git checkout master
    )
    Return str
}

get_dep_local() {
    /*  Run on local system after merging a branch into master.
    */
    str =
    ( LTrim
        workon DevOps
        write-host "``r``nPulling changes to master`r`n===================="
        git checkout master
        git fetch --all --prune
        git pull
        write-host "``r``nMerging master into test`r`n===================="
        git checkout test
        git fetch --all --prune
        git merge master
        git push
        write-host "``r``nMerging master into deploy`r`n===================="
        git checkout deploy
        git fetch --all --prune
        git merge master
        git push
        Write-Host "`r`nReturning to Master`r`n===================="
        git checkout master
    )
    Return str
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
