class Diablo3Interface {
    Static SkillKeys := ["q", "w", "e", "r"]
    Static TimerFreq := 1000  ; milliseconds

    __New() {
        this.Skills := {}

        for i, skill in this.SkillKeys {
            this.Skills[skill] := new Diablo3Skill(skill, this.TimerFreq)
        }
    }

    Toggle(skillLetter) {
        this.Skills[skillLetter].Toggle()
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
        this.Timer := ; initialize timer to null
        this.TimerFreq := freq
        This.Timer := ObjBindMethod(this, "UseSkill")
    }

    Toggle() {
        if(this.Active) {
            this.disable()
        } else {
            this.enable()
        }
    }

    Enable() {
        this.Active := True
        this.UseSkill()  ; Trigger immediately

        ; Activate timer
        timer := this.Timer  ; Not sure why this line is necessary but it is.
        SetTimer, % timer, % this.TimerFreq,
    }

    Disable() {
        this.Active := false

        ; Deactivate time
        timer := this.Timer
        setTimer, % timer, OFF
    }

    UseSkill() {
        if(WinActive(this.Window)) {
            Send, % this.Letter
        }
    }
}

#IfWinActive, Diablo III
7::D3.Toggle("q")
8::D3.Toggle("w")
9::D3.Toggle("e")
0::D3.Toggle("r")
~b::D3.DisableAll()
; This should always be at the bottom
#IfWinActive ; End #IfWinActive for Diablo 3
