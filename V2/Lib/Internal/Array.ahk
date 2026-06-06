; Directives
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

/**
 * @description `GetRandomItem()`
 * Returns a random item from the array.
 * @returns {(Any)}
 * A random item from the array.
 */
Array_GetRandomItem(this) {
    if (this.Length() = 0) {
        return ""
    }

    randomIndex := Random(1, this.Length())
    return this[randomIndex]
}

/**
 * @description `GetRandomSample()`
 * Returns an array containing a randomly selected subset of the original array.
 * Order of the returned elements most likely will not match the original order.
 * @param {(Number)} Count
 * The number of items to select. If `Count` is greater than the length of the array, all items in the array will be returned.
 * @returns {(Array)}
 * An array containing a randomly selected subset of the original array.
 */
Array_GetRandomSample(this, count) {
    tempArray := this.clone() ; Create a temporary array so we don't modify the original
    tempArray.Shuffle() ; Randomize the order of the elements in the temporary array

    ; If we are going to return the entire array we can save some steps and just return it. No need to loop.
    if (tempArray.Length() >= count) {
        resultArray := tempArray
    } else { ; Otherwise we need to loop through the array until we have enough items.
        resultArray := []
        while (count > 0 and tempArray.Length() > 0) {
            resultArray.Push(tempArray.Pop())
            count -= 1
        }
    }

    return resultArray
}

/**
 * @description `Shuffle()`
 * Shuffles an array in place using the Fischer-Yates algorithm
 * @returns {(String)}
 * Always returns an empty string
 */
Array_Shuffle(this) {
    ; Loop backwards from the last element down to the second element
    i := this.Length
    while (i > 1) {
        ; Generate a random index between 1 and the current index (inclusive)
        randomIndex := Random(1, i)

        ; Swap elements
        this.Swap(i, randomIndex)

        ; Move the boundary dividing the randomized and un-randomized elements
        i -= 1
    }
}

/**
 * @description `Swap()`
 * Swaps the specified elements of an array in place.
 * @param {(Number)} i
 * The index of the first element to swap
 * @param {(Number)} j
 * The index of the second element to swap
 * @returns {(String)}
 * Always returns an empty string
 */
Array_Swap(this, i, j) {
        temp := this[i]
        this[i] := this[j]
        this[j] := temp
}

; Inject the methods into the Array prototype so they can be called on any array instance
Array.Prototype.DefineProp("Join", {Call: Array_Join})
Array.Prototype.DefineProp("Includes", {Call: Array_Includes})
Array.Prototype.DefineProp("GetRandomItem", {Call: Array_GetRandomItem})
Array.Prototype.DefineProp("GetRandomSample", {Call: Array_GetRandomSample})
Array.Prototype.DefineProp("Shuffle", {Call: Array_Shuffle})
Array.Prototype.DefineProp("Swap", {Call: Array_Swap})
