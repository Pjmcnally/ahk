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
