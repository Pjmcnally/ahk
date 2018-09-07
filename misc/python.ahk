; Play around with this: https://github.com/cocobelgica/AutoHotkey-JSON

run_python_script(script, write:=TRUE, options:="") {
    temp_file_path = "C:\temp\ahk\temp.txt"
    py_command :=  "py.exe " . script . " " . options

    if (write) {
        full_command := "&{" . py_command . " > " . temp_file_path . "}"
    } else {
        full_command := "&{" . py_command . "}"
    }

    RunWait, pwsh.exe -NoProfile -Command %full_command%,, hide

    Return
}
