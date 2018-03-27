--
-- 客户端 --> 逻辑服务器
-- 请求建筑物信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestOccupyWildCity = class("RequestOccupyWildCity", GameMessage);

--
-- 构造函数
--
function RequestOccupyWildCity:ctor()
    RequestOccupyWildCity.super.ctor(self);
end

--@Override
function RequestOccupyWildCity:_OnSerial() 
end

--@Override
function RequestOccupyWildCity:_OnDeserialize() 
end

return RequestOccupyWildCity;
