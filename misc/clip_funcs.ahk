; This ahk file functions to better handle input from the clipboard

; ------------------------------------------------------------------------------
; Functions used in this module

clip_swap(str){
    ; This function allows me to paste a string but not disrupt the clipboard
    ClipSaved := ClipboardAll           ; Save the entire clipboard to a variable of your choice.
    Clipboard := str                    ; Assign text to clipboard
    ClipWait, 1, 0                      ; Wait 1 second for clipboard to contain text

    Send, ^v

    Clipboard := ClipSaved              ; Restore the original clipboard.
    ClipSaved =                         ; Free the memory in case the clipboard was very large.
}

clip_func(func, send_res:=False){
    ; This function takes in a func name and runs it on whatever text is currently higlighted and "Sends" the result
    ClipSaved := ClipboardAll           ; Save the entire clipboard to a variable of your choice.
    Clipboard =                         ; Empty clipboard

    Send ^c                             ; Copy highlight text to clipboard
    ClipWait, 1, 0                      ; Wait 1 second for clipboard to contain text
    res := %func%(Clipboard)            ; Run passed in func on contents of clipboard

    if (send_res){                      ; if send_res is True
        Send, %res%                     ; Send results string
    }

    Clipboard := ClipSaved              ; Restore the original clipboard.
    ClipSaved =                         ; Free the memory in case the clipboard was very large.
}
