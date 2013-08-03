#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=..\..\..\..\..\..\Scripts\CleanUp1g.exe
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Fileversion=0.0.0.21
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Obfuscator=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.3.6.0
	
	Author:         Screwloose Malware Cleaner
	
	Script Function: Cleans up malware automatically from computers
	
#ce ----------------------------------------------------------------------------
#include <String.au3>
#include <Array.au3>
#include <Date.au3>
#include <File.au3>
#include <Process.au3>

#include "_Zip.au3"
#include "WinHttp.au3"
#include "HasteBinPost.au3"
#include "rKill.au3"
#include "TDSKiller.au3"
#include "CCleaner.au3"
#include "TempFileCleanup.au3"
#include "VipreRescue.au3"
#include "MalwareBytes.au3"
#include "ProcKill.au3"

; Script Start - Add your code below here
WriteLn("===========================")
WriteLn("Screwloose Malware Cleaner v1.0g")
WriteLn("===========================")
WriteLn("Written by Jake Paternoster (jake@screwloose.com.au)")
WriteLn("Website: www.screwloose.com.au")
WriteLn("")
WriteLn("Last Updated 10/03/2013")
WriteLn("")

Local $APIKey = ""
Local $APIURL = ""
Local $SettingsFile = ""
Local $NoGFI = False

For $i = 1 To $CmdLine[0] Step 2
	If $CmdLine[$i] = "/API" Then $APIKey = $CmdLine[$i + 1]
	If $CmdLine[$i] = "/URL" Then $APIURL = $CmdLine[$i + 1]
	If $CmdLine[$i] = "/NOGFI" Then $NoGFI = True
Next

If $NoGFI = False Then
	If $APIKey = "" Or $APIURL = "" Then
		WriteLn("Useage: CleanUp.exe /API 1234567890abc /URL system-monitor.com")
		Exit
	EndIf

	If FileExists("C:\Program Files\Advanced Monitoring Agent\settings.ini") Then
		$SettingsFile = "C:\Program Files\Advanced Monitoring Agent\settings.ini"
		WriteLn("Agent Detected!")
	ElseIf FileExists("C:\Program Files (x86)\Advanced Monitoring Agent\settings.ini") Then
		$SettingsFile = "C:\Program Files (x86)\Advanced Monitoring Agent\settings.ini"
		WriteLn("Agent Detected on x64")
	Else
		WriteLn("GFI Agent Not Found")
		Exit
	EndIf

	WriteLn("Retreiving DeviceID...")

	Local $var = IniReadSection($SettingsFile, "GENERAL")

	;EXTRACT GFI DEVICE ID
	Local $strDevID = ""

	For $i = 1 To $var[0][0]
		If $var[$i][0] = "DEVICEID" Then
			$strDevID = $var[$i][1]
		EndIf
	Next

	If $strDevID <> "" Then
		WriteLn("DeviceID is " & $strDevID)
	Else
		WriteLn("DeviceID not detected!")
		Exit
	EndIf

	WriteLn("Getting GFI Check ID...")
	;GET CHECK ID
	Local $URL = "https://www." & $APIURL & "/api/?apikey=" & $APIKey & "&service=list_checks&deviceid=" & $strDevID

	Local $PostResult = BinaryToString(InetRead($URL))
	Local $Checks = CompReadXML($PostResult, "check")
	Local $CheckFound = False
	For $i = 0 To UBound($Checks) - 1
		If StringInStr($Checks[$i], "Script Check - Screwloose Malware Cleaner") Then
			Local $CheckIDArray = CompReadXML($Checks[$i], "checkid")
			$CheckFound = True
		EndIf
	Next

	If $CheckFound = True Then
		Local $CheckID = $CheckIDArray[0]
	Else
		WriteLn("Error getting Check ID, please check API and URL settings and ensure Check name is set to Screwloose Malware Cleaner")
		Exit
	EndIf

	WriteLn("Check ID is " & $CheckID)
EndIf
;==============================================================
; Kill Web Browsers
;==============================================================

Local $phase = 1
WriteLn("Initiating Phase " & $phase)
WriteLn("Killing Browsers...")

KillBrowsers()

WriteLn("Phase " & $phase & " Complete!")

;==============================================================
; rKILL
;==============================================================
Local $phase = 2
WriteLn("Initiating Phase " & $phase)

;Local $output = RunrKill()
Local $output = ProcKill()

If $output <> "" Then
	Local $data = "Process Killer: " & PostData($output)
	WriteLn($data)
	If $NoGFI = False Then GFIPostData($data)
Else
	WriteLn("Error Running Process Killer")
EndIf

WriteLn("Phase " & $phase & " Complete!")

Local $phase = 3
;==============================================================
; TDSS Killer
;==============================================================

WriteLn("Initiating Phase " & $phase)

Local $output = RunTDSSKiller()

If $output <> "" Then
	Local $data = "TDSS killer: " & PostData($output)
	WriteLn($data)
	If $NoGFI = False Then GFIPostData($data)
Else
	WriteLn("Error Running TDSSKiller.exe")
EndIf

Local $phase = 4
;==============================================================
; CCleaner
;==============================================================

WriteLn("Initiating Phase " & $phase)

CCleaner()

WriteLn("Phase " & $phase & " Complete!")

Local $phase = 5
;==============================================================
; Clean Temp Files
;==============================================================

WriteLn("Initiating Phase " & $phase)

CleanFiles()

WriteLn("Phase " & $phase & " Complete!")

;==============================================================
; Malwarebytes
;==============================================================

Local $phase = 6
WriteLn("Initiating Phase " & $phase)

InstallMBAM()
MBAMUpdate()

Local $output = MBAMScan()

If $output <> "" Then
	Local $data = "MalwareBytes: " & PostData($output)
	WriteLn($data)
	If $NoGFI = False Then GFIPostData($data)
Else
	WriteLn("Error Running MBAM.exe")
EndIf

WriteLn("Phase " & $phase & " Complete!")

;==============================================================
; Vipre Rescue
;==============================================================
Local $phase = 7
WriteLn("Initiating Phase " & $phase)

Local $output = VipreRescue()

If $output <> "" Then
	Local $data = "VipreRescue: " & PostData($output)
	WriteLn($data)
	If $NoGFI = False Then GFIPostData($data)
Else
	WriteLn("Error Running VipreRescue.exe")
EndIf

WriteLn("Phase " & $phase & " Complete!")


Func GFIPostData($data)
	$URL = "https://www." & $APIURL & "/api/?apikey=" & $APIKey & "&service=add_check_note&checkid=" & $CheckID & "&private_note=" & $data
	Local $PostResult = BinaryToString(InetRead($URL))

	If StringInStr($PostResult, "Note Added") Then
		WriteLn("GFI Postback Successful!")
	Else
		WriteLn("Error with GFI Postback")
	EndIf

EndFunc   ;==>GFIPostData

Func CompReadXML($XML, $Value)
	Local $aRet = _StringBetween($XML, '<' & $Value & '>', '</' & $Value & '>')
	If IsArray($aRet) Then
		Return $aRet
	Else
		Return SetError(-1)
	EndIf
EndFunc   ;==>CompReadXML

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