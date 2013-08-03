Local $title = "Malwarebytes Anti-Malware"
;ControlClick($title, "", "[CLASS:ThunderRT6CommandButton; INSTANCE:2]", "")

While 1 = 1


	If WinExists($title, "The scan completed successfully") Then
		;WriteLn("Scan Finished")
		WinActivate($title)
		Sleep(100)
		Send('{ENTER}')
		Sleep(100)

		ControlClick($title, "", "[CLASS:ThunderRT6CommandButton; INSTANCE:2]", "")

		for $i=1 to 6
			 msgbox(0,"", ControlGetText($title, "", "[CLASS:ThunderRT6CommandButton; INSTANCE:" & $i & "]"))
		  next
	EndIf
WEnd