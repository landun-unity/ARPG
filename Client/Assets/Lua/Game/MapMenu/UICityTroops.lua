--[[城池预制]]--
local UIBase= require("Game/UI/UIBase");
local UICityTroops=class("UICityTroops",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
local MapLoad = require("Game/Map/MapLoad");

--构造函数
function UICityTroops:ctor()
    UICityTroops.super.ctor(self);
    self._grid = nil;
    -- 本建筑
    self._building = nil;
    -- 部队的最大数量
	 self.Max_Army_Count = 5;
    -- 主城或要塞名字
    self._cityName = nil;
    -- 图标
    self._cityIcon = nil;
    -- 主城或要塞坐标
    self._cityIndex = nil;
    -- 兵力
    self._troops = nil;
    -- 耐久
    self._durable = nil;
    -- 未配置文字提示
    self._noArmyTipsTextList = {};
    -- 卡牌ui是否已创建
    self._isCardsCreated = false;
    -- 部队点击按钮
    self._emptyTroopsBtnList = {};
    -- 卡牌ui类 index从1开始
    self._allCasrdsUiClassList = {};
    -- 可配置多少部队
    self.CanCreateArmyCount = 0;
    -- 父物体脚本
    self._parent = nil;
end

function UICityTroops:DoDataExchange()
	self._grid = self:RegisterController(UnityEngine.Transform,"armyCard/Grid1");
	self._cityName = self:RegisterController(UnityEngine.UI.Text,"armyInformation/cityName");
    self._cityIcon = self:RegisterController(UnityEngine.UI.Image,"armyInformation/BarracksImage");
	self._cityIndex = self:RegisterController(UnityEngine.UI.Text,"armyInformation/cityIndex/Text");
	self._troops = self:RegisterController(UnityEngine.UI.Text,"armyInformation/troops/troopsText");
	self._durable = self:RegisterController(UnityEngine.UI.Text,"armyInformation/durable/durableText");
    for i = 1, 5 do
        self._emptyTroopsBtnList[i] = self:RegisterController(UnityEngine.UI.Button,"armyCard/Grid1/EmptyTroops" .. i .. "/clickBtnPanel" .. i);
        self._noArmyTipsTextList[i] = self:RegisterController(UnityEngine.UI.Text,"armyCard/Grid1/EmptyTroops" .. i .. "/BottomImage/NotOpenedImage/Text");
    end
end

--注册点击事件
function UICityTroops:DoEventAdd()   
    self:AddListener(self.transform:GetComponent(typeof(UnityEngine.UI.Button)),self.OnCilckMySelf);
    for i = 1, 5 do
        self.lua_behaviour:AddClick(self._emptyTroopsBtnList[i].gameObject, function(...)
            return self.OnClickEmptyTroops(self, i, ...);
        end);
    end
end

-- 打开刷新界面信息
function UICityTroops:OnRefreshUIData(parent, building)
    if parent == nil or building == nil then
        return;
    end
    self._parent = parent;
    self._building = building;
    self:SetNameIndex();
    self:SetAllTroopsCount();
	self:SetDuration();
    self:CreateCards();
end

-- 名称坐标
function UICityTroops:SetNameIndex()
    self._cityName.text = self._building._name;
    if self._building._dataInfo.Type == BuildingType.MainCity then
        self._cityIcon.sprite = GameResFactory.Instance():GetResSprite("MainCity");
    elseif self._building._dataInfo.Type == BuildingType.SubCity then
        self._cityIcon.sprite = GameResFactory.Instance():GetResSprite("PointsCity1");
    else
        self._cityIcon.sprite = GameResFactory.Instance():GetResSprite("fortress1");
    end
    
	local tiledId = self._building._tiledId;
    local x = math.modf(tiledId / MapLoad:GetWidth());
    local y = math.modf(tiledId  - x * MapLoad:GetWidth());
    self._cityIndex.text = string.format("%d,%d", x, y);
end

--总兵力刷新
function UICityTroops:SetAllTroopsCount()
    if self._building._dataInfo.Type == BuildingType.PlayerFort then
        local fort = BuildingService:Instance():GetBuilding(self._building._id)
        local sumNum = 0;
        local armyCount = fort:GetArmyInfoCounts();
        for i = 1, armyCount do
            local armyInfo = fort:GetArmyInfos(i);
                if armyInfo ~= nil then
                    if armyInfo:GetArmyState() == ArmyState.TransformArrive then 
                        local troopNum = armyInfo:GetAllSoldierCount();
                        sumNum = sumNum + troopNum;
                    end
                end
        end
        self._troops.text = sumNum;
    elseif self._building._dataInfo.Type == BuildingType.WildFort or self._building._dataInfo.Type == BuildingType.WildGarrisonBuilding then
        local wildFort = BuildingService:Instance():GetBuilding(self._building._id)
        local sumNum = 0;
        local armyCount = wildFort:GetWildFortArmyInfoCounts();
        for i = 1, armyCount do
            local armyInfo = wildFort:GetWildFortArmyInfos(i);
            if armyInfo ~= nil then
                if armyInfo:GetArmyState() == ArmyState.TransformArrive then 
                    local troopNum = armyInfo:GetAllSoldierCount();
                    sumNum = sumNum + troopNum;
                end
            end
        end
        self._troops.text = sumNum;
    else
        self._troops.text = self._building:GetAllInCityArmySoldiers();
    end
end

--耐久刷新
function UICityTroops:SetDuration()
--    local curDura = PlayerService:Instance():GetTiledDurableByIndex(self._building._tiledId).tiledCurDurable;
--    local maxDura = PlayerService:Instance():GetTiledDurableByIndex(self._building._tiledId).tiledMaxDurable;
--    local tiledInfo = PlayerService:Instance():GetTiledInfoByIndex(self._building._tiledId);
--    if tiledInfo ~= nil then
--        self._durable.text = string.format("%d/%d", tiledInfo.curDurableVal, tiledInfo.maxDurableVal);
--    end
    local curDura = MapService:Instance():GetMyTiledDura(self._building._tiledId);
    local maxDura = MapService:Instance():GetMyTiledMaxDura(self._building._tiledId);
    self._durable.text = string.format("%d/%d", curDura, maxDura);
end

-- 刷新卡牌信息
function UICityTroops:CreateCards()
    if self._isCardsCreated == false then
        for i = 1, self.Max_Army_Count do
            local uiSmallHeroCard = require("Game/Hero/HeroCardPart/UISmallHeroCard").new();
            GameResFactory.Instance():GetUIPrefab("UIPrefab/GeneralSmallHeroCard", self._grid:FindChild("EmptyTroops" .. i .. "/Panel" .. i), uiSmallHeroCard, function (go)
                uiSmallHeroCard.gameObject.name = "UISmallHeroCard" .. i;
                uiSmallHeroCard:Init();
                self._allCasrdsUiClassList[i] = uiSmallHeroCard;
                if i == self.Max_Army_Count then
                    self._isCardsCreated = true;
                    self:SetCards();
                end
	        end);
        end        
    else
        self:SetCards();
    end
end

function UICityTroops:SetCards()
    if self._building._dataInfo.Type == BuildingType.MainCity or self._building._dataInfo.Type == BuildingType.SubCity then
        self:SetMainCityCard();
    elseif self._building._dataInfo.Type == BuildingType.PlayerFort then
        self:SetFortCard();
    elseif self._building._dataInfo.Type == BuildingType.WildFort or self._building._dataInfo.Type == BuildingType.WildGarrisonBuilding then
        self:SetWildFortCard();
    end
end

function UICityTroops:SetMainCityCard()
    self.CanCreateArmyCount = FacilityService:Instance():GetCityPropertyByFacilityProperty(self._building._id, FacilityProperty.ArmyCount);
    for i = 1, self.Max_Army_Count do
        if i <= self.CanCreateArmyCount then
            self._grid:FindChild("EmptyTroops" .. i).gameObject:SetActive(true);
            self._grid:FindChild("EmptyTroops" .. i .. "/Panel").gameObject:SetActive(false);
            local tempArmy = ArmyService:Instance():GetArmyInCity(self._building._id, i);
            if tempArmy ~= nil then
                local back = tempArmy:GetCard(ArmySlotType.Back);
                if back ~= nil then
                    local isGray = false;
                    if tempArmy.curBuildingId ~= self._building._id then
                        isGray = true;
                    end
                    self._allCasrdsUiClassList[i]:SetTroopUIType("City", i - 1, self._building._id);
                    self._allCasrdsUiClassList[i]:SetUISmallHeroCardMessage(back, isGray);
                    self._allCasrdsUiClassList[i]:AllSoldierCount(tempArmy);
                    local stateStr = self:GetArmyStateStr(tempArmy);
                    self._allCasrdsUiClassList[i]:SetArmyStateText(stateStr);
                    self._grid:FindChild("EmptyTroops" .. i .. "/Panel" .. i).gameObject:SetActive(true);
                else
                    self._grid:FindChild("EmptyTroops" .. i .. "/Panel" .. i).gameObject:SetActive(false);
                    self._noArmyTipsTextList[i].text = "未配置";
                end
            else
                self._grid:FindChild("EmptyTroops" .. i .. "/Panel" .. i).gameObject:SetActive(false);
                self._noArmyTipsTextList[i].text = "未配置";
            end
        elseif i == self.CanCreateArmyCount + 1 then
            self._grid:FindChild("EmptyTroops" .. i).gameObject:SetActive(true);
            self._grid:FindChild("EmptyTroops" .. i .. "/Panel" .. i).gameObject:SetActive(false);
            self._grid:FindChild("EmptyTroops" .. i .. "/Panel").gameObject:SetActive(true);
            self._noArmyTipsTextList[i].text = "";
        else
            self._grid:FindChild("EmptyTroops" .. i).gameObject:SetActive(false);
        end
    end
end

function UICityTroops:SetFortCard()
    self.CanCreateArmyCount = self._building:GetFortGrade();
    for i = 1, self.Max_Army_Count do
        if i <= self.CanCreateArmyCount then
            self._grid:FindChild("EmptyTroops" .. i).gameObject:SetActive(true);
            self._grid:FindChild("EmptyTroops" .. i .. "/Panel").gameObject:SetActive(false);
            local tempArmy = self._building:GetArmyInfos(i);
            if tempArmy ~= nil then
                local back = tempArmy:GetCard(ArmySlotType.Back);
                if back ~= nil then
                    self._allCasrdsUiClassList[i]:SetTroopUIType("fort",tempArmy.spawnSlotIndex - 1, self._building._id);
                    self._allCasrdsUiClassList[i]:SetUISmallHeroCardMessage(back, false);
                    self._allCasrdsUiClassList[i]:AllSoldierCount(tempArmy);
                    local stateStr = self:GetArmyStateStr(tempArmy);
                    self._allCasrdsUiClassList[i]:SetArmyStateText(stateStr);
                    self._grid:FindChild("EmptyTroops" .. i .. "/Panel" .. i).gameObject:SetActive(true);
                else
                    self._grid:FindChild("EmptyTroops" .. i .. "/Panel" .. i).gameObject:SetActive(false);
                    self._noArmyTipsTextList[i].text = "无部队";
                end
            else
                self._grid:FindChild("EmptyTroops" .. i .. "/Panel" .. i).gameObject:SetActive(false);
                self._noArmyTipsTextList[i].text = "无部队";
            end
        else
            self._grid:FindChild("EmptyTroops" .. i).gameObject:SetActive(false);
        end
    end
end

function UICityTroops:SetWildFortCard()
    self.CanCreateArmyCount = self.Max_Army_Count;
    for i = 1, self.Max_Army_Count do
        self._grid:FindChild("EmptyTroops" .. i).gameObject:SetActive(true);
        self._grid:FindChild("EmptyTroops" .. i .. "/Panel").gameObject:SetActive(false);
        local tempArmy = self._building:GetWildFortArmyInfos(i);
        if tempArmy ~= nil then
            local back = tempArmy:GetCard(ArmySlotType.Back);
            if back ~= nil then
                self._allCasrdsUiClassList[i]:SetTroopUIType("fort",tempArmy.spawnSlotIndex - 1, self._building._id);
                self._allCasrdsUiClassList[i]:SetUISmallHeroCardMessage(back, false);
                self._allCasrdsUiClassList[i]:AllSoldierCount(tempArmy);
                local stateStr = self:GetArmyStateStr(tempArmy);
                self._allCasrdsUiClassList[i]:SetArmyStateText(stateStr);
                self._grid:FindChild("EmptyTroops" .. i .. "/Panel" .. i).gameObject:SetActive(true);
            else
                self._grid:FindChild("EmptyTroops" .. i .. "/Panel" .. i).gameObject:SetActive(false);
                self._noArmyTipsTextList[i].text = "无部队";
            end
        else
            self._grid:FindChild("EmptyTroops" .. i .. "/Panel" .. i).gameObject:SetActive(false);
            self._noArmyTipsTextList[i].text = "无部队";
        end
    end
end

function UICityTroops:OnCilckMySelf()
    if self._building == nil then
        return;
    end
    local pos = MapService:Instance():GetTiledPositionByIndex(self._building._tiledId);
    MapService:Instance():ScanTiledByUGUIPositionNotDelay(pos.x, pos.y - 120);
    --MapService:Instance():SetCallBack(self._building._tiledId)
    MapService:Instance():ChangeBiggerView();
    --MapService:Instance():ClickCityCallBack();
    local tiled = MapService:Instance()._logic._tiledManage:GetTiledByIndex(self._building._tiledId);
    MapService:Instance():EnterOperator(OperatorType.ZoomOut);
    local param = {};
    param[0] = self._building
    UIService:Instance():ShowUI(UIType.UIMainCity, param);
    UIService:Instance():HideUI(UIType.UIGameMainView);
    UIService:Instance():HideUI(UIType.CityObj);
end

function UICityTroops:OnClickEmptyTroops(index)
    if index < 1 or index > 5 then
        return;
    end

    if index > self.CanCreateArmyCount then
        self:OnCilckMySelf();
        return;
    end

    if self._building._dataInfo.Type == BuildingType.MainCity or self._building._dataInfo.Type == BuildingType.SubCity then
        local armyInfo = ArmyService:Instance():GetArmyInCity(self._building._id, index);
        if armyInfo.curBuildingId == 0 or armyInfo.curBuildingId == self._building._id then
            --print("在一个城市" .. armyInfo.curBuildingId .. "  " .. self._building._id);
            local param = {};
            param[0] = true;
            param[1] = self._building._id;
            param[2] = index - 1;
            param[3] = UIType.CityObj;
            UIService:Instance():ShowUI(UIType.ArmyFunctionUI,param);
        else
            --print("不在一个城市" .. armyInfo.curBuildingId .. "  " .. self._building._id);
            if self._parent ~= nil then
                self._parent:MoveToPositionAndCallBack(armyInfo.curBuildingId, function()
                    local param = {};
                    param[0] = false;
                    param[1] = armyInfo.spawnBuildng;
                    param[2] = armyInfo.spawnSlotIndex - 1;
                    param[3] = UIType.CityObj;
                    UIService:Instance():ShowUI(UIType.ArmyFunctionUI,param);
                end);
            end
        end
    elseif self._building._dataInfo.Type == BuildingType.PlayerFort then
        local fort = BuildingService:Instance():GetBuilding(self._building._id);
        local haveArmyCount = fort:GetArmyInfoCounts();
        if index > haveArmyCount then
            self:OnCilckMySelf();
            return;
        end

        local armyInfo = fort:GetArmyInfos(index);
        if armyInfo == nil then
            return;
        end

        local param = {}
        param[0] = false;
        param[1] = armyInfo.spawnBuildng;
        param[2] = armyInfo.spawnSlotIndex - 1;
        param[3] = UIType.CityObj;
        UIService:Instance():ShowUI(UIType.ArmyFunctionUI,param);
    elseif self._building._dataInfo.Type == BuildingType.WildFort or self._building._dataInfo.Type == BuildingType.WildGarrisonBuilding then
        local fort = BuildingService:Instance():GetBuilding(self._building._id);
        local haveArmyCount = fort:GetWildFortArmyInfoCounts();
        if index > haveArmyCount then
            self:OnCilckMySelf();
            return;
        end

        local armyInfo = fort:GetWildFortArmyInfos(index);
        if armyInfo == nil then
            return;
        end

        local param = {}
        param[0] = false;
        param[1] = armyInfo.spawnBuildng;
        param[2] = armyInfo.spawnSlotIndex - 1;
        param[3] = UIType.CityObj;
        UIService:Instance():ShowUI(UIType.ArmyFunctionUI,param);
    end
end

-- 获取部队显示状态字符串
function UICityTroops:GetArmyStateStr(armyInfo)
    if self._building._dataInfo.Type == BuildingType.MainCity or self._building._dataInfo.Type == BuildingType.SubCity then
        if armyInfo.curBuildingId ~= self._building._id then
            return "<color=#808A87>调动</color>";
        -- 二次保护
        elseif armyInfo:GetArmyState() == ArmyState.TransformRoad or armyInfo:GetArmyState() == ArmyState.TransformArrive then
            return "<color=#808A87>调动</color>";
        elseif armyInfo:GetArmyState() == ArmyState.BattleRoad or
        armyInfo:GetArmyState() == ArmyState.BattleIng or
        armyInfo:GetArmyState() == ArmyState.SweepRoad or
        armyInfo:GetArmyState() == ArmyState.SweepIng or
        armyInfo:GetArmyState() == ArmyState.GarrisonRoad or
        armyInfo:GetArmyState() == ArmyState.MitaRoad or
        armyInfo:GetArmyState() == ArmyState.MitaIng or
        armyInfo:GetArmyState() == ArmyState.TrainingRoad or
        armyInfo:GetArmyState() == ArmyState.Training or
        armyInfo:GetArmyState() == ArmyState.RescueRoad or
        armyInfo:GetArmyState() == ArmyState.RescueIng then
            return "<color=#00FF00>行军</color>";
        elseif armyInfo:GetArmyState() == ArmyState.Back then
            return "<color=#4169E1>返回</color>";
        elseif armyInfo:GetArmyState() == ArmyState.GarrisonIng then
            return "<color=#00FF00>驻守</color>";
        elseif armyInfo:IsArmyInConscription() == true then
            return "<color=#C0C0C0>征兵</color>";
        elseif armyInfo:IsArmyIsBadlyHurt() == true then
            return "<color=#FF0000>重伤</color>";
        elseif armyInfo:IsArmyIsTired() == true then
            return "<color=#FF0000>疲劳</color>";
        else
            return "";
        end
    elseif self._building._dataInfo.Type == BuildingType.PlayerFort or self._building._dataInfo.Type == BuildingType.WildFort or self._building._dataInfo.Type == BuildingType.WildGarrisonBuilding then
        if armyInfo:GetArmyState() == ArmyState.BattleRoad or
        armyInfo:GetArmyState() == ArmyState.BattleIng or
        armyInfo:GetArmyState() == ArmyState.SweepRoad or
        armyInfo:GetArmyState() == ArmyState.SweepIng or
        armyInfo:GetArmyState() == ArmyState.GarrisonRoad or
        armyInfo:GetArmyState() == ArmyState.MitaRoad or
        armyInfo:GetArmyState() == ArmyState.MitaIng or
        armyInfo:GetArmyState() == ArmyState.TrainingRoad or
        armyInfo:GetArmyState() == ArmyState.Training or
        armyInfo:GetArmyState() == ArmyState.RescueRoad or
        armyInfo:GetArmyState() == ArmyState.RescueIng or
        armyInfo:GetArmyState() == ArmyState.TransformRoad then
            return "<color=#00FF00>行军</color>";
        elseif armyInfo:GetArmyState() == ArmyState.Back then
            return "<color=#4169E1>返回</color>";
        elseif armyInfo:GetArmyState() == ArmyState.GarrisonIng then
            return "<color=#00FF00>驻守</color>";
        elseif armyInfo:IsArmyInConscription() == true then
            return "<color=#C0C0C0>征兵</color>";
        elseif armyInfo:IsArmyIsBadlyHurt() == true then
            return "<color=#FF0000>重伤</color>";
        elseif armyInfo:IsArmyIsTired() == true then
            return "<color=#FF0000>疲劳</color>";
        elseif armyInfo:GetArmyState() == ArmyState.TransformArrive then
            return "<color=#00FF00>待命</color>";
        else
            return "";
        end
    end
end

return UICityTroops