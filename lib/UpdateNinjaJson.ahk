#NoEnv
#NoTrayIcon
#SingleInstance Ignore
#include lib\JSON.ahk
;SetWorkingDir %A_ScriptDir%



global JsonName := ["Currency","Fragment","Oil","incubator","Incubator","Scarab","Fossil","Resonator","Essence","DivinationCard","Prophecy","UniqueMap","UniqueJewel","UniqueFlask","UniqueWeapon","UniqueArmour","UniqueAccessory","Beast","Map"]
global League := "Metamorph"

global TheJson := Object()
global Web1 := ComObjCreate("WinHttp.WinHttpRequest.5.1")

IniRead, League, Config.ini, Default, League

UpdateJson()
{
	Ifnotexist NinjaData
		FileCreateDir,NinjaData
	Settimer,GetJson,0
	return
}

GetJson:
loop % JsonName.Length()
{
	ty := JsonName[A_index]
	Filename = %ty%`.json
	url = https://poe.ninja/api/data/itemoverview?league=%League%&type=%ty%
	if (InStr(ty,"Currency") = 1) or  (InStr(ty,"Fragment") = 1) 
		url = https://poe.ninja/api/data/currencyoverview?league=%League%&type=%ty%
	;msgbox % url
	Web1.Open("GET", url)
	Web1.SetRequestHeader("Content-Type", "application/json")
	try
	{
		Web1.Send()
		result := Web1.responsetext
		if result = ""
		{
			Title = 更新Ninja %Filename% 失败
			tooltip % Title
			settimer,removeTooltip,2000
			continue
		}
		
	}
	catch
	{
		Title = 更新Ninja %Filename% 数据失败
		tooltip % Title
		settimer,removeTooltip,15000
		Continue
	}

;数据处理

	result := JSON.Load(result)
	loop % result.lines.length()
	{
		TheJsonCore := {"links":"","chaosvalue":"","exaltedvalue":"","sparklinetotalchange":"","receivesparklinetotalchange":"","mapTier":"","chaosEquivalent":""}
		indexlines := result.lines[A_index]
		TheJsonCore.links := indexlines.links
		TheJsonCore.mapTier := indexlines.mapTier
		TheJsonCore.chaosvalue := indexlines.chaosvalue
		TheJsonCore.exaltedvalue := indexlines.exaltedvalue
		TheJsonCore.sparklinetotalchange := indexlines.sparkline.totalChange
		TheJsonCore.chaosEquivalent := indexlines.chaosEquivalent
		TheJsonCore.receivesparklinetotalchange := indexlines.receivesparkline.totalChange

		detailsId := RegexReplace(indexlines.detailsId,"'|-")

		TheJson.insert(detailsId,TheJsonCore)
		;a := TheJson%detailsId%.chaosequivalent
		;msgbox % a
	}
	ifexist  NinjaData\%FileName%
		Filedelete, NinjaData\%Filename%
	TheJsonDump := JSON.Dump(TheJson)
	TheJson := Object()
	Fileappend, %TheJsonDump%, Ninjadata\%Filename%
}
;settimer,RemoveToolTip,1500
settimer,GetJson,off
return

RemoveToolTip:
ToolTip
settimer,RemoveToolTip,off
return