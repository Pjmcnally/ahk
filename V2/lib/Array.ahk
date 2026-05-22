#Requires AutoHotkey v2.0

; Array.ahk - Extension methods for Array objects

/**
 * @description `Join()`
 * Joins the elements of an array into a string, separated by a specified delimiter.
 * @param {(String)} Delimiter
 * The string to use as a separator.
 * @returns {(String)}
 * The joined string.
 */
Array_Join(this, Delimiter := ",") {
    str := ""
    for index, value in this {
        str .= (index = 1 ? "" : Delimiter) . value
    }
    return str
}

/**
 * @description `Includes()`
 * Checks if a value exists in an array.
 * @param {(String)} Value
 * The value to search for.
 * @returns {(Boolean)}
 * True if the value exists in the array, false otherwise.
 */
Array_Includes(this, Value) {
    for index, element in this {
        if (element = Value) {
            return true
        }
    }
    return false
}

; Inject the methods into the Array prototype so they can be called on any array instance
Array.Prototype.DefineProp("Join", {Call: Array_Join})
Array.Prototype.DefineProp("Includes", {Call: Array_Includes})
