; Directives
#Requires AutoHotkey v2.0

; Includes
#Include "%A_LineFile%\..\..\Lib\Internal"
#Include "Diablo.ahk"

; Hotkeys
HotIfWinActive("Diablo III")
#HotIf WinActive("Diablo III")
; Basic hotkeys
Hotkey("XButton1", (*) => D3EnableAll("UeDh"))
Hotkey("XButton2", (*) => D3Skill("DisableAll"))

; Disable all - PassThru mode to allow actual buttons to register in game.
~Escape::D3Skill("DisableAll")
~Space::D3Skill("DisableAll")
~m::D3Skill("DisableAll")
~b::D3Skill("DisableAll")

; Misc hotkeys
n::Send('{Enter}')

; Below section is disabled as it only applies to Monk (which I am not playing this season).
; ; HotIf for D3 and Right Click held down to use left click to dash.
; #HotIf WinActive("Diablo III") && GetKeyState("RButton", "P")
; LButton::Send("e")
#HotIf ; End #IfWinActive for Diablo 3
HotIfWinActive() ; End HotIfWinActive for Diablo 3

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

D3EnableAll(build) {
    Send("{Space 3}")  ; Clear any onscreen messages
    switch build, 0 {
        case "wwBarb":
            D3Skill("Enable", "w", 30000) ; W
            D3Skill("Enable", "e", 1000)  ; E
            D3Skill("Enable", "r", 1000)  ; R
        case "pojMonk":
            Send("q")                     ; Activate Sweeping Wind
            D3Skill("Enable", "r", 1000)  ; R - toggle on
        case "UeDh":
            D3Skill("Enable", "w", 5000)  ; Cast "Shadow Power" every 5 seconds
            D3Skill("Enable", "e", 1000)  ; Cast "Smoke Screen" on CD
            D3Skill("Enable", "r", 1000)  ; Cast "Vengeance" on CD
        default: throw("Invalid class specified")
    }

    D3Skill("Enable", "1", 1000)  ; Use Potion on CD (For "Mother" buff)
}
