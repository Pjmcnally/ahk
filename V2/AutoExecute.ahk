; Directives
#Requires AutoHotkey v2.0

; Includes and
#Include "%A_LineFile%\..\Lib\Internal" ; Include the Lib directory for shared utilities and classes
#Include "Logger.ahk"
#Include "System.ahk"

; Auto-Execute Commands
; Create global logger instance for use in any included module. This will create the log file if it doesn't exist and append to it if it does exist.
GlobalLogger := Logger(System.DownloadsPath . "\Ahk_Logs\" . FormatTime(A_Now, "yyyy-MM-dd") . ".log", "INFO")

; Register the cleanup function to run on script exit/reload
OnExit(CleanupScript)
CleanUpScript(ExitReason, ExitCode) {
    global GlobalLogger
    GlobalLogger.Dispose()
}
;windowManager := New WindowManagerInterface([pandora, New WindowInterface("ahk_exe Signal.exe"), New WindowInterface("Microsoft To Do"), New WindowInterface("Pocket Casts Desktop")])
