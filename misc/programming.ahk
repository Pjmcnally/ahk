; This ahk file contains my scripts that interact with Git.

#IfWinActive, ahk_group consoles ; Only run in consoles (specified in core.ahk)

; Functions used in this module
; ------------------------------------------------------------------------------

; Hotstrings in this module
; ------------------------------------------------------------------------------
; Git hotkeys
:*:gp::git push
:*:gs::git status
:*:gd::git diff
:*:gfa::git fetch --all --prune
:*:gc::git commit -m "
:*:gca::git commit -am "

; DevOps hotkeys
; Run on local system after merging a branch into master to other branches.
:*:devpush::workon DevOps; write-host "``r``nPulling changes to master"; git checkout master; git pull; write-host "``r``nMerging master into test"; git checkout test; git merge master; git push; write-host "``r``nMerging master into deploy"; git checkout deploy; git merge master; git push; git checkout master
; Run on remote system after updating all branches to pull down changes.
:*:devpull::workon DevOpsLive; write-host "``r``nUpdating Live deploy"; git checkout deploy; git pull; workon DevOpsTest; write-host "``r``nUpdating Test master"; git checkout master; git pull; write-host "``r``nUpdating Test test"; git checkout test; git pull; write-host "``r``nUpdating Test deploy"; git checkout deploy; git pull; git checkout master;

; Django hotkeys
:*:drun::python manage.py runserver
:*:dmm::python manage.py makemigrations
:*:dmig::python manage.py migrate
:*:dcol::python manage.py collectstatic --noinput --clear

; Annoying hotkey replacements
+Space::  ; Shift + Space doesn't seem to work in the terminal. This fixes that.
    Send {Space}
Return

#IfWinActive ; Clear IfWinActive
