--
-- 客户端 --> 逻辑服务器
-- 拆除要塞
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RemoveFort = class("RemoveFort", GameMessage);

--
-- 构造函数
--
function RemoveFort:ctor()
    RemoveFort.super.ctor(self);
    --
    -- 建筑物ID
    --
    self.buildingId = 0;
    
    --
    -- 格子索引
    --
    self.index = 0;
end

--@Override
function RemoveFort:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);
end

--@Override
function RemoveFort:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.index = self:ReadInt32();
end

return RemoveFort;
