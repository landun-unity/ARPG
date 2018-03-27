--
-- 客户端 --> 逻辑服务器
-- 请求玩家资源信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestResourceInfo = class("RequestResourceInfo", GameMessage);

--
-- 构造函数
--
function RequestResourceInfo:ctor()
    RequestResourceInfo.super.ctor(self);
end

--@Override
function RequestResourceInfo:_OnSerial() 
end

--@Override
function RequestResourceInfo:_OnDeserialize() 
end

return RequestResourceInfo;
