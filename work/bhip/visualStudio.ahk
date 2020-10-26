finish_build() {
    ; Update local database (conditional on additional input)
    Input, var, T2 L1, {Space}{Tab}{Enter}
    if (var = "y") {
        Run, % get_update_database_url() ,, Min
    }

    ; Update plugin server
    pluginServerPath := get_dev_path() . "\pluginServer"
    RunWait, %pluginServerPath%\z Refresh Plugins.cmd, %pluginServerPath%

    ; Clear all previous log files
    FileRecycle, %pluginServerPath%\InfoLogs\*
    FileRecycle, %pluginServerPath%\Logs\*
}

^!+F6::finish_build()
