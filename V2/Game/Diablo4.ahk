; Directives
#Requires AutoHotkey v2.0

; Includes
#Include "%A_LineFile%\..\..\Lib\Internal"
#Include "Diablo.ahk"

; Hotkeys
#HotIf WinActive("Diablo IV")
; Basic hotkeys
!c::Send("{Enter}")

; Skill hotkeys
; Toggle individual skill
7::MsgBox("text") ; D4Skill("Toggle", "{Numpad0}", 250)      ; RMouse
8::D4Skill("Toggle", "{Numpad1}", 250)      ; Q
9::D4Skill("Toggle", "{Numpad2}", 250)      ; W
0::D4Skill("Toggle", "{Numpad4}", 250)      ; R
Space::D4Skill("Toggle", "{Space}", 250)    ; Space (evade)

; Enable All
-:: {
    D4Skill("Enable", "{Numpad0}", 100)  ; RMouse
    D4Skill("Enable", "{Numpad1}", 250)  ; Q
    D4Skill("Enable", "{Numpad2}", 250)  ; W
    D4Skill("Enable", "{Numpad4}", 250)  ; R
}

; Disable all
~b::D4Skill("DisableAll") ; Back
~i::D4Skill("DisableAll") ; Inventory
~6::D4Skill("DisableAll") ; Mount
#HotIf ; End #IfWinActive for Diablo 4

; Functions
/**
 * @description `D3Skill()`
 * Toggles, enables or disables a specific skill in the game Diablo 4.
 * @param {(String)} key
 * The in game key assigned to the skill.
 * @param {(String)} mode
 * The mode to use for the skill. Can be either `toggle`, `enable`, `disable`, or `disableAll`.
 * Modes are not case sensitive.
 * @param {(Number)} delay
 * The amount of time in milliseconds to wait between activations of the skill (when active).
*/
D4Skill(mode, skill := "*", delay := 1000) {
    static D4 := Diablo("Diablo IV")

    switch mode, 0 { ; 0 enables case insensitive comparison.
        case "toggle": D4.GetSkill(skill).Toggle(delay)
        case "enable": D4.GetSkill(skill).Enable(delay)
        case "disable": D4.GetSkill(skill).Disable(delay)
        case "disableAll": D4.DisableAll()
        default: throw("Invalid mode specified.")
    }
}
