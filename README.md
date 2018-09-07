# ahk

This is the main hub for all of my AutoHotkey files.

Directions for setting this up:
1. Clone this repo as a subfolder of you "My Documents" Folder (folder should be named ahk)
2. Copy Autohotkey.ahk from folder ahk\core to "My Documents"
    * Update the path in the line SetWorkingDir. 
    * The path is relative starting at "My Documents" to the location of the AHK folder
3. Create a file called "autohotkey_main.ahk" in ahk\core folder
    * This file should be based off of autohotkey_main_default.ahk
    * Add any #Include statements to include desired modules.
    * autohotkey_main.ahk will need to be setup on each machine as it is not tracked by git.
