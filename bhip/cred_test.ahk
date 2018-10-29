test_credential() {
    /*  Script to quickly run cred test for use when testing on multiple
    systems.

    Before you start create a file like this containing the needed values:
    [values]
    url=""
    cert=""
    username=""
    password=""
    guid=""
    */

    file := "C:\Users\Patrick\Desktop\test.txt"
    elements := ["url", "cert", "username", "password", "guid"]
    object := {}

    for index, item in elements {
        IniRead, value, % file, Values, % item
        object[item] := value
    }

    Send, % object.url
    Send, {Tab}
    Send, % object.cert
    Send, {Tab 2}
    Send, % object.username
    Send, {Tab}
    SendRaw, % object.password
    Send, {Tab}
    Send, % object.guid
    Send, {Tab 4}
    Send, {Enter}
}

:co:credtestgo::
    test_credential()
Return

:co:credtestrun::
    Send, % get_tester_path()
Return
