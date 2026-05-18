Class Logger {
    __New(path) {
        this.Path := path
        this.DateFormat := "yyyy/MM/dd HH:mm:ss"
        this.DefaultLogLevel := "INFO"
    }

    WriteLine(text, level) {
        timeString := f_date("", this.DateFormat)
        logLevel := Format("{:-5}", level)
        output := timeString . " " . logLevel . " " . text . "`r`n"

        FileAppend, % output, % this.Path
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

    WriteError(text, e, notify) {
        this.WriteLine(text, "ERROR")
        this.WriteErrorDetail(e)
        if (notify) {
            SoundPlay, *16  ; https://www.autohotkey.com/docs/commands/SoundPlay.htm
            MsgBox, % text
        }
    }

    WriteFatal(text, e, notify) {
        this.WriteLine(text, "FATAL")
        this.WriteErrorDetail(e)
        if (notify) {
            SoundPlay, *16  ; https://www.autohotkey.com/docs/commands/SoundPlay.htm
            MsgBox, % text
        }
    }

    WriteErrorDetail(e) {
        if (e.Message) {
            this.WriteLine("Message " . e.Message)
        }
        if (e.What) {
            this.WriteLine("What " . e.What)
        }
        if (e.Extra) {
            this.WriteLine("Extra " . e.Extra)
        }
        if (e.File or e.Line) {
            this.WriteLine(e.File . " " . e.Line)
        }
    }
}
