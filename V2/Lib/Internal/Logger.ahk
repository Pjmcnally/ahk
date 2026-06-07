; Directives
#Requires AutoHotkey v2.0

; TODO: Review this for any ideas to implement: https://www.autohotkey.com/boards/viewtopic.php?t=59127

/**
 * @description
 * A data object class for Logger settings. This is used to configure the Logger class when initializing it with the {@link Logger.Init} method.
 * @property {(Boolean)} Enabled
 * Whether logging is enabled. If false, the Logger will not write any log entries and will ignore all calls to write to the log. This can be used to disable logging without having to change the log level or other settings.
 * @property {(String)} FolderPath
 * The path to the folder where log files will be stored.
 * @property {(String)} DateFormat
 * The format for dates in the log. This uses the same format specifiers as the {@link https://www.autohotkey.com/docs/v2/lib/FormatTime.htm|FormatTime} function.
 * @property {(String)} MinimumLogLevel
 * The minimum level of messages to log. The levels are (in order of severity): "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL".
 * Any messages with a log level that has a numeric value less than the numeric value of the MinimumLogLevel will not be logged.
 */
class LoggerSettings {
    __New(enabled, folderPath, dateFormat, minimumLogLevel) {
        this.Enabled := enabled
        this.FolderPath := folderPath
        this.DateFormat := dateFormat
        this.MinimumLogLevel := minimumLogLevel
    }
}

/**
 * @description
 * A static class for writing to a log file.
 * This class is static and should not be instantiated. All methods and properties are static and can be accessed directly from the class.
 * This class does need to be initialized with the {@link Logger.Init} method before it can be used. This will setup the log file and folder based on the provided settings.
 * If the log file already exists, it will be appended to. If it does not exist, it will be created.
 * If the class is not initialized, calls to write to the log will be ignored and no logging will occur. Any failures will happen silently.
 * See {@link LoggerSettings} for the settings that can be used to configure the Logger.
 * @property {(Boolean)} IsEnabled
 * Indicates whether logging is enabled.
 * Default = False
 * @property {(Map)} LogLevels
 * A map of log levels to their corresponding numeric values for comparison. Higher numeric values indicate higher severity.
 * The levels are: "TRACE"=1, "DEBUG"=2, "INFO"=3, "WARN"=4, "ERROR"=5, "FATAL"=6, "OVER"=7.
 * OVER (short for "Override") is a special log level that is above all other levels and will always be logged regardless of the MinimumLogLevel setting.
 * It can be used for important messages that should always be logged but are not errors, such as startup messages or critical configuration information.
 */
class Logger {
    static IsEnabled := false
    static LogLevels := Map(
        "TRACE", 1,
        "DEBUG", 2,
        "INFO",  3,
        "WARN",  4,
        "ERROR", 5,
        "FATAL", 6,
        "OVER",  7
    )

    __Call() {
        throw Error("This class is static and cannot be called.", -1)
    }

    __New() {
        throw Error("This class is static and cannot be instantiated.", -1)
    }

    /**
     * @description `Init()`
     * Static method to initialize the logger with the specified settings. See {@link LoggerSettings} for the settings that can be used to configure the Logger.
     * @param {LoggerSettings} settings
     * The settings for the logger.
     */
    static Init(settings) {
        if (settings and (settings is LoggerSettings)) {
            this._ReadSettings(settings)
            this._CreateLogFile()
        } else {
            this.IsEnabled := false
        }

        OnExit(Logger.Cleanup)
    }

    /**
     * @description `_ReadSettings()`
     * Static internal method to read the settings for the logger. See {@link LoggerSettings} for the settings that can be used to configure the Logger.
     * @param {LoggerSettings} settings
     * The settings for the logger.
     * If settings are not provided or are invalid the logger is disabled.
     */
    static _ReadSettings(settings) {
        this.IsEnabled := settings.HasProp("Enabled") ? settings.Enabled : false
        this.DateFormat := settings.HasProp("DateFormat") ? settings.DateFormat : ""
        this.LogFolderPath := settings.HasProp("FolderPath") ? settings.FolderPath : ""
        this.MinimumLogLevel := settings.HasProp("MinimumLogLevel") ? settings.MinimumLogLevel : ""
    }

    /**
     * @description `_CreateLogFile`
     * Static internal method to create a new log file and any required directories for the provided path. If the log file already exists new data will be appended.
     */
    static _CreateLogFile() {
        ; Setup folder and file for logging
        this.logFileName := FormatTime(A_Now, "yyyy-MM-dd") . ".log"
        this.logFullPath := this.logFolderPath . this.logFileName
        if (!DirExist(this.logFolderPath)) {
            DirCreate(this.logFolderPath)
        }

        ; Create file object
        this.FileObject := FileOpen(this.logFullPath, "a", "UTF-8-RAW")
        this._WriteLine("Log started. Minimum Log level=[" . this.MinimumLogLevel . "]. Log Location=[" . this.logFullPath . "]", "OVER")
    }

    /**
     * @description `_RollLogFile`
     * Static internal method to roll over log file in the date has changed since the last entry.
     */
    static _RollLogFile() {
        ; Rotate log files if the date has changed since the last log entry. This will create a new log file for the new date and close the old log file.
        logDateDiff := DateDiff(A_Now, FileGetTime(this.logFullPath), "D")
        if (this.FileObject and (logDateDiff > 0)) {
            this.FileObject.Close()
            this.FileObject := "" ; Release closed file object reference
        }
        this._CreateLogFile()
    }

    /**
     * @description `_WriteLine`
     * Static internal method to add a line to the log file. This is only used internally. For public use try {@link Logger.WriteLog}.
     * @param {(String)} text
     * The text to add to the log file
     * @param {(String)} level
     * The log level of the line to add.
     * Because this method writes directly to the log it will add lines even if the log level is below the MinimumLogLevel.
     * That is one reason why this should not be used publicly. Instead use `WriteLog`
     */
    static _WriteLine(text, level) {
        timeString := FormatTime(A_Now, this.DateFormat)
        logLevel := Format("{:-5}", level)
        output := timeString . " " . logLevel . " " . text . "`r`n"

        this.FileObject.Write(output)
        this.FileObject.Read(0) ; Flush the file buffer to ensure the log is written to disk immediately
    }

    /**
     * @description `WriteLog`
     * Writes data to the log file.
     * @param {(String)} text
     * The text to add to the log file
     * @param {(String)} level
     * The log level of the line to add. If the log level is less than the MinimumLogLevel the call will be disregarded and nothing will be written to the log file.
     * If the logger is not enabled the call will be disregarded and nothing will be written to the log file.
     */
    static WriteLog(text, level) {
        if (this.IsEnabled and (this.logLevels[level] >= this.logLevels[this.MinimumLogLevel])) {
            this._RollLogFile()
            this._WriteLine(text, level)
        }
    }

    /**
     * @description `WriteTrace`
     * Writes data to the log file with an log level of "TRACE".
     * If this log level is less than the minimum log level the call will be disregarded and nothing will be written to the log.
     * If the logger is not enabled the call will be disregarded and nothing will be written to the log file.
     * @param {(String)} text
     * The text to add to the log file
     */
    static WriteTrace(text) {
        this.WriteLog(text, "TRACE")
    }

    /**
     * @description `WriteDebug`
     * Writes data to the log file with an log level of "DEBUG".
     * If this log level is less than the minimum log level the call will be disregarded and nothing will be written to the log.
     * If the logger is not enabled the call will be disregarded and nothing will be written to the log file.
     * @param {(String)} text
     * The text to add to the log file
     */
    static WriteDebug(text) {
        this.WriteLog(text, "DEBUG")
    }

    /**
     * @description `WriteInfo`
     * Writes data to the log file with an log level of "INFO".
     * If this log level is less than the minimum log level the call will be disregarded and nothing will be written to the log.
     * If the logger is not enabled the call will be disregarded and nothing will be written to the log file.
     * @param {(String)} text
     * The text to add to the log file
     */
    static WriteInfo(text) {
        this.WriteLog(text, "INFO")
    }

    /**
     * @description `WriteWarn`
     * Writes data to the log file with an log level of "WARN".
     * If this log level is less than the minimum log level the call will be disregarded and nothing will be written to the log.
     * If the logger is not enabled the call will be disregarded and nothing will be written to the log file.
     * @param {(String)} text
     * The text to add to the log file
     */
    static WriteWarn(text) {
        this.WriteLog(text, "WARN")
    }

    /**
     * @description `WriteError`
     * Writes data to the log file with an log level of "ERROR".
     * If this log level is less than the minimum log level the call will be disregarded and nothing will be written to the log.
     * If the logger is not enabled the call will be disregarded and nothing will be written to the log file.
     * @param {(String)} text
     * The text to add to the log file
     */
    static WriteError(text, e := "") {
        this.WriteLog(text, "ERROR")
    }

    /**
     * @description `WriteFatal`
     * Writes data to the log file with an log level of "FATAL".
     * If this log level is less than the minimum log level the call will be disregarded and nothing will be written to the log.
     * If the logger is not enabled the call will be disregarded and nothing will be written to the log file.
     * @param {(String)} text
     * The text to add to the log file
     */
    static WriteFatal(text, e := "") {
        this.WriteLog(text, "FATAL")

        if (e) {
            this._WriteErrorDetail(e)
        }
    }

    /**
     * @description `WriteOver`
     * Writes data to the log file with an log level of "OVER".
     * This log level is special and will always be written to the log as long as the logger is enabled.
     * @param {(String)} text
     * The text to add to the log file
     */
    static WriteOver(text) {
        this.WriteLog(text, "OVER")
    }

    /**
     * @description `_WriteErrorDetail`
     * Internal static function that writes AutoHotkey errors (with all internal parts) to the log file.
     * @param {(String)} text
     * The text to add to the log file
     */
    static _WriteErrorDetail(e) {
        if (e.Message) {
            this._WriteLine("Message " . e.Message, "ERROR")
        }
        if (e.What) {
            this._WriteLine("What " . e.What, "ERROR")
        }
        if (e.Extra) {
            this._WriteLine("Extra " . e.Extra, "ERROR")
        }
        if (e.File or e.Line) {
            this._WriteLine(e.File . " " . e.Line, "ERROR")
        }
    }

    /**
     * @description `Cleanup`
     * Static method to release the file handler from the logger class. This is typically called as a Callback to the OnExit function.
     */
    static Cleanup(*) {
        try{
            this.FileObject.Close()
        } catch Error as e {
            ; If we fail to close the file, there's not much we can do about it at this point since we're already exiting. Just swallow the error to prevent any unhandled exceptions during script exit.
        }
    }
}
