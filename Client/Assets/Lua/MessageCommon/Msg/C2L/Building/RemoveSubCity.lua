--
-- 客户端 --> 逻辑服务器
-- 拆除分城
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RemoveSubCity = class("RemoveSubCity", GameMessage);

--
-- 构造函数
--
function RemoveSubCity:ctor()
    RemoveSubCity.super.ctor(self);
    --
    -- 建筑物ID
    --
    self.buildingId = 0;
end

--@Override
function RemoveSubCity:_OnSerial() 
    self:WriteInt64(self.buildingId);
end

--@Override
function RemoveSubCity:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
end

return RemoveSubCity;
