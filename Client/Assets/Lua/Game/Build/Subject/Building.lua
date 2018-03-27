-- 建筑物
local List = require("common/List")
local Building = class("Building")
local DataGameConfig = require("Game/Table/model/DataGameConfig")
require("Game/Table/model/DataBuilding")
local VariationCalc = require("Game/Util/VariationCalc")

-- 构造函数
function Building:ctor()
    -- 建筑物表Id
    self._tableId = 0

    -- 唯一Id
    self._id = 0

    -- 表数据
    self._dataInfo = nil

    -- 所有者
    self._owner = 0

    -- 名称
    self._name = nil;

    -- 格子Id
    self._tiledId = 0

    -- 耐久消耗
    self._durabilityCost = 0

    -- 耐久恢复的时间
    self._durabilityRecoveryTime = 0

    -- 所有的城区
    self._allTownList = List.new()

    -- 城区层数
    self._state = 0

    -- 预备兵
    self._redif = nil;
    -- 预备兵增加计时器
    self.marchTimer = nil;

    -- 添加城区
    self._townList = { }

    self.firstBattleInfo = nil;

    -- 分城建造完成时间
    self._subCitySuccessTime = 0;

    -- 分城拆除完成时间
    self._subCityDeleteTime = 0;
    -- 同盟名称
    self._leagueName = "";
    -- 同盟id
    self._leagueId = 0;

    -- 建造完成时间
    self._buildSuccessTime = 0
    -- 拆除完成时间
    self._buildDeleteTime = 0
    -- 要塞升级时间
    self._upgradeFortTime = 0

    self.createTime = 0;
    self.removeTime = 0;

    -- 子码头
    self._childBoat = nil;
end

-- 同盟名称
function Building:SetLeagueName(args)
    self._leagueName = args
end
function Building:GetLeagueName()
    return self._leagueName
end


-- 同盟id
function Building:SetLeagueId(args)
    self._leagueId = args
end
function Building:GetLeagueId()
    return self._leagueId
end



function Building:SetIndex(index)
    self._tiledId = index
end

function Building:GetIndex()
    return self._tiledId;
end



-- 设置Id
function Building:SetId(id)
    self._id = id;
end

-- 得到Id
function Building:GetId()
    return self._id;
end

-- 获得城区的数量
-- function Building:GetTownCount()
-- 	return self._allTownList:Count()
-- end

-- 添加城區
function Building:SetTownValue(town)
    if town == nil then
        return;
    end
    self._allTownList:Push(town);
end
-- 设置所有者

function Building:SetOwner(id)

    self._owner = id

end


function Building:GetOwner()

    return self._owner;

end

-- 根据索引获得城区
function Building:GetTownByIndex(index)
    if index < 0 or index >= self._allTownList:Count() then
        return
    end
    return self._allTownList:Get(index)
end

-- 根据格子取得城区
function Building:GetTown(tileId)
    return self._allTownTable.tileId
end

-- 添加一个城区
function Building:AddTown(town)
    if town == nil then
        return
    end
    table.insert(self._townList, town)
end

-- 获取一个城区
function Building:GetTown(index)
    return self._townList[index]
end

-- 获取城区数量
function Building:GetTownCount()
    return #self._townList
end

-- 添加一个要塞
function Building:AddFort(fort)
    if fort == nil then
        return
    end
    table.insert(self._fortList, fort)
end
function Building:GetFort(index)
    return self._fortList[index]
end
function Building:GetFortCount()
    return #self._fortList
end

function Building:RemoveArmyInfo(armyinfo)

end

function Building:SetArmyInfo(armyinfo,index)

end



-- begin 获取首战奖励  hlf
function Building:GetFirst()

    return self.firstBattleInfo

end

function Building:SetFirst(firstBattleInfo)

    self.firstBattleInfo = firstBattleInfo

end
-- end 首战奖励

-- 	for k,v in pairs(self._allTownTable) do
-- 		if k == town._index then
-- 			return
-- 		end
-- 	end

-- 	self._allTownList:Push(town)

-- 	self._allTownTable.insert(town._index,town)
-- end

-- 设置预备兵数量
function Building:SetBuildingRedif(count)
    local data = 0;
    local reducedTime = 0;
    local recoveryTime = 0;
    if self._dataInfo.Type ~= BuildingType.WildGarrisonBuilding then
        data = DataGameConfig[301].OfficialData
        reducedTime = self:GetCityPropertyByFacilityProperty(FacilityProperty.RedifTime);
        recoveryTime=self:GetCityMaxLevelFacilityProperty(MaxLevelFacilityProperty.ReserveRecoveryTime)
    else
        data = DataGameConfig[505].OfficialData
    end
    local maxRedif = self:GetBuildingMaxRedif();

    if count >= maxRedif then
        count = maxRedif;
    end
    if self._redif == nil then
        self._redif = VariationCalc.new();
        self._redif:Init(count, PlayerService:Instance():GetLocalTime(),false);
        self._redif:SetVariationVal(1);
        local reducedTime = reducedTime
        local perTime = math.floor(data *(1+reducedTime))*(1+ recoveryTime/10000);    
        self._redif:SetVariationSpace(perTime);
        self._redif:SetMaxValue(maxRedif);
    else
        self._redif:SetValue(count);
    end
end

-- 预备兵定时增加（增量及其时间由DataGameConfig表配置）
function Building:AddRedifCount()
    local data = 0;
    local reducedTime = 0;
    local recoveryTime = 0;
    if self._dataInfo.Type ~= BuildingType.WildGarrisonBuilding then
        data = DataGameConfig[301].OfficialData
        reducedTime = self:GetCityPropertyByFacilityProperty(FacilityProperty.RedifTime);
        recoveryTime=self:GetCityMaxLevelFacilityProperty(MaxLevelFacilityProperty.ReserveRecoveryTime)
    else
        data = DataGameConfig[505].OfficialData
    end
    local maxRedif = self:GetBuildingMaxRedif();
        local perTime = math.floor(data * (1 + reducedTime)) * (1 + recoveryTime/10000);
    if self._redif ~= nil then
        self._redif:SetVariationSpace(perTime);
    end

    --预备兵相关界面定时刷新
    self.refreshUITime = 1000000000;
    if self.refreshUITimer == nil then
        self.refreshUITimer = Timer.New( function()
            self.refreshUITime = self.refreshUITime > 0 and self.refreshUITime - 1 or 0;
            local baseCityClass = UIService:Instance():GetUIClass(UIType.UIMainCity);
            if baseCityClass ~= nil and baseCityClass.curBuilding ~= nil and baseCityClass.curBuilding._id == self._id then
                baseCityClass:SetRedif();
            end
            if self.refreshUITime == 0 then
               self.refreshUITimer:Stop();
            end
        end , 1, -1, false);
        self.refreshUITimer:Start();
    end
end


-- 获取本城市预备兵上限
function Building:GetBuildingMaxRedif()
    if self._dataInfo.Type ~= BuildingType.WildGarrisonBuilding then
        return self:GetCityPropertyByFacilityProperty(FacilityProperty.RedifMax) + DataGameConfig[315].OfficialData;
    else
        return DataGameConfig[504].OfficialData;
    end
end

function Building:GetWildCampMaxRedif()
    return DataGameConfig[504].OfficialData;
end

function Building:GetBuildingRedif()
    return self._redif:GetValue();
end

--增加预备兵数量（任务可以增加）
function Building:AddBuildingRedif(addCount)
    self._redif:ChangeValue(addCount);
end

--检测增加一定数量的预备兵时，会不会超过上限
function Building:CheckRedifAddToMax(addCount)
    local maxRedif = self:GetBuildingMaxRedif();
    if self:GetBuildingRedif() + addCount >= maxRedif then
        return true;
    end
    return false;
end

function Building:RemoveRedifTimer( )
    if self.marchTimer ~= nil then
       self.marchTimer:Stop();
       self.marchTimer = nil;
    end
    if self.refreshUITimer~=nil then 
        self.refreshUITimer:Stop();
        self.refreshUITimer=nil;
    end
end


-- 判断分城是否在建设中
function Building:JudgeSubCityIsCreating()
    if self._dataInfo == nil or self._dataInfo.Type ~= BuildingType.SubCity then
        return false;
    end
    if self._subCitySuccessTime == 0 then
        return false;
    end
    local currentTime = PlayerService:Instance():GetLocalTime();
    if currentTime < self._subCitySuccessTime then
        return true;
    else
        return false;
    end
end

-- 判断分城是否在拆除中
function Building:JudgeSubCityIsDeleting()
    if self._dataInfo == nil or self._dataInfo.Type ~= BuildingType.SubCity then
        return false;
    end
    if self._subCityDeleteTime == 0 then
        return false;
    end
    local currentTime = PlayerService:Instance():GetLocalTime();
    if currentTime < self._subCityDeleteTime then
        return true;
    else
        return false;
    end
end

-- 判断玩家要塞是否在建造中
function Building:JudgePlayerFortIsOnBuilding()
    if self._dataInfo == nil or self._dataInfo.Type ~= BuildingType.PlayerFort then
        return false;
    end
    if self._buildSuccessTime == 0 then
        return false;
    end
    local currentTime = PlayerService:Instance():GetLocalTime();
    if currentTime < self._buildSuccessTime then
        return true;
    end
    return false;
end



return Building