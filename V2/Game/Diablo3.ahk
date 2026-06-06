; Directives
#Requires AutoHotkey v2.0

; Includes
#Include "%A_LineFile%\..\..\Lib\Internal"
#Include "Diablo.ahk"

; Hotkeys
#HotIf WinActive("Diablo III")
; Basic hotkeys
c::Send("{Enter}")

; Skill base hotkeys - Change timings as necessary depending on current class.
; Toggle individual skill
7::D3Skill("Toggle", "q", 1000)
8::D3Skill("Toggle", "w", 1000)
9::D3Skill("Toggle", "e", 5000)
0::D3Skill("Toggle", "r", 1000)

; Enable all
-:: {
    D3Skill("Enable", "{Numpad1}", 1000)  ; Q
    D3Skill("Enable", "{Numpad2}", 1000)  ; W
    D3Skill("Enable", "{Numpad3}", 5000)  ; E
    D3Skill("Enable", "{Numpad4}", 1000)   ; R
}

; Disable all
~Space::D3Skill("DisableAll")
~m::D3Skill("DisableAll")
~b::D3Skill("DisableAll")
#HotIf ; End #IfWinActive for Diablo 3

; Functions
/**
 * @description `D3Skill()`
 * Toggles, enables or disables a specific skill in the game Diablo 3.
 * @param {(String)} key
 * The in game key assigned to the skill.
 * @param {(String)} mode
 * The mode to use for the skill. Can be either `toggle`, `enable`, `disable`, or `disableAll`.
 * Modes are not case sensitive.
 * @param {(Number)} delay
 * The amount of time in milliseconds to wait between activations of the skill (when active).
*/
D3Skill(mode, skill := "*", delay := 1000) {
    static D3 := Diablo("Diablo III")

    switch mode, 0 { ; 0 enables case insensitive comparison.
        case "toggle": D3.GetSkill(skill).Toggle(delay)
        case "enable": D3.GetSkill(skill).Enable(delay)
        case "disable": D3.GetSkill(skill).Disable(delay)
        case "disableAll": D3.DisableAll()
        default: throw("Invalid mode specified.")
    }
}
