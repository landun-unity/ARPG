--[[
    其他玩家主城
--]]

local UIBase = require("Game/UI/UIBase");
local UIOccupyOtherCityTown = class("UIOccupyOtherCityTown", UIBase);
local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");
local SelfLand = require("Game/MapMenu/SelfLand");
local LayerType = require("Game/Map/LayerType")
local UICueMessageType = require("Game/UI/UICueMessageType");
require("Game/Table/InitTable");
require("Game/League/LeagueTitleType")
-- 构造函数
function UIOccupyOtherCityTown:ctor()
    UIOccupyOtherCityTown.super.ctor(self);

    -- 部队出征按钮
    self.campaigner = nil
    -- 当前点击格子
    self.curTiledIndex = nil

    -- 放弃按钮
    self._giveUpBtn = nil

    -- 取消放弃按钮
    self._cencelGiveUpBtn = nil

    -- 名字
    self._name = nil

    -- 同盟名称
    self._leagueName = nil
    self.FloodImage = nil;
    self.signImage = nil;
    self.signImage1 = nil;
    self.avoidWarTimeText = nil;
    self._avoidWarImage = nil;
    self.tiled = nil;
    self.leftParent = nil;
end

-- 注册控件
function UIOccupyOtherCityTown:DoDataExchange()
    self._giveUpBtn = self:RegisterController(UnityEngine.UI.Button, "abandon")
    self._cencelGiveUpBtn = self:RegisterController(UnityEngine.UI.Button, "CancelGiveUp")
    self._name = self:RegisterController(UnityEngine.UI.Text, "backImg/Personal/PersonageImage/NameText")
    self._leagueName = self:RegisterController(UnityEngine.UI.Text, "backImg/Personal/HangFlagsImage/NameText")
    self.signImage = self:RegisterController(UnityEngine.UI.Image, "signImage")
    self.FloodImage = self:RegisterController(UnityEngine.UI.Image, "backImg/FloodImage")
    self.signImage1 = self:RegisterController(UnityEngine.UI.Image, "signImage1")
    self.leftParent = self:RegisterController(UnityEngine.RectTransform, "backImg/Personal");
    self.avoidWarTimeText = self:RegisterController(UnityEngine.UI.Text, "backImg/Personal/AvoidWarImage/AvoidWarTimeText");
    self._avoidWarImage = self:RegisterController(UnityEngine.UI.Image, "backImg/Personal/AvoidWarImage");
end

-- 注册控件点击事件
function UIOccupyOtherCityTown:DoEventAdd()
    self:AddListener(self._giveUpBtn, self.OnClickGiveUpBtn);
    self:AddListener(self._cencelGiveUpBtn, self.OnClickCencelGiveUpBtn);
    self:AddListener(self.signImage, self.OnClickSignBtn);
    self:AddListener(self.signImage1, self.OnClickUndoSignBtn);
end

-- 点击放弃土地
function UIOccupyOtherCityTown:OnClickGiveUpBtn()
    if PlayerService:Instance():GetLocalTime() <= self.tiled.tiledInfo.avoidWarTime then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.CannotGiveUpLand)
        return
    end
    MapService:Instance():HideTiled()
    UIService:Instance():ShowUI(UIType.UIAbandonSoil, self.curTiledIndex);
end


-- 免战时间显示
function UIOccupyOtherCityTown:_ArmyStateRequest(tiled)
    local freeWarEndTime = tiled.tiledInfo.avoidWarTime;
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
    CommonService:Instance():TimeDown(nil,freeWarEndTime,self.avoidWarTimeText, function() self._avoidWarImage.gameObject:SetActive(false) end);
    return avoidTime
end

-- 点击取消放弃土地
function UIOccupyOtherCityTown:OnClickCencelGiveUpBtn()
    local msg = require("MessageCommon/Msg/C2L/Army/CancelGiveUpOwnerLand").new();
    msg:SetMessageId(C2L_Army.CancelGiveUpOwnerLand)
    msg.tiledIndex = self.curTiledIndex
    NetService:Instance():SendMessage(msg)
    MapService:Instance():HideTiled()
    local tiled = MapService:Instance():GetTiledByIndex(self.curTiledIndex)
    if tiled ~= nil then
        tiled.IsAlreadyQuit = false;
    end
end
-- 标记 
function UIOccupyOtherCityTown:OnClickSignBtn()
    local name = nil;
    local tiledInfo = MapService:Instance():GetDataTiled(self.tiled)
    if tiledInfo ~= nil then
        local building = self.tiled._building 
        local town = self.tiled._town
        if building ~= nil and town == nil then
            name = building._name.." (Lv."..self.tiled:GetResource().TileLv..")"
        elseif town ~= nil then
            name = town._building._name.."-城区"
        end

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
function UIOccupyOtherCityTown:OnClickUndoSignBtn()
    local msg = require("MessageCommon/Msg/C2L/Player/RequestUndoMarker").new();
    msg:SetMessageId(C2L_Player.RequestUndoMarker);
    msg.tiledIndex = self.curTiledIndex;
    NetService:Instance():SendMessage(msg);
    self.gameObject:SetActive(false);
    MapService:Instance():HideTiled()
end

-- 是否已标记 
function UIOccupyOtherCityTown:FlushMainCityInfo(tiled)
    local isMarked = UIService:Instance():IsMarked(tiled);
    if isMarked then
        self.signImage1.gameObject:SetActive(true);
        self.signImage.gameObject:SetActive(false);
    else
        self.signImage1.gameObject:SetActive(false);
        self.signImage.gameObject:SetActive(true);
    end
end

-- 部队出征
function UIOccupyOtherCityTown:OnClickCampaignerBtn()
    if self:CheckTiledIsForBattle() == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.HaveNoBorderTiled);
        return
    end

    if PlayerService:Instance():IsHaveCanSendArmy() == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 144);
        return;
    end

    self.gameObject:SetActive(false)
    local param = { }
    param.troopsNum = 1
    param.troopType = SelfLand.battle
    param.tiledIndex = self.curTiledIndex;
    UIService:Instance():ShowUI(UIType.UISelfLandFunction, param);
    UIService:Instance():HideUI(UIType.UIGameMainView)
end



-- 加载土地资源产量
function UIOccupyOtherCityTown:ShowTiled(tiled)
    self.tiled = tiled
    self.gameObject.transform.localScale = Vector3.New(1.52, 1.52, 1.52);
    if tiled == nil then
        return
    end
    self:FlushMainCityInfo(tiled)
    self.curTiledIndex = tiled:GetIndex()
    if tiled:GetTown() == nil then
        return
    end
    local building = tiled:GetTown()._building
    if building == nil then
        return
    end
    if tiled.tiledInfo == nil then
        return
    end
    self:_ArmyStateRequest(tiled);
    if tiled.tiledInfo ~= nil then
        if tiled.tiledInfo.superiorLeagueId ~= 0 then
            self.FloodImage.transform.localPosition = Vector3.New(self.FloodImage.transform.localPosition.x, self.leftParent.localPosition.y + self.leftParent.sizeDelta.y/2, 0);
            self.FloodImage.gameObject:SetActive(true)
        else
            self.FloodImage.gameObject:SetActive(false)
        end
    else
        self.FloodImage.gameObject:SetActive(false)
    end
    self._name.text = tiled.tiledInfo.ownerName
    if tiled.tiledInfo.leagueId == 0 then
        self._leagueName.text = "<color=#BF3636FF>在野</color>";
    else
        self._leagueName.text = "<color=#71b448>" .. tiled.tiledInfo.leagueName .. "</color>";
    end
    if building:JudgeSubCityIsCreating() then
        self._giveUpBtn.gameObject:SetActive(false)
    else
        if tiled.tiledInfo ~= nil and tiled.tiledInfo.ownerId == PlayerService:Instance():GetPlayerId() then
            self._giveUpBtn.gameObject:SetActive(true)
            local isGiveUp = MapService:Instance():IsGiveUpTiledInterval(tiled)
            if isGiveUp then
                self._cencelGiveUpBtn.gameObject:SetActive(true)
                self._giveUpBtn.gameObject:SetActive(false)
            else
                self._cencelGiveUpBtn.gameObject:SetActive(false)
                self._giveUpBtn.gameObject:SetActive(true)
            end
        else
            self._giveUpBtn.gameObject:SetActive(false);
        end
    end

      ClickService:Instance():GetCurClickUI(Vector3.New(self.leftParent.transform.localPosition.x, self.leftParent.transform.localPosition.y - CommonService:Instance():GetChildCount(self.leftParent.transform) * 22-113, 0))
end


-- 检测是否有相邻地块
function UIOccupyOtherCityTown:CheckTiledIsForBattle()
    local x, y = MapService:Instance():GetTiledCoordinate(self.curTiledIndex)
    local ownerId = nil
    for i = x - 1, x + 1 do
        for j = y - 1, y + 1 do
            local tempIndex = MapService:Instance():GetTiledIndex(i, j)
            local tiled = MapService:Instance():GetTiledByIndex(tempIndex)
            local tempTiledInfo = tiled.tiledInfo
            if tempTiledInfo ~= nil then
                ownerId = tempTiledInfo.ownerId
            end
            if PlayerService:Instance():GetPlayerId() == ownerId then
                return true
            end
        end
    end
    return false
end

return UIOccupyOtherCityTown;
