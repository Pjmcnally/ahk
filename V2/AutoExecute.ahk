; Directives
#Requires AutoHotkey v2.0

; Includes
#Include "%A_LineFile%\..\Lib\Internal" ; Include the Lib directory for shared utilities and classes
#Include "Logger.ahk"

; Auto-Execute Commands
; ==============================================================================
; Setup Logger
LoggerSettings := Map(
    "Enabled", true,
    "FolderPath", A_MyDocuments . "\AutoHotkey\Logs\",
    "DateFormat", "yyyy/MM/dd HH:mm:ss",
    "LogLevel", "INFO"
)
Logger.Init(LoggerSettings)
OnExit(Logger.Cleanup)

;windowManager := New WindowManagerInterface([pandora, New WindowInterface("ahk_exe Signal.exe"), New WindowInterface("Microsoft To Do"), New WindowInterface("Pocket Casts Desktop")])
