/*  DevOps functions, hotstrings, and hotkeys used at BHIP.
*/

; Functions
; ==============================================================================
; Run on local system after merging a branch into master to other branches.
get_dev_pull() {
    str =
    ( LTrim
        workon devops_live
        write-host "``r``nUpdating Live deploy`r`n===================="
        git checkout deploy
        git pull
        workon devops_test;
        write-host "``r``nUpdating Test master`r`n===================="
        git checkout master
        git pull
        write-host "``r``nUpdating Test test`r`n===================="
        git checkout test
        git pull
        write-host "``r``nUpdating Test deploy`r`n===================="
        git checkout deploy
        git pull
        Write-Host "`r`nReturning to Master`r`n===================="
        git checkout master
    )
    Return str
}

get_dev_push() {
    str =
    ( LTrim
        workon DevOps
        write-host "``r``nPulling changes to master`r`n===================="
        git checkout master
        git pull
        write-host "``r``nMerging master into test`r`n===================="
        git checkout test
        git merge master
        git push
        write-host "``r``nMerging master into deploy`r`n===================="
        git checkout deploy
        git merge master
        git push
        Write-Host "`r`nReturning to Master`r`n===================="
        git checkout master
    )
    Return str
}

; Hotstrings
; ==============================================================================
; Run on local system after merging a branch into master to other branches.
:*:devpush::
    paste_contents(get_dev_push())
Return

; Run on remote system after updating all branches to pull down changes.
:*:devpull::
    paste_contents(get_dev_pull())
Return
