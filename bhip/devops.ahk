/*  DevOps functions, hotstrings, and hotkeys used at BHIP.
*/

; Hotstrings
; ==============================================================================
; Run on local system after merging a branch into master to other branches.
:*:devpush::
    str =
    (
        workon DevOps
        write-host "``r``nPulling changes to master"
        git checkout master
        git pull
        write-host "``r``nMerging master into test"
        git checkout test
        git merge master
        git push
        write-host "``r``nMerging master into deploy"
        git checkout deploy
        git merge master
        git push
        git checkout master
    )
    paste_contents(dedent(str, 8))
Return

; Run on remote system after updating all branches to pull down changes.
:*:devpull::
    str =
    (
        workon devops_live
        write-host "``r``nUpdating Live deploy"
        git checkout deploy
        git pull
        workon devops_test;
        write-host "``r``nUpdating Test master"
        git checkout master
        git pull
        write-host "``r``nUpdating Test test"
        git checkout test
        git pull
        write-host "``r``nUpdating Test deploy"
        git checkout deploy
        git pull
        git checkout master
    )
    paste_contents(dedent(str, 8))
Return
