--
-- 逻辑服务器 --> 客户端
-- 同步单条线信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncOneLine = class("SyncOneLine", GameMessage);

--
-- 构造函数
--
function SyncOneLine:ctor()
    SyncOneLine.super.ctor(self);
    --
    -- 唯一ID
    --
    self.oId = 0;
    
    --
    -- 玩家ID
    --
    self.playerId = 0;
    
    --
    -- 产生部队的建筑物
    --
    self.spawnBuilding = 0;
    
    --
    -- 产生部队的槽位
    --
    self.spawnSlotId = 0;
    
    --
    -- 出发点横坐标
    --
    self.startCroodinateX = 0;
    
    --
    -- 出发点纵坐标
    --
    self.startCroodinateY = 0;
    
    --
    -- 目标点横坐标
    --
    self.targetCroodinateX = 0;
    
    --
    -- 目标点纵坐标
    --
    self.targetCroodinateY = 0;
end

--@Override
function SyncOneLine:_OnSerial() 
    self:WriteInt64(self.oId);
    self:WriteInt64(self.playerId);
    self:WriteInt64(self.spawnBuilding);
    self:WriteInt32(self.spawnSlotId);
    self:WriteInt32(self.startCroodinateX);
    self:WriteInt32(self.startCroodinateY);
    self:WriteInt32(self.targetCroodinateX);
    self:WriteInt32(self.targetCroodinateY);
end

--@Override
function SyncOneLine:_OnDeserialize() 
    self.oId = self:ReadInt64();
    self.playerId = self:ReadInt64();
    self.spawnBuilding = self:ReadInt64();
    self.spawnSlotId = self:ReadInt32();
    self.startCroodinateX = self:ReadInt32();
    self.startCroodinateY = self:ReadInt32();
    self.targetCroodinateX = self:ReadInt32();
    self.targetCroodinateY = self:ReadInt32();
end

return SyncOneLine;
