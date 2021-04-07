class Diablo3Interface {
    Static SkillKeys := ["q", "w", "e", "r"]
    Static TimerFreq := 1000  ; milliseconds

    __New() {
        this.Skills := {}

        for i, skill in this.SkillKeys {
            this.Skills[skill] := new Diablo3Skill(skill, this.TimerFreq)
        }
    }

    Toggle(skillLetter, freq:="") {
        this.Skills[skillLetter].Toggle(freq)
    }

    DisableAll() {
        for key, val in this.Skills {
            val.Disable()
        }
    }
}

class Diablo3Skill {
    Static Window := "Diablo III"

    __New(SkillLetter, freq) {
        this.Active := false
        this.Letter := SkillLetter
        this.TimerFreq := freq
        This.Timer := ObjBindMethod(this, "UseSkill")
    }

    Toggle(freq) {
        (this.Active) ? this.disable() : this.enable(freq)
    }

    Enable(freq) {
        if (!freq) {
            freq := this.TimerFreq
        }

        this.Active := True
        this.UseSkill()  ; Trigger immediately

        ; Activate timer
        timer := this.Timer  ; Not sure why this line is necessary but it is.
        SetTimer, % timer, % freq,
    }

    Disable() {
        this.Active := false

        ; Deactivate time
        timer := this.Timer
        setTimer, % timer, OFF
    }

    UseSkill() {
        if (WinActive(this.Window)) {
            Send, % this.Letter

            Random, delay, 100, 300
            Sleep, % delay
        }
    }
}

#IfWinActive, Diablo III
7::D3.Toggle("q")
8::D3.Toggle("w", 120000)
9::D3.Toggle("e", 4000)
0::D3.Toggle("r")
c::Send {Enter}

; Disable all Hotkeys
~Space::D3.DisableAll()
~m::D3.DisableAll()
~b::D3.DisableAll()
#IfWinActive ; End #IfWinActive for Diablo 3
