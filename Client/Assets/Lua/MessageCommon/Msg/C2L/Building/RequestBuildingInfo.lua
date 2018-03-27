--
-- 客户端 --> 逻辑服务器
-- 请求建筑物信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestBuildingInfo = class("RequestBuildingInfo", GameMessage);

--
-- 构造函数
--
function RequestBuildingInfo:ctor()
    RequestBuildingInfo.super.ctor(self);
end

--@Override
function RequestBuildingInfo:_OnSerial() 
end

--@Override
function RequestBuildingInfo:_OnDeserialize() 
end

return RequestBuildingInfo;
