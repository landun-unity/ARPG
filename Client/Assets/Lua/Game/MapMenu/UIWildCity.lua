--[[
    野城
--]]

local UIBase = require("Game/UI/UIBase");
local UIWildCity = class("UIWildCity", UIBase);
local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");
require("Game/Table/InitTable");
require("Game/Table/model/DataText")
-- 构造函数
function UIWildCity:ctor()
    UIWildCity.super.ctor(self);

    -- self.deImage = nil;
    self.woodNum = nil;
    self.stoneNum = nil;
    self.ironNum = nil;
    self.foodNum = nil;
    self.destroy = nil;
    self.siege = nil;
    self.numTable = { };
    self.grideNum = nil;
    -- 部队出征按钮
    self.campaigner = nil


    -- 同盟攻城
    self.helpBtn = nil;
    self.downPart = nil;
    self.leagueNameDown = nil;
    self.leaderName = nil;
    self.killName1 = nil;
    self.killNum1 = nil;
    self.killName2 = nil;
    self.killNum2 = nil;
    self.killName3 = nil;
    self.killNum3 = nil;
    self.cityName1 = nil;
    self.cityName2 = nil;
    self.cityName3 = nil;
    self.cityNum1 = nil;
    self.cityNum2 = nil;
    self.cityNum3 = nil;

    -- title
    self.title = nil;

    self.signImage = nil;
    self.signImage1 = nil;

    -- self.AvoidWarImage = nil;
    -- self.AvoidWarText = nil;
    -- self.gradeText = nil;
    -- self.defendersText = nil;
    self.tiled = nil;
    -- 当前点击格子
    self.curTiledIndex = nil

    -- 左侧
    self.avoidWarTimeText = nil;
    self.wood = nil;
    self.iron = nil;
    self.stone = nil;
    self.food = nil;
    self.occupiedTip = nil;
    self.explainTextParent = nil;
    self.explainText = nil;
    self.defendingText = nil;
    self.leagueName = nil;
    self.mwood = nil;
    self.mstone = nil;
    self.miron = nil;
    self.mfood = nil;
    self.LeagueImage = nil;
    self._avoidWarImage = nil;
    self.DeImage = nil;
    self.diplomacy = nil;
    self.amity = nil;
    self.NPCRecoverTime = nil;
        -- NPC守军恢复时间
    self._npcRecoverTimePanel = nil
    self._npcRecoverTime = nil

    self.OneLevelOfLandImage  =nil;
end

-- 初始化
function UIWildCity:DoDataExchange()

    -- 标题
    self.woodNum = self:RegisterController(UnityEngine.UI.Text, "BottomImg/resourceWoodImg/numText");
    self.stoneNum = self:RegisterController(UnityEngine.UI.Text, "BottomImg/resourceStoneImg/numText");
    self.ironNum = self:RegisterController(UnityEngine.UI.Text, "BottomImg/resourceIronImg/numText");
    self.foodNum = self:RegisterController(UnityEngine.UI.Text, "BottomImg/resourceFoodImg/numText");
    self.destroy = self:RegisterController(UnityEngine.UI.Text, "BottomImg/FirstImg/moneyNum");
    self.siege = self:RegisterController(UnityEngine.UI.Text, "BottomImg/SendImg/moneyNum");
    -- self.grideNum = self:RegisterController(UnityEngine.UI.Text, "FortName/landGrade/Num");

    self.diplomacy = self:RegisterController(UnityEngine.UI.Image,"OneLevelOfLandImage/LeagueImage/diplomacy")
    self.amity = self:RegisterController(UnityEngine.UI.Image,"OneLevelOfLandImage/LeagueImage/amity")
    self.OneLevelOfLandImage = self:RegisterController(UnityEngine.Transform,"OneLevelOfLandImage")
    --- [[
    -- 同盟攻城
    self.BottomImg = self:RegisterController(UnityEngine.Transform, "BottomImg");
    self.helpBtn = self:RegisterController(UnityEngine.UI.Button, "BottomImg/HelpBtn");
    self.downPart = self:RegisterController(UnityEngine.Transform, "BottomImg1");
    self.leagueNameDown = self:RegisterController(UnityEngine.UI.Text, "BottomImg1/Text/leagueName");
    self.leaderName = self:RegisterController(UnityEngine.UI.Text, "BottomImg1/Text (1)/leaderName");
    self.killName1 = self:RegisterController(UnityEngine.UI.Text, "BottomImg1/killName1");
    self.killNum1 = self:RegisterController(UnityEngine.UI.Text, "BottomImg1/killName1/killNum1");
    self.killName2 = self:RegisterController(UnityEngine.UI.Text, "BottomImg1/killName2");
    self.killNum2 = self:RegisterController(UnityEngine.UI.Text, "BottomImg1/killName2/killNum2");
    self.killName3 = self:RegisterController(UnityEngine.UI.Text, "BottomImg1/killName3");
    self.killNum3 = self:RegisterController(UnityEngine.UI.Text, "BottomImg1/killName3/killNum3");


    self.cityName1 = self:RegisterController(UnityEngine.UI.Text, "BottomImg1/cityName1");
    self.cityName2 = self:RegisterController(UnityEngine.UI.Text, "BottomImg1/cityName2");
    self.cityName3 = self:RegisterController(UnityEngine.UI.Text, "BottomImg1/cityName3");
    self.cityNum1 = self:RegisterController(UnityEngine.UI.Text, "BottomImg1/cityName1/killNum1");
    self.cityNum2 = self:RegisterController(UnityEngine.UI.Text, "BottomImg1/cityName2/killNum2");
    self.cityNum3 = self:RegisterController(UnityEngine.UI.Text, "BottomImg1/cityName3/killNum3");
    -- ]]

    --self.campaigner = self:RegisterController(UnityEngine.UI.Button, "campaigner")

    self.signImage = self:RegisterController(UnityEngine.UI.Button, "signImage")
    self.signImage1 = self:RegisterController(UnityEngine.UI.Button, "signImage1")
    -- self.AvoidWarImage = self:RegisterController(UnityEngine.UI.Image,"AvoidWarImage");
    -- self.AvoidWarText = self:RegisterController(UnityEngine.UI.Text,"AvoidWarImage/AvoidWarTimeText")
    -- self.gradeText = self:RegisterController(UnityEngine.UI.Text,"DeImage/defenders/gradeText")
    -- self.defendersText = self:RegisterController(UnityEngine.UI.Text,"DeImage/defenders/Text")

    -- 左侧
    self.avoidWarTimeText = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/AvoidWarImage/AvoidWarTimeText");
    self.wood = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/WoodImage/firewoodTime");
    self.iron = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/IronImage/fireironTime");
    self.stone = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/StoneImage/firestoneTime");
    self.food = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/FoodImage/firefoodTime")
    self.occupiedTip = self:RegisterController(UnityEngine.Transform, "OneLevelOfLandImage/OccupiedTip");
    self.explainTextParent = self:RegisterController(UnityEngine.Transform, "OneLevelOfLandImage/ExplainTextParent");
    self.explainText = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/ExplainTextParent/ExplainText");
    self.defendingText = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/DeImage/LV");
    self.leagueName = self:RegisterController(UnityEngine.UI.Text, "OneLevelOfLandImage/LeagueImage/LeagueNameText");
    self.mwood = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/WoodImage");
    self.mstone = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/StoneImage");
    self.miron = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/IronImage");
    self.mfood = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/FoodImage");
    self.LeagueImage = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/LeagueImage");
    self._avoidWarImage = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/AvoidWarImage");
    self.DeImage = self:RegisterController(UnityEngine.UI.Image, "OneLevelOfLandImage/DeImage")
        -- npc守军恢复时间
    self._npcRecoverTimePanel = self:RegisterController(UnityEngine.Transform,"OneLevelOfLandImage/NPCRecoverTime")
    self._npcRecoverTime = self:RegisterController(UnityEngine.UI.Text,"OneLevelOfLandImage/NPCRecoverTime/RecoverTime")
end

-- 注册控件点击事件
function UIWildCity:DoEventAdd()
    --self:AddListener(self.campaigner, self.OnClickCampaignerBtn);
    self:AddListener(self.helpBtn, self.OnClickhelpBtn);
    self:AddListener(self.signImage, self.OnClickSignBtn);
    self:AddListener(self.signImage1, self.OnClickDeleteSignBtn);
end


function UIWildCity:OnClickhelpBtn()

    LogManager:Instance():Log("UIWildCity:OnClickhelpBtn");
    UIService:Instance():ShowUI(UIType.UIWildCityRewardsExplain);
end

-- 点击标记
function UIWildCity:OnClickSignBtn()
    local name = nil;
    if self.tiled ~= nil then
        if self.tiled._building ~= nil then
            name = self.tiled._building._dataInfo.Name
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
function UIWildCity:OnClickDeleteSignBtn()
    local msg = require("MessageCommon/Msg/C2L/Player/RequestUndoMarker").new();
    msg:SetMessageId(C2L_Player.RequestUndoMarker);
    msg.tiledIndex = self.curTiledIndex;
    NetService:Instance():SendMessage(msg);
    self.gameObject:SetActive(false);
    MapService:Instance():HideTiled()
end

-- 是否已标记 
function UIWildCity:FlushMainCityInfo(tiled)
    local isMarked = UIService:Instance():IsMarked(tiled);
    if isMarked then
        self.signImage1.gameObject:SetActive(true);
        self.signImage.gameObject:SetActive(false);
    else
        self.signImage1.gameObject:SetActive(false);
        self.signImage.gameObject:SetActive(true);
    end
end

function UIWildCity:IsPossessLeague()
    local leagueId = PlayerService:Instance():GetLeagueId();
    if leagueId == 0 then

    end
end

-- 加载资源
function UIWildCity:ShowTiled(tiled)
    self.gameObject.transform.localScale = Vector3.New(1.52, 1.52, 1.52);
    self:FlushMainCityInfo(tiled)
    self.tiled = tiled;
    self.curTiledIndex = tiled:GetIndex()

    self:SetLeftInformations();

    local resource = MapService:Instance():GetBuildingDataTile(tiled)
    local dataBuilding = tiled._building._dataInfo
    local wood = dataBuilding.Wood;
    local stone = dataBuilding.Stone;
    local iron = dataBuilding.Iron;
    local food = dataBuilding.Food;
    local thewoodNum = resource.FirstSeizedWood;
    local thestoneNum = resource.FirstSeizedStone;
    local theironNum = resource.FirstSeizedIronOre;
    local thefoodNum = resource.FirstSeizedFood;
    local thedestroy = resource.AnnihilationRankGold;
    local thesiege = resource.DemolitionRankGold;
    self.woodNum.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = thewoodNum;
    self.stoneNum.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = thestoneNum;
    self.ironNum.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = theironNum;
    self.foodNum.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = thefoodNum;
    self.destroy.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = thedestroy;
    self.siege.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = thesiege;
    self:Diplomacy(tiled)
    self:RefreshNpcRecoverTime()
end

-- 刷新守军恢复时间
function UIWildCity:RefreshNpcRecoverTime()
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

      ClickService:Instance():GetCurClickUI(Vector3.New(self.OneLevelOfLandImage.transform.localPosition.x, self.OneLevelOfLandImage.transform.localPosition.y  - CommonService:Instance():GetChildCount(self.OneLevelOfLandImage.transform) * 22-113, 0))
end


-- 显示左侧所有的信息
function UIWildCity:SetLeftInformations()
    -- 首占同盟名字、tips、杀敌（攻城）前3榜
    local info = LeagueService:Instance():GetWildPlayerInfo()
    -- if info == nil then
    --     return
    -- end
    if info.firstOccupyLeagueId ~= 0 then
        self.BottomImg.gameObject:SetActive(false)
        self.downPart.gameObject:SetActive(true)
        self.occupiedTip.gameObject:SetActive(false);
        self.LeagueImage.gameObject:SetActive(true);
        if info.curOccupyLeagueId == 0 then
            self.occupiedTip.gameObject:SetActive(true);
            self.LeagueImage.gameObject:SetActive(false);
        else
            self.occupiedTip.gameObject:SetActive(false);
            self.LeagueImage.gameObject:SetActive(true);
        end
        self.leagueName.text = "<color=#71b448>" .. info.curOccupyLeagueName .. "</color>";
        self.leagueNameDown.text =  info.firstOccupyLeagueName
        if info.firstOccupyLeagueName == "" then
            self.leagueNameDown.text = "<color=#71b448>" .. DataText[1001].TextContent .. "</color>";
        end
        self.leaderName.text = info.firstOccupyLeagueLeaderName;
        if info.topThreeKillPlayerList:Get(1) ~= nil then
            self.killNum1.text = "灭敌 " .. info.topThreeKillPlayerList:Get(1).killValue;
            self.killName1.text = "1 " .. info.topThreeKillPlayerList:Get(1).name;
            self.cityName1.text = "1 " .. info.topThreeSiegePlayerList:Get(1).name;
            self.cityNum1.text = "攻城 " .. info.topThreeSiegePlayerList:Get(1).siegeValue;
        end
        if info.topThreeKillPlayerList:Get(2) ~= nil then
            self.killName2.text = "2 " .. info.topThreeKillPlayerList:Get(2).name;
            self.killNum2.text = "灭敌 " .. info.topThreeKillPlayerList:Get(2).killValue;
            self.cityName2.text = "2 " .. info.topThreeSiegePlayerList:Get(2).name;
            self.cityNum2.text = "攻城 " .. info.topThreeSiegePlayerList:Get(2).siegeValue;
        end
        if info.topThreeKillPlayerList:Get(3) ~= nil then
            self.killName3.text = "3 " .. info.topThreeKillPlayerList:Get(3).name;
            self.killNum3.text = "灭敌 " .. info.topThreeKillPlayerList:Get(3).killValue;
            self.cityName3.text = "3 " .. info.topThreeSiegePlayerList:Get(3).name;
            self.cityNum3.text = "攻城 " .. info.topThreeSiegePlayerList:Get(3).siegeValue;
        end
    else
        self.LeagueImage.gameObject:SetActive(false);
        self.downPart.gameObject:SetActive(false)
        self.BottomImg.gameObject:SetActive(true)
        self.occupiedTip.gameObject:SetActive(true);
    end
    -- 免战时间
    self:_ArmyStateRequest();
    -- 资源信息
    self:SetResourceInformations();
end


function UIWildCity:Diplomacy(tiled)
    self.amity.gameObject:SetActive(false)
    self.diplomacy.gameObject:SetActive(false)
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



-- 野城资源信息
function UIWildCity:SetResourceInformations()
    local resource = MapService:Instance():GetBuildingDataTile(self.tiled)
    local dataBuilding = self.tiled._building._dataInfo
    local perWood = dataBuilding.Wood;
    local perStone = dataBuilding.Stone;
    local perIron = dataBuilding.Iron;
    local perFood = dataBuilding.Food;
    if perWood ~= 0 then
        self.mwood.gameObject:SetActive(true);
        self.wood.text = "+" .. perWood .. "/小时";
    else
        self.mwood.gameObject:SetActive(false);
    end
    if perStone ~= 0 then
        self.mstone.gameObject:SetActive(true);
        self.stone.text = "+" .. perStone .. "/小时";
    else
        self.mstone.gameObject:SetActive(false);
    end
    if perIron ~= 0 then
        self.miron.gameObject:SetActive(true);
        self.iron.text = "+" .. perIron .. "/小时";
    else
        self.miron.gameObject:SetActive(false);
    end
    if perFood ~= 0 then
        self.mfood.gameObject:SetActive(true);
        self.food.text = "+" .. perFood .. "/小时";
    else
        self.mfood.gameObject:SetActive(false);
    end
    -- 守军强度
    --LogManager:Instance():Log("守军   :  " .. resource.NPCTroopLv .. " 土地等级：" .. resource.TileLv);
    self.defendingText.text = "Lv." .. resource.NPCTroopLv .. " " .. resource.NPCTroopNum .. "/" .. resource.NPCTroopNum;
    self.explainTextParent.gameObject:SetActive(false);
    -- self.explainTextParent.gameObject:SetActive(true);
end

-- 免战时间显示
function UIWildCity:_ArmyStateRequest()
    if self.tiled.tiledInfo == nil then
        return;
    end

    local freeWarEndTime = self.tiled.tiledInfo.avoidWarTime;
    -- print("免战时间 == " .. freeWarEndTime)
    -- print(freeWarEndTime - curTime)
    -- print(self.tiled.tiledInfo.leagueId)
    -- print(PlayerService:Instance():GetLeagueId())
    local curTime = PlayerService:Instance():GetLocalTime();
    if freeWarEndTime - curTime > 0 and self.tiled.tiledInfo.leagueId == PlayerService:Instance():GetLeagueId() then
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

-- -- 部队出征
-- function UIWildCity:OnClickCampaignerBtn()
--     print("部队出征")
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
function UIWildCity:CheckTiledIsForBattle()
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



return UIWildCity;