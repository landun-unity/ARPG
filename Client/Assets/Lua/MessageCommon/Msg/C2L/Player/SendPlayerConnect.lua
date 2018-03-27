--
-- 客户端 --> 逻辑服务器
-- 同步服务器时间
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SendPlayerConnect = class("SendPlayerConnect", GameMessage);

--
-- 构造函数
--
function SendPlayerConnect:ctor()
    SendPlayerConnect.super.ctor(self);
end

--@Override
function SendPlayerConnect:_OnSerial() 
end

--@Override
function SendPlayerConnect:_OnDeserialize() 
end

return SendPlayerConnect;
