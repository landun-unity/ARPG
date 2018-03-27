--
-- 客户端 --> 逻辑服务器
-- 请求玉
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestJade = class("RequestJade", GameMessage);

--
-- 构造函数
--
function RequestJade:ctor()
    RequestJade.super.ctor(self);
end

--@Override
function RequestJade:_OnSerial() 
end

--@Override
function RequestJade:_OnDeserialize() 
end

return RequestJade;
