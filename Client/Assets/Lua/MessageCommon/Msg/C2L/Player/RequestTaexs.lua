--
-- 客户端 --> 逻辑服务器
-- 请求税收
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestTaexs = class("RequestTaexs", GameMessage);

--
-- 构造函数
--
function RequestTaexs:ctor()
    RequestTaexs.super.ctor(self);
end

--@Override
function RequestTaexs:_OnSerial() 
end

--@Override
function RequestTaexs:_OnDeserialize() 
end

return RequestTaexs;
