--
-- 客户端 --> 逻辑服务器
-- 部队撤退
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyRetreatingImmediately = class("ArmyRetreatingImmediately", GameMessage);

--
-- 构造函数
--
function ArmyRetreatingImmediately:ctor()
    ArmyRetreatingImmediately.super.ctor(self);
    --
    -- 建筑物Id
    --
    self.buildingId = 0;
    
    --
    -- 部队索引
    --
    self.index = 0;
end

--@Override
function ArmyRetreatingImmediately:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);
end

--@Override
function ArmyRetreatingImmediately:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.index = self:ReadInt32();
end

return ArmyRetreatingImmediately;
