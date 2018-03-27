--
-- 客户端 --> 逻辑服务器
-- 请求同步信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestSyncInfo = class("RequestSyncInfo", GameMessage);

--
-- 构造函数
--
function RequestSyncInfo:ctor()
    RequestSyncInfo.super.ctor(self);
end

--@Override
function RequestSyncInfo:_OnSerial() 
end

--@Override
function RequestSyncInfo:_OnDeserialize() 
end

return RequestSyncInfo;
