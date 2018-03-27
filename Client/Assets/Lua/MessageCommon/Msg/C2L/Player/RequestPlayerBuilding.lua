--
-- 客户端 --> 逻辑服务器
-- 请求建筑物同步信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestPlayerBuilding = class("RequestPlayerBuilding", GameMessage);

--
-- 构造函数
--
function RequestPlayerBuilding:ctor()
    RequestPlayerBuilding.super.ctor(self);
end

--@Override
function RequestPlayerBuilding:_OnSerial() 
end

--@Override
function RequestPlayerBuilding:_OnDeserialize() 
end

return RequestPlayerBuilding;
