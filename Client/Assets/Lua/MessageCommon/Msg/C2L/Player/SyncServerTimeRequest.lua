--
-- 客户端 --> 逻辑服务器
-- 同步服务器时间
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncServerTimeRequest = class("SyncServerTimeRequest", GameMessage);

--
-- 构造函数
--
function SyncServerTimeRequest:ctor()
    SyncServerTimeRequest.super.ctor(self);
end

--@Override
function SyncServerTimeRequest:_OnSerial() 
end

--@Override
function SyncServerTimeRequest:_OnDeserialize() 
end

return SyncServerTimeRequest;
