; Scripts below mass upload documents to USPTO
; Version 4.0 (loop)
; last updated 03-07-17
; Created by Patrick McNally

; This is my new attempt at a master upload script to work on any browser (It currently supports IE and Chrome).
; I am very close to getting this to work in Firefox but for some reason the upload window behaves inconsistently.

#i::
#c::
#z::
    main() ; Runs entire script
return

main() {
    ; Create instance of UploadSession
    my_upload := New UploadSession

    ; Get name of open window
    my_upload.getWindow()

    ; Check if open window is a supported browser
    my_upload.verifyBrowser()

    ; Setup and get info for specific browser.
    my_upload.setupBrowser()

    ; Get directory holding files and file count.
    my_upload.getDirectory()
    my_upload.countFiles()

    ; Get and check number of foreign refs.
    my_upload.getForeignCount()

    ; Check with user that all is correct then upload File
    my_upload.verifyContinue()

    ; Upload files to USPTO
    my_upload.submitLoop()
}

class UploadSession {
    ; These are the hard-coded variables.  If anything changes this is where you will need to change stuff.
    Static submitDelay := 100 ; 100 is default. Increase this number to slow down the submission process if it is breaking.  Do not set below 100 or errors may occur.
    Static file_default := "\*.pdf"  ; Limits to only uploading pdf files. If this is changed make sure leading \ is included.

    getWindow() {
        WinGet, window, ProcessName, A
        This.window := window
    }

    verifyBrowser() {
        ; Function to check if active window is supported browser.
        ; Currently not compatible with Firefox so check is commented out.
        if (This.window != "chrome.exe" and This.window != "iexplore.exe") { ; and window != "firefox.exe"
            MsgBox % "Please make sure to your Chrome or Internet Explorer window is active before using hotkey."
            Exit
        }
    }

    setupBrowser() {
        ; Set input mode per browser
        if (browswer = "firefox.exe") { ; Firefox works better (but not completely) with Send mode
            SetKeyDelay, % UploadSession.submitDelay
        } else {
            SendMode, Input ; SendInput is better and Chrome and IE both work with it.
        }

        ; get proper window references per browser.
        ; dict of supported browsers and the names of the window where the files to be uploaded are selected.
        ; "upload" and "normal" are keys. The corresponding values are the titles of the windows. These are found by
        ; using AutoHotkey WindowSpy. Right click on AutoHotkey icon in task bar to run.
        browserDict := {"chrome.exe": {"upload": "Open", "normal": "United States Patent & Trademark Office - Google Chrome"}
            , "firefox.exe": {"upload": "File Upload", "normal": "United States Patent & Trademark Office - Mozilla Firefox"} ; doesn't actually work.
            , "IEXPLORE.EXE": {"upload": "Choose File to Upload", "normal": "United States Patent & Trademark Office - Internet Explorer"}}

        This.upload_window := browserDict[This.window]["upload"]
        This.browser_window := browserDict[This.window]["normal"]
    }

    getDirectory() {
        ; Asks user which directory they would like to upload from. If no response uses default directory.
        InputBox, directory, Directory, Please enter the directory containg the references.
        if ErrorLevel
            Exit

        if (directory) {
            directory := directory UploadSession.file_default
        } else {
            directory := "C:\Users\" A_UserName "\Desktop\upload" UploadSession.file_default
        }
        This.directory := directory
    }

    countFiles() {
        num := 0
        loop, Files, % This.directory
            num := A_Index
        This.file_count := num
    }

    getForeignCount() {
        While (This.foreignValid != True) {
            ; While loop to request and check foreign ref number for validity
            This.promptForeign()
            This.verifyForeign()
        }
    }

    promptForeign() {
        ; function to display input box and request the number of foreign references from user.
        InputBox, num, Foreign References, How many of the references being submitted are foreign references?
        if ErrorLevel
            Exit
        This.foreign_count := num
    }

    verifyForeign() {
        ; function to check in value given for foreign references is valid.
        if (This.foreign_count < 0) {
            MsgBox % "Number of Foreign references cannot be negative. Please only enter either 0 or positive numbers."
            This.foreignValid := False
        } else if isNotInt(This.foreign_count) {
            MsgBox % "Please only enter either 0 or positive numbers."
            This.foreignValid := False
        } else if This.foreign_count > This.file_count {
            MsgBox % "Number of foreign refs cannot be larger than number of total files. "
            This.foreignValid := False
        } else {
            This.foreignValid := True
        }
    }

    verifyContinue() {
        MsgBox, 1, Continue?, % "AutoHotkey has found " . This.file_count . " files to upload.`r`rClick OK to continue or Cancel to quit."
        ifMsgBox Cancel
            Exit
    }

    submitLoop() {
        ; Loop through references to upload to FIP.
        Sleep, % UploadSession.submitDelay  ; Prevents occasional issue where window is not activated properly after clicking "ok"

        Loop, Files, % This.directory
        {
            This.submitRef(A_LoopFileFullPath)
            if (A_Index = This.file_count or Mod(A_index, 20) = 0) {
                continue
            } else {
                This.openUploadWindow() ; Automatically open upload window except for every 20th
            }
        }
        MsgBox, % "AutoHotkey has attempted to select all " . This.file_count . " files."
    }

    submitRef(file) {
        ; function to manipulate web browser to submit select and upload references.
        IfWinNotActive, % This.upload_window, , WinActivate, % This.upload_window,
        WinWaitActive, % This.upload_window,
        Send, %file%
        Sleep, % UploadSession.submitDelay
        Send, {ENTER}
        Sleep, % UploadSession.submitDelay

        IfWinNotActive, % This.browser_window, , WinActivate, % This.browser_window,
        WinWaitActive, % This.browser_window
        ; Sleep, 10000  ; Wait for file to be "received" only use when virtual desktop is behaving weirdly
        Send, {TAB}i
        if (A_Index <= This.foreign_count) {
            ; Sleep, % UploadSession.submitDelay ; option sleep if going to fast for computer. Remove first ";" to activate
            Send, {TAB}f
        } else {
            Send, {TAB}n
            ; Sleep, % UploadSession.submitDelay ; option sleep if going to fast for computer. Remove first ";" to activate
        }
        Sleep, % UploadSession.submitDelay
    }

    openUploadWindow() {
        ; Function to enter keyboard commands to open upload window to prep for next reference.
        if (This.window = "firefox.exe") {  ; Doesn't actually work.
            Send, {TAB 3}{SPACE}{SHIFTDOWN}{TAB 5}{SHIFTUP}{SPACE}
        } else {
            Send, {TAB 3}{SPACE}
            Sleep % UploadSession.submitDelay
            Send, {SHIFTDOWN}{TAB 5}{SHIFTUP}{SPACE}
            Sleep % UploadSession.submitDelay
        }
    }
}

isNotInt(str) {
    ; function to check if value is integer.
    ; I am not sure why but this doesn't work in-line so I had to make a little function to do it.
    if str is not integer
        return True
    return False
}
