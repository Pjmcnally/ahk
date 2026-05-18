finish_build(update_database) {
    ; Run database update process
    if (update_database) {
        Run, % get_update_database_url() ,, Min
    }

    ; Update plugin server
    pluginServerPath := get_dev_path() . "\pluginServer"
    RunWait, %pluginServerPath%\z Refresh Plugins.cmd, %pluginServerPath%

    ; Clear all previous log files
    FileRecycle, %pluginServerPath%\InfoLogs\*
    FileRecycle, %pluginServerPath%\Logs\*
}

; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
!^F6::finish_build(false)
^!+F6::finish_build(true)
