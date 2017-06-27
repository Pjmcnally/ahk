; Script to enter "United States of America
^!u::
    ; Wait for the key to be released.  Use one KeyWait for each of the hotkey's modifiers.
    KeyWait Control
    KeyWait Alt
    SendInput United States of America{Tab}{Enter}
Return


; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; Functions used in hotstrings

f_date(date:="", format:="MM-dd-yyyy") {
    /* Function to return formatted date.
     * ARGS:
     *     date (int): Optional.  If not provided will default to current date & time.  Otherwise, specify all or the leading part of a timestamp in the YYYYMMDDHH24MISS format
     *     format (str): Optional. If not provided will default to MM-dd-yyyy.  Provide any format (as string)  https://autohotkey.com/docs/commands/FormatTime.html
    */
    
    FormatTime, res, %date%, %format%
    return res
}

; navigates through workdox save UI and fills in blanks
worldoxSave(desc, doc_type) {
    num := splitMatterNum(clipboard)
    SendInput % num["raw"] " " desc
    SendInput {Tab}{Tab}
    SendInput % doc_type
    SendInput {Tab}
    SendInput % num["client_num"]
    SendInput {Tab}
    SendInput % num["family_num"]
    SendInput {Tab}
    SendInput % num["c_code"]
    SendInput {Tab}
    SendInput % num["cont_num"]
    SendInput {Tab}{Tab}{Tab}{Enter}
}

; Splits matter number and returns parts.
splitMatterNum(str) {
    ; Matter numbers exist is a format of CCCC.FFFIIN or CCC.FFFIIN
    ; They infrequently appear as CCCC.FFFINN, CCC.FFFINN
    ; where CCCC or CCC = client number, FFF = family number, I or II = country code
    ; and N or NN = continuation number.

    ; test to ensure string has 11 digits cancel if not.
    len := StrLen(str)
    if (len != 11 and len != 10) {
        MsgBox Invalid Matter Number
        Exit
    }

    ; break string into client number and remainder.
    num_array := StrSplit(str, ".")
    client_num := num_array[1]

    remainder := num_array[2]
    family_num := SubStr(remainder, 1, 3)

    ; extract c_temp and check for char "U"
    ; for this purpose US should always be the right answer
    c_temp := SubStr(remainder, 4, 2)
    if InStr(c_temp, "U") {
        c_code := "US"
    } else {
        MsgBox Invald country
        Exit
    }

    ; check if c_temp contains digits.  If no grab 1 digit.  If yes grab both
    if c_temp is alpha
        cont_num := SubStr(remainder, 6, 1)
    if c_temp is not alpha
        cont_num := SubStr(remainder, 5, 2)

    num := {"raw": str, "client_num": client_num, "family_num": family_num, "c_code": c_code, "cont_num": cont_num}
    return num
}


; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; Hotstrings

; Worldox save hotstrings
:co:wcomm::
    worldoxSave("IDS Comm", "ids")
return

:co:wccca::
    worldoxSave("IDS CCCA", "comm")
return

:co:wxmit::
    worldoxSave("IDS Xmit", "xmit")
return

:co:w1449::
    worldoxSave("IDS 1449", "ids")
return

:co:wnum::
    num := splitMatterNum(clipboard)
    Send, {Tab}
    SendInput % num["client_num"]
    SendInput {Tab}
    SendInput % num["family_num"]
    SendInput {Tab}
    SendInput % num["c_code"]
    SendInput {Tab}
    SendInput % num["cont_num"]
    SendInput {Enter}
return


; Document types
:co:aarf::Response to Final Office Action
:co:aarn::Response to Non Final Office Action
:co:adaf::Response to Advisory Action
:co:adar::Advisory Action
:co:apbr::Appeal Brief
:co:aprb::Appellant's Reply Brief
:co:eesr::Extended European Search Report
:co:exan::Examiner's Answer
:co:exin::Examiner Interview Summary
:co:foar::Final Office Action
:co:iper::International Preliminary Examination Report
:co:iprp::International Preliminary Report on Patentability
:co:oarn::Non Final Office Action
:co:pabr::Pre-Appeal Brief
:co:pamd::Preliminary Amendment
:co:prop::Preliminary Report on Patentability
:co:pubap::Published Application
:co:rerr::Restriction Requirement
:co:rrr1mo::Response to Restriction Requirement


; misc text replace
:co:asaps::If possible, please sign ASAP.
:co:asap3mo::If possible, please sign ASAP.  This must be filed soon for us to avoid paying a filing fee.
:co:asapaarn::If possible, please sign ASAP.  We recently filed a response to non-final office action and we could recieve an office action shortly.
:co:asaprce::If possible, please sign ASAP.  We recently filed an RCE and could recieve an office action shortly.
:co:asapq::Also, If possible please sign ASAP as my last day is Friday May 19th and I am trying to finish this up so I don’t have to transfer it to someone else.
:co:asn::Application Serial No. ` ; "`" creates trailing space.
:co:atty::attorney `
:co:e1::1.97(e)(1)
:co:e2::1.97(e)(2)
:co:fsids::^v SIDS
:co:ifq::If there are any questions or there is anything more I can do to help please let me know.
:co:ifs::If this is satisfactory please sign the attached documents and return them to me.  If not please let me know what changes you would like made.
:co:pinfo::Patrick{Tab}McNally{Tab}Pmcnally@slwip.com{Tab}{Down}{Tab}{Tab}{Space}
:co:pnum::^v{Tab}A1{Tab}United States of America{Tab}{Enter}
:co:w/ec::w/English Claims
:co:w/et::w/English Translation
:co:[on::[Online].  Retrieved from the Internet: <URL: ^v>
:co:[onar::[Online].  [Archived YYYY-MM-DD].  Retrieved from the Internet: <URL: ^v>
:c*:isbef::   ; This function is a bit of a mess since I can't just add months.  It is a bit hacky but works.
    Input, months, , {space}{enter}{tab},]  ; As hiddne part of hotstring wait for user to input months to deadline
    if (months) {                           ; If Nonths exist 
        deadline := A_Now                     ; Store Today
        days_to_add := months * 30          ; Calc days by Months * 30. This is crude but close enough.
        deadline += %days_to_add%, days       ; Add days to date.
        deadline := f_date(deadline, "MMM yyyy")
    } else {                                ; If no month entered set ??? as output.
        deadline := "???"
    }
    SendInput % "IDS/SIDS before first OA (Estimated " . deadline . ")"
return
:c:esearch::  ; Quick little hacky hostring to help with email seach
    day := 22
    while (day <= 31) {
        SendInput % """May{space}" . day . ","" OR{space}"
        day += 1
    }
    SendInput {backspace 3}
return

; Text replace for date 
:co:td::
    sendInput % f_date(,"MM-dd-yy")
return
:co:td\::
    sendInput % f_date(,"MM/dd/yyyy")
return
:co:tda::  ; To insert arbitrary date
    arb_date := 20170417
    sendInput % f_date(arb_date, "MM/dd/yyyy")
    send {Tab}internal{Tab}
return

; Prosecution documents hotstrings
:co:m312::Application Serial No. ^v, Amendment after allowance under 37 CFR 1.312 mailed `
:co:mr312::Application Serial No. ^v, Response filed  to Amendment after Final or under 37 CFR 1.312 mailed{Left 54}
:co:maarf::Application Serial No. ^v, Response filed  to Final Office Action mailed{Left 30}
:co:maarn::Application Serial No. ^v, Response filed  to Non Final Office Action mailed{Left 34}
:co:madar::Application Serial No. ^v, Advisory Action mailed `
:co:mapbr::Application Serial No. ^v, Appeal Brief filed `
:co:maprb::Application Serial No. ^v, Reply Brief filed  to Examiner's Answer mailed{Left 28}
:co:mesr::European Application Serial No. ^v, Extended European Search Report mailed `
:co:mexan::Application Serial No. ^v, Examiner's Answer mailed `
:co:mexin::Application Serial No. ^v, Examiner Interview Summary mailed `
:co:mfoar::Application Serial No. ^v, Final Office Action mailed `
:co:miper::International Application Serial No. ^v, International Preliminary Examination Report mailed `
:co:miprp::International Application Serial No. ^v, International Preliminary Report on Patentability mailed `
:co:misr::International Application Serial No. ^v, International Search Report mailed `
:co:misrwo::International Application Serial No. ^v, International Search Report and Written Opinion mailed `
:co:mnoar::Application Serial No. ^v, Notice of Allowance mailed `
:co:moarn::Application Serial No. ^v, Non Final Office Action mailed `
:co:mpabr::Application Serial No. ^v, Pre-Appeal Brief filed `
:co:mpamd::Application Serial No. ^v, Preliminary Amendment mailed `
:co:mprop::International Application Serial No. ^v, Preliminary Report on Patentability mailed `
:co:mrerr::Application Serial No. ^v, Restriction Requirement mailed `
:co:mrr1mo::Application Serial No. ^v, Response filed  to Restriction Requirement mailed{Left 34}
:co:mwo::International Application Serial No. ^v, Written Opinion mailed `


; Matter Management text replacements
:co:mmdone::
    SendInput % "--All office actions, responses, and NOAs entered as references " . f_date(,"MM/dd/yyyy") . " --  PJM"
Return

:co:mmno::
    SendInput % "--Matter reviewed, no file history found as of " . f_date(,"MM/dd/yyyy") . " -- PJM"
Return

:co:mmnone::
    SendInput % "--Matter reviewed, no office actions, responses, or NOAs found as of " . f_date(,"MM/dd/yyyy") . " -- PJM"
Return


; Full email shortcuts
; -----------------------------------------------
; basic IDS email
:co:eids::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared an IDS for ^v.  I examined the specification, disclosure, and file.  I found no additional references.  I prepared the IDS to cite all currently unmarked references in FIP.  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

; Continuation IDS where not all references were cited in parent.
:co:eidsconn::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared an IDS for ^v.  Since it is a continuation/divisional I compared all of the unmarked references to those in its parent.  Some of the references unmarked in ^v have not been cited in the parent (see attached spreadsheet).  Despite this, I have prepared this IDS to cite all unmarked references (this includes those references not cited in the parent).  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

; Continuation IDS where only citing references cited in parent
:co:eidsconp::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared an IDS for ^v.  I have prepared this IDS to cite all references previously cited in the parent.  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

; Continuation IDS where all references were cited in parent
:co:eidscony::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared an IDS for ^v.  Since it is a continuation/divisional I compared all of the unmarked references to those in its parent.  All references currently unmarked in ^v have been cited in its parent matter.  Therefore, I have prepared this IDS to cite all unmarked references.  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

; memo email for new IDS
:co:eidsmemo::^v - IDS memo for your review{Tab}{Enter}{Tab}I have prepared an IDS memo for ^v.  Please review the memo and other attached documents.  Let me know which references you would like cited in this matter.^{Home}

; reminder email
:co:eout:: Outstanding SIDS - Signature Reminder{Tab}{Enter}{Tab}I have attached all outstanding IDS/SIDS out for your signature.  Please disregard all previous requests for signature.  Please sign all the attached documents and return them to me.  ^{Home}

; reminder email - Quit
:co:eoutq:: Outstanding SIDS - Signature Reminder{Tab}{Enter}{Tab}I have attached all outstanding IDS/SIDS out for your signature.  Please disregard all previous requests for signature.  Please sign all the attached documents and return them to me.{Enter 2}{Tab}Please sign and return all documents ASAP as my last day is Friday May 19th.  I am trying to clear out my docket before then.^{Home}

; email for SIDS and RCE
:co:erce::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared an SIDS and RCE for ^v.  I prepared the SIDS to cite all currently unmarked references in FIP.  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

; basic SIDS email
:co:esids::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared a SIDS for ^v.  I prepared the SIDS to cite all currently unmarked references in FIP.  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

; basic foreign reference SIDS email
:co:esidsfor::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared a SIDS for ^v in response to a foreign office action received in a related matter. I prepared the SIDS to cite the received document and all currently unmarked references in FIP.  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}


^!d::
    ; this is a hacky test script
    temp := clipboard
    Sleep, 100
    clipboard =  
    (
        // function to select all references to be downloaded for submission with IDS/SIDS
        (function checkDownload(){
            function checkAttach() {
                var results = []

                // Select all matching lines in the patent section
                var patent_rows = document.querySelectorAll("input.patent_checkRow");
                for (var i=0; i < patent_rows.length; i++) {
                    var parent = patent_rows[i].parentNode.parentNode;
                    if (parent.children[2].childElementCount < 2) {
                        results.push(parent.children[1].firstChild.firstChild.textContent);
                    }
                }

                // Select all matching lines in the NPL section 
                var pub_rows = document.querySelectorAll("input.pub_checkRow")
                for (var j=0; j < pub_rows.length; j++) {
                    var parent = pub_rows[j].parentNode.parentNode;
                    if (parent.children[2].childElementCount < 2) {
                        results.push(parent.children[1].firstChild.firstChild.textContent);
                    }
                }
                return results
            }

            function checkForeignPat() {
                var count = 0;
                var rows = document.querySelectorAll("input.patent_checkRow");
                for (var i=0; i < rows.length; i++) {
                    var parent = rows[i].parentNode.parentNode;
                    if (parent.children[6].textContent != "US") {
                        parent.firstChild.click();
                        count += 1;
                    }
                }
                return count;
            }

            function checkNPL() {
                var count = 0;
                var rows = document.querySelectorAll("input.pub_checkRow");
                for (var i=0; i < rows.length; i++) {
                    var parent = rows[i].parentNode.parentNode;
                    parent.firstChild.click();
                    count += 1;
                    }
                return count;
            }
            var noFile = checkAttach()
            if (noFile.length == 0) {
                noFile = 0
            }
            var forCount = checkForeignPat()
            var nplCount = checkNPL()
            console.log("Refs missing attachments: " + noFile + ".\n" + forCount + " Foreign and " + nplCount + " NPL refs checked and ready to download.")    
        }())
    )
    SendInput ^v
    Sleep, 100
    clipboard := temp
return
