--
-- 客户端 --> 逻辑服务器
-- 部队练兵
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyTrainingMsg = class("ArmyTrainingMsg", GameMessage);

--
-- 构造函数
--
function ArmyTrainingMsg:ctor()
    ArmyTrainingMsg.super.ctor(self);
    --
    -- 建筑物Id
    --
    self.buildingId = 0;
    
    --
    -- 部队索引
    --
    self.index = 0;
    
    --
    -- 格子索引
    --
    self.tiledIndex = 0;
    
    --
    -- 练兵次数
    --
    self.trainingTimes = 0;
end

--@Override
function ArmyTrainingMsg:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);
    self:WriteInt32(self.tiledIndex);
    self:WriteInt32(self.trainingTimes);
end

--@Override
function ArmyTrainingMsg:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.index = self:ReadInt32();
    self.tiledIndex = self:ReadInt32();
    self.trainingTimes = self:ReadInt32();
end

return ArmyTrainingMsg;
