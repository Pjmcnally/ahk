; This ahk file contains my scripts that interact with Git.

; ------------------------------------------------------------------------------
; Functions used in this module

; ------------------------------------------------------------------------------
; Hotstrings in this module

::gp::git push {Enter}
::gs::git status {Enter}
::gd::git diff {Enter}
::gfa::git fetch --all {Enter}
:o:gc::git commit -m "
:o:gca::git commit -am "
