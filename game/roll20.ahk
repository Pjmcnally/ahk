convert_date(str) {
    /*  Function to convert old date type mm/dd/yyyy to new date type
        yyyy/mm/dd. This allows dates to be easily sorted.

        This is a one-of script and has been used and retired.
    */

    Array := StrSplit(str, "/")
    m := trim(Array[1])
    d := trim(Array[2])
    y := trim(Array[3])

    new_str := y . "/" . m . "/" . d
    return new_str
}

^!d::
    clip_func("convert_date")
return
