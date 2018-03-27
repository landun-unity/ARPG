--
-- 客户端 --> 逻辑服务器
-- 请求土地耐久
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestTiledDurable = class("RequestTiledDurable", GameMessage);

--
-- 构造函数
--
function RequestTiledDurable:ctor()
    RequestTiledDurable.super.ctor(self);
end

--@Override
function RequestTiledDurable:_OnSerial() 
end

--@Override
function RequestTiledDurable:_OnDeserialize() 
end

return RequestTiledDurable;
