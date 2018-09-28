; Play around with this: https://github.com/cocobelgica/AutoHotkey-JSON

python_to_clip(script, options:="") {
    py_command :=  "py.exe " . script . " " . options
    full_command := "&{" . py_command . " | clip.exe}"

    RunWait, pwsh.exe -NoProfile -Command %full_command%,, hide

    return Clipboard
}

python_to_file(script, options:="") {
    EnvGet, temp_folder, TEMP
    temp_file_path := temp_folder . "\python_to_file.tmp"

    py_command :=  "py.exe " . script . " " . options
    full_command := "&{" . py_command . " > " . temp_file_path . "}"

    RunWait, pwsh.exe -NoProfile -Command %full_command%,, hide

    FileRead, res, %temp_file_path%

    return res
}

python_test_func() {
    func := "python_to_file"
    py_file := "C:\Users\Patrick\Documents\programming\ahk\python\test.py"
    timer_wrapper(func, py_file)
    MsgBox, % %func%(py_file)
}

!^p::
    python_test_func()
return
