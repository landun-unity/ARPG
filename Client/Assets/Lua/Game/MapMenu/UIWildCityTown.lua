--[[
    野城城区界面
--]]

local UIBase = require("Game/UI/UIBase");
local UIWildCityTown = class("UIWildCityTown", UIBase);
local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");
require("Game/Table/InitTable");

-- 构造函数
function UIWildCityTown:ctor()
    UIWildCityTown.super.ctor(self);

    -- 出征
    --self.campaigner = nil

    self.signImage = nil;
    self.signImage1 = nil;
    self.giveUpLand = nil;
    self.deleteGiveUpLand = nil;

    self.CityProperNumImg = nil;
    self.CityProperText = nil;
    self.CityProperImg = nil;

    -- 左侧
     self.leftParent = nil;
    self.avoidWarTimeText = nil;
    self.explainTextParent = nil;
    self.explainText = nil;
    self.defendingText = nil;
    self.playerName = nil;
    self.leagueName = nil;
    self.LeagueImage = nil;
    self.PossessorImage = nil;
    self._avoidWarImage = nil;
    self.DeImage = nil;
    self.FloodImage = nil;
    self.tiled = nil;
    self.curTiledIndex = nil
    self.diplomacy = nil;
    self.amity = nil;
    self.mailBtn = nil;
    -- NPC守军恢复时间
    self._npcRecoverTimePanel = nil
    self._npcRecoverTime = nil
end

-- 注册控件
function UIWildCityTown:DoDataExchange()

 --   self.campaigner = self:RegisterController(UnityEngine.UI.Button, "campaigner")
    self.signImage = self:RegisterController(UnityEngine.UI.Button, "signImage")
    self.signImage1 = self:RegisterController(UnityEngine.UI.Button, "signImage1");
    self.giveUpLand = self:RegisterController(UnityEngine.UI.Button, "GiveUpLand");
    self.deleteGiveUpLand = self:RegisterController(UnityEngine.UI.Button, "deleteGiveUpLand")

    -- 左侧
     self.leftParent =  self:RegisterController(UnityEngine.RectTransform, "OneLevelOfLandImage");
    self.CityProperImg = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/CityProperImg")
    self.CityProperText = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/CityProperImg/CityProperText")
    self.CityProperNumImg = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/CityProperImg/CityProperNumImg")

    self.avoidWarTimeText = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/AvoidWarImage/AvoidWarTimeText");
    self.explainTextParent = self:RegisterController(UnityEngine.Transform, "OneLevelOfLandImage/ExplainTextParent");
    self.explainText = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/ExplainTextParent/ExplainText");
    self.defendingText = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/DeImage/LV");
    self.playerName = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/PossessorImage/PossessorNameText");
    self.leagueName = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/LeagueImage/LeagueNameText");
    self.LeagueImage = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/LeagueImage");
    self.PossessorImage = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/PossessorImage");
    self._avoidWarImage = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/AvoidWarImage");
    self.DeImage = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/DeImage")
    self.FloodImage = self:RegisterController(UnityEngine.UI.Image, "FloodImage")
    self.diplomacy = self:RegisterController(UnityEngine.UI.Image,"OneLevelOfLandImage/LeagueImage/diplomacy")
    self.amity = self:RegisterController(UnityEngine.UI.Image,"OneLevelOfLandImage/LeagueImage/amity")
    self.mailBtn = self:RegisterController(UnityEngine.UI.Button,"OneLevelOfLandImage/PossessorImage/Image")
    -- npc守军恢复时间
    self._npcRecoverTimePanel = self:RegisterController(UnityEngine.Transform,"OneLevelOfLandImage/NPCRecoverTime")
    self._npcRecoverTime = self:RegisterController(UnityEngine.UI.Text,"OneLevelOfLandImage/NPCRecoverTime/RecoverTime")
end

-- 注册控件点击事件
function UIWildCityTown:DoEventAdd()
    --self:AddListener(self.campaigner, self.OnClickCampaignerBtn);
    self:AddListener(self.signImage, self.OnClickSignBtn);
    self:AddListener(self.signImage1, self.OnClickDeleteSignBtn);
    self:AddListener(self.giveUpLand, self.OnClickUpLand);
    self:AddListener(self.deleteGiveUpLand, self.OnClickDeleteGiveUpLand)
    self:AddListener(self.mailBtn, self.OnClickMailBtn)
end

-- 加载资源
function UIWildCityTown:ShowTiled(tiled)
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
    self.gameObject.transform.localScale = Vector3.New(1.52, 1.52, 1.52);
    self.curTiledIndex = tiled:GetIndex();
    self.tiled = tiled;
    if tiled.tiledInfo ~= nil and tiled.tiledInfo.ownerId == PlayerService:Instance():GetPlayerId() then
        self.giveUpLand.gameObject:SetActive(true)
        local isGiveUp = MapService:Instance():IsGiveUpTiledInterval(tiled)
        if isGiveUp then
            self.deleteGiveUpLand.gameObject:SetActive(true)
            self.giveUpLand.gameObject:SetActive(false)
        else
            self.deleteGiveUpLand.gameObject:SetActive(false)
            self.giveUpLand.gameObject:SetActive(true)
        end
    else
        self.giveUpLand.gameObject:SetActive(false)
        self.deleteGiveUpLand.gameObject:SetActive(false);
    end
    self:FlushMainCityInfo(tiled)
    self:SetLeftInformations();
    self:Diplomacy(tiled)
    self:RefreshNpcRecoverTime()

       ClickService:Instance():GetCurClickUI(Vector3.New(self.leftParent.transform.localPosition.x, self.leftParent.transform.localPosition.y  - CommonService:Instance():GetChildCount(self.leftParent.transform) * 22-113, 0))
end

function UIWildCityTown:Diplomacy(tiled)
    self.amity.gameObject:SetActive(false)
    self.diplomacy.gameObject:SetActive(false)
    if tiled ~= nil then
        if tiled.tiledInfo ~= nil and tiled.tiledInfo.leagueId ~= PlayerService:Instance():GetLeagueId() then
            if  PlayerService:Instance():GetLeagueRelation(tiled.tiledInfo.leagueId) == 1 then
                self.amity.gameObject:SetActive(true)
            elseif PlayerService:Instance():GetLeagueRelation(tiled.tiledInfo.leagueId) == 2 then
                self.diplomacy.gameObject:SetActive(true)
            else
                self.amity.gameObject:SetActive(false)
                self.diplomacy.gameObject:SetActive(false) 
            end
        end
    end
end


-- 刷新守军恢复时间
function UIWildCityTown:RefreshNpcRecoverTime()
    if self.tiled.tiledInfo == nil then
        self._npcRecoverTimePanel.gameObject:SetActive(false)
        return
    end
    -- print("当前格子的索引 == " .. self.tiled.tiledInfo.tiledId)
    local npcRecoverTime = self.tiled.tiledInfo.nPCRecoverTime
    local curTime = PlayerService:Instance():GetLocalTime()
    -- print("守军恢复时间差 == " .. (npcRecoverTime - curTime))
    if npcRecoverTime - curTime > 0 then
        self._npcRecoverTimePanel.gameObject:SetActive(true)
    else
        self._npcRecoverTimePanel.gameObject:SetActive(false)
    end
    local recoverTime = npcRecoverTime - curTime
    local cdTime = math.floor(recoverTime / 1000)
    if cdTime <= 0 then
        cdTime = 0
    end
    self._npcRecoverTime.text = CommonService:Instance():GetDateString(cdTime)
    CommonService:Instance():TimeDown(nil,npcRecoverTime,self._npcRecoverTime,function() self._npcRecoverTimePanel.gameObject:SetActive(false) end)
end

-- 显示左侧所有的信息
function UIWildCityTown:SetLeftInformations()
    local resource = MapService:Instance():GetBuildingTownDataTile(self.tiled)
    -- 占领该城区者同盟、名字
    if self.tiled.tiledInfo ~= nil then
        if self.tiled.tiledInfo.ownerId ~= 0 then
            self.LeagueImage.gameObject:SetActive(true);
            self.PossessorImage.gameObject:SetActive(true);
            if self.tiled.tiledInfo.ownerId ~= PlayerService:Instance():GetPlayerId() then
                self.mailBtn.gameObject:SetActive(true)
            else
                self.mailBtn.gameObject:SetActive(false)
            end
            if self.tiled.tiledInfo.leagueId ~= 0 then
                self.leagueName.text = "<color=#71b448>" .. self.tiled.tiledInfo.leagueName .. "</color>";
            else
                self.leagueName.text = "<color=#BF3636FF>在野</color>";
            end
        else
            self.LeagueImage.gameObject:SetActive(false);
            self.PossessorImage.gameObject:SetActive(false);
        end
    else
        self.LeagueImage.gameObject:SetActive(false);
        self.PossessorImage.gameObject:SetActive(false);
    end
    
    local town = self.tiled:GetTown();
    if town ~= nil then
        local building = town._building;
        if building ~= nil then
            local name = building._name;
            if building._dataInfo ~= nil then
                -- 税收加成
                local townAreaTiledId = building._dataInfo.OuterRingTileID;
                if self.tiled.tiledInfo ~= nil and self.tiled.tiledInfo.ownerId ~= 0 then
                    self.playerName.text = self.tiled.tiledInfo.ownerName;
                else
                    self.playerName.text = building._dataInfo.Name;
                end
                
                print("外层tiledId == " .. townAreaTiledId)
                self.CityProperNumImg.text = "税收+" .. DataTile[townAreaTiledId].TaxRevenue;
                self.explainText.text = "占领<color=#FFFF00>" .. building._dataInfo.Name .. "</color>后增加" ..(DataTile[townAreaTiledId].TaxModifier / 100) .. "%";
            end
        end
    end

    -- 免战时间
    self:_ArmyStateRequest();

    -- 守军强度
    --LogManager:Instance():Log("守军   :  " .. resource.NPCTroopLv .. " 土地等级：" .. resource.TileLv);
    self.defendingText.text = "Lv." .. resource.NPCTroopLv;

end

function UIWildCityTown:OnClickMailBtn()
    CommonService:Instance():RequestPlayerInfo(self.tiled.tiledInfo.ownerId);
end

-- 免战时间显示
function UIWildCityTown:_ArmyStateRequest()
    if self.tiled.tiledInfo == nil then
        self._avoidWarImage.gameObject:SetActive(false);
        return
    end
    local freeWarEndTime = self.tiled.tiledInfo.avoidWarTime;
    local curTime = PlayerService:Instance():GetLocalTime();

    if freeWarEndTime - curTime > 0 and self.tiled.tiledInfo.ownerId == PlayerService:Instance():GetPlayerId() then
        self._avoidWarImage.gameObject:SetActive(true)
    else
        self._avoidWarImage.gameObject:SetActive(false);
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

-- 标记
function UIWildCityTown:OnClickSignBtn()
    local name = nil;
    if self.tiled ~= nil then
        if self.tiled._town ~= nil then
            name = self.tiled._town._building._dataInfo.Name .. "-城区"
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
function UIWildCityTown:OnClickDeleteSignBtn()
    local msg = require("MessageCommon/Msg/C2L/Player/RequestUndoMarker").new();
    msg:SetMessageId(C2L_Player.RequestUndoMarker);
    msg.tiledIndex = self.curTiledIndex;
    NetService:Instance():SendMessage(msg);
    self.gameObject:SetActive(false);
    MapService:Instance():HideTiled()
end

-- 是否已标记 
function UIWildCityTown:FlushMainCityInfo(tiled)
    local isMarked = UIService:Instance():IsMarked(tiled);
    if isMarked then
        self.signImage1.gameObject:SetActive(true);
        self.signImage.gameObject:SetActive(false);
    else
        self.signImage1.gameObject:SetActive(false);
        self.signImage.gameObject:SetActive(true);
    end
end

-- 放弃
function UIWildCityTown:OnClickUpLand()
    MapService:Instance():HideTiled()
    local tiled = MapService:Instance():GetTiledByIndex(self.curTiledIndex);
    if tiled == nil then
        return
    end
    if tiled.tiledInfo == nil then
        return
    end
    if PlayerService:Instance():GetLocalTime() <= tiled.tiledInfo.avoidWarTime then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.CannotGiveUpLand)
        return
    end
    UIService:Instance():ShowUI(UIType.UIAbandonSoil, self.curTiledIndex);
end
-- 取消放弃
function UIWildCityTown:OnClickDeleteGiveUpLand()
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

-- 是否已放弃
function UIWildCityTown:IsAlreadyQuitState(tiled)
    if tiled ~= nil then
        --print(tiled.IsAlreadyQuit)
        if tiled.IsAlreadyQuit == false then
            self.giveUpLand.gameObject:SetActive(true);
            self.deleteGiveUpLand.gameObject:SetActive(false);
        else
            self.giveUpLand.gameObject:SetActive(false);
            self.deleteGiveUpLand.gameObject:SetActive(true);
        end
    end
end

function UIWildCityTown:SetavoidWar()

end

-- -- 部队出征
-- function UIWildCityTown:OnClickCampaignerBtn()

--     if self:CheckTiledIsForBattle() == false then
--         UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.HaveNoBorderTiled);
--         return
--     end
--     self.gameObject:SetActive(false)

--     if PlayerService:Instance():IsHaveCanSendArmy() == false then
--         UIService:Instance():ShowUI(UIType.UICueMessageBox, 144);
--         return;
--     end

--     local param = { }
--     param.troopsNum = 1
--     param.troopType = SelfLand.battle
--     param.tiledIndex = self.curTiledIndex;
--     UIService:Instance():ShowUI(UIType.UISelfLandFunction, param);
--     UIService:Instance():HideUI(UIType.UIGameMainView)
-- end

-- 检测是否有相邻地块
function UIWildCityTown:CheckTiledIsForBattle()
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


return UIWildCityTown;
