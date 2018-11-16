/*  Python functions, hotstrings, and hotkeys.

    This module is a work in progress. The goal is to build an interface between
    AutoHotkey and Python such that AutoHotkey can call a Python script and then
    use the results of that script in AutoHotkey.
*/


; Functions
; ==============================================================================
python_to_clip(script, options:="") {
    /*  Run Python script and save results to clipboard.
    */
    py_command :=  "py.exe " . script . " " . options
    full_command := "&{" . py_command . " | clip.exe}"

    RunWait, pwsh.exe -NoProfile -Command %full_command%,, hide

    return Clipboard
}

python_to_file(script, options:="") {
    /*  Run Python script and save results to file in temp folder.
    */
    EnvGet, temp_folder, TEMP
    temp_file_path := temp_folder . "\python_to_file.tmp"

    py_command :=  "py.exe " . script . " " . options
    full_command := "&{" . py_command . " > " . temp_file_path . "}"

    RunWait, pwsh.exe -NoProfile -Command %full_command%,, hide

    FileRead, res, %temp_file_path%

    return res
}

python_test_func() {
    /*  Test function to try different methods of passing data.
    */
    func := "python_to_file"
    py_file := "C:\Users\Patrick\Documents\programming\ahk\python\py_test.py"
    timer_wrapper(func, py_file)
    MsgBox, % %func%(py_file)
}


; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
!^p::python_test_func()
