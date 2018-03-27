--[[
    自建要塞
--]]

local UIBase = require("Game/UI/UIBase");
local UIWildeFort = class("UIWildeFort", UIBase);
local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");
require("Game/Table/InitTable");
local SelfLand = require("Game/MapMenu/SelfLand");
local BuildingType = require("Game/Build/BuildingType");

-- 构造函数
function UIWildeFort:ctor()
    UIWildeFort.super.ctor(self);

    self._NameText1 = nil;
    self._NameText2 = nil;
    self.fortress = nil;
    self.campaigner = nil;
    self.curTiledIndex = nil;
    self.tiled = nil;
    self.PersonageImage = nil;
    self.HangFlagsImage = nil;
    self.signImage1 = nil;
    self.abolishQuit = nil;
    self.abolishQuitLand = nil;
    self.FortressObj = nil;
    self.campaignerBattle = nil;
    self.AvoidWarImage = nil;
    self.AvoidWarTimeText = nil;
    self.Personal =nil;
    self.troops = nil;
    self.introduction = nil;
    self.Defender = nil;
    self.DefenderText = nil;
    self.introductionText = nil;
end

-- 初始化的时候
function UIWildeFort:OnInit()
    return true;
end

-- 初始化
function UIWildeFort:DoDataExchange()
    self.PersonageImage = self:RegisterController(UnityEngine.UI.Image, "backImg/Personal/PersonageImage")
    self.HangFlagsImage = self:RegisterController(UnityEngine.UI.Image, "backImg/Personal/HangFlagsImage")
    self._NameText1 = self:RegisterController(UnityEngine.UI.Text, "backImg/Personal/PersonageImage/NameText")
    self._NameText2 = self:RegisterController(UnityEngine.UI.Text, "backImg/Personal/HangFlagsImage/NameText");
    self.FloodImage = self:RegisterController(UnityEngine.UI.Image, "backImg/Personal/PersonageImage/FloodImage")
    self.fortress = self:RegisterController(UnityEngine.UI.Button, "FortressObj/fortress")
    self.campaigner = self:RegisterController(UnityEngine.UI.Button, "FortressObj/campaigner")
    self.garrison = self:RegisterController(UnityEngine.UI.Button, "FortressObj/garrison");
    self.signImage = self:RegisterController(UnityEngine.UI.Button, "signImage")
    self.abandon = self:RegisterController(UnityEngine.UI.Button, "abandon")
    self.Personal =self:RegisterController(UnityEngine.Transform,"backImg/Personal")
    self.signImage1 = self:RegisterController(UnityEngine.UI.Button, "signImage1")
    self.abolishQuit = self:RegisterController(UnityEngine.UI.Button, "abolishQuit");
    self.abolishQuitLand = self:RegisterController(UnityEngine.UI.Button, "abolishQuitLand")
    self.FortressObj = self:RegisterController(UnityEngine.Transform, "FortressObj")
    self.campaignerBattle = self:RegisterController(UnityEngine.UI.Button, "campaigner")
    self.AvoidWarImage = self:RegisterController(UnityEngine.UI.Image,"backImg/Personal/AvoidWarImage")
    self.AvoidWarTimeText = self:RegisterController(UnityEngine.UI.Text,"backImg/Personal/AvoidWarImage/AvoidWarTimeText")
    self.troops  = self:RegisterController(UnityEngine.UI.Image,"backImg/Personal/troops")
    self.introduction = self:RegisterController(UnityEngine.UI.Text,"backImg/Personal/introduction")
    self.Defender = self:RegisterController(UnityEngine.UI.Image,"backImg/Personal/Defender")
    self.DefenderText = self:RegisterController(UnityEngine.UI.Text,"backImg/Personal/Defender/Text")
    self.introductionText = self:RegisterController(UnityEngine.UI.Text,"backImg/Personal/introduction/Text")
end

-- 注册按钮点击事件
function UIWildeFort:DoEventAdd()
    self:AddListener(self.fortress, self.OnClickFortress);
    self:AddListener(self.campaigner, self.OnClickCampaigner);
    self:AddListener(self.garrison, self.OnClickGarrison);
    self:AddListener(self.signImage, self.OnClickSignImage);
    self:AddListener(self.abandon, self.OnClickAbandon)
    self:AddListener(self.signImage1, self.OnClickDeleteSignBtn);
    self:AddListener(self.abolishQuit, self.OnClickquit)
    self:AddListener(self.abolishQuitLand, self.OnClickQuitLandBtn);
    self:AddListener(self.campaignerBattle, self.OnClickCampaignerBattleBtn)
end

function UIWildeFort:OnShow()

end

function UIWildeFort:avoidWarTime(tiled)
    local freeWarEndTime = tiled.tiledInfo.avoidWarTime;
    local curTime = PlayerService:Instance():GetLocalTime();
    if freeWarEndTime - curTime <= 0 then
        self.AvoidWarImage.gameObject:SetActive(false);
        return;
    else
        self.AvoidWarImage.gameObject:SetActive(true)
    end
    local avoidTime = freeWarEndTime - curTime;
    local cdTime = math.floor(avoidTime / 1000)
    if cdTime <= 0 then
        cdTime = 0;
    end
    self.AvoidWarTimeText.text = CommonService:Instance():GetDateString(cdTime);
    CommonService:Instance():TimeDown(nil,freeWarEndTime,self.AvoidWarTimeText, function() self.AvoidWarImage.gameObject:SetActive(false) end);
    return avoidTime
end

-- 点击要塞
function UIWildeFort:OnClickFortress()
    MapService:Instance():HideTiled()
    local building = BuildingService:Instance():GetBuildingByTiledId(self.curTiledIndex);
    local tiled = MapService:Instance():GetTiledByIndex(self.curTiledIndex)
    if building ~= nil then
        local param = { }
        param[0] = self.tiled._building
        UIService:Instance():ShowUI(UIType.UIMainCity, param);
        self.gameObject:SetActive(false);
        
        --MapService:Instance():ChangeBiggerView();
        MapService:Instance():SetCallBack(building._tiledId);
        MapService:Instance():ClickCityCallBack();
        --MapService:Instance():ScanTiled(self.curTiledIndex)
        MapService:Instance():EnterOperator(OperatorType.ZoomOut, tiled);
        UIService:Instance():HideUI(UIType.UIGameMainView)
    else
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.wildFortNoExistence);
        return
    end
end

-- 点击调动
function UIWildeFort:OnClickCampaigner()
    MapService:Instance():HideTiled()
    local building = BuildingService:Instance():GetBuildingByTiledId(self.curTiledIndex);
    if building == nil then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.wildFortNoExistence);
        return
    end

    if PlayerService:Instance():IsHaveCanSendArmy() == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 144);
        return;
    end

    if building._dataInfo.Type == BuildingType.WildFort or building._dataInfo.Type == BuildingType.WildGarrisonBuilding then
        local frade = 5;
        local armyNum = building:GetWildFortArmyInfoCounts();
        if frade == armyNum then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.ArmyNumSaturation);
            return
        end
        self:ShowUISelfLand(SelfLand.transfer);
        UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
        UIService:Instance():HideUI(UIType.UIArmyBattleDetail);
    elseif building._dataInfo.Type == BuildingType.PlayerFort then
        local frade = building._fortGrade;
        local armyNum = building:GetArmyInfoCounts();
        if frade == armyNum then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.ArmyNumSaturation);
            return
        end
        self:ShowUISelfLand(SelfLand.transfer);
        UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
        UIService:Instance():HideUI(UIType.UIArmyBattleDetail);
    end
end
-- 点击驻守
function UIWildeFort:OnClickGarrison()
    local building = BuildingService:Instance():GetBuildingByTiledId(self.curTiledIndex);
    if building == nil then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.wildFortNoExistence);
        return
    end

    if PlayerService:Instance():IsHaveCanSendArmy() == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 144);
        return;
    end

    MapService:Instance():HideTiled()
    self:ShowUISelfLand(SelfLand.garrison);
    UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
    UIService:Instance():HideUI(UIType.UIArmyBattleDetail);
end
-- 点击标记
function UIWildeFort:OnClickSignImage()
    local name = nil;
    if self.tiled ~= nil then
        if self.tiled._building ~= nil then
            name = self.tiled._building._name
        end
    end
    local building = BuildingService:Instance():GetBuildingByTiledId(self.curTiledIndex);
    if building == nil then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.wildFortNoExistence);
        return
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
function UIWildeFort:OnClickDeleteSignBtn()
    local msg = require("MessageCommon/Msg/C2L/Player/RequestUndoMarker").new();
    msg:SetMessageId(C2L_Player.RequestUndoMarker);
    msg.tiledIndex = self.curTiledIndex;
    NetService:Instance():SendMessage(msg);
    self.gameObject:SetActive(false);
    MapService:Instance():HideTiled()
end
-- 是否已标记 
function UIWildeFort:FlushMainCityInfo(tiled)
    local isMarked = UIService:Instance():IsMarked(tiled);
    if isMarked then
        self.signImage1.gameObject:SetActive(true);
        self.signImage.gameObject:SetActive(false);
    else
        self.signImage1.gameObject:SetActive(false);
        self.signImage.gameObject:SetActive(true);
    end
end
-- 取消放弃土地
function UIWildeFort:OnClickQuitLandBtn()
    local msg = require("MessageCommon/Msg/C2L/Army/CancelGiveUpOwnerLand").new();
    msg:SetMessageId(C2L_Army.CancelGiveUpOwnerLand)
    msg.tiledIndex = self.curTiledIndex
    NetService:Instance():SendMessage(msg)
    MapService:Instance():HideTiled()
end

function UIWildeFort:OnClickquit()
    local msg = require("MessageCommon/Msg/C2L/Building/ClickDeleteFort").new();
    msg:SetMessageId(C2L_Building.ClickDeleteFort);
    msg.index = self.curTiledIndex
    NetService:Instance():SendMessage(msg);
    self.gameObject:SetActive(false);
    MapService:Instance():HideFortTimeBox(self.curTiledIndex)
    MapService:Instance():HideTiled()
end

-- 点击放弃
function UIWildeFort:OnClickAbandon()
    local building = BuildingService:Instance():GetBuildingByTiledId(self.curTiledIndex);
    if building == nil then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.wildFortNoExistence);
        return
    end
    if self.tiled.tiledInfo.avoidWarTime - PlayerService:Instance():GetLocalTime() >= 0 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 123);
        MapService:Instance():HideTiled()
        return
    end
    UIService:Instance():ShowUI(UIType.UIAbandonSoil, self.curTiledIndex);
    self.gameObject:SetActive(false);
    MapService:Instance():HideTiled()
end

function UIWildeFort:ShowUISelfLand(selfLandType)
    self.gameObject:SetActive(false);
    local param = { }
    param.troopsNum = 1
    param.troopType = selfLandType
    param.tiledIndex = self.curTiledIndex
    UIService:Instance():ShowUI(UIType.UISelfLandFunction, param);
    UIService:Instance():HideUI(UIType.UIGameMainView);
end

-- 放弃状态下 弹出框显示
function UIWildeFort:HideForts()
    local building = self.tiled._building
    if building ~= nil then
        if building._buildDeleteTime - PlayerService:Instance():GetLocalTime() > 0 then
            self.abolishQuit.gameObject:SetActive(true)
            self.fortress.gameObject:SetActive(false)
            self.abandon.gameObject:SetActive(false)
        else
            self.abolishQuit.gameObject:SetActive(false);
            self.fortress.gameObject:SetActive(true);
            self.abandon.gameObject:SetActive(true);
        end
    end
end

-- 加载资源
function UIWildeFort:ShowTiled(tiled)
    if tiled.tiledInfo ~= nil then
        if tiled.tiledInfo.superiorLeagueId ~= 0 then
            self.FloodImage.gameObject:SetActive(true)
        else
            self.FloodImage.gameObject:SetActive(false)
        end
    else
        self.FloodImage.gameObject:SetActive(false)
    end
    self.gameObject.transform.localScale = Vector3.New(1.52, 1.52, 1.52);
    self:FlushMainCityInfo(tiled)
    self.abolishQuit.gameObject:SetActive(false);
    self.tiled = tiled;
    local building = self.tiled._building
    local isGiveUp = MapService:Instance():IsGiveUpTiledInterval(tiled)
    if isGiveUp then
        self.abolishQuitLand.gameObject:SetActive(true)
        self.fortress.gameObject:SetActive(false)
        self.abandon.gameObject:SetActive(false)
    elseif building._buildDeleteTime - PlayerService:Instance():GetLocalTime() > 0 then
        self.abolishQuit.gameObject:SetActive(true)
        self.fortress.gameObject:SetActive(false)
        self.abandon.gameObject:SetActive(false)
    else
        self.abolishQuit.gameObject:SetActive(false);
        self.abolishQuitLand.gameObject:SetActive(false)
        self.fortress.gameObject:SetActive(true)
        self.abandon.gameObject:SetActive(true)
    end
    -- self:HideForts()
    self.FortressObj.gameObject:SetActive(false);
    self.abandon.gameObject:SetActive(false);
    if tiled ~= nil and tiled.tiledInfo ~= nil and tiled.tiledInfo.ownerId ~= PlayerService:Instance():GetPlayerId() then
        self.FortressObj.gameObject:SetActive(false);
        -- self.campaignerBattle.gameObject:SetActive(true);
        self.abandon.gameObject:SetActive(false);
    elseif tiled ~= nil and tiled.tiledInfo ~= nil and tiled.tiledInfo.ownerId == PlayerService:Instance():GetPlayerId() then
        self.FortressObj.gameObject:SetActive(true);
        -- self.campaignerBattle.gameObject:SetActive(false);
        self.abandon.gameObject:SetActive(true)
    end
    self.curTiledIndex = tiled:GetIndex();
    local building = BuildingService.Instance():GetBuildingByTiledId(self.curTiledIndex);

    local leagueId = PlayerService:Instance():GetLeagueId();
    if tiled._building ~= nil and tiled._building._dataInfo ~= nil then
        if tiled._building._dataInfo.Type == BuildingType.WildFort then
            if tiled._building._owner == 0 then
                local resource = self.tiled:GetResource()
                self._NameText1.text = "野外要塞"
                self.HangFlagsImage.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("defenders");
            end
            if tiled.tiledInfo ~= nil then
                if tiled.tiledInfo.ownerId ~= 0 and leagueId == 0 then
                    self._NameText1.text = "<color=#71b448>" .. tiled.tiledInfo.ownerName .. "</color>";
                    self._NameText2.text = "<color=#BF3636FF>在野</color>"
                elseif tiled.tiledInfo.ownerId ~= 0 and leagueId ~= 0 then
                    self._NameText1.text = tiled.tiledInfo.ownerName
                    self._NameText2.text = "<color=#71b448>" .. tiled.tiledInfo.leagueName .. "</color>";
                end
            end
        elseif tiled._building._dataInfo.Type == BuildingType.PlayerFort then
            if leagueId == 0 then
                self._NameText1.text = "<color=#71b448>" ..PlayerService:Instance():GetName().."</color>";
                self._NameText2.text = "<color=#BF3636FF>在野</color>"
            else
                self._NameText1.text = "<color=#71b448>" ..PlayerService:Instance():GetName().."</color>";
                self._NameText2.text = "<color=#71b448>" .. PlayerService:Instance():GetLeagueName() .. "</color>";
            end
        elseif tiled._building._dataInfo.Type == BuildingType.WildGarrisonBuilding then
            self.troops.gameObject:SetActive(true);
            self.introduction.gameObject:SetActive(true)
            self.introduction.text = "个人占领,可通过调动放置5支部队,存在少量预备兵"
            self.Defender.gameObject:SetActive(true);
            self.DefenderText.text = "守军强度 Lv " .. DataTile[DataTileCut[tiled:GetImageId(LayerType.WildFort)].TileID].NPCTroopLv
            self.introductionText.text = "个人占领,可通过调动放置5支部队,存在少量预备兵"
            if leagueId == 0 then
                self._NameText1.text = "<color=#71b448>" ..PlayerService:Instance():GetName().."</color>";
                self._NameText2.text = "<color=#BF3636FF>在野</color>"
            else
                self._NameText1.text = "<color=#71b448>" ..PlayerService:Instance():GetName().."</color>";
                self._NameText2.text = "<color=#71b448>" .. PlayerService:Instance():GetLeagueName() .. "</color>";
            end
        end
    end
        if tiled.tiledInfo ~= nil then
            self:avoidWarTime(tiled)
        end
        ClickService:Instance():GetCurClickUI(Vector3.New(self.Personal.transform.localPosition.x, self.Personal.localPosition.y  - CommonService:Instance():GetChildCount(self.Personal.transform) * 22-113, 0))
end

return UIWildeFort;
