AutoHotkey Bulk Upload instructions

1. Prepare references:
    1. Bulk Download (From FIP)
    2. Bulk Rename (Using Sidebar)
    3. Bulk Flatten (Not always necessary but recommended)
    4. Put references in a folder
        * The script will try to upload all files in that folder so make sure there are no other files.
        * The location of this folder is irrelevant but you will need to know where it is.
2. Upload all docs but references:
    1. Open Chrome or Internet Explorer (Firefox is not supported).
    2. Navigate to USPTO EFS
    3. Upload IDS and any other documents.
        * Make sure to upload and verify those docs. The bulk upload script always assumes it can upload 20 refs. If that is not true it will break.
3. Upload references:
    1. Click "Browse"
    2. In the box that pops up:
        1. Navigate to the folder that contains the references
        2. Copy the folder location
    3. Click in the file name box so the cursor is blinking there
    4. Press the Hotkey: (any from below)
        * Windows Key + z
        * Windows Key + i
        * Windows key + c
    5. Answer the questions:
        * Paste copied folder locations for first question
        * Type in number of foreign refs
  6. Don't touch anything:
        * While AutoHotkey is working if you type or click anywhere you can disrupt it
  7. When the first 20 references are completed click uploaded and validate. If there are more the 20 references the script is still running and waiting for the opportunity to provide more references. When you are ready navigate back to the submission page return to step 3 (You will not need to re-answer questions).
  8. When all references are selected a message will notify you.

Caveats and Issues:

The AutoUpload script is still a work in progress. I have done extensive testing and it works very consistently. However, it is possible that it may not work in all possible circumstances. If you come across a situation where it does not behave as expected please let me know.

If a Hotkey goes awry it will continue to attempt to execute its command until it has complete itself. This can be canceled by right clicking on the AutoHotkey log in the taskbar and selecting "Reload this Script". This cancels the current script and resets AutoHotkey. If you make any changes to a script you must also "Reload this script" before AutoHotkey will acknowledge those changes.

The main issue I have been dealing with is AutoHotkey going too fast and having the commands jumbled or misinterpreted by the browser. This can manifest in several ways but the most typical is that it will not upload the correct number of references instead it simply keeps overwriting one of them. If this is a problem on your system you can modify the delay variable in the script. Near the top of the script is a line that reads:

_submitDelay := 100  ; 100 is default. Increase this number to slow down the submission process if it is breaking. Do not set below 100 or errors may occur._

Increase the number after the equal sign but before the semi-colon.
