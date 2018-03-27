--[[
    野地、别人占领的土地界面
--]]

local UIBase = require("Game/UI/UIBase");
local UIWildernes = class("UIWildernes", UIBase);
local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");
local SelfLand = require("Game/MapMenu/SelfLand");
local LayerType = require("Game/Map/LayerType")
local UICueMessageType = require("Game/UI/UICueMessageType");
require("Game/Table/InitTable");
require("Game/League/LeagueTitleType")
-- 构造函数
function UIWildernes:ctor()
    UIWildernes.super.ctor(self);
    self.campaigner = nil;
    self.signImage = nil;
    self._cancelSignImage = nil;
    self.cancelSign = nil;

    -- 左侧
    self.leftParent = nil;
    --   self.avoidWarTimeText = nil;
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
    --  self._avoidWarImage = nil;
    self.DeImage = nil;
    self.FloodImage = nil;
    self.tiled = nil;
    self.curTiledIndex = nil;
    self.diplomacy = nil;
    self.amity = nil;
    self.mailImage = nil;
end

-- 注册控件
function UIWildernes:DoDataExchange()
    self.campaigner = self:RegisterController(UnityEngine.UI.Button, "campaigner");
    self.signImage = self:RegisterController(UnityEngine.UI.Button, "signImage");
    self._cancelSignImage = self:RegisterController(UnityEngine.UI.Button, "cancelSignImage");
    self.cancelSign = self:RegisterController(UnityEngine.UI.Button, "cancelSignImage")
    self.FloodImage = self:RegisterController(UnityEngine.UI.Image, "FloodImage")
    -- 左侧
    -- self.avoidWarTimeText = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/AvoidWarImage/AvoidWarTimeText");
    self.leftParent = self:RegisterController(UnityEngine.RectTransform, "OneLevelOfLandImage");
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
    -- self._avoidWarImage = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/AvoidWarImage");
    self.DeImage = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/DeImage")
    self.diplomacy = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/LeagueImage/diplomacy")
    self.amity = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/LeagueImage/amity")
    self.mailImage = self:RegisterController(UnityEngine.UI.Button, "OneLevelOfLandImage/PossessorImage/PossessorNameText/Image");
end

-- 注册控件点击事件
function UIWildernes:DoEventAdd()
    self:AddListener(self.campaigner, self.OnClickCampaignerBtn);
    self:AddListener(self.signImage, self.OnClickSignBtn);
    self:AddListener(self._cancelSignImage, self.OnClickcanceSignBtn);
    self:AddListener(self.mailImage, self.OnClickMailBtn);
end

-- 加载土地资源产量
function UIWildernes:ShowTiled(tiled)
    self.gameObject.transform.localScale = Vector3.New(1.52, 1.52, 1.52);
    self.tiled = tiled;
    self.curTiledIndex = self.tiled:GetIndex()
    self:SetResourceInformations();
    self:FlushMainCityInfo(tiled);
    if tiled.tiledInfo ~= nil then
        if tiled.tiledInfo.superiorLeagueId ~= 0 then
            self.FloodImage.transform.localPosition = Vector3.New(self.FloodImage.transform.localPosition.x, self.leftParent.localPosition.y + self.leftParent.sizeDelta.y / 2, 0);
            self.FloodImage.gameObject:SetActive(true);
        else
            self.FloodImage.gameObject:SetActive(false)
        end
    else
        self.FloodImage.gameObject:SetActive(false)
    end
    self:Diplomacy(tiled)

    -- 返回当当前UIPublicClass,设置同盟标记详情的位置
    ClickService:Instance():GetCurClickUI(Vector3.New(self.leftParent.transform.localPosition.x, self.leftParent.localPosition.y  - CommonService:Instance():GetChildCount(self.leftParent.transform) * 22-113, 0))
end



function UIWildernes:OnClickMailBtn()
    CommonService:Instance():RequestPlayerInfo(self.tiled.tiledInfo.ownerId);
end

-- 显示领地资源信息
function UIWildernes:SetResourceInformations()
    self.LeagueImage.gameObject:SetActive(false);
    self.PossessorImage.gameObject:SetActive(false);
    self.mailImage.gameObject:SetActive(false);
    -- 占领该城区者同盟、名字
    if self.tiled.tiledInfo ~= nil then
        -- print(self.tiled.tiledInfo.ownerId)
        if self.tiled.tiledInfo.ownerId ~= 0 then
            print("地块ownerid == " .. self.tiled.tiledInfo.ownerId)
            self.LeagueImage.gameObject:SetActive(true);
            self.PossessorImage.gameObject:SetActive(true);
            self.mailImage.gameObject:SetActive(true);
            if self.tiled.tiledInfo.leagueId ~= 0 then
                self.leagueName.text = "<color=#71b448>" .. self.tiled.tiledInfo.leagueName .. "</color>";
            else
                self.leagueName.text = "<color=#BF3636FF>在野</color>";
            end
            self.playerName.text = self.tiled.tiledInfo.ownerName;
        else
            self.LeagueImage.gameObject:SetActive(false);
            self.PossessorImage.gameObject:SetActive(false);
            self.mailImage.gameObject:SetActive(false);
        end
    end
    -- 刷资源
    local resource = self.tiled:GetResource();
    if self.tiled._building ~= nil then
        resource = MapService:Instance():GetBuildingDataTile(self.tiled)
    end
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
    if self.tiled._building ~= nil then
        resource = MapService:Instance():GetBuildingDataTile(self.tiled)
    end
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
end


function UIWildernes:Diplomacy(tiled)
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




-- 部队出征
function UIWildernes:OnClickCampaignerBtn()
    if self:CheckTiledIsForBattle() == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.HaveNoBorderTiled);
        return
    end
    self.gameObject:SetActive(false)

    if PlayerService:Instance():IsHaveCanSendArmy() == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 144);
        return;
    end

    local param = { }
    param.troopsNum = 1
    param.troopType = SelfLand.battle
    param.tiledIndex = self.curTiledIndex;
    UIService:Instance():ShowUI(UIType.UISelfLandFunction, param);
    UIService:Instance():HideUI(UIType.UIGameMainView)
end

-- 标记点击事件
function UIWildernes:OnClickSignBtn()
    local resource = self.tiled:GetResource();
    local name = "土地Lv" .. resource.TileLv;
    local msg = require("MessageCommon/Msg/C2L/Player/RequestMarkTiled").new();
    msg:SetMessageId(C2L_Player.RequestMarkTiled);
    msg.name = name
    msg.tiledIndex = self.curTiledIndex;
    NetService:Instance():SendMessage(msg);
    self.gameObject:SetActive(false);
    MapService:Instance():HideTiled()
end

-- 取消标记点击事件
function UIWildernes:OnClickcanceSignBtn()
    local msg = require("MessageCommon/Msg/C2L/Player/RequestUndoMarker").new();
    msg:SetMessageId(C2L_Player.RequestUndoMarker);
    msg.tiledIndex = self.curTiledIndex;
    NetService:Instance():SendMessage(msg);
    self.gameObject:SetActive(false);
    MapService:Instance():HideTiled()

end
-- 是否已标记 
function UIWildernes:FlushMainCityInfo(tiled)
    local isMarked = UIService:Instance():IsMarked(tiled);
    if isMarked then
        self.cancelSign.gameObject:SetActive(true);
        self.signImage.gameObject:SetActive(false);
    else
        self.cancelSign.gameObject:SetActive(false);
        self.signImage.gameObject:SetActive(true);
    end
end

-- 检测是否有相邻地块
function UIWildernes:CheckTiledIsForBattle()
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

return UIWildernes;
