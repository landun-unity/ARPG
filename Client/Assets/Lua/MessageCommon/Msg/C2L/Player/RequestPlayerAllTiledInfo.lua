--
-- 客户端 --> 逻辑服务器
-- 请求领地Id
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestPlayerAllTiledInfo = class("RequestPlayerAllTiledInfo", GameMessage);

--
-- 构造函数
--
function RequestPlayerAllTiledInfo:ctor()
    RequestPlayerAllTiledInfo.super.ctor(self);
end

--@Override
function RequestPlayerAllTiledInfo:_OnSerial() 
end

--@Override
function RequestPlayerAllTiledInfo:_OnDeserialize() 
end

return RequestPlayerAllTiledInfo;
