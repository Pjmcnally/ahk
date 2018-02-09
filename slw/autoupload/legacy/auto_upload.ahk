;Scripts below mass upload documents to USPTO
;Version 2.0
;last updated 01-24-17
;Created by Patrick McNally

#z::
#i::
#c::
;This is my new attempt at a master upload script to work on any browser (It currently supports IE and Chrome).

main()

checkCancel(Val) {
    ; Function to check in Cancel has been clicked and, if yes, terminate the currently running thread of this script
    if (Val) {
        Exit
    }
}

getRefNums() {
    ; Function to display input box and request reference numbers from user.
    InputBox, First, First reference, Please enter the number preceeding the underscore of the FIRST reference being submitted (For Example 1 or 0001)
    checkCancel(ErrorLevel)
    InputBox, Last, Last reference, Please enter the number preceeding the underscore of the LAST reference being submitted (For Example 20 or 0020)
    checkCancel(ErrorLevel)

    Results := {"First": First, "Last": Last}
    return Results
}

getForNum() {
    ; function to display input box and request the number of foreign references from user.
    InputBox, temp, Foreign References, How many of the references being submitted are foreign references?
    checkCancel(ErrorLevel)
    return temp
}

checkNums(numArray, maxRefs) {
    ; Function to check numArray to make sure answers are Valid

    ; Check to make sure first and last are both numbers.
    if ( isNotInt(numArray["First"]) or isNotInt(numArray["Last"]) ) {
        MsgBox % "One of your responses is not an integer.  Please only enter positive numbers for First and last."
        return false

    ; Check to make sure first num is greater than 0.
    } else if (numArray["First"] <= 0) {
        MsgBox % "One of your numbers is less than or equal to 0.  Please only enter positive numbers for First and last."
        return false

    ; Check to make sure First num is not greater than last.
    } else if (numArray["First"] > numArray["Last"]) {
        MsgBox % "Please make sure that the number of the Last reference is greater than the number of the First reference"
        return false

    ; Check to make sure number of refs to submit is not greater than maxRefs.
    } else if (numArray["Last"] - numArray["First"] + 1 > MaxRefs) {
        MsgBox % "That is too many references.  You can only submit 20 references in one submission.  Please re-enter the numbers of the first and last references."
        return false

    ; If all check fail then return true.
    } else {
        return true
    }

}

isNotInt( str ) {
    ; function to check if value is integer.
    if str is not integer
        return true
    return false
}

checkFor(numArray) {
    ; function to check in value given for foreign references is valid.
    if (numArray["foreign"] < 0) {
        MsgBox % "Number of Foreign references cannot be negative.  Please only enter either 0 or positive numbers."
        return false
    } else if (numArray["foreign"] > numArray["Last"] - numArray["First"] + 1) {
        MsgBox % "You cannot submit more foreign references than total references.  Please re-enter the number of foreign referneces."
        return false
    } else {
        return true
    }
}

submitRef(num, maxFor, dict, browser, submitDelay) {
    ; function to manipulate web broser to submit select and upload references.

    uploadWindow := dict[browser]["upload"]
    normalWindow := dict[browser]["normal"]

    foreign := (num <= maxFor)

    num += 0.0 ; To set to float to format properly. For more info see note by SetFormat call in main

    IfWinNotActive, %uploadWindow%, , WinActivate, %wuploadWindow%,
    WinWaitActive, %uploadWindow%,
    Sleep, %submitDelay%  ; This line is optional and may help on slower computers.
    SendInput, {SHIFTDOWN}{TAB}{TAB}{SHIFTUP}  ; if "Use inline AutoComplete in File Explorer and Run Dialog" option is enabled in internet options this line is not required.
    Sleep, %submitDelay%  ; This line is optional and may help on slower computers.
    SendInput, %num%
    sleep, %submitDelay%
    SendInput, {ENTER}
    Sleep, %submitDelay%

    IfWinNotActive, ahk_class %normalWindow%, , WinActivate, ahk_class %normalWindow%,
    WinWaitActive, ahk_class %normalWindow%
    SendInput, {TAB}i
    if (foreign) {
        SendInput, {TAB}f
    } else {
        sendInput, {TAB}n
    }
    Sleep, %submitDelay%
}

main() {
    ; These are the hardcoded variables.  If anything changes this is where you will need to change stuff.
    SetFormat, float, 04 ; sets float format so that when numbers are coverted to float leading 0's will pad them to set digit count to match renaming scheme
    submitDelay := 100 ; 100 is default. Increase this number to slow down the submission process if it is breaking.  Do not set below 100 or errors may occur.
    MaxRefs := 20 ; This is determined by the USPTO and is hard coded.
    browseDict := {"chrome.exe": {"upload": "Open", "normal": "Chrome_WidgetWin_1"}
        , "firefox.exe": {"upload": "File Upload", "normal": "MozillaWindowClass"}
        , "IEXPLORE.EXE": {"upload": "Choose File to Upload", "normal": "IEFrame"}} ; dict of supported browsers and the names of the window where the files to be uploaded are selected.

    WinGet, browser, ProcessName, A

    if (browser != "chrome.exe" and browser != "iexplore.exe") {
        MsgBox % "Please make sure to your Chrome or Internet Explorer window is active before using hotkey."
        Exit
    }

    While (numsValid != true) {
        ; While loop to request and check First and Last numbers for validity
        Nums := getRefNums()
        numsValid := checkNums(Nums, MaxRefs)
    }
    While (forValid != true) {
        ; While loop to request and check foreign ref number for validity
        Nums["Foreign"] := getForNum()
        forValid := checkFor(Nums)
    }

    ; Variables used for filing
    totalRefs := Nums["last"] - Nums["first"] + 1 ; fixed off by one problem (if first = 1 and last = 20 there are 20 not 19)
    forRefs := Nums["foreign"]
    NPLRefs := totalRefs - Nums["foreign"]

    forRefMax := Nums["foreign"] + Nums["first"] -1 ; fixed off by one problem (fir first = 1 and numFor -= 20 the last foreign is 20 not 21)
    refNum := Nums["first"]

    While (refNum <= Nums["last"]) {
        ; While loop to iterate over and submit references
        submitRef(refNum, forRefMax, browseDict, browser, submitDelay)

        if (refnum >= Nums["last"]) {
            MsgBox % "AutoHotkey has attempted to select all references. There should be " forRefs " Foreign and " NPLRefs " NPL References.  There should be a total of " totalRefs " references.  If this is correct please click 'Upload and Validate'"
        ; } else if (Mod(refNum - 1, 20) = 0) {  ; These two lines are used in the looping variant
        ;    ; Do nothing but skip code below.   ; If you want to use the loop variant use that file.
        } else {
            SendInput, {TAB 3}{SPACE}
            Sleep %submitDelay%,
            sendInput, {SHIFTDOWN}{TAB 5}{SHIFTUP}{SPACE}
            Sleep %submitDelay%,
        }

        refNum += 1
    }
}
return

#x::
;This version works in FireFox
SetKeyDelay, 100

;Defining variables
First := 0
Last := 0
RefNum := 0
RefSub := 0
NumbOfRef := 100
NumbOfFor := 100
NumbOfNPL := 0


;This section requests input from the user regarding the first and last numbers of the references being submitted
While % NumbOfRef >20
{
    InputBox, First, First reference, Please enter the number preceeding the underscore of the FIRST reference being submitted. For Example 1 or 0001.
    InputBox, Last, Last reference, Please enter the number preceeding the underscore of the LAST reference being submitted. For Example 20 or 0020.

    if % First > Last
{
        NumbOfRef := 0
        NumbOfFor := 0
        MsgBox % "Please make sure that the number of the First reference is lower than the number of the Last reference"
        Break
}

    NumbOfRef := (Last - First + 1)
    If NumbOfRef > 20
        MsgBox % "That is too many references.  You can only submit 20 references in one submission.  Please re-enter the numbers of the first and last references."
}

;This section request input from the user regarding the number of foreign references to be submitted
While % NumbOfFor > NumbOfRef
{
    InputBox, NumbOfFor, Foreign References, How many of the references being submitted are foreign references?
    If % NumbOfFor > NumbOfRef
        MsgBox % "You cannot submit more foreign references than total references.  Please re-enter the number of foreign referneces."
}

RefNum := First - 1 + .0000
SetFormat, float, 04.0
RefNum += 0  ; Sets Var to be 000011

While % RefSub < NumbOfFor
{
    RefNum := (RefNum + 1.0)
    RefSub := (RefSub + 1)
    WinWait, File Upload,
    IfWinNotActive, File Upload, , WinActivate, File Upload,
    WinWaitActive, File Upload,
    Send, {SHIFTDOWN}{TAB}{TAB}{SHIFTUP}%RefNum%{ENTER}
    WinWait, ahk_class MozillaWindowClass,
    IfWinNotActive, ahk_class MozillaWindowClass, , WinActivate, ahk_class MozillaWindowClass,
    WinWaitActive, ahk_class MozillaWindowClass,
    Send, {TAB}i{TAB}f
    If % RefSub = NumbOfRef
        MsgBox AutoHotkey has attempted to select all references.  There should be %NumbOfFor% Foreign and %NumbOfNPL% NPL References.  There should be a total of %RefSub% references.  If this is correct please click "Upload and Validate"
    Else
        Send, {TAB 3}{SPACE}{SHIFTDOWN}{TAB 5}{SHIFTUP}{SPACE}
}

While % RefSub < NumbOfRef
{
    RefNum := (RefNum + 1.0)
    RefSub := (RefSub + 1)
    NumbOfNPL := (NumbOfNPL + 1)
    WinWait, File Upload,
    IfWinNotActive, File Upload, , WinActivate, File Upload,
    WinWaitActive, File Upload,
    Send, {SHIFTDOWN}{TAB}{TAB}{SHIFTUP}%RefNum%{ENTER}
    WinWait, ahk_class MozillaWindowClass,
    IfWinNotActive, ahk_class MozillaWindowClass, , ahk_class MozillaWindowClass,
    WinWaitActive, ahk_class MozillaWindowClass,
    Send, {TAB}i{TAB}N
    If % RefSub = NumbOfRef
        MsgBox AutoHotkey has attempted to select all references.  There should be %NumbOfFor% Foreign and %NumbOfNPL% NPL References.  There should be a total of %RefSub% references.  If this is correct please click "Upload and Validate"
    Else
        Send, {TAB 3}{SPACE}{SHIFTDOWN}{TAB 5}{SHIFTUP}{SPACE}
}
