/*
Main ahk script executed on this computer.

This module functions as a hub to include other AHK files and runs any system
specific Auto-Execute commands.  Core/Universal Auto-Execute commands should
be added to core.ahk.

System description: <Change as needed>
*/

; Auto-Execute Section (Any system specific Auto-Execute commands go here)
; ==============================================================================


; Include Section
; ==============================================================================
; Include Core Module(s) (core.ahk must be first for the Auto-Execute to work)
#Include core\core.ahk
#Include core\clipboard.ahk
#Include core\files.ahk
#Include core\strings.ahk
#include core\time.ahk

; Include Example
; #Include the_thing_I_want
; #Include misc\the_other_thing_I_want
