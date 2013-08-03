Func CleanFiles()

	EmptyFolder(@HomeDrive & @HomePath & "\Local Settings\Temporary Internet Files\Content.IE5")
	EmptyFolder(@HomeDrive & @HomePath & "\Local Settings\Temporary Internet Files")
	EmptyFolder(@HomeDrive & @HomePath & "\Local Settings\History")
	EmptyFolder(@HomeDrive & "\Temp\Temporary Internet Files")
	EmptyFolder(@WindowsDir & "\Temp")
	EmptyFolder(@HomeDrive & "\Temp")
	EmptyFolder(@HomeDrive & @HomePath & "\Local Settings\Temp")
	EmptyFolder(@TempDir)

	ShellExecuteWait("RunDll32.exe", " InetCpl.cpl,ClearMyTracksByProcess 255")
EndFunc   ;==>CleanFiles

Func EmptyFolder($FolderToDelete)
	WriteLn("Deleting Folder " & $FolderToDelete)
	$AllFiles = _FileListToArray($FolderToDelete, "*", 0)

	If IsArray($AllFiles) Then
		For $i = 1 To $AllFiles[0]
			$delete = FileDelete($FolderToDelete & "\" & $AllFiles[$i])
			DirRemove($FolderToDelete & "\" & $AllFiles[$i], 1)
		Next
	EndIf
EndFunc   ;==>EmptyFolder