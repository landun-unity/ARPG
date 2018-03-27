--
-- 客户端 --> 逻辑服务器
-- 请求玩家势力值
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestPlayerInfluence = class("RequestPlayerInfluence", GameMessage);

--
-- 构造函数
--
function RequestPlayerInfluence:ctor()
    RequestPlayerInfluence.super.ctor(self);
end

--@Override
function RequestPlayerInfluence:_OnSerial() 
end

--@Override
function RequestPlayerInfluence:_OnDeserialize() 
end

return RequestPlayerInfluence;
