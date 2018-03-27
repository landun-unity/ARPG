--
-- 客户端 --> 逻辑服务器
-- 部队驻守
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyGarrisonMsg = class("ArmyGarrisonMsg", GameMessage);

--
-- 构造函数
--
function ArmyGarrisonMsg:ctor()
    ArmyGarrisonMsg.super.ctor(self);
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
end

--@Override
function ArmyGarrisonMsg:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);
    self:WriteInt32(self.tiledIndex);
end

--@Override
function ArmyGarrisonMsg:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.index = self:ReadInt32();
    self.tiledIndex = self:ReadInt32();
end

return ArmyGarrisonMsg;
