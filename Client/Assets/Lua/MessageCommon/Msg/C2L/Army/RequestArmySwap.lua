--
-- 客户端 --> 逻辑服务器
-- 部队调动
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestArmySwap = class("RequestArmySwap", GameMessage);

--
-- 构造函数
--
function RequestArmySwap:ctor()
    RequestArmySwap.super.ctor(self);
    --
    -- 玩家ID
    --
    self.playerId = 0;
    
    --
    -- 建筑物ID
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
function RequestArmySwap:_OnSerial() 
    self:WriteInt64(self.playerId);
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);
    self:WriteInt32(self.tiledIndex);
end

--@Override
function RequestArmySwap:_OnDeserialize() 
    self.playerId = self:ReadInt64();
    self.buildingId = self:ReadInt64();
    self.index = self:ReadInt32();
    self.tiledIndex = self:ReadInt32();
end

return RequestArmySwap;
