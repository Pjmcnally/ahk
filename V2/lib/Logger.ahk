Class Logger {
    static logLevels := {TRACE: 1, DEBUG: 2, INFO: 3, WARN: 4, ERROR: 5, FATAL: 6, OVER: 7}

    __New(path, logLevel := "INFO") {
        this.Path := path
        this.DateFormat := "yyyy/MM/dd HH:mm:ss"
        this.DefaultLogLevel := "INFO"
        this.LogLevel := logLevel
        this.FileObject := FileOpen(path, "a", "UTF-8-RAW")
        this.WriteLine("Log started. Current level: " . logLevel . " Log Location: " . path, "OVER")
    }

    WriteLine(text, level) {
        ; Only write to the log if the log level of the message is greater than or equal to the current log level of the logger
        if (Logger.logLevels[level] >= Logger.logLevels[this.LogLevel]) {
            timeString := FormatTime(A_Now, this.DateFormat)
            logLevel := Format("{:-5}", level)
            output := timeString . " " . logLevel . " " . text . "`r`n"

            this.FileObject.Write(output)
            this.FileObject.Read(0) ; Flush the file buffer to ensure the log is written to disk immediately
        }
    }

    Write(text) {
        this.WriteLine(text, this.DefaultLogLevel)
    }

    WriteTrace(text) {
        this.WriteLine(text, "TRACE")
    }

    WriteDebug(text) {
        this.WriteLine(text, "DEBUG")
    }

    WriteInfo(text) {
        this.WriteLine(text, "INFO")
    }

    WriteWarn(text) {
        this.WriteLine(text, "WARN")
    }

    WriteError(text, e := "", notify := false) {
        this.WriteLine(text, "ERROR")

        if (e) {
            this.WriteErrorDetail(e)
        }

        if (notify) {
            SoundPlay("*16")  ; https://www.autohotkey.com/docs/commands/SoundPlay.htm
            MsgBox(text)
        }
    }

    WriteFatal(text, e, notify) {
        this.WriteLine(text, "FATAL")

        if (e) {
            this.WriteErrorDetail(e)
        }

        if (notify) {
            SoundPlay("*16")  ; https://www.autohotkey.com/docs/commands/SoundPlay.htm
            MsgBox(text)
        }
    }

    WriteOver(text) {
        this.WriteLine(text, "OVER")
    }

    WriteErrorDetail(e) {
        if (e.Message) {
            this.WriteLine("Message " . e.Message, "ERROR")
        }
        if (e.What) {
            this.WriteLine("What " . e.What, "ERROR")
        }
        if (e.Extra) {
            this.WriteLine("Extra " . e.Extra, "ERROR")
        }
        if (e.File or e.Line) {
            this.WriteLine(e.File . " " . e.Line, "ERROR")
        }
    }

    Dispose() {
        if (this.FileObject) {
            this.FileObject.Close()
        }
    }
}
