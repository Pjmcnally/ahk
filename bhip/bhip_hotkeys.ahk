f_date(date:="", format:="MM-dd-yyyy") {
    /* Function to return formatted date.
     * ARGS:
     *     date (int): Optional.  If not provided will default to current date & time.  Otherwise, specify all or the leading part of a timestamp in the YYYYMMDDHH24MISS format
     *     format (str): Optional. If not provided will default to MM-dd-yyyy.  Provide any format (as string)  https://autohotkey.com/docs/commands/FormatTime.html
    */
    
    FormatTime, res, %date%, %format%
    return res
}


; Misc Hotstrings for BHIP tickets
:co:ifq::If there are any questions or there is anything more I can do to help please let me know.
:o:{c::{{}code{}}^v{{}code{}}
:o:-p::--Patrick
:o:tsig::Please let me know if any additional actions are required to resolve this ticket.{Enter 2}{Space 5}--Patrick
:o:scom::
    SendInput % "--Patrick McNally, " . f_date()
Return


; Hostrings for various hosts
:co:pinfo::Patrick{Tab}McNally{Tab}Pmcnally@slwip.com{Tab}{Down}{Tab}{Tab}{Space}
