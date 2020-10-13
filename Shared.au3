#include <Array.au3>
#include <FileConstants.au3>
#include <GUIConstantsEx.au3>

;Version: 0.3.4 AutoIt: v3.3.14.5
;Author: VJ-Duardo(GitHub)

Global Const $eProgramName = "GoogleHotkeys"

Global Const $eSettingsFilename = "settings.txt"

Global Const $eTranslateKeyDefault = "^,+,$,q"
Global Const $eSearchKeyDefault = "^,+,$,y"
Global Const $eTranslateLanguageDefault = "de"
Global Const $eAutoStartSetting = $GUI_UNCHECKED

Global $oURLEscapeDic = ObjCreate("Scripting.Dictionary")
$oURLEscapeDic.Add("%", "%25")
$oURLEscapeDic.Add(" ", "%20")
$oURLEscapeDic.Add("$", "%24")
$oURLEscapeDic.Add("&", "%26")
$oURLEscapeDic.Add("`", "%60")
$oURLEscapeDic.Add(":", "%3A")
$oURLEscapeDic.Add("<", "%3C")
$oURLEscapeDic.Add(">", "%3E")
$oURLEscapeDic.Add("[", "%5B")
$oURLEscapeDic.Add("]", "%5D")
$oURLEscapeDic.Add("{", "%7B")
$oURLEscapeDic.Add("}", "%7D")
$oURLEscapeDic.Add("“", "%22")
$oURLEscapeDic.Add("+", "%2B")
$oURLEscapeDic.Add("#", "%23")
$oURLEscapeDic.Add("@", "%40")
$oURLEscapeDic.Add("/", "%2F")
$oURLEscapeDic.Add(";", "%3B")
$oURLEscapeDic.Add("=", "%3D")
$oURLEscapeDic.Add("?", "%3F")
$oURLEscapeDic.Add("\", "%5C")
$oURLEscapeDic.Add("^", "%5E")
$oURLEscapeDic.Add("|", "%7C")
$oURLEscapeDic.Add("~", "%7E")
$oURLEscapeDic.Add("‘", "%27")
$oURLEscapeDic.Add(",", "%2C")



Func _SaveFileCheck($bSecondTry = False)
	Local $hSaveFile = FileOpen($eSettingsFilename, $FO_READ)
	If $hSaveFile = -1 Then
		If $bSecondTry == False Then
			_CreateNewSaveFile()
			Return _SaveFileCheck(True)
		Else
			Return False
		Endif
	EndIf
	Return True
EndFunc


Func _CreateNewSaveFile()
	Local $hNewFile = FileOpen($eSettingsFilename, $FO_OVERWRITE)
	FileWriteLine($hNewFile, $eTranslateKeyDefault)
	FileWriteLine($hNewFile, $eSearchKeyDefault)
	FileWriteLine($hNewFile, $eTranslateLanguageDefault)
	FileWrite($hNewFile, $eAutoStartSetting)
	FileClose($hNewFile)
EndFunc
