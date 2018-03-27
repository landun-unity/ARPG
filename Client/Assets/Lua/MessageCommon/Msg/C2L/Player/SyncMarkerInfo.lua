--
-- 客户端 --> 逻辑服务器
-- 同步服务器时间
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncMarkerInfo = class("SyncMarkerInfo", GameMessage);

--
-- 构造函数
--
function SyncMarkerInfo:ctor()
    SyncMarkerInfo.super.ctor(self);
end

--@Override
function SyncMarkerInfo:_OnSerial() 
end

--@Override
function SyncMarkerInfo:_OnDeserialize() 
end

return SyncMarkerInfo;
