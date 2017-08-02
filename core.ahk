; This file is for core hotstrings

; The line below this one is literal (the ; does not count as a comment indicator). I have removed /\[] as end chars
#Hotstring EndChars -(){}:;'",.?!`n `t

; Hotkey to reload script as I frequently save and edit it.
^!r::Reload  ; Assign Ctrl-Alt-R as a hotkey to restart the script.


stringUpper(string){
    ; Allow me to call stringUpper as a function (not command)
    StringUpper, res, string
    return res
}

stringLower(string){
     ; Allow me to call stringLower as a function (not command)
    StringLower, res, string
    return res
}

clip_swap(str){
    ; This function allows me to paste a string but not disrupt the clipboard
    ClipSaved := ClipboardAll           ; Save the entire clipboard to a variable of your choice.
    Clipboard := str                    ; Assign text to clipboard
    ClipWait

    Send, ^v

    Clipboard := ClipSaved              ; Restore the original clipboard.
    ClipSaved =                         ; Free the memory in case the clipboard was very large.
}

clip_func(func){
    ; This function takes in a func name and runs it on whatever text is currently higlighted and "Sends" the result
    ClipSaved := ClipboardAll           ; Save the entire clipboard to a variable of your choice.
    Clipboard =                         ; Empty clipboard

    Send ^c                             ; Copy highlight text to clipboard
    ClipWait                            ; Wait for clipboard to contain text
    res := %func%(Clipboard)            ; Run passed in func on contents of clipboard
    Send, %res%                         ; Send results string

    Clipboard := ClipSaved              ; Restore the original clipboard.
    ClipSaved =                         ; Free the memory in case the clipboard was very large.
}

^!u::
    ; Hotkey to uppercase all highlighted text
    clip_func("stringUpper")
Return

^!l::
    ; Hotkey to lowercase all hightlighted text
    clip_func("stringLower")
Return
