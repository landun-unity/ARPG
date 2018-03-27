--[[
    玩家占领界面菜单
--]]

local UIBase = require("Game/UI/UIBase")
local UIOneselfSoilObj = class("UIOneselfSoilObj", UIBase)
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
require("Game/Table/InitTable");
local DataState = require("Game/Table/model/DataState")

local DataCardSet = require("Game/Table/model/DataCardSet");
local DataExperienceBook = require("Game/Table/model/DataExperienceBook");

-- 构造方法
function UIOneselfSoilObj:ctor()
    UIOneselfSoilObj.super.ctor(self)
    self.buildingBtn = nil
    self.sweepBtn = nil
    self.defendBtn = nil
    self.mitaBtn = nil
    self.trainingBtn = nil

    self.FloodImage = nil;
    self.WaiveUnderframeBtn = nil;
    self._requestTimer = nil;

    -- 左侧
    self.leftParent = nil;
    self.tiledLeftInfoObj = nil;
    self.avoidWarTimeText = nil;
    self.wood = nil;
    self.iron = nil;
    self.stone = nil;
    self.food = nil;
    self.explainTextParent = nil;
    self.explainText = nil;
    self.defendingText = nil;
    self.playerName = nil;
    self.leagueName = nil;
    self.mwood = nil;
    self.mstone = nil;
    self.miron = nil;
    self.mfood = nil;
    self.LeagueImage = nil;
    self.PossessorImage = nil;
    self._avoidWarImage = nil;
    self.DeImage = nil;

    self.SignUnderframeImage = nil;
    self.CancelSignUnderframeImage = nil;
    -- 取消放弃
    self._cancelGiveUp = nil

    self.curTiled = nil;
    -- 当前显示的Tiled
    self.curTiledIndex = nil;
    -- 当前点击格子index
end

-- 初始化
function UIOneselfSoilObj:DoDataExchange()
    self.buildingBtn = self:RegisterController(UnityEngine.UI.Button, "FunctionObj/FortificationButton");
    self.sweepBtn = self:RegisterController(UnityEngine.UI.Button, "FunctionObj/SweepButton");
    self.sweepText = self:RegisterController(UnityEngine.UI.Text, "FunctionObj/SweepButton/SweepText");
    self.defendBtn = self:RegisterController(UnityEngine.UI.Button, "FunctionObj/DefendButton");
    self.mitaBtn = self:RegisterController(UnityEngine.UI.Button, "FunctionObj/TondenButton");
    self.trainingBtn = self:RegisterController(UnityEngine.UI.Button, "FunctionObj/TrainingButton");
    self.WaiveUnderframeBtn = self:RegisterController(UnityEngine.UI.Button, "SignWaiveObj/WaiveUnderframeImage");
    self._cancelGiveUp = self:RegisterController(UnityEngine.UI.Button, "SignWaiveObj/CancelWaiveUnderframeImage");
    
    self.SourceEventObj = self:RegisterController(UnityEngine.Transform, "SourceEventObj");
    self.SourceEventIcon = self:RegisterController(UnityEngine.UI.Image, "SourceEventObj/Bg/Icon");
    self.SourceEventtime = self:RegisterController(UnityEngine.UI.Text, "SourceEventObj/Bg/time");
    self.SourceEventDec = self:RegisterController(UnityEngine.UI.Text, "SourceEventObj/Bg/Dec");
    self.FloodImage = self:RegisterController(UnityEngine.UI.Image, "FloodImage");
    self.SignUnderframeImage = self:RegisterController(UnityEngine.UI.Button, "SignWaiveObj/SignUnderframeImage");
    self.CancelSignUnderframeImage = self:RegisterController(UnityEngine.UI.Button, "SignWaiveObj/CancelSignUnderframeImage");

    -- 左侧
    self.leftParent = self:RegisterController(UnityEngine.RectTransform, "OneLevelOfLandImage");
    self.tiledLeftInfoObj = self:RegisterController(UnityEngine.Transform, "OneLevelOfLandImage");
    self.avoidWarTimeText = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/AvoidWarImage/AvoidWarTimeText");
    self.wood = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/WoodImage/firewoodTime");
    self.iron = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/IronImage/fireironTime");
    self.stone = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/StoneImage/firestoneTime");
    self.food = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/FoodImage/firefoodTime")
    self.explainTextParent = self:RegisterController(UnityEngine.Transform, "OneLevelOfLandImage/ExplainTextParent");
    self.explainText = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/ExplainTextParent/ExplainText");
    self.defendingText = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/DeImage/LV");
    self.playerName = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/PossessorImage/PossessorNameText");
    self.leagueName = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/LeagueImage/LeagueNameText");
    self.mwood = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/WoodImage");
    self.mstone = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/StoneImage");
    self.miron = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/IronImage");
    self.mfood = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/FoodImage");
    self.LeagueImage = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/LeagueImage");
    self.PossessorImage = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/PossessorImage");
    self._avoidWarImage = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/AvoidWarImage");
    self.DeImage = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/DeImage")

end

-- 注册控件点击事件
function UIOneselfSoilObj:DoEventAdd()
    self:AddListener(self.buildingBtn.gameObject, self.OnClickBuildingBtn);
    self:AddListener(self.sweepBtn.gameObject, self.OnClickSweepBtn);
    self:AddListener(self.defendBtn.gameObject, self.OnClickDefendBtn);
    self:AddListener(self.mitaBtn.gameObject, self.OnClickMitaBtn);
    self:AddListener(self.trainingBtn.gameObject, self.OnClickTrainingBtn);
    self:AddListener(self.WaiveUnderframeBtn.gameObject, self.OnClickWaiveUnderframeBtn);
    self:AddListener(self._cancelGiveUp.gameObject, self.OnClickCancelGiveUpBtn);
    self:AddListener(self.SignUnderframeImage, self.OnClickSignBtn);
    self:AddListener(self.CancelSignUnderframeImage, self.OnClickDeleteSignBtn);
end

function UIOneselfSoilObj:ShowTiled(tiled, SourceEventinfo)
    if tiled == nil or tiled.tiledInfo == nil then
        return
    end
    self.curTiled = tiled;
    self.curTiledIndex = tiled:GetIndex();

    local info = SourceEventService:Instance():GetSourceEventById(self.curTiledIndex)
    if info ~= nil then
        if info._eventType == SourceEventType.ExperienceBook or info._eventType == SourceEventType.CardSet then
            self.sweepText.text = "探索"
        else
            self.sweepText.text = "扫荡"
        end
    end
    
    -- 由于父物体的localScale为0.52，自身缩放要等比变大。
    self.gameObject.transform.localScale = Vector3.New(1.52, 1.52, 1.52);
    
    if (SourceEventinfo) then
        self:InitSourceEvent(SourceEventinfo);
    else      
        self:SetLeftInformations();
    end
   
    local isGiveUp = MapService:Instance():IsGiveUpTiledInterval(tiled)
    if isGiveUp then
        self._cancelGiveUp.gameObject:SetActive(true)
        self.WaiveUnderframeBtn.gameObject:SetActive(false)
        self.buildingBtn.gameObject:SetActive(false)
    else
        self._cancelGiveUp.gameObject:SetActive(false)
        self.WaiveUnderframeBtn.gameObject:SetActive(true)
        self.buildingBtn.gameObject:SetActive(true)
    end
    self:FlushMainCityInfo(tiled); 
    self:NewerPeriodControl();

           ClickService:Instance():GetCurClickUI(Vector3.New(self.leftParent.transform.localPosition.x, self.leftParent.transform.localPosition.y - CommonService:Instance():GetChildCount(self.leftParent.transform) * 22-113, 0))
end

-- 新手保护期控制屯田练兵驻守的显隐
function UIOneselfSoilObj:NewerPeriodControl()
    if NewerPeriodService:Instance():CanMita() == false then
        if self.mitaBtn.gameObject.activeSelf == true then
            self.mitaBtn.gameObject:SetActive(false);
        end
    else
        if self.mitaBtn.gameObject.activeSelf == false then
            self.mitaBtn.gameObject:SetActive(true);
        end
    end
    if NewerPeriodService:Instance():CanTrain() == false then
        if self.trainingBtn.gameObject.activeSelf == true then
            self.trainingBtn.gameObject:SetActive(false);
        end
    else
        if self.trainingBtn.gameObject.activeSelf == false then
            self.trainingBtn.gameObject:SetActive(true);
        end
    end
    if NewerPeriodService:Instance():CanGarrison() == false then
        if self.defendBtn.gameObject.activeSelf == true then
            self.defendBtn.gameObject:SetActive(false);
        end
    else
        if self.defendBtn.gameObject.activeSelf == false then
            self.defendBtn.gameObject:SetActive(true);
        end
    end
end

-- 显示左侧所有的信息
function UIOneselfSoilObj:SetLeftInformations()
    self.tiledLeftInfoObj.gameObject:SetActive(true);
    self.SourceEventObj.gameObject:SetActive(false);
    -- 同盟、角色名字
    local leagueId = PlayerService:Instance():GetLeagueId();
    if leagueId == 0 then
        self.leagueName.text = "<color=#BF3636FF>在野</color>"
    else
        self.leagueName.text = "<color=#71b448>" .. PlayerService:Instance():GetLeagueName() .. "</color>";
        if self.curTiled.tiledInfo ~= nil then
            if self.curTiled.tiledInfo.superiorLeagueId ~= 0 then
                self.FloodImage.transform.localPosition = Vector3.New(self.FloodImage.transform.localPosition.x, self.leftParent.localPosition.y + self.leftParent.sizeDelta.y/2, 0);
                self.FloodImage.gameObject:SetActive(true)
            else
                self.FloodImage.gameObject:SetActive(false)
            end
        else
            self.FloodImage.gameObject:SetActive(false)
        end
    end
    self.playerName.text = PlayerService:Instance():GetName()
    -- 免战时间
    self:_ArmyStateRequest();
    -- 资源信息
    self:SetResourceInformations();
end

--显示资源地事件
function UIOneselfSoilObj:InitSourceEvent(info)
    self.tiledLeftInfoObj.gameObject:SetActive(false);
    self.SourceEventObj.gameObject:SetActive(true);
    local line = nil;
    if (info._eventType == SourceEventType.ExperienceBook) then
        -- 经验书
        line = DataExperienceBook[info._eventTableID];
        self.SourceEventIcon.sprite = GameResFactory.Instance():GetResSprite(line.ExperienceIcon)
        self.SourceEventDec.text = "散落在土地上的武将经验书。"
    end
    if (info._eventType == SourceEventType.CardSet) then
        -- 武将卡
        line = DataCardSet[info._eventTableID];
        self.SourceEventIcon.sprite = GameResFactory.Instance():GetResSprite(line.CardSetIcon)
        self.SourceEventDec.text = "散落在土地上的武将卡包。（仅在主城附近领地上出现）"
    end
    if (info._eventType == SourceEventType.Thief) then
        -- 贼兵
        --line = DataCardSet[info._eventTableID];
        --self.SourceEventIcon.sprite = GameResFactory.Instance():GetResSprite(line.CardSetIcon)
        self.SourceEventDec.text = "贼兵！！！！！！！！！！！！！！！！！！！！"
    end
    self:SetEndTime(info._endTime);
end

-- 免战时间显示
function UIOneselfSoilObj:_ArmyStateRequest()
    local freeWarEndTime = self.curTiled.tiledInfo.avoidWarTime;
    local curTime = PlayerService:Instance():GetLocalTime();
    if freeWarEndTime - curTime <= 0 then
        self._avoidWarImage.gameObject:SetActive(false)
        return;
    else
        self._avoidWarImage.gameObject:SetActive(true);
    end
    local avoidTime = freeWarEndTime - curTime;
    local cdTime = math.floor(avoidTime / 1000)
    if cdTime <= 0 then
        cdTime = 0;
    end
    self.avoidWarTimeText.text = CommonService:Instance():GetDateString(cdTime);
    CommonService:Instance():TimeDown(nil,freeWarEndTime,self.avoidWarTimeText,function() self._avoidWarImage.gameObject:SetActive(false) end);
    return avoidTime
end

-- 显示领地资源信息
function UIOneselfSoilObj:SetResourceInformations()
    -- 刷资源
    local resource = self.curTiled:GetResource();
    if resource ~= nil then
        if resource.Wood ~= 0 then
            self.mwood.gameObject:SetActive(true);
            self.wood.text = "+" .. resource.Wood .. "/小时";
        else
            self.mwood.gameObject:SetActive(false);
        end
        if resource.Stone ~= 0 then
            self.mstone.gameObject:SetActive(true);
            self.stone.text = "+" .. resource.Stone .. "/小时";
        else
            self.mstone.gameObject:SetActive(false);
        end
        if resource.Iron ~= 0 then
            self.miron.gameObject:SetActive(true);
            self.iron.text = "+" .. resource.Iron .. "/小时";
        else
            self.miron.gameObject:SetActive(false);
        end
        if resource.Food ~= 0 then
            self.mfood.gameObject:SetActive(true);
            self.food.text = "+" .. resource.Food .. "/小时";
        else
            self.mfood.gameObject:SetActive(false);
        end
        -- 守军强度
        -- LogManager:Instance():Log("守军   :  "..resource.NPCTroopLv.." 土地等级："..resource.TileLv);
        self.defendingText.text = "Lv." .. resource.NPCTroopLv;
        -- 6级以上高级地额外介绍
        if resource.TileLv > 5 then
            self.explainTextParent.gameObject:SetActive(true);
            if resource.TileLv == 6 then
                self.explainText.text = "土地Lv.6上建分城,可建造钱庄(提升本城税收)";
            elseif resource.TileLv == 7 then
                self.explainText.text = "土地Lv.7上建分城,可建造技工所(提升本城资源产量)";
            elseif resource.TileLv == 8 then
                self.explainText.text = "土地Lv.8上建分城,可建造塔楼(提升本城视野范围)";
            elseif resource.TileLv == 9 then
                self.explainText.text = "土地Lv.9上建分城,可建造酒馆(提升本城武将体力恢复)";
            end
        else
            self.explainTextParent.gameObject:SetActive(false);
        end
    else
        LogManager:Instance():Log("error!!!!!!!!!!!!! you clicked tiled get resource is nil.")
    end
end

-- 点击取消放弃按钮
function UIOneselfSoilObj:OnClickCancelGiveUpBtn()
    local tiled = MapService:Instance():GetTiledByIndex(self.curTiledIndex);
    if tiled ~= nil then
        if PlayerService:Instance():GetPlayerId() ~= tiled.tiledInfo.ownerId then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.UnableDoOperation);
            return
        end
    end
    local msg = require("MessageCommon/Msg/C2L/Army/CancelGiveUpOwnerLand").new();
    msg:SetMessageId(C2L_Army.CancelGiveUpOwnerLand)
    msg.tiledIndex = self.curTiledIndex
    NetService:Instance():SendMessage(msg)
    MapService:Instance():HideTiled()
end

-- 标记
function UIOneselfSoilObj:OnClickSignBtn()
    local resource = nil;
    local name = "";
    if self.curTiled ~= nil then
        resource = self.curTiled:GetResource();
        if PlayerService:Instance():GetPlayerId() ~= self.curTiled.tiledInfo.ownerId then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.UnableDoOperation);
            return
        end
    end
    if resource ~= nil then
        name = "土地Lv" .. resource.TileLv;
    end
    local msg = require("MessageCommon/Msg/C2L/Player/RequestMarkTiled").new();
    msg:SetMessageId(C2L_Player.RequestMarkTiled);
    msg.name = name
    msg.tiledIndex = self.curTiledIndex;
    NetService:Instance():SendMessage(msg);
    self.gameObject:SetActive(false);
    MapService:Instance():HideTiled()
end 

-- 取消标记
function UIOneselfSoilObj:OnClickDeleteSignBtn()
    local tiled = MapService:Instance():GetTiledByIndex(self.curTiledIndex);
    if tiled ~= nil then
        if PlayerService:Instance():GetPlayerId() ~= tiled.tiledInfo.ownerId then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.UnableDoOperation);
            return
        end
    end
    local msg = require("MessageCommon/Msg/C2L/Player/RequestUndoMarker").new();
    msg:SetMessageId(C2L_Player.RequestUndoMarker);
    msg.tiledIndex = self.curTiledIndex;
    NetService:Instance():SendMessage(msg);
    self.gameObject:SetActive(false);
    MapService:Instance():HideTiled()
end

-- 是否已标记 
function UIOneselfSoilObj:FlushMainCityInfo(tiled)
    local isMarked = UIService:Instance():IsMarked(tiled);
    if isMarked then
        self.CancelSignUnderframeImage.gameObject:SetActive(true);
        self.SignUnderframeImage.gameObject:SetActive(false);
    else
        self.CancelSignUnderframeImage.gameObject:SetActive(false);
        self.SignUnderframeImage.gameObject:SetActive(true);
    end
end

-- 点击筑城按钮
function UIOneselfSoilObj:OnClickBuildingBtn()
    local tiled = MapService:Instance():GetTiledByIndex(self.curTiledIndex);
    if tiled ~= nil then
        if PlayerService:Instance():GetPlayerId() ~= tiled.tiledInfo.ownerId then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.UnableDoOperation);
            return
        end
    end
    MapService:Instance():HideTiled()
    UIService:Instance():ShowUI(UIType.UIBuild, self.curTiledIndex);
    UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
    self.gameObject:SetActive(false);

end

function UIOneselfSoilObj:decreeCount()
  
end

-- 点击扫荡按钮
function UIOneselfSoilObj:OnClickSweepBtn()
    local tiled = MapService:Instance():GetTiledByIndex(self.curTiledIndex);
    if tiled ~= nil then
        if PlayerService:Instance():GetPlayerId() ~= tiled.tiledInfo.ownerId then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.UnableDoOperation);
            return
        end
    end

    if PlayerService:Instance():IsHaveCanSendArmy() == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 144);
        return;
    end

    MapService:Instance():HideTiled()
    self:ShowUISelfLand(SelfLand.loot)
    UIService:Instance():HideUI(UIType.UIGameMainView)
    UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
end

-- 点击驻守按钮
function UIOneselfSoilObj:OnClickDefendBtn()
    if NewerPeriodService:Instance():CanGarrison() == false then
        return;
    end

    local tiled = MapService:Instance():GetTiledByIndex(self.curTiledIndex);
    if tiled ~= nil then
        if PlayerService:Instance():GetPlayerId() ~= tiled.tiledInfo.ownerId then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.UnableDoOperation);
            return
        end
    end

    if PlayerService:Instance():IsHaveCanSendArmy() == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 144);
        return;
    end

    MapService:Instance():HideTiled()
    self:ShowUISelfLand(SelfLand.garrison)
    UIService:Instance():HideUI(UIType.UIGameMainView)
    UIService:Instance():HideUI(UIType.UIArmyDetailGrid)
end

-- 点击屯田按钮
function UIOneselfSoilObj:OnClickMitaBtn()
    if NewerPeriodService:Instance():CanMita() == false then
        return;
    end

    local tiled = MapService:Instance():GetTiledByIndex(self.curTiledIndex);
    if tiled ~= nil then
        if PlayerService:Instance():GetPlayerId() ~= tiled.tiledInfo.ownerId then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.UnableDoOperation);
            return
        end
    end
    local decree = PlayerService:Instance():GetDecreeSystem():GetCurValue()
    if decree < 3 then
       UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.decreeCount);
       return
    end

    if PlayerService:Instance():IsHaveCanSendArmy() == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 144);
        return;
    end

    MapService:Instance():HideTiled()
    self:ShowUISelfLand(SelfLand.wasteland)
    UIService:Instance():HideUI(UIType.UIGameMainView)
    UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
end

-- 点击练兵按钮
function UIOneselfSoilObj:OnClickTrainingBtn()
    if NewerPeriodService:Instance():CanTrain() == false then
        return;
    end

    local tiled = MapService:Instance():GetTiledByIndex(self.curTiledIndex);
    if tiled ~= nil then
        if PlayerService:Instance():GetPlayerId() ~= tiled.tiledInfo.ownerId then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.UnableDoOperation);
            return
        end
    end
    local decree = PlayerService:Instance():GetDecreeSystem():GetCurValue()
    if decree < 3 then
       UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.decreeCount);
       return
    end

    if PlayerService:Instance():IsHaveCanSendArmy() == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 144);
        return;
    end

    MapService:Instance():HideTiled()
    self:ShowUISelfLand(SelfLand.training)
    UIService:Instance():HideUI(UIType.UIGameMainView)
    UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
end

-- 点击放弃按钮
function UIOneselfSoilObj:OnClickWaiveUnderframeBtn()
    local tiled = MapService:Instance():GetTiledByIndex(self.curTiledIndex);
    if tiled ~= nil then
        if PlayerService:Instance():GetPlayerId() ~= tiled.tiledInfo.ownerId then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.UnableDoOperation);
            return
        end
    end
    if tiled.tiledInfo == nil then
        return
    end
    if PlayerService:Instance():GetLocalTime() <= tiled.tiledInfo.avoidWarTime then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.CannotGiveUpLand)
        return
    end
    MapService:Instance():HideTiled()
    UIService:Instance():ShowUI(UIType.UIAbandonSoil, self.curTiledIndex);
    -- body
end

-- 显示个人土地选项
function UIOneselfSoilObj:ShowUISelfLand(selfLandType)
    self.gameObject:SetActive(false);
    local param = { }
    param.troopsNum = 1
    param.troopType = selfLandType
    param.tiledIndex = self.curTiledIndex
    UIService:Instance():ShowUI(UIType.UISelfLandFunction, param);
end

-- 设置资源地时间倒计时
function UIOneselfSoilObj:SetEndTime(endtime)
    local curTime = PlayerService:Instance():GetLocalTime();
    local downTime = endtime - curTime;
    local cdTime = math.floor(downTime / 1000)
    if cdTime <= 0 then
        cdTime = 0;
        self.SourceEventObj.gameObject:SetActive(false);
        self.tiledLeftInfoObj.gameObject:SetActive(true);
    end
    self.SourceEventtime.text = CommonService:Instance():GetDateString(cdTime);
    CommonService:Instance():TimeDown(nil,endtime,self.SourceEventtime,function() self:EventTimeOver() end);
end

-- 资源地事件时间倒计时结束
function UIOneselfSoilObj:EventTimeOver()
    self:SetLeftInformations();
end

return UIOneselfSoilObj
