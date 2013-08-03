#include <Date.au3>
#include "_Zip.au3"

Func VipreRescue()
	WriteLn("Downloading VipreRescue...")

	Local $ret = InetGet("http://live.vipreantivirus.com/Download2/", @TempDir & "\VR.zip", 1, 1)

	Do
		Sleep(250)
	Until InetGetInfo($ret, 2)

	Local $aData = InetGetInfo($ret) ; Get all information.
	InetClose($ret)

	If $aData[3] = False Then
		WriteLn("Error Downloading VipreRescue")
		WriteLn($aData[4])
		Return "Error Downloading VipreRescue" & @CRLF & $aData[4]
	Else
		WriteLn("VipreRescue Downloaded!")
		WriteLn("Extracting VipreRescue...")

		FileDelete(@TempDir & "\VR\*.*")
		DirRemove(@TempDir & "\VR", 1)

		$retResult = _Zip_UnzipAll(@TempDir & "\VR.zip", @TempDir & "\VR")
		WriteLn("Extraction Complete!")

		WriteLn("Starting Scan...")
		Local $val = RunWait(@TempDir & "\VR\VipreRescueScanner.exe", @TempDir & "\VR", @SW_HIDE)
		WriteLn("VipreRescue Complete!")
		WriteLn("Returning Results...")

		$searchdir = @TempDir & "\VR\*.xml"
		$search = FileFindFirstFile($searchdir)

		$file = FileFindNextFile($search)

		Local $VROut = FileRead(@TempDir & "\VR\" & $file)

		Return $VROut
	EndIf
EndFunc   ;==>VipreRescue