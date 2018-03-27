--
-- 客户端 --> 逻辑服务器
-- 请求资源地消息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local GetSourceEvent = class("GetSourceEvent", GameMessage);

--
-- 构造函数
--
function GetSourceEvent:ctor()
    GetSourceEvent.super.ctor(self);
end

--@Override
function GetSourceEvent:_OnSerial() 
end

--@Override
function GetSourceEvent:_OnDeserialize() 
end

return GetSourceEvent;
