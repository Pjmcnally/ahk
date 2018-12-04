# ahk

This is the main hub for all of my AutoHotkey files.

Directions for setting this up:
1. Clone this repo
2. Create symbolic link from Autohotkey.ahk in the repo\ahk folder to "My Documents"
    * Run PowerShell in admin mode
    * Run the following command:
    * New-Item -ItemType SymbolicLink -Path {path to my documents} -Name AutoHotkey.ahk -Value {path to AutoHotkey.ahk} 
3. Create a file called "autohotkey_main.ahk" in repo\ahk folder
    * This file should be based off of autohotkey_main_default.ahk
    * Add any #Include statements to include desired modules.
    * autohotkey_main.ahk will need to be setup on each machine as it is not tracked by git.
