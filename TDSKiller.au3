Func RunTDSSKiller()
	WriteLn("Downloading TDSS Killer...")

	Local $ret = InetGet("http://media.kaspersky.com/utilities/VirusUtilities/EN/tdsskiller.exe", @TempDir & "\tdsskiller.exe", 1, 1)

	Do
		Sleep(250)
	Until InetGetInfo($ret, 2)

	Local $aData = InetGetInfo($ret) ; Get all information.
	InetClose($ret)

	If $aData[3] = False Then
		WriteLn("Error Downloading TDSS Killer")
		WriteLn($aData[4])
		Return "Error Downloading TDSS Killer" & @CRLF & $aData[4]
	Else
		WriteLn("Executing TDSS Killer...")
		;Local $Command = @ComSpec & " /c tdsskiller.exe -l TDSreport.txt -silent -dcexact"
		;Local $val = RunWait($Command, @TempDir, @SW_HIDE)

		Local $pid = Run('"' & @TempDir & 'tdsskiller.exe" -l TDSreport.txt -silent -dcexact', @TempDir)

		If @error Then
			Return SetError(2, 0, False)
		EndIf

		While ProcessExists($pid)
			Sleep(250)
		WEnd

		WriteLn("TDSS Killer Complete!")
		WriteLn("Returning Results...")

		Local $TDSOut = FileRead(@TempDir & "\TDSreport.txt")

		Return $TDSOut
	EndIf
EndFunc   ;==>RunTDSSKiller