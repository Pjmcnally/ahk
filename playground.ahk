; This file is where I do experimental or fun stuff in Autohotkey.

#IfWinActive  ; Clears #IfWinActive for preceeding scripts.


^!t::
file := FileOpen("rand_array.txt", "w")
array := [1, 2, 3, 4, 5, 6]


i := 0, num := 1000000
while (i < num) {
    rand_array := genRandomArray(array)
    file.Write(arrayAsStr(rand_array))
    i += 1
}
file.Close()
return


arrayAsStr(array) {
    ; function to format array as string
    str := "["
    for key, val in array {
        str := str . val . ", "
    }
    StringTrimRight, str, str, 2
    str := str . "]`r`n"
    return str
}


genRandomArray(array) {
    ; This function preserves the original array and returns a new one.
    a := array.clone()  ; Copy of array so original is not changed
    shuffle(a)
    return a
}


shuffle(a) {
    ; This is an implementation of the Fischer-Yates shuffle (in place)
    i := a.length()  ; Arrays are 1-indexed so I dont need to -1 here.
    while (i > 1) {  ; Dont need to swap the last element with itself.
        Random, rand, 0.0, 1.0  ; Get random float between 0 and 1
        j := Ceil(rand * i)  ; Turn float to int between 1 and i (currently unrandomized digits)
        temp := a[i], a[i] := a[j], a[j] := temp  ; swap values at i and j in array
        i -= 1
    }
    return a
}
