
Func CCleaner()
	WriteLn("Downloading CCleaner...")

	Local $ret = InetGet("http://www.piriform.com/ccleaner/download/portable/downloadfile", @TempDir & "\CCleaner.zip", 1, 1)

	Do
		Sleep(250)
	Until InetGetInfo($ret, 2)

	Local $aData = InetGetInfo($ret) ; Get all information.
	InetClose($ret)

	If $aData[3] = False Then
		WriteLn("Error Downloading CCleaner")
		WriteLn($aData[4])
		Return "Error Downloading CCleaner" & @CRLF & $aData[4]
	Else
		WriteLn("CCleaner Downloaded!")
		WriteLn("Extracting CCleaner...")

		DirRemove("CCleaner", 1)
		_Zip_UnzipAll(@TempDir & "\CCleaner.zip", @TempDir & "\CCleaner")

;~ 	WriteLn("Defining Scan Paremeters...")
;~ 	IniWrite(@TempDir &"\CCleaner\ccleaner.ini","Options","(App)Start Menu Shortcuts","True")
;~ 	IniWrite(@TempDir &"\CCleaner\ccleaner.ini","Options","(App)Desktop Shortcuts","True")
;~ 	IniWrite(@TempDir &"\CCleaner\ccleaner.ini","Options","(App)History","True")
;~ 	IniWrite(@TempDir &"\CCleaner\ccleaner.ini","Options","(App)Old Prefetch data","True")
;~ 	IniWrite(@TempDir &"\CCleaner\ccleaner.ini","Options","(App)Menu Order Cache","True")
;~ 	IniWrite(@TempDir &"\CCleaner\ccleaner.ini","Options","(App)Tray Notifications Cache","True")
;~ 	IniWrite(@TempDir &"\CCleaner\ccleaner.ini","Options","(App)Window Size/Location Cache","True")
;~ 	IniWrite(@TempDir &"\CCleaner\ccleaner.ini","Options","(App)User Assist History","True")
;~ 	IniWrite(@TempDir &"\CCleaner\ccleaner.ini","Options","(App)IIS Log Files","True")
;~ 	IniWrite(@TempDir &"\CCleaner\ccleaner.ini","Options","(App)Hotfix Uninstallers","True")
;~ 	IniWrite(@TempDir &"\CCleaner\ccleaner.ini","Options","(App)Custom Folders","True")
;~ 	IniWrite(@TempDir &"\CCleaner\ccleaner.ini","Options","(App)Wipe Free Space","False")
;~ 	IniWrite(@TempDir &"\CCleaner\ccleaner.ini","Options","(App)DNS Cache","True")
;~ 	IniWrite(@TempDir &"\CCleaner\ccleaner.ini","Options","(App)Mozilla - Compact Databases","True")
;~ 	IniWrite(@TempDir &"\CCleaner\ccleaner.ini","Options","(App)Google Chrome - Compact Databases","True")

		WriteLn("Starting CCleaner...")
		;ShellExecuteWait(@TempDir &"\CCleaner\CCleaner.exe","/AUTO")

		;Local $val = RunWait(@TempDir &'\CCleaner\CCleaner.exe /clean "' & @TempDir & '\CCleanerLog.txt"', @TempDir, @SW_MAXIMIZE)
;~ 	If @ProcessorArch = "X64" Then
;~ 		Local $val = RunWait(@TempDir & '\CCleaner\CCleaner64.exe /AUTO', @TempDir, @SW_MAXIMIZE)
;~ 	Else

		Local $pid = Run('"' & @TempDir & '\CCleaner\CCleaner.exe" /AUTO', @TempDir & "\CCleaner")

		If @error Then
			Return SetError(2, 0, False)
		EndIf

		While ProcessExists($pid)
			Sleep(250)
		WEnd
;~ 	EndIf


		WriteLn("CCleaner Complete!")
	EndIf
EndFunc   ;==>CCleaner