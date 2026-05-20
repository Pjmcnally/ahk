#Requires AutoHotkey v2.0

Array_Join(arr, delimiter := ",") {
    str := ""
    for index, value in arr {
        str .= (index = 1 ? "" : delimiter) . value
    }
    return str
}

Array_Includes(arr, value) {
    for index, element in arr {
        if (element = value) {
            return true
        }
    }
    return false
}

Array.Prototype.DefineProp("Join", {Call: Array_Join})
Array.Prototype.DefineProp("Includes", {Call: Array_Includes})
