; This ahk file contains my scripts that interact with Git.

#IfWinActive, ahk_group consoles ; Only run in consoles (specified in core.ahk)

; Functions used in this module
; ------------------------------------------------------------------------------

; Hotstrings in this module
; ------------------------------------------------------------------------------
; Git hotkeys
::gp::git push
::gs::git status
::gd::git diff
::gfa::git fetch --all --prune
:o:gc::git commit -m "
:o:gca::git commit -am "

; Django hotkeys
:o:drun::python manage.py runserver
:o:dmm::python manage.py makemigrations
:o:dmig::python manage.py migrate
:o:dcol::python manage.py collectstatic --noinput --clear

#IfWinActive ; Clear IfWinActive
