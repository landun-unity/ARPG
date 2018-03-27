--
-- 逻辑服务器 --> 客户端
-- 同步玩家的所有建筑物
-- @author czx
--
local List = require("common/List");

local SyncBuilding = require("MessageCommon/Msg/L2C/Player/SyncBuilding");
local CityTitledModel = require("MessageCommon/Msg/L2C/Player/CityTitledModel");

local GameMessage = require("common/Net/GameMessage");
local SyncBuildingInfo = class("SyncBuildingInfo", GameMessage);

--
-- 构造函数
--
function SyncBuildingInfo:ctor()
    SyncBuildingInfo.super.ctor(self);
    --
    -- 建筑物列表
    --
    self.allBuilding = List.new();
end

--@Override
function SyncBuildingInfo:_OnSerial() 
    
    local allBuildingCount = self.allBuilding:Count();
    self:WriteInt32(allBuildingCount);
    for allBuildingIndex = 1, allBuildingCount, 1 do 
        local allBuildingValue = self.allBuilding:Get(allBuildingIndex);
        
        self:WriteInt64(allBuildingValue.id);
        self:WriteString(allBuildingValue.name);
        self:WriteInt64(allBuildingValue.ownerId);
        self:WriteString(allBuildingValue.ownerName);
        self:WriteInt64(allBuildingValue.leagueId);
        self:WriteString(allBuildingValue.leagueName);
        self:WriteInt32(allBuildingValue.tableId);
        self:WriteInt32(allBuildingValue.tiledId);
        self:WriteInt32(allBuildingValue.durabilityCost);
        self:WriteInt64(allBuildingValue.durabilityRecoveryTime);
        self:WriteInt32(allBuildingValue.redifNum);
        self:WriteInt32(allBuildingValue.canExpandTime);
        self:WriteInt64(allBuildingValue.buildSuccessTime);
        self:WriteInt64(allBuildingValue.removeBuildTime);
        self:WriteInt32(allBuildingValue.buildingType);
        self:WriteInt32(allBuildingValue.buildingLev);
        self:WriteInt64(allBuildingValue.buildingUpgradeTime);
        self:WriteInt64(allBuildingValue.onBuildingId);
        self:WriteInt32(allBuildingValue.nameNum);
        self:WriteInt32(allBuildingValue.fortArmyCount);
        self:WriteInt64(allBuildingValue.upgradeFortTime);
        self:WriteInt64(allBuildingValue.createTime);
        self:WriteInt64(allBuildingValue.removeTime);
        
        local allBuildingValuetitleListCount = allBuildingValue.titleList:Count();
        self:WriteInt32(allBuildingValuetitleListCount);
        for allBuildingValuetitleListIndex = 1, allBuildingValuetitleListCount, 1 do 
            local allBuildingValuetitleListValue = allBuildingValue.titleList:Get(allBuildingValuetitleListIndex);
            
            self:WriteInt32(allBuildingValuetitleListValue.index);
            self:WriteInt32(allBuildingValuetitleListValue.tableid);
            self:WriteInt32(allBuildingValuetitleListValue.level);
            self:WriteInt32(allBuildingValuetitleListValue.folkType);
        end
    end
end

--@Override
function SyncBuildingInfo:_OnDeserialize() 
    
    local allBuildingCount = self:ReadInt32();
    for i = 1, allBuildingCount, 1 do 
        local allBuildingValue = SyncBuilding.new();
        allBuildingValue.id = self:ReadInt64();
        allBuildingValue.name = self:ReadString();
        allBuildingValue.ownerId = self:ReadInt64();
        allBuildingValue.ownerName = self:ReadString();
        allBuildingValue.leagueId = self:ReadInt64();
        allBuildingValue.leagueName = self:ReadString();
        allBuildingValue.tableId = self:ReadInt32();
        allBuildingValue.tiledId = self:ReadInt32();
        allBuildingValue.durabilityCost = self:ReadInt32();
        allBuildingValue.durabilityRecoveryTime = self:ReadInt64();
        allBuildingValue.redifNum = self:ReadInt32();
        allBuildingValue.canExpandTime = self:ReadInt32();
        allBuildingValue.buildSuccessTime = self:ReadInt64();
        allBuildingValue.removeBuildTime = self:ReadInt64();
        allBuildingValue.buildingType = self:ReadInt32();
        allBuildingValue.buildingLev = self:ReadInt32();
        allBuildingValue.buildingUpgradeTime = self:ReadInt64();
        allBuildingValue.onBuildingId = self:ReadInt64();
        allBuildingValue.nameNum = self:ReadInt32();
        allBuildingValue.fortArmyCount = self:ReadInt32();
        allBuildingValue.upgradeFortTime = self:ReadInt64();
        allBuildingValue.createTime = self:ReadInt64();
        allBuildingValue.removeTime = self:ReadInt64();
        
        local allBuildingValuetitleListCount = self:ReadInt32();
        for i = 1, allBuildingValuetitleListCount, 1 do 
            local allBuildingValuetitleListValue = CityTitledModel.new();
            allBuildingValuetitleListValue.index = self:ReadInt32();
            allBuildingValuetitleListValue.tableid = self:ReadInt32();
            allBuildingValuetitleListValue.level = self:ReadInt32();
            allBuildingValuetitleListValue.folkType = self:ReadInt32();
            allBuildingValue.titleList:Push(allBuildingValuetitleListValue);
        end
        self.allBuilding:Push(allBuildingValue);
    end
end

return SyncBuildingInfo;
