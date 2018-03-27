--[[
	城
--]]

local PlayerBuilding = require("Game/Build/Subject/PlayerBuilding")
local List = require("common/List")
local Data = require("Game/Table/model/DataConstruction")
local MainCityView = require("Game/Build/Building/MainCityView")
require("Game/Facility/FacilityProperty")
require("Game/Player/CurrencyEnum")
local City = class("City",PlayerBuilding)
local VariationCalc = require("Game/Util/VariationCalc")

--初始化
function City:ctor()
    City.super.ctor(self);

    --所有的显示tiled
    --self._allTiledTable = {};

    --能够扩建次数
    --self._canExpandTimes = 0;

    --已经扩建次数
    --self._expandTimes = 0;

    --格子list
    --self._cityTitleList=List.new();
    
    --外观等级
    self._cityLevel = 0;

    --设施list
    self._allFacility = List.new();

    --所有设施的属性
    self._allFacilityProperty = {};
    
    -- 部队的最大数量
    self.Max_Army_Count = 5;
    -- 部队
    self.allArmyList = {};
    self:InitArmy();   

    self._maxLevelFacilityProperty = {};
    --self:CreatNewCity();

    self.baseConstructQueue = nil;         -- 基础建造队列列表
    self.tempConstructQueue = nil;         -- 临时建造队列列表
     
    self.baseConstructQueueMax = 0;        -- 基础建造队列上限      
    self.tempConstructQueueMax = 0;        -- 临时建造队列上限
end

-- 初始化部队
function City:InitArmy()
    -- print("初始化部队！！！！！！！！！！！！！！！！！！！！");
    for i = 1,self.Max_Army_Count do
        self.allArmyList[i] = require("Game/Army/ArmyInfo").new();
        self.allArmyList[i].spawnSlotIndex = i;
    end
end

function City:SetCityLevel(value)
    if value == nil then
        return;
    end

    self._cityLevel = value;
end

function City:GetCityLevel()
    return self._cityLevel;
end

-- 从1开始的
function City:GetArmyInfo(index)
    if nil == index then
        return nil;
    end
    if index < 1 or index > self.Max_Army_Count then
        return nil;
    end
    return self.allArmyList[index];
end

--设置Id
function City:SetId(id)
	self._id = id;
    for i = 1,self.Max_Army_Count do
        self.allArmyList[i].spawnBuildng = id;
    end
end

function City:InitCityProperty()
    local count = 0;
    for k,v in pairs(FacilityProperty) do
        count = count + 1;
    end
    
    for i=1, count do
         self._allFacilityProperty[i] = 0;
    end

    self._allFacility:ForEach(function(...)
        self:SingleFacilityProperty(...);
    end );
    
    self:CityResources();
end

function City:SetConstructionQueueMaxValue(baseMax, tempMax)
    self.baseConstructQueueMax = baseMax;
    self.tempConstructQueueMax = tempMax;
end

function City:GetPlayerBaseConsMax()
    return self.baseConstructQueueMax;
end

function City:GetPlayerTempConsMax()
    return self.tempConstructQueueMax;
end

--获取城市的基础建造队列列表
function City:GetBaseConstructionQueue()
    return self.baseConstructQueue;
end

--获取城市的临时建造队列列表
function City:GetTempConstructionQueue()
    return self.tempConstructQueue;
end

--设置建造队列列表
function City:SetConstructionQueues(baseList,tempList)
    if self.baseConstructQueue~= nil then
        self.baseConstructQueue= nil;
    end
    self.baseConstructQueue = baseList;
    if self.tempConstructQueue ~= nil then
        self.tempConstructQueue = nil;
    end
    self.tempConstructQueue = tempList;
end

--初始化属性
function City:SingleFacilityProperty(SingleFacility)
    --print(SingleFacility._level)
    for m,n in ipairs(Data[SingleFacility._tableId].ConstructionFunctionType) do
        local FunctionParameter = "ConstructionFunctionParameter"..m;
        if n == FacilityProperty.Cost or n == FacilityProperty.RecruitTime or n == FacilityProperty.RedifTime then
            if SingleFacility._level == 0 then
                self._allFacilityProperty[n] = self._allFacilityProperty[n] + 0;
            else
                self._allFacilityProperty[n] = self._allFacilityProperty[n] + Data[SingleFacility._tableId][FunctionParameter][SingleFacility._level] / 10000;
            end
        else
            if SingleFacility._level == 0 then
                self._allFacilityProperty[n] = self._allFacilityProperty[n] + 0;
            else
                self._allFacilityProperty[n] = self._allFacilityProperty[n] + Data[SingleFacility._tableId][FunctionParameter][SingleFacility._level];
            end
        end
        
        self:SetMaxLevelFacilityProperty(SingleFacility, SingleFacility._level);
    end
end

--满级属性
function City:SetMaxLevelFacilityProperty(SingleFacility, level)
    if level == nil or SingleFacility == nil then
        return;
    end
    if level == Data[SingleFacility._tableId].MaxLevel and Data[SingleFacility._tableId].MaxLevelAttribute ~= 0 then
        local lastValue = 0;
        if self._maxLevelFacilityProperty[Data[SingleFacility._tableId].MaxLevelAttribute] ~= nil then
            lastValue = self._maxLevelFacilityProperty[Data[SingleFacility._tableId].MaxLevelAttribute];
        end
        local newValue = Data[SingleFacility._tableId].MaxLevelAttributeParameter;
        self._maxLevelFacilityProperty[Data[SingleFacility._tableId].MaxLevelAttribute] = lastValue + newValue;
    end
end

--改变设施属性
function City:ChangeFacilityProperty(currencyLevel, level, SingleFacility)
    if level == 0 then
        return;
    end

    for m,n in ipairs(Data[SingleFacility._tableId].ConstructionFunctionType) do
        local FunctionParameter = "ConstructionFunctionParameter"..m;
        if n == FacilityProperty.Cost or n == FacilityProperty.RecruitTime or n == FacilityProperty.RedifTime then
            if currencyLevel == 0 then
                self._allFacilityProperty[n] = 
                self._allFacilityProperty[n] +
                Data[SingleFacility._tableId][FunctionParameter][level] / 10000;
            else
                self._allFacilityProperty[n] = 
                self._allFacilityProperty[n] -
                Data[SingleFacility._tableId][FunctionParameter][currencyLevel] / 10000 +
                Data[SingleFacility._tableId][FunctionParameter][level] / 10000;
            end
        else
            if currencyLevel == 0 then
                self._allFacilityProperty[n] = 
                self._allFacilityProperty[n] +
                Data[SingleFacility._tableId][FunctionParameter][level];
            else
                self._allFacilityProperty[n] = 
                self._allFacilityProperty[n] -
                Data[SingleFacility._tableId][FunctionParameter][currencyLevel] +
                Data[SingleFacility._tableId][FunctionParameter][level];
            end
        end
    end

    self:SetMaxLevelFacilityProperty(SingleFacility, level);
    self:CityResources();
end

--获取对应属性
function City:GetCityPropertyByFacilityProperty(facilityProperty)
    if facilityProperty == nil then
        --print("没有属性")
        return 0;
    end
    if self._allFacilityProperty[facilityProperty] ~= nil then 
        return self._allFacilityProperty[facilityProperty];
    end    
    return 0;
end

--获取对应属性
function City:GetCityMaxLevelFacilityProperty(MaxLevelFacilityProperty)
    if MaxLevelFacilityProperty == nil then
        print("参数空值！！！！！！！")
        return 0;
    end
    
    if self._maxLevelFacilityProperty[MaxLevelFacilityProperty] ~= nil then 
        return self._maxLevelFacilityProperty[MaxLevelFacilityProperty];
    else   
        return 0;
    end
end

--资源
function City:CityResources()
      -- for i,v in ipairs(self._allFacilityProperty) do
      --     --print("设施:".."  "..i.." 属性:".."  "..v);
      -- end
      --print(self._allFacilityProperty[FacilityProperty.Wood]..self._allFacilityProperty[FacilityProperty.Iron]..self._allFacilityProperty[FacilityProperty.Stone]..self._allFacilityProperty[FacilityProperty.Food])
     -- print(self._allFacilityProperty[FacilityProperty.Wood])
     PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):SetVariationVal(self._allFacilityProperty[FacilityProperty.Wood]);
     --PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):SetMaxValue(self._allFacilityProperty[FacilityProperty.ResourcesMax]);
     --PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):SetVariationSpace(self._allFacilityProperty[FacilityProperty.Wood] / 3600);
     PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):SetVariationVal(self._allFacilityProperty[FacilityProperty.Iron]);
     --PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):SetMaxValue(self._allFacilityProperty[FacilityProperty.ResourcesMax]);
     --PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):SetVariationSpace(self._allFacilityProperty[FacilityProperty.Iron] / 3600);
     PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):SetVariationVal(self._allFacilityProperty[FacilityProperty.Stone]);
     --PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):SetMaxValue(self._allFacilityProperty[FacilityProperty.ResourcesMax]);
     --PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):SetVariationSpace(self._allFacilityProperty[FacilityProperty.Stone] / 3600);
     PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Grain):SetVariationVal(self._allFacilityProperty[FacilityProperty.Food]);
     --PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Grain):SetMaxValue(self._allFacilityProperty[FacilityProperty.ResourcesMax]);
     --PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Grain):SetVariationSpace(self._allFacilityProperty[FacilityProperty.Food] / 3600);
     local InitFrameMax = DataCharacterInitial[1].FameLimit;
     for i = 1,PlayerService:Instance():GetCityInfoCount() do 
        local cityInfo = PlayerService:Instance():GetCityInfoByIndex(i);
        local building = BuildingService:Instance():GetBuilding(cityInfo.id);
        addLimit = building:GetCityPropertyByFacilityProperty(FacilityProperty.PrestigeMax);
        InitFrameMax =InitFrameMax  + addLimit ;
     end
     PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):SetMaxValue(InitFrameMax);
end

--接收所有设施list
function City:SetAllFacility(Facility)
    self._allFacility:Push(Facility);
end

--城市有没有部队（配置大营才算是一个部队）
function City:CheckCityHaveArmy()

    for i=1 , #self.allArmyList do
        if self.allArmyList[i] ~= nil then
            if self.allArmyList[i]:CheckArmyHaveBackCard() then 
                return true;
            end
        end
    end
    return false;
end

--获取城市中所有的部队数量
function City:GetAllArmyCounts()
    -- body
    return #self.allArmyList
end

--获取城市中所有部队的总兵力
function City:GetAllArmySoldiers()
    local allCount = 0;
    for i=1 , #self.allArmyList do
        if self.allArmyList[i] ~= nil then
            allCount = allCount + self.allArmyList[i]:GetAllSoldierCount();
        end
    end
    return allCount;
end

--获取城市中所有在城市中部队的总兵力(不在城中的不加)
function City:GetAllInCityArmySoldiers()
    local allCount = 0;
    for i=1 , #self.allArmyList do
        if self.allArmyList[i] ~= nil and self.allArmyList[i]:GetArmyState() == ArmyState.None then
            allCount = allCount + self.allArmyList[i]:GetAllSoldierCount();
        end
    end
    return allCount;
end

--判断卡牌是否在该城市某个队伍中
function City:CheckCardInArmy(cardId)
    for i=1 , #self.allArmyList do
        if self.allArmyList[i] ~= nil then
            if self.allArmyList[i]:CheckCardInArmy(cardId) then
                return true;
            end
        end
    end
    return false;
end

--通过卡牌id找到它所属的队伍
function City:GetArmyInfoByCardId(cardId)
    for i=1 , #self.allArmyList do
        if self.allArmyList[i] ~= nil then
            if self.allArmyList[i]:CheckCardInArmy(cardId) then
                return self.allArmyList[i];
            end
        end
    end
    return nil;
end

--获得城区的数量
-- function City:GetCityTitleCount()
--     return self._cityTitleList:Count()
-- end

-- --添加城區
-- function City:SetCityTitleValue(index, town)
--     if town == nil then 
--         return;
--     end
--     self._cityTitleList:Push(town);
--     self._allTiledTable[index] = town;
-- end

--已扩建次数
-- function City:GetCityExpandTimes()
--     local time = 0;
    
--     for k,v in pairs(self._allTiledTable) do
--        --print(k)
--         if k == 0 or 
--         k == 2 or
--         k == 4 or
--         k == 10 or
--         k == 14 or
--         k == 20 or
--         k == 22 or
--         k == 24 then
--         --print(k)
--         time = time + 1;
--         end
--     end

--     return time;
-- end

-- --根据索引获得城区
-- function City:GetCityTitleByIndex(index)
--     if index < 0 or index >= self._cityTitleList:Count() then
--         return
--     end
--     return self._cityTitleList:Get(index);
-- end

-- function City:CityTitleClear()
--     self._cityTitleList:Clear();
-- end

--获得设施的数量
function City:GetAllFacilityCount()
    return self._allFacility:Count()
end

--设置设施
function City:SetFacilityValue(index, facility)
    if facility == nil then 
        return;
    end
    self._allFacility:Push(facility);
    --self._allFacility[index] = facility;
end

--获取对应设施等级
function City:GetFacilitylevelByIndex(index)
    if index == nil or self:GetFacilityByIndex(index) == nil then
       return 0;
    end
    return self:GetFacilityByIndex(index)._level;
end

--获得设施
function City:GetFacilityByIndex(index)
    if index == nil then
        return;
    end
    if index < 0 or index > self._allFacility:Count() then
        return;
    end
    return self._allFacility:Get(index);
end

--清空设施
function City:AllFacilityClear()
    self._allFacility:Clear();
end

-- --获得tiled的数量
-- function City:GetTiledCount()
--     return table.getn(self._allTiledTable);
-- end

--设置tiled
-- function City:SetCityTiled(index, citytiled)
--     if index == nil then
--         return;
--     end
--     --table.insert(self._allTiledTable,index,tiled);
--     --print(tiled);
--     self._allTiledTable[index] = citytiled;
-- end

-- function City:GetCityTiledByIndex(index)
--     return self._allTiledTable[index];
-- end

-- --获得全部tiled
-- function City:GetTiledTable()
--     return self._allTiledTable;
-- end

--部队槽位是否开启
function City:CheckArmySlotIndexOpen(armySlotIndex)
    local openedCount = self:GetCityPropertyByFacilityProperty(FacilityProperty.ArmyCount);
    if openedCount >= armySlotIndex then
        return true;
    else
        return false;
    end
    return false;
end

--某个队伍的前锋是否开启
function City:CheckArmyFrontOpen(armySlotIndex)
    local armyIsOpen = self:CheckArmySlotIndexOpen(armySlotIndex);
    if armyIsOpen == true then 
        local frontCount = self:GetCityPropertyByFacilityProperty(FacilityProperty.Striker);
        if frontCount >= armySlotIndex then
            return true;
        else
            return false;
        end
    else
        return false;
    end
end

--获取城市征兵队伍数量
function City:GetArmyConscritionCount()
    local count =0;
    if self.allArmyList ~= nil then 
        for i=1,#self.allArmyList do
            if self.allArmyList[i]~= nil then 
                if self.allArmyList[i]:IsArmyInConscription() == true then 
                    count = count+1;
                end
            end
        end
    end
    return count;
end

--获取城市所有队伍某类型的维持消耗
function City:GetAllKeepArmyCost(currencyEnum)
    local count = 0;
    if self.allArmyList ~= nil then 
        for i=1,#self.allArmyList do
            if self.allArmyList[i]~= nil then
               count = count+ self.allArmyList[i]:GetKeepArmyCost(currencyEnum);
            end
        end
    end
    return count;
end

--清空该城市所有部队里卡牌的兵力
function City:ClearAllCardSoldiers()
    if self.allArmyList ~= nil then 
        for i=1,#self.allArmyList do
            if self.allArmyList[i]~= nil then
               self.allArmyList[i]:ClearAllCardSoldiers();
            end
        end
    end
end

return City;
