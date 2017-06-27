; This script pastes javascript into the browser so I can quickly and easily exicute it.

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
