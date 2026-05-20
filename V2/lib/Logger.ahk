Class Logger {
    __New(path) {
        this.DateFormat := "yyyy/MM/dd HH:mm:ss"
        this.DefaultLogLevel := "INFO"
        this.FileObject := FileOpen(path, "a", "UTF-8-RAW")
    }

    WriteLine(text, level) {
        timeString := FormatTime(A_Now, this.DateFormat)
        logLevel := Format("{:-5}", level)
        output := timeString . " " . logLevel . " " . text . "`r`n"

        this.FileObject.Write(output)
        this.FileObject.Read(0) ; Flush the file buffer to ensure the log is written to disk immediately
    }

    Write(text) {
        this.WriteLine(text, this.DefaultLogLevel)
    }

    WriteInfo(text) {
        this.WriteLine(text, "INFO")
    }

    WriteDebug(text) {
        this.WriteLine(text, "DEBUG")
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
