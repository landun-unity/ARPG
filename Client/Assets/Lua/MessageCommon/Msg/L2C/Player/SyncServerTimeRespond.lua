--
-- 逻辑服务器 --> 客户端
-- 同步服务器时间返回
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncServerTimeRespond = class("SyncServerTimeRespond", GameMessage);

--
-- 构造函数
--
function SyncServerTimeRespond:ctor()
    SyncServerTimeRespond.super.ctor(self);
    --
    -- 时间
    --
    self.time = 0;
end

--@Override
function SyncServerTimeRespond:_OnSerial() 
    self:WriteInt64(self.time);
end

--@Override
function SyncServerTimeRespond:_OnDeserialize() 
    self.time = self:ReadInt64();
end

return SyncServerTimeRespond;
