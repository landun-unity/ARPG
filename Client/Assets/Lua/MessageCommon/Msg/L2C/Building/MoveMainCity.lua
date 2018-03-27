--
-- 逻辑服务器 --> 客户端
-- 迁移主城
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local MoveMainCity = class("MoveMainCity", GameMessage);

--
-- 构造函数
--
function MoveMainCity:ctor()
    MoveMainCity.super.ctor(self);
    --
    -- 建筑物Id
    --
    self.buildingId = 0;
    
    --
    -- 建筑物索引
    --
    self.index = 0;
end

--@Override
function MoveMainCity:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);
end

--@Override
function MoveMainCity:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.index = self:ReadInt32();
end

return MoveMainCity;
