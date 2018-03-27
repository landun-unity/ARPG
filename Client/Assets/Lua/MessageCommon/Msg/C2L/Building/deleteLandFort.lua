--
-- 客户端 --> 逻辑服务器
-- 要塞升级请求
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local deleteLandFort = class("deleteLandFort", GameMessage);

--
-- 构造函数
--
function deleteLandFort:ctor()
    deleteLandFort.super.ctor(self);
    --
    -- 建筑物ID
    --
    self.buildingId = 0;
    
    --
    -- 格子Id
    --
    self.tiledIndex = 0;
end

--@Override
function deleteLandFort:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.tiledIndex);
end

--@Override
function deleteLandFort:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.tiledIndex = self:ReadInt32();
end

return deleteLandFort;
