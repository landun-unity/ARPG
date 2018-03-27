--[[
    自建要塞
--]]

local UIBase = require("Game/UI/UIBase");
local UIOnBuilding = class("UIOnBuilding", UIBase);
local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");
require("Game/Table/InitTable");
local SelfLand = require("Game/MapMenu/SelfLand"); 

-- 构造函数
function UIOnBuilding:ctor()
    UIOnBuilding.super.ctor(self);
    self._landGradeText = nil;
    self._roomText = nil;
    self._Coord = nil;
    self._NameText1 = nil;
    self._NameText2 = nil;
    self.curTiledIndex = nil;
    self.tiled = nil;
    self.PersonageImage = nil;
    self.HangFlagsImage = nil;
    self.PersonageImage1 = nil;
    self.HangFlagsImage1 = nil;

    self.AvoidWarImage = nil;
    self.AvoidWarTimeText = nil;
    self.signImage = nil;
    self.signImage1 = nil;
    self.FloodImage = nil;
    self.Personal =nil;
end

-- 初始化的时候
function UIOnBuilding:OnInit()

end

-- 初始化
function UIOnBuilding:DoDataExchange()
    self._landGradeText = self:RegisterController(UnityEngine.UI.Text, "backImg/LandName/landGrade/Text");
    self._roomText = self:RegisterController(UnityEngine.UI.Text, "backImg/LandName/place/roomText");
    self._Coord = self:RegisterController(UnityEngine.UI.Text, "backImg/LandName/place/Coord");
    -- self.PersonageImage = self:RegisterController(UnityEngine.UI.Image,"backImg/Personal/PersonageImage")
    self.HangFlagsImage = self:RegisterController(UnityEngine.UI.Image, "backImg/Personal/HangFlagsImage")
    self.PersonageImage1 = self:RegisterController(UnityEngine.UI.Image, "backImg/Personal/PersonageImage1")
    -- self.HangFlagsImage1 = self:RegisterController(UnityEngine.UI.Image,"backImg/Personal/HangFlagsImage1")
    self._NameText1 = self:RegisterController(UnityEngine.UI.Text, "backImg/Personal/PersonageImage1/NameText")
    self._NameText2 = self:RegisterController(UnityEngine.UI.Text, "backImg/Personal/HangFlagsImage/NameText");
    self.Personal =self:RegisterController(UnityEngine.Transform, "backImg/Personal")

    -- self._PersonageNameText1 = self:RegisterController(UnityEngine.UI.Text,"backImg/Personal/PersonageImage1/NameText")
    -- self._PersonageNameText2 = self:RegisterController(UnityEngine.UI.Text,"backImg/Personal/HangFlagsImage1/NameText");
    self.signImage = self:RegisterController(UnityEngine.UI.Button, "signImage")
    self.abandon = self:RegisterController(UnityEngine.UI.Button, "abandon")

    self.AvoidWarImage = self:RegisterController(UnityEngine.UI.Image, "backImg/Personal/AvoidWarImage")
    self.AvoidWarTimeText = self:RegisterController(UnityEngine.UI.Text, "backImg/Personal/AvoidWarImage/AvoidWarTimeText")
    self.signImage1 = self:RegisterController(UnityEngine.UI.Button, "signImage1")
    self.FloodImage = self:RegisterController(UnityEngine.UI.Image, "backImg/Personal/PersonageImage1/FloodImage")
end

-- 注册按钮点击事件
function UIOnBuilding:DoEventAdd()
    self:AddListener(self.signImage, self.OnClickSignImage);
    self:AddListener(self.abandon, self.OnClickAbandon)
    self:AddListener(self.signImage1, self.OnClickUndoSign)
end

function UIOnBuilding:OnShow()

end


function UIOnBuilding:OnClickSignImage()
    local name = nil;
    if self.tiled ~= nil then
        if self.tiled._building ~= nil then
            name = self.tiled._building._name
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

function UIOnBuilding:OnClickUndoSign()
    local msg = require("MessageCommon/Msg/C2L/Player/RequestUndoMarker").new();
    msg:SetMessageId(C2L_Player.RequestUndoMarker);
    msg.tiledIndex = self.curTiledIndex;
    NetService:Instance():SendMessage(msg);
    self.gameObject:SetActive(false);
    MapService:Instance():HideTiled()
end

-- 是否已标记 
function UIOnBuilding:FlushMainCityInfo(tiled)
    local isMarked = UIService:Instance():IsMarked(tiled);
    if isMarked then
        self.signImage1.gameObject:SetActive(true);
        self.signImage.gameObject:SetActive(false);
    else
        self.signImage1.gameObject:SetActive(false);
        self.signImage.gameObject:SetActive(true);
    end
end


-- 加载资源
function UIOnBuilding:ShowTiled(tiled)
    self.gameObject.transform.localScale = Vector3.New(1.52, 1.52, 1.52);
    self:FlushMainCityInfo(tiled);
    -- self.PersonageImage.gameObject:SetActive(false);
    self.HangFlagsImage.gameObject:SetActive(false);
    self.PersonageImage1.gameObject:SetActive(false);
    if tiled.tiledInfo ~= nil then
        if tiled.tiledInfo.superiorLeagueId ~= 0 then
            self.FloodImage.gameObject:SetActive(true)
        else
            self.FloodImage.gameObject:SetActive(false)
        end
    else
        self.FloodImage.gameObject:SetActive(false)
    end
    -- self.HangFlagsImage1.gameObject:SetActive(false);
    self.tiled = tiled;
    self.curTiledIndex = tiled:GetIndex()
    local positionx = tiled:GetX();
    local positiony = tiled:GetY();
    self._Coord.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = positionx .. " , " .. positiony;
    local thename = nil;
    local thestate = nil;
    local region = tiled:GetRegion();
    local mystate = DataState[region.StateID];
    local mystates = mystate.Name;
    local regions = region.Name;
    self._roomText.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = mystates .. "-" .. regions;
    -- local building = BuildingService.Instance():GetBuildingByTiledId(self.curTiledIndex);
    -- local buildName = building._name;
    -- self._landGradeText.text = buildName;
    if tiled ~= nil and tiled.tiledInfo ~= nil then
        local leagueId = tiled.tiledInfo.leagueId
        if leagueId == 0 then
            self.HangFlagsImage.gameObject:SetActive(true)
            self.PersonageImage1.gameObject:SetActive(true);
            self._NameText1.text = "<color=#71b448>" ..tiled.tiledInfo.ownerName.. "</color>";  
            self._NameText2.text = "<color=#BF3636FF>在野</color>";
        else
            self.HangFlagsImage.gameObject:SetActive(true)
            self.PersonageImage1.gameObject:SetActive(true);
            self._NameText1.text = "<color=#71b448>" .. tiled.tiledInfo.ownerName .. "</color>";  
            self._NameText2.text = "<color=#71b448>" .. tiled.tiledInfo.leagueName.. "</color>";  
        end
    end

    if tiled.tiledInfo ~= nil then
        if tiled.tiledInfo.avoidWarTime >= 0 then
            local freeWarEndTime = tiled.tiledInfo.avoidWarTime;
            local localTime = PlayerService:Instance():GetLocalTime()
            local avoidTime = freeWarEndTime - localTime
            local myId = PlayerService:Instance():GetPlayerId()
            local ownerId = tiled.tiledInfo.ownerId
            self.AvoidWarImage.gameObject:SetActive(false)
            if avoidTime >= 0 and myId == ownerId then
                self.AvoidWarImage.gameObject:SetActive(true)
            end
            local cdTime = math.floor(avoidTime / 1000)
            if cdTime <= 0 then
                cdTime = 0;
            end
            self.AvoidWarTimeText.text = CommonService:Instance():GetDateString(cdTime);
            CommonService:Instance():TimeDown(nil,freeWarEndTime,self.AvoidWarTimeText,function() self.AvoidWarImage.gameObject:SetActive(false) end);
        end
    end
    self.abandon.gameObject:SetActive(false)


      ClickService:Instance():GetCurClickUI(Vector3.New(self.Personal.transform.localPosition.x, self.Personal.localPosition.y  - CommonService:Instance():GetChildCount(self.Personal.transform) * 22-113, 0))
end


return UIOnBuilding;
