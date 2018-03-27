--[[游戏主界面]]

local UIBase= require("Game/UI/UIBase");
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
local UIConfigTable=require("Game/Table/model/DataUIConfig");
local UIBattleReportItem=class("UIBattleReportItem",UIBase);
local UIBattleReportItemArmy = require("Game/BattleReport/UIBattleReport/UIBattleReportItemArmy");
local GetBattleReportDetail = require("MessageCommon/Msg/C2L/BattleReport/GetBattleReportDetail");
local ReportGroup = require("Game/BattleReport/UIBattleReport/ReportGroup");
-- local BattleResultType = require("Game/BattleReport/BattleResultType");
require("Game/BattleReport/BattleResultType")
require("Game/BattleReport/ReporterType")
local BattleReportType = require("Game/BattleReport/BattleReportType");
local OuterSize = Vector2.New(1228,172);
local InnerSize = Vector2.New(1200,172);


function UIBattleReportItem:ctor()
    UIBattleReportItem.super.ctor(self)
    self._go = nil;
    self._continueBattleBtn = nil;
    
    self._unreadObj = nil;
    self._typeImage = nil;
    self._typeTextImage = nil;
    self._AttackTarget = nil;
    self._AttackTime = nil;
    self._ourPartParent = nil;
    self._enemyParent = nil;
    self.ArmyPrefab = UIConfigTable[UIType.UIBattleReportItemArmy].ResourcePath;
    self._ourPart = nil;
    self._enemy = nil;
    self._UnReadBg = nil;
    self._UnReadCount = nil;
    self.funobject = nil;
    self.fun = nil;
    self._isread = true;
    self._Result = nil;
    self._AName = nil;
    self._Aleague = nil;
    self._DName = nil;
    self._Dleague = nil;
    self._infoDetail = nil;
    self._ContainLabel = nil;
    self._funobject = nil;
    self._fun = nil;
    self._affiliate = nil;
    self.defenderTextObj = nil;

    self.openFunction = nil;
    self.uiBattleReport = nil;

    self._info = nil;
end

--注册控件
function UIBattleReportItem:DoDataExchange()
    self.ItemBtn = self:RegisterController(UnityEngine.UI.Button,"ItemBtn")
    self.BackRect = self:RegisterController(UnityEngine.RectTransform,"ItemBtn")
    self._continueBattleBtn = self:RegisterController(UnityEngine.UI.Button,"ContinueBattleBtn")
    self._typeImage = self:RegisterController(UnityEngine.UI.Image,"type")
    self._typeTextImage = self:RegisterController(UnityEngine.UI.Image,"type/TypeImage")
    self._AttackTarget = self:RegisterController(UnityEngine.UI.Text,"address")
    self._AttackTime = self:RegisterController(UnityEngine.UI.Text,"time")
    self._ourPartParent = self:RegisterController(UnityEngine.Transform,"OurPart")
    self._enemyParent = self:RegisterController(UnityEngine.Transform,"Enemy")
    self._unreadObj = self:RegisterController(UnityEngine.Transform,"ItemBtn/UnRead")
    self._UnReadBg = self:RegisterController(UnityEngine.Transform,"UnReadBg")
    self._UnReadCount = self:RegisterController(UnityEngine.UI.Text,"UnReadBg/UnReadCount")
    self._Result = self:RegisterController(UnityEngine.UI.Image,"Result")
    self._AName = self:RegisterController(UnityEngine.UI.Text,"NameAndLeague/AName/Text")
    self._Aleague = self:RegisterController(UnityEngine.UI.Text,"NameAndLeague/Aleague/Text")
    self._DName = self:RegisterController(UnityEngine.UI.Text,"NameAndLeague/DName/Text")
    self._Dleague = self:RegisterController(UnityEngine.UI.Text,"NameAndLeague/Dleague/Text")
    self._ContainLabel = self:RegisterController(UnityEngine.UI.Text,"ContinueBattleBtn/Text")
    self._affiliate = self:RegisterController(UnityEngine.UI.Text,"affiliate");
    self.defenderTextObj = self:RegisterController(UnityEngine.Transform,"defenders");
end

--注册控件点击事件
function UIBattleReportItem:DoEventAdd()
    self:AddListener(self.ItemBtn,self.OnClickItemBtn)
    self:AddListener(self._continueBattleBtn,self.OnClickContinueBattleBtn)
    --self:AddOnUp(self.ItemBtn, self.OnDragItemUp);
    --self:AddOnDrag(self.ItemBtn, self.OnDragItemUp)
end

function UIBattleReportItem:SetUIBattleReport(uiBase)
    self.uiBattleReport = uiBase;
end 

--点击打开的逻辑
function UIBattleReportItem:OnClickItemBtn()
    if self.uiBattleReport~= nil then 
        self.uiBattleReport:SetClickItemDic(self);
    end
    BattleReportService:Instance():SetLastClickIndex(self._info._continueIndex)
    BattleReportService:Instance():ReadOneReport(self._info._iD,self._info._continueIndex)
    if(self._isread == false)then
        self._isread = true;
        self._unreadObj.gameObject:SetActive(false);
    end
    self._infoDetail = BattleReportService:Instance():GetBattleReportInfoById(self._info._iD,self._info._continueIndex);
    if self._infoDetail ~= nil then
        self:OpenBattleReportDetail();
    else
        self:SendToGetBAttleReportInfo();
    end
end

--判断是否打开战报详情
function UIBattleReportItem:JudgeOpenBattleReportDetail()
    if(self._info._iD == BattleReportService:Instance():GetLastClickID() and self._info._continueIndex == BattleReportService:Instance():GetLastClickIndex()) then
        self:OpenBattleReportDetail();
    end
end

--打开战报详情
function UIBattleReportItem:OpenBattleReportDetail()
    if self._infoDetail == nil  then
        self._infoDetail = BattleReportService:Instance():GetBattleReportInfoById(self._info._iD,self._info._continueIndex);
    end
    if self._infoDetail ~= nil then
        local pamp = {};
        pamp[1] = self._info;
        pamp[2] = self._infoDetail;
        pamp[3] = self._info._continueIndex;
        UIService:Instance():ShowUI(UIType.UIBattleReportDetail,pamp)
    end
end

--发送消息 要战报详情
function UIBattleReportItem:SendToGetBAttleReportInfo()
    local msg = GetBattleReportDetail.new();
    msg:SetMessageId(C2L_BattleReport.GetBattleReportDetail);
    msg.battleReportGroup = BattleReportService:Instance():GetGroup();
    
    if BattleReportService:Instance():GetGroup() == ReportGroup.Alliance then
        msg.id = PlayerService:Instance():GetLeagueId();
    else
        msg.id = PlayerService:Instance():GetPlayerId();
    end
    msg.battleReportID = self._info._iD;
    msg.index = self._info._continueIndex;
    NetService:Instance():SendMessage(msg);
end

--显示连续战斗
function UIBattleReportItem:OnClickContinueBattleBtn()
    self.fun(self.funobject,self._info);
end

--拖动回调
function UIBattleReportItem:OnDragItemUp()
    if(self._fun)then
        self._fun(self._funobject);
    end
end

--设置回调
function UIBattleReportItem:SetDragUpCallBack(go,fun)
    self._funobject = go;
    self._fun = fun;
end

--初始化刷新的方法
--function UIBattleReportItem:RefreshItem(info,index)
function UIBattleReportItem:RefreshItem(info) 
    if info == nil then
        return;
    end
    self._info = info;
    self._continueBattleBtn.gameObject:SetActive(false);
    self._UnReadBg.gameObject:SetActive(false);
    if self._info._continueIndex == 0 then
        --self.BackRect.sizeDelta = OuterSize;
        self._AttackTarget.gameObject:SetActive(true)
        self._typeImage.gameObject:SetActive(true)
        if self._info._isContinueReport == true then
            self._ContainLabel.text ="连续战斗"..self._info._continueReportCount;
            self._continueBattleBtn.gameObject:SetActive(true);
        else
            self._ContainLabel.text ="连续战斗"
        end
        local conUnReadCount = BattleReportService:Instance():GetConReprotUnreadCount(self._info._reportType,self._info._iD);
        if conUnReadCount > 0 then
            self._UnReadBg.gameObject:SetActive(true);
            self._UnReadCount.text = tostring(conUnReadCount);
        end
    else
        --self.BackRect.sizeDelta = InnerSize;
        self._AttackTarget.gameObject:SetActive(false)
        self._typeImage.gameObject:SetActive(false)
    end

    if(self._info._battleType ~= BattleReportType.Defence) then
        self._typeTextImage.sprite = GameResFactory.Instance():GetResSprite("TextAttack");
        self._typeImage.sprite = GameResFactory.Instance():GetResSprite("attackSign");
    else
        self._typeTextImage.sprite = GameResFactory.Instance():GetResSprite("TextDefend");
        self._typeImage.sprite = GameResFactory.Instance():GetResSprite("defendSign");
    end
    if self._info._tileIndex ~= nil then
        local x, y = MapService:Instance():GetTiledCoordinate(self._info._tileIndex)
        self._AttackTarget.text = x..","..y;
    end
    if self._info._fightTime ~= nil then
        self._AttackTime.text = os.date("%Y-%m-%d %H:%M:%S",math.floor(self._info._fightTime/1000));
    end
    self:SetAttackAndDefence();
    self:SetIfRead(self._info._isRead)
    self:SetResult(self._info._resultType)
    self._affiliate.gameObject:SetActive(false);
    if(self._info._reportType==ReporterType.OccupyLand) then
        self._affiliate.text = "占领土地"
        self._affiliate.gameObject:SetActive(true);
    elseif(self._info._reportType==ReporterType.LoseLand) then
        self._affiliate.text = "失去领地"
        self._affiliate.gameObject:SetActive(true);
    elseif(self._info._reportType==ReporterType.OccupyBuild) then
        self._affiliate.text = "成功占领"
        self._affiliate.gameObject:SetActive(true);
    elseif(self._info._reportType==ReporterType.OccuptWildCity) then
        self._affiliate.text = "同盟占领"
        self._affiliate.gameObject:SetActive(true);
    elseif(self._info._reportType==ReporterType.AttackSucces) then
        self._affiliate.text = "成功附属"
        self._affiliate.gameObject:SetActive(true);
    elseif(self._info._reportType==ReporterType.BeAttackLose) then
        self._affiliate.text = "被附属"
        self._affiliate.gameObject:SetActive(true);
    end

    if(self._info._battleType ~= BattleReportType.Defence) then
        self:SetNameOrLeague(self._AName,self._info._aPlayerName);
        self:SetNameOrLeague(self._Aleague,self._info._aleagueName);
        self:SetNameOrLeague(self._DName,self._info._dPlayerName);
        self:SetNameOrLeague(self._Dleague,self._info._dleagueName);
        if self._info._dPlayerName == "守军" then 
            self.defenderTextObj.gameObject:SetActive(true);
        else
            self.defenderTextObj.gameObject:SetActive(true);
        end
    else
        self.defenderTextObj.gameObject:SetActive(false);
        self:SetNameOrLeague(self._AName,self._info._dPlayerName);
        self:SetNameOrLeague(self._Aleague,self._info._dleagueName);
        self:SetNameOrLeague(self._DName,self._info._aPlayerName);
        self:SetNameOrLeague(self._Dleague,self._info._aleagueName);
    end
end

--设置文本内容 联盟或者名字
function UIBattleReportItem:SetNameOrLeague(label,text)
    if text == "" then
        label.transform.parent.gameObject:SetActive(false);
    else
        label.transform.parent.gameObject:SetActive(true);       
        label.text = text;
    end
end

--设置结果
function UIBattleReportItem:SetResult(args)
    if args == BattleResultType.Win then
        if(self._info._battleType ~= BattleReportType.Defence) then
            self._Result.sprite = GameResFactory.Instance():GetResSprite("TextWin");
        else
            self._Result.sprite = GameResFactory.Instance():GetResSprite("TextLoss");
        end
    end
    if(args == BattleResultType.Lose) then
       if(self._info._battleType ~= BattleReportType.Defence) then
            self._Result.sprite = GameResFactory.Instance():GetResSprite("TextLoss");
        else
            self._Result.sprite = GameResFactory.Instance():GetResSprite("TextWin");
        end
    end
    if(args == BattleResultType.Draw) then
        self._Result.sprite = GameResFactory.Instance():GetResSprite("draw");
    end
    if(args == BattleResultType.NoFight) then
        self._Result.sprite = GameResFactory.Instance():GetResSprite("NotFight");
    end
    if(args == BattleResultType.DieTogether) then
        self._Result.sprite = GameResFactory.Instance():GetResSprite("DieTogether");
    end
end

--设置是否已读
function UIBattleReportItem:SetIfRead(isread)
    self._isread = isread;
    if(isread) then
        self._unreadObj.gameObject:SetActive(false);
    else
        self._unreadObj.gameObject:SetActive(true);
    end
end

--设置未读数量
function UIBattleReportItem:SetUnReadNum(num)
    self._UnReadBg.gameObject:SetActive(false);
    --print(debug.traceback());
    if(num>=1)then
        self._UnReadBg.gameObject:SetActive(true);
        self._UnReadCount.text = tostring(num);
    end
end

--设置攻击防御方
function UIBattleReportItem:SetAttackAndDefence()
    if(self._ourPart == nil) then
        self._ourPart = UIBattleReportItemArmy.new();
        GameResFactory.Instance():GetUIPrefab(self.ArmyPrefab,self._ourPartParent,self._ourPart,function (go)
            self._ourPart:Init();
            if(self._info._battleType == BattleReportType.Defence) then
                self._ourPart:SetInfo(self._info._dCardTableID,self._info._dCardLevel,self._info._dTroopNum,self._info._dAdvanceStar);
            else
                self._ourPart:SetInfo(self._info._aCardTableID,self._info._aCardLevel,self._info._aTroopNum,self._info._aAdvanceStar);
            end
        end);
    else
        if(self._info._battleType == BattleReportType.Defence) then
            self._ourPart:SetInfo(self._info._dCardTableID,self._info._dCardLevel,self._info._dTroopNum,self._info._dAdvanceStar);
        else
            self._ourPart:SetInfo(self._info._aCardTableID,self._info._aCardLevel,self._info._aTroopNum,self._info._aAdvanceStar);
        end
    end
        
    if(self._enemy == nil) then
      self._enemy = UIBattleReportItemArmy.new();
        GameResFactory.Instance():GetUIPrefab(self.ArmyPrefab,self._enemyParent,self._enemy,function (go)
            self._enemy:Init();
            if(self._info._battleType == BattleReportType.Defence) then
                self._enemy:SetInfo(self._info._aCardTableID,self._info._aCardLevel,self._info._aTroopNum,self._info._aAdvanceStar);
            else
                self._enemy:SetInfo(self._info._dCardTableID,self._info._dCardLevel,self._info._dTroopNum,self._info._dAdvanceStar);
            end
        end);
    else
        if(self._info._battleType == BattleReportType.Defence) then
            self._enemy:SetInfo(self._info._aCardTableID,self._info._aCardLevel,self._info._aTroopNum,self._info._aAdvanceStar);
        else
            self._enemy:SetInfo(self._info._dCardTableID,self._info._dCardLevel,self._info._dTroopNum,self._info._dAdvanceStar);
        end
    end
end

--回调UI对象
function UIBattleReportItem:Setgo(go)
    self._go = go;
end

--回调方法
function UIBattleReportItem:SetCallBack(object, fun)
    self.funobject = object;
    self.fun = fun;
end

return UIBattleReportItem
