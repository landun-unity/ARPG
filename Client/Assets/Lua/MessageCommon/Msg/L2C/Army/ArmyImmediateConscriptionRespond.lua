--
-- 逻辑服务器 --> 客户端
-- 部队征兵回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyImmediateConscriptionRespond = class("ArmyImmediateConscriptionRespond", GameMessage);

--
-- 构造函数
--
function ArmyImmediateConscriptionRespond:ctor()
    ArmyImmediateConscriptionRespond.super.ctor(self);
    --
    -- 建筑物id
    --
    self.buildingId = 0;
    
    --
    -- 部队索引
    --
    self.armyindex = 0;
    
    --
    -- 大营数量
    --
    self.backNowNum = 0;
    
    --
    -- 中军数量
    --
    self.middleNowNum = 0;
    
    --
    -- 前锋数量
    --
    self.frontNowNum = 0;
    
    --
    -- 所处建筑物id
    --
    self.curBuildingId = 0;
    
    --
    -- 所处建筑物预备兵数量
    --
    self.redifNum = 0;
end

--@Override
function ArmyImmediateConscriptionRespond:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.armyindex);
    self:WriteInt32(self.backNowNum);
    self:WriteInt32(self.middleNowNum);
    self:WriteInt32(self.frontNowNum);
    self:WriteInt64(self.curBuildingId);
    self:WriteInt32(self.redifNum);
end

--@Override
function ArmyImmediateConscriptionRespond:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.armyindex = self:ReadInt32();
    self.backNowNum = self:ReadInt32();
    self.middleNowNum = self:ReadInt32();
    self.frontNowNum = self:ReadInt32();
    self.curBuildingId = self:ReadInt64();
    self.redifNum = self:ReadInt32();
end

return ArmyImmediateConscriptionRespond;
