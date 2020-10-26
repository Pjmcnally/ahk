finish_build() {
    ; Update local database
    Run, % get_update_database_url()

    ; Update plugin server
    pluginServerPath := get_dev_path() . "\pluginServer"
    RunWait, %pluginServerPath%\z Refresh Plugins.cmd, %pluginServerPath%

    ; Clear all previous log files
    FileRecycle, %pluginServerPath%\InfoLogs\*
    FileRecycle, %pluginServerPath%\Logs\*
}

^!+F6::finish_build()
