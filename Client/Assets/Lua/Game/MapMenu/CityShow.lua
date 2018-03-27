local UIBase = require("Game/UI/UIBase")
local MapService = require("Game/Map/MapService")
local OperatorType = require("Game/Map/Operator/OperatorType")
-- local ClickManage = require("Game/Map/ClickMenu/ClickManage")
local CityShow = class("CityShow", UIBase)
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
local SelfLand = require("Game/MapMenu/SelfLand");
-- local C2L_Facility = require("MessageCommon/Handler/C2L/C2L_Facility");
require("Game/Table/InitTable");


function CityShow:ctor()
    CityShow.super.ctor(self)
    self.cityBtn = nil;
    self.garrisonBtn = nil;
    self.tileIndex = nil;
    self.playerName = nil
    self.curTiledIndex = nil
    self.tiled = nil;
    self.signImage = nil;
    self.signUndoImage = nil;
    self.mName = nil;
    self.meng = nil;
    self.meng1 = nil;
    self.mName1 = nil;
    self.leagueName = nil;
    self._avoidWarImage = nil;
    self.avoidWarTimeText = nil;
    self.cancelGiveUpBtn = nil;
    self.FloodImage = nil;
    self.leftParent = nil;
end

-- 注册控件
function CityShow:DoDataExchange()
    self.cityBtn = self:RegisterController(UnityEngine.UI.Button, "City");
    self.garrisonBtn = self:RegisterController(UnityEngine.UI.Button, "garrison");
    self.playerName = self:RegisterController(UnityEngine.UI.Text, "Panel/mName/resourceText");
    self.leagueName = self:RegisterController(UnityEngine.UI.Text, "Panel/meng/resourceText")
    self.signImage = self:RegisterController(UnityEngine.UI.Button, "signImage");
    self.signUndoImage = self:RegisterController(UnityEngine.UI.Button, "signUndoImage")
    -- self.mName = self:RegisterController(UnityEngine.RectTransform,"Panel/mName")
    -- self.meng = self:RegisterController(UnityEngine.RectTransform,"Panel/meng")
    self.FloodImage = self:RegisterController(UnityEngine.UI.Image, "FloodImage")
    self.mName1 = self:RegisterController(UnityEngine.RectTransform, "Panel/mName1")
    self.meng1 = self:RegisterController(UnityEngine.RectTransform, "Panel/meng1")
    self.playerName1 = self:RegisterController(UnityEngine.UI.Text, "Panel/mName1/resourceText");
    self.leagueName1 = self:RegisterController(UnityEngine.UI.Text, "Panel/meng1/resourceText")
    self._avoidWarImage = self:RegisterController(UnityEngine.UI.Image, "Panel/AvoidWarImage");
    self.avoidWarTimeText = self:RegisterController(UnityEngine.UI.Text, "Panel/AvoidWarImage/AvoidWarTimeText");
    self.cancelGiveUpBtn = self:RegisterController(UnityEngine.UI.Button, "cancelGiveUpImage");
    self.leftParent = self:RegisterController(UnityEngine.RectTransform, "Panel");
end

function CityShow:RegisterAllNotice()
    -- self:RegisterNotice(L2C_Facility.SynMarkerInfoRespond, self.RefreshExp);
    -- self:RegisterNotice(L2C_Facility.CityExpandRespond, self.CityExpandRespond);
    -- self:RegisterNotice(L2C_Facility.OpenCityFacilityRespond, self.RefreshExp);
    -- self:RegisterNotice(L2C_Facility.CityExpandRespond, self.CityExpandRespond);
end

-- 注册点击事件
function CityShow:DoEventAdd()
    self:AddListener(self.cityBtn, self.OnCilckCityBtn);
    self:AddListener(self.garrisonBtn, self.OnCilckGarrisonBtn);
    self:AddListener(self.signImage, self.OnClickSign);
    self:AddListener(self.signUndoImage, self.OnClicksignUndoImage);
    self:AddListener(self.cancelGiveUpBtn, self.OnCancelGiveUpBtn);
end

function CityShow:OnCilckCityBtn()
    MapService:Instance():HideTiled()
    -- 发送消息
    self:CityExpandRespond();
    local gameObj = UnityEngine.GameObject.Find("UIPublicClick")
    if gameObj ~= nil then
        gameObj:SetActive(false);
    end
end

function CityShow:OnCilckGarrisonBtn()
    if NewerPeriodService:Instance():CanGarrison() == false then
        return;
    end

    if PlayerService:Instance():IsHaveCanSendArmy() == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 144);
        return;
    end

    MapService:Instance():HideTiled()
    self.gameObject:SetActive(false)
    local param = { }
    param.troopsNum = 1
    param.troopType = SelfLand.garrison
    param.tiledIndex = self.curTiledIndex
    UIService:Instance():ShowUI(UIType.UISelfLandFunction, param);
    MapService:Instance():HideTiled()
    UIService:Instance():HideUI(UIType.UIGameMainView)
end
-- 标记
function CityShow:OnClickSign()
    local name = nil;
    if self.tiled ~= nil then
        if self.tiled._town ~= nil then
            if self.tiled._town._building._dataInfo.Type == BuildingType.MainCity then
                name = PlayerService:Instance():GetName().."-城区";
            elseif self.tiled._town._building._dataInfo.Type == BuildingType.SubCity then
                name = self.tiled._town._building._name.."-城区";
            end
        elseif self.tiled._building ~= nil then
            name = self.tiled._building._name.." (Lv."..self.tiled:GetResource().TileLv..")"
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
--  取消标记
function CityShow:OnClicksignUndoImage()
    local msg = require("MessageCommon/Msg/C2L/Player/RequestUndoMarker").new();
    msg:SetMessageId(C2L_Player.RequestUndoMarker);
    msg.tiledIndex = self.curTiledIndex;
    NetService:Instance():SendMessage(msg);
    -- print("取消标记点击事件")
    self.gameObject:SetActive(false);
    MapService:Instance():HideTiled()

end

-- 取消放弃
function CityShow:OnCancelGiveUpBtn()
    local msg = require("MessageCommon/Msg/C2L/Building/CancelRemoveSubCityRequest").new();
    msg:SetMessageId(C2L_Building.CancelRemoveSubCityRequest);
    local building = nil;
    if self.tiled:GetBuilding() == nil then
        building = self.tiled:GetTown()._building;
    else
        building = self.tiled:GetBuilding();
    end
    msg.buildingID = building._id;
    NetService:Instance():SendMessage(msg);
    MapService:Instance():HideTiled()
    self.gameObject:SetActive(false)
end

function CityShow:FlushMainCityInfo(tiled)
    local isMarked = UIService:Instance():IsMarked(tiled);
    if isMarked then
        self.signUndoImage.gameObject:SetActive(true);
        self.signImage.gameObject:SetActive(false);
    else
        self.signUndoImage.gameObject:SetActive(false);
        self.signImage.gameObject:SetActive(true);
    end
end

-- -- 检测一块地是否标记
-- function CityShow:IsMarked(tiled)
--     local markerCount = PlayerService:Instance():GetMainCityCount()
--     for i = 1, markerCount do
--         if tiled:GetIndex() == PlayerService:Instance():GetMainCitySign(i) then
--             return true
--         end
--     end
--     return false
-- end

function CityShow:ShowCityBtn(tiled)
    local building = tiled:GetBuilding();
    if building == nil then
        building = tiled:GetTown()._building;
        if building:JudgeSubCityIsCreating() or building:JudgeSubCityIsDeleting() then
            self.cityBtn.gameObject:SetActive(false);
            self.garrisonBtn.gameObject:SetActive(false);
        else
            self.cityBtn.gameObject:SetActive(true);
            if NewerPeriodService:Instance():CanGarrison() == false then
                if self.garrisonBtn.gameObject.activeSelf == true then
                    self.garrisonBtn.gameObject:SetActive(false);
                end
            else
                if self.garrisonBtn.gameObject.activeSelf == false then
                    self.garrisonBtn.gameObject:SetActive(true);
                end
            end
        end
        if building:JudgeSubCityIsDeleting() then
            self.cancelGiveUpBtn.gameObject:SetActive(true);
        else
            self.cancelGiveUpBtn.gameObject:SetActive(false);
        end
    else
        if building:JudgeSubCityIsCreating()  then
            self.cityBtn.gameObject:SetActive(false);
        else
            self.cityBtn.gameObject:SetActive(true);
        end

        if building:JudgeSubCityIsDeleting() then
            self.cancelGiveUpBtn.gameObject:SetActive(true);
        else
            self.cancelGiveUpBtn.gameObject:SetActive(false);
        end
        self.garrisonBtn.gameObject:SetActive(true);
    end
end


-- 加载资源
function CityShow:ShowTiled(tiled)
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
    self:ShowCityBtn(tiled);
    self.curTiledIndex = tiled._index
    self.tiled = tiled;
    self:FlushMainCityInfo(tiled)
    local playerId = PlayerService:Instance():GetPlayerId();
    local leagueId = PlayerService:Instance():GetLeagueId();
    local superLeagueId = PlayerService:Instance():GetsuperiorLeagueId();
    if leagueId == 0 and playerId == tiled.tiledInfo.ownerId then
        self.playerName1.text = PlayerService:Instance():GetName();
        self.leagueName1.text = "<color=#BF3636FF>在野</color>"
    elseif leagueId ~= 0 and playerId == tiled.tiledInfo.ownerId then
        self.playerName1.text = PlayerService:Instance():GetName();
        self.leagueName1.text = "<color=#71b448>" .. PlayerService:Instance():GetLeagueName() .. "</color>";
    elseif superLeagueId ~= 0 and playerId ~= tiled.tiledInfo.ownerId then
        self.playerName1.text = PlayerService:Instance():GetName();
        self.leagueName1.text = "<color=#BF3636FF>" .. PlayerService:Instance():GetsuperiorName() .. "</color>";
    end
    local freeWarEndTime = self.tiled.tiledInfo.avoidWarTime;
    local curTime = PlayerService:Instance():GetLocalTime();
    self._avoidWarImage.gameObject:SetActive(false);
    if freeWarEndTime - curTime > 0 then
        self:_ArmyStateRequest();
    end

--    local town = self.tiled:GetTown();
--    if town ~= nil then
--        local building = town._building;
--        if building ~= nil then
--            if building._dataInfo.Type == BuildingType.SubCity then
--                self.garrisonBtn.gameObject:SetActive(false);
--            else
--                self.garrisonBtn.gameObject:SetActive(true);      
--            end
--        end
--    end
  ClickService:Instance():GetCurClickUI(Vector3.New(self.leftParent.transform.localPosition.x, self.leftParent.transform.localPosition.y - CommonService:Instance():GetChildCount(self.leftParent.transform) * 22-113, 0))
end

function CityShow:CityExpandRespond()
    if self.tiled._building ~= nil or self.tiled:GetTown() ~= nil then
        local building = nil;
        if self.tiled._building ~= nil then
            building = self.tiled._building;
        else
            building = self.tiled:GetTown()._building;
        end
        local param = { };
        param[0] = building
        UIService:Instance():ShowUI(UIType.UIMainCity, param);
        UIService:Instance():HideUI(UIType.UIGameMainView);
        MapService:Instance():SetCallBack(building._tiledId);
        MapService:Instance():ClickCityCallBack();
        MapService:Instance():EnterOperator(OperatorType.ZoomOut);
    end
    self:HideTiled();
    ClickService:Instance():HideUIBreathingFrame();
end

-- 免战时间显示
function CityShow:_ArmyStateRequest()
    local freeWarEndTime = self.tiled.tiledInfo.avoidWarTime;
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

function CityShow:HideTiled()
    self.gameObject:SetActive(false);
end

return CityShow;