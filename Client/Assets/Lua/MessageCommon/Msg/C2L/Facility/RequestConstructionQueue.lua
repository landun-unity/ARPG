--
-- 客户端 --> 逻辑服务器
-- 请求所有的建造队列
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestConstructionQueue = class("RequestConstructionQueue", GameMessage);

--
-- 构造函数
--
function RequestConstructionQueue:ctor()
    RequestConstructionQueue.super.ctor(self);
end

--@Override
function RequestConstructionQueue:_OnSerial() 
end

--@Override
function RequestConstructionQueue:_OnDeserialize() 
end

return RequestConstructionQueue;
