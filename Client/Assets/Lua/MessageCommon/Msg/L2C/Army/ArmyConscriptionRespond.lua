--
-- 逻辑服务器 --> 客户端
-- 部队征兵回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyConscriptionRespond = class("ArmyConscriptionRespond", GameMessage);

--
-- 构造函数
--
function ArmyConscriptionRespond:ctor()
    ArmyConscriptionRespond.super.ctor(self);
    --
    -- 建筑物id
    --
    self.buildingId = 0;
    
    --
    -- 部队索引
    --
    self.index = 0;
    
    --
    -- 大营
    --
    self.backOverTime = 0;
    
    --
    -- 中军
    --
    self.middleOverTime = 0;
    
    --
    -- 前锋
    --
    self.frontOverTime = 0;
    
    --
    -- 大营征兵数量
    --
    self.backCspNum = 0;
    
    --
    -- 中军征兵数量
    --
    self.middleCspNum = 0;
    
    --
    -- 前锋征兵数量
    --
    self.frontCspNum = 0;
end

--@Override
function ArmyConscriptionRespond:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);
    self:WriteInt64(self.backOverTime);
    self:WriteInt64(self.middleOverTime);
    self:WriteInt64(self.frontOverTime);
    self:WriteInt32(self.backCspNum);
    self:WriteInt32(self.middleCspNum);
    self:WriteInt32(self.frontCspNum);
end

--@Override
function ArmyConscriptionRespond:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.index = self:ReadInt32();
    self.backOverTime = self:ReadInt64();
    self.middleOverTime = self:ReadInt64();
    self.frontOverTime = self:ReadInt64();
    self.backCspNum = self:ReadInt32();
    self.middleCspNum = self:ReadInt32();
    self.frontCspNum = self:ReadInt32();
end

return ArmyConscriptionRespond;
