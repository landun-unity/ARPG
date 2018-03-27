--
-- 客户端 --> 逻辑服务器
-- 请求领地Id
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestTiledIdInfo = class("RequestTiledIdInfo", GameMessage);

--
-- 构造函数
--
function RequestTiledIdInfo:ctor()
    RequestTiledIdInfo.super.ctor(self);
end

--@Override
function RequestTiledIdInfo:_OnSerial() 
end

--@Override
function RequestTiledIdInfo:_OnDeserialize() 
end

return RequestTiledIdInfo;
