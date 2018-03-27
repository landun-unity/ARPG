--
-- 客户端 --> 逻辑服务器
-- 部队撤退
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyRetreatingMsg = class("ArmyRetreatingMsg", GameMessage);

--
-- 构造函数
--
function ArmyRetreatingMsg:ctor()
    ArmyRetreatingMsg.super.ctor(self);
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
function ArmyRetreatingMsg:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);
end

--@Override
function ArmyRetreatingMsg:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.index = self:ReadInt32();
end

return ArmyRetreatingMsg;
