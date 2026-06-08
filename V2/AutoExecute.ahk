; Directives
#Requires AutoHotkey v2.0

; Includes
#Include "%A_LineFile%\..\Lib\Internal"
#Include "Logger.ahk"

; Auto-Execute Commands
; ==============================================================================
; Initialize the global logger instance
Logger.Init(LoggerSettings(true, A_MyDocuments . "\AutoHotkey\Logs\", "yyyy/MM/dd HH:mm:ss", "INFO"))

;windowManager := New WindowManagerInterface([pandora, New WindowInterface("ahk_exe Signal.exe"), New WindowInterface("Microsoft To Do"), New WindowInterface("Pocket Casts Desktop")])
