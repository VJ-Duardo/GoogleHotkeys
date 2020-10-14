#AutoIt3Wrapper_Icon=icons\ghMain.ico
#AutoIt3Wrapper_Outfile_x64=GoogleHotkeys-0.3.5\GoogleHotkeys.exe
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Description=Hotkeys for Google Translate and Search
#AutoIt3Wrapper_Res_ProductName=GoogleHotkeys
#AutoIt3Wrapper_Res_ProductVersion=0.3.5
#AutoIt3Wrapper_Res_LegalCopyright=VJ-Duardo


#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <TrayConstants.au3>
#include <Misc.au3>

#include <Shared.au3>

;Version: 0.3.5 AutoIt: v3.3.14.5
;Author: VJ-Duardo(GitHub)

_Singleton(@ScriptName)


Global $hDataFile = 0

Global Const $eEmptyKey = "$"
Global Const $eSeparatorKey = ","

Global Const $eTranslateLinkMain = "https://translate.google.com/translate#auto/{language}/"
Global $sTranslateLink = StringReplace($eTranslateLinkMain, "{language}", $eTranslateLanguageDefault)
Global Const $eSearchLink = "https://www.google.com/search?q="

_OpenDataFile()
While 1
	Sleep(100)
WEnd

Func _OpenDataFile($bSecondTry = False)
	If Call("_SaveFileCheck") == True Then
		$hDataFile = FileOpen($eSettingsFilename, $FO_READ)
	Else
		MsgBox($MB_SYSTEMMODAL, "", "There is an issue with the save file.")
		Exit
	EndIf
	_ReadDataFile()
	Local Const $eTrayTimeout = 3
	if(UBound($CmdLine) > 1) Then
		If $CmdLine[1] == "restart" Then
			TrayTip($eProgramName, $eProgramName & " has been restarted.", $eTrayTimeout, $TIP_ICONASTERISK)
		EndIf
	Else
		TrayTip($eProgramName, $eProgramName & " is now active.", $eTrayTimeout, $TIP_ICONASTERISK)
	EndIf
	FileClose($hDataFile)
EndFunc


Func _ReadDataFile()
	 Local $sHotkeyString = StringReplace(StringReplace(FileReadLine($hDataFile), $eSeparatorKey, ""), $eEmptyKey, "")
	 HotKeySet($sHotkeyString, "_Translate")

	 $sHotkeyString = StringReplace(StringReplace(FileReadLine($hDataFile, 2), $eSeparatorKey, ""), $eEmptyKey, "")
	 HotKeySet($sHotkeyString, "_Research")

	 $sTranslateLink = StringReplace($eTranslateLinkMain, "{language}", FileReadLine($hDataFile, 3))
EndFunc



Func _UseMarkedText($sLink)
	Local $vClipboard = ClipGet()
	ClipPut("")
	Send ("^c")
	sleep(100)
	Local $vClipContent = ClipGet()
	If Not @error Then
		Local $sClipped = Call("_EscapeURLSymbols", $vClipContent)
		ShellExecute($sLink & $sClipped)
	EndIf
	ClipPut($vClipboard)
EndFunc


Func _EscapeURLSymbols($sInput)
	For $i = 0 To $oURLEscapeDic.Count -1
		$sInput = StringReplace($sInput, $oURLEscapeDic.Keys[$i], $oURLEscapeDic.Item($oURLEscapeDic.Keys[$i]))
	Next
	Return $sInput
EndFunc



Func _Translate ()
    Call("_UseMarkedText", $sTranslateLink)
EndFunc


Func _Research()
	Call("_UseMarkedText", $eSearchLink)
EndFunc