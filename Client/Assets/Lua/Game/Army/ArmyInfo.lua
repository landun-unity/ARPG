--[[
	部队
--]]
require("Game/Army/ArmyState")
local ArmyInfo = class("ArmyInfo")
local CurrencyEnum = require("Game/Player/CurrencyEnum");

-- 构造函数
function ArmyInfo:ctor()
    -- 卡牌
    self.cardArray = { };
    -- 卡牌兵力
    self.soldierCountArray = { };
    -- 卡牌总兵力
    self.allSoldierCount = 0;
    -- 征兵结束时间戳
    self.allConscriptionEndTimeArray = { };    
    -- 正在征兵的数量
    self.allConscriptionCountArray = { };
    -- 起始格子
    self.startTiled = 0;
    -- 结束格子
    self.endTiled = 0;
    -- 所在地格子
    self.tiledId = 0;
    -- 开始移动时间
    self.startTime = 0;
    -- 结束移动时间
    self.endTime = 0;
    -- 屯田开始时间
    self.farmmingStartTime = 0;
    -- 屯田结束时间
    self.farmmingEndTime = 0;
    -- 练兵开始时间
    self.trainingStartTime = 0;
    -- 练兵结束时间
    self.trainingEndTime = 0;
    -- 战平开始时间
    self.battleStartTime = 0;
    -- 战平结束时间
    self.battleEndTime = 0;
    -- 槽位
    self.slotIndex = 0;
    -- 产生的槽位(城市的)
    self.spawnSlotIndex = 0;
    -- 出生的建筑物Id
    self.spawnBuildng = 0;
    -- 部队的移动速度
    self.speed = 200;
    -- 部队状态
    self.armyState = ArmyState.None;
    -- 部队当前所在的建筑Id
    self.curBuildingId = 0;

    -- 总共练兵次数
    self.totalTrainingTimes = 0;

    -- 当前练兵次数
    self.curTrainingTimes = 0;
end

--设置队伍基本信息
function ArmyInfo:SetArmyBaseInfo(startTiled,endTiled,tiledId,startTime,endTime,slotIndex,spawnSlotIndex,spawnBuildng,armyState,curBuildingId
    ,farmmingStartTime,farmmingEndTime,trainingStartTime,trainingEndTime,battleStartTime,battleEndTime,totalTrainingTimes,curTrainingTimes)
    self.startTiled = startTiled;
    self.endTiled = endTiled;
    self.tiledId = tiledId;
    self.startTime = startTime;
    self.endTime = endTime;
    self.slotIndex = slotIndex;
    self.spawnSlotIndex = spawnSlotIndex;
    self.spawnBuildng = spawnBuildng;
    self.armyState = armyState;
    self.curBuildingId = curBuildingId;
    self.farmmingStartTime = farmmingStartTime;
    self.farmmingEndTime = farmmingEndTime;
    self.trainingStartTime = trainingStartTime;
    self.trainingEndTime = trainingEndTime;
    self.battleStartTime = battleStartTime;
    self.battleEndTime = battleEndTime;
    self.totalTrainingTimes = totalTrainingTimes;
    self.curTrainingTimes = curTrainingTimes;
end

-- 设置卡牌
function ArmyInfo:SetCard(armySlotType, card, soldier)
    if card == nil or soldier == nil or armySlotType == nil then
        return;
    end

    if self.soldierCountArray[armySlotType] ~= nil then
        self.allSoldierCount = self.allSoldierCount - self.soldierCountArray[armySlotType];
    end

    self.allSoldierCount = self.allSoldierCount + soldier;
    card:SetCardTroop(soldier);
    card:SetBuildingId(self.spawnBuildng);
    self.cardArray[armySlotType] = card;
    self.soldierCountArray[armySlotType] = soldier;
end

-- 移除卡牌
function ArmyInfo:RemoveCard(armySlotType)
    if armySlotType == nil then
        return;
    end

    if self.soldierCountArray[armySlotType] ~= nil then
        self.allSoldierCount = self.allSoldierCount - self.soldierCountArray[armySlotType];
    end

    self.cardArray[armySlotType] = nil;
    self.soldierCountArray[armySlotType] = 0;
end

-- 清空部队里所有卡牌的兵力
function ArmyInfo:ClearAllCardSoldiers()
    for k,v in pairs(self.cardArray) do      
        v:SetCardTroop(0);
    end
end

-- 征兵完成调用
function ArmyInfo:OnConscriptionOk()
    self.allSoldierCount = 0;
    for k, v in pairs(self.soldierCountArray) do
        self.allSoldierCount = self.allSoldierCount + v;
    end
end

-- 设置征兵信息
function ArmyInfo:SetConscription(armySlotType, conscriptionEndTime, conscriptionCount)
    self.allConscriptionEndTimeArray[armySlotType] = conscriptionEndTime;
    self.allConscriptionCountArray[armySlotType] = conscriptionCount;
end

--更新兵力,征兵完成后调用,刷新兵力、总兵力 
function ArmyInfo:UpdateSoldierCount(armySlotType,newCount,endTime)
    if self.soldierCountArray[armySlotType] ~= nil then
        self.allSoldierCount = self.allSoldierCount - self.soldierCountArray[armySlotType];
    end
    self.soldierCountArray[armySlotType] =  newCount;
    if endTime~= nil then
        self.allConscriptionEndTimeArray[armySlotType] = endTime;
        self.allConscriptionCountArray[armySlotType] = 0;
    end
    self.allSoldierCount = self.allSoldierCount +  self.soldierCountArray[armySlotType];

    local cardInfo = self:GetCard(armySlotType);
    if cardInfo ~= nil then 
        cardInfo.troop = newCount;
    end
end


--获取某个位置的兵力
function ArmyInfo:GetIndexSoldierCount(armySlotType)
    if self.soldierCountArray[armySlotType] ~= nil then 
        return self.soldierCountArray[armySlotType];
    else
        return 0;
    end
end

-- 获取总兵力
function ArmyInfo:GetAllSoldierCount()
    return self.allSoldierCount;
end

-- 队伍某个位置是否处于征兵中
function ArmyInfo:IsConscription(armySlotType)
    if self.allConscriptionCountArray[armySlotType] ~= nil and self.allConscriptionCountArray[armySlotType] > 0 then
        return true;
    else
        return false;
    end
end

--检测队伍中某个位置的卡牌是否是重伤
function ArmyInfo:CheckArmyCardIsHurt(armySlotType)
    local heroCard = self:GetCard(armySlotType);
    if heroCard ~= nil then
        if heroCard.RecoverTime > 0 then
            local leftTime = math.floor((heroCard.RecoverTime - PlayerService:Instance():GetLocalTime()) / 1000)
            if leftTime > 0 then
                return true;
            else
                return false;
            end        
        else
            return false;
        end
    else
        return false;
    end
end

--检测队伍中某个位置的卡牌是否是疲劳
function ArmyInfo:CheckArmyCardIsTired(armySlotType)
    local heroCard = self:GetCard(armySlotType);
    local needPhysical = DataGameConfig[103].OfficialData;
    if NewerPeriodService:Instance():IsInNewerPeriod() == true then
        needPhysical = DataGameConfig[104].OfficialData;
    end
    if heroCard ~= nil then
        if heroCard.power:GetValue() < needPhysical then
            return true;
        else
            return false;
        end
    else
        return false;
    end
end

--队伍是否疲劳（只要一个卡牌疲劳就算是）
function ArmyInfo:IsArmyIsTired()
    if self:CheckArmyCardIsTired(ArmySlotType.Back) == true or self:CheckArmyCardIsTired(ArmySlotType.Center) == true or self:CheckArmyCardIsTired(ArmySlotType.Front) == true then 
        return true;
    end
    return false;      
end

--队伍是否重伤（只要一个卡牌重伤就算是）
function ArmyInfo:IsArmyIsBadlyHurt()
    if self:CheckArmyCardIsHurt(ArmySlotType.Back) == true or self:CheckArmyCardIsHurt(ArmySlotType.Center) == true or self:CheckArmyCardIsHurt(ArmySlotType.Front) == true then 
        return true;
    end
    return false;      
end

--队伍是否在征兵（只要一个位置在征兵就算在）
function ArmyInfo:IsArmyInConscription()
    if self:IsConscription(ArmySlotType.Back) == true or self:IsConscription(ArmySlotType.Center) == true or self:IsConscription(ArmySlotType.Front) == true then 
        return true;
    end
    return false;      
end

--获取队伍中正在征兵的卡牌的数量
function ArmyInfo:GetConscriptingCardCount()
    local count = 0;
    for k, v in pairs(ArmySlotType) do
        if self:IsConscription(v) == true then
            count = count + 1;
        end
    end
    return count;
end

--获取征兵结束的时间戳（单位：秒）
function ArmyInfo:GetConscriptionEndTime(armySlotType)
    if self.allConscriptionEndTimeArray[armySlotType] then
        return self.allConscriptionEndTimeArray[armySlotType];
    else
        return 0;
    end
end

-- 获取队伍中某个位置正在征兵的数量
function ArmyInfo:GetConscriptionCount(armySlotType)
    return self.allConscriptionCountArray[armySlotType];
end

--获取队伍状态
function ArmyInfo:GetArmyState()
    return self.armyState;
end

-- 获取卡牌
function ArmyInfo:GetCard(armySlotType)
    if armySlotType == nil or armySlotType == ArmySlotType.None then       
        return nil;
    end
    if self.cardArray[armySlotType] == nil then 
        return nil;
    else
        return self.cardArray[armySlotType];
    end
end

-- 获取卡牌数量
function ArmyInfo:GetCardCount()
    local count = 0;
    for k,v in pairs(self.cardArray) do      
        count = count +1;
    end
    return count;
end

--判断当前部队是否配置大营
function ArmyInfo:CheckArmyHaveBackCard()    
    return self:GetCard(ArmySlotType.Back);
end

-- 判断卡牌是否在该部队中 cardId:卡牌唯一id
function ArmyInfo:CheckCardInArmy(cardId)
    for k,v in pairs(self.cardArray) do      
        if v.id == cardId then
            return true;
        end
    end
    return nil;
end

-- 判断卡牌是否在该部队中 cardTabelId:卡牌tableId
function ArmyInfo:CheckCardInArmyByTableId(cardTabelId)
    for k,v in pairs(self.cardArray) do      
        if v.tableID == cardTabelId then
            return true;
        end
    end
    return nil;
end

-- 检测改部队是否开启前锋
function ArmyInfo:CheckArmyOpenFront()
    local belongBuilding = BuildingService:Instance():GetBuilding(self.spawnBuildng);
    if belongBuilding ~= nil then 
        return belongBuilding:CheckArmyFrontOpen(self.spawnSlotIndex);
    end
    return false;
end

--获取部队中的卡牌通过tableID
function ArmyInfo:GetCardByTableId(cardTabelId)
    for k,v in pairs(self.cardArray) do      
        if v.tableID == cardTabelId then
            return v;
        end
    end
    return nil;
end

-- 获取卡牌在部队中的位置
function ArmyInfo:GetCardArmySlotType(cardId)
    for k,v in pairs(self.cardArray) do      
        if v.id == cardId then
            return k;
        end
    end
    return nil;
end

--获取部队中卡牌的总COST值
function ArmyInfo:GetArmyAllCost()
    local allCost =0;
    for k,v in pairs(self.cardArray) do      
        allCost = allCost + v:GetHeroCostValue();
    end
    return allCost;
end

--获取部队当前可配置的最大COST值
function ArmyInfo:GetArmyMaxCost()
    local belongBuilding = BuildingService:Instance():GetBuilding(self.spawnBuildng);
    if belongBuilding ~= nil then 
        return belongBuilding:GetCityPropertyByFacilityProperty(FacilityProperty.Cost);
    else
        return 0;
    end
end

function ArmyInfo:GetArmyBelongsCity(buildingId)
     return self.spawnBuildng;
end

function ArmyInfo:GetArmyState()
    return self.armyState;
end

--获取部队总的攻城值
function ArmyInfo:GetAllAttackCityValue()
    local cityValue = 0;
    for k,v in pairs(self.cardArray) do      
        cityValue = cityValue + v:GetSiegeValue();
    end
    return cityValue;
end

-- 获取部队速度（包含设施加成）
function ArmyInfo:GetSpeedContainFacility()
    local tempSpeed = self:GetSpeed();
    local facilityAdd = FacilityService:Instance():GetCityPropertyByFacilityProperty(self.spawnBuildng, FacilityProperty.ArmySpeed);
    return tempSpeed + facilityAdd;
end

-- 获取部队速度（不含设施加成）
function ArmyInfo:GetSpeed()
    local tempSpeed = 0;
    for k,v in pairs(self.cardArray) do      
        if v ~= nil then
            local speed = v:GetSpeedValue();
            if tempSpeed == 0 then
                tempSpeed = speed;
            else
                if speed < tempSpeed then
                    tempSpeed = speed;
                end
            end
        end
    end
    return tempSpeed;
end

--检测队伍中所有卡牌是否都已达到兵力上限
function ArmyInfo:CheckArmyAllSoliderMax()
    --获取兵营增加的最大可征兵数量
    local soldierBuildingCount =0;
    local building = BuildingService:Instance():GetBuilding(self.spawnBuildng);
    if building ~= nil then 
        soldierBuildingCount = building:GetCityPropertyByFacilityProperty(FacilityProperty.NumberTroops);
    else
        print("error!!!  building is nil which id is "..self.spawnBuildng);
    end
    for k,v in pairs(self.cardArray) do
        local maxSolider = DataHeroLevel[v.level].UnitAmount+ soldierBuildingCount;
        if self.soldierCountArray[k] ~= nil and self.soldierCountArray[k] < maxSolider then 
            return false;
        end
    end
    return true;
end

--获取部队的维持消耗
function ArmyInfo:GetKeepArmyCost(currencyEnum)
    local costValue = 0;
    for k,v in pairs(self.cardArray) do
        local mHeroData = DataHero[v.tableID];
        local soliders =  self:GetIndexSoldierCount(k)/100;
        local mResourceData = ArmyService:Instance():GetCardDataConscriptionResources(mHeroData.Star,mHeroData.Camp,mHeroData.BaseArmyType);
        if currencyEnum == CurrencyEnum.Wood then
            costValue = costValue + math.floor(mResourceData.KeepWood* soliders);     
        elseif currencyEnum == CurrencyEnum.Iron then 
            costValue = costValue + math.floor(mResourceData.KeepIorn* soliders);
        elseif currencyEnum == CurrencyEnum.Grain then 
            costValue = costValue + math.floor(mResourceData.KeepFood* soliders);
        end
    end
    return costValue;
end

--部队是否开启阵营加成
function ArmyInfo:CheckCampAddition()
    if self:GetCardCount() < 2 then 
        return false;
    else
        local campTable = self:GetArmyCampTables();
        for k, v in pairs(campTable) do
            if v >1 then 
                return  self:CheckCampBuildingIsBuilded(k);
            end
        end    
    end
    return false;
end

--部队是否开启兵种加成
function ArmyInfo:CheckSoldierAddition()
    if self:GetCardCount() < 2 then
        return false;
    else
        local soldierTypeTable = self:GetArmySoldierTypeTables();
        for k, v in pairs(soldierTypeTable) do
            if v >1 then 
                return  true;
            end
        end
    end
    return false;
end

--部队是否开启称号加成
function ArmyInfo:CheckTitleAddition()
    if self:GetCardCount() < 2 then 
       return false;
    else
        
    end
    return false;
end

--检测阵营对应的设施建筑是否建造
function ArmyInfo:CheckCampBuildingIsBuilded(camp)
    local building = BuildingService:Instance():GetBuilding(self.spawnBuildng)   
    local campAdditionData = ArmyService:Instance():GetCampAdditionData(camp);
    local buildId =0;
    if building._dataInfo.Type == BuildingType.MainCity then    
        buildId = campAdditionData.ConstructionType[1];    
    elseif building._dataInfo.Type == BuildingType.SubCity then
        buildId = campAdditionData.ConstructionType[2];
    end
    local needLevel = campAdditionData.ConstructionLevel;
    local curLevel = building:GetFacilitylevelByIndex(DataConstruction[buildId].Type);
    if curLevel >= needLevel then 
        return true;
    else
        return false;
    end
end

--获取部队兵种加成的卡牌数量
function ArmyInfo:GetGetAddedSoldierCardCount()
     if self:GetCardCount() < 2 then
        return 0;
    else
        local soldierTypeTable = self:GetArmySoldierTypeTables();
        for k, v in pairs(soldierTypeTable) do
            if v >1 then 
                return  v;
            end
        end
    end
    return 0;
end

--获取部队阵营加成的卡牌数量
function ArmyInfo:GetGetAddedCampCardCount()
    if self:GetCardCount() < 2 then 
        return 0;
    else
        local campTable = self:GetArmyCampTables();
        for k, v in pairs(campTable) do
            if v >1 then
                if  self:CheckCampBuildingIsBuilded(k) == true then
                    return  v;
                else
                     return  0;
                end
            end
        end    
    end
    return 0;
end

--获取部队开启的加成阵营
function ArmyInfo:GetAddedCamp()
    local campTable = self:GetArmyCampTables();       
    for k, v in pairs(campTable) do
        if v >1 then 
            return k;
        end
    end
end

--获取部队开启的加成兵种
function ArmyInfo:GetAddedSoldierType()
    local soldierTypeTable = self:GetArmySoldierTypeTables();       
    for k, v in pairs(soldierTypeTable) do
        if v >1 then 
            return k;
        end
    end
end

function ArmyInfo:GetArmySoldierTypeTables()
    local soldierTypeTable = {};
    for k, v in pairs(ArmySlotType) do
        local oneCard = self:GetCard(v);
        if oneCard~= nil then
            --高级兵种要转换为基本兵种类型
            --local normalBaseType = DataHeroArmyType[]
            if soldierTypeTable[oneCard.baseArmy] == nil then
                soldierTypeTable[oneCard.baseArmy] = 1;
            else
                local count = soldierTypeTable[oneCard.baseArmy];
                count = count+1;
                soldierTypeTable[oneCard.baseArmy] = count;
            end
        end
    end
    return soldierTypeTable; 
end

function ArmyInfo:GetArmyCampTables()
    local campTable = {};
    for k, v in pairs(ArmySlotType) do
        local oneCard = self:GetCard(v);
        if oneCard~= nil then 
            local heroData = DataHero[oneCard.tableID];
            if heroData ~= nil then
                if campTable[heroData.Camp] == nil then
                    campTable[heroData.Camp] = 1;
                else
                    local count = campTable[heroData.Camp];
                    count = count+1;
                    campTable[heroData.Camp] = count;
                end
            end
        end
    end
    return campTable;
end

return ArmyInfo;
