/*  Core time functions.

This module contains core time functions that are used by other modules.
This file should also be loaded as other files may fail to load without it.
*/

; Functions
; ==============================================================================
milli_to_hhmmss(milli) {
    /*  A function to convert milliseconds to readable time.

        Args:
            milli (int): number of milliseconds
        Returns:
            Str: The formatted string in hh:mm:ss.mil
    */
    mil := mod(milli, 1000)
    sec := mod(milli //= 1000, 60)
    min := mod(milli //= 60, 60)
    hou := milli // 60
    Return Format("{1:02d}:{2:02d}:{3:02d}.{4:03d}", hou, min, sec, mil)
}

f_date(date:="", format:="MM-dd-yyyy") {
    /*  Function to return formatted date.

        Args:
            date (str): Optional. If not provided will default to current date & time. Otherwise, specify all or the leading part of a timestamp in the YYYYMMDDHH24MISS format
            format (str): Optional. If not provided will default to MM-dd-yyyy. Provide any format (as string)  https://autohotkey.com/docs/commands/FormatTime.html
        Returns:
            str: Date in specified format
    */
    FormatTime, res, %date%, %format%
    Return res
}
