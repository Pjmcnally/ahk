; This file is for core hotstrings

; The line below this one is literal (the ; does not count as a comment indicator). I have removed /\[] as end chars
#Hotstring EndChars -(){}:;'",.?!`n `t

; Hotkey to reload script as I frequently save and edit it.
^!r::Reload  ; Assign Ctrl-Alt-R as a hotkey to restart the script.


stringUpper(string){
    StringUpper, res, string
    return res
}

stringLower(string){
    StringLower, res, string
    return res
}


^!u::
    ClipSaved := ClipboardAll           ; Save the entire clipboard to a variable of your choice.
    Clipboard =                         ; Empty clipboard

    Send ^c                             ; Copy highlight text to clipboard
    ClipWait                            ; Wait for clipboard to contain text
    up_clip := stringUpper(Clipboard)   ; StringUpper contents of clipboard
    Send, %up_clip%                     ; Send upper case string 

    Clipboard := ClipSaved              ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
    ClipSaved =                         ; Free the memory in case the clipboard was very large.
Return

^!l::
    ClipSaved := ClipboardAll           ; Save the entire clipboard to a variable of your choice.
    Clipboard =                         ; Empty clipboard

    Send ^c                             ; Copy highlight text to clipboard
    ClipWait                            ; Wait for clipboard to contain text
    StringLower, low_clip, Clipboard     ; StringUpper contents of clipboard
    Send, %low_clip%                     ; Send upper case string 

    Clipboard := ClipSaved              ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
    ClipSaved =                         ; Free the memory in case the clipboard was very large.
Return

