--
-- 逻辑服务器 --> 客户端
-- 部队列表
-- @author czx
--
local List = require("common/List");

local SingleArmyInfo = require("MessageCommon/Msg/L2C/Army/SingleArmyInfo");

local GameMessage = require("common/Net/GameMessage");
local SyncAllArmy = class("SyncAllArmy", GameMessage);

--
-- 构造函数
--
function SyncAllArmy:ctor()
    SyncAllArmy.super.ctor(self);
    --
    -- 所有的部队列表
    --
    self.allArmyList = List.new();
end

--@Override
function SyncAllArmy:_OnSerial() 
    
    local allArmyListCount = self.allArmyList:Count();
    self:WriteInt32(allArmyListCount);
    for allArmyListIndex = 1, allArmyListCount, 1 do 
        local allArmyListValue = self.allArmyList:Get(allArmyListIndex);
        
        self:WriteInt64(allArmyListValue.card1);
        self:WriteInt32(allArmyListValue.soldier1Count);
        self:WriteInt64(allArmyListValue.soldier1ConscriptionStartTime);
        self:WriteInt64(allArmyListValue.soldier1ConscriptionCount);
        self:WriteInt64(allArmyListValue.card2);
        self:WriteInt32(allArmyListValue.soldier2Count);
        self:WriteInt64(allArmyListValue.soldier2ConscriptionStartTime);
        self:WriteInt64(allArmyListValue.soldier2ConscriptionCount);
        self:WriteInt64(allArmyListValue.card3);
        self:WriteInt32(allArmyListValue.soldier3Count);
        self:WriteInt64(allArmyListValue.soldier3ConscriptionStartTime);
        self:WriteInt64(allArmyListValue.soldier3ConscriptionCount);
        self:WriteInt32(allArmyListValue.startTiled);
        self:WriteInt32(allArmyListValue.endTiled);
        self:WriteInt64(allArmyListValue.startTime);
        self:WriteInt64(allArmyListValue.endTime);
        self:WriteInt32(allArmyListValue.slotId);
        self:WriteInt32(allArmyListValue.spawnSlotId);
        self:WriteInt64(allArmyListValue.spawnBuilding);
        self:WriteInt32(allArmyListValue.tiledId);
        self:WriteInt64(allArmyListValue.curBuildingId);
        self:WriteInt64(allArmyListValue.farmmingStartTime);
        self:WriteInt64(allArmyListValue.farmmingEndTime);
        self:WriteInt64(allArmyListValue.trainingStartTime);
        self:WriteInt64(allArmyListValue.trainingEndTime);
        self:WriteInt64(allArmyListValue.battleStartTime);
        self:WriteInt64(allArmyListValue.battleEndTime);
        self:WriteInt32(allArmyListValue.totalTrainingTimes);
        self:WriteInt32(allArmyListValue.curTrainingTimes);
        self:WriteInt32(allArmyListValue.state);
    end
end

--@Override
function SyncAllArmy:_OnDeserialize() 
    
    local allArmyListCount = self:ReadInt32();
    for i = 1, allArmyListCount, 1 do 
        local allArmyListValue = SingleArmyInfo.new();
        allArmyListValue.card1 = self:ReadInt64();
        allArmyListValue.soldier1Count = self:ReadInt32();
        allArmyListValue.soldier1ConscriptionStartTime = self:ReadInt64();
        allArmyListValue.soldier1ConscriptionCount = self:ReadInt64();
        allArmyListValue.card2 = self:ReadInt64();
        allArmyListValue.soldier2Count = self:ReadInt32();
        allArmyListValue.soldier2ConscriptionStartTime = self:ReadInt64();
        allArmyListValue.soldier2ConscriptionCount = self:ReadInt64();
        allArmyListValue.card3 = self:ReadInt64();
        allArmyListValue.soldier3Count = self:ReadInt32();
        allArmyListValue.soldier3ConscriptionStartTime = self:ReadInt64();
        allArmyListValue.soldier3ConscriptionCount = self:ReadInt64();
        allArmyListValue.startTiled = self:ReadInt32();
        allArmyListValue.endTiled = self:ReadInt32();
        allArmyListValue.startTime = self:ReadInt64();
        allArmyListValue.endTime = self:ReadInt64();
        allArmyListValue.slotId = self:ReadInt32();
        allArmyListValue.spawnSlotId = self:ReadInt32();
        allArmyListValue.spawnBuilding = self:ReadInt64();
        allArmyListValue.tiledId = self:ReadInt32();
        allArmyListValue.curBuildingId = self:ReadInt64();
        allArmyListValue.farmmingStartTime = self:ReadInt64();
        allArmyListValue.farmmingEndTime = self:ReadInt64();
        allArmyListValue.trainingStartTime = self:ReadInt64();
        allArmyListValue.trainingEndTime = self:ReadInt64();
        allArmyListValue.battleStartTime = self:ReadInt64();
        allArmyListValue.battleEndTime = self:ReadInt64();
        allArmyListValue.totalTrainingTimes = self:ReadInt32();
        allArmyListValue.curTrainingTimes = self:ReadInt32();
        allArmyListValue.state = self:ReadInt32();
        self.allArmyList:Push(allArmyListValue);
    end
end

return SyncAllArmy;
