Func _UnicodeURLEncode($UnicodeURL)
	$UnicodeBinary = StringToBinary($UnicodeURL, 4)
	$UnicodeBinary2 = StringReplace($UnicodeBinary, '0x', '', 1)
	$UnicodeBinaryLength = StringLen($UnicodeBinary2)
	Local $EncodedString
	For $i = 1 To $UnicodeBinaryLength Step 2
		$UnicodeBinaryChar = StringMid($UnicodeBinary2, $i, 2)
		If StringInStr("$-_.+!*'(),;/?:@=&abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890", BinaryToString('0x' & $UnicodeBinaryChar, 4)) Then
			$EncodedString &= BinaryToString('0x' & $UnicodeBinaryChar)
		Else
			$EncodedString &= '%' & $UnicodeBinaryChar
		EndIf
	Next
	Return $EncodedString
EndFunc   ;==>_UnicodeURLEncode

Func PostData($sPostData)
	; Initialize and get session handle
	Local $hOpen = _WinHttpOpen()
	; Get connection handle
	Local $hConnect = _WinHttpConnect($hOpen, "hastebin.com")
	; Specify the reguest
	Local $hRequest = _WinHttpOpenRequest($hConnect, "POST", "documents")

	; Send request
	_WinHttpSendRequest($hRequest, Default, Default, StringLen($sPostData))

	; Write additional data to send
	_WinHttpWriteData($hRequest, $sPostData)

	; Wait for the response
	_WinHttpReceiveResponse($hRequest)

	; Check if there is data available...
	If _WinHttpQueryDataAvailable($hRequest) Then
		Local $Keys = _WinHttpReadData($hRequest)
		Local $aRet = _StringBetween($Keys, '{"key":"', '"}')

		Return "http://hastebin.com/" & $aRet[0]
	Else
		WriteLn("Error Posting to HasteBin")
		Return "<Error Posting to HasteBin>"
	EndIf

	; Close handles
	_WinHttpCloseHandle($hRequest)
	_WinHttpCloseHandle($hConnect)
	_WinHttpCloseHandle($hOpen)
EndFunc   ;==>PostData