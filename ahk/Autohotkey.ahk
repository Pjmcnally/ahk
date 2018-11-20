/*
Jump start ahk script to run main AHK script on this computer.

This file is is run by AutoHotkey on AutoHotkey start. It performs two
operations. First it sets the working dir to allow for relative imports within
my core AHK file. This cannot be set in the core file itself as the imports are
executed first.

It then runs the core ahk file to load all desired hotkeys and then terminates
itself.

To get this file to run automatically either copy it to the "My Documents"
folder or create a symbolic link using the following command:
New-Item -ItemType SymbolicLink -Path {path to My Documents} -Name AutoHotkey.ahk -Value {path to this file}
*/

; Sets working dir relative to ahk folder. Allows relative imports.
; Ensures a consistent starting directory. Set this to path of AHK folder.
SetWorkingDir, %A_ScriptDir%\programming\ahk

; Executes main AHK file
run ahk\autohotkey_main.ahk

; Exits this AHK file
ExitApp
