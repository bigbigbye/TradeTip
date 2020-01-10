#NoEnv
;#NoTrayIcon
#SingleInstance Ignore
#include lib\JSON.ahk 

SetWorkingDir %A_ScriptDir%

CoordMode, ToolTip, Screen
CoordMode, mouse, Screen


global Version := "5a1df8f38b614aa7"
global Ready := false
global CheckBoard := ""
global WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
global result
global League
global Showtip := false
global idweb := "https://www.pathofexile.com/trade/search"
global mChrome
global Detailid2Type
global Uptime = A_hour   ":"  A_min
global _Title := ""
TrapName:="实时插件by白侠"

IniRead, mLeague, config.ini, Section, League
IniRead, mKill, config.ini, Hotkeys, Kill
IniRead, mChrome, config.ini, Hotkeys, Chrome
IniRead, mTool, config.ini, Hotkeys, Tool



ifexist  NinjaData\DetailIdtoType.json
{
        Fileread, Detailid2Type, NinjaData\DetailIdtoType.json
        Detailid2Type := JSON.Load(Detailid2Type)
}

WebRequest.Open("GET","https://gitee.com/lishitong/codes/1u0tc2zby9wgml7so8x5320/raw?blob_name=ToolTip_Version.txt")
try
{
        WebRequest.Send()
        VersionMsg := WebRequest.responsetext
        if !instr(version,VersionMsg) 
        {    
                Msgbox,版本已更新,请通过网页获取最新版本
                Run,"https://www.lanzous.com/ToolTip"
                exitapp
        }
}
catch
{
        tooltip,网络问题无法验证版本
        settimer,removeTooltip,2000
}




Menu, Tray, NoStandard
Menu, Tray, Click,1
Menu, Tray, Add, Open, OnClick
Menu, Tray, Add, Exit, OnEx
Menu, Tray, Default, Open
Menu, Tray,Tip,%TrapName%

Gui Add, Tab3, x0 y0 w263 h110, 运行|快捷键|关于
Gui, Tab, 1
Gui Add, Text, x8 y32 w57 h23 +0x200, 赛季选择：
Gui Add, Text, x8 y56 w58 h23 +0x200, 模式选择：
Gui Add, ComboBox,vLeague x72 y34 w100, % mLeague
GuiControl,Choose,League,1
Gui Add, ComboBox,vMode x72 y57 w100, 选择前十个|整体采样十个
GuiControl,Choose,Mode,1
Gui Add, CheckBox, x8 y80 w72 h23 vOnline Checked, 只看在线
Gui Add, CheckBox, x88 y81 h22 vCur, 忽略是否腐化
Gui Add, Button,gStart x176 y32 w75 h46, 开始
Gui Add, Link, x190 y88 w120 h23, <a href="https://gitee.com/ByeXman/pathofexile_price_query_tool/raw/master/赞助.png">赞助添动力</a>
Gui, Tab, 2
Gui Add, HotKey, x69 y32 w135 h20 vKill, %mKill%
Gui Add, HotKey, x69 y56 w135 h20 vChrome, %mChrome%
Gui Add, HotKey, x69 y80 w135 h20 vtool, %mtool%
Gui Add, Text, x8 y29 w51 h24 +0x200, 强制退出
Gui Add, Text, x8 y53 w54 h25 +0x200, 打开网页
Gui Add, Text, x8 y77 w54 h25 +0x200, 关闭标签
Gui Add, Button, x205 y31 w47 h45 gSettingConfig, 确认
Gui, Tab, 3
Gui Add, Text, x8 y32+0x200, Update:2019/12/22
Gui Add, Link,+0x200, <a href="http://bbs.17173.com/thread-11224517-1-1.html">17173论坛发布帖子</a> 
Gui Add, Link,+0x200, Power by<a href="http://bbs.17173.com/?134837501">白侠</a>                  <a href="https://gitee.com/ByeXman/pathofexile_price_query_tool/raw/master/赞助.png">赞助作者</a>
HotKey, %mKill%, Hkill
HotKey, %mChrome%, HChrome
HotKey, %mTool%, HTool
HotKey, %mKill%, On
HotKey, %mChrome%, On
HotKey, %mTool%, On
Gui Show, w257 h108, TradeTip
Return


SettingConfig:
Gui, Submit
if  (Kill <> mKill) and (Kill <> "^c") and(kill <> mChrome) and(kill <> "") and (Kill <> mTool)
{
        mKill := Kill
        HotKey, %mKill%, Hkill
        IniWrite, %mKill%, Config.ini, HotKeys,Kill
        HotKey, %mKill%, On
        Guicontrol,,Kill,%mKill%
}
If (Chrome <> mChrome) and (Kill <> "^c") and(Chrome <> mkill) and (Chrome <>"") and (Chrome <> mTool)
{
        mChrome := Chrome
        HotKey, %mChrome%, HChrome
        IniWrite, %mChrome%, Config.ini, HotKeys, Chrome
        HotKey, %mChrome%, On
        Guicontrol,,Chrome,%mChrome%
}

If (Tool <> mTool) and (Tool <> "^c") and(Tool<> mkill) and (Tool<>"") and (Tool<> mChrome)
{
        mTool := Tool
        HotKey, %mTool%, HTool
        IniWrite, %mTool%, Config.ini, HotKeys, Tool
        HotKey, %mTool%, On
        Guicontrol,,Tool,%mTool%
}

Gui Show
return
        
HAct:
WinActivate, TradeTip
Return

HChrome:
run,%idweb%
Return


OnClick:
Gui,Show
return

;GuiEscape:
GuiClose:
Gui Hide
return


OnEx:
HKill:
    ExitApp
Return

; End of the GUI section

#IfWinActive Path of Exile
~^C::
if Clipboard != ""
        settimer,Main,100,1
return
#IfWinActive


;Main:
;FindTradeInfo(Clipboard)
;settimer,Main,off
;return


#if ShowTip
HTool:
;~`::
tooltip
settimer,RemoveToolTip,off
ShowTip := false
return
#if


RemoveToolTip:
ToolTip
ShowTip := false
settimer,RemoveToolTip,off
return



Start()
{
		Gui, Hide
        WinActivate, Path of Exile
        GuiControlGet, League
        IniWrite, %League%, Config.ini, default, League
        Ifexist lib\UpdateNinjaJson.exe
        	run,lib\UpdateNinjaJson.exe
        idweb = https://www.pathofexile.com/trade/search/%League%
        Ready := true
		Tooltip,对着装备Ctrl+C即可
		settimer,RemoveToolTip,2000
        Clipboard := ""
        
        return
}

;获取name和type
GetNameAndType(Clip)
{
        mItem := {Rarity:"",ItemName:false,ItemType:false,ItemLink:0,ItemTier:0,ItemCorrupted:false,AddInfo:""}
        tier := 0
        if (InStr(Clip, "稀有度:") != 1) and (InStr(Clip, "Rarity:") != 1)
                return  mItem
        ClipArray :=  StrSplit(Clip, "`n", "`r")
        try
        {
                mItem.Rarity := RegexReplace(ClipArray[1],"稀有度: |Parity: ")
                if Regexmatch(Clip,"Map Tier: .*|地图等阶: .*",sTeir) > 0
                        if !Regexmatch(sTeir,"1[0-8]",tier)
                                Regexmatch(sTeir,"[0-9]",tier)
                mItem.ItemTier := tier
                if RegExMatch(clip,"(W|R|G|B)(-W|-R|-G|-B){4}")
                        if RegExMatch(clip,"(W|R|G|B)(-W|-R|-G|-B){5}")
                            mItem.ItemLink := 6
                        else
                            mItem.ItemLink := 5
                if (ClipArray[ClipArray.length()] = "Corrupted") or (ClipArray[ClipArray.length()] = "已腐化")
                        mItem.ItemCorrupted := true
                if RegExMatch(ClipArray[3],"---")
                {
                        if RegExMatch(ClipArray[ClipArray.length()-1],"右键点击这个预言到你的角色|Right-click to add this prophecy to your character")  or RegExMatch(ClipArray[ClipArray.length()],"右键点击这个预言到你的角色|Right-click to add this prophecy to your character")
                        {
                                mItem.ItemName := GetENG(ClipArray[2])
                                mItem.ItemType := "Prophecy"
                        }
                        else
                        {
                                mItem.ItemName := false
                                mItem.ItemType := GetENG(ClipArray[2])
                        }
                }
                else
                {
                        mItem.ItemName := GetENG(ClipArray[2])
                        mItem.ItemType := GetENG(ClipArray[3])
                }
                if RegExMatch(ClipArray[3],"i)^blighted |萎灭 |优质的 萎灭 ") or RegExMatch(ClipArray[2],"i)^blighted |萎灭 |优质的 萎灭 ")
                        mItem.AddInfo := "map_blighted"
                mItem.ItemType := RegexReplace(mItem.ItemType,"Blighted ")
                return mItem
        }
        catch
                return
}

;抓取英语
GetENG(Arr)
{
        if(RegExMatch(Arr,"\(.*?\)",m))
        {
                m := LTrim(m,"(")
                m := RTrim(m,")")
                Arr := m
        }
        return Arr
}    

;抓取Trade信息

;FindTradeInfo(Clip)
Main:
{
        settimer,Main,off
        
        if !Ready
                return
        clip := Clipboard
        Tooltip, Loading
        GuiControlGet, League
        GuiControlGet, Mode
        GuiControlGet, Online
        GuiControlGet, Cur
        MouseGetPos, Px,Py
        mItem := GetNameAndType(Clip)
        ShowTip := false
        
       
        if  mItem.ItemType = false
        {
                Tooltip, 非装备信息
                settimer, RemoveToolTip, 2000
                return
        }
        Clipboard := ""
        ;data := {"query":{"status":{"option":"any"},"type":null,"stats":[{"type":"and","filters":[]}],"filters":{"socket_filters":{"filters":{"links":{"min":0}}}}},"sort":{"price":"asc"}}
        data := {"query":{"status":{"option":"any"},"type":null,"stats":[{"type":"and","filters":[]}],"filters":{"map_filters":{"disabled":true,"filters":{"map_tier":{"min":null},"map_blighted": {"option": "false"}}},"socket_filters":{"filters":{"links":{"min":0}}},"misc_filters":{"disabled":true,"filters":{"corrupted":{"option":null}}}}},"sort":{"price":"asc"}}
        if !Cur
        {
                data.query.filters.misc_filters.disabled := false
                if mItem.ItemCorrupted
                        data.query.filters.misc_filters.filters.corrupted.option:= true
                else
                        data.query.filters.misc_filters.filters.corrupted.option:= false
        }   
        if Online = 1
                data.query.status.option := "online"
        if mItem.ItemLink = 5
        {
                data.query.filters.socket_filters.filters.links.min := 5
                data.query.filters.socket_filters.filters.links.max := 5
        }
        else if mItem.ItemLink = 6
                data.query.filters.socket_filters.filters.links.min := 6
        if mItem.ItemTier  > 0
        {
                data.query.type := {"discriminator" : "warfortheatlas","option":mItem.ItemType}
                data.query.filters.map_filters.disabled := false
                data.query.filters.map_filters.filters.map_tier.min := mItem.ItemTier
                if instr(mItem.AddInfo,"map_blighted") = 1
                        data.query.filters.map_filters.filters.map_blighted.option := "true"
        }
        else
        {
                if  mItem.ItemName != false
                        data.query.name := mItem.ItemName
                data.query.type := mItem.ItemType
        }

        ;获取ninja数据
        Ninjadata := GetDateForNinja(mItem)
        
        
        tmpString := ""
        tmpString = 装备名称：
        ItemType := mItem.ItemType
        if  mItem.ItemName != false
        {
                ItemName := mItem.ItemName
                tmpString .= ItemName " "
        }
        tmpString .=  ItemType
        if mItem.ItemLink > 0
                tmpString .= "  " mItem.ItemLink " L"
        else if mItem.ItemTier > 0
                tmpString .= "  T" mItem.ItemTier
        tmpString .= "`n"
        if instr(mItem.AddInfo,"map_blighted") = 1
                tmpString .= "               萎 灭 图`n"
        if Cur
                tmpString .= "               *忽略是否腐化*`n"
        else if mItem.ItemCorrupted
                tmpString .= "               已 腐 化`n"
        tmpString .= NinjaData
        
        
        tooltip,%tmpString%,%px%,%py%
        ;hwnd := WinExist("ahk_class tooltips_class32")
        ;WinSet, Trans, 200, % "ahk_id" hwnd
        
        
        body  := JSON.dump(data)
        clipboard := body
        url = https://www.pathofexile.com/api/trade/search/%League%
        WebRequest.Open("POST", url)
        WebRequest.SetRequestHeader("Content-Type", "application/json")
		try
        {
                WebRequest.Send(body)
                result := JSON.Load(WebRequest.responsetext)
        }
		catch
        {
				tooltip,网络访问错误
				settimer,removeTooltip,2000
                Settimer,Main,off
				return
        }
        itemid := result.id
        itemlist := result.result
		itemUnit := result.total
        idweb = https://www.pathofexile.com/trade/search/%League%/%itemid% 	
        url := "https://www.pathofexile.com/api/trade/fetch/"
        maxCount := 10
        step := floor(itemlist.length()/maxCount)  - 1
        ;url= %url%%listtemp%
        Lengt := itemlist.length()
		
        loop , %maxCount%
        {
                if InStr(Mode, "整体采样十个") = 1
                {
                        index := (A_index-1) * step+2
                }
                else
                        index := A_index  
                listtemp := itemlist[index]
                url= %url%%listtemp%,
        }
        
        url := Rtrim(url, ",")
        url .= ?query=%itemid%
        WebRequest.Open("GET",url)
		try
        {
				WebRequest.Send()
				result := JSON.Load(WebRequest.responsetext)
        }
		catch
        {
				Tooltip, 网络访问错误
                settimer, RemoveToolTip, 2000
                Settimer,Main,off
				return
        }
        
        
        infolist := result.result       
        MaxWidth := 0
        
        tmpString .= Strpad("=========Data From Trade===========",24)"`n"
        tmpString .= "装备总数: "  ItemUnit "`n"
        tmpString .= Strpad("-------------------------------------------------------",24)"`n"
        tmpString .= StrPad("   pirce",14)
        tmpString .= "|"StrPad("iLvl  ",7)
        tmpString .= "|"StrPad("上架时间",6) 
        tmpString .= "|"StrPad("名称",12)"`n"
        now := A_YYYY A_MM A_DD A_Hour A_MM A_sec

        for info in infolist
        {
                tmpString .=  StrPad(Process_dict(infolist[A_index].listing),12)
                tmpString .= "|" StrPad(infolist[A_index].item.ilvl,7)
                tmpString .= "|" StrPad(Defdate(infolist[A_index].listing.indexed,now),8)
                tmpString .= "|"StrPad(TradeFunc_TrimNames(infolist[A_index].listing.account.lastCharacterName,12,true),12) 
                tmpString .= Ttip "`n"
        }
        
        tmpString .=  "`n"
        ChangeKey := ChangeHotKey(mchrome)
        tmpString .= "快捷键  "  ChangeKey  "  打开网页"
        ChangeKey := ChangeHotKey(mTool)
        tmpString .= "  快捷键  "  ChangeKey  "  关闭窗口"
        tooltip,%tmpString%,%px%,%py%
        ;hwnd := WinExist("ahk_class tooltips_class32")
        ;WinSet, Trans, 200, % "ahk_id" hwnd
        settimer, RemoveToolTip, 7000
        ShowTip := true
        Clipboard := ""
        return
}

Process_dict(s)
{
        if s.price != ""
        {
                single_price := s.price.amount
                if !InStr(single_price,".")
                        single_price .=  ".0"
                unit := s.price.currency
                price_info := StrPad(single_price,5,"left")
                price_info .= unit
                return price_info
        }
        return  "------------"
}

;获取快捷键
ChangeHotKey(c)
{
        OutPutChr := StrReplace(c,"+","Shift+")
        OutPutChr := StrReplace(OutPutChr,"^","Ctrl+")
        OutPutChr := StrReplace(OutPutChr,"!","Alt+")
        return OutPutChr
}

;StrPad
StrPad(String, Length, Side="right", PadChar=" ")
{
        StringLen, Len, String
        AddLen := Length-Len
        If (AddLen <= 0)
        {
                return String
        }
        Pad := StrMult(PadChar, AddLen)
        If (Side == "right")
        {
                Result := String . Pad
        }
        Else
        {
                Result := Pad . String
        }
        return Result
}

StrMult(Char, Times)
{
        Result =
        Loop, %Times%
        {
                Result := Result . Char
        }
        return Result
}


;名称修饰
TradeFunc_TrimNames(name, length, addDots) {
	s := SubStr(name, 1 , length)
	If (StrLen(name) > length + 3 && addDots) {
		StringTrimRight, s, s, 3
		s .= "..."
	}
	Return s
}



 ;时间差
DefDate(str,n)
{
        _n := n
        if StrLen(str) <> 20
                return miss
        Var := RegexReplace(str,"-|:|T|Z","")
        if RegexMatch(var,"[0-9]{14}","") <> 1
                return miss
        EnvSub, _n, %var%, Seconds
        _n -= 28800
        if _n < 60
                title := "few s"
        else if _n <3600
        {
                title :=substr("0" Floor(_n/60) ,-1)
                title .= " m "
        }
        else if _n < 86400
        {
                title :=substr("0" Floor(_n/3600) ,-1)
                title .= " h "
        }
        else if _n >= 86400
        {
                title :=substr("0" Floor(_n/86400) ,-1)
                title .= " d "
        }
        else
                title = miss
        return title
}

;从下载的Ninja装备信息中获取信息
GetDateForNinja(mItem)
{
        mDetailId := mItem.ItemName mItem.ItemType
        if mItem.ItemTier > 0
        {
                if mItem.Rarity = "传奇" or mItem.Rarity = "Unique"
                        mDetailId := mItem.ItemName "t" mItem.ItemTier
                else
                        mDetailId := mItem.ItemType "t" mItem.ItemTier League
                if mItem.AddInfo = "map_blighted"
                        mDetailId := "blighted" mDetailId
        }
        else if Regexmatch(mItem.ItemType,"Prophecy|Flask") 
                mDetailId := mItem.ItemName
        mDetailId := RegexReplace(mDetailId,"'|0")
        mDetailId := Ltrim(mDetailId,"-")
        mDetailId := RegexReplace(mDetailId,"\s|-")
        dtype := Detailid2Type[mDetailId]
        _dtype := dtype
        
        Filename = %dtype%`.json
        _title := ""
        ifexist NinjaData\%Filename%
        {
                _title .= Strpad("=========Data From Ninja ===========",24)"`n"
                FileRead, dtype,NinjaData\%Filename%
                dtype := JSON.Load(dtype)
                i := 0
                _index := []
                ItemArry := dtype[mDetailId]
                _title .= ShowPrices(ItemArry,_dtype)
                if (InStr(_dtype,"UniqueArmour") = 1) or (InStr(_dtype,"UniqueWeapon") = 1)
                { 
                        mDetailId5l := mDetailId "5l"
                        mDetailId6l := mDetailId "6l"
                        _title .= ShowPrices(dtype[mDetailId5l],_dtype)
                        _title .= ShowPrices(dtype[mDetailId6l],_dtype)
                }
        }
        return _title
}
 

ShowPrices(ary,typ)
{
    if !ary
        return ""
    titl := ""
    if (instr(typ,"Currency") = 1) or (instr(typ,"Fragment") = 1 )
    {
        titl .= "2Pay   "
        titl .= Strpad(ary.chaosequivalent " chaos",10,"left")
        titl .= "|| 七日增幅"
        titl .= Strpad(ary.receivesparklinetotalchange " % ",10) "`n"
        return titl
    }
    if (instr(typ,"UniqueArmour") = 1) or (instr(typ,"UniqueWeapon") = 1 )
        titl .=  ary.links "L ||"
    else if (instr(typ,"Map") = 1) or (instr(typ,"UniqueMap") = 1 )
        titl .= "T" ary.mapTier "||"
    if ary.exaltedvalue < 1
    {
        titl .= StrPad(ary.chaosvalue " ",10,"left")
        titl .= StrPad("chaos",5)
    }
    else 
    {
        titl .= StrPad(ary.exaltedvalue " ",10,"left")
        titl .= StrPad("exa",5)
    }
    titl .= "||七日增幅"
    titl .= StrPad(ary.sparklinetotalchange "% ",10) "`n"
    return titl
}