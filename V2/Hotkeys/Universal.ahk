#Requires AutoHotkey v2.0

; Meta control hotkeys
Hotkey("^!l", (*) => ListHotkeys()) ; Ctrl+Alt+L to list hotkeys
Hotkey("^!p", (*) => Pause(-1))     ; Ctrl+Alt+P to toggle pause
Hotkey("^!r", (*) => Reload())      ; Ctrl+Alt+R to reload script

/*
Idea 1:
To log all activated hotkeys in AutoHotkey v2, you can use a custom wrapper function that dynamically defines hotkeys, routes them to your handler, and appends the triggered key and timestamp to a log file.The following snippet logs your hotkeys both to the console (OutputDebug) and to a text file.

; ==========================================
; Hotkey Logging Wrapper
; ==========================================

LogHotkey(hotkeyString, actionFunction) {
    ; Define the hotkey and route it to our internal wrapper
    Hotkey(hotkeyString, TriggerWrapper)

    ; Inner function that logs and executes the intended action
    TriggerWrapper(ThisHotkey) {
        ; 1. Format the time and create the log message
        logMessage := FormatTime(, "yyyy-MM-dd HH:mm:ss") " - Activated: " ThisHotkey "`n"

        ; 2. Output to the Debugger (DbgView, VS Code, etc.)
        OutputDebug(logMessage)

        ; 3. Append to a log file (creates hotkey_log.txt in the script folder)
        FileAppend(logMessage, "hotkey_log.txt")

        ; 4. Call the actual function passed into the wrapper
        actionFunction(ThisHotkey)
    }
}

; ==========================================
; Implementation Examples
; ==========================================

; Example 1: Ctrl+Shift+N
LogHotkey("^+n", (*) => Run("notepad.exe"))

; Example 2: F1
LogHotkey("F1", (*) => MsgBox("F1 was pressed!"))

; Example 3: Win+C
LogHotkey("#c", (hotkey) => ToolTip("You triggered " hotkey))


Idea 1A: Get hotkey info:
Yes, in AutoHotkey v2 you can identify the currently executing function or method using the built-in A_ThisFunc variable. It returns a string containing the name of the function, or the method preceded by its class (e.g., ClassName.MethodName).Basic Exampleautohotkey#Requires AutoHotkey v2.0

MyMethod()

MyMethod() {
    MsgBox("Currently running method: " . A_ThisFunc)
}
Use code with caution.Advanced: Getting the Call StackIf your method calls other helper methods or functions and you want to trace the entire chain of execution, you can throw an Exception and inspect its stack trace.autohotkey#Requires AutoHotkey v2.0

Level1()

Level1() {
    Level2()
}

Level2() {
    Level3()
}

Level3() {
    ; Throw an exception to access the call stack
    try {
        throw Exception("")
    } catch as e {
        MsgBox("Execution path:\n" . e.Stack)
    }
}
Use code with caution.For tips on how to understand and utilize function objects to make your methods reusable:

Idea 2:
To redirect a custom function to a standard AutoHotkey v2 library function, define your custom function with the exact same name and parameters, and then pass the arguments to the library function. You can call the standard function directly by preceding it with the library prefix if one is used.The Redirect PatternIf your custom function needs to intercept a standard v2 function, rename the standard function (or scope it to its library namespace if it belongs to a Lib file), and return its result.ahk; Example: Overriding/redirecting the built-in MsgBox
MsgBox(Text, Title?, Options?) {
    ; Do your custom actions here (e.g., logging or changing parameters)
    MyCustomLogFunction("MsgBox was called with text: " Text)

    ; Redirect to the standard built-in MsgBox
    if IsSet(Title) and IsSet(Options)
        return MsgBox(Text, Title, Options)
    else if IsSet(Title)
        return MsgBox(Text, Title)
    else
        return MsgBox(Text)
}
Use code with caution.

Ideal 3:
To automatically write every hotkey activation to a text file or console, you can dynamically register your keys using Hotkey and a wrapper function. This avoids copy-pasting the same logging code everywhere.

#Requires AutoHotkey v2.0
LogFile := "hotkey_log.txt"

; Define your hotkeys and their corresponding actions/labels
myHotkeys := Map(
    "^j", "DoAction1",
    "^k", "DoAction2",
    "#c", "DoAction3"
)

; Dynamically loop and register them with a logging wrapper
for keys, action in myHotkeys {
    Hotkey(keys, LogAndExecute)
}

; This wrapper logs the key and triggers the mapped function
LogAndExecute(ThisHotkey) {
    global myHotkeys, LogFile

    ; 1. Add your logging logic here
    FileAppend(FormatTime(,"yyyy-MM-dd HH:mm:ss") " - Triggered: " ThisHotkey "`n", LogFile)

    ; 2. Execute the actual mapped function/label
    actionName := myHotkeys[ThisHotkey]
    if IsSet(%actionName%) or HasMethod(%actionName%)
        %actionName%()
    else
        MsgBox("Executed: " ThisHotkey " (Mapped action not found)")
}

; --- Action Functions ---
DoAction1() {
    MsgBox("You pressed Ctrl+J")
}

DoAction2() {
    MsgBox("You pressed Ctrl+K")
}

DoAction3() {
    Run("calc.exe")
}

*/
