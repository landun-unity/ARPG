--
-- 逻辑服务器 --> 客户端
-- 强征回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncForced = class("SyncForced", GameMessage);

--
-- 构造函数
--
function SyncForced:ctor()
    SyncForced.super.ctor(self);
    --
    -- 金币
    --
    self.gold = 0;
    
    --
    -- 时间
    --
    self.time = 0;
    
    --
    -- 次数
    --
    self.forcedCount = 0;
end

--@Override
function SyncForced:_OnSerial() 
    self:WriteInt64(self.gold);
    self:WriteInt64(self.time);
    self:WriteInt32(self.forcedCount);
end

--@Override
function SyncForced:_OnDeserialize() 
    self.gold = self:ReadInt64();
    self.time = self:ReadInt64();
    self.forcedCount = self:ReadInt32();
end

return SyncForced;
