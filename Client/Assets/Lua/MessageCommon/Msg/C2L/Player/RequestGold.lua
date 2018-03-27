--
-- 客户端 --> 逻辑服务器
-- 请求金币玉符
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestGold = class("RequestGold", GameMessage);

--
-- 构造函数
--
function RequestGold:ctor()
    RequestGold.super.ctor(self);
end

--@Override
function RequestGold:_OnSerial() 
end

--@Override
function RequestGold:_OnDeserialize() 
end

return RequestGold;
