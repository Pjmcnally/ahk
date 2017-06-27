; This ahk file contains my scripts that interact with Git.

::gp::git push
::gs::git status
::gd::git diff
::gf::git fetch --all
:o:gc::git commit -m ""{left 1}
:o:gca::git commit -am ""{left 1}
