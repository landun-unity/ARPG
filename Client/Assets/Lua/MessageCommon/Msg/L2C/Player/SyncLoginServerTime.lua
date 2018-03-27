--
-- 逻辑服务器 --> 客户端
-- 循环同步服务器时间
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncLoginServerTime = class("SyncLoginServerTime", GameMessage);

--
-- 构造函数
--
function SyncLoginServerTime:ctor()
    SyncLoginServerTime.super.ctor(self);
    --
    -- 时间
    --
    self.time = 0;
end

--@Override
function SyncLoginServerTime:_OnSerial() 
    self:WriteInt64(self.time);
end

--@Override
function SyncLoginServerTime:_OnDeserialize() 
    self.time = self:ReadInt64();
end

return SyncLoginServerTime;
