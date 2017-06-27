;Scripts below mass upload documents to USPTO
;Version 1.2
;last updated 12-22-14
;Created by Patrick McNally 


#i::
;This is version of the sting works in IE 9 and IE 11

;Defining variables
First := 0
Last := 0
RefNum := 0
RefSub := 0
NumbOfRef := 100
NumbOfFor := 100
NumbOfNPL := 0


;This section requests input from the user regarding the first and last numbers of the references being submitted
While % NumbOfRef >20
{
	InputBox, First, First reference, Please enter the number preceeding the underscore of the FIRST reference being submitted (For Example 1 or 0001) 
	InputBox, Last, Last reference, Please enter the number preceeding the underscore of the LAST reference being submitted (For Example 20 or 0020) 
		
	if % First > Last
{
		NumbOfRef := 0
		NumbOfFor := 0
		MsgBox % "Please make sure that the number of the First reference is lower than the number of the Last reference"
		Break		
}

	NumbOfRef := (Last - First + 1)
	If NumbOfRef > 20
		MsgBox % "That is too many references.  You can only submit 20 references in one submission.  Please re-enter the numbers of the first and last references."
}

;This section request input from the user regarding the number of foreign references to be submitted
While % NumbOfFor > NumbOfRef
{	
	InputBox, NumbOfFor, Foreign References, How many of the references being submitted are foreign references?	
	If % NumbOfFor > NumbOfRef
		MsgBox % "You cannot submit more foreign references than total references.  Please re-enter the number of foreign referneces."
}	

RefNum := First - 1 + .0000
SetFormat, float, 04.0
RefNum += 0  ; Sets Var to be 000011

While % RefSub < NumbOfFor
{
	RefNum := (RefNum + 1.0)
	RefSub := (RefSub + 1)
	WinWait, Choose File to Upload,
	IfWinNotActive, Choose File to Upload, , WinActivate, Choose File to Upload,   
	WinWaitActive, Choose File to Upload, 
	SendInput, {SHIFTDOWN}{TAB}{TAB}{SHIFTUP}%RefNum%{ENTER}
	WinWait, ahk_class IEFrame
	IfWinNotActive, ahk_class IEFrame, , WinActivate, ahk_class IEFrame,
	WinWaitActive, ahk_class IEFrame 
	Send, {TAB}i
	Sleep, 100  
	Send, {TAB}f
	Sleep, 100
	If % RefSub = NumbOfRef
		MsgBox AutoHotkey has attempted to select all references.  There should be %NumbOfFor% Foreign and %NumbOfNPL% NPL References.  There should be a total of %RefSub% references.  If this is correct please click "Upload and Validate"
	Else
	{	
		SendInput, {TAB 3}{SPACE}
		Sleep 100,
		sendInput, {SHIFTDOWN}{TAB 5}{SHIFTUP}{SPACE}
		Sleep 100,
	}
}

While % RefSub < NumbOfRef	
{
	RefNum := (RefNum + 1.0)
	RefSub := (RefSub + 1)
	NumbOfNPL := (NumbOfNPL + 1)
	WinWait, Choose File to Upload,
	IfWinNotActive, Choose File to Upload, , WinActivate, Choose File to Upload,   
	WinWaitActive, Choose File to Upload, 
	SendInput, {SHIFTDOWN}{TAB}{TAB}{SHIFTUP}%RefNum%{ENTER}
	WinWait, ahk_class IEFrame
	IfWinNotActive, ahk_class IEFrame, , WinActivate, ahk_class IEFrame,
	WinWaitActive, ahk_class IEFrame 
	Send, {TAB}i
	Sleep, 100  
	Send, {TAB}n
	Sleep, 100
	If % RefSub = NumbOfRef
		MsgBox AutoHotkey has attempted to select all references.  There should be %NumbOfFor% Foreign and %NumbOfNPL% NPL References.  There should be a total of %RefSub% references.  If this is correct please click "Upload and Validate"
	Else
	{	
		SendInput, {TAB 3}{SPACE}
		Sleep 100,
		sendInput, {SHIFTDOWN}{TAB 5}{SHIFTUP}{SPACE}
		Sleep 100,
	}
}
Return


#c::
;This version works in Chrome

;Defining variables
First := 0
Last := 0
RefNum := 0
RefSub := 0
NumbOfRef := 100
NumbOfFor := 100
NumbOfNPL := 0


;This section requests input from the user regarding the first and last numbers of the references being submitted
While % NumbOfRef >20
{
	InputBox, First, First reference, Please enter the number preceeding the underscore of the FIRST reference being submitted.  For Example 1 or 0001. 
	InputBox, Last, Last reference, Please enter the number preceeding the underscore of the LAST reference being submitted. For Example 20 or 0020.

	if % First > Last
{
		NumbOfRef := 0
		NumbOfFor := 0
		MsgBox % "Please make sure that the number of the First reference is lower than the number of the Last reference"
		Break		
}

	NumbOfRef := (Last - First + 1)
	If NumbOfRef > 20
		MsgBox % "That is too many references.  You can only submit 20 references in one submission.  Please re-enter the numbers of the first and last references."
}

;This section request input from the user regarding the number of foreign references to be submitted
While % NumbOfFor > NumbOfRef
{	
	InputBox, NumbOfFor, Foreign References, How many of the references being submitted are foreign references?	
	If % NumbOfFor > NumbOfRef
		MsgBox % "You cannot submit more foreign references than total references.  Please re-enter the number of foreign referneces."
}	

RefNum := First - 1 + .0000
SetFormat, float, 04.0
RefNum += 0  ; Sets Var to be 000011

While % RefSub < NumbOfFor
{
	RefNum := (RefNum + 1.0)
	RefSub := (RefSub + 1)
	WinWait, Open, 
	IfWinNotActive, Open, , WinActivate, Open, 
	WinWaitActive, Open, 
	SendInput, {SHIFTDOWN}{TAB}{TAB}{SHIFTUP}%RefNum%{ENTER}
	WinWait, ahk_class Chrome_WidgetWin_1, 
	IfWinNotActive, ahk_class Chrome_WidgetWin_1, , WinActivate, ahk_class Chrome_WidgetWin_1, 
	WinWaitActive, ahk_class Chrome_WidgetWin_1, 
	SendInput, {TAB}i
	Sleep, 100  
	SendInput, {TAB}f
	Sleep, 100
	If % RefSub = NumbOfRef
		MsgBox AutoHotkey has attempted to select all references.  There should be %NumbOfFor% Foreign and %NumbOfNPL% NPL References.  There should be a total of %RefSub% references.  If this is correct please click "Upload and Validate"
	Else
	{	
		SendInput, {TAB 3}{SPACE}
		Sleep 100,
		sendInput, {SHIFTDOWN}{TAB 5}{SHIFTUP}{SPACE}
		Sleep 100,
	}
}

While % RefSub < NumbOfRef
{
	RefNum := (RefNum + 1.0)
	RefSub := (RefSub + 1)
	NumbOfNPL := (NumbOfNPL + 1)
	WinWait, Open, 
	IfWinNotActive, Open, , WinActivate, Open, 
	WinWaitActive, Open, 
	SendInput, {SHIFTDOWN}{TAB}{TAB}{SHIFTUP}%RefNum%{ENTER}
	WinWait, ahk_class Chrome_WidgetWin_1, 
	IfWinNotActive, ahk_class Chrome_WidgetWin_1, , ahk_class Chrome_WidgetWin_1, 
	WinWaitActive, ahk_class Chrome_WidgetWin_1, 
	SendInput, {TAB}i
	Sleep, 100  
	SendInput, {TAB}n
	Sleep, 100
	If % RefSub = NumbOfRef
		MsgBox AutoHotkey has attempted to select all references.  There should be %NumbOfFor% Foreign and %NumbOfNPL% NPL References.  There should be a total of %RefSub% references.  If this is correct please click "Upload and Validate"
	Else
	{	
		SendInput, {TAB 3}{SPACE}
		Sleep 100,
		sendInput, {SHIFTDOWN}{TAB 5}{SHIFTUP}{SPACE}
		Sleep 100,
	}
}
Return


#x::
;This version works in FireFox
SetKeyDelay, 100

;Defining variables
First := 0
Last := 0
RefNum := 0
RefSub := 0
NumbOfRef := 100
NumbOfFor := 100
NumbOfNPL := 0


;This section requests input from the user regarding the first and last numbers of the references being submitted
While % NumbOfRef >20
{
	InputBox, First, First reference, Please enter the number preceeding the underscore of the FIRST reference being submitted. For Example 1 or 0001.
	InputBox, Last, Last reference, Please enter the number preceeding the underscore of the LAST reference being submitted. For Example 20 or 0020.

	if % First > Last
{
		NumbOfRef := 0
		NumbOfFor := 0
		MsgBox % "Please make sure that the number of the First reference is lower than the number of the Last reference"
		Break		
}

	NumbOfRef := (Last - First + 1)
	If NumbOfRef > 20
		MsgBox % "That is too many references.  You can only submit 20 references in one submission.  Please re-enter the numbers of the first and last references."
}

;This section request input from the user regarding the number of foreign references to be submitted
While % NumbOfFor > NumbOfRef
{	
	InputBox, NumbOfFor, Foreign References, How many of the references being submitted are foreign references?	
	If % NumbOfFor > NumbOfRef
		MsgBox % "You cannot submit more foreign references than total references.  Please re-enter the number of foreign referneces."
}	

RefNum := First - 1 + .0000
SetFormat, float, 04.0
RefNum += 0  ; Sets Var to be 000011

While % RefSub < NumbOfFor
{
	RefNum := (RefNum + 1.0)
	RefSub := (RefSub + 1)
	WinWait, File Upload, 
	IfWinNotActive, File Upload, , WinActivate, File Upload, 
	WinWaitActive, File Upload, 
	Send, {SHIFTDOWN}{TAB}{TAB}{SHIFTUP}%RefNum%{ENTER}
	WinWait, ahk_class MozillaWindowClass, 
	IfWinNotActive, ahk_class MozillaWindowClass, , WinActivate, ahk_class MozillaWindowClass, 
	WinWaitActive, ahk_class MozillaWindowClass, 
	Send, {TAB}i{TAB}f
	If % RefSub = NumbOfRef
		MsgBox AutoHotkey has attempted to select all references.  There should be %NumbOfFor% Foreign and %NumbOfNPL% NPL References.  There should be a total of %RefSub% references.  If this is correct please click "Upload and Validate"
	Else
		Send, {TAB 3}{SPACE}{SHIFTDOWN}{TAB 5}{SHIFTUP}{SPACE}
}

While % RefSub < NumbOfRef
{
	RefNum := (RefNum + 1.0)
	RefSub := (RefSub + 1)
	NumbOfNPL := (NumbOfNPL + 1)
	WinWait, File Upload, 
	IfWinNotActive, File Upload, , WinActivate, File Upload, 
	WinWaitActive, File Upload, 
	Send, {SHIFTDOWN}{TAB}{TAB}{SHIFTUP}%RefNum%{ENTER}
	WinWait, ahk_class MozillaWindowClass, 
	IfWinNotActive, ahk_class MozillaWindowClass, , ahk_class MozillaWindowClass, 
	WinWaitActive, ahk_class MozillaWindowClass, 
	Send, {TAB}i{TAB}N
	If % RefSub = NumbOfRef
		MsgBox AutoHotkey has attempted to select all references.  There should be %NumbOfFor% Foreign and %NumbOfNPL% NPL References.  There should be a total of %RefSub% references.  If this is correct please click "Upload and Validate"
	Else
		Send, {TAB 3}{SPACE}{SHIFTDOWN}{TAB 5}{SHIFTUP}{SPACE}
}