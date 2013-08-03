
Func RunrKill()
	WriteLn("Downloading rKill...")

	Local $ret = InetGet("http://download.bleepingcomputer.com/grinler/rkill.exe", @TempDir & "\WiNlOgOn.exe", 1, 1)

	Do
		Sleep(250)
	Until InetGetInfo($ret, 2)

	Local $aData = InetGetInfo($ret) ; Get all information.
	InetClose($ret)

	If $aData[3] = False Then
		WriteLn("Error Downloading rKill.com")
		WriteLn($aData[4])
		Return "Error Downloading rKill.com" & @CRLF & $aData[4]
	Else
		WriteLn("Executing rKill...")

		Local $pid = Run(@TempDir & "\WiNlOgOn.exe", @TempDir)
		If @error Then
			WriteLn("Error Running")
			Return SetError(2, 0, False)
		EndIf

		$title = "Rkill Finished"

		Opt("WinTitleMatchMode", 4)
		While ProcessExists($pid)
			If WinExists($title, "") Then
				ControlClick($title, "", "[CLASS:ThunderRT6CommandButton; INSTANCE:1]", "")
				WinActivate($title)
				Sleep(100)
				Send('{ENTER}')
				Sleep(2500)
				WinClose("Rkill.txt - Notepad")
				ExitLoop
			EndIf
		WEnd

		WriteLn("rKill Complete!")
		WriteLn("Returning Results...")
		Local $RkillOut = FileRead(@DesktopDir & "\rkill.txt")

		Return $RkillOut
	EndIf
EndFunc   ;==>RunrKill