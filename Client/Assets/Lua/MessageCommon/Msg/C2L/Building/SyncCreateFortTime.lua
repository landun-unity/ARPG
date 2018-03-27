--
-- 客户端 --> 逻辑服务器
-- 同步创建要塞时间
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncCreateFortTime = class("SyncCreateFortTime", GameMessage);

--
-- 构造函数
--
function SyncCreateFortTime:ctor()
    SyncCreateFortTime.super.ctor(self);
end

--@Override
function SyncCreateFortTime:_OnSerial() 
end

--@Override
function SyncCreateFortTime:_OnDeserialize() 
end

return SyncCreateFortTime;
