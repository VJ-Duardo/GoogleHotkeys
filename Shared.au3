#include <Array.au3>
#include <FileConstants.au3>
#include <GUIConstantsEx.au3>

;Version: 0.3.6 AutoIt: v3.3.14.5
;Author: VJ-Duardo(GitHub)

Global Const $eProgramName = "GoogleHotkeys"

Global Const $eSettingsFilename = "settings.txt"

Global Const $eTranslateKeyDefault = "^,+,$,q"
Global Const $eSearchKeyDefault = "^,+,$,y"
Global Const $eTranslateLanguageDefault = "de"
Global Const $eAutoStartSetting = $GUI_UNCHECKED

Global Const $eAllLanguages = "AF|AM|AR|AZ|BE|BG|BN|BS|CA|CO|CS|CY|DA|DE|EL|EN|EO|ES|ET|EU|FA|FI|FR|FY|GA|GAA|GD|GL|GU|HA|HAW|HI|HR|HT|HU|HY|ID|IG|IS|IT|IW|JA|JW|KA|KK|KM|KN|KO|KU|KY|LA|LN|LO|LT|LV|MG|MI|MK|ML|MN|MR|MS|MT|NE|NL|NO|NY|NYN|OR|PA|PL|PS|PT|RM|RO|RU|RW|SD|SH|SI|SK|SL|SN|SO|SQ|SR|ST|SU|SV|SW|TA|TE|TG|TH|TK|TL|TR|TT|UG|UK|UR|UZ|VI|XH|YI|YO|ZH-CN|ZH-TW|ZU"

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
$oURLEscapeDic.Add('"', "%22")
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
