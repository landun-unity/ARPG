--
-- 逻辑服务器 --> 客户端
-- 部队信息
-- @author czx
--
local SingleArmyInfo = require("MessageCommon/Msg/L2C/Army/SingleArmyInfo");

local GameMessage = require("common/Net/GameMessage");
local ArmyBaseInfo = class("ArmyBaseInfo", GameMessage);

--
-- 构造函数
--
function ArmyBaseInfo:ctor()
    ArmyBaseInfo.super.ctor(self);
    --
    -- 单个部队
    --
    self.army = SingleArmyInfo.new();
end

--@Override
function ArmyBaseInfo:_OnSerial() 
    self:WriteInt64(self.army.card1);
    self:WriteInt32(self.army.soldier1Count);
    self:WriteInt64(self.army.soldier1ConscriptionStartTime);
    self:WriteInt64(self.army.soldier1ConscriptionCount);
    self:WriteInt64(self.army.card2);
    self:WriteInt32(self.army.soldier2Count);
    self:WriteInt64(self.army.soldier2ConscriptionStartTime);
    self:WriteInt64(self.army.soldier2ConscriptionCount);
    self:WriteInt64(self.army.card3);
    self:WriteInt32(self.army.soldier3Count);
    self:WriteInt64(self.army.soldier3ConscriptionStartTime);
    self:WriteInt64(self.army.soldier3ConscriptionCount);
    self:WriteInt32(self.army.startTiled);
    self:WriteInt32(self.army.endTiled);
    self:WriteInt64(self.army.startTime);
    self:WriteInt64(self.army.endTime);
    self:WriteInt32(self.army.slotId);
    self:WriteInt32(self.army.spawnSlotId);
    self:WriteInt64(self.army.spawnBuilding);
    self:WriteInt32(self.army.tiledId);
    self:WriteInt64(self.army.curBuildingId);
    self:WriteInt64(self.army.farmmingStartTime);
    self:WriteInt64(self.army.farmmingEndTime);
    self:WriteInt64(self.army.trainingStartTime);
    self:WriteInt64(self.army.trainingEndTime);
    self:WriteInt64(self.army.battleStartTime);
    self:WriteInt64(self.army.battleEndTime);
    self:WriteInt32(self.army.totalTrainingTimes);
    self:WriteInt32(self.army.curTrainingTimes);
    self:WriteInt32(self.army.state);
end

--@Override
function ArmyBaseInfo:_OnDeserialize() 
    self.army.card1 = self:ReadInt64();
    self.army.soldier1Count = self:ReadInt32();
    self.army.soldier1ConscriptionStartTime = self:ReadInt64();
    self.army.soldier1ConscriptionCount = self:ReadInt64();
    self.army.card2 = self:ReadInt64();
    self.army.soldier2Count = self:ReadInt32();
    self.army.soldier2ConscriptionStartTime = self:ReadInt64();
    self.army.soldier2ConscriptionCount = self:ReadInt64();
    self.army.card3 = self:ReadInt64();
    self.army.soldier3Count = self:ReadInt32();
    self.army.soldier3ConscriptionStartTime = self:ReadInt64();
    self.army.soldier3ConscriptionCount = self:ReadInt64();
    self.army.startTiled = self:ReadInt32();
    self.army.endTiled = self:ReadInt32();
    self.army.startTime = self:ReadInt64();
    self.army.endTime = self:ReadInt64();
    self.army.slotId = self:ReadInt32();
    self.army.spawnSlotId = self:ReadInt32();
    self.army.spawnBuilding = self:ReadInt64();
    self.army.tiledId = self:ReadInt32();
    self.army.curBuildingId = self:ReadInt64();
    self.army.farmmingStartTime = self:ReadInt64();
    self.army.farmmingEndTime = self:ReadInt64();
    self.army.trainingStartTime = self:ReadInt64();
    self.army.trainingEndTime = self:ReadInt64();
    self.army.battleStartTime = self:ReadInt64();
    self.army.battleEndTime = self:ReadInt64();
    self.army.totalTrainingTimes = self:ReadInt32();
    self.army.curTrainingTimes = self:ReadInt32();
    self.army.state = self:ReadInt32();
end

return ArmyBaseInfo;
