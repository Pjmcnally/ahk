; ------------------------------------------------------------------------------
; Functions used in this module

f_date(date:="", format:="MM-dd-yyyy") {
    /* Function to return formatted date.
     * ARGS:
     *     date (int): Optional.  If not provided will default to current date & time.  Otherwise, specify all or the leading part of a timestamp in the YYYYMMDDHH24MISS format
     *     format (str): Optional. If not provided will default to MM-dd-yyyy.  Provide any format (as string)  https://autohotkey.com/docs/commands/FormatTime.html
    */
    
    FormatTime, res, %date%, %format%
    return res
}


; ------------------------------------------------------------------------------
; Hotstrings in this module

; Script to enter "United States of America
^!u::
    ; Wait for the key to be released.  Use one KeyWait for each of the hotkey's modifiers.
    KeyWait Control
    KeyWait Alt
    SendInput United States of America{Tab}{Enter}
Return

; Hotstrings that autofill dates
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


; Hotstrings for document type 
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


; Hotstring for misc text replace
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


; Hotstrings for prosecution
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


; Hosttrings to generate Emails
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
