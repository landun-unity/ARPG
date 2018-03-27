--
-- 客户端 --> 逻辑服务器
-- 请求强征
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestForced = class("RequestForced", GameMessage);

--
-- 构造函数
--
function RequestForced:ctor()
    RequestForced.super.ctor(self);
end

--@Override
function RequestForced:_OnSerial() 
end

--@Override
function RequestForced:_OnDeserialize() 
end

return RequestForced;
