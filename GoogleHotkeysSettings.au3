#AutoIt3Wrapper_Icon=icons\ghSettings.ico
#AutoIt3Wrapper_Outfile_x64=GoogleHotkeys-0.3.5\GoogleHotkeys Settings.exe
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Description=GoogleHotkeys: Settings Application
#AutoIt3Wrapper_Res_ProductName=GoogleHotkeys Settings
#AutoIt3Wrapper_Res_ProductVersion=0.3.5
#AutoIt3Wrapper_Res_LegalCopyright=VJ-Duardo


#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>

#include <GUIComboBox.au3>
#include <WinAPIFiles.au3>
#include <Misc.au3>

#include <Shared.au3>

;Version: 0.3.5 AutoIt: v3.3.14.5
;Author: VJ-Duardo(GitHub)

_Singleton(@ScriptName)


Global Const $eVersion = "0.3.5"

Global $hDataFile = 0

Global $aFileConentOnStart[3]
Global $aTranslateCombos[4]
Global $aSearchCombos[4]

Global Const $eAutostartDirectory = "C:\Users\" & @UserName & "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
Global Const $eSettingsFilenameExeShortcut = $eProgramName & "_V"
Global Const $eFullAutostartDir = $eAutostartDirectory & "\" & $eSettingsFilenameExeShortcut

Global $oHotkeyDic = ObjCreate("Scripting.Dictionary")
$oHotkeyDic.Add("^", "Ctrl")
$oHotkeyDic.Add("+", "Shift")
$oHotkeyDic.Add("!", "Alt")
$oHotkeyDic.Add("$", " ")
Call("_ReverseDictionary", $oHotkeyDic)



;Translate/Search rows-----------------------------------------------------------------------------------------
$hGSSettingsGui = GUICreate($eProgramName & " Settings", 542, 284, -1, -1)

$idTranslateLabel = GUICtrlCreateLabel("Translator:", 40, 32, 76, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Microsoft Sans Serif")

$searchLabel = GUICtrlCreateLabel("Search Engine:", 40, 120, 98, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Microsoft Sans Serif")

Local Const $iRowOffset = 88
Local $aTranslateComboStart[4] = [184, 32, 65, 25]
Local $aTranslatePlusStart[4] = [256, 32, 13, 24]
_CreateSelectionRow($aTranslateComboStart, $aTranslatePlusStart, $iRowOffset, $aTranslateCombos)

Local $aSearchComboStart[4] = [184, 120, 65, 25]
Local $aSearchPlusStart[4] = [256, 120, 13, 24]
_CreateSelectionRow($aSearchComboStart, $aSearchPlusStart, $iRowOffset, $aSearchCombos)


;Language------------------------------------------------------------------------------------------------------
$idLanguageLabel = GUICtrlCreateLabel("Target Language:", 40, 64, 150, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Microsoft Sans Serif")

$idLanguageComboBox = GUICtrlCreateCombo("", 184, 64, 65, 25, BitOR($CBS_DROPDOWNLIST,$WS_VSCROLL))
GUICtrlSetData($idLanguageComboBox, $eAllLanguages)


;Buttons---------------------------------------------------------------------------------------------------
$idCancelButton = GUICtrlCreateButton("Cancel", 408, 240, 91, 25)
GUICtrlSetFont(-1, 10, 400, 0, "Microsoft Sans Serif")

$idOkButton = GUICtrlCreateButton("OK", 40, 240, 91, 25)
GUICtrlSetFont(-1, 10, 400, 0, "Microsoft Sans Serif")


;Autostart-------------------------------------------------------------------------------------------------
$idAutostartCheckbox = GUICtrlCreateCheckbox("Autostart", 40, 176, 265, 17)
GUICtrlSetFont(-1, 10, 400, 0, "Microsoft Sans Serif")


;Version Label---------------------------------------------------------------------------------------------
$eVersionLabel = GUICtrlCreateLabel("Version " & $eVersion, 456, 8, 81, 19)
GUICtrlSetFont(-1, 9, 400, 2, "Microsoft Sans Serif")
GUICtrlSetState($eVersionLabel, $GUI_DISABLE)


Func _CreateSelectionRow($aStart, $aStartPlus, $iOffset, ByRef $aComboArray)
	Local $aComboContent[4] = [" |Ctrl", " |Shift", " |Alt", "A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|0|1|2|3|4|5|6|7|8|9|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12"]
	For $i = 0 To 2
		$idComboBox = GUICtrlCreateCombo("", $aStart[0], $aStart[1], $aStart[2], $aStart[3], BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData($idComboBox, $aComboContent[$i])
		$aComboArray[$i] = $idComboBox
		$aStart[0]+= $iOffset
	Next

	Local const $iKeySizeChange = 16
	$idKeyComboBox = GUICtrlCreateCombo("", $aStart[0], $aStart[1], $aStart[2]-$iKeySizeChange, $aStart[3], BitOR($CBS_DROPDOWNLIST,$WS_VSCROLL))
	GUICtrlSetData($idKeyComboBox, $aComboContent[3])
	$aComboArray[3] = $idKeyComboBox

	For $j = 0 To 2
		$idPlusLabel = GUICtrlCreateLabel("+", $aStartPlus[0], $aStartPlus[1], $aStartPlus[2], $aStartPlus[3])
		GUICtrlSetFont(-1, 13, 400, 0, "MS Sans Serif")
		$aStartPlus[0]+= $iOffset
	Next
EndFunc

GUISetState(@SW_SHOW)

;------------------------------------------------------------------------------------------------



Func _ReadDataFile()
	$hDataFile = FileOpen($eSettingsFilename, $FO_READ)
    If Call("_SaveFileCheck") == True Then
		$hDataFile = FileOpen($eSettingsFilename, $FO_READ)
	Else
		MsgBox($MB_SYSTEMMODAL, "", "There is an issue with the save file.")
		Exit
	EndIf
	_SetValuesInGUI()
	FileClose($hDataFile)
EndFunc



Func _SetValuesInGUI()
	Local $aHotkey = StringSplit(FileReadLine($hDataFile, 1), ",", $STR_NOCOUNT)
	Call("_SetComboBoxes", $aTranslateCombos, $aHotkey)

	$aHotkey = StringSplit(FileReadLine($hDataFile, 2), ",", $STR_NOCOUNT)
	Call("_SetComboBoxes", $aSearchCombos, $aHotkey)

	_GUICtrlComboBox_SelectString($idLanguageComboBox, FileReadLine($hDataFile, 3))

	for $i =0 To (UBound($aFileConentOnStart))-1
		$aFileConentOnStart[$i] = FileReadLine($hDataFile, $i+1)
	Next

	GUICtrlSetState($idAutostartCheckbox, FileReadLine($hDataFile, 4))
EndFunc


Func _SetComboBoxes($aComboArray, $aHotkeyArray)
	For $i = 0 To 2 Step +1
		_GUICtrlComboBox_SelectString($aComboArray[$i], $oHotkeyDic.Item($aHotkeyArray[$i]))
	Next
	_GUICtrlComboBox_SelectString($aComboArray[3], StringRegExpReplace($aHotkeyArray[3], "[{}]", ""))
EndFunc



Func _WriteDataToFile()
	If Call("_SaveFileCheck") == True Then
		$hDataFile = FileOpen($eSettingsFilename, $FO_OVERWRITE)
	Else
		MsgBox($MB_SYSTEMMODAL, "", "There is an issue with the save file. It is possible the changes did not get saved.")
		Return
	EndIf
	FileWriteLine($hDataFile, Call("_GetHotKeyFromGUI", $aTranslateCombos))
	FileWriteLine($hDataFile, Call("_GetHotKeyFromGUI", $aSearchCombos))
	Local $sLanguageSelection = ""
	If StringInStr(GUICtrlRead($idLanguageComboBox), "-") <> 0 Then
		Local $sStringParts = StringSplit(GUICtrlRead($idLanguageComboBox), "-")
		$sLanguageSelection = StringLower($sStringParts[0]) & "-" & StringUpper($sStringParts[1])
	Else
		$sLanguageSelection = GUICtrlRead($idLanguageComboBox)
	EndIf
	FileWriteLine($hDataFile, $sLanguageSelection)
	FileWriteLine($hDataFile, GUICtrlRead($idAutostartCheckbox))
	FileClose($hDataFile)
EndFunc


Func _GetHotKeyFromGUI($aComboArray)
	Local $sHotkeyString = ""
	For $i = 0 To UBound($aComboArray)-2 Step +1
		$sHotkeyString = $sHotkeyString & $oHotkeyDic.Item(GUICtrlRead($aComboArray[$i])) & ","
	Next
	if StringLeft(GUICtrlRead($aComboArray[3]), 1) == "F" Then
		$sHotkeyString = $sHotkeyString & "{" & GUICtrlRead($aComboArray[3]) & "}"
	Else
		$sHotkeyString = $sHotkeyString & GUICtrlRead($aComboArray[3])
	EndIf
	Return $sHotkeyString
EndFunc



Func _GetAutostartFolderState()
	if FileExists($eFullAutostartDir & ".lnk") == 1 Then
		Return True
	Else
		Return False
	EndIf
EndFunc


Func _SetAutostartFolder()
	If GUICtrlRead($idAutostartCheckbox) == $GUI_CHECKED Then
		If Call("_GetAutostartFolderState") == False Then
			FileCreateShortcut(@WorkingDir & "\" & $eProgramName&".exe", $eFullAutostartDir, @WorkingDir)
		EndIf
	Else
		If Call("_GetAutostartFolderState") == True Then
			ConsoleWrite($eFullAutostartDir & ".lnk")
			FileDelete($eFullAutostartDir & ".lnk")
		EndIf
	EndIf
EndFunc



Func _CheckForSettingChanges()
	If Call("_SaveFileCheck") == True Then
		$hDataFile = FileOpen($eSettingsFilename, $FO_READ)
	Else
		MsgBox($MB_SYSTEMMODAL, "", "There is an issue with the save file.")
		Exit
	EndIf
	for $i =0 To (UBound($aFileConentOnStart)) -1
		If $aFileConentOnStart[$i] <> FileReadLine($hDataFile, $i +1) Then
			FileClose($hDataFile)
			Return True
		EndIf
	Next
	FileClose($hDataFile)
EndFunc



Func _RestartMainScript()
	If _CheckForSettingChanges() == True Then
		If ProcessExists($eProgramName&".exe") Then
			ProcessClose($eProgramName&".exe")
			Run($eProgramName&".exe restart")
		EndIf
	EndIf
EndFunc



Func _ReverseDictionary($dic)
	for $i = 0 To ($dic.Count)-1 Step +1
		$dic.Add($dic.Items[$i], $dic.Keys[$i])
	Next
EndFunc



_ReadDataFile()
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $idCancelButton
			Exit
		Case $idOkButton
			_WriteDataToFile()
			_SetAutostartFolder()
			_RestartMainScript()
			Exit
	EndSwitch
WEnd
