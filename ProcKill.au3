#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Array.au3>
#Include <process.au3>
#include <Date.au3>

prockill()
KillBrowsers()

Func WriteLn($TextToWrite)
	ConsoleWrite(_NowTime() & "	" & $TextToWrite & @CRLF)
	Local $file = FileOpen("Cleanup Output.txt", 1)

	; Check if file opened for writing OK
	If $file = -1 Then
		ConsoleWrite("Unable to open Log file.")
	Else
		FileWriteLine($file, _NowTime() & "	" & $TextToWrite & @CRLF)
		FileClose($file)
	EndIf
EndFunc   ;==>WriteLn

Func KillBrowsers()
	ProcessClose("chrome.exe") ;<=== Close Web Browsers
	ProcessClose("firefox.exe") ;<=== Close Web Browsers
	ProcessClose("iexplore.exe") ;<=== Close Web Browsers
EndFunc   ;==>KillBrowsers

Func prockill()
	Local $Log = ""
	Local $pr = ProcessList()
	Local $RegProcWhitelist[71] ; Create Process Whitelist array

	$RegProcWhitelist[0] = "[System Process]"
	$RegProcWhitelist[1] = "System"
	$RegProcWhitelist[2] = "alg.exe"
	$RegProcWhitelist[3] = "csrss.exe"
	$RegProcWhitelist[4] = "explorer.exe"
	$RegProcWhitelist[5] = "lsass.exe"
	$RegProcWhitelist[6] = "services.exe"
	$RegProcWhitelist[7] = "smss.exe"
	$RegProcWhitelist[8] = "svchost.exe"
	$RegProcWhitelist[9] = "winlogon.exe"
	$RegProcWhitelist[10] = "taskmgr.exe"
	$RegProcWhitelist[11] = "userinit.exe"
	$RegProcWhitelist[12] = "AutoIt3.exe"
	$RegProcWhitelist[13] = "LogonUI.exe"
	$RegProcWhitelist[14] = "System Idle Process"
	$RegProcWhitelist[15] = "taskhost.exe"
	$RegProcWhitelist[16] = "VSSVC.exe"
	$RegProcWhitelist[17] = "wininit.exe"
	$RegProcWhitelist[18] = "winlogon.exe"
	$RegProcWhitelist[19] = "sppsvc.exe"
	$RegProcWhitelist[20] = "svchost.exe"
	$RegProcWhitelist[21] = "XenDpriv.exe"
	$RegProcWhitelist[22] = "WmiPrvSE.exe"
	$RegProcWhitelist[23] = "lsm.exe"
	$RegProcWhitelist[24] = "SMSvcHost.exe"
	$RegProcWhitelist[25] = "msdtc.exe"
	$RegProcWhitelist[26] = "rdpclip.exe"
	$RegProcWhitelist[27] = "dwm.exe"
	$RegProcWhitelist[28] = "SciTE.exe"
	$RegProcWhitelist[29] = "XenGuestAgent.exe"
	$RegProcWhitelist[30] = "audiodg.exe"
	$RegProcWhitelist[30] = "spoolsv.exe"
	$RegProcWhitelist[31] = "TrustedInstaller.exe"
	$RegProcWhitelist[33] = "PrintIsolationHost.exe"
	$RegProcWhitelist[35] = "LMIGuardian.exe"
	$RegProcWhitelist[34] = "Oobe.exe"
	$RegProcWhitelist[36] = "LMIRTechConsole.exe"
	$RegProcWhitelist[37] = "Support-LogMeInRescue.exe"
	$RegProcWhitelist[38] = "lmi_rescue.exe"
	$RegProcWhitelist[39] = "regedit.exe"
	$RegProcWhitelist[40] = "chrome.exe"
	$RegProcWhitelist[41] = "iexplorer.exe"
	$RegProcWhitelist[42] = "firefox.exe"
	$RegProcWhitelist[43] = "Autoit_Studio.exe"
	$RegProcWhitelist[44] = "MsMpEng.exe"
	$RegProcWhitelist[45] = "msseces.exe"
	$RegProcWhitelist[46] = "teamviewer.exe"
	$RegProcWhitelist[47] = "TeamViewerQS_en.exe"
	$RegProcWhitelist[48] = "TeamViewerQS.exe"
	$RegProcWhitelist[49] = "Elsinore.ScreenConnect.GuestService.exe"
	$RegProcWhitelist[50] = "Elsinore.ScreenConnect.GuestClient.exe"
	$RegProcWhitelist[51] = "winagent.exe"
	$RegProcWhitelist[52] = "ntoskrnl.exe"
	$RegProcWhitelist[54] = "Start8Srv.exe"
	$RegProcWhitelist[55] = "Start8_64.exe"
	$RegProcWhitelist[56] = "Start8.exe"
	$RegProcWhitelist[57] = "vmms.exe"
	$RegProcWhitelist[58] = "WUDFHost.exe"
	$RegProcWhitelist[59] = "mcGlidHost.exe"
	$RegProcWhitelist[60] = "ehrecvr.exe"
	$RegProcWhitelist[61] = "dasHost.exe"
	$RegProcWhitelist[62] = "cmdagent.exe"
	$RegProcWhitelist[63] = "lnssatt.exe"
	$RegProcWhitelist[64] = "TeamViewer_Service.exe"
	$RegProcWhitelist[65] = "SysTray.exe"
	$RegProcWhitelist[66] = "dllhost.exe"
	$RegProcWhitelist[67] = "audiodg.exe"
	$RegProcWhitelist[68] = "conhost.exe"
	$RegProcWhitelist[69] = "cfp.exe"
	$RegProcWhitelist[70] = @ScriptName



	_ArraySort($RegProcWhitelist)
	For $i = 1 To $pr[0][0]
		Local $iKeyIndex = _ArrayBinarySearch($RegProcWhitelist, $pr[$i][0])
		If @error Then

			$Log = $Log & "Detected Non-Whitelisted Process! " & $pr[$i][0] & " (Killing) " & @CRLF
			WriteLn("Detected Non-Whitelisted Process! " & $pr[$i][0] & " (Killing) ")
			ProcessClose($pr[$i][0])

			Local $PID = ProcessExists($pr[$i][0]) ; Will return the PID or 0 if the process isn't found.

			If $PID > 0 Then
				$Log = $Log & "Process still in memory, trying Method 2" & @CRLF
				WriteLn("Process still in memory, trying Method 2")
				ProcessClose($PID)
			EndIf

			Local $PID = ProcessExists($pr[$i][0]) ; Will return the PID or 0 if the process isn't found.

			If $PID > 0 Then
				$Log = $Log & "Process still in memory, trying Method 3" & @CRLF
				WriteLn("Process still in memory, trying Method 3")
				RunWait(@ComSpec & " /c taskkill /F /PID " & $PID & " /T", @SystemDir, @SW_HIDE)
			EndIf

			Local $PID = ProcessExists($pr[$i][0]) ; Will return the PID or 0 if the process isn't found.

			If $PID > 0 Then
				$Log = $Log & "Process still in memory, I give up." & @CRLF
				WriteLn("Process still in memory, I give up.")
			EndIf

		EndIf
		Sleep(500)
	Next

Return $Log
EndFunc   ;==>prockill